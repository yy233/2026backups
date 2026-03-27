//
//  ChatViewController.swift
//  Genz
//
//  Created by Sera on 2021/5/12.
//

import Foundation
import SnapKit
import UIKit
import Photos
import BasicKit
import BasicUIKit
import APIKit
import Alamofire
import HyphenateChat
import AlbumUIKit

class ChatViewController: TableViewController {
    
    var chatWith: String = ""
    
    let dataDispatchSource = DispatchSourceData(type: .replace, queue: DispatchQueue.main)
    let scrollDispatchSource = DispatchSourceData(type: .replace, queue: DispatchQueue.main)
    
    var scrollIndexPath: IndexPath?
    var scrollAnimated: Bool = false
    
    deinit {
        EMClient.shared().chatManager?.remove(self)
    }
    
    fileprivate var profileMap = [String: UserProfile]()
    fileprivate var isSyncingProfileUsers = Set<String>()

    lazy var pannelView = ChatPannelView(frame: .zero).then {
        $0.backgroundColor = .clear
        $0.didSubmitTextHandler = {[unowned self] text in
            sendTextMessage(content: text)
        }
        $0.didSubmitAssetsHandler = {[unowned self] assets in
            sendMediaMessage(assets: assets)
        }
        $0.didKeyboardChangeFrameHandler = {[unowned self] in
            scrollAnimated = true
            scrollToLastMessage()
        }
    }
    
    override func viewDidLoad() {
        showLoadMoreFooter = false
        showRefreshHeader = true
        triggerRefreshAutomatic = true
        let viewModel = ChatViewModel()
        viewModel.chatWith = chatWith
        self.viewModel = viewModel
        super.viewDidLoad()
        view.backgroundColor = color(245, 245, 245)
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        EMClient.shared().chatManager?.add(self, delegateQueue: DispatchQueue.main)

        if let conversation = EMClient.shared().chatManager?.getConversationWithConvId(chatWith) {
            conversation.markAllMessages(asRead: nil)
        }
        
        view.addSubview(pannelView)
        pannelView.snp.makeConstraints { make in
            make.top.left.width.height.equalToSuperview()
        }
        
        if let tableView = tableView {
            tableView.backgroundColor = view.backgroundColor
            tableView.register(cellWithClass: ChatTextMessageTableViewCell.self)
            tableView.register(cellWithClass: ChatImageMessageTableViewCell.self)
            tableView.register(cellWithClass: ChatVideoMessageTableViewCell.self)
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIManager.shared.screenWidth, height: 20))

