//
//  BusinessGoodsViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/16.
//

import Foundation
import BasicKit
import BasicUIKit
import UIKit
import APIKit

final class BusinessGoodsViewController: SegmentViewController, SegmentBarItem {
    
    //MARK: - Segment
    var segmentTitle: String { return "好物" }

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
        segmentStyle = .fixed
        segmentBarHeight = 45
        super.viewDidLoad()
        customBar.isHidden = true
        
        let searchView = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 4
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchBtnTap)))
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(40)
                make.top.equalTo(12)
            }
        }
        
        let searchIcon = UIImageView().then {
            $0.image = UIImage(named: "ge_icon_mall_search")
            searchView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(10)
                make.width.height.equalTo(24)
                make.centerY.equalToSuperview()
            }
        }
        
        let _ = UILabel().then {
            $0.text = "Autlx"
            $0.textColor = color(0, 0, 0, 0.3)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            searchView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(searchIcon.snp.right).offset(4)
                make.right.equalTo(-20)
                make.top.height.equalToSuperview()
            }
        }
        
        let filterBtn = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -12, left: 0, bottom: -12, right: 0)
            $0.setImage(UIImage(named: "ge_icon_mall_filter"), for: .normal)
            $0.addTarget(self, action: #selector(filterBtnTap), for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.centerY.equalTo(tabSegmentView)
                make.width.equalTo(60)
                make.height.equalTo(24)
            }
        }
        
        tabSegmentView.snp.remakeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(10)
            make.left.equalTo(view)
            make.right.equalTo(filterBtn.snp.left).offset(10)
            make.height.equalTo(segmentBarHeight)
        }
        
        pageViewController.view.snp.remakeConstraints { make in
            make.top.equalTo(tabSegmentView.snp.bottom)
            make.left.width.equalTo(view)
            make.height.equalTo(UIManager.shared.screenHeight)
        }
        
        Network.request(GoodsAPI.goodsCategoryList).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let data = (response.data?["list"] as? [Any])?.jsonString.data(using: .utf8),
                      let list = try? JSONDecoder().decode([GoodsCategoryItem].self, from: data) {
                self.bind(segments: list.compactMap {
                    let item = $0
                    return ChildDetailViewController().then { $0.categoryItem = item }
                })
            }
        }
    }

    @objc fileprivate func filterBtnTap() {
        UIManager.push(to: GoodsSectionListViewController())
    }
    
    @objc fileprivate func searchBtnTap() {
        UIManager.push(to: MagazineSearchViewController().then { $0.business = .goods })
    }
    
    class ChildDetailViewController: CollectionViewController, SegmentBarItem {
        
        //MARK: - Segment
        var segmentTitle: String {
            return categoryItem?.name ?? "推荐"
        }
        
        var normalColor: UIColor { color(0, 0, 0, 0.3) }
        var selectColor: UIColor { .black }
        var font: UIFont { UIFont.regularPingFangSCFont(ofSize: 14) }
        var selectFont: UIFont { .semiboldPingFangSCFont(ofSize: 18) }
        var viewController: UIViewController { self }
        var segmentPadding: CGFloat { 16 }
        var segmentMargin: CGFloat { 28 }
        var segmentIndicatorEnable: Bool { false }
        
        var categoryItem: GoodsCategoryItem?
        override func viewDidLoad() {
            showRefreshHeader = true
            showLoadMoreFooter = true
            triggerRefreshAutomatic = true
            triggerLoadMoreAutomatic = true
            
            let viewModel = InnerViewModel()
            viewModel.url = GoodsAPI.categoryGoodsList.rawValue
            viewModel.innerPara = ["goodsCategoryId": (categoryItem?.id).nonnull]
            self.viewModel = viewModel
            super.viewDidLoad()
            
            if let flowlayout = flowLayout as? CollectionWaterFlowLayout {
                flowlayout.contentInset = UIEdgeInsets(top: 10, left: 16, bottom: 360, right: 16)
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
        
        class InnerViewModel: NetworkViewModel {
            var innerPara: [String: Any]?
            override var parameters: [String : Any]? { innerPara }
            
            override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
                guard let data = data.jsonString.data(using: .utf8) else { return nil }
                do {
                    let result = try JSONDecoder().decode([GoodsItem].self, from: data)
                    if isLoadingMore {
                        var list = [GoodsItem]()
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
}
