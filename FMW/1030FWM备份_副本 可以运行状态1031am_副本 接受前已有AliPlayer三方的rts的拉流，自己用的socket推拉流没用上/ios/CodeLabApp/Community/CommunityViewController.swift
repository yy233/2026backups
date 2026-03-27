//
//  CommunityViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/11.
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
import Combine
import APIKit
import ImagePreviewKit

final class CommunityContainerViewController: SegmentViewController {
    
    private lazy var allVC = CommunityViewController().then {
        $0.name = "推荐"
        let viewModel = InnerViewModel()
        viewModel.url = FeedAPI.recommendList.rawValue
        $0.viewModel = viewModel
    }
    private lazy var followVC = CommunityViewController().then {
        $0.name = "关注"
        let viewModel = InnerViewModel()
        viewModel.url = FeedAPI.followList.rawValue
        $0.viewModel = viewModel
    }

    private lazy var allCollectionVC = FeedCollectionViewController().then {
        $0.name = "推荐"
        let viewModel = InnerViewModel()
        viewModel.url = FeedAPI.recommendList.rawValue
        $0.viewModel = viewModel
    }
    private lazy var followCollectionVC = FeedCollectionViewController().then {
        $0.name = "关注"
        let viewModel = InnerViewModel()
        viewModel.url = FeedAPI.followList.rawValue
        $0.viewModel = viewModel
    }
    
    public static let feedStyleKey = "com.codelab.gyg.feed.style"
    public static let feedStyleChangeNotification: Notification.Name = Notification.Name(rawValue: "com.codelab.gyg.feed.style.change")
    private var cancelables = Set<AnyCancellable>()
        
    override func viewDidLoad() {
        segmentStyle = .navigationLeft
        segmentBarHeight = 44
        super.viewDidLoad()
        customBackBtn.isHidden = true
        
        let cameraBtn = UIButton().then {
            $0.setImage(UIImage(named: "lab_icon_community_camera"), for: .normal)
            $0.addTarget(self, action: #selector(cameraBtnTap), for: .touchUpInside)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            customBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.right.equalTo(-16)
                make.centerY.equalTo(customBackBtn)
            }
        }
        
        let messageBtn = UIButton().then {
            $0.setImage(UIImage(named: "lab_icon_community_message"), for: .normal)
            $0.addTarget(self, action: #selector(messageBtnTap), for: .touchUpInside)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            customBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.right.equalTo(cameraBtn.snp.left).offset(-16)
                make.centerY.equalTo(cameraBtn)
            }
        }
        
        let redDot = RedDot().then {
            $0.value = .dot((AppContext.current.userContext?.unreadTotalCount).nonnull)
            customBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(messageBtn)
                make.top.equalTo(messageBtn)
                make.width.height.equalTo(10)
            }
        }
        
        AppContext.current.userContext?.$unreadTotalCount.sink(receiveValue: { result in
            redDot.value = .dot(result)
        }).store(in: &cancelables)
        
        NotificationCenter.default.publisher(for: CommunityContainerViewController.feedStyleChangeNotification).sink {[unowned self] _ in
            if UserDefaults.standard.bool(forKey: CommunityContainerViewController.feedStyleKey) != true {
                bind(segments: [allCollectionVC, followCollectionVC])
            } else {
                bind(segments: [allVC, followVC])
            }
        }.store(in: &cancelables)
        
        NotificationCenter.default.publisher(for: .notificationFeedDidPublish).sink {[unowned self] _ in
            pageViewController.scrollToPage(.last, animated: true)
            if UserDefaults.standard.bool(forKey: CommunityContainerViewController.feedStyleKey) != true {
                followCollectionVC.viewModel?.refresh(shouldLoadCache: false)
                followCollectionVC.collectionView?.setContentOffset(.zero, animated: false)
            } else {
                followVC.viewModel?.refresh(shouldLoadCache: false)
                followVC.tableView?.scrollToTop()
            }
        }.store(in: &cancelables)
        
