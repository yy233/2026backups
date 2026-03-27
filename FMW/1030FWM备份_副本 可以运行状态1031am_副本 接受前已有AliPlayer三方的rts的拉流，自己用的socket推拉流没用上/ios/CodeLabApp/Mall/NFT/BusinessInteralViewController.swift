//
//  BusinessInteralViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/16.
//

import Foundation
import BasicKit
import BasicUIKit
import UIKit
import YYImage
import Alamofire

final class BusinessInteralViewController: CollectionViewController, SegmentBarItem {
    
    //MARK: - Segment
    var segmentTitle: String { return "积分" }
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

    private let priceArrowView = UIImageView()
    private let hotBtn = UIButton()
    private let newBtn = UIButton()
    private let priceBtn = UIButton()
    
    override func viewDidLoad() {
        var sortOrder = 1

        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = InnerViewModel()
        viewModel.url = NFTAPI.pointsNFTList.rawValue
        viewModel.innerPara = ["sortType": "hot", "sortOrder": sortOrder]
        self.viewModel = viewModel
        super.viewDidLoad()
        
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
                
                viewModel.innerPara = ["sortType": "hot", "sortOrder": sortOrder]
                viewModel.refresh(shouldLoadCache: false)
                collectionView?.setContentOffset(.zero, animated: false)
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.equalTo(16)
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
                
                viewModel.innerPara = ["sortType": "newest", "sortOrder": sortOrder]
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
                
                viewModel.innerPara = ["sortType": "price", "sortOrder": sortOrder]
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
        
//        let _ = UIButton().then {
//            $0.hitTestEdgeInsets = UIEdgeInsets(top: -16, left: -14, bottom: -16, right: -16)
//            $0.setImage(UIImage(named: "ge_icon_brand_detail_filter"), for: .normal)
//            $0.addTarget(self, action: #selector(filterBtnTap), for: .touchUpInside)
//            view.addSubview($0)
//            $0.snp.makeConstraints { make in
//                make.right.equalTo(-16)
//                make.centerY.equalTo(priceBtn)
//                make.width.equalTo(46)
//                make.height.equalTo(17)
//            }
//        }
        
        if let flowlayout = flowLayout as? CollectionWaterFlowLayout {
            flowlayout.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
            flowlayout.columnCount = 1
            flowlayout.lineSpacing = 12
            flowlayout.indexPathWidthHandler = { _,_ in
                return UIManager.shared.screenWidth
            }
            flowlayout.indexPathHeightHandler = { indexPath, width in
                if let nftItem = viewModel.element(at: indexPath.item) as? NFTSeriesItem,
                   let media = nftItem.seriesInfo?.cover {
                    return max(media.ht.nonnull, 1)/max(media.wt.nonnull, 1)*width
                }
                return width
            }
        }
        
        collectionView?.register(cellWithClass: ImageCollectionCell.self)
        collectionView?.snp.makeConstraints({ make in
            make.top.equalTo(hotBtn.snp.bottom).offset(15)
            make.left.right.bottom.equalToSuperview()
        })
    }
    
    @objc fileprivate func filterBtnTap() {
        let filterVC = NFTFilterViewController()
        filterVC.modalPresentationStyle = .overFullScreen
        filterVC.didSelectTypeHandler = { item in
            
        }
        UIManager.present(modal: filterVC)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
        cell.contentView.backgroundColor = .white
        cell.textBackView.isHidden = false
        if let item = viewModel?.element(at: indexPath.item) as? NFTSeriesItem {
            cell.bindModel(item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = viewModel?.element(at: indexPath.item) as? NFTSeriesItem {
            UIManager.push(to: InteralDrawViewController().then { $0.nftSeriesItem = item })
        }
    }
    
    fileprivate class ImageCollectionCell: UICollectionViewCell {
        fileprivate lazy var imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .black.withAlphaComponent(0.1)
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        fileprivate lazy var textLabel = UILabel().then {
            $0.font = .mediumPingFangSCFont(ofSize: 27)
            $0.textColor = .white
            $0.textAlignment = .left
            $0.numberOfLines = 2
            contentView.insertSubview($0, aboveSubview: imageView)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.height.lessThanOrEqualTo(100)
                make.bottom.equalTo(-29)
                make.width.equalTo(110)
            }
        }
        
        fileprivate lazy var textBackView = LinearGradientView().then {
            $0.startPoint = CGPoint(x: 0, y: 0)
            $0.endPoint = CGPoint(x: 0, y: 1)
            $0.colors = [color(0, 0, 0, 0), color(0, 0, 0, 0.16)]
            contentView.insertSubview($0, aboveSubview: imageView)
            contentView.insertSubview($0, belowSubview: textLabel)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalTo(imageView)
                make.top.equalTo(textLabel).offset(-30)
            }
        }
        
        fileprivate lazy var priceBack = UIView().then {
            $0.backgroundColor = color(87, 80, 79)
            $0.layer.cornerRadius = 24.5
            contentView.insertSubview($0, belowSubview: draftView)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.equalTo(92)
                make.height.equalTo(49)
                make.bottom.equalTo(textLabel)
            }
        }
        
        fileprivate lazy var priceLabel = UILabel().then {
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textColor = .white
            $0.textAlignment = .center
            priceBack.insertSubview($0, aboveSubview: priceBack)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        fileprivate lazy var draftView = UIImageView().then {
            $0.image = UIImage(named: "ge_icon_mall_draft")
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-96)
                make.height.width.equalTo(49)
                make.bottom.equalTo(textLabel)
            }
        }
                
        override func prepareForReuse() {
            super.prepareForReuse()
            imageView.cancelCurrentWebImageLoad()
            imageView.image = nil
        }
        
        func bindModel(_ item: NFTSeriesItem) {
            guard let info = item.seriesInfo else { return }
            textLabel.text = info.name
            imageView.setWebImage(url: OSSUploader.imageNFTURLFor((info.cover?.guid).nonnull, crop: .medium))
            priceLabel.text = "\(item.points.nonnull)积分"
        }
    }
    
    fileprivate class InnerViewModel: NetworkViewModel {
        var innerPara: [String: Any]?
        override var parameters: [String : Any]? { innerPara }
        
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([NFTSeriesItem].self, from: data)
                if isLoadingMore {
                    var list = [NFTSeriesItem]()
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
