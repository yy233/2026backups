//
//  GoodsDetailViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/13.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import APIKit
import ImagePreviewKit

final class GoodsDetailViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var goodItem: GoodsItem?
    private let pageLabel = UILabel()
    private let markBtn = UIButton()
    private let buyBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBar.backgroundColor = color(255, 255, 255, 0.1)
        
        markBtn.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "ge_icon_brand_detail_mark"), for: .normal)
            $0.setImage(UIImage(named: "ge_icon_brand_detail_mark_selected"), for: .selected)
            $0.addTarget(self, action: #selector(markBtnTap(sender:)), for: .touchUpInside)
            $0.imageEdgeInsets = .zero
            $0.isSelected = goodItem?.isMark == true
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-10)
                make.centerY.equalTo(customBackBtn)
                make.width.height.equalTo(24)
            }
        }
        
        let _ = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "ge_icon_goods_detail_share"), for: .normal)
            $0.addAction(UIAction() { _ in
                ActionSheet.show(titles: ["分享"]) { _ in
                    let items = ["我在这里发现一个超棒的商品，快来下载吧http://www.fmwworld.com", URL(string: "http://www.fmwworld.com").nonnull]
                    let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    activityVC.modalPresentationStyle = .overFullScreen
                    UIManager.present(modal: activityVC)
                }
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(markBtn.snp.left).offset(-15)
                make.centerY.equalTo(customBackBtn)
                make.width.height.equalTo(24)
            }
        }
        
        let bottomBar = UIView().then {
            $0.backgroundColor = .white
            $0.layer.shadowOffset = CGSize(width: 0, height: -2)
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
            $0.layer.shadowRadius = 4
            $0.layer.shadowOpacity = 1
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(UIManager.shared.isNotchScreen ? 84 : 60)
            }
        }
        
        let officeBtn = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -20, bottom: -10, right: -20)
            $0.setImage(UIImage(named: "ge_icon_goods_detail_office"), for: .normal)
            $0.addAction(UIAction() { _ in
                UIManager.push(to: ChatViewController().then { $0.chatWith = AppContext.assistorUserID })
            }, for: .touchUpInside)
            bottomBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.top.equalTo(15)
                make.width.equalTo(24)
                make.height.equalTo(41)
            }
        }
        
        buyBtn.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 8
            $0.setTitle("立即购买", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 16)
            $0.addTarget(self, action: #selector(choiceBtnTap), for: .touchUpInside)
            bottomBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(officeBtn.snp.right).offset(23)
                make.right.equalTo(-42)
                make.centerY.equalTo(officeBtn)
                make.height.equalTo(44)
            }
        }
        
        let scrollView = UIScrollView().then {
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.contentInsetAdjustmentBehavior = .never
            $0.delegate = self
            view.insertSubview($0, belowSubview: bottomBar)
            view.insertSubview($0, belowSubview: customBar)
            $0.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(bottomBar.snp.top)
            }
        }
        
        let contentView = UIView().then {
            $0.backgroundColor = .white
            scrollView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.width.equalTo(view)
            }
        }
        
        requestGoodsDetail(contentView: contentView)
    }
    
    private func requestGoodsDetail(contentView: UIView) {
        Network.request(GoodsAPI.goodsDetailInfo, parameters: ["goodsId": (goodItem?.id).nonnull]).responseData { response in
            if let error = response.error {
                self.markBtn.isEnabled = false
                self.buyBtn.isEnabled = false
                Toast.toast(title: error.localizedDescription)
            } else if let data = response.data?.jsonData(),
                      let goodsItem = try? JSONDecoder().decode(GoodsItem.self, from: data)
            {
                self.goodItem = goodsItem
                self.markBtn.isSelected = goodsItem.isMark.nonnull
                self.buyBtn.setTitle(goodsItem.inventory.nonnull > 0 ? "立即购买" : "暂无库存", for: .normal)
                self.buyBtn.backgroundColor = goodsItem.inventory.nonnull > 0 ? .black : color(0, 0, 0, 0.2)
                self.buyBtn.isEnabled = goodsItem.inventory.nonnull > 0
                
                let flowLayout = UICollectionViewFlowLayout().then {
                    $0.scrollDirection = .horizontal
                    $0.minimumLineSpacing = 0
                    $0.minimumInteritemSpacing = 0
                    $0.itemSize = CGSize(width: UIManager.shared.screenWidth, height: UIManager.shared.screenWidth)
                }
                
                let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
                    $0.backgroundColor = .white
                    $0.isScrollEnabled = true
                    $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    $0.delegate = self
                    $0.dataSource = self
                    $0.isPagingEnabled = true
                    $0.showsVerticalScrollIndicator = false
                    $0.showsHorizontalScrollIndicator = false
                    $0.keyboardDismissMode = .onDrag
                    $0.contentInsetAdjustmentBehavior = .never
                    $0.bounces = false
                    $0.register(cellWithClass: ImageCollectionCell.self)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.top.left.right.equalToSuperview()
                        make.height.equalTo(UIManager.shared.screenWidth)
                    }
                }
                
                let pageBackView = UIView().then {
                    $0.backgroundColor = color(0, 0, 0, 0.4)
                    $0.layer.cornerRadius = 12.0
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.width.equalTo(56)
                        make.height.equalTo(24)
                        make.right.equalTo(-20)
                        make.bottom.equalTo(collectionView).offset(-43)
                    }
                }
                
                let _ = UIImageView().then {
                    $0.image = UIImage(named: "lab_goods_page")
                    $0.contentMode = .scaleAspectFit
                    pageBackView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.width.height.equalTo(12)
                        make.centerY.equalToSuperview()
                        make.left.equalTo(8)
                    }
                }
                
                self.pageLabel.do {
                    $0.font = .mediumPingFangSCFont(ofSize: 12)
                    $0.textAlignment = .right
                    pageBackView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.right.equalTo(-10)
                        make.top.bottom.equalToSuperview()
                        make.left.equalTo(20)
                    }
                }
                
                let _ = UIView().then {
                    $0.backgroundColor = .white
                    $0.layer.cornerRadius = 16.0
                    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.right.bottom.equalToSuperview()
                        make.top.equalTo(collectionView.snp.bottom).offset(-23)
                    }
                }
                
                let nameLabel = UILabel().then {
                    let attributeText = NSMutableAttributedString()
                    if let bord = goodsItem.bord {
                        let btn = UIButton().then {
                            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
                            $0.backgroundColor = .black
                            $0.layer.cornerRadius = 4.0
                            $0.setTitle(bord.name, for: .normal)
                            $0.setTitleColor(.white, for: .normal)
                            $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 12)
                            let width = $0.sizeThatFits(CGSize(width: 200, height: 20)).width
                            $0.frame = CGRect(x: 0, y: 0, width: width + 16, height: 24)
                            $0.addAction(UIAction() { _ in
                                UIManager.push(to: BrandDetailViewController().then { $0.brandItem = bord })
                            }, for: .touchUpInside)
                            contentView.addSubview($0)
                            $0.snp.makeConstraints { make in
                                make.width.equalTo(width + 16)
                                make.height.equalTo(24)
                                make.left.equalTo(16)
                                make.top.equalTo(collectionView.snp.bottom).offset(2)
                            }
                        }
                        
                        let textAttachment = NSTextAttachment()
                        textAttachment.image = UIImage()
                        textAttachment.bounds = CGRect(x: 0, y: -5, width: btn.width + 10, height: btn.height)
                        attributeText.append(NSAttributedString(attachment: textAttachment))
                    }
                    
                    attributeText.append(NSAttributedString(string: goodsItem.name, attributes: [.font: UIFont.mediumPingFangSCFont(ofSize: 18), .foregroundColor: UIColor.black]))
                    $0.attributedText = attributeText
                    $0.textAlignment = .left
                    $0.numberOfLines = 2
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(16)
                        make.right.equalTo(-16)
                        make.height.lessThanOrEqualTo(60)
                        make.top.equalTo(collectionView.snp.bottom)
                    }
                }
                
                let priceLabel = UILabel().then {
                    $0.text = String(format: "¥ %.02f", goodsItem.price.nonnull)
                    $0.textColor = color(255, 38, 111)
                    $0.font = .gothamMediumFont(ofSize: 18)
                    $0.textAlignment = .left
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(nameLabel)
                        make.right.equalTo(-45)
                        make.height.lessThanOrEqualTo(30)
                        make.top.equalTo(nameLabel.snp.bottom).offset(6)
                    }
                }
                
                let _ = UIView().then {
                    $0.backgroundColor = color(245, 245, 245)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(16)
                        make.right.equalTo(-16)
                        make.top.equalTo(priceLabel.snp.bottom).offset(16)
                        make.height.equalTo(1)
                    }
                }
                
                let choiceView = UIView().then {
                    $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.choiceBtnTap)))
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(16)
                        make.right.equalTo(-16)
                        make.top.equalTo(priceLabel.snp.bottom).offset(16)
                        make.height.equalTo(50.5)
                    }
                    
                    let title = UILabel()
                    title.text = "规格"
                    title.font = .mediumPingFangSCFont(ofSize: 14)
                    title.textColor = .black
                    $0.addSubview(title)
                    title.snp.makeConstraints { make in
                        make.centerY.left.equalToSuperview()
                        make.width.lessThanOrEqualTo(40)
                        make.height.equalTo(20)
                    }
                    
                    let desc = UILabel()
                    desc.text = "\((goodsItem.size?.count).nonnull)个尺码可供选择"
                    desc.font = .regularPingFangSCFont(ofSize: 14)
                    desc.textColor = color(0, 0, 0, 0.5)
                    $0.addSubview(desc)
                    desc.snp.makeConstraints { make in
                        make.centerY.equalTo(title)
                        make.left.equalTo(title.snp.right).offset(20)
                        make.right.lessThanOrEqualTo(-50)
                        make.height.equalTo(20)
                    }
                    
                    let arrow = UIImageView()
                    arrow.image = UIImage(named: "ge_icon_goods_detail_arrow")
                    arrow.contentMode = .scaleAspectFit
                    $0.addSubview(arrow)
                    arrow.snp.makeConstraints { make in
                        make.right.equalToSuperview()
                        make.width.height.equalTo(17)
                        make.centerY.equalTo(title)
                    }
                    
                    let line = UIView()
                    line.backgroundColor = color(245, 245, 245)
                    $0.addSubview(line)
                    line.snp.makeConstraints { make in
                        make.bottom.left.right.equalToSuperview()
                        make.height.equalTo(1)
                    }
                }
                
                let protectView = UIView().then {
                    $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.protectBtnTap)))
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(16)
                        make.right.equalTo(-16)
                        make.top.equalTo(choiceView.snp.bottom)
                        make.height.equalTo(50.5)
                    }
                    
                    let title = UILabel()
                    title.text = "保障"
                    title.font = .mediumPingFangSCFont(ofSize: 14)
                    title.textColor = .black
                    $0.addSubview(title)
                    title.snp.makeConstraints { make in
                        make.centerY.left.equalToSuperview()
                        make.width.lessThanOrEqualTo(40)
                        make.height.equalTo(20)
                    }
                    
                    let desc = UILabel()
                    desc.text = goodsItem.guarantees?.compactMap { $0.title }.joined(separator: "  ")
                    desc.font = .regularPingFangSCFont(ofSize: 14)
                    desc.textColor = color(0, 0, 0, 0.5)
                    $0.addSubview(desc)
                    desc.snp.makeConstraints { make in
                        make.centerY.equalTo(title)
                        make.left.equalTo(title.snp.right).offset(20)
                        make.right.lessThanOrEqualTo(-50)
                        make.height.equalTo(20)
                    }
                    
                    let arrow = UIImageView()
                    arrow.image = UIImage(named: "ge_icon_goods_detail_arrow")
                    arrow.contentMode = .scaleAspectFit
                    $0.addSubview(arrow)
                    arrow.snp.makeConstraints { make in
                        make.right.equalToSuperview()
                        make.width.height.equalTo(17)
                        make.centerY.equalTo(title)
                    }
                    
                    let line = UIView()
                    line.backgroundColor = color(245, 245, 245)
                    $0.addSubview(line)
                    line.snp.makeConstraints { make in
                        make.bottom.left.right.equalToSuperview()
                        make.height.equalTo(1)
                    }
                }
                
                let saleView = UIView().then {
                    $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.saleBtnTap)))
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(16)
                        make.right.equalTo(-16)
                        make.top.equalTo(protectView.snp.bottom)
                        make.height.equalTo(50.5)
                    }
                    
                    let title = UILabel()
                    title.text = "售后"
                    title.font = .mediumPingFangSCFont(ofSize: 14)
                    title.textColor = .black
                    $0.addSubview(title)
                    title.snp.makeConstraints { make in
                        make.centerY.left.equalToSuperview()
                        make.width.lessThanOrEqualTo(40)
                        make.height.equalTo(20)
                    }
                    
                    let desc = UILabel()
                    desc.text = goodsItem.afterSales?.compactMap { $0.title }.joined(separator: "  ")
                    desc.font = .regularPingFangSCFont(ofSize: 14)
                    desc.textColor = color(0, 0, 0, 0.5)
                    $0.addSubview(desc)
                    desc.snp.makeConstraints { make in
                        make.centerY.equalTo(title)
                        make.left.equalTo(title.snp.right).offset(20)
                        make.right.lessThanOrEqualTo(-50)
                        make.height.equalTo(20)
                    }
                    
                    let arrow = UIImageView()
                    arrow.image = UIImage(named: "ge_icon_goods_detail_arrow")
                    arrow.contentMode = .scaleAspectFit
                    $0.addSubview(arrow)
                    arrow.snp.makeConstraints { make in
                        make.right.equalToSuperview()
                        make.width.height.equalTo(17)
                        make.centerY.equalTo(title)
                    }
                    
                    let line = UIView()
                    line.backgroundColor = color(245, 245, 245)
                    $0.addSubview(line)
                    line.snp.makeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.height.equalTo(1)
                        make.bottom.equalTo(10)
                    }
                }
                
                let goodsLabel = UILabel().then {
                    $0.text = "商品详情"
                    $0.textColor = .black
                    $0.font = .mediumPingFangSCFont(ofSize: 18)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(choiceView)
                        make.right.equalTo(-20)
                        make.height.equalTo(25)
                        make.top.equalTo(saleView.snp.bottom).offset(26)
                    }
                }
                
                let goodsCodeLabel = UILabel().then {
                    $0.text = "商品编号: \(goodsItem.goodsNum.nonnull)"
                    $0.textColor = color(0, 0, 0, 0.5)
                    $0.font = .regularPingFangSCFont(ofSize: 14)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(choiceView)
                        make.right.equalTo(-20)
                        make.height.equalTo(20)
                        make.top.equalTo(goodsLabel.snp.bottom).offset(12)
                    }
                }
                
                let modelLabel = UILabel().then {
                    $0.text = "模特演示"
                    $0.textColor = .black
                    $0.font = .mediumPingFangSCFont(ofSize: 18)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(choiceView)
                        make.right.equalTo(-20)
                        make.height.equalTo(25)
                        make.top.equalTo(goodsCodeLabel.snp.bottom).offset(16)
                    }
                }
                
                var topImageView: UIImageView?
                if let images = goodsItem.images {
                    let attributeText = NSMutableAttributedString(string: "1/\(images.count)", attributes: [.foregroundColor: color(255, 255, 255, 0.4)])
                    attributeText.setAttributes([.foregroundColor: UIColor.white], range: NSRange(location: 0, length: 1))
                    self.pageLabel.attributedText = attributeText
                    collectionView.reloadData()
                }
                
                if let images = goodsItem.modelImages {
                    for image in images {
                        let _ = UIImageView().then {
                            $0.setWebImage(url: image.guid)
                            $0.contentMode = .scaleAspectFill
                            $0.clipsToBounds = true
                            contentView.addSubview($0)
                            let imageHeight = max(image.ht.nonnull, 1)/max(image.wt.nonnull, 1)*(UIManager.shared.screenWidth - 16*2)
                            $0.snp.makeConstraints { make in
                                make.left.equalTo(16)
                                make.right.equalTo(-16)
                                make.height.equalTo(imageHeight)
                                
                                if let topImageView = topImageView {
                                    make.top.equalTo(topImageView.snp.bottom).offset(5)
                                } else {
                                    make.top.equalTo(modelLabel.snp.bottom).offset(10)
                                }
                            }
                            topImageView = $0
                        }
                    }
                }
                
                
                if let image = goodsItem.sizeShowImage {
                    let sizeLabel = UILabel().then {
                        $0.text = "尺码对照"
                        $0.textColor = .black
                        $0.font = .mediumPingFangSCFont(ofSize: 18)
                        contentView.addSubview($0)
                        $0.snp.makeConstraints { make in
                            make.left.equalTo(choiceView)
                            make.right.equalTo(-20)
                            make.height.equalTo(25)
                            make.top.equalTo(topImageView!.snp.bottom).offset(20)
                        }
                    }
                    
                    let _ = UIImageView().then {
                        $0.setWebImage(url: image.guid)
                        contentView.addSubview($0)
                        let imageHeight = max(image.ht.nonnull, 1)/max(image.wt.nonnull, 1)*(UIManager.shared.screenWidth - 16*2)
                        $0.snp.makeConstraints { make in
                            make.left.equalTo(16)
                            make.right.equalTo(-16)
                            make.height.equalTo(imageHeight)
                            make.top.equalTo(sizeLabel.snp.bottom).offset(12)
                            make.bottom.equalTo(-20)
                        }
                    }
                }
            }
        }
    }
    
    @objc fileprivate func markBtnTap(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        Network.request(sender.isSelected ? GoodsAPI.goodsMark : GoodsAPI.goodsCancelMark, parameters: ["goodsId": (goodItem?.id).nonnull]).responseEmpty()
    }
    
    @objc fileprivate func choiceBtnTap() {
        UIManager.present(modal: GoodsSizeSelectViewController().then {
            $0.modalPresentationStyle = .overFullScreen
            $0.goodsItem = goodItem
        })
    }
    
    @objc fileprivate func protectBtnTap() {
        UIManager.present(modal: GoodsProtectTipsViewController().then {
            $0.modalPresentationStyle = .overFullScreen
            $0.goodsItem = goodItem
        })
    }
    
    @objc fileprivate func saleBtnTap() {
        UIManager.present(modal: GoodsSaleTipsViewController().then {
            $0.modalPresentationStyle = .overFullScreen
            $0.goodsItem = goodItem
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customBar.backgroundColor = color(255, 255, 255, min(1, max(0.1, scrollView.contentOffset.y/(UIManager.shared.screenWidth - UIManager.shared.navBarHeight))))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (goodItem?.images?.count).nonnull
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
        cell.contentView.backgroundColor = color(231, 231, 231)
        if let item = goodItem?.images?[safe: indexPath.item] {
            cell.imageView.setWebImage(url: item.guid)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let images = goodItem?.images {
            if indexPath.item == images.count - 1 {
                pageLabel.attributedText = NSAttributedString(string: "\(indexPath.item + 1)/\(images.count)", attributes: [.foregroundColor: color(255, 255, 255)])
            } else {
                let attributeText = NSMutableAttributedString(string: "\(indexPath.item + 1)/\(images.count)", attributes: [.foregroundColor: color(255, 255, 255, 0.4)])
                attributeText.setAttributes([.foregroundColor: UIColor.white], range: NSRange(location: 0, length: 1))
                pageLabel.attributedText = attributeText
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let images = goodItem?.images, let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionCell {
            ImagePreview.previewPhotos(images.compactMap { $0.guid }, fromView: cell.imageView, initilizeIndex: indexPath.item)
        }
    }
    
    fileprivate class ImageCollectionCell: UICollectionViewCell {
        fileprivate lazy var imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = color(231, 231, 231)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
    }
}
