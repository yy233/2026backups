//
//  MagazineSearchViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/12.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import Combine
import TagListView
import APIKit

final class MagazineSearchViewController: TableViewController {
    enum Business: String {
        case magazine = "杂志名称"
        case goods = "商品名称"
        case nft = "藏品名称"
    }
    
    var business: Business = .magazine
    
    private let textField = UITextField()
    private var hotWords = [String]()
    
    private lazy var magazineResultVC = MagazineResultViewController().then {
        $0.willMove(toParent: self)
        addChild($0)
        $0.didMove(toParent: self)
        view.addSubview($0.view)
        
        if let tableView = tableView {
            $0.view.snp.makeConstraints { make in
                make.top.left.right.bottom.equalTo(tableView)
            }
        }
    }
    
    private lazy var nftResultVC = NFTResultViewController().then {
        $0.willMove(toParent: self)
        addChild($0)
        $0.didMove(toParent: self)
        view.addSubview($0.view)
        
        if let tableView = tableView {
            $0.view.snp.makeConstraints { make in
                make.top.left.right.bottom.equalTo(tableView)
            }
        }
    }
    
    private lazy var goodsResultVC = GoodsResultViewController().then {
        $0.willMove(toParent: self)
        addChild($0)
        $0.didMove(toParent: self)
        view.addSubview($0.view)
        
        if let tableView = tableView {
            $0.view.snp.makeConstraints { make in
                make.top.left.right.bottom.equalTo(tableView)
            }
        }
    }
    
    override func viewDidLoad() {
        showRefreshHeader = false
        showLoadMoreFooter = false
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        
        let searchBar = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 8.0
            customBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerY.equalTo(customBackBtn)
                make.left.equalTo(customBackBtn.snp.right).offset(16)
                make.right.equalTo(-16)
                make.height.equalTo(39)
            }
        }
        
        let _ = UIImageView().then {
            $0.image = UIImage(named: "ge_icon_search")
            searchBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(12)
                make.width.height.equalTo(16)
                make.centerY.equalToSuperview()
            }
        }
        
        textField.do {
            $0.font = UIFont.regularPingFangSCFont(ofSize: 12)
            $0.textColor = .black
            $0.attributedPlaceholder = NSAttributedString(string: "请输入\(business.rawValue)", attributes: [.foregroundColor: color(179, 179, 179)])
            $0.textAlignment = .left
            $0.keyboardType = .default
            $0.returnKeyType = .search
            $0.clearButtonMode = .always
            $0.textPublisher().delay(for: 1, scheduler: RunLoop.main).sink {[unowned self] _ in
                startSearch()
            }.store(in: &cancellableList)
            searchBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(34)
                make.top.bottom.equalToSuperview()
                make.right.equalTo(-16)
            }
        }
        
        tableView?.register(cellWithClass: SearchTagCell.self)
        tableView?.snp.makeConstraints({ make in
            make.top.equalTo(customBar.snp.bottom).offset(14)
            make.left.right.bottom.equalToSuperview()
        })
        
        Network.request(GoodsAPI.searchHotWords).responseData { response in
            if let list = response.data?["list"] as? [String] {
                self.hotWords.removeAll()
                self.hotWords.append(contentsOf: list)
                self.tableView?.reloadData()
            }
        }
        
        textField.becomeFirstResponder()
    }
    
    fileprivate func startSearch() {
        if textField.text.nonnull.isEmpty {
            switch business {
            case .magazine:
                magazineResultVC.view.isHidden = true
            case .nft:
                nftResultVC.view.isHidden = true
            case .goods:
                goodsResultVC.view.isHidden = true
            }
        } else {
            switch business {
            case .magazine:
                magazineResultVC.view.isHidden = false
                if let viewModel = magazineResultVC.viewModel as? MainLeftMenuViewController.InnerViewModel {
                    viewModel.innerPara = ["id": textField.text.nonnull]
                }
                magazineResultVC.tableView?.scrollToTop()
                magazineResultVC.viewModel?.refresh(shouldLoadCache: false)
            case .nft:
                nftResultVC.view.isHidden = false
                if let viewModel = nftResultVC.viewModel as? NFTMallViewController.InnerViewModel {
                    viewModel.innerPara = ["id": textField.text.nonnull]
                }
                nftResultVC.collectionView?.setContentOffset(.zero, animated: false)
                nftResultVC.viewModel?.refresh(shouldLoadCache: false)
            case .goods:
                goodsResultVC.view.isHidden = false
                if let viewModel = goodsResultVC.viewModel as? BusinessGoodsViewController.ChildDetailViewController.InnerViewModel {
                    viewModel.innerPara = ["keyword": textField.text.nonnull]
                }
                goodsResultVC.collectionView?.setContentOffset(.zero, animated: false)
                goodsResultVC.viewModel?.refresh(shouldLoadCache: false)
            }
        }
    }
    
    @objc fileprivate func cancelBtnTapHandler() {
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIManager.shared.screenHeight - UIManager.shared.navBarHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SearchTagCell.self)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .white
        cell.tagView.removeAllTags()
        cell.tagView.addTags(hotWords)

        cell.didSelectHandler = {[unowned self] title in
            textField.text = title
            startSearch()
        }
        return cell
    }
    
    fileprivate class SearchTagCell: UITableViewCell, TagListViewDelegate {
        lazy var titleLabel = UILabel().then {
            $0.text = "热门搜索"
            $0.textColor = .black
            $0.font = .semiboldPingFangSCFont(ofSize: 14)
            $0.textAlignment = .left
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(10)
                make.left.equalTo(16)
                make.width.lessThanOrEqualTo(200)
                make.height.equalTo(20)
            }
        }
        
        lazy var tagView = TagListView().then {
            $0.textFont = .regularPingFangSCFont(ofSize: 12)
            $0.textColor = color(165, 165, 165)
            $0.alignment = .leading
            $0.tagBackgroundColor = color(245, 245, 245)
            $0.marginX = 8
            $0.marginY = 8
            $0.paddingX = 10
            $0.paddingY = 4
            $0.cornerRadius = 10
            $0.delegate = self
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(12)
                make.left.equalTo(16)
                make.right.equalTo(-10)
                make.height.equalTo(100)
            }
        }
        
        var didSelectHandler: ((String) -> Void)?
        func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
            didSelectHandler?(title)
        }
    }
}

