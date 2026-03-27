//
//  CommunityFeedDetailViewController.swift
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
import APIKit
import Combine
import ImagePreviewKit

final class CommunityFeedDetailViewController: TableViewController {
    
    var feedItem: FeedItem!
    private var cancelables = Set<AnyCancellable>()

    private let moreBtn = UIButton()
    private let likeView = UIButton()
    private let likeHighlightView = UIImageView()
    private let commentLabel = UILabel()
    private let likeLabel = UILabel()
    private let markView = UIButton()
    private let markLabel = UILabel()

    private lazy var dispatcher = VideoPlayerDispatch(parentView: view, scrollView: tableView)

    var communityItem: CommunityItem?
    
    deinit {
        dispatcher.checkVideoPlayerToStop()
    }
    
    override func viewDidLoad() {
        showRefreshHeader = false
        triggerRefreshAutomatic = false
        triggerLoadMoreAutomatic = true
        showEmptyPlaceholder = false
        let viewModel = InnerViewModel()
        viewModel.url = FeedAPI.commentList.rawValue
        viewModel.innerPara = ["feedId": feedItem.id]
        self.viewModel = viewModel
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = communityItem != nil ? "公告" : "动态"
        dispatcher.playWhenScrolling = true
        
        NotificationCenter.default.publisher(for: .notificationFeedDidDelete).sink {[unowned self] object in
            guard let feed = object.object as? FeedItem, feed.id == self.feedItem.id else { return }
            backBtnTapHandler()
        }.store(in: &cancelables)
        
        moreBtn.do {
            $0.setImage(UIImage(named: "lab_community_feed_detail_more"), for: .normal)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.addAction(UIAction() {[unowned self] _ in
                var titles = ["分享", "举报"]
                
                if communityItem?.manager?.contains(where: { $0.userID == AppContext.current.userID }) == true {
                    titles.append("删除公告")
                    titles.append("发布公告")
                } else if feedItem.user?.userID == AppContext.current.userID {
                    titles.append("删除")
                }
                
                ActionSheet.show(titles: titles) { index in
                    if index == 0 {
                        let items = ["我在这里发现一个超棒的内容，快来下载吧http://www.fmwworld.com", URL(string: "http://www.fmwworld.com").nonnull]
                        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
                        activityVC.modalPresentationStyle = .overFullScreen
                        UIManager.present(modal: activityVC)
                    } else if index == 1 {
                        let para: [String: Any] = ["beReportId": self.feedItem.id,
                                                   "type": 2,
                                                   "reason": ""]
                        Network.request(MainAPI.contentReport, parameters: para).responseEmpty()
                        Toast.toast(title: "举报成功")
                    } else if index == 2 {
                        HUD.show()
                        Network.request(FeedAPI.feedDelete, parameters: ["feedId": (self.feedItem?.id).nonnull]).responseData { response in
                            if let error = response.error {
                                Toast.toast(title: error.localizedDescription)
                            } else {
                                Toast.toast(title: "删除成功")
                                NotificationCenter.default.post(name: .notificationFeedDidDelete, object: self.feedItem)
                                self.dismiss(animated: false)
                            }
                        }
                    } else {
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
        
        let bottomBar = UIView().then {
            $0.backgroundColor = .white
            $0.layer.shadowOffset = CGSize(width: 0, height: -1)
            $0.layer.shadowColor = color(241, 243, 246).cgColor
            $0.layer.shadowRadius = 0
            $0.layer.shadowOpacity = 1.0
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(49)
                
                if UIManager.shared.isNotchScreen {
                    make.bottom.equalTo(-34)
                } else {
                    make.bottom.equalToSuperview()
                }
            }
        }
        
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        tableView?.register(cellWithClass: CommunityFeedDetailCell.self)
        tableView?.register(cellWithClass: CommunityFeedCommentCell.self)
        tableView?.snp.makeConstraints({ make in
            make.top.equalTo(customBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomBar.snp.top)
        })
        
        markLabel.do {
            $0.font = .regularPingFangSCFont(ofSize: 10)
            $0.textColor = .black
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(commentTap)))
            bottomBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16).priority(.required)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(14)
                make.top.equalTo(12)
            }
        }
        
        markView.do {
            $0.setImage(UIImage(named: "ge_icon_brand_detail_mark"), for: .normal)
            $0.addTarget(self, action: #selector(markTap), for: .touchUpInside)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -20)
            bottomBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.right.equalTo(markLabel.snp.left).offset(-2)
                make.top.equalTo(13)
            }
        }
        
        commentLabel.do {
            $0.font = .regularPingFangSCFont(ofSize: 10)
            $0.textColor = .black
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(commentTap)))
            bottomBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(markView.snp.left).offset(-16).priority(.required)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(14)
                make.top.equalTo(12)
            }
        }
        
        let commentView = UIImageView().then {
            $0.image = UIImage(named: "ge_icon_community_feed_detail_comment")
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(commentTap)))
            bottomBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.right.equalTo(commentLabel.snp.left).offset(-2)
                make.centerY.equalTo(markView)
            }
        }
        
        likeLabel.do {
            $0.font = .regularPingFangSCFont(ofSize: 10)
            $0.textColor = .black
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeTap)))
            bottomBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(commentView.snp.left).offset(-16)
                make.width.lessThanOrEqualTo(100)
                make.height.centerY.equalTo(commentLabel)
            }
        }
        
        likeView.do {
            $0.setImage(UIImage(named: "ge_icon_community_feed_detail_like"), for: .normal)
            $0.addTarget(self, action: #selector(likeTap), for: .touchUpInside)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -20)
            bottomBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.right.equalTo(likeLabel.snp.left).offset(-2)
                make.centerY.equalTo(commentView)
            }
        }
        
        likeHighlightView.do {
            $0.isHidden = true
            $0.image = UIImage(named: "ge_icon_community_feed_like")
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeTap)))
            bottomBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(32)
                make.centerX.equalTo(likeView)
                make.centerY.equalTo(likeView).offset(2)
            }
        }
        
        let inputBackView = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 8
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(commentTap)))
            bottomBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(likeView.snp.left).offset(-16)
                make.height.equalTo(36)
                make.top.equalTo(7)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "写个评论吧~"
            $0.font = .regularPingFangSCFont(ofSize: 12)
            $0.textColor = color(0, 0, 0, 0.4)
            inputBackView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.centerY.height.equalToSuperview()
                make.width.lessThanOrEqualTo(300)
            }
        }
        
        refreshFeed()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dispatcher.checkVideoPlayerToPlay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dispatcher.checkVideoPlayerToStop()
    }
    
    private func refreshFeed() {
        Network.request(FeedAPI.feedDetailInfo, parameters: ["feedId": feedItem.id]).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
                if (error as NSError).code == 301 {
                    self.backBtnTapHandler()
                }
            } else if let feed = try? JSONDecoder().decode(FeedItem.self, from: (response.data?.jsonData()).nonnull) {
                self.feedItem = feed
                self.commentLabel.text = feed.commentsCount > 999 ? "999+" : "\(feed.commentsCount)"
                self.likeLabel.text = feed.likesCount > 999 ? "999+" : "\(feed.likesCount)"
                self.likeLabel.textColor = feed.isLike ? color(255, 38, 111) : color(0, 0, 0)
                self.likeView.isHidden = feed.isLike
                self.likeHighlightView.isHidden = !feed.isLike
                self.markLabel.text = feed.markCount > 999 ? "999+" : "\(feed.markCount)"
                self.markView.setImage(feed.isMark ? UIImage(named: "ge_icon_brand_detail_mark_selected") : UIImage(named: "ge_icon_brand_detail_mark"), for: .normal)
                self.tableView?.reloadData()
                
                self.viewModel?.refresh(shouldLoadCache: false)
            }
        }
    }
    
    @objc private func likeTap() {
        feedItem.isLike = !feedItem.isLike
        likeView.isHidden = feedItem.isLike
        likeHighlightView.isHidden = !likeView.isHidden
        likeLabel.textColor = feedItem.isLike ? color(255, 38, 111) : color(0, 0, 0)
        feedItem.likesCount = feedItem.isLike ? feedItem.likesCount + 1 : feedItem.likesCount - 1
        likeLabel.text = feedItem.likesCount > 999 ? "999+" : "\(feedItem.likesCount)"

        Network.request(feedItem.isLike ? FeedAPI.like : FeedAPI.cancelLike, parameters: ["feedId": feedItem.id]).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            }
        }
        NotificationCenter.default.post(name: .notificationFeedDidLikeUpdate, object: feedItem)
    }
    
    @objc private func markTap() {
        feedItem.isMark = !feedItem.isMark
        feedItem.markCount = feedItem.isMark ? feedItem.markCount + 1 : feedItem.markCount - 1
        markLabel.text = feedItem.markCount > 999 ? "999+" : "\(feedItem.markCount)"
        markView.setImage(feedItem.isMark ? UIImage(named: "ge_icon_brand_detail_mark_selected") : UIImage(named: "ge_icon_brand_detail_mark"), for: .normal)
        Network.request(feedItem.isMark ? FeedAPI.mark : FeedAPI.cancelMark, parameters: ["feedId": feedItem.id]).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            }
        }
        NotificationCenter.default.post(name: .notificationFeedDidMarkUpdate, object: feedItem)
    }
    
    @objc private func commentTap() {
        UIManager.present(modal: CommentInputViewController().then {
            $0.modalPresentationStyle = .overFullScreen
            $0.feedItem = self.feedItem
            $0.didSubmitHandler = { comment in
                comment.isFeedOwner = comment.user?.userID == self.feedItem.user?.userID
                if comment.reply == nil {
                    comment.reply = CommentReplyResponse()
                }
                self.feedItem.commentsCount += 1
                self.commentLabel.text = self.feedItem.commentsCount > 999 ? "999+" : "\(self.feedItem.commentsCount)"
                self.viewModel?.insert(comment, at: 0)
                self.tableView?.reloadData()
                self.tableView?.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: false)
                NotificationCenter.default.post(name: .notificationFeedDidCommentUpdate, object: self.feedItem)
            }
        }, animated: false)
    }
    
    @objc private func shareTap() {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (viewModel?.numberOfElements).nonnull + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if let comment = viewModel?.element(at: section - 1) as? CommentItem {
            return 1 + (comment.reply?.list.count).nonnull
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: CommunityFeedDetailCell.self)
            cell.bindData(feedItem)
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = .white
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withClass: CommunityFeedCommentCell.self)
        if let comment = viewModel?.element(at: indexPath.section - 1) as? CommentItem, let replyResponse = comment.reply {
            comment.isFeedOwner = comment.user?.userID == feedItem.user?.userID
            if indexPath.row > 0 {
                if let reply = comment.reply?.list[safe: indexPath.row - 1] {
                    if indexPath.row == replyResponse.list.count, replyResponse.hasNext {
                        cell.bindData(reply, moreCount: replyResponse.total - replyResponse.list.count)
                    } else {
                        cell.bindData(reply, moreCount: 0)
                    }
                }
            } else if replyResponse.hasNext , replyResponse.list.count == 0 {
                cell.bindData(comment, moreCount: replyResponse.total - replyResponse.list.count)
            } else {
                cell.bindData(comment, moreCount: 0)
            }
        }
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .white
        cell.didReplyTap = {[weak self, weak cell] in
            guard let strongCell = cell, let strongSelf = self,
                    let indexPath = strongSelf.tableView?.indexPath(for: strongCell),
                  let superComment = strongSelf.viewModel?.element(at: indexPath.section - 1) as? CommentItem else { return }
            UIManager.present(modal: CommentInputViewController().then {
                $0.modalPresentationStyle = .overFullScreen
                $0.feedItem = strongSelf.feedItem
                $0.toUser = strongCell.commentItem?.user
                $0.commentItem = superComment
                $0.didSubmitHandler = { comment in
                    strongSelf.feedItem.commentsCount += 1
                    strongSelf.commentLabel.text = strongSelf.feedItem.commentsCount > 999 ? "999+" : "\(strongSelf.feedItem.commentsCount)"
                    superComment.reply?.list.insert(comment, at: 0)
                    superComment.reply?.total = (superComment.reply?.total).nonnull + 1
                    strongSelf.tableView?.reloadData()
                    strongSelf.tableView?.scrollToRow(at: IndexPath(row: 1, section: indexPath.section), at: .top, animated: false)
                    NotificationCenter.default.post(name: .notificationFeedDidCommentUpdate, object: strongSelf.feedItem)
                }
            }, animated: false)
        }
        
        cell.didMoreTap = {[weak self, weak cell] in
            guard let strongCell = cell, let strongSelf = self,
                  let indexPath = strongSelf.tableView?.indexPath(for: strongCell),
                  let superComment = strongSelf.viewModel?.element(at: indexPath.section - 1) as? CommentItem
            else { return }
            
            if let response = superComment.reply, response.hasNext {
                HUD.show()
                Network.request(FeedAPI.replyList, parameters: ["feedId": superComment.feedId, "commentId": superComment.id, "offset": response.nextOffset]).responseData { response in
                    HUD.hide()
                    if let error = response.error {
                        Toast.toast(title: error.localizedDescription)
                    } else if let data = response.data?.jsonData(), let result = try? JSONDecoder().decode(CommentReplyResponse.self, from: data) {
                        if let reply = superComment.reply {
                            reply.hasNext = result.hasNext
                            reply.nextOffset = result.nextOffset
                            
                            for item in result.list {
                                if !reply.list.contains(where: { $0.id == item.id }) {
                                    reply.list.append(item)
                                }
                            }
                        }
                        strongSelf.tableView?.reloadData()
                    }
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let imageItem = feedItem.images.first {
                return 85 + imageItem.imageHeight + (feedItem.content.nonnull.isEmpty ? 0 : feedItem.contentHeight + 12) + (feedItem.hasExtra ? 30 : 0) + 91
            }
            return CGFloat.leastNormalMagnitude
        }
        
        if let comment = viewModel?.element(at: indexPath.section - 1) as? CommentItem {
            if indexPath.row > 0 {
                if let reply = comment.reply?.list[safe: indexPath.row - 1] {
                    if indexPath.row == (comment.reply?.list.count).nonnull, comment.reply?.hasNext == true {//显示展开
                        return 40 + reply.contentHeight + 23 + 33 + 20
                    }
                    return 40 + reply.contentHeight + 23 + 20
                }
            } else if comment.reply?.hasNext == true && comment.reply?.list.count == 0 { //显示展开
                return 24 + comment.contentHeight + 23 + 33 + 20
            } else {
                return 24 + comment.contentHeight + 23 + 20
            }
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CommunityFeedCommentCell, let commentItem = cell.commentItem {
            if commentItem.user?.userID == AppContext.current.userID ||
                feedItem.user?.userID == AppContext.current.userID {
                ActionSheet.show(titles: ["删除"]) { _ in
                    HUD.show()
                    Network.request(FeedAPI.commentDelete, parameters: ["feedId": commentItem.feedId, "commentId": commentItem.id]).responseData { response in
                        HUD.hide()
                        if let error = response.error {
                            Toast.toast(title: error.localizedDescription)
                        } else {
                            Toast.toast(title: "删除成功")
                            self.feedItem.commentsCount -= 1
                            self.commentLabel.text = self.feedItem.commentsCount > 999 ? "999+" : "\(self.feedItem.commentsCount)"
                            
                            if commentItem.isReply {
                                if let parent = self.viewModel?.element(at: indexPath.section - 1) as? CommentItem {
                                    parent.reply?.list.removeAll(where: { $0.id == commentItem.id })
                                    self.tableView?.reloadData()
                                }
                            } else {
                                self.viewModel?.remove(commentItem)
                                self.tableView?.reloadData()
                            }
                            
                            NotificationCenter.default.post(name: .notificationFeedDidCommentUpdate, object: self.feedItem)
                        }
                    }
                }
            } else {
                ActionSheet.show(titles: ["举报"]) { index in
                    let para: [String: Any] = ["beReportId": commentItem.id,
                                               "type": 3,
                                               "reason": ""]
                    Network.request(MainAPI.contentReport, parameters: para).responseEmpty()
                    Toast.toast(title: "举报成功")
                }
            }
        }
    }
    
    fileprivate class InnerViewModel: NetworkViewModel {
        var innerPara: [String: Any]?
        override var parameters: [String : Any]? { innerPara }
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([CommentItem].self, from: data)
                if isLoadingMore {
                    var list = [CommentItem]()
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

fileprivate class CommunityFeedDetailCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    lazy var avatarView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTap)))
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(16)
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
            make.right.equalTo(-14)
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
    
    lazy var timeLabel = UILabel().then {
        $0.font = .regularPingFangSCFont(ofSize: 12)
        $0.textColor = color(0, 0, 0, 0.4)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(avatarView)
            make.right.equalTo(-16)
            make.height.equalTo(17)
            make.bottom.equalTo(commentLabel.snp.top).offset(-28)
        }
    }
    
    lazy var commentLabel = UILabel().then {
        $0.font = .mediumPingFangSCFont(ofSize: 16)
        $0.textColor = .black
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(avatarView)
            make.right.equalTo(-16)
            make.height.equalTo(22)
            make.bottom.equalTo(-12)
        }
    }
    
    var feedItem: FeedItem!
    func bindData(_ feedItem: FeedItem) {
        self.feedItem = feedItem
        titleLabel.text = feedItem.user?.userName
        descLabel.text = (feedItem.user?.introduction).nonnull.isEmpty ? "这个人很懒，吃饭都要靠别人喂" : feedItem.user?.introduction
        avatarView.setWebImage(url: OSSUploader.avatarURLFor((feedItem.user?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
        commentLabel.text = "共\(feedItem.commentsCount)条评论"
        timeLabel.text = "发布于\(Date(timeIntervalSince1970: feedItem.createTime/1000.0).displayString())" + (feedItem.city.nonnull.isNotEmpty ? " · \(feedItem.city.nonnull)" : "")
        
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
        
        communityBtn.snp.remakeConstraints { make in
            make.left.equalTo(avatarView)
            make.width.greaterThanOrEqualTo(32)
            make.height.equalTo(22)
            
            if contentLabel.isHidden {
                make.top.equalTo(collectionView.snp.bottom).offset(8)
            } else {
                make.top.equalTo(contentLabel.snp.bottom).offset(8)
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
    }
    
    @objc private func userTap() {
        UIManager.push(to: UserViewController().then {
            $0.userID = (feedItem.user?.userID).nonnull
            $0.userInfo = feedItem?.user
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItem.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let imageItem = feedItem.images.first else { return collectionView.size }
        return CGSize(width: UIManager.shared.screenWidth, height: imageItem.imageHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
        let item = feedItem.images[indexPath.item]
        cell.imageView.setWebImage(url: OSSUploader.imageURLFor(item.guid), cornerRadius: 16*3.0, finalSize: CGSize(width: item.imageWidth*3.0, height: item.imageHeight*3.0))
        cell.contentView.backgroundColor = .white
    
        if item.isVideo {
            cell.playerView.isHidden = false
            cell.playerView.bind(playerItem: VideoPlayerItem(identifier: feedItem.id, parentIdenfifier: "\(CommunityFeedDetailViewController.self).\(ImageCollectionCell.self).\(collectionView)", videoURL: URL(string: OSSUploader.videoURLFor(item.guid)).nonnull, thumbnailURL: URL(string: OSSUploader.imageURLFor(item.guid)).nonnull, contentMode: .scaleAspectFill, extra: nil))
        } else {
            cell.playerView.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.progress = CGFloat(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionCell {
            let item = feedItem.images[indexPath.item]
            if item.isVideo {
                let playerItem = VideoPlayerItem(identifier: feedItem.id, parentIdenfifier: "\(VideoPlayerViewController.self).\(item.guid)", videoURL: URL(string: OSSUploader.videoURLFor(item.guid)).nonnull, thumbnailURL: URL(string: OSSUploader.imageURLFor(item.guid)).nonnull, contentMode: .scaleAspectFill, extra: nil)
                UIManager.push(to: VideoPlayerViewController(playerItem: playerItem))
            } else {
                ImagePreview.previewPhotos([OSSUploader.imageURLFor(item.guid, crop: .origin)], fromView: cell.imageView)
            }
        }
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
            playerView.prepareForReuse()
        }
    }
}

fileprivate class CommunityFeedCommentCell: UITableViewCell {
    lazy var avatarView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTap)))
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalToSuperview()
            make.width.height.equalTo(48)
        }
    }
    
    lazy var titleLabel = UILabel().then {
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTap)))
        $0.textColor = color(0, 0, 0, 0.6)
        $0.font = .regularPingFangSCFont(ofSize: 14)
        $0.textAlignment = .left
        contentView.addSubview($0)
    }
    
    lazy var contentLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 0
        contentView.addSubview($0)
    }
    
    lazy var timeLabel = UIButton().then {
        $0.setTitleColor(color(0, 0, 0, 0.4), for: .normal)
        $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -20, right: -10)
        $0.addAction(UIAction() { _ in
            self.didReplyTap?()
        }, for: .touchUpInside)
        contentView.addSubview($0)
    }
    
    lazy var ownerBtn = UIButton().then {
        $0.backgroundColor = color(245, 245, 245)
        $0.layer.cornerRadius = 4
        $0.setTitle("作者", for: .normal)
        $0.setTitleColor(color(0, 0, 0, 0.6), for: .normal)
        $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 10)
        $0.isHidden = true
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(4)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(28)
            make.height.equalTo(16)
        }
    }
    
    lazy var moreBtn = UIButton().then {
        $0.setTitleColor(color(51, 186, 255), for: .normal)
        $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
        $0.isHidden = true
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
        $0.addAction(UIAction() { _ in
            self.didMoreTap?()
        }, for: .touchUpInside)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(contentLabel)
            make.bottom.equalTo(-20)
            make.width.lessThanOrEqualTo(200)
            make.height.equalTo(17)
        }
    }
    
    lazy var moreImageView = UIImageView().then {
        $0.image = UIImage(named: "lab_feed_detail_reply_more")
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(moreBtn.snp.right).offset(4)
            make.width.height.equalTo(12)
            make.centerY.equalTo(moreBtn)
        }
    }
    
    var didReplyTap: PureCompletionHandler?
    var didMoreTap: PureCompletionHandler?
    var commentItem: CommentItem?
    func bindData(_ commentItem: CommentItem, moreCount: Int) {
        self.commentItem = commentItem
        avatarView.setWebImage(url: OSSUploader.avatarURLFor((commentItem.user?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
        titleLabel.text = commentItem.user?.userName
        contentLabel.attributedText = commentItem.contentAttributedText
        timeLabel.setTitle(Date(timeIntervalSince1970: commentItem.time/1000.0).displayString() + (commentItem.location.nonnull.isNotEmpty ? " · \(commentItem.location.nonnull)" : "") + "   回复", for: .normal)
        ownerBtn.isHidden = !commentItem.isFeedOwner
        
        if moreCount > 0 {
            moreBtn.isHidden = false
            moreImageView.isHidden = false
            moreBtn.setTitle("展开\(moreCount)条评论", for: .normal)
        } else {
            moreBtn.isHidden = true
            moreImageView.isHidden = true
        }
        
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
        
        guard let commentItem = commentItem else { return }
        
        if commentItem.isReply {
            avatarView.snp.updateConstraints { make in
                make.left.equalTo(76)
                make.width.height.equalTo(28)
            }
            
            titleLabel.snp.remakeConstraints { make in
                make.left.equalTo(avatarView.snp.right).offset(10)
                make.width.lessThanOrEqualTo(200)
                make.height.equalTo(20)
                make.centerY.equalTo(avatarView)
            }
            
            contentLabel.snp.remakeConstraints { make in
                make.left.equalTo(avatarView)
                make.right.equalTo(-16)
                make.height.equalTo(commentItem.contentHeight)
                make.top.equalTo(avatarView.snp.bottom).offset(12)
            }
            
            if !moreBtn.isHidden {
                timeLabel.snp.remakeConstraints { make in
                    make.left.equalTo(contentLabel)
                    make.bottom.equalTo(moreBtn.snp.top).offset(-16)
                    make.right.lessThanOrEqualTo(-16)
                    make.height.equalTo(17)
                }
            } else {
                timeLabel.snp.remakeConstraints { make in
                    make.left.equalTo(contentLabel)
                    make.bottom.equalTo(-20)
                    make.right.lessThanOrEqualTo(-16)
                    make.height.equalTo(17)
                }
            }
        } else {
            avatarView.snp.updateConstraints { make in
                make.left.equalTo(16)
                make.width.height.equalTo(48)
            }
            
            titleLabel.snp.remakeConstraints { make in
                make.left.equalTo(avatarView.snp.right).offset(12)
                make.width.lessThanOrEqualTo(200)
                make.height.equalTo(20)
                make.top.equalTo(avatarView).offset(2)
            }
            
            contentLabel.snp.remakeConstraints { make in
                make.left.equalTo(titleLabel)
                make.right.equalTo(-16)
                make.height.equalTo(commentItem.contentHeight)
                make.top.equalTo(titleLabel.snp.bottom).offset(4)
            }
            
            if !moreBtn.isHidden {
                timeLabel.snp.remakeConstraints { make in
                    make.left.equalTo(contentLabel)
                    make.bottom.equalTo(moreBtn.snp.top).offset(-16)
                    make.right.lessThanOrEqualTo(-16)
                    make.height.equalTo(17)
                }
            } else {
                timeLabel.snp.remakeConstraints { make in
                    make.left.equalTo(contentLabel)
                    make.bottom.equalTo(-20)
                    make.right.lessThanOrEqualTo(-16)
                    make.height.equalTo(17)
                }
            }
        }
    }
    
    @objc private func userTap() {
        UIManager.push(to: UserViewController().then {
            $0.userID = (commentItem?.user?.userID).nonnull
            $0.userInfo = commentItem?.user
        })
    }
}
