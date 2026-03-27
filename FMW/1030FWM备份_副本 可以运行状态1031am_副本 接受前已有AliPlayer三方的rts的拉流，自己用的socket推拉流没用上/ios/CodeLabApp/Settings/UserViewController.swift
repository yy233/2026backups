//
//  SettingsViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/5/30.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import YYImage
import Combine
import CodeLabUnityBridge
import APIKit
import Alamofire
import VideoPlayerKit

final class UserViewController: SegmentViewController {
    var tabUser = false
    var userID: String = ""
    var userInfo: UserInfo?
    private var user: UserProfile?

    private let barAvatarView = UIImageView()
    private let barNameLabel = UILabel()
    private let backgorundView = UIImageView()
    private let avatarView = UIImageView()
    private let nameLabel = UILabel()
    private let descLabel = UILabel()
    private let followLabel = UIButton()
    private let fansLabel = UIButton()
    private let nftCountLabel = UILabel()
    private let feedsCountLabel = UILabel()
    private let editBtn = UIButton()
    private let fansBtn = UIButton()
    private let chatBtn = UIButton()

    override func viewDidLoad() {
        segmentStyle = .float
        segmentBarHeight = 40
        maximumOffset = 367 - UIManager.shared.navBarHeight
        
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = tabUser
        customBar.backgroundColor = .clear
                
        if tabUser {
            let settingsBtn = UIButton().then {
                $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
                $0.setImage(UIImage(named: "ge_icon_user_menu"), for: .normal)
                $0.addAction(UIAction() {_ in
                    UIManager.push(to: SettingsViewController())
                }, for: .touchUpInside)
                customBar.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.height.equalTo(24)
                    make.right.equalTo(-20)
                    make.bottom.equalTo(-10)
                }
            }
            
            let _ = UIButton().then {
                $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
                $0.setImage(UIImage(named: "ge_icon_user_right"), for: .normal)
                $0.addAction(UIAction() {_ in
                    UIManager.push(to: MyInteralViewController())
                }, for: .touchUpInside)
                customBar.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.height.equalTo(24)
                    make.right.equalTo(settingsBtn.snp.left).offset(-15)
                    make.bottom.equalTo(-10)
                }
            }
        } else {
            let _ = UIButton().then {
                $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
                $0.setImage(UIImage(named: "ge_icon_user_menu"), for: .normal)
                $0.addAction(UIAction() { _ in
                    ActionSheet.show(titles: ["分享", "举报"]) { index in
                        if index == 0 {
                            let items = ["我在这里发现一个超棒的用户，快来下载吧http://www.fmwworld.com", URL(string: "http://www.fmwworld.com").nonnull]
                            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
                            activityVC.modalPresentationStyle = .overFullScreen
                            UIManager.present(modal: activityVC)
                        } else {
                            let para: [String: Any] = ["beReportId": self.userID,
                                                       "type": 1,
                                                       "reason": ""]
                            Network.request(MainAPI.contentReport, parameters: para).responseEmpty()
                            Toast.toast(title: "举报成功")
                        }
                    }
                }, for: .touchUpInside)
                customBar.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.height.equalTo(24)
                    make.right.equalTo(-20)
                    make.bottom.equalTo(-10)
                }
            }
        }
        
        barNameLabel.do {
            $0.isHidden = true
            $0.textColor = .black
            $0.font = .gothamMediumFont(ofSize: 18)
            customBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.lessThanOrEqualTo(200)
                make.centerX.equalTo(customBar).offset(18)
                make.height.lessThanOrEqualTo(50)
                make.centerY.equalTo(customBackBtn)
            }
        }
        
        barAvatarView.do {
            $0.isHidden = true
            customBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(30)
                make.right.equalTo(barNameLabel.snp.left).offset(-5)
                make.centerY.equalTo(customBackBtn)
            }
        }
        
        headerContentView.snp.remakeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(view)
            make.height.equalTo(367)
        }
        
        tabSegmentView.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(view)
            make.height.equalTo(40)
            make.top.equalTo(headerContentView.snp.bottom)
        }
        
        pageViewController.view.snp.remakeConstraints { make in
            make.top.equalTo(tabSegmentView.snp.bottom).offset(10)
            make.left.width.equalTo(tabSegmentView)
            make.height.equalTo(UIManager.shared.screenHeight - UIManager.shared.navBarHeight - 50)
        }
        
        backgorundView.do {
            $0.image = UIImage(named: "lab_user_background")
            $0.contentMode = .scaleAspectFill
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(-67)
                make.height.equalTo(367)
            }
        }
        
        avatarView.do {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarTapHandler)))
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(82)
                make.top.equalTo(144)
                make.left.equalTo(20)
            }
        }
        
        nameLabel.do {
            $0.textColor = .black
            $0.font = .gothamMediumFont(ofSize: 24)
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nameTapHandler)))
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-20)
                make.top.equalTo(avatarView)
                make.height.lessThanOrEqualTo(50)
                make.left.equalTo(avatarView.snp.right).offset(24)
            }
        }
        
        descLabel.do {
            $0.textColor = color(0, 0, 0, 0.5)
            $0.font = .regularPingFangSCFont(ofSize: 12)
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nameTapHandler)))
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(3)
                make.height.equalTo(17)
                make.left.right.equalTo(nameLabel)
            }
        }
        
        if userID == AppContext.current.userID {
            editBtn.do {
                $0.hitTestEdgeInsets = UIEdgeInsets(top: -8, left: -10, bottom: -15, right: -10)
                $0.setImage(UIImage(named: "lab_user_edit_profile"), for: .normal)
                $0.addTarget(self, action: #selector(nameTapHandler), for: .touchUpInside)
                headerContentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.equalTo(66)
                    make.height.equalTo(21)
                    make.left.equalTo(nameLabel)
                    make.top.equalTo(descLabel.snp.bottom).offset(8)
                }
            }
        } else {
            fansBtn.do {
                $0.backgroundColor = color(51, 186, 255)
                $0.layer.cornerRadius = 10.5
                $0.setTitle(" 关注", for: .normal)
                $0.setTitleColor(.white, for: .normal)
                $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 10)
                $0.setImage(UIImage(named: "lab_user_fans_follow"), for: .normal)
                $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 8)
                $0.addAction(UIAction() {[weak self] _ in
                    guard let profile = self?.user else { return }
                    if profile.relationship == .fan || profile.relationship == .stranger {
                        HUD.show()
                        Network.request(UserAPI.userFollow, parameters: ["remoteId": (profile.userInfo?.userID).nonnull]).responseData { response in
                            HUD.hide()
                            if let error = response.error {
                                Toast.toast(title: error.localizedDescription)
                            } else {
                                Toast.toast(title: "已关注")
                                self?.fansBtn.setTitle("已关注", for: .normal)
                                self?.fansBtn.setImage(nil, for: .normal)
                                switch profile.relationship {
                                case .stranger:
                                    profile.relationship = .follow
                                case .fan:
                                    profile.relationship = .friend
                                default:break
                                }
                            }
                        }
                    } else {
                        Alert.show(title: "取消关注", message: "取消关注后，对方将从你的关注列表中移除", submitBtnTitle: "确认", submitBtnTapHandler: {
                            HUD.show()
                            Network.request(UserAPI.userCancelFollow, parameters: ["remoteId": (profile.userInfo?.userID).nonnull]).responseData { response in
                                HUD.hide()
                                if let error = response.error {
                                    Toast.toast(title: error.localizedDescription)
                                } else {
                                    Toast.toast(title: "已取消关注")
                                    self?.fansBtn.setTitle(" 关注", for: .normal)
                                    self?.fansBtn.setImage(UIImage(named: "lab_user_fans_follow"), for: .normal)

                                    switch profile.relationship {
                                    case .follow:
                                        profile.relationship = .stranger
                                    case .friend:
                                        profile.relationship = .fan
                                    default:break
                                    }
                                }
                            }
                        })
                    }
                }, for: .touchUpInside)
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(nameLabel)
                    make.width.greaterThanOrEqualTo(46)
                    make.height.equalTo(21)
                    make.top.equalTo(descLabel.snp.bottom).offset(8)
                }
            }
            
            chatBtn.do {
                $0.hitTestEdgeInsets = UIEdgeInsets(top: -8, left: 0, bottom: -15, right: -20)
                $0.setImage(UIImage(named: "lab_user_chat_other"), for: .normal)
                $0.addAction(UIAction() {[unowned self] _ in
                    UIManager.push(to: ChatViewController().then { $0.chatWith = userID })
                }, for: .touchUpInside)
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(fansBtn.snp.right).offset(8)
                    make.width.equalTo(48)
                    make.height.equalTo(21)
                    make.centerY.equalTo(fansBtn)
                }
            }
        }
        
        let backView = UIView().then {
            $0.backgroundColor = .white
            headerContentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(avatarView.snp.bottom).offset(36)
            }
        }
        
        followLabel.do {
            $0.setTitle("0", for: .normal)
            $0.contentHorizontalAlignment = .left
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -30, left: -20, bottom: -20, right: 0)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .gothamMediumFont(ofSize: 24)
            $0.addAction(UIAction() {[unowned self]_ in
                guard userID == AppContext.current.userID else { return }
                UIManager.push(to: FansViewController().then {
                    $0.index = 0
                    $0.userID = userID
                })
            }, for: .touchUpInside)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.height.lessThanOrEqualTo(50)
                make.top.equalTo(10)
                make.width.equalTo(110)
                make.left.equalTo(16)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "关注"
            $0.textColor = color(0, 0, 0, 0.3)
            $0.font = .regularPingFangSCFont(ofSize: 12)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.height.equalTo(17)
                make.top.equalTo(followLabel.snp.bottom)
                make.width.left.equalTo(followLabel)
            }
        }
        
        fansLabel.do {
            $0.setTitle("0", for: .normal)
            $0.contentHorizontalAlignment = .left
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -30, left: -20, bottom: -20, right: 0)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .gothamMediumFont(ofSize: 24)
            $0.addAction(UIAction() {[unowned self] _ in
                guard userID == AppContext.current.userID else { return }
                UIManager.push(to: FansViewController().then {
                    $0.index = 1
                    $0.userID = userID
                })
            }, for: .touchUpInside)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.height.lessThanOrEqualTo(50)
                make.top.equalTo(10)
                make.right.equalTo(-16)
                make.left.equalTo(147)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "粉丝数量"
            $0.textColor = color(0, 0, 0, 0.3)
            $0.font = .regularPingFangSCFont(ofSize: 12)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.height.equalTo(17)
                make.top.equalTo(fansLabel.snp.bottom)
                make.width.left.equalTo(fansLabel)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.05)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(1)
                make.height.equalTo(78)
                make.top.equalToSuperview()
                make.left.equalTo(followLabel.snp.right)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.05)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview()
                make.top.equalTo(78)
            }
        }
        
        bind(segments: [UserHomeViewController().then {
            $0.userID = userID
            $0.tabUser = tabUser
            $0.parentScrollView = overlayScrollDetectorView
            $0.contentSizeDidChange = {[unowned self] _ in
                updateContentSize(index: 0)
            }
        }, UserNFTViewController().then {
            $0.userID = userID
            $0.tabUser = tabUser
            $0.parentScrollView = overlayScrollDetectorView
            $0.contentSizeDidChange = {[unowned self] _ in
                updateContentSize(index: 1)
            }
        }, UserFeedViewController().then {
            $0.userID = userID
            $0.tabUser = tabUser
            $0.parentScrollView = overlayScrollDetectorView
            $0.contentSizeDidChange = {[unowned self] _ in
                updateContentSize(index: 2)
            }
        }])
        
        if let btn = tabSegmentView.segmentBtns[safe: 1] {
            nftCountLabel.do {
                $0.textColor = color(0, 0, 0, 0.3)
                $0.font = .mediumPingFangSCFont(ofSize: 16)
                tabSegmentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.lessThanOrEqualTo(100)
                    make.left.equalTo(btn.snp.right).offset(5)
                    make.height.equalTo(22)
                    make.centerY.equalTo(btn)
                }
            }
        }
        
        if let btn = tabSegmentView.segmentBtns[safe: 2] {
            feedsCountLabel.do {
                $0.textColor = color(0, 0, 0, 0.3)
                $0.font = .mediumPingFangSCFont(ofSize: 16)
                tabSegmentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.lessThanOrEqualTo(100)
                    make.left.equalTo(btn.snp.right).offset(5)
                    make.height.equalTo(22)
                    make.centerY.equalTo(btn)
                }
            }
        }
        
        updateUserInfo()
        
        if let userInfo = userInfo {
            barAvatarView.setWebImage(url: OSSUploader.avatarURLFor(userInfo.avatar, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
            barNameLabel.text = userInfo.userName
            avatarView.setWebImage(url: OSSUploader.avatarURLFor(userInfo.avatar, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
            nameLabel.text = userInfo.userName
            descLabel.text = userInfo.introduction ?? "这个人很懒，吃饭都要靠别人喂"
        }
    }
    
    @objc fileprivate func avatarTapHandler() {
        let unityVC = AvatarDecorationViewController()
        unityVC.userID = userID
        let options = CodeLabUnityWindowPresentationOptions()
        options.transitionStyle = .none
        CodeLabUnityInstance.shared.presentUnityWindow(with: options, overlayViewController: unityVC) {
            
        } completion: { handle, error in
            unityVC.backBtnDidTap = {
                handle?.dismiss(animated: true, completion: { _ in })
            }
        }
    }
    
    @objc fileprivate func nameTapHandler() {
        UIManager.present(modal: UserEditNameViewController().then {
            $0.modalPresentationStyle = .overFullScreen
            $0.didSubmitHandler = { string in
                self.user?.userInfo?.userName = string
                self.nameLabel.text = string
                AppContext.current.userContext?.user?.user?.userInfo?.userName = string
            }
        }, animated: false)
    }
    
    private func refreshUser() {
        Network.request(UserAPI.userInfo.rawValue + userID, encoding: URLEncoding.default).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let data = response.data?.jsonData(), let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
                self.user = profile
                if profile.userInfo?.userID == AppContext.current.userID {
                    AppContext.current.userContext?.user?.user = profile
                }
                self.updateUserInfo()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshUser()
        (viewControllers[0] as? UserHomeViewController)?.refresh()
    }
    
    private func updateUserInfo() {
        guard let profile = user else { return }
        barAvatarView.setWebImage(url: OSSUploader.avatarURLFor((profile.userInfo?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
        barNameLabel.text = profile.userInfo?.userName
        avatarView.setWebImage(url: OSSUploader.avatarURLFor((profile.userInfo?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
        nameLabel.text = profile.userInfo?.userName
        descLabel.text = profile.userInfo?.introduction ?? "这个人很懒，吃饭都要靠别人喂"
        fansLabel.setTitle("\(profile.fansNum)", for: .normal)
        followLabel.setTitle("\(profile.followNum)", for: .normal)
        feedsCountLabel.text = "\(profile.feedNum.nonnull)"
        nftCountLabel.text = "\(profile.nftNum.nonnull)"
        
        if profile.relationship == .follow || profile.relationship == .friend {
            fansBtn.setImage(nil, for: .normal)
            fansBtn.setTitle("已关注", for: .normal)
        } else if profile.relationship == .fan || profile.relationship == .stranger {
            fansBtn.setTitle(" 关注", for: .normal)
            fansBtn.setImage(UIImage(named: "lab_user_fans_follow"), for: .normal)
        }
    }
    
    override func updateContentSize(index: Int) {
        if index == pageViewController.currentIndex {
            overlayScrollDetectorView.contentSize = CGSize(width: overlayScrollDetectorView.contentSize.width, height: 367 + 40 + tabSegmentView.currentSelectedItem.contentSize.height)
            contentView.contentSize = CGSize(width: UIManager.shared.screenWidth, height: UIManager.shared.screenHeight + maximumOffset)
        }
    }
    
    override func didScrolToPage(index: Int) {
        overlayScrollDetectorView.contentOffset = offsetMap[index] ?? contentView.contentOffset
        overlayScrollDetectorView.contentSize = CGSize(width: overlayScrollDetectorView.contentSize.width, height: 367 + 40 + tabSegmentView.currentSelectedItem.contentSize.height)
        
        if index == 1 {
            nftCountLabel.textColor = color(0, 0, 0)
            feedsCountLabel.textColor = color(0, 0, 0, 0.3)
        } else if index == 2 {
            nftCountLabel.textColor = color(0, 0, 0, 0.3)
            feedsCountLabel.textColor = color(0, 0, 0)
        } else {
            nftCountLabel.textColor = color(0, 0, 0, 0.3)
            feedsCountLabel.textColor = color(0, 0, 0, 0.3)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        if contentView.contentOffset.y >= 0 {
            backgorundView.alpha = 1.0
        } else {
            backgorundView.alpha = 1.0 - abs(contentView.contentOffset.y)/50*0.7
        }
        
        if contentView.contentOffset.y < 160 {
            customBar.backgroundColor = .clear
            barNameLabel.isHidden = true
            barAvatarView.isHidden = true
        } else {
            customBar.backgroundColor = .white
            barNameLabel.isHidden = false
            barAvatarView.isHidden = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if contentView.contentOffset.y < -50 {
            avatarTapHandler()
        }
    }
    
    fileprivate class UserFeedViewController: TableViewController, SegmentBarItem {
        
        //MARK: - Segment
        var segmentTitle: String {
            return "动态"
        }
        
        var normalColor: UIColor { color(0, 0, 0, 0.3) }
        var selectColor: UIColor { .black }
        var font: UIFont { UIFont.semiboldPingFangSCFont(ofSize: 16) }
        var selectFont: UIFont { UIFont.semiboldPingFangSCFont(ofSize: 16) }
        var viewController: UIViewController { self }
        var segmentPadding: CGFloat { 16 }
        var segmentMargin: CGFloat { 48 }
        var segmentIndicatorEnable: Bool { true }
        var segmentIndicatorColor: UIColor? { color(51, 186, 255) }
        var segmentIndicatorHeight: CGFloat { 4.0 }
        var contentSize: CGSize { tableView?.contentSize ?? .zero }
        
        func updateContentOffset(_ offset: CGPoint) {
            tableView?.contentOffset = offset
        }
        
        var parentScrollView: UIScrollView!
        var contentSizeDidChange: ((CGSize) -> Void)?
        var userID: String = ""
        var tabUser: Bool = false
        lazy var dispatcher = VideoPlayerDispatch(parentView: view, scrollView: tableView)

        override func viewDidLoad() {
            showRefreshHeader = false
            triggerRefreshAutomatic = true
            triggerLoadMoreAutomatic = true
            emptyPlaceholderOffsetY = -200
            let viewModel = CommunityContainerViewController.InnerViewModel()
            viewModel.url = FeedAPI.publishList.rawValue
            viewModel.innerPara = ["remoteId": userID]
            self.viewModel = viewModel
            super.viewDidLoad()
            dispatcher.playWhenScrolling = true
            
            tableView?.panGestureRecognizer.require(toFail: parentScrollView.panGestureRecognizer)
            tableView?.scrollsToTop = false
            tableView?.bounces = false
            tableView?.register(cellWithClass: CommunityFeedCell.self)
            tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIManager.shared.screenWidth - 150, height: tabUser && TabBarViewController.sectorTabBarShow ? 300 : 120))
            tableView?.snp.makeConstraints({ make in
                make.top.left.right.bottom.equalToSuperview()
            })
            tableView?.publisher(for: \.contentSize).sink(receiveValue: {[unowned self] size in
                contentSizeDidChange?(size)
            }).store(in: &cancellableList)
            
            NotificationCenter.default.publisher(for: .notificationFeedDidPublish).sink {_ in
                viewModel.refresh(shouldLoadCache: false)
            }.store(in: &cancellableList)
            
            NotificationCenter.default.publisher(for: .notificationFeedDidDelete).sink {[unowned self] object in
                guard let feed = object.object as? FeedItem else { return }
                viewModel.remove(feed)
                tableView?.reloadData()
            }.store(in: &cancellableList)
            
            NotificationCenter.default.publisher(for: .notificationFeedDidLikeUpdate).sink {[unowned self] object in
                guard let feed = object.object as? FeedItem else { return }
                if let currentFeed = viewModel.element(for: feed.uniqueIdentifier) as? FeedItem {
                    currentFeed.likesCount = feed.likesCount
                    currentFeed.isLike = feed.isLike
                    tableView?.reloadData()
                }
            }.store(in: &cancellableList)
            
            NotificationCenter.default.publisher(for: .notificationFeedDidCommentUpdate).sink {[unowned self] object in
                guard let feed = object.object as? FeedItem else { return }
                if let currentFeed = viewModel.element(for: feed.uniqueIdentifier) as? FeedItem {
                    currentFeed.commentsCount = feed.commentsCount
                    tableView?.reloadData()
                }
            }.store(in: &cancellableList)
            
            NotificationCenter.default.publisher(for: .notificationFeedDidMarkUpdate).sink {[unowned self] object in
                guard let feed = object.object as? FeedItem else { return }
                if let currentFeed = viewModel.element(for: feed.uniqueIdentifier) as? FeedItem {
                    currentFeed.markCount = feed.markCount
                    currentFeed.isMark = feed.isMark
                    tableView?.reloadData()
                }
            }.store(in: &cancellableList)
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withClass: CommunityFeedCell.self)
            if let feedItem = viewModel?.element(at: indexPath.section) as? FeedItem {
                cell.bindData(feedItem, style: .user)
                cell.moreActionHandler = {
                    ActionSheet.show(titles: ["分享"]) { index in
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
            cell.selectionStyle = .none
            cell.contentView.backgroundColor =  .white
            return cell
        }
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            guard let feedItem = viewModel?.element(at: indexPath.section) as? FeedItem, let imageItem = feedItem.images.first else { return CGFloat.leastNormalMagnitude }
            return imageItem.imageHeight + 80 + (feedItem.content.nonnull.isEmpty ? 0 : 12 + feedItem.contentHeight) + (feedItem.hasExtra ? 79 : 49)
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let feedItem = viewModel?.element(at: indexPath.section) as? FeedItem {
                UIManager.push(to: CommunityFeedDetailViewController().then { $0.feedItem = feedItem })
            }
        }
    }
    
    fileprivate class UserNFTViewController: CollectionViewController, SegmentBarItem {
        //MARK: - Segment
        var segmentTitle: String {
            return "数藏"
        }
        
        var normalColor: UIColor { color(0, 0, 0, 0.3) }
        var selectColor: UIColor { .black }
        var font: UIFont { UIFont.semiboldPingFangSCFont(ofSize: 16) }
        var selectFont: UIFont { UIFont.semiboldPingFangSCFont(ofSize: 16) }
        var viewController: UIViewController { self }
        var segmentPadding: CGFloat { 16 }
        var segmentMargin: CGFloat { 48 }
        var segmentIndicatorEnable: Bool { true }
        var segmentIndicatorColor: UIColor? { color(51, 186, 255) }
        var segmentIndicatorHeight: CGFloat { 4.0 }
        var contentSize: CGSize { collectionView?.contentSize ?? .zero }
        
        func updateContentOffset(_ offset: CGPoint) {
            collectionView?.contentOffset = offset
        }
        
        fileprivate var parentScrollView: UIScrollView!
        fileprivate var contentSizeDidChange: ((CGSize) -> Void)?
        
        var userID: String?
        var tabUser: Bool = false
        
        override func viewDidLoad() {
            showRefreshHeader = false
            triggerRefreshAutomatic = true
            triggerLoadMoreAutomatic = true
            emptyPlaceholderOffsetY = -200
            let viewModel = InnerViewModel()
            viewModel.url = NFTAPI.ownNFTList.rawValue
            viewModel.innerPara = ["remoteUid": userID.nonnull, "goodsId": ""]
            self.viewModel = viewModel
            super.viewDidLoad()
            
            if let flowlayout = flowLayout as? CollectionWaterFlowLayout {
                flowlayout.contentInset = UIEdgeInsets(top: 15, left: 16, bottom: tabUser && TabBarViewController.sectorTabBarShow ? 300 : 120, right: 16)
                flowlayout.columnCount = 2
                flowlayout.columnSpacing = 13
                flowlayout.lineSpacing = 15
                flowlayout.indexPathHeightHandler = { indexPath, width in
                    if let item = viewModel.element(at: indexPath.item) as? UserNFTItem, let info = item.info, let cover = info.cover {
                        let imageHeight = max(1, cover.ht.nonnull)/max(1, cover.wt.nonnull)*width
                        return imageHeight + 30
                    }
                    return width + 30
                }
            }
            
            collectionView?.panGestureRecognizer.require(toFail: parentScrollView.panGestureRecognizer)
            collectionView?.scrollsToTop = false
            collectionView?.bounces = false
            collectionView?.register(cellWithClass: NFTCollectionCell.self)
            collectionView?.snp.makeConstraints({ make in
                make.top.left.right.bottom.equalToSuperview()
            })
            collectionView?.publisher(for: \.contentSize).sink(receiveValue: {[unowned self] size in
                contentSizeDidChange?(size)
            }).store(in: &cancellableList)
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withClass: NFTCollectionCell.self, for: indexPath)
            cell.contentView.backgroundColor = .white
            if let item = viewModel?.element(at: indexPath.item) as? UserNFTItem, let info = item.info, let cover = info.cover {
                let imageWidth = (UIManager.shared.screenWidth - 16*2 - 13)/2.0
                let imageHeight = max(1, cover.ht.nonnull)/max(1, cover.wt.nonnull)*imageWidth
                cell.imageView.setWebImage(url: OSSUploader.imageNFTURLFor((info.cover?.guid).nonnull, crop: .medium), cornerRadius: 12*3.0, finalSize: CGSize(width: imageWidth*3.0, height: imageHeight*3.0))
                cell.textLabel.text = info.name + "#\(item.goodsNum.nonnull)"
                cell.pointsLabel.isHidden = true
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let item = viewModel?.element(at: indexPath.item) as? UserNFTItem, let info = item.info {
                UIManager.push(to: NFTDetailViewController().then {
                    $0.nftInfo = info
                    $0.goodsNum = item.goodsNum
                })
            }
        }

        fileprivate class InnerViewModel: NetworkViewModel {
            var innerPara: [String: Any]?
            override var parameters: [String : Any]? { innerPara }
            
            override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
                guard let data = data.jsonString.data(using: .utf8) else { return nil }
                do {
                    let result = try JSONDecoder().decode([UserNFTItem].self, from: data)
                    if isLoadingMore {
                        var list = [UserNFTItem]()
                        for item in result {
                            if element(for: item.uniqueIdentifier) == nil {
                                list.append(item)
                            }
                        }
                        return list
                    }
                    return result
                } catch {
                    assertionFailure(error.localizedDescription)
                }
                return nil
            }
        }
    }
    
    fileprivate class UserHomeViewController: BaseViewController, SegmentBarItem {
        //MARK: - Segment
        var segmentTitle: String {
            return "主页"
        }
        
        var normalColor: UIColor { color(0, 0, 0, 0.3) }
        var selectColor: UIColor { .black }
        var font: UIFont { UIFont.semiboldPingFangSCFont(ofSize: 16) }
        var selectFont: UIFont { UIFont.semiboldPingFangSCFont(ofSize: 16) }
        var viewController: UIViewController { self }
        var segmentPadding: CGFloat { 16 }
        var segmentMargin: CGFloat { 48 }
        var segmentIndicatorEnable: Bool { true }
        var segmentIndicatorColor: UIColor? { color(51, 186, 255) }
        var segmentIndicatorHeight: CGFloat { 4.0 }
        var contentSize: CGSize { scrollView.contentSize }
        
        func updateContentOffset(_ offset: CGPoint) {
            scrollView.contentOffset = offset
        }
        
        var parentScrollView: UIScrollView!
        var contentSizeDidChange: ((CGSize) -> Void)?
        
        let scrollView = UIScrollView()
        var cancelableList = Set<AnyCancellable>()
        var markFeeds: [FeedItem] = []
        var userID: String = ""
        var tabUser: Bool = false
        var markFeedCollectionView: UICollectionView!
        
        let commentView = UIView()
        let commentTitleLabel = UILabel()
        let commentTimeLabel = UILabel()
        var commentItem: CommentItem?
        
        let nftImageView = UIImageView()
        let goodsCell1 = ImageNameCollectionCell()
        let goodsCell2 = ImageNameCollectionCell()
        
        @objc fileprivate func nftBtnTap() {
            UIManager.push(to: UserMarkViewController().then {
                $0.index = 0
                $0.userID = userID
            })
        }
        
        @objc fileprivate func goodsBtnTap() {
            UIManager.push(to: UserMarkViewController().then {
                $0.index = 1
                $0.userID = userID
            })
        }
        
        @objc fileprivate func feedBtnTap() {
            UIManager.push(to: UserMarkFeedsViewController().then { $0.userID = userID })
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
  
            scrollView.do {
                $0.showsVerticalScrollIndicator = false
                $0.showsHorizontalScrollIndicator = false
                $0.panGestureRecognizer.require(toFail: parentScrollView.panGestureRecognizer)
                $0.scrollsToTop = false
                $0.contentInsetAdjustmentBehavior = .never
                $0.bounces = false
                view.addSubview($0)
                $0.snp.makeConstraints({ make in
                    make.top.left.right.bottom.equalToSuperview()
                })
                $0.publisher(for: \.contentSize).sink(receiveValue: {[unowned self] size in
                    contentSizeDidChange?(size)
                }).store(in: &cancelableList)
            }
            
            let contentView = UIView().then {
                $0.backgroundColor = .white
                scrollView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.top.bottom.equalToSuperview()
                    make.width.equalTo(view)
                }
            }
            
            let _ = LinearGradientView().then {
                $0.startPoint = CGPoint(x: 0, y: 0)
                $0.endPoint = CGPoint(x: 0, y: 1)
                $0.colors = [color(255, 255, 255), color(249, 249, 249)]
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.edges.equalTo(UIEdgeInsets.zero)
                }
            }
            
            //MARK: - 数藏
            let nftView = UIView().then {
                $0.isUserInteractionEnabled = true
                $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nftBtnTap)))
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.equalTo(20)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(166)
                }
            }
            
            nftImageView.do {
                $0.layer.cornerRadius = 14.0
                $0.layer.masksToBounds = true
                $0.image = UIImage(named: "lab_user_nft_mark")
                $0.isUserInteractionEnabled = true
                $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nftBtnTap)))
                nftView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(16)
                    make.width.height.equalTo(166)
                    make.top.equalToSuperview()
                }
            }
            
            let titleLabel1 = UILabel().then {
                $0.text = "收藏的\n数藏"
                $0.numberOfLines = 2
                $0.font = .gothamBoldFont(ofSize: 27)
                $0.textColor = .black
                nftView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(nftImageView.snp.right).offset(13)
                    make.top.equalTo(nftImageView).offset(5)
                    make.right.equalTo(-16)
                    make.height.lessThanOrEqualTo(100)
                }
            }
            
            let _ = UILabel().then {
                $0.text = "丰富你的藏品世界"
                $0.font = .mediumPingFangSCFont(ofSize: 14)
                $0.textColor = color(11, 21, 38, 0.5)
                nftView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalTo(titleLabel1)
                    make.top.equalTo(titleLabel1.snp.bottom).offset(14)
                    make.height.equalTo(21)
                }
            }
            
            let _ = UIButton().then {
                $0.setImage(UIImage(named: "lab_user_mark_btn"), for: .normal)
                $0.addTarget(self, action: #selector(nftBtnTap), for: .touchUpInside)
                nftView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.height.equalTo(39)
                    make.left.equalTo(titleLabel1)
                    make.bottom.equalTo(nftImageView)
                }
            }
            
            //MARK: - 商品
            let goodsView = UIView().then {
                $0.isUserInteractionEnabled = true
                $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goodsBtnTap)))
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(nftView.snp.bottom).offset(37)
                    make.height.equalTo(100)
                }
            }
            
            let titleLabel2 = UILabel().then {
                $0.text = "收藏的\n商品"
                $0.numberOfLines = 2
                $0.font = .gothamBoldFont(ofSize: 27)
                $0.textColor = .black
                goodsView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(16)
                    make.top.equalToSuperview()
                    make.width.lessThanOrEqualTo(100)
                    make.height.lessThanOrEqualTo(100)
                }
            }
            
            let _ = UILabel().then {
                $0.text = "有趣的商品购物"
                $0.font = .mediumPingFangSCFont(ofSize: 14)
                $0.textColor = color(11, 21, 38, 0.5)
                goodsView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(titleLabel2)
                    make.top.equalTo(titleLabel2.snp.bottom).offset(13)
                    make.height.equalTo(21)
                }
            }
            
            goodsCell1.do {
                goodsView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.right.equalTo(-16)
                    make.top.equalTo(1)
                    make.width.equalTo(76)
                    make.height.equalTo(98)
                }
            }
            
            goodsCell2.do {
                goodsView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.right.equalTo(goodsCell1.snp.left).offset(-8)
                    make.top.width.height.equalTo(goodsCell1)
                }
            }
            
            //MARK: - 动态
            let feedView = UIView().then {
                $0.backgroundColor = .white
                $0.layer.cornerRadius = 14
                $0.isUserInteractionEnabled = true
                $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(feedBtnTap)))
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(goodsView.snp.bottom).offset(42)
                    make.height.equalTo(176)
                    
                    if userID != AppContext.current.userID {
                        make.bottom.equalTo(tabUser && TabBarViewController.sectorTabBarShow ? -300 : -120)
                    }
                }
            }
            
            let titleLabel3 = UILabel().then {
                $0.text = "收藏的动态"
                $0.font = .semiboldPingFangSCFont(ofSize: 16)
                $0.textColor = .black
                feedView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(16)
                    make.top.equalTo(10)
                    make.right.equalTo(-20)
                    make.height.equalTo(23)
                }
            }
                
            let _ = UIImageView().then {
                $0.image = UIImage(named: "ge_main_arrow")
                feedView.addSubview($0)
                $0.snp.makeConstraints { make in
                   make.width.equalTo(8)
                    make.height.equalTo(16)
                    make.right.equalTo(-16)
                    make.centerY.equalTo(titleLabel3)
                }
            }
            
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.itemSize = CGSize(width: 128, height: 138)
            flowLayout.scrollDirection = .horizontal
            
            markFeedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
                $0.backgroundColor = .white
                $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                $0.delegate = self
                $0.dataSource = self
                $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                $0.showsVerticalScrollIndicator = false
                $0.showsHorizontalScrollIndicator = false
                $0.register(cellWithClass: FeedCollectionCell.self)
                $0.keyboardDismissMode = .onDrag
                $0.contentInsetAdjustmentBehavior = .never
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(138)
                    make.top.equalTo(titleLabel3.snp.bottom).offset(16)
                }
            }
            
            //MARK: - 评论
            if userID == AppContext.current.userID {
                commentView.do {
                    $0.isHidden = true
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.width.equalTo(view)
                        make.top.equalTo(feedView.snp.bottom).offset(42)
                        make.height.equalTo(207)
                        make.bottom.equalTo(tabUser && TabBarViewController.sectorTabBarShow ? -100 : 0)
                    }
                }
                
                let titleLabel4 = UIButton().then {
                    $0.setTitle("我的评论", for: .normal)
                    $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 16)
                    $0.setTitleColor(.black, for: .normal)
                    $0.contentHorizontalAlignment = .left
                    $0.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: 0, bottom: -10, right: 0)
                    $0.addAction(UIAction() { _ in
                        UIManager.push(to: MyCommentsViewController())
                    }, for: .touchUpInside)
                    commentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(16)
                        make.top.equalToSuperview()
                        make.right.equalToSuperview()
                        make.height.equalTo(23)
                    }
                }
                
                let _ = UIButton().then {
                    $0.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: 40 - UIManager.shared.screenWidth, bottom: -20, right: -20)
                    $0.setImage(UIImage(named: "ge_main_arrow"), for: .normal)
                    $0.addAction(UIAction() { _ in
                        UIManager.push(to: MyCommentsViewController())
                    }, for: .touchUpInside)
                    commentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.width.equalTo(8)
                        make.height.equalTo(16)
                        make.right.equalTo(-16)
                        make.centerY.equalTo(titleLabel4)
                    }
                }
                
                let commentBackView = UIButton().then {
                    $0.backgroundColor = color(248, 248, 248)
                    $0.layer.borderColor = UIColor.white.cgColor
                    $0.layer.borderWidth = 1.0
                    $0.layer.cornerRadius = 8
                    $0.layer.shadowOffset = CGSize(width: 0, height: 5)
                    $0.layer.shadowColor = color(227, 227, 227, 0.64).cgColor
                    $0.layer.shadowRadius = 20
                    $0.layer.shadowOpacity = 1.0
                    $0.addAction(UIAction() {_ in
                        let feedItem = FeedItem()
                        feedItem.id = (self.commentItem?.feedId).nonnull
                        UIManager.push(to: CommunityFeedDetailViewController().then { $0.feedItem = feedItem })
                    }, for: .touchUpInside)
                    commentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(16)
                        make.right.equalTo(-16)
                        make.top.equalTo(titleLabel4.snp.bottom).offset(16)
                        make.height.equalTo(101)
                    }
                }
                
                commentTitleLabel.do {
                    $0.textColor = .black
                    $0.font = .mediumPingFangSCFont(ofSize: 14)
                    commentBackView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(12)
                        make.top.equalTo(16)
                        make.right.equalTo(-12)
                        make.height.lessThanOrEqualTo(50)
                    }
                }
                
                commentTimeLabel.do {
                    $0.textColor = color(0, 0, 0, 0.4)
                    $0.font = .regularPingFangSCFont(ofSize: 12)
                    commentBackView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.right.equalTo(commentTitleLabel)
                        make.bottom.equalTo(-16)
                        make.right.equalTo(-12)
                        make.height.lessThanOrEqualTo(50)
                    }
                }
            }
        }
        
        func refresh() {
            Network.request(UserAPI.userHomeData, parameters: ["remoteId": userID]).responseData { response in
                if response.error == nil {
                    let nfts = response.data?["markDigitGoods"] as? [Any]
                    let goods = response.data?["markGoods"] as? [Any]
                    let feeds = response.data?["markFeeds"] as? [Any]
                    let comments = response.data?["comments"] as? [Any]

                    if let data = nfts?.jsonString.data(using: .utf8),
                       let list = try? JSONDecoder().decode([NFTInfo].self, from: data),
                       let info = list.first {
                        self.nftImageView.image = nil
                        self.nftImageView.setWebImage(url: (info.cover?.guid).nonnull)
                    } else {
                        self.nftImageView.image = UIImage(named: "lab_user_nft_mark")
                    }
                    
                    if let data = goods?.jsonString.data(using: .utf8),
                       let list = try? JSONDecoder().decode([GoodsItem].self, from: data), !list.isEmpty {
                        if let item = list[safe: 0] {
                            self.goodsCell1.nameLabel.text = item.name
                            self.goodsCell1.imageView.image = nil
                            self.goodsCell1.imageView.setWebImage(url: (item.cover?.guid).nonnull)
                        } else {
                            self.goodsCell1.nameLabel.text = "暂无收藏"
                            self.goodsCell1.imageView.image = nil
                        }
                        
                        if let item = list[safe: 1] {
                            self.goodsCell2.isHidden = false
                            self.goodsCell2.nameLabel.text = item.name
                            self.goodsCell2.imageView.image = nil
                            self.goodsCell2.imageView.setWebImage(url: (item.cover?.guid).nonnull)
                        } else {
                            self.goodsCell2.isHidden = true
                        }
                    } else {
                        self.goodsCell1.nameLabel.text = "暂无收藏"
                        self.goodsCell1.imageView.image = nil
                        self.goodsCell2.isHidden = true
                    }
                    
                    if let data = feeds?.jsonString.data(using: .utf8),
                       let feedList = try? JSONDecoder().decode([FeedItem].self, from: data) {
                        self.markFeeds.removeAll()
                        self.markFeeds.append(contentsOf: feedList)
                        self.markFeedCollectionView.reloadData()
                    }
                    
                    if self.userID == AppContext.current.userID {
                        if let data = comments?.jsonString.data(using: .utf8),
                           let comments = try? JSONDecoder().decode([CommentItem].self, from: data),
                            let commentItem = comments.first {
                            self.commentItem = commentItem
                            self.commentView.isHidden = false
                            self.commentTitleLabel.text = commentItem.content
                            self.commentTimeLabel.text = Date(timeIntervalSince1970: commentItem.time/1000.0).displayString() + (commentItem.location.nonnull.isEmpty ? "" : "  ·  \(commentItem.location.nonnull)")
                            self.commentView.snp.updateConstraints { make in
                                make.bottom.equalTo(-200)
                            }
                        } else {
                            self.commentView.isHidden = true
                            self.commentView.snp.updateConstraints { make in
                                make.bottom.equalTo(-100)
                            }
                        }
                    }
                }
            }
        }
        
        class ImageNameCollectionCell: UIView {
            lazy var nameLabel = UILabel().then {
                $0.font = .mediumPingFangSCFont(ofSize: 9)
                $0.textColor = color(11, 21, 38)
                $0.textAlignment = .center
                addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(21)
                    make.top.equalTo(imageView.snp.bottom).offset(2)
                }
            }
            
            fileprivate lazy var imageView = UIImageView().then {
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                $0.backgroundColor = color(246, 246, 246)
                addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.top.equalToSuperview()
                    make.height.equalTo(76)
                }
            }
        }
    }
}

