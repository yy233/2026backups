//
//  BrandDetailViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/13.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import APIKit

final class BrandDetailViewController: CollectionViewController {

    var brandItem: GoodsItem.BordItem?
    
    private let descLabel = UILabel()
    private let hotBtn = UIButton()
    private let newBtn = UIButton()
    private let priceBtn = UIButton()
    private let priceArrowView = UIImageView()

    override func viewDidLoad() {
        showRefreshHeader = false
        triggerLoadMoreAutomatic = true
        triggerRefreshAutomatic = true
        let viewModel = BusinessGoodsViewController.ChildDetailViewController.InnerViewModel()
        viewModel.url = GoodsAPI.brandGoodsList.rawValue
        viewModel.innerPara = ["bordId": (brandItem?.id).nonnull, "sort": "hot"]
        self.viewModel = viewModel
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBar.backgroundColor = .clear
        customBackBtn.setImage(UIImage(named: "lab_navigation_back_white"), for: .normal)

        let backgorundView = UIImageView().then {
            $0.image = UIImage(named: "lab_child_community_background")
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            view.insertSubview($0, belowSubview: customBar)
            $0.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(260)
            }
        }
        
        let nameLabel = UILabel().then {
            $0.text = brandItem?.name
            $0.textColor = .white
            $0.font = .gothamBoldFont(ofSize: 20)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.top.equalTo(customBar.snp.bottom).offset(20)
                make.right.equalTo(-16)
                make.height.lessThanOrEqualTo(40)
            }
        }
        
        descLabel.do {
            $0.textColor = color(255, 255, 255, 0.4)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(nameLabel)
                make.top.equalTo(nameLabel.snp.bottom).offset(4)
                make.height.equalTo(20)
            }
        }
        
        viewModelDidFinishLoad = {[weak self] _ in
            self?.descLabel.text = "共\(viewModel.count)款"
        }
        
        let backView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 18.0
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(backgorundView.snp.bottom).offset(-87)
                make.left.right.bottom.equalToSuperview()
            }
        }
        
        hotBtn.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -16, left: -16, bottom: -14, right: -16)
            $0.setTitle("热门", for: .normal)
            $0.setTitleColor(color(147, 148, 152), for: .normal)
            $0.setTitleColor(.black, for: .selected)
            $0.isSelected = true
            $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 14)
            $0.addAction(UIAction() {[unowned self] _ in
                priceBtn.isSelected = false
                newBtn.isSelected = false
                hotBtn.isSelected = true
                hotBtn.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 14)
                newBtn.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                priceBtn.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                
                viewModel.innerPara = ["bordId": (brandItem?.id).nonnull, "sort": "hot"]
                viewModel.refresh(shouldLoadCache: false)
                collectionView?.setContentOffset(.zero, animated: false)
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.top.equalTo(backView).offset(16)
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
            $0.addAction(UIAction() {[unowned self] _ in
                priceBtn.isSelected = false
                newBtn.isSelected = true
                hotBtn.isSelected = false
                newBtn.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 14)
                hotBtn.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                priceBtn.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                
                viewModel.innerPara = ["bordId": (brandItem?.id).nonnull, "sort": "new"]
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
            $0.addAction(UIAction() {[unowned self] _ in
                priceBtn.isSelected = true
                newBtn.isSelected = false
                hotBtn.isSelected = false
                priceBtn.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 14)
                newBtn.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                hotBtn.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                
                viewModel.innerPara = ["bordId": (brandItem?.id).nonnull, "sort": sortOrder == 1 ? "price_up" : "price_down"]
                viewModel.refresh(shouldLoadCache: false)
                collectionView?.setContentOffset(.zero, animated: false)
                sortOrder = sortOrder == 1 ? -1 : 1
                self.priceArrowView.transform = sortOrder == 1 ? .identity : CGAffineTransform(rotationAngle: .pi)
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(newBtn.snp.right).offset(20)
                make.centerY.equalTo(hotBtn)
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
        
        if let flowlayout = flowLayout as? CollectionWaterFlowLayout {
            flowlayout.contentInset = UIEdgeInsets(top: 10, left: 16, bottom: 60, right: 16)
            flowlayout.columnCount = 2
            flowlayout.columnSpacing = 13
            flowlayout.lineSpacing = 18
            flowlayout.indexPathHeightHandler = {_,width in
                return width + 72
            }
        }
        
        if let collectionView = collectionView {
            view.bringSubviewToFront(collectionView)
            collectionView.register(cellWithClass: GoodsCollectionCell.self)
            collectionView.snp.makeConstraints({ make in
                make.top.equalTo(hotBtn.snp.bottom).offset(20)
                make.left.right.bottom.equalToSuperview()
            })
        }
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


