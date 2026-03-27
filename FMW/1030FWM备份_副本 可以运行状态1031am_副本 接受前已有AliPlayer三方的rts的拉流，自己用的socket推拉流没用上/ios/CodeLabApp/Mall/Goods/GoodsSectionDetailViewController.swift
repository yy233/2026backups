//
//  GoodsSectionDetailViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/16.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import YYImage

final class GoodsSectionDetailViewController: CollectionViewController {
    
    var typeItem: GoodsTypeItem?
    
    private let priceArrowView = UIImageView()
    private let hotBtn = UIButton()
    private let newBtn = UIButton()
    private let priceBtn = UIButton()
    
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = BusinessGoodsViewController.ChildDetailViewController.InnerViewModel()
        viewModel.url = GoodsAPI.typeGoodsList.rawValue
        viewModel.innerPara = ["goodsTypeId": (typeItem?.id).nonnull, "sort": "hot"]
        self.viewModel = viewModel
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = typeItem?.name
        
        hotBtn.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -16, left: -16, bottom: -14, right: -16)
            $0.setTitle("热门", for: .normal)
            $0.setTitleColor(color(147, 148, 152), for: .normal)
            $0.setTitleColor(.black, for: .selected)
            $0.isSelected = true
            $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 14)
            $0.addAction(UIAction() {[unowned self]_ in
                hotBtn.isSelected = true
                priceBtn.isSelected = false
                newBtn.isSelected = false
                
                hotBtn.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 14)
                newBtn.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                priceBtn.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                
                viewModel.url = GoodsAPI.typeGoodsList.rawValue
                viewModel.innerPara = ["goodsTypeId": (typeItem?.id).nonnull, "sort": "hot"]
                viewModel.refresh(shouldLoadCache: false)
                collectionView?.setContentOffset(.zero, animated: false)
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.top.equalTo(customBar.snp.bottom).offset(16)
                make.width.equalTo(28)
                make.height.equalTo(20)
            }
        }
        
        newBtn.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -16, left: -14, bottom: -16, right: -14)
            $0.setTitle("最新", for: .normal)
            $0.setTitleColor(color(147, 148, 152), for: .normal)
            $0.setTitleColor(.black, for: .selected)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
            $0.addAction(UIAction() {[unowned self]_ in
                hotBtn.isSelected = false
                priceBtn.isSelected = false
                newBtn.isSelected = true
                
                newBtn.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 14)
                hotBtn.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                priceBtn.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                
                viewModel.url = GoodsAPI.typeGoodsList.rawValue
                viewModel.innerPara = ["goodsTypeId": (typeItem?.id).nonnull, "sort": "new"]
                viewModel.refresh(shouldLoadCache: false)
                collectionView?.setContentOffset(.zero, animated: false)
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(hotBtn.snp.right).offset(28)
                make.centerY.equalTo(hotBtn)
                make.width.equalTo(28)
                make.height.equalTo(20)
            }
        }
        
        var sortOrder = 1
        priceBtn.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -16, left: -14, bottom: -16, right: -50)
            $0.setTitle("价格", for: .normal)
            $0.setTitleColor(color(147, 148, 152), for: .normal)
            $0.setTitleColor(.black, for: .selected)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
            $0.addAction(UIAction() {[unowned self]_ in
                hotBtn.isSelected = false
                priceBtn.isSelected = true
                newBtn.isSelected = false
                
                priceBtn.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 14)
                newBtn.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                hotBtn.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                
                viewModel.url = GoodsAPI.typeGoodsList.rawValue
                viewModel.innerPara = ["goodsTypeId": (typeItem?.id).nonnull, "sort": sortOrder == 1 ? "price_up" : "price_down"]
                viewModel.refresh(shouldLoadCache: false)
                collectionView?.setContentOffset(.zero, animated: false)
                sortOrder = sortOrder == 1 ? -1 : 1
                priceArrowView.transform = sortOrder == 1 ? .identity : CGAffineTransform(rotationAngle: .pi)
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(newBtn.snp.right).offset(20)
                make.top.equalTo(hotBtn)
                make.width.equalTo(28)
                make.height.equalTo(20)
            }
        }
        
        priceArrowView.do {
            $0.image = UIImage(named: "ge_icon_brand_detail_price")
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(priceBtn.snp.right).offset(6)
                make.centerY.equalTo(priceBtn)
                make.width.height.equalTo(14)
            }
        }
        
        let _ = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -16, left: -14, bottom: -16, right: -16)
            $0.setImage(UIImage(named: "ge_icon_brand_detail_filter"), for: .normal)
            $0.addTarget(self, action: #selector(filterBtnTap), for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.centerY.equalTo(priceBtn)
                make.width.equalTo(46)
                make.height.equalTo(17)
            }
        }
        
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
            make.top.equalTo(hotBtn.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        })
    }
    
    @objc fileprivate func filterBtnTap() {
        let filterVC = GoodsFilterViewController()
        filterVC.modalPresentationStyle = .overFullScreen
        filterVC.didFilterHandler = {[unowned self] priceLow, priceHigh, size in
            guard let viewModel = viewModel as? BusinessGoodsViewController.ChildDetailViewController.InnerViewModel else { return }
            viewModel.url = GoodsAPI.typeGoodsFilter.rawValue
            viewModel.innerPara = ["goodsTypeId": (typeItem?.id).nonnull,
                                   "startPrice": priceLow.nonnull,
                                   "endPrice": priceHigh.nonnull,
                                   "size": size]
            viewModel.refresh(shouldLoadCache: false)
            collectionView?.setContentOffset(.zero, animated: false)
        }
        UIManager.present(modal: filterVC)
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