extension UserViewController.UserHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(markFeeds.count, 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: FeedCollectionCell.self, for: indexPath)
        cell.contentView.backgroundColor = .white
        cell.clipsToBounds = false
        
        if let feed = markFeeds[safe: indexPath.item], let imageItem = feed.images.first {
            cell.imageView.backgroundColor = .clear
            cell.emptyLabel.isHidden = true
            cell.imageView.setWebImage(url: OSSUploader.imageURLFor(imageItem.guid, crop: .medium), cornerRadius: 8*3.0, finalSize: CGSize(width: 128*3.0, height: 128*3.0))
            cell.backView.isHidden = false
            cell.avatarView.setWebImage(url: OSSUploader.avatarURLFor((feed.user?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
            cell.nameLabel.text = feed.user?.userName
        } else {
            cell.backView.isHidden = true
            cell.imageView.backgroundColor = color(0, 0, 0, 0.1)
            cell.emptyLabel.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIManager.push(to: CommunityFeedDetailViewController().then { $0.feedItem = markFeeds[indexPath.item] })
    }
}

fileprivate class FeedCollectionCell: UICollectionViewCell {
    fileprivate lazy var imageView = UIImageView().then {
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        }
    }
    
    fileprivate lazy var backView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 17.5
        $0.layer.shadowOffset = CGSize(width: 0, height: 5)
        $0.layer.shadowColor = color(227, 227, 227, 0.64).cgColor
        $0.layer.shadowRadius = 20
        $0.layer.shadowOpacity = 1.0
        contentView.insertSubview($0, aboveSubview: imageView)
        $0.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.width.equalTo(93)
            make.height.equalTo(35)
        }
    }
    
    fileprivate lazy var avatarView = UIImageView().then {
        backView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.top.equalTo(6)
            make.width.height.equalTo(23)
        }
    }
    
    fileprivate lazy var nameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .semiboldPingFangSCFont(ofSize: 14)
        backView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(5)
            make.right.equalTo(-5)
            make.top.bottom.equalToSuperview()
        }
    }
    
    fileprivate lazy var emptyLabel = UILabel().then {
        $0.text = "暂无收藏"
        $0.textColor = .black
        $0.font = .regularPingFangSCFont(ofSize: 14)
        $0.textAlignment = .center
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.center.equalTo(imageView)
            make.width.height.equalToSuperview()
        }
    }
}