        NotificationCenter.default.publisher(for: .notificationFeedDidDelete).sink {[unowned self] object in
            guard let feed = object.object as? FeedItem else { return }
            if UserDefaults.standard.bool(forKey: CommunityContainerViewController.feedStyleKey) != true {
                followCollectionVC.viewModel?.remove(feed)
                followCollectionVC.collectionView?.reloadData()
            } else {
                followVC.viewModel?.remove(feed)
                followVC.tableView?.reloadData()
            }
        }.store(in: &cancelables)
        
        NotificationCenter.default.publisher(for: .notificationPointsDidTapFeedRecommend).sink {[unowned self] _ in
            pageViewController.scrollToPage(.first, animated: true)
        }.store(in: &cancelables)
        
        if UserDefaults.standard.bool(forKey: CommunityContainerViewController.feedStyleKey) != true {
            bind(segments: [allCollectionVC, followCollectionVC])
        } else {
            bind(segments: [allVC, followVC])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppContext.current.userContext?.refreshUnread()
    }
    
    @objc fileprivate func messageBtnTap() {
        UIManager.push(to: MessageViewController())
    }
    
    @objc fileprivate func cameraBtnTap() {
        UIManager.push(to: FeedEditViewController(editItem: FeedEditItem()))
    }
    
    class InnerViewModel: NetworkViewModel {
        var innerPara: [String: Any]?
        override var parameters: [String : Any]? { innerPara }
        
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([FeedItem].self, from: data)
                if isLoadingMore {
                    var list = [FeedItem]()
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

final class CommunityViewController: TableViewController, SegmentBarItem {
    
    //MARK: - Segment
    var segmentTitle: String {
        return name
    }

    var name: String = ""
    var normalColor: UIColor { color(156, 156, 156) }
    var selectColor: UIColor { .black }
    var font: UIFont { UIFont.mediumPingFangSCFont(ofSize: 18) }
    var selectFont: UIFont { .mediumPingFangSCFont(ofSize: 20) }
    var viewController: UIViewController { self }
    var segmentPadding: CGFloat { 16 }
    var segmentMargin: CGFloat { 24 }
    var segmentIndicatorEnable: Bool { true }
    var segmentIndicatorImage: UIImage? { UIImage(named: "lab_tab_segment_line") }
    var segmentIndicatorHeight: CGFloat { 7.6 }
        
    private lazy var dispatcher = VideoPlayerDispatch(parentView: view, scrollView: tableView)
    
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        super.viewDidLoad()

        dispatcher.playWhenScrolling = true
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
        tableView?.register(cellWithClass: CommunityFeedCell.self)
        tableView?.snp.makeConstraints({ make in
            make.top.left.right.bottom.equalToSuperview()
        })
        
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CommunityFeedCell.self)
        if let feedItem = viewModel?.element(at: indexPath.section) as? FeedItem {
            cell.bindData(feedItem, style: name == "关注" ? .follow : .recommend)
            cell.moreActionHandler = {
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
        cell.selectionStyle = .none
        cell.contentView.backgroundColor =  .white
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

class CommunityFeedCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    lazy var avatarView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTap)))
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(11)
            make.width.height.equalTo(57)
        }
    }
    
    lazy var titleLabel = UILabel().then {
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTap)))
        $0.textColor = .black
        $0.font = .mediumPingFangSCFont(ofSize: 14)
        $0.textAlignment = .left
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(6)
            make.top.equalTo(avatarView).offset(14)
            make.right.equalTo(moreBtn.snp.left).offset(-10)
            make.height.equalTo(20)
        }
    }
    
    lazy var descLabel = UILabel().then {
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTap)))
        $0.textColor = color(0, 0, 0, 0.4)
        $0.font = .regularPingFangSCFont(ofSize: 12)
        $0.textAlignment = .left
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(17)
        }
    }
    
    lazy var locationBtn = UIButton().then {
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: 0, right: -5)
        $0.backgroundColor = color(245, 245, 245)
        $0.layer.cornerRadius = 11
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 10)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        $0.addAction(UIAction() {[unowned self] _ in
            UIManager.push(to: CommunityFeedListViewController().then { $0.locationItem = feedItem.location })
        }, for: .touchUpInside)
        contentView.addSubview($0)
    }
    
    lazy var topicBtn = UIButton().then {
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: 0, right: -5)
        $0.backgroundColor = color(245, 245, 245)
        $0.layer.cornerRadius = 11
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 10)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        $0.addAction(UIAction() {[unowned self] _ in
            UIManager.push(to: CommunityFeedListViewController().then { $0.topicItem = feedItem.topic?.first })
        }, for: .touchUpInside)
        contentView.addSubview($0)
    }
    
    lazy var communityBtn = UIButton().then {
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: 0, right: -5)
        $0.backgroundColor = color(230, 247, 255)
        $0.layer.cornerRadius = 11
        $0.setTitleColor(color(51, 186, 255), for: .normal)
        $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 10)
        $0.setImage(UIImage(named: "lab_feed_community_mark"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        $0.addAction(UIAction() {[unowned self] _ in
            UIManager.push(to: FeedChildCommunityDetailViewController().then { $0.communityItem = feedItem.community })
        }, for: .touchUpInside)
        contentView.addSubview($0)
    }
    
    lazy var contentLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(collectionView.snp.bottom).offset(12)
            make.height.equalTo(0)
        }
    }
    
    lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.backgroundColor = .white
        $0.isScrollEnabled = true
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.delegate = self
        $0.dataSource = self
        $0.isPagingEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
        $0.contentInsetAdjustmentBehavior = .never
        $0.bounces = false
        $0.register(cellWithClass: ImageCollectionCell.self)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(UIManager.shared.screenWidth)
        }
    }
    
    lazy var pageControl = SnakePageControl(frame: .zero).then {
        $0.activeTint = .black
        $0.inactiveTint = .white
        $0.indicatorPadding = 10
        contentView.insertSubview($0, aboveSubview: collectionView)
        $0.snp.makeConstraints { make in
            make.bottom.equalTo(collectionView).offset(-10)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
    lazy var likeView = UIButton().then {
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -20, bottom: -20, right: -80)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(likeTap), for: .touchUpInside)
        $0.setImage(UIImage(named: "ge_icon_community_feed_dislike"), for: .normal)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(avatarView)
            make.bottom.equalTo(-13)
        }
    }
    
    lazy var likeHightlightView = UIButton().then {
        $0.hitTestEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: -20, right: -80)
        $0.setImage(UIImage(named: "ge_icon_community_feed_like"), for: .normal)
        $0.isHidden = true
        $0.addTarget(self, action: #selector(likeTap), for: .touchUpInside)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerX.equalTo(likeView)
            make.centerY.equalTo(likeView).offset(2)
        }
    }
    
    lazy var likeLabel = UILabel().then {
        $0.font = .regularPingFangSCFont(ofSize: 12)
        $0.isUserInteractionEnabled = false
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(likeView.snp.right).offset(4)
            make.width.lessThanOrEqualTo(100)
            make.height.centerY.equalTo(likeView)
        }
    }
    
    lazy var commentView = UIButton().then {
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -20, bottom: -20, right: -80)
        $0.setImage(UIImage(named: "ge_icon_community_feed_comment"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(commentTap), for: .touchUpInside)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerX.equalToSuperview().offset(-2)
            make.centerY.equalTo(likeView)
        }
    }
    
    lazy var commentLabel = UILabel().then {
        $0.font = .regularPingFangSCFont(ofSize: 12)
        $0.isUserInteractionEnabled = false
        $0.textColor = color(0, 0, 0, 0.4)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(commentView.snp.right).offset(4)
            make.width.lessThanOrEqualTo(100)
            make.height.centerY.equalTo(likeView)
        }
    }
    
    lazy var markView = UIButton().then {
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -20, bottom: -20, right: -80)
        $0.setImage(UIImage(named: "ge_icon_community_feed_mark"), for: .normal)
        $0.addTarget(self, action: #selector(markTap), for: .touchUpInside)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalTo(markLabel.snp.left).offset(-2)
            make.centerY.equalTo(likeView)
        }
    }
    
    lazy var markLabel = UILabel().then {
        $0.font = .regularPingFangSCFont(ofSize: 12)
        $0.isUserInteractionEnabled = false
        $0.textColor = color(0, 0, 0, 0.4)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.width.lessThanOrEqualTo(100)
            make.height.centerY.equalTo(likeView)
        }
    }
    
    lazy var moreBtn = UIButton().then {
        $0.setImage(UIImage(named: "lab_community_feed_cell_more"), for: .normal)
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        $0.addAction(UIAction() {[unowned self] _ in
            moreActionHandler?()
        }, for: .touchUpInside)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.right.equalTo(-16)
            make.centerY.equalTo(avatarView)
        }
    }
    
    enum Style: String {
        case follow = "follow"
        case recommend = "recommend"
        case topic = "topic"
        case communityNew = "communityNew"
        case communityHot = "communityHot"
        case user = "user"
    }
    
    var feedItem: FeedItem!
    var feedStyle: Style!
    var moreActionHandler: PureCompletionHandler?
    func bindData(_ feedItem: FeedItem, style: Style) {
        self.feedItem = feedItem
        self.feedStyle = style
        
        titleLabel.text = feedItem.user?.userName
        descLabel.text = (feedItem.user?.introduction).nonnull.isEmpty ? "这个人很懒，吃饭都要靠别人喂" : feedItem.user?.introduction
        avatarView.setWebImage(url: OSSUploader.avatarURLFor((feedItem.user?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
        likeHightlightView.isHidden = !feedItem.isLike
        likeView.isHidden = feedItem.isLike
        markLabel.text = feedItem.markCount > 999 ? "999+" : "\(feedItem.markCount)"
        markView.setImage(feedItem.isMark ? UIImage(named: "ge_icon_community_feed_mark_selected") : UIImage(named: "ge_icon_community_feed_mark"), for: .normal)
        likeLabel.text = feedItem.likesCount > 999 ? "999+" : "\(feedItem.likesCount)"
        likeLabel.textColor = feedItem.isLike ? color(255, 38, 111) : color(0, 0, 0, 0.4)
        commentLabel.text = feedItem.commentsCount > 999 ? "999+" : "\(feedItem.commentsCount)"
        
        if feedItem.content.nonnull.isNotEmpty {
            contentLabel.attributedText = feedItem.contentAttributedText
            contentLabel.isHidden = false
        } else {
            contentLabel.isHidden = true
        }
        
        communityBtn.setTitle(" \((feedItem.community?.name).nonnull)", for: .normal)
        topicBtn.setTitle("#\((feedItem.topic?.first?.name).nonnull)", for: .normal)
        locationBtn.setTitle("#\((feedItem.location?.name).nonnull)", for: .normal)
        communityBtn.isHidden = feedItem.community == nil
        topicBtn.isHidden = feedItem.topic == nil
        locationBtn.isHidden = feedItem.location == nil
        
        pageControl.pageCount = feedItem.images.count
        pageControl.isHidden = feedItem.images.count <= 1
        
        collectionView.reloadData()
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.cancelCurrentWebImageLoad()
        avatarView.image = nil
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        guard let imageItem = feedItem.images.first else { return }
        
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(imageItem.imageHeight)
        }
        
        if !contentLabel.isHidden {
            contentLabel.snp.updateConstraints { make in
                make.height.equalTo(feedItem.contentHeight)
            }
        }
        
        if feedStyle == .topic {
            communityBtn.snp.remakeConstraints { make in
                make.left.equalTo(avatarView)
                make.width.greaterThanOrEqualTo(32)
                make.height.equalTo(22)
                
                if !contentLabel.isHidden {
                    make.top.equalTo(contentLabel.snp.bottom).offset(8)
                } else {
                    make.top.equalTo(collectionView.snp.bottom).offset(8)
                }
            }

            if !topicBtn.isHidden {
                topicBtn.snp.remakeConstraints { make in
                    if !communityBtn.isHidden {
                        make.left.equalTo(communityBtn.snp.right).offset(8)
                    } else {
                        make.left.equalTo(avatarView)
                    }
                    
                    make.centerY.equalTo(communityBtn)
                    make.width.greaterThanOrEqualTo(32)
                    make.height.equalTo(22)
                }
            }
            
            if !locationBtn.isHidden {
                locationBtn.snp.remakeConstraints { make in
                    if !topicBtn.isHidden {
                        make.left.equalTo(topicBtn.snp.right).offset(8)
                    }
                    else if !communityBtn.isHidden {
                        make.left.equalTo(communityBtn.snp.right).offset(8)
                    } else {
                        make.left.equalTo(avatarView)
                    }
                    
                    make.centerY.equalTo(communityBtn)
                    make.width.greaterThanOrEqualTo(32)
                    make.height.equalTo(22)
                }
            }
            
            likeView.snp.remakeConstraints { make in
                make.width.height.equalTo(24)
                make.left.equalTo(avatarView)
                
                if !communityBtn.isHidden {
                    make.top.equalTo(communityBtn.snp.bottom).offset(12)
                } else if !topicBtn.isHidden {
                    make.top.equalTo(topicBtn.snp.bottom).offset(12)
                } else if !locationBtn.isHidden {
                    make.top.equalTo(communityBtn.snp.bottom).offset(12)
                } else if !contentLabel.isHidden {
                    make.top.equalTo(contentLabel.snp.bottom).offset(12)
                } else {
                    make.top.equalTo(collectionView.snp.bottom).offset(12)
                }
            }
        } else {
            communityBtn.snp.remakeConstraints { make in
                make.left.equalTo(avatarView)
                make.bottom.equalTo(likeView.snp.top).offset(-12)
                make.width.greaterThanOrEqualTo(32)
                make.height.equalTo(22)
            }

            if !topicBtn.isHidden {
                topicBtn.snp.remakeConstraints { make in
                    if !communityBtn.isHidden {
                        make.left.equalTo(communityBtn.snp.right).offset(8)
                    } else {
                        make.left.equalTo(avatarView)
                    }
                    
                    make.centerY.equalTo(communityBtn)
                    make.width.greaterThanOrEqualTo(32)
                    make.height.equalTo(22)
                }
            }
            
            if !locationBtn.isHidden {
                locationBtn.snp.remakeConstraints { make in
                    if !topicBtn.isHidden {
                        make.left.equalTo(topicBtn.snp.right).offset(8)
                    }
                    else if !communityBtn.isHidden {
                        make.left.equalTo(communityBtn.snp.right).offset(8)
                    } else {
                        make.left.equalTo(avatarView)
                    }
                    
                    make.centerY.equalTo(communityBtn)
                    make.width.greaterThanOrEqualTo(32)
                    make.height.equalTo(22)
                }
            }
        }
    }
    
    @objc func likeTap() {
        feedItem.isLike = !feedItem.isLike
        feedItem.likesCount = feedItem.isLike ? feedItem.likesCount + 1 : feedItem.likesCount - 1
        likeHightlightView.isHidden = !feedItem.isLike
        likeView.isHidden = feedItem.isLike
        likeLabel.text = feedItem.likesCount > 999 ? "999+" : "\(feedItem.likesCount)"
        likeLabel.textColor = feedItem.isLike ? color(255, 38, 111) : color(0, 0, 0, 0.4)
        Network.request(feedItem.isLike ? FeedAPI.like : FeedAPI.cancelLike, parameters: ["feedId": feedItem.id]).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            }
        }
        NotificationCenter.default.post(name: .notificationFeedDidLikeUpdate, object: feedItem)
    }
    
    @objc private func commentTap() {
        UIManager.push(to: CommunityFeedDetailViewController().then { $0.feedItem = feedItem })
    }
    
    @objc private func markTap() {
        feedItem.isMark = !feedItem.isMark
        feedItem.markCount = feedItem.isMark ? feedItem.markCount + 1 : feedItem.markCount - 1
        markLabel.text = feedItem.markCount > 999 ? "999+" : "\(feedItem.markCount)"
        markView.setImage(feedItem.isMark ? UIImage(named: "ge_icon_community_feed_mark_selected") : UIImage(named: "ge_icon_community_feed_mark"), for: .normal)
        Network.request(feedItem.isMark ? FeedAPI.mark : FeedAPI.cancelMark, parameters: ["feedId": feedItem.id]).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            }
        }
        NotificationCenter.default.post(name: .notificationFeedDidMarkUpdate, object: feedItem)
    }
    
    @objc private func userTap() {
        UIManager.push(to: UserViewController().then {
            $0.userID = (feedItem.user?.userID).nonnull
            $0.userInfo = feedItem.user
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItem.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let imageItem = feedItem.images.first else { return collectionView.size }
        return CGSize(width: UIManager.shared.screenWidth, height: imageItem.imageHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIManager.push(to: CommunityFeedDetailViewController().then { $0.feedItem = feedItem })
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
        
        let item = feedItem.images[indexPath.item]
        cell.imageView.setWebImage(url: OSSUploader.imageURLFor(item.guid), cornerRadius: 16*3.0, finalSize: CGSize(width: item.imageWidth*3.0, height: item.imageHeight*3.0))
        cell.contentView.backgroundColor = .white
    
        if item.isVideo {
            cell.playerView.isHidden = false
            cell.playerView.bind(playerItem: VideoPlayerItem(identifier: feedItem.id, parentIdenfifier: "\(String(describing: collectionView.parentViewController)).\(ImageCollectionCell.self).\(feedStyle.rawValue)", videoURL: URL(string: OSSUploader.videoURLFor(item.guid)).nonnull, thumbnailURL: URL(string: OSSUploader.imageURLFor(item.guid)).nonnull, contentMode: .scaleAspectFill, extra: nil))
        } else {
            cell.playerView.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.progress = CGFloat(indexPath.item)
    }
    
    class ImageCollectionCell: UICollectionViewCell {
        lazy var imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
            }
        }
        
        lazy var playerView = VideoPlayerView().then {
            $0.layer.cornerRadius = 12.0
            $0.layer.masksToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
            }
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            imageView.cancelCurrentWebImageLoad()
            imageView.image = nil
            playerView.prepareForReuse()
        }
    }
}


