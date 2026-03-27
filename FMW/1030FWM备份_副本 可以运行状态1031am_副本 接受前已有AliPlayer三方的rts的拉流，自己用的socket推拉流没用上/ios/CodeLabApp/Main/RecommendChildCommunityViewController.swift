//
//  RecommendChildCommunityViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/13.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit

struct RecommendFeedChildCommunityItem: Codable, IdentifierElement {
    var id = ""
    var icon: String?
    var name: String?
    
    var uniqueIdentifier: String { id }
    
    enum CodingKeys: CodingKey {
        case id
        case icon
        case name
    }
}

final class RecommendChildCommunityViewController: CollectionViewController {
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = InnerViewModel()
        viewModel.url = MainAPI.recommendCommunity.rawValue
        self.viewModel = viewModel
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "热门社区"
        
        if let flowlayout = flowLayout as? CollectionWaterFlowLayout {
            flowlayout.contentInset = UIEdgeInsets(top: 15, left: 16, bottom: 60, right: 16)
            flowlayout.columnCount = 2
            flowlayout.columnSpacing = 13
            flowlayout.lineSpacing = 15
            flowlayout.indexPathHeightHandler = { _,width in
                return width
            }
        }
        
        collectionView?.register(cellWithClass: CollectionCell.self)
        collectionView?.snp.makeConstraints({ make in
            make.top.equalTo(customBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CollectionCell.self, for: indexPath)
        cell.contentView.backgroundColor = .white
        if let data = viewModel?.element(at: indexPath.item) as? RecommendFeedChildCommunityItem {
            let width = (UIManager.shared.screenWidth - 16*2 - 13)/2.0
            cell.backView.image = nil
            cell.backView.setWebImage(url: OSSUploader.avatarURLFor(data.icon.nonnull, crop: .medium), cornerRadius: 16.0*3, finalSize: CGSize(width: width*3.0, height: width*3.0))
            cell.nameLabel.text = "#\(data.name.nonnull)"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = viewModel?.element(at: indexPath.item) as? RecommendFeedChildCommunityItem {
            UIManager.push(to: FeedChildCommunityDetailViewController().then {
                var item = CommunityItem()
                item.id = data.id
                item.image = data.icon.nonnull
                item.name = data.name.nonnull
                $0.communityItem = item
            })
        }
    }
    
    fileprivate class InnerViewModel: NetworkViewModel {
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([RecommendFeedChildCommunityItem].self, from: data)
                if isLoadingMore {
                    var list = [RecommendFeedChildCommunityItem]()
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
    
    fileprivate class CollectionCell: UICollectionViewCell {
        lazy var backView = UIImageView().then {
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        lazy var backCoverView = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.3)
            $0.layer.cornerRadius = 16.0
            contentView.insertSubview($0, aboveSubview: backView)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        lazy var nameLabel = UILabel().then {
            $0.font = .semiboldPingFangSCFont(ofSize: 18)
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.textColor = .white
            backCoverView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
    }
}

