//
//  UserMarkFeedsViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/9.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit

class UserMarkFeedsViewController: CollectionViewController {
    
    var userID: String = ""
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = CommunityContainerViewController.InnerViewModel()
        viewModel.url = FeedAPI.markList.rawValue
        viewModel.innerPara = ["remoteId": userID]
        self.viewModel = viewModel
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "收藏的动态"
        
        if let flowlayout = flowLayout as? CollectionWaterFlowLayout {
            flowlayout.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 60, right: 16)
            flowlayout.columnCount = 2
            flowlayout.columnSpacing = 13
            flowlayout.lineSpacing = 18
            flowlayout.indexPathHeightHandler = {indexPath,width in
                guard let feedItem = viewModel.element(at: indexPath.item) as? FeedItem, let item = feedItem.images.first else { return width }
                return item.imageCollectionHeight + feedItem.contentCollectionHeight + 38
            }
        }
        
        collectionView?.register(cellWithClass: FeedCollectionViewController.ImageCollectionCell.self)
        collectionView?.snp.makeConstraints({ make in
            make.top.equalTo(customBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
        
        NotificationCenter.default.publisher(for: .notificationFeedDidLikeUpdate).sink {[unowned self] object in
            guard let feed = object.object as? FeedItem else { return }
            if let currentFeed = viewModel.element(for: feed.uniqueIdentifier) as? FeedItem {
                currentFeed.likesCount = feed.likesCount
                currentFeed.isLike = feed.isLike
                collectionView?.reloadData()
            }
        }.store(in: &cancellableList)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: FeedCollectionViewController.ImageCollectionCell.self, for: indexPath)
        cell.contentView.backgroundColor = collectionView.backgroundColor
        if let feedItem = viewModel?.element(at: indexPath.item) as? FeedItem {
            cell.bindModel(feedItem)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let feedItem = viewModel?.element(at: indexPath.item) as? FeedItem {
            UIManager.push(to: CommunityFeedDetailViewController().then { $0.feedItem = feedItem })
        }
    }
}
