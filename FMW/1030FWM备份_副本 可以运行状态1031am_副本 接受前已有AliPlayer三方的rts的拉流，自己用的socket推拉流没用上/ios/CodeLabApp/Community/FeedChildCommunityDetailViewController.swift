//
//  FeedChildCommunityDetailViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/8/30.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import YYImage
import Combine
import CodeLabUnityBridge
import APIKit
import VideoPlayerKit

final class FeedChildCommunityDetailViewController: SegmentViewController {
    
    private let backgorundView = UIImageView()
    private let avatarView = UIImageView()
    private let nameLabel = UILabel()
    private let descLabel = UILabel()
    private let managerAvatarView = UIImageView()
    private let managerLabel = UIButton()
    private let topBtn = UIButton()
    private let topFeedLabel = UIButton()
    private let broadcastBtn = UIButton()
    private let broadcastLabel = UIButton()
    private let followBtn = UIButton()
    
    private var cancelables = Set<AnyCancellable>()

    var communityItem: CommunityItem?
    
    override func viewDidLoad() {
        segmentStyle = .float
        segmentBarHeight = 48
        maximumOffset = 202

        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBar.backgroundColor = .clear
        customBackBtn.setImage(UIImage(named: "lab_navigation_back_white"), for: .normal)
        
        let _ = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "lab_child_community_share"), for: .normal)
            $0.addAction(UIAction() {[unowned self] _ in
                var titles = ["分享"]
                if communityItem?.manager?.contains(where: { $0.userID == AppContext.current.userID }) == true {
                    titles.append("发布公告")
                }
                
                ActionSheet.show(titles: titles) { index in
                    if index == 0 {
                        let items = ["我在这里发现一个超棒的社区，快来下载吧http://www.fmwworld.com", URL(string: "http://www.fmwworld.com").nonnull]
                        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
                        activityVC.modalPresentationStyle = .overFullScreen
                        UIManager.present(modal: activityVC)
                    } else if index == 1 {
                        let feed = FeedEditItem()
                        feed.communityitem = self.communityItem
                        feed.isCommunityBroadcast = true
                        UIManager.push(to: FeedEditViewController(editItem: feed))
                    }
                }
            }, for: .touchUpInside)
            customBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(20)
                make.right.equalTo(-16)
                make.centerY.equalTo(customBackBtn)
            }
        }
        
        backgorundView.do {
            $0.image = UIImage(named: "lab_child_community_background")
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            view.insertSubview($0, belowSubview: customBar)
            view.insertSubview($0, belowSubview: contentView)
            $0.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(400)
            }
        }
        
        contentView.backgroundColor = .clear
        contentView.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(customBar.snp.bottom)
        }
        
        headerContentView.backgroundColor = .clear
        headerContentView.snp.remakeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(view)
            make.height.equalTo(maximumOffset + 15)
        }
        
        tabSegmentView.backgroundColor = .white
        tabSegmentView.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(view)
            make.height.equalTo(40)
            make.top.equalTo(headerContentView.snp.bottom)
        }
        
        pageViewController.view.backgroundColor = .white
        pageViewController.view.snp.remakeConstraints { make in
            make.top.equalTo(tabSegmentView.snp.bottom)
            make.left.width.equalTo(tabSegmentView)
            make.height.equalTo(UIManager.shared.screenHeight - UIManager.shared.navBarHeight - 40)
        }
        
        avatarView.do {
            $0.layer.cornerRadius = 8.0
            $0.layer.masksToBounds = true
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(64)
                make.top.equalTo(24)
                make.left.equalTo(16)
            }
        }
        
        nameLabel.do {
            $0.textColor = .white
            $0.font = .mediumPingFangSCFont(ofSize: 16)
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-90)
                make.left.equalTo(avatarView.snp.right).offset(12)
                make.height.equalTo(22)
                make.top.equalTo(avatarView).offset(2)
            }
        }
        
        descLabel.do {
            $0.textColor = .white.withAlphaComponent(0.5)
            $0.font = .regularPingFangSCFont(ofSize: 12)
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-90)
                make.left.equalTo(nameLabel)
                make.height.equalTo(17)
                make.top.equalTo(nameLabel.snp.bottom).offset(4)
            }
        }
        
        managerAvatarView.do {
            $0.image = UIImage(named: "lab_child_community_manager")
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(10)
                make.top.equalTo(descLabel.snp.bottom).offset(7)
                make.left.equalTo(nameLabel)
            }
        }
        
        managerLabel.do {
            $0.setTitle("申请管理员", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 10)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
            $0.addAction(UIAction() {_ in
                UIManager.push(to: FeedChildCommunityManagerApplyViewController().then { $0.communityItem = self.communityItem })
            }, for: .touchUpInside)
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.lessThanOrEqualTo(200)
                make.left.equalTo(managerAvatarView.snp.right).offset(5)
                make.height.equalTo(10)
                make.centerY.equalTo(managerAvatarView)
            }
        }
        
        followBtn.do {
            $0.layer.cornerRadius = 4.0
            $0.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            $0.layer.borderWidth = 1.0
            $0.setImage(UIImage(named: "lab_child_community_follow"), for: .normal)
            $0.setImage(nil, for: .selected)
            $0.setTitle(" 关注", for: .normal)
            $0.setTitle("已关注", for: .selected)
            $0.setTitleColor(color(248, 248, 248), for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0)
            $0.addAction(UIAction() {[unowned self] _ in
                followBtn.isSelected = !followBtn.isSelected
                communityItem?.isFollow = followBtn.isSelected
                
                Network.request(followBtn.isSelected ? FeedAPI.communityFollow : FeedAPI.communityCancelFollow, parameters: ["id": (communityItem?.id).nonnull]).responseData { response in
                    if let error = response.error {
                        Toast.toast(title: error.localizedDescription)
                    }
                }
            }, for: .touchUpInside)
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.equalTo(60)
                make.height.equalTo(28)
                make.centerY.equalTo(avatarView)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 18.0
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(avatarView.snp.bottom).offset(24)
            }
        }
        
        topBtn.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
            $0.backgroundColor = color(235, 248, 255)
            $0.layer.cornerRadius = 4.0
            $0.setTitle("置顶", for: .normal)
            $0.setTitleColor(color(51, 186, 255), for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 10)
            $0.addAction(UIAction() {[unowned self] _ in
                guard let _ = communityItem?.topFeed else { return }
                UIManager.push(to: CommunityFeedDetailViewController().then { $0.feedItem = communityItem?.topFeed?.feedItem })
            }, for: .touchUpInside)
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(avatarView)
                make.width.equalTo(28)
                make.height.equalTo(17)
                make.top.equalTo(avatarView.snp.bottom).offset(42)
            }
        }
        
        topFeedLabel.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
            $0.addAction(UIAction() {[unowned self] _ in
                guard let _ = communityItem?.topFeed else { return }
                UIManager.push(to: CommunityFeedDetailViewController().then { $0.feedItem = communityItem?.topFeed?.feedItem })
            }, for: .touchUpInside)
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(topBtn.snp.right).offset(6)
                make.centerY.equalTo(topBtn)
                make.right.lessThanOrEqualTo(-16)
                make.height.equalTo(20)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(0.5)
                make.top.equalTo(topBtn.snp.bottom).offset(14)
            }
        }
        
        broadcastBtn.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 4.0
            $0.setTitle("公告", for: .normal)
            $0.setTitleColor(color(0, 0, 0, 0.5), for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 10)
            $0.addTarget(self, action: #selector(broadcastFeedTapHandler), for: .touchUpInside)
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(avatarView)
                make.width.equalTo(28)
                make.height.equalTo(17)
                make.top.equalTo(topBtn.snp.bottom).offset(28)
            }
        }
        
        broadcastLabel.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
            $0.addTarget(self, action: #selector(broadcastFeedTapHandler), for: .touchUpInside)
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(broadcastBtn.snp.right).offset(6)
                make.centerY.equalTo(broadcastBtn)
                make.right.lessThanOrEqualTo(-16)
                make.height.equalTo(20)
            }
        }
        
        bind(segments: [ChildFeedViewController().then {
            $0.name = "最新"
            $0.parentScrollView = overlayScrollDetectorView
            $0.contentSizeDidChange = {[unowned self] _ in
                updateContentSize(index: 0)
            }
            
            let viewModel = CommunityContainerViewController.InnerViewModel()
            viewModel.url = FeedAPI.communityFeedList.rawValue
            viewModel.innerPara = ["id": (communityItem?.id).nonnull, "sort": 0]
            $0.viewModel = viewModel
        }, ChildFeedViewController().then {
            $0.name = "最热"
            $0.parentScrollView = overlayScrollDetectorView
            $0.contentSizeDidChange = {[unowned self] _ in
                updateContentSize(index: 1)
            }
            
            let viewModel = CommunityContainerViewController.InnerViewModel()
            viewModel.url = FeedAPI.communityFeedList.rawValue
            viewModel.innerPara = ["id": (communityItem?.id).nonnull, "sort": 1]
            $0.viewModel = viewModel
        }])
        
        refreshCommunity()
        
        NotificationCenter.default.publisher(for: .notificationCommunityFeedDidUpdateStatus).sink { object in
            guard let communityItem = object.object as? CommunityItem, communityItem.id == self.communityItem?.id else { return }
            self.refreshCommunity()
        }.store(in: &cancelables)
        
        NotificationCenter.default.publisher(for: .notificationFeedDidPublish).sink { object in
            guard let feed = object.object as? FeedItem, feed.community?.id == self.communityItem?.id else { return }
            (self.viewControllers.first as? ChildFeedViewController)?.viewModel?.refresh(shouldLoadCache: true)
        }.store(in: &cancelables)
    }
    
    private func refreshCommunity() {
        Network.request(FeedAPI.communityDetail, parameters: ["id": (communityItem?.id).nonnull]).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let data = response.data?.jsonData(), let communityItem = try? JSONDecoder().decode(CommunityItem.self, from: data) {
                self.communityItem = communityItem
                self.viewControllers.forEach { ($0 as? ChildFeedViewController)?.communityItem = communityItem }
                self.avatarView.setWebImage(url: OSSUploader.avatarURLFor(communityItem.image), cornerRadius: 8*3.0, finalSize: CGSize(width: 64*3.0, height: 64*3.0))
                self.nameLabel.text = communityItem.name
                self.descLabel.text = "\(communityItem.followCount.nonnull)关注 · \(communityItem.feedCount.nonnull)帖子"
                if let user = communityItem.manager?.first {
                    self.managerAvatarView.setWebImage(url: OSSUploader.avatarURLFor(user.avatar, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
                    self.managerLabel.setTitle("管理员: \(user.userName)", for: .normal)
                }
                
                self.followBtn.isSelected = communityItem.isFollow == true
                
                if communityItem.manager?.contains(where: { $0.userID == AppContext.current.userID }) == true {
                    if let feed = communityItem.broadcastFeed {
                        self.broadcastLabel.setTitle(feed.desc.isEmpty ? "[图片]" : feed.desc, for: .normal)
                    } else {
                        self.broadcastLabel.setTitle("发布公告", for: .normal)
                    }
                } else {
                    self.broadcastLabel.setTitle(communityItem.broadcastFeed?.desc ?? "暂无公告", for: .normal)
                }
                
                if let feed = communityItem.topFeed {
                    self.topFeedLabel.setTitle(feed.desc.isEmpty ? "[图片]" : feed.desc, for: .normal)
                } else {
                    self.topFeedLabel.setTitle("暂无置顶", for: .normal)
                }
            }
        }
    }
        
    override func updateContentSize(index: Int) {
        if index == pageViewController.currentIndex {
            overlayScrollDetectorView.contentSize = CGSize(width: UIManager.shared.screenWidth, height: maximumOffset + 15 + segmentBarHeight + tabSegmentView.currentSelectedItem.contentSize.height)
            contentView.contentSize = CGSize(width: UIManager.shared.screenWidth, height: UIManager.shared.screenHeight + maximumOffset)
        }
    }
    
    @objc fileprivate func broadcastFeedTapHandler() {
        if let _ = communityItem?.broadcastFeed {
            UIManager.push(to: CommunityFeedDetailViewController().then {
                $0.feedItem = communityItem?.broadcastFeed?.feedItem
                $0.communityItem = communityItem
            })
        } else if communityItem?.manager?.contains(where: { $0.userID == AppContext.current.userID }) == true {
            let feed = FeedEditItem()
            feed.communityitem = self.communityItem
            feed.isCommunityBroadcast = true
            UIManager.push(to: FeedEditViewController(editItem: feed))
        }
    }
    
    override func didScrolToPage(index: Int) {
        overlayScrollDetectorView.contentSize = CGSize(width: UIManager.shared.screenWidth, height: maximumOffset + 15 + segmentBarHeight + tabSegmentView.currentSelectedItem.contentSize.height)
        overlayScrollDetectorView.contentOffset = offsetMap[index] ?? contentView.contentOffset
        
        if index == 0 {
            (viewControllers[0] as? ChildFeedViewController)?.dispatcher.isVisible = true
            (viewControllers[1] as? ChildFeedViewController)?.dispatcher.isVisible = false
        } else {
            (viewControllers[0] as? ChildFeedViewController)?.dispatcher.isVisible = false
            (viewControllers[1] as? ChildFeedViewController)?.dispatcher.isVisible = true
        }
    }
    
    fileprivate class ChildFeedViewController: TableViewController, SegmentBarItem {
        
        var name: String = ""
        //MARK: - Segment
        var segmentTitle: String {
            return name
        }
        
        var normalColor: UIColor { color(0, 0, 0, 0.4) }
        var selectColor: UIColor { .black }
        var font: UIFont { UIFont.regularPingFangSCFont(ofSize: 14) }
        var selectFont: UIFont { .mediumPingFangSCFont(ofSize: 14) }
        var viewController: UIViewController { self }
        var segmentPadding: CGFloat { 16 }
        var segmentMargin: CGFloat { 32 }
        var segmentIndicatorEnable: Bool { true }
        var segmentIndicatorColor: UIColor? { color(51, 186, 255) }
        var segmentIndicatorHeight: CGFloat { 4.0 }
        
        var contentSize: CGSize { tableView?.contentSize ?? .zero }
        
        func updateContentOffset(_ offset: CGPoint) {
            tableView?.contentOffset = offset
        }
        
        var parentScrollView: UIScrollView!
        var contentSizeDidChange: ((CGSize) -> Void)?
        var communityItem: CommunityItem?
        lazy var dispatcher = VideoPlayerDispatch(parentView: view, scrollView: tableView).then { $0.isVisible = false }

        override func viewDidLoad() {
            triggerRefreshAutomatic = true
            triggerLoadMoreAutomatic = true
            emptyPlaceholderOffsetY = -200
            super.viewDidLoad()
            dispatcher.playWhenScrolling = true
            
            tableView?.panGestureRecognizer.require(toFail: parentScrollView.panGestureRecognizer)
            tableView?.scrollsToTop = false
            tableView?.bounces = false
            tableView?.register(cellWithClass: CommunityFeedCell.self)
            tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIManager.shared.screenWidth, height: 100))
            tableView?.snp.makeConstraints({ make in
                make.top.left.right.bottom.equalToSuperview()
            })
            tableView?.publisher(for: \.contentSize).sink(receiveValue: {[unowned self] size in
                contentSizeDidChange?(size)
            }).store(in: &cancellableList)
            
            NotificationCenter.default.publisher(for: .notificationFeedDidDelete).sink {[unowned self] object in
                guard let feed = object.object as? FeedItem else { return }
                viewModel?.remove(feed)
                tableView?.reloadData()
            }.store(in: &cancellableList)
            
            NotificationCenter.default.publisher(for: .notificationFeedDidLikeUpdate).sink {[unowned self] object in
                guard let feed = object.object as? FeedItem else { return }
                if let currentFeed = viewModel?.element(for: feed.uniqueIdentifier) as? FeedItem {
                    currentFeed.likesCount = feed.likesCount
                    currentFeed.isLike = feed.isLike
                    tableView?.reloadData()
                }
            }.store(in: &cancellableList)
            
            NotificationCenter.default.publisher(for: .notificationFeedDidCommentUpdate).sink {[unowned self] object in
                guard let feed = object.object as? FeedItem else { return }
                if let currentFeed = viewModel?.element(for: feed.uniqueIdentifier) as? FeedItem {
                    currentFeed.commentsCount = feed.commentsCount
                    tableView?.reloadData()
                }
            }.store(in: &cancellableList)
            
            NotificationCenter.default.publisher(for: .notificationFeedDidMarkUpdate).sink {[unowned self] object in
                guard let feed = object.object as? FeedItem else { return }
                if let currentFeed = viewModel?.element(for: feed.uniqueIdentifier) as? FeedItem {
                    currentFeed.markCount = feed.markCount
                    currentFeed.isMark = feed.isMark
                    tableView?.reloadData()
                }
            }.store(in: &cancellableList)
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            dispatcher.isVisible = true
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            dispatcher.isVisible = false
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withClass: CommunityFeedCell.self)
            cell.selectionStyle = .none
            cell.contentView.backgroundColor =  .white
            
            if let feedItem = viewModel?.element(at: indexPath.section) as? FeedItem {
                cell.bindData(feedItem, style: name == "最新" ? .communityNew : .communityHot)
                cell.moreActionHandler = {[weak cell, weak self] in
                    guard let strongCell = cell, let strongSelf = self, let feedItem = strongCell.feedItem else { return }
                    if strongSelf.communityItem?.manager?.contains(where: { $0.userID == AppContext.current.userID }) == true {
                        let menuVC = ChildFeedMoreMenuViewController()
                        menuVC.parentOriginY = strongCell.contentView.convert(strongCell.moreBtn.frame, to: UIManager.shared.rootWindow).maxY
                        menuVC.feedItem = strongCell.feedItem
                        menuVC.communityItem = strongSelf.communityItem
                        menuVC.modalPresentationStyle = .overFullScreen
                        UIManager.present(modal: menuVC, animated: false)
                    } else {
                        ActionSheet.show(titles: ["分享", "举报"]) { index in
                            if index == 0 {
                                let items = ["我在这里发现一个超棒的内容，快来下载吧http://www.fmwworld.com", URL(string: "http://www.fmwworld.com").nonnull]
                                let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
                                activityVC.modalPresentationStyle = .overFullScreen
                                UIManager.present(modal: activityVC)
                            } else {
                                let para: [String: Any] = ["beReportId": feedItem.id,
                                                           "type": 2,
                                                           "reason": ""]
                                Network.request(MainAPI.contentReport, parameters: para).responseEmpty()
                                Toast.toast(title: "举报成功")
                            }
                        }
                    }
                }
            }
            return cell
        }
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            guard let feedItem = viewModel?.element(at: indexPath.section) as? FeedItem, let imageItem = feedItem.images.first else { return 0 }
            return imageItem.imageHeight + 80 + (feedItem.content.nonnull.isEmpty ? 0 : 12 + feedItem.contentHeight) + (feedItem.hasExtra ? 79 : 49)
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let feedItem = viewModel?.element(at: indexPath.section) as? FeedItem {
                UIManager.push(to: CommunityFeedDetailViewController().then { $0.feedItem = feedItem })
            }
        }
    }
    
    fileprivate class ChildFeedMoreMenuViewController: UIViewController {
        var parentOriginY: CGFloat = 0
        var feedItem: FeedItem?
        var communityItem: CommunityItem?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .clear
            
            let backView = UIView().then {
                $0.backgroundColor = color(0, 0, 0, 0.6)
                $0.layer.cornerRadius = 8
                view.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.equalTo(80)
                    make.height.equalTo(113)
                    make.right.equalTo(-16)
                    make.top.equalTo(parentOriginY + 10)
                }
            }
            
            let _ = UIButton().then {
                $0.setTitle(feedItem?.id == communityItem?.topFeed?.feedId ? "取消置顶" : "置顶内容", for: .normal)
                $0.setTitleColor(.white, for: .normal)
                $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
                $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
                $0.addAction(UIAction() { _ in
                    HUD.show()
                    Network.request(self.feedItem?.id == self.communityItem?.topFeed?.feedId ? FeedAPI.communityFeedCancelTop : FeedAPI.communityFeedTop, parameters: ["feedId": (self.feedItem?.id).nonnull, "id": (self.communityItem?.id).nonnull]).responseData { response in
                        HUD.hide()
                        if let error = response.error {
                            Toast.toast(title: error.localizedDescription)
                        } else {
                            Toast.toast(title: "操作成功")
                            NotificationCenter.default.post(name: .notificationCommunityFeedDidUpdateStatus, object: self.communityItem)
                            self.dismiss(animated: false)
                        }
                    }
                }, for: .touchUpInside)
                backView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.equalTo(10)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(17)
                }
            }
            
            let _ = UIView().then {
                $0.backgroundColor = .white.withAlphaComponent(0.1)
                backView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(-37)
                    make.height.equalTo(0.5)
                }
            }
            
            let _ = UIButton().then {
                $0.setTitle("隐藏内容", for: .normal)
                $0.setTitleColor(.white, for: .normal)
                $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
                $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
                $0.addAction(UIAction() { _ in
                    HUD.show()
                    Network.request(FeedAPI.communityFeedHidden, parameters: ["feedId": (self.feedItem?.id).nonnull, "id": (self.communityItem?.id).nonnull]).responseData { response in
                        HUD.hide()
                        if let error = response.error {
                            Toast.toast(title: error.localizedDescription)
                        } else {
                            Toast.toast(title: "操作成功")
                            NotificationCenter.default.post(name: .notificationCommunityFeedDidUpdateStatus, object: self.communityItem)
                            NotificationCenter.default.post(name: .notificationFeedDidDelete, object: self.feedItem)
                            self.dismiss(animated: false)
                        }
                    }
                }, for: .touchUpInside)
                backView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.left.right.equalToSuperview()
                    make.height.equalTo(17)
                }
            }
            
            let _ = UIView().then {
                $0.backgroundColor = .white.withAlphaComponent(0.1)
                backView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(37)
                    make.height.equalTo(0.5)
                }
            }
            
            let _ = UIButton().then {
                $0.setTitle("分享", for: .normal)
                $0.setTitleColor(.white, for: .normal)
                $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
                $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
                $0.addAction(UIAction() {[unowned self] _ in
                    let items = ["我在这里发现一个超棒的内容，快来下载吧http://www.fmwworld.com", URL(string: "http://www.fmwworld.com").nonnull]
                    let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    activityVC.modalPresentationStyle = .overFullScreen
                    UIManager.present(modal: activityVC)
                    dismiss(animated: false)
                }, for: .touchUpInside)
                backView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.bottom.equalTo(-10)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(17)
                }
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            dismiss(animated: false)
        }
    }
}

