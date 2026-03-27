//
//  NFTListViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/12.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import APIKit
import Alamofire

final class NFTMallViewController: SegmentViewController {
    
    override func viewDidLoad() {
        segmentStyle = .fixed
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "NFT市场"
        
        let _ = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -16, left: -16, bottom: -16, right: -16)
            $0.setTitle("我的委托", for: .normal)
            $0.setTitleColor(color(51, 186, 255), for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
            $0.addAction(UIAction() { _ in
                UIManager.push(to: NFTOwnProxyContainerViewController())
            }, for: .touchUpInside)
            customBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.equalTo(48)
                make.height.equalTo(17)
                make.centerY.equalTo(customBackBtn)
            }
        }
        
        let backView = UIButton().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 8.0
            $0.addAction(UIAction() { _ in
                UIManager.push(to: MagazineSearchViewController().then { $0.business = .nft })
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(customBar.snp.bottom).offset(12)
                make.height.equalTo(38)
            }
        }
        
        let _ = UIImageView().then {
            $0.image = UIImage(named: "ge_icon_main_left_search")
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(16)
                make.left.equalTo(16)
                make.centerY.equalToSuperview()
            }
        }
        
        let _ = UILabel().then {
            $0.text = "搜索您想要的藏品"
            $0.textColor = color(179, 179, 179)
            $0.font = .regularPingFangSCFont(ofSize: 12)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(38)
                make.top.bottom.equalToSuperview()
                make.right.equalTo(-16)
            }
        }
        
        tabSegmentView.snp.remakeConstraints { make in
            make.left.width.equalTo(view)
            make.top.equalTo(backView.snp.bottom).offset(10)
            make.height.equalTo(segmentBarHeight)
        }
        
        Network.request(NFTAPI.typeList, encoding: URLEncoding.default).responseData {[weak self] response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let list = response.data?["list"] as? [Any], let data = list.jsonString.data(using: .utf8),
                      let result = try? JSONDecoder().decode([NFTClassificationItem].self, from: data) {
                
                var viewControllers = [NFTListViewController]()
                let nftVC = NFTListViewController().then {
                    $0.name = "全部"
                    let viewModel = InnerViewModel()
                    viewModel.url = NFTAPI.mallList.rawValue
                    viewModel.innerPara = ["classificationId": "all"]
                    $0.viewModel = viewModel
                }
                viewControllers.append(nftVC)
                
                for item in result {
                    let nftVC = NFTListViewController().then {
                        $0.name = item.classificationName
                        let viewModel = InnerViewModel()
                        viewModel.url = NFTAPI.mallList.rawValue
                        viewModel.innerPara = ["classificationId": item.classificationId]
                        $0.viewModel = viewModel
                    }
                    viewControllers.append(nftVC)
                }
                self?.bind(segments: viewControllers)
            }
        }
    }
    
    struct InnerItem: Codable, IdentifierElement {
        var id: String = ""
        var nftInfo: NFTInfo?
        var type: String?
        
        var uniqueIdentifier: String { id }
        
        enum CodingKeys: String, CodingKey {
            case id = "goodsId"
            case nftInfo = "nftGoods"
            case type
        }
    }
    
    class InnerViewModel: NetworkViewModel {
        var innerPara: [String: Any]?
        override var parameters: [String : Any]? { innerPara }
        
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([InnerItem].self, from: data)
                if isLoadingMore {
                    var list = [InnerItem]()
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

fileprivate class NFTListViewController: CollectionViewController, SegmentBarItem {
    
    //MARK: - Segment
    var segmentTitle: String {
        return name
    }

    var name: String = ""
    var normalColor: UIColor { color(0, 0, 0, 0.3) }
    var selectColor: UIColor { .black }
    var font: UIFont { UIFont.semiboldPingFangSCFont(ofSize: 16) }
    var selectFont: UIFont { .semiboldPingFangSCFont(ofSize: 16) }
    var viewController: UIViewController { self }
    var segmentPadding: CGFloat { 16 }
    var segmentMargin: CGFloat { 48 }
    var segmentIndicatorEnable: Bool { true }
    var segmentIndicatorImage: UIImage? { UIImage(named: "lab_tab_segment_line") }
    var segmentIndicatorHeight: CGFloat { 7.6 }

    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        super.viewDidLoad()
        
        if let flowlayout = flowLayout as? CollectionWaterFlowLayout {
            flowlayout.contentInset = UIEdgeInsets(top: 15, left: 16, bottom: 60, right: 16)
            flowlayout.columnCount = 2
            flowlayout.columnSpacing = 13
            flowlayout.lineSpacing = 15
            flowlayout.indexPathHeightHandler = {[unowned self] indexPath,width in
                if let media = viewModel?.element(at: indexPath.item) as? NFTMallViewController.InnerItem,
                    let cover = media.nftInfo?.cover {
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
        if let item = viewModel?.element(at: indexPath.item) as? NFTMallViewController.InnerItem,
           let info = item.nftInfo, let cover = info.cover {
            let imageWidth = (UIManager.shared.screenWidth - 16*2 - 13)/2.0
            let imageHeight = max(1, cover.ht.nonnull)/max(1, cover.wt.nonnull)*imageWidth
            cell.imageView.setWebImage(url: OSSUploader.imageNFTURLFor(cover.guid, crop: .medium), cornerRadius: 12*3.0, finalSize: CGSize(width: imageWidth*3.0, height: imageHeight*3.0))
            cell.textLabel.text = info.name
            cell.pointsLabel.setTitle(info.minDealPrice.nonnull > 0 ? "\(info.minDealPrice.nonnull)积分" : "暂无成交", for: .normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = viewModel?.element(at: indexPath.item) as? NFTMallViewController.InnerItem,
           let info = item.nftInfo {
            UIManager.push(to: NFTDetailViewController().then {
                $0.nftInfo = info
            })
        }
    }
}

