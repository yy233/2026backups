//
//  CommunityFeedListViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/16.
//

import Foundation
import BasicUIKit
import UIKit
import BasicKit
import SnapKit
import PageControls
import APIKit
import AVFoundation
import VideoPlayerKit

final class CommunityFeedListViewController: TableViewController {
        
    var topicItem: TopicItem?
    var locationItem: LocationItem?
    
    private lazy var dispatcher = VideoPlayerDispatch(parentView: view, scrollView: tableView)

    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = CommunityContainerViewController.InnerViewModel()
        if let topicItem = topicItem {
            viewModel.url = FeedAPI.tagFeedList.rawValue
            viewModel.innerPara = ["id": topicItem.id, "sort": 0]
        } else if let locationItem = locationItem {
            viewModel.url = FeedAPI.locationFeedList.rawValue
            viewModel.innerPara = ["id": locationItem.id, "sort": 0]
        }
        self.viewModel = viewModel
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = topicItem?.name ?? locationItem?.name
        dispatcher.playWhenScrolling = true
        
        tableView?.register(cellWithClass: CommunityFeedCell.self)
        tableView?.isPagingEnabled = true
        tableView?.snp.makeConstraints({ make in
            make.top.equalTo(customBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
        
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
            cell.bindData(feedItem, style: .topic)
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
        cell.contentView.backgroundColor = .white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let feedItem = viewModel?.element(at: indexPath.section) as? FeedItem,
           let imageItem = feedItem.images.first {
            return max(imageItem.imageHeight + 80 + 12 + feedItem.contentHeight + (feedItem.hasExtra ? 79 : 49), tableView.height)
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let feedItem = viewModel?.element(at: indexPath.section) as? FeedItem {
            UIManager.push(to: CommunityFeedDetailViewController().then { $0.feedItem = feedItem })
        }
    }
}