fileprivate class MagazineResultViewController: TableViewController {
    override func viewDidLoad() {
        showRefreshHeader = false
        showLoadMoreFooter = true
        triggerRefreshAutomatic = false
        triggerLoadMoreAutomatic = true
        emptyPlaceholderOffsetY = -100
        
        let viewModel = MainLeftMenuViewController.InnerViewModel()
        viewModel.url = MainAPI.magazineSearch.rawValue
        self.viewModel = viewModel
        
        super.viewDidLoad()
        
        tableView?.register(cellWithClass: MagazineSearchCell.self)
        tableView?.snp.makeConstraints({ make in
            make.top.left.right.bottom.equalToSuperview()
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let item = viewModel?.element(at: indexPath.section) as? MagazineItem, let cover = item.cover {
            let imageWidth = UIManager.shared.screenWidth - 32
            return max(1, cover.ht.nonnull)/max(1, cover.wt.nonnull)*imageWidth + 16
        }
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MagazineSearchCell.self)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .white
        if let item = viewModel?.element(at: indexPath.section) as? MagazineItem, let cover = item.cover {
            cell.iconView.image = nil
            cell.iconView.setWebImage(url: OSSUploader.imageURLFor(cover.guid))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = viewModel?.element(at: indexPath.section) as? MagazineItem {
            UIManager.push(to: MagazineDetailViewController().then { $0.magazineItem = item })
        }
    }
    
    fileprivate class MagazineSearchCell: UITableViewCell {
        fileprivate lazy var iconView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
            }
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            iconView.image = nil
            iconView.cancelCurrentWebImageLoad()
        }
    }
}

fileprivate class NFTResultViewController: CollectionViewController {
    override func viewDidLoad() {
        showRefreshHeader = false
        showLoadMoreFooter = true
        triggerRefreshAutomatic = false
        triggerLoadMoreAutomatic = true
        emptyPlaceholderOffsetY = -100
        
        let viewModel = NFTMallViewController.InnerViewModel()
        viewModel.url = NFTAPI.nftSearch.rawValue
        self.viewModel = viewModel
        
        super.viewDidLoad()
        
        if let flowlayout = flowLayout as? CollectionWaterFlowLayout {
            flowlayout.contentInset = UIEdgeInsets(top: 15, left: 16, bottom: 60, right: 16)
            flowlayout.columnCount = 2
            flowlayout.columnSpacing = 13
            flowlayout.lineSpacing = 15
            flowlayout.indexPathHeightHandler = { indexPath,width in
                if let info = viewModel.element(at: indexPath.item) as? NFTMallViewController.InnerItem, let cover = info.nftInfo?.cover {
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
            cell.imageView.setWebImage(url: OSSUploader.imageNFTURLFor((info.cover?.guid).nonnull, crop: .medium), cornerRadius: 12*3.0, finalSize: CGSize(width: imageWidth*3.0, height: imageHeight*3.0))
            cell.textLabel.text = info.name
            cell.pointsLabel.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = viewModel?.element(at: indexPath.item) as? NFTMallViewController.InnerItem, let info = item.nftInfo {
            UIManager.push(to: NFTDetailViewController().then {
                $0.nftInfo = info
            })
        }
    }
}

fileprivate class GoodsResultViewController: CollectionViewController {
    override func viewDidLoad() {
        showRefreshHeader = false
        showLoadMoreFooter = true
        triggerRefreshAutomatic = false
        triggerLoadMoreAutomatic = true
        emptyPlaceholderOffsetY = -100
        
        let viewModel = BusinessGoodsViewController.ChildDetailViewController.InnerViewModel()
        viewModel.url = GoodsAPI.goodsSearch.rawValue
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
