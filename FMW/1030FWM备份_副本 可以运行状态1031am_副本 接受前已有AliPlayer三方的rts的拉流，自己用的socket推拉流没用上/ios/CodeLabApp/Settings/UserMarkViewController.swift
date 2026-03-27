//
//  UserMarkViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/17.
//

import Foundation
import BasicUIKit
import APIKit
import BasicKit

class UserMarkViewController: SegmentViewController {
    var index = 0
    var userID: String = ""
    override func viewDidLoad() {
        segmentStyle = .navigation
        segmentBarHeight = 40
        super.viewDidLoad()
        customBackBtn.isHidden = false

        bind(segments: [MarkNFTViewController().then { $0.userID = userID },
                        MarkGoosViewController().then { $0.userID = userID }])
    }
    
    override func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        .at(index: index)
    }
    
    fileprivate class MarkGoosViewController: CollectionViewController, SegmentBarItem {
        
        //MARK: - Segment
        var segmentTitle: String {
            return "好物"
        }
        
        var normalColor: UIColor { color(0, 0, 0, 0.3) }
        var selectColor: UIColor { .black }
        var font: UIFont { .mediumPingFangSCFont(ofSize: 18) }
        var selectFont: UIFont { .semiboldPingFangSCFont(ofSize: 18) }
        var viewController: UIViewController { self }
        var segmentPadding: CGFloat { 20 }
        var segmentMargin: CGFloat { 20 }
        var segmentIndicatorEnable: Bool { false }
        var userID: String?
        
        override func viewDidLoad() {
            triggerRefreshAutomatic = true
            triggerLoadMoreAutomatic = true
            
            let viewModel = BusinessGoodsViewController.ChildDetailViewController.InnerViewModel()
            viewModel.url = GoodsAPI.goodsMarkList.rawValue
            viewModel.innerPara = ["remoteId": userID.nonnull]
            self.viewModel = viewModel
            super.viewDidLoad()
            
            if let flowlayout = flowLayout as? CollectionWaterFlowLayout {
                flowlayout.contentInset = UIEdgeInsets(top: 10, left: 16, bottom: 60, right: 16)
                flowlayout.columnCount = 2
                flowlayout.columnSpacing = 13
                flowlayout.lineSpacing = 18
                flowlayout.indexPathHeightHandler = {_,width in
                    return width + 72
                }
            }
            
            collectionView?.register(cellWithClass: GoodsCollectionCell.self)
            collectionView?.snp.makeConstraints({ make in
                make.top.left.right.bottom.equalToSuperview()
            })
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withClass: GoodsCollectionCell.self, for: indexPath)
            cell.contentView.backgroundColor = .white

            if let item = viewModel?.element(at: indexPath.item) as? GoodsItem {
                cell.imageView.setWebImage(url: (item.cover?.guid).nonnull)
                cell.textLabel.text = item.name
                cell.priceLabel.text = String(format: "￥ %.2f", item.price.nonnull)
            }
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let item = viewModel?.element(at: indexPath.item) as? GoodsItem {
                UIManager.push(to: GoodsDetailViewController().then { $0.goodItem = item })
            }
        }
    }
    
    fileprivate class MarkNFTViewController: CollectionViewController, SegmentBarItem {
        
        //MARK: - Segment
        var segmentTitle: String {
            return "数藏"
        }
        
        var normalColor: UIColor { color(0, 0, 0, 0.3) }
        var selectColor: UIColor { .black }
        var font: UIFont { .mediumPingFangSCFont(ofSize: 18) }
        var selectFont: UIFont { .semiboldPingFangSCFont(ofSize: 18) }
        var viewController: UIViewController { self }
        var segmentPadding: CGFloat { 20 }
        var segmentMargin: CGFloat { 20 }
        var segmentIndicatorEnable: Bool { false }
        var userID: String?

        override func viewDidLoad() {
            triggerRefreshAutomatic = true
            triggerLoadMoreAutomatic = true
            let viewModel = InnerViewModel()
            viewModel.url = NFTAPI.markNFTList.rawValue
            viewModel.innerPara = ["remoteId": userID.nonnull]
            self.viewModel = viewModel
            super.viewDidLoad()
            
            if let flowlayout = flowLayout as? CollectionWaterFlowLayout {
                flowlayout.contentInset = UIEdgeInsets(top: 15, left: 16, bottom: 60, right: 16)
                flowlayout.columnCount = 2
                flowlayout.columnSpacing = 13
                flowlayout.lineSpacing = 15
                flowlayout.indexPathHeightHandler = { indexPath,width in
                    if let info = viewModel.element(at: indexPath.item) as? NFTInfo, let cover = info.cover {
                        let imageHeight = max(1, cover.ht.nonnull)/max(1, cover.wt.nonnull)*width
                        return imageHeight + 30
                    }
                    return width + 30
                }
            }
            
            collectionView?.register(cellWithClass: NFTCollectionCell.self)
            collectionView?.snp.makeConstraints({ make in
                make.top.left.right.bottom.equalToSuperview()
            })
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withClass: NFTCollectionCell.self, for: indexPath)
            cell.contentView.backgroundColor = .white
            if let info = viewModel?.element(at: indexPath.item) as? NFTInfo, let cover = info.cover {
                let imageWidth = (UIManager.shared.screenWidth - 16*2 - 13)/2.0
                let imageHeight = max(1, cover.ht.nonnull)/max(1, cover.wt.nonnull)*imageWidth
                cell.imageView.setWebImage(url: OSSUploader.imageNFTURLFor((info.cover?.guid).nonnull, crop: .medium), cornerRadius: 12*3.0, finalSize: CGSize(width: imageWidth*3.0, height: imageHeight*3.0))
                cell.textLabel.text = info.name
                cell.pointsLabel.isHidden = true
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let info = viewModel?.element(at: indexPath.item) as? NFTInfo {
                UIManager.push(to: NFTDetailViewController().then {
                    $0.nftInfo = info
                })
            }
        }
    }
    
    fileprivate class InnerViewModel: NetworkViewModel {
        var innerPara: [String: Any]?
        override var parameters: [String : Any]? { innerPara }
        
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([NFTInfo].self, from: data)
                if isLoadingMore {
                    var list = [NFTInfo]()
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