            //键盘弹起，滚动视图
            tableView.snp.makeConstraints { make in
                make.top.equalTo(customBar.snp.bottom)
                make.left.right.equalToSuperview()
                make.bottom.equalTo(pannelView.inputBar.snp.top)
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(sender:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        view.bringSubviewToFront(pannelView)
        
        viewModelDidFinishLoad = {[weak self] _ in
            guard let strongSelf = self, let response = strongSelf.viewModel?.response else { return }
            strongSelf.tableView?.mj_header?.endRefreshing()
            strongSelf.tableView?.reloadData()
            
            if response.isLoadingMore, response.newCount > 0 {
                strongSelf.scrollIndexPath = IndexPath(row: 0, section: response.newCount - 1)
                strongSelf.scrollToIndexPathForMessage()
            }
        }
            
        NotificationCenter.default.publisher(for: .notificationIMMessageStatusUpdate).sink {[weak self] obj in
            guard let strongSelf = self, let obj = obj.object as? ChatMessageItem, obj.target?.chatWith == strongSelf.chatWith else { return }
            if let _ = strongSelf.viewModel?.element(for: obj.messageID) {
                strongSelf.reloadTableView()
            }
        }.store(in: &cancellableList)
        
        refreshUser()
    }
    
    private func refreshUser() {
        Network.request(UserAPI.userInfo.rawValue + chatWith, encoding: URLEncoding.default).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let data = response.data?.jsonData(), let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
                self.profileMap[self.chatWith] = profile
                self.customBarTitleLabel.text = profile.userInfo?.userName
            }
        }
    }
    
    //MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let element = viewModel?.element(at: indexPath.section) as? ChatMessageItem else {
            return CGFloat.leastNormalMagnitude
        }
        return element.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let element = viewModel?.element(at: indexPath.section) as? ChatMessageItem else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        var tableCell: ChatBaseMessageTableViewCell?
        
        if let _ = element as? ChatTextMessageItem {
            tableCell = tableView.dequeueReusableCell(withClass: ChatTextMessageTableViewCell.self, for: indexPath)
        } else if let _ = element as? ChatImageMessageItem {
            tableCell = tableView.dequeueReusableCell(withClass: ChatImageMessageTableViewCell.self, for: indexPath)
        } else if let _ = element as? ChatVideoMessageItem {
            tableCell = tableView.dequeueReusableCell(withClass: ChatVideoMessageTableViewCell.self, for: indexPath)
        }
        
        tableCell?.contentView.backgroundColor = view.backgroundColor
        tableCell?.bindModel(element)
        
        let userID = (element.target?.from).nonnull
        if let profile = profileMap[userID] {
            tableCell?.avatarBtn.setWebImage(url: OSSUploader.avatarURLFor((profile.userInfo?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
        } else {
            syncUserProfileFor(userID: userID)
        }
        
        tableCell?.showMenuPressHandler = {[weak tableCell, weak self]_ in
            guard let messageItem = tableCell?.messageItem, let target = messageItem.target, let strongSelf = self else { return }
            ActionSheet.show(titles: ["删除消息"]) { index in
                strongSelf.viewModel?.remove(messageItem)
                strongSelf.reloadTableView()
                IMClient.shared.deleteMessage(target, messageItem: messageItem)
            }
        }
        
        return tableCell ?? super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func scrollToIndexPathForMessage() {
        scrollDispatchSource.semaphore {[weak self] in
            guard let strongSelf = self, (strongSelf.tableView?.numberOfSections).nonnull > 0 else { return }
            let indexPath = strongSelf.scrollIndexPath ?? IndexPath(row: 0, section: (strongSelf.tableView?.numberOfSections).nonnull - 1)
            let cellRect = strongSelf.tableView?.rectForRow(at: indexPath)
            let maximumOffsetY = (strongSelf.tableView?.contentSize.height).nonnull - (strongSelf.tableView?.bounds.height).nonnull
            
            if maximumOffsetY > 0 {
                if (cellRect?.origin.y).nonnull > maximumOffsetY {
                    if strongSelf.scrollAnimated {
                        UIView.animate(withDuration: 0.2) {
                            strongSelf.tableView?.setContentOffset(CGPoint(x: (strongSelf.tableView?.contentOffset.x).nonnull, y: maximumOffsetY), animated: false)
                        }
                    }
                    else {
                        strongSelf.tableView?.setContentOffset(CGPoint(x: (strongSelf.tableView?.contentOffset.x).nonnull, y: maximumOffsetY), animated: false)
                    }
                }
                else {
                    if strongSelf.scrollAnimated {
                        UIView.animate(withDuration: 0.2) {
                            strongSelf.tableView?.setContentOffset(CGPoint(x: (strongSelf.tableView?.contentOffset.x).nonnull, y: (cellRect?.origin.y).nonnull - (strongSelf.tableView?.adjustedContentInset.top).nonnull), animated: false)
                        }
                    }
                    else {
                        strongSelf.tableView?.setContentOffset(CGPoint(x: (strongSelf.tableView?.contentOffset.x).nonnull, y: (cellRect?.origin.y).nonnull - (strongSelf.tableView?.adjustedContentInset.top).nonnull), animated: false)
                    }
                }
            }
            
            strongSelf.scrollIndexPath = nil
        }
    }
    
    func syncUserProfileFor(userID: String) {
        guard !isSyncingProfileUsers.contains(userID) else { return }
        isSyncingProfileUsers.insert(userID)
        
        Network.request(UserAPI.userInfo.rawValue + userID, encoding: URLEncoding.default).responseData {[weak self] response in
            guard let strongSelf = self else { return }
            strongSelf.isSyncingProfileUsers.remove(userID)
            
            if response.error == nil, let data = response.data?.jsonData(), let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
                strongSelf.profileMap[userID] = profile
                
                if let cells = strongSelf.tableView?.visibleCells.compactMap({ $0 as? ChatBaseMessageTableViewCell }) {
                    for cell in cells {
                        if cell.messageItem?.target?.from == profile.userInfo?.userID {
                            cell.avatarBtn.setWebImage(url: OSSUploader.avatarURLFor((profile.userInfo?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
                        }
                    }
                }
            }
        }
    }
}

extension ChatViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.location(in: view).y >= pannelView.inputBar.top {
            return false
        }
        return true
    }
    
    @objc func tapGestureHandler(sender: UITapGestureRecognizer) {
        if pannelView.inputBar.top > sender.location(in: view).y {
            pannelView.resetPannelToInitilize()
        }
    }
}

extension ChatViewController: EMChatManagerDelegate {
    func messagesDidReceive(_ aMessages: [EMChatMessage]) {
        for message in aMessages {
            viewModel?.append(message.wrapToIMMessageItem.wrapViewMessageItem())
        }
        reloadTableView()
    }
}

//MARK: - 发送
extension ChatViewController {
    fileprivate func sendTextMessage(content: String) {
        let textMessageItem = ChatTextMessageItem()
        textMessageItem.from = .myself
        textMessageItem.timestamp = Int64(Date().timeIntervalSince1970*1000)
        textMessageItem.content = content
        textMessageItem.target = textMessageItem.wrapSendingMessage(chatType: .single, chatWith: chatWith)
        textMessageItem.target?.sdkMessage = textMessageItem.target?.generateSDKMessage()
        textMessageItem.messageID = (textMessageItem.target?.messageID).nonnull
        
        viewModel?.append(textMessageItem)
        reloadTableView()
        IMClient.shared.sendTextMessage(messageItem: textMessageItem)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.scrollAnimated = true
            self.scrollToLastMessage()
        }
        
        NotificationCenter.default.post(name: .notificationIMMessageWillSend, object: textMessageItem.target)
    }
    
    fileprivate func sendMediaMessage(assets: [PHAsset]) {
        if let asset = assets.first, asset.elementType == .video {
            let videoMessageItem = ChatVideoMessageItem()
            videoMessageItem.from = .myself
            videoMessageItem.timestamp = Int64(Date().timeIntervalSince1970*1000)
            videoMessageItem.imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            videoMessageItem.hasPlayed = true
            videoMessageItem.duration = Int32(asset.duration)
            videoMessageItem.videoCacheName = LocalFileContext.generateFileName(for: .video)
            videoMessageItem.target = videoMessageItem.wrapSendingMessage(chatType: .single, chatWith: self.chatWith)
            videoMessageItem.target?.sdkMessage = videoMessageItem.target?.generateSDKMessage()
            videoMessageItem.messageID = (videoMessageItem.target?.messageID).nonnull
            
            AlbumAssetsContext.fetchVideo(for: asset) { result,_ in
                if let result = result as? AVURLAsset {
                    let filePath = videoMessageItem.filePath
                    do {
                        try FileManager.default.copyItem(atPath: result.url.path, toPath: filePath)
                        
                        AlbumAssetsContext.fetchImage(for: asset, resolution: .detail) { image,_ in
                            if let image = image {
                                let filePath = videoMessageItem.imagePath
                                if FileManager.default.createFile(atPath: filePath, contents: image.jpegData(compressionQuality: 1.0), attributes: nil) {
                                    DispatchQueue.main.async {
                                        self.viewModel?.append(videoMessageItem)
                                        self.reloadTableView()
                                        IMClient.shared.sendVideoMessage(messageItem: videoMessageItem)
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            self.scrollAnimated = true
                                            self.scrollToLastMessage()
                                        }
                                        
                                        NotificationCenter.default.post(name: .notificationIMMessageWillSend, object: videoMessageItem.target)
                                    }
                                }
                            }
                        }
                    } catch {
                        dPrint("视频消息发送失败" + error.localizedDescription)
                    }
                }
            }
        } else {
            DispatchQueue.global().async {
                var appendItems = [ChatImageMessageItem]()
                for item in assets {
                    let imageMessageItem = ChatImageMessageItem()
                    imageMessageItem.from = .myself
                    imageMessageItem.imageSize = CGSize(width: item.pixelWidth, height: item.pixelHeight)
                    imageMessageItem.timestamp = Int64(Date().timeIntervalSince1970*1000)
                    imageMessageItem.imageCacheName = LocalFileContext.generateFileName(for: .image)
                    imageMessageItem.target = imageMessageItem.wrapSendingMessage(chatType: .single, chatWith: self.chatWith)
                    imageMessageItem.target?.sdkMessage = imageMessageItem.target?.generateSDKMessage()
                    imageMessageItem.messageID = (imageMessageItem.target?.messageID).nonnull

                    AlbumAssetsContext.fetchImage(for: item, resolution: .detail, isSynchrous: true, progressHandler: nil) { image,_ in
                        if let image = image {
                            let filePath = imageMessageItem.filePath
                            if FileManager.default.createFile(atPath: filePath, contents: image.jpegData(compressionQuality: 1.0), attributes: nil) {
                                appendItems.append(imageMessageItem)
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    appendItems.forEach { self.viewModel?.append($0) }
                    self.reloadTableView()
                    IMClient.shared.sendImageMessage(messageItems: appendItems)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.scrollAnimated = true
                        self.scrollToLastMessage()
                    }
                    
                    NotificationCenter.default.post(name: .notificationIMMessageWillSend, object: appendItems.last?.target)
                }
            }
        }
    }
}

//MARK: - refreash
extension ChatViewController {
    func reloadTableView() {
        dataDispatchSource.semaphore {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView?.reloadData()
        }
    }
    
    func scrollToLastMessage() {
        scrollDispatchSource.semaphore {[weak self] in
            guard let strongSelf = self, (strongSelf.tableView?.numberOfSections).nonnull > 0 else { return }
            let maximumOffsetY = (strongSelf.tableView?.contentSize.height).nonnull - (strongSelf.tableView?.bounds.height).nonnull
            if maximumOffsetY > 0 {
                UIView.animate(withDuration: strongSelf.scrollAnimated ? 0.2 : 0.01) {
                    strongSelf.tableView?.setContentOffset(CGPoint(x: (strongSelf.tableView?.contentOffset.x).nonnull, y: maximumOffsetY), animated: false)
                }
            }
        }
    }
}

fileprivate class ChatViewModel: DataLoadViewModel {
    var chatWith: String = ""
    var latestMessageId: String?
    var pageSize: Int32 = 100
    
    //IM内刷新与加载更多是相反的
    override func refresh(shouldLoadCache: Bool) {
        if let conversation = EMClient.shared().chatManager?.getConversationWithConvId(chatWith) {
            conversation.loadMessagesStart(fromId: latestMessageId, count: pageSize, searchDirection: .up) {[weak self] list, error in
                if let error = error {
                    Toast.toast(title: error.errorDescription)
                    self?.response = ViewModelResponse(isCache: false, isLoadingMore: true, hasMore: false, newCount: 0, error: error as? Error)
                } else if let list = list, !list.isEmpty {
                    var count = 0
                    if self?.latestMessageId != nil {
                        for message in list.reversed() {
                            let item = message.wrapToIMMessageItem.wrapViewMessageItem()
                            if self?.element(for: item.messageID) == nil {
                                count += 1
                                self?.insert(item, at: 0)
                            }
                        }
                    } else {
                        for message in list {
                            let item = message.wrapToIMMessageItem.wrapViewMessageItem()
                            if self?.element(for: item.messageID) == nil {
                                count += 1
                                self?.append(item)
                            }
                        }
                    }

                    self?.latestMessageId = list.first?.messageId
                    self?.response = ViewModelResponse(isCache: false, isLoadingMore: true, hasMore: false, newCount: count, error: nil)
                } else {
                    self?.response = ViewModelResponse(isCache: false, isLoadingMore: true, hasMore: false, newCount: 0, error: nil)
                }
            }
        }
    }
}
