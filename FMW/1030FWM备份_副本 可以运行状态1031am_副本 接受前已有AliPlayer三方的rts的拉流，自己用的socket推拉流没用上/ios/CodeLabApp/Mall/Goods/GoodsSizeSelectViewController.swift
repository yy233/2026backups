//
//  GoodsSizeSelectViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/13.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import APIKit

final class GoodsSizeSelectViewController: UIViewController {
    
    var goodsItem: GoodsItem?
    private let contentView = UIView()
    private let selectSizeLabel = UILabel()
    private let payBtn = UIButton()
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.location(in: view).y < contentView.frame.minY {
            dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        contentView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.shadowOffset = CGSize(width: 0, height: -2)
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
            $0.layer.shadowRadius = 4
            $0.layer.shadowOpacity = 1
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(UIManager.shared.screenHeight - 200 > 546 ? 546 : UIManager.shared.screenHeight - 200)
            }
        }
        
        let _ = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
            $0.setImage(UIImage(named: "lab_goods_modal_dismiss"), for: .normal)
            $0.addTarget(self, action: #selector(dismissBtnTap), for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-15)
                make.width.height.equalTo(24)
                make.top.equalTo(20)
            }
        }
        
        let imageBack = UIView().then {
            $0.layer.cornerRadius = 8.0
            $0.backgroundColor = color(231, 231, 231)
            $0.layer.masksToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.equalTo(20)
                make.width.height.equalTo(100)
            }
        }
        
        let _ = UIImageView().then {
            $0.setWebImage(url: (goodsItem?.cover?.guid).nonnull)
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            imageBack.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(100)
                make.center.equalToSuperview()
            }
        }
        
        selectSizeLabel.do {
            $0.text = "请选择规格"
            $0.textColor = color(152, 152, 152)
            $0.font = .regularPingFangSCFont(ofSize: 12)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(imageBack.snp.right).offset(16)
                make.right.equalTo(-20)
                make.height.equalTo(17)
                make.bottom.equalTo(imageBack)
            }
        }
        
        let priceLabel = UILabel().then {
            $0.text = String(format: "￥ %.02f", (goodsItem?.price).nonnull)
            $0.textColor = color(255, 38, 111)
            $0.font = .gothamBoldFont(ofSize: 24)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(selectSizeLabel)
                make.right.equalTo(-20)
                make.height.lessThanOrEqualTo(50)
                make.bottom.equalTo(selectSizeLabel.snp.top).offset(-8)
            }
        }
        
        let sizeLabel = UILabel().then {
            $0.text = "规格"
            $0.textColor = .black
            $0.font = .semiboldPingFangSCFont(ofSize: 16)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(imageBack)
                make.right.equalTo(-20)
                make.height.equalTo(23)
                make.top.equalTo(imageBack.snp.bottom).offset(23)
            }
        }
        
        let btnWidth = (UIManager.shared.screenWidth - 80)/3.0
        
        if let size = goodsItem?.size {
            for i in 0..<size.count {
                let item = size[i]
                let _ = UIButton().then {
                    $0.setTitle(item.type, for: .normal)
                    $0.tag = i + 9999
                    $0.setTitleColor(.black, for: .normal)
                    $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 14)
                    $0.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
                    $0.layer.borderWidth = 1
                    $0.addTarget(self, action: #selector(sizeBtnTap(sender:)), for: .touchUpInside)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        if i%3 == 0 {
                            make.left.equalTo(sizeLabel)
                        } else if i%3 == 2 {
                            make.right.equalTo(-20)
                        } else {
                            make.centerX.equalToSuperview()
                        }
                        make.top.equalTo(sizeLabel.snp.bottom).offset(20 + i/3*60)
                        make.height.equalTo(40)
                        make.width.equalTo(btnWidth)
                    }
                }
            }
        }
        
        payBtn.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 8
            $0.setTitle("立即购买", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 16)
            $0.addAction(UIAction() {[unowned self] _ in
                guard let selectBtn = selectBtn else {
                    Toast.toast(title: "请选择规格")
                    return
                }
                
                let tag = selectBtn.tag - 9999
                if let item = goodsItem?.size?[safe: tag] {
                    selectSizeLabel.text = item.type
                    payBtn.setTitle(String(format: "￥%.02f 立即购买", item.price.nonnull), for: .normal)
                    dismiss(animated: true) {
                        UIManager.push(to: GoodsPayViewController().then {
                            $0.goodsItem = self.goodsItem
                            $0.selectSize = item
                        })
                    }
                }
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.bottom.equalTo(-40)
                make.height.equalTo(44)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "*商品由合作商家提供，下单后7天内发货"
            $0.textColor = color(152, 152, 152)
            $0.font = .regularPingFangSCFont(ofSize: 12)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(payBtn)
                make.right.equalTo(-20)
                make.height.equalTo(17)
                make.bottom.equalTo(payBtn.snp.top).offset(-16)
            }
        }
    }
    
    @objc fileprivate func dismissBtnTap() {
        dismiss(animated: true)
    }
    
    private var selectBtn: UIButton?
    @objc fileprivate func sizeBtnTap(sender: UIButton) {
        if !sender.isSelected {
            selectBtn?.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
            sender.layer.borderColor = UIColor.black.cgColor
            selectBtn = sender
            
            let tag = sender.tag - 9999
            if let item = goodsItem?.size?[safe: tag] {
                selectSizeLabel.text = item.type
                payBtn.setTitle(String(format: "￥%.02f 立即购买", item.price.nonnull), for: .normal)
            }
        }
    }
}
