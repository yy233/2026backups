//
//  CommunityListViewController.swift
//  Genz
//
//  Created by Sera on 2021/9/11.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import APIKit

final class GoodsSectionListViewController: BaseViewController {
    
    private var categoryList = [GoodsCategoryItem]()
    private var leftSelectIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "商品分类"
        
        leftCollectionView.snp.makeConstraints { make in
            make.top.equalTo(customBar.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.width.equalTo(84)
        }
        
        rightCollectionView.snp.makeConstraints { make in
            make.left.equalTo(leftCollectionView.snp.right)
            make.top.equalTo(btn1.snp.bottom).offset(10)
            make.right.bottom.equalToSuperview()
        }
        
        Network.request(GoodsAPI.goodsCategorySection).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let data = (response.data?["list"] as? [Any])?.jsonString.data(using: .utf8), let list = try? JSONDecoder().decode([GoodsCategoryItem].self, from: data), !list.isEmpty {
                self.categoryList.removeAll()
                self.categoryList.append(contentsOf: list)
                self.leftCollectionView.reloadData()
                self.rightCollectionView.reloadData()
                
                if let groupList = list.first?.list {
                    self.btn1.setTitle(groupList[safe: 0]?.name, for: .normal)
                    self.btn1.isHidden = groupList.count < 1
                    self.btn2.setTitle(groupList[safe: 1]?.name, for: .normal)
                    self.btn2.isHidden = groupList.count < 2
                    self.btn3.setTitle(groupList[safe: 2]?.name, for: .normal)
                    self.btn3.isHidden = groupList.count < 3
                    self.btn1Tap()
                }
            }
        }
    }
    
    fileprivate lazy var leftCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = color(245, 245, 245)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: UICollectionReusableView.self)
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withClass: UICollectionReusableView.self)
        collectionView.register(cellWithClass: LeftSectionCollectionCell.self)
        view.addSubview(collectionView)
        return collectionView
    }()
    
    fileprivate lazy var rightCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 28
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 15, right: 16)
        collectionView.register(cellWithClass: RightGoodsItemCollectionCell.self.self)
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: RightGoodsHeaderView.self)
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withClass: UICollectionReusableView.self)
        view.addSubview(collectionView)
        return collectionView
    }()
    
    fileprivate lazy var btn1 = UIButton().then {
        $0.setTitle("猜你喜欢", for: .normal)
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0)
        $0.layer.cornerRadius = 4
        $0.setTitleColor(color(0, 0, 0, 0.5), for: .normal)
        $0.setTitleColor(color(51, 186, 255), for: .selected)
        $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 12)
        $0.layer.borderColor = color(51, 186, 255).cgColor
        $0.addTarget(self, action: #selector(btn1Tap), for: .touchUpInside)
        view.addSubview($0)
        $0.snp.makeConstraints { make in
            make.top.equalTo(customBar.snp.bottom).offset(12)
            make.left.equalTo(leftCollectionView.snp.right).offset(16)
            make.width.equalTo(72)
            make.height.equalTo(28)
        }
    }
    
    fileprivate lazy var btn2 = UIButton().then {
        $0.setTitle("上装", for: .normal)
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0)
        $0.layer.cornerRadius = 4
        $0.setTitleColor(color(0, 0, 0, 0.5), for: .normal)
        $0.setTitleColor(color(51, 186, 255), for: .selected)
        $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 12)
        $0.layer.borderColor = color(51, 186, 255).cgColor
        $0.addTarget(self, action: #selector(btn2Tap), for: .touchUpInside)
        view.addSubview($0)
        $0.snp.makeConstraints { make in
            make.top.equalTo(btn1)
            make.left.equalTo(btn1.snp.right).offset(8)
            make.width.equalTo(48)
            make.height.equalTo(28)
        }
    }
    
    fileprivate lazy var btn3 = UIButton().then {
        $0.setTitle("裤子", for: .normal)
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0)
        $0.layer.cornerRadius = 4
        $0.setTitleColor(color(0, 0, 0, 0.5), for: .normal)
        $0.setTitleColor(color(51, 186, 255), for: .selected)
        $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 12)
        $0.layer.borderColor = color(51, 186, 255).cgColor
        $0.addTarget(self, action: #selector(btn3Tap), for: .touchUpInside)
        view.addSubview($0)
        $0.snp.makeConstraints { make in
            make.top.equalTo(btn1)
            make.left.equalTo(btn2.snp.right).offset(8)
            make.width.equalTo(48)
            make.height.equalTo(28)
        }
    }
    
    @objc fileprivate func btn1Tap() {
        btn1.backgroundColor = color(230, 246, 255)
        btn2.backgroundColor = color(245, 245, 245)
        btn3.backgroundColor = color(245, 245, 245)
        btn1.layer.borderWidth = 1
        btn2.layer.borderWidth = 0
        btn3.layer.borderWidth = 0
        btn1.isSelected = true
        btn2.isSelected = false
        btn3.isSelected = false
        rightCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    @objc fileprivate func btn2Tap() {
        btn2.backgroundColor = color(230, 246, 255)
        btn1.backgroundColor = color(245, 245, 245)
        btn3.backgroundColor = color(245, 245, 245)
        btn1.layer.borderWidth = 0
        btn2.layer.borderWidth = 1
        btn3.layer.borderWidth = 0
        btn1.isSelected = false
        btn2.isSelected = true
        btn3.isSelected = false
        rightCollectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .top, animated: true)
    }
    
    @objc fileprivate func btn3Tap() {
        btn3.backgroundColor = color(230, 246, 255)
        btn2.backgroundColor = color(245, 245, 245)
        btn1.backgroundColor = color(245, 245, 245)
        btn1.layer.borderWidth = 0
        btn2.layer.borderWidth = 0
        btn3.layer.borderWidth = 1
        btn1.isSelected = false
        btn2.isSelected = false
        btn3.isSelected = true
        rightCollectionView.scrollToItem(at: IndexPath(item: 0, section: 2), at: .top, animated: true)
    }
}