class FeedCollectionViewController: CollectionViewController, SegmentBarItem {
    
    //MARK: - Segment
    var segmentTitle: String {
        return name
    }

    var name: String = ""
    var normalColor: UIColor { color(156, 156, 156) }
    var selectColor: UIColor { .black }
    var font: UIFont { UIFont.mediumPingFangSCFont(ofSize: 18) }
    var selectFont: UIFont { .mediumPingFangSCFont(ofSize: 20) }
    var viewController: UIViewController { self }
    var segmentPadding: CGFloat { 16 }
    var segmentMargin: CGFloat { 24 }
    var segmentIndicatorEnable: Bool { true }
    var segmentIndicatorImage: UIImage? { UIImage(named: "lab_tab_segment_line") }
    var segmentIndicatorHeight: CGFloat { 7.6 }
    
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        super.viewDidLoad()
        
        if let flowlayout = flowLayout as? CollectionWaterFlowLayout {
            flowlayout.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 100, right: 16)
            flowlayout.columnCount = 2
            flowlayout.columnSpacing = 13
            flowlayout.lineSpacing = 18
            flowlayout.indexPathHeightHandler = {[unowned self] indexPath,width in
                guard let feedItem = viewModel?.element(at: indexPath.item) as? FeedItem, let item = feedItem.images.first else { return width }
                return item.imageCollectionHeight + feedItem.contentCollectionHeight + 38
            }
        }
        
        collectionView?.register(cellWithClass: ImageCollectionCell.self)
        collectionView?.snp.makeConstraints({ make in
            make.top.left.right.bottom.equalToSuperview()
        })
        
        NotificationCenter.default.publisher(for: .notificationFeedDidLikeUpdate).sink {[unowned self] object in
            guard let feed = object.object as? FeedItem else { return }
            if let currentFeed = viewModel?.element(for: feed.uniqueIdentifier) as? FeedItem {
                currentFeed.likesCount = feed.likesCount
                currentFeed.isLike = feed.isLike
                collectionView?.reloadData()
            }
        }.store(in: &cancellableList)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
        cell.contentView.backgroundColor = collectionView.backgroundColor
        if let feedItem = viewModel?.element(at: indexPath.item) as? FeedItem {
            cell.bindModel(feedItem)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionCell, let feedItem = cell.feedItem {
            UIManager.push(to: CommunityFeedDetailViewController().then { $0.feedItem = feedItem })
        }
    }
    
    class ImageCollectionCell: UICollectionViewCell {
        fileprivate lazy var imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(0)
            }
        }
        
        fileprivate lazy var videoCoverView = UIImageView().then {
            $0.image = UIImage(named: "lab_feed_video_cover")
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(32)
                make.center.equalTo(imageView)
            }
        }
        
        fileprivate lazy var textLabel = UILabel().then {
            $0.textColor = .black
            $0.numberOfLines = 0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(imageView)
                make.right.equalTo(imageView)
                make.bottom.equalTo(avatarView.snp.top).offset(-6)
                make.top.equalTo(imageView.snp.bottom).offset(10)
            }
        }
        
        fileprivate lazy var avatarView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(22)
                make.left.equalTo(imageView)
                make.bottom.equalToSuperview()
            }
        }
        
        fileprivate lazy var nameLabel = UILabel().then {
            $0.font = .regularPingFangSCFont(ofSize: 12)
            $0.textColor = color(0, 0, 0, 0.4)
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(avatarView.snp.right).offset(6)
                make.right.lessThanOrEqualTo(likeView.snp.left).offset(-6)
                make.centerY.equalTo(avatarView)
                make.height.equalTo(17)
            }
        }
        
        fileprivate lazy var likeView = UIButton().then {
            $0.contentMode = .scaleAspectFit
            $0.addTarget(self, action: #selector(likeTap), for: .touchUpInside)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -60)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(16)
                make.right.equalTo(likeLabel.snp.left).offset(-5)
                make.centerY.equalTo(avatarView)
            }
        }
        
        fileprivate lazy var likeLabel = UILabel().then {
            $0.font = .regularPingFangSCFont(ofSize: 12)
            $0.textColor = color(0, 0, 0, 0.4)
            $0.isUserInteractionEnabled = true
            $0.textAlignment = .right
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeTap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(imageView)
                make.width.lessThanOrEqualTo(100)
                make.centerY.height.equalTo(avatarView)
            }
        }
        
        @objc func userTap() {
            UIManager.push(to: UserViewController().then {
                $0.userID = (feedItem?.user?.userID).nonnull
                $0.userInfo = feedItem?.user
            })
        }
        
        var feedItem: FeedItem?
        func bindModel(_ feedItem: FeedItem) {
            self.feedItem = feedItem
            guard let imageItem = feedItem.images.first else { return }
            imageView.setWebImage(url: OSSUploader.imageURLFor(imageItem.guid), cornerRadius: 12.0*3, finalSize: CGSize(width: imageItem.imageCollectionWidth*3.0, height: imageItem.imageCollectionHeight*3.0))
            videoCoverView.isHidden = !imageItem.isVideo
            textLabel.attributedText = feedItem.contentAttributedText
            avatarView.setWebImage(url: OSSUploader.avatarURLFor((feedItem.user?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
            nameLabel.text = feedItem.user?.userName
            likeLabel.text = feedItem.likesCount > 999 ? "999+" : "\(feedItem.likesCount)"
            likeView.setImage(feedItem.isLike ? UIImage(named: "ge_icon_nft_list_like") : UIImage(named: "ge_icon_nft_list_unlike"), for: .normal)
            likeLabel.textColor = feedItem.isLike ? color(255, 38, 111) : color(0, 0, 0, 0.4)
            imageView.snp.updateConstraints { make in
                make.height.equalTo(imageItem.imageCollectionHeight)
            }
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
        
        @objc func likeTap() {
            guard let feedItem = feedItem else { return }
            feedItem.isLike = !feedItem.isLike
            likeView.setImage(feedItem.isLike ? UIImage(named: "ge_icon_nft_list_like") : UIImage(named: "ge_icon_nft_list_unlike"), for: .normal)
            likeLabel.textColor = feedItem.isLike ? color(255, 38, 111) : color(0, 0, 0, 0.4)
            feedItem.likesCount = feedItem.isLike ? feedItem.likesCount + 1 : feedItem.likesCount - 1
            likeLabel.text = feedItem.likesCount > 999 ? "999+" : "\(feedItem.likesCount)"
            Network.request(feedItem.isLike ? FeedAPI.like : FeedAPI.cancelLike, parameters: ["feedId": feedItem.id]).responseData { response in
                if let error = response.error {
                    Toast.toast(title: error.localizedDescription)
                }
            }
        }
    }
}
