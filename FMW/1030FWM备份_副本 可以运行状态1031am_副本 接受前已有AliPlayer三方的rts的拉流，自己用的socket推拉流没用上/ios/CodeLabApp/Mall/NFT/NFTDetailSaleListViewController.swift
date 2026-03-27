//
//  NFTDetailSaleListViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/15.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import APIKit

final class NFTDetailSaleListViewController: CollectionViewController {
    
    var nftInfo: NFTInfo?
    var list: [UserNFTItem] = []
    
    private let contentView = UIView()
    private let submitBtn = UIButton()
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.location(in: view).y < contentView.frame.minY {
            dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        showRefreshHeader = false
        showLoadMoreFooter = false
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        contentView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(UIManager.shared.screenHeight - 200 > 501 ? 501 : UIManager.shared.screenHeight - 200)
            }
        }
        
        let titleLabel = UILabel().then {
            $0.text = "寄售"
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 18)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-50)
                make.height.lessThanOrEqualTo(50)
                make.top.equalTo(26)
            }
        }
        
        let descLabel = UILabel().then {
            $0.text = nftInfo?.name
            $0.textColor = color(0, 0, 0, 0.4)
            $0.font = .regularPingFangSCFont(ofSize: 12)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(titleLabel)
                make.height.equalTo(18)
                make.top.equalTo(titleLabel.snp.bottom).offset(2)
            }
        }
        
        let _ = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "ge_icon_modal_dismiss"), for: .normal)
            $0.addTarget(self, action: #selector(dismissBtnTap), for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-20)
                make.width.height.equalTo(20)
                make.centerY.equalTo(titleLabel)
            }
        }
        
        submitBtn.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 12
            $0.setTitle("确定", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 16)
            $0.addTarget(self, action: #selector(submitBtnTap), for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.bottom.equalTo(UIManager.shared.isNotchScreen ? -42 : -18)
                make.height.equalTo(44)
            }
        }
        
        if let collectionView = collectionView,
           let flowlayout = flowLayout as? CollectionWaterFlowLayout {
            flowlayout.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
            flowlayout.columnCount = 3
            flowlayout.columnSpacing = 18
            flowlayout.lineSpacing = 24
            flowlayout.indexPathHeightHandler = {_,width in
                return width + 28
            }
            
            collectionView.removeFromSuperview()
            contentView.addSubview(collectionView)
            collectionView.register(cellWithClass: CollectionCell.self)
            collectionView.snp.makeConstraints({ make in
                make.left.right.equalToSuperview()
                make.top.equalTo(descLabel.snp.bottom).offset(14)
                make.bottom.equalTo(submitBtn.snp.top).offset(-15)
            })
        }
    }
    
    @objc fileprivate func dismissBtnTap() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func submitBtnTap() {
        if selectIndex != nil, let item = list[safe: selectIndex.nonnull] {
            if item.isOnSale {
                HUD.show()
                Network.request(NFTAPI.nftCancelSale, parameters: ["id": item.saleId.nonnull]).responseData { response in
                    HUD.hide()
                    if let error = response.error {
                        Toast.toast(title: error.localizedDescription)
                    } else {
                        Toast.toast(title: "已取消寄售")
                        self.dismiss(animated: true)
                    }
                }
            } else {
                dismiss(animated: true) {
                    UIManager.present(modal: NFTDetailSaleSelectShowViewController().then {
                        $0.modalPresentationStyle = .overFullScreen
                        $0.userNFTItem = item
                    })
                }
            }
        } else {
            dismiss(animated: true)
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        view.backgroundColor = color(0, 0, 0, 0.5)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        view.backgroundColor = .clear
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CollectionCell.self, for: indexPath)
        cell.contentView.backgroundColor = .white
        cell.clipsToBounds = false
        cell.contentView.clipsToBounds = false
        cell.selectMarkView.isHidden = indexPath.item != selectIndex
        
        if let item = list[safe: indexPath.item] {
            let imageWidth = (UIManager.shared.screenWidth - 20*2 - 18)/2.0
            cell.imageView.setWebImage(url: OSSUploader.imageNFTURLFor((item.info?.cover?.guid).nonnull, crop: .medium), cornerRadius: 12.0*3, finalSize: CGSize(width: imageWidth*3.0, height: imageWidth*3.0))
            cell.textLabel.text = (item.info?.name).nonnull + "#\(item.goodsNum.nonnull)"
        }

        return cell
    }
    
    var selectIndex: Int?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndex = indexPath.item
        collectionView.reloadData()
        
        if let item = list[safe: indexPath.item] {
            if item.isOnSale {
                submitBtn.setTitle("取消出售", for: .normal)
            } else {
                submitBtn.setTitle("出售", for: .normal)
            }
        }
    }
    
    fileprivate class CollectionCell: UICollectionViewCell {
        lazy var imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(-28)
            }
        }
        
        lazy var textLabel = UILabel().then {
            $0.font = .mediumPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            $0.textAlignment = .center
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(imageView)
                make.height.equalTo(20)
                make.bottom.equalToSuperview()
            }
        }
        
        lazy var selectMarkView = UIView().then {
            $0.isHidden = true
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 12.0
            $0.layer.borderColor = color(51, 186, 255).cgColor
            $0.layer.borderWidth = 2.0
            contentView.insertSubview($0, belowSubview: imageView)
            $0.snp.makeConstraints { make in
                make.center.equalTo(imageView)
                make.width.height.equalTo(imageView).offset(8)
            }
        }
    }
}