extension GoodsSectionListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == leftCollectionView {
            return 1
        }
        
        if let group = categoryList[safe: leftSelectIndex]?.list {
            return group.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == leftCollectionView {
            return categoryList.count
        }
        
        if let group = categoryList[safe: leftSelectIndex]?.list {
            return (group[safe: section]?.list?.count).nonnull
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == leftCollectionView {
            let cell = collectionView.dequeueReusableCell(withClass: LeftSectionCollectionCell.self, for: indexPath)
            cell.contentView.backgroundColor = .clear
            cell.titleLabel.text = categoryList[safe: indexPath.item]?.name
            cell.titleLabel.backgroundColor = indexPath.item == leftSelectIndex ? .white : .clear
            return cell
        }
  
        let cell = collectionView.dequeueReusableCell(withClass: RightGoodsItemCollectionCell.self, for: indexPath)
        cell.contentView.backgroundColor = .white
        if let group = categoryList[safe: leftSelectIndex]?.list, let item = group[safe: indexPath.section]?.list?[safe: indexPath.item] {
            cell.iconView.setWebImage(url: (item.icon?.guid).nonnull)
            cell.titleLabel.text = item.name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader, collectionView == rightCollectionView {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: RightGoodsHeaderView.self, for: indexPath)
            if let group = categoryList[safe: leftSelectIndex]?.list {
                view.titleLabel.text = group[safe: indexPath.section]?.name
            }
            return view
        }
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: UICollectionReusableView.self, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == leftCollectionView {
            return CGSize(width: 84, height: 44)
        }
        
        let width = floor((UIManager.shared.screenWidth - 84 - 32 - 20)/3.0)
        return CGSize(width: width, height: width + 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == leftCollectionView {
            return .zero
        }
        return CGSize(width: UIManager.shared.screenWidth - 84, height: 53)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == leftCollectionView {
            leftSelectIndex = indexPath.item
            collectionView.reloadData()
            rightCollectionView.reloadData()
            
            if let list = categoryList[safe: leftSelectIndex]?.list {
                self.btn1.setTitle(list[safe: 0]?.name, for: .normal)
                self.btn1.isHidden = list.count < 1
                self.btn2.setTitle(list[safe: 1]?.name, for: .normal)
                self.btn2.isHidden = list.count < 2
                self.btn3.setTitle(list[safe: 2]?.name, for: .normal)
                self.btn3.isHidden = list.count < 3
                self.btn1Tap()
            }
        } else if let group = categoryList[safe: leftSelectIndex]?.list, let item = group[safe: indexPath.section]?.list?[safe: indexPath.item] {
            UIManager.push(to: GoodsSectionDetailViewController().then {
                $0.typeItem = item
            })
        }
    }
}

fileprivate extension GoodsSectionListViewController {
    class LeftSectionCollectionCell: UICollectionViewCell {
        fileprivate lazy var titleLabel = UILabel().then {
            $0.textColor = color(0, 0, 0, 0.5)
            $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
            $0.textAlignment = .center
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
    }
    
    class RightGoodsItemCollectionCell: UICollectionViewCell {
        fileprivate lazy var iconView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(-28)
            }
        }
        
        fileprivate lazy var titleLabel = UILabel().then {
            $0.textColor = color(0, 0, 0, 0.5)
            $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
            $0.textAlignment = .center
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(20)
            }
        }
    }

    class RightGoodsHeaderView: UICollectionReusableView {
        lazy var titleLabel = UILabel().then {
            $0.textColor = color(0, 0, 0)
            $0.font = UIFont.semiboldPingFangSCFont(ofSize: 14)
            $0.textAlignment = .left
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(16)
                make.left.equalTo(16)
                make.width.lessThanOrEqualTo(150)
                make.height.equalTo(20)
            }
        }
    }
}
