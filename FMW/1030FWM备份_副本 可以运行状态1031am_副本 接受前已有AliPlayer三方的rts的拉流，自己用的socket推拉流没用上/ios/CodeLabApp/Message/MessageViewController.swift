//
//  MessageViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/17.
//

import Foundation
import BasicUIKit
import UIKit
import BasicKit
import SnapKit
import PageControls
import YYImage
import AVFoundation
import VideoPlayerKit
import HyphenateChat
import APIKit
import Alamofire

final class MessageViewController: TableViewController {
    
    deinit {
        EMClient.shared().chatManager?.remove(self)
    }
    
    fileprivate let dataDispatchSource = DispatchSourceData(type: .replace, queue: DispatchQueue.main)
    fileprivate let dataQueue = DispatchQueue(label: "com.fmw.make.im.session")
    
    fileprivate var sessions = [IMSessionItem]()
    fileprivate var profileMap = [String: UserProfile]()
    fileprivate var isSyncingProfileUsers = Set<String>()
    
    override func viewDidLoad() {
        showRefreshHeader = false
        showLoadMoreFooter = false
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "消息"
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIManager.shared.screenWidth, height: 158)).then {
            $0.backgroundColor = .white
        }
        
        tableView?.tableHeaderView = headerView
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        tableView?.register(cellWithClass: MessageTableViewCell.self)
        tableView?.snp.makeConstraints({ make in
            make.top.equalTo(customBar.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        })
        
        let _ = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            headerView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(10)
                make.bottom.equalTo(-20)
            }
        }
        
        let commentView = UIButton().then {
            $0.setImage(UIImage(named: "ge_icon_message_comment"), for: .normal)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -30, right: 0)
            $0.addAction(UIAction() {_ in
                UIManager.push(to: NoticeCommentViewController())
            }, for: .touchUpInside)
            headerView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(60)
                make.left.equalTo(38)
                make.top.equalTo(20)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "评论转发"
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textColor = color(0, 0, 0, 0.5)
            headerView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(commentView)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(20)
                make.top.equalTo(commentView.snp.bottom).offset(8)
            }
        }
        
        let commentRedDot = RedDot().then {
            $0.value = .dot((AppContext.current.userContext?.unreadCommentNoticeCount).nonnull)
            headerView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(10)
                make.top.equalTo(commentView).offset(0)
                make.right.equalTo(commentView).offset(-5)
            }
        }
        
        let userView = UIButton().then {
            $0.setImage(UIImage(named: "ge_icon_message_user"), for: .normal)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -30, right: 0)
            $0.addAction(UIAction() {_ in
                UIManager.push(to: NoticeRelationViewController())
            }, for: .touchUpInside)
            headerView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(60)
                make.centerX.equalToSuperview()
                make.top.equalTo(commentView)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "新增关注"
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textColor = color(0, 0, 0, 0.5)
            headerView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(userView)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(20)
                make.top.equalTo(userView.snp.bottom).offset(8)
            }
        }
        
        let userRedDot = RedDot().then {
            $0.value = .dot((AppContext.current.userContext?.unreadFollowNoticeCount).nonnull)
            headerView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(10)
                make.top.equalTo(userView).offset(0)
                make.right.equalTo(userView).offset(-5)
            }
        }
        
        let likeView = UIButton().then {
            $0.setImage(UIImage(named: "ge_icon_message_like"), for: .normal)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -30, right: 0)
            $0.contentMode = .scaleAspectFit
            $0.addAction(UIAction() {_ in
                UIManager.push(to: NoticeLikeViewController())
            }, for: .touchUpInside)
            headerView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(60)
                make.right.equalTo(-38)
                make.top.equalTo(commentView)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "赞和收藏"
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textColor = color(0, 0, 0, 0.5)
            headerView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(likeView)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(20)
                make.top.equalTo(likeView.snp.bottom).offset(8)
            }
        }
        
        let likeRedDot = RedDot().then {
            $0.value = .dot((AppContext.current.userContext?.unreadLikeNoticeCount).nonnull)
            headerView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(10)
                make.top.equalTo(likeView).offset(0)
                make.right.equalTo(likeView).offset(-5)
            }
        }
        
        IMClient.shared.$imStatus.receive(on: RunLoop.main).sink {[unowned self] result in
            switch result {
            case .failed:
                customBarTitleLabel.text = "消息(连接失败)"
            case .linking:
                customBarTitleLabel.text = "消息(连接中...)"
            case .syncing:
                customBarTitleLabel.text = "消息(收取中...)"
            default:
                customBarTitleLabel.text = "消息"
            }
        }.store(in: &cancellableList)
        
        AppContext.current.userContext?.$unreadCommentNoticeCount.sink(receiveValue: { result in
            commentRedDot.value = .dot(result)
        }).store(in: &cancellableList)
        
        AppContext.current.userContext?.$unreadFollowNoticeCount.sink(receiveValue: { result in
            userRedDot.value = .dot(result)
        }).store(in: &cancellableList)
        
        AppContext.current.userContext?.$unreadLikeNoticeCount.sink(receiveValue: { result in
            likeRedDot.value = .dot(result)
        }).store(in: &cancellableList)
        
        AppContext.current.userContext?.$unreadSystemNoticeCount.sink(receiveValue: {[weak self] _ in
            self?.tableView?.reloadData()
        }).store(in: &cancellableList)
        
        EMClient.shared().chatManager?.add(self, delegateQueue: dataQueue)
        dataQueue.async {[weak self] in
            if let conversations = EMClient.shared().chatManager?.getAllConversations(true) {
                for item in conversations {
                    self?.sessions.append(item.sessionItem)
                }
                self?.reloadTableView()
            }
        }
        
        NotificationCenter.default.publisher(for: .notificationIMMessageWillSend).sink {[weak self] obj in
            self?.dataQueue.async {
                guard let strongSelf = self, let messageItem = obj.object as? IMMessageItem,
                      let sessionItem = strongSelf.sessions.first(where: { $0.chatWith == messageItem.chatWith }) else { return }
                sessionItem.lastMessage = messageItem
                sessionItem.updateTime = messageItem.createTime
                strongSelf.sessions = strongSelf.sessions.sorted { im1, im2 in
                    return im1.updateTime >= im2.updateTime
                }
                strongSelf.reloadTableView()
            }
        }.store(in: &cancellableList)
        
        AppContext.current.userContext?.systemNoticeMessage.publisher.sink {[weak self] _ in
            self?.reloadTableView()
        }.store(in: &cancellableList)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppContext.current.userContext?.refreshUnread()
    }
    
    fileprivate func syncUserProfileFor(userID: String) {
        guard !isSyncingProfileUsers.contains(userID) else { return }
        isSyncingProfileUsers.insert(userID)
        
        Network.request(UserAPI.userInfo.rawValue + userID, encoding: URLEncoding.default).responseData {[weak self] response in
            guard let strongSelf = self else { return }
            strongSelf.isSyncingProfileUsers.remove(userID)
            
            if response.error == nil, let data = response.data?.jsonData(), let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
                strongSelf.profileMap[userID] = profile
                
                if let cells = strongSelf.tableView?.visibleCells.compactMap({ $0 as? MessageTableViewCell }) {
                    for cell in cells {
                        if cell.sessionItem?.chatWith == profile.userInfo?.userID {
                            cell.avatarView.setWebImage(url: OSSUploader.avatarURLFor((profile.userInfo?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
                            cell.titleLabel.text = profile.userInfo?.userName
                        }
                    }
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sessions.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MessageTableViewCell.self)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .white
        
        if indexPath.section == 0 { //系统消息
            cell.avatarView.image = UIImage(named: "ge_icon_message_system")
            cell.titleLabel.text = "系统消息"
            cell.timeLabel.text = (AppContext.current.userContext?.systemMessageTimestamp).nonnull > 0 ? Date(timeIntervalSince1970: (AppContext.current.userContext?.systemMessageTimestamp).nonnull/1000.0).displayString() : "刚刚"
            cell.contentLabel.text = (AppContext.current.userContext?.systemNoticeMessage).nonnull.isEmpty ? "暂无消息" : AppContext.current.userContext?.systemNoticeMessage
            cell.redDot.value = .dot((AppContext.current.userContext?.unreadSystemNoticeCount).nonnull)
            cell.sessionItem = nil
        } else if let sessionItem = sessions[safe: indexPath.section - 1] {
            cell.sessionItem = sessionItem
            cell.timeLabel.text = Date(timeIntervalSince1970: Double(sessionItem.updateTime)/1000.0).displayString()
            cell.contentLabel.text = sessionItem.lastMessage?.lastTextDesc
            cell.redDot.value = .dot(Int(sessionItem.unreadCount))
            
            if let user = profileMap[sessionItem.chatWith] {
                cell.avatarView.setWebImage(url: OSSUploader.avatarURLFor((user.userInfo?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
                cell.titleLabel.text = user.userInfo?.userName
            } else {
                syncUserProfileFor(userID: sessionItem.chatWith)
                cell.avatarView.image = nil
                cell.titleLabel.text = nil
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            UIManager.push(to: SystemNoticeViewController())
        } else if let session = sessions[safe: indexPath.section - 1] {
            session.unreadCount = 0
            UIManager.push(to: ChatViewController().then { $0.chatWith = session.chatWith })
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section < 1 { return nil }
        
        let deleteAction = UIContextualAction.init(style: .destructive, title: "删除") {[unowned self] _,_,completionHandler in
            if let item = sessions[safe: indexPath.section - 1] {
                IMClient.shared.deleteSession(item)
                sessions.removeAll(where: { $0.chatWith == item.chatWith })
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                completionHandler(true)
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction]).then { $0.performsFirstActionWithFullSwipe = false }
    }
}

fileprivate class MessageTableViewCell: UITableViewCell {
    lazy var avatarView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTap)))
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalToSuperview()
            make.width.height.equalTo(52)
        }
    }
    
    lazy var titleLabel = UILabel().then {
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTap)))
        $0.textColor = .black
        $0.font = .mediumPingFangSCFont(ofSize: 16)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(10)
            make.top.equalTo(avatarView).offset(3)
            make.right.lessThanOrEqualTo(-100)
            make.height.equalTo(22)
        }
    }
    
    lazy var contentLabel = UILabel().then {
        $0.textColor = color(0, 0, 0, 0.4)
        $0.font = .regularPingFangSCFont(ofSize: 14)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.right.lessThanOrEqualTo(-20)
            make.height.equalTo(20)
        }
    }
    
    lazy var timeLabel = UILabel().then {
        $0.textColor = color(0, 0, 0, 0.3)
        $0.font = .regularPingFangSCFont(ofSize: 12)
        $0.textAlignment = .right
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalTo(titleLabel)
            make.width.lessThanOrEqualTo(100)
            make.height.equalTo(17)
        }
    }
    
    lazy var redDot = RedDot().then {
        $0.value = .dot(0)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(10)
            make.top.equalTo(avatarView).offset(0)
            make.right.equalTo(avatarView).offset(-5)
        }
    }
    
    var sessionItem: IMSessionItem?
    @objc private func userTap() {
        guard let sessionItem = sessionItem else {
            UIManager.push(to: SystemNoticeViewController())
            return
        }
        UIManager.push(to: UserViewController().then { $0.userID = sessionItem.chatWith})
    }
}

extension MessageViewController: EMChatManagerDelegate {
    func reloadTableView() {
        dataDispatchSource.semaphore {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView?.reloadData()
        }
    }
    
    func conversationListDidUpdate(_ aConversationList: [EMConversation]) {
        if aConversationList.count < sessions.count { return }
        
        sessions.removeAll()
        for item in aConversationList {
            sessions.append(item.sessionItem)
        }
        sessions = sessions.sorted { im1, im2 in
            return im1.updateTime >= im2.updateTime
        }
        reloadTableView()
    }
    
    func messagesDidReceive(_ aMessages: [EMChatMessage]) {
        guard let message = aMessages.last, let sessionItem = sessions.first(where: { $0.chatWith == message.conversationId }) else { return }
        sessionItem.lastMessage = message.wrapToIMMessageItem
        sessionItem.updateTime = message.timestamp
        sessionItem.unreadCount += Int32(aMessages.count)
        sessions = sessions.sorted { im1, im2 in
            return im1.updateTime >= im2.updateTime
        }
        reloadTableView()
    }
}
