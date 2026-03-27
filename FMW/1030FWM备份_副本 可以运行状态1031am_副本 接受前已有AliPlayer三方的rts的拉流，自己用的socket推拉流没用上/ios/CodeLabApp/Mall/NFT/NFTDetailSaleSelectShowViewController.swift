//
//  NFTDetailSaleSelectShowViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/15.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import APIKit

final class NFTDetailSaleSelectShowViewController: UIViewController {
    
    var userNFTItem: UserNFTItem? {
        didSet {
            nftInfo = userNFTItem?.info
        }
    }
    
    private var nftInfo: NFTInfo?
    
    private let contentView = UIView()
    private let priceTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        contentView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(441)
            }
        }
        
        let titleLabel = UILabel().then {
            $0.text = "确认寄售"
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
            $0.text = (nftInfo?.name).nonnull + "#\((userNFTItem?.goodsNum).nonnull)"
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
        
        let nftImageView = UIImageView().then {
            $0.setWebImage(url: OSSUploader.imageNFTURLFor((nftInfo?.cover?.guid).nonnull, crop: .medium), cornerRadius: 8.0*3, finalSize: CGSize(width: 100*3.0, height: 100*3.0))
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(titleLabel)
                make.width.height.equalTo(100)
                make.top.equalTo(descLabel.snp.bottom).offset(24)
            }
        }
        
        
        let priceLabel = UILabel().then {
            $0.text = "价格"
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 14)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(titleLabel)
                make.height.equalTo(20)
                make.top.equalTo(nftImageView.snp.bottom).offset(20)
            }
        }
        
        let priceBackView = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 8.0
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(44)
                make.top.equalTo(priceLabel.snp.bottom).offset(16)
            }
        }
        
        priceTextField.do {
            $0.font = UIFont.mediumPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            $0.keyboardType = .numberPad
            $0.returnKeyType = .done
            $0.clearButtonMode = .never
            $0.attributedPlaceholder = NSAttributedString(string: "请输入售价", attributes: [.font: UIFont.regularPingFangSCFont(ofSize: 14), .foregroundColor: color(152, 152, 152)])
            priceBackView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.bottom.equalToSuperview()
            }
        }
        
        let cancelBtn = UIButton().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 1.0
            $0.setTitle("取消", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 16)
            $0.addTarget(self, action: #selector(dismissBtnTap), for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.width.equalTo(125)
                make.bottom.equalTo(UIManager.shared.isNotchScreen ? -42 : -18)
                make.height.equalTo(44)
            }
        }
        
        let _ = UIButton().then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 12
            $0.setTitle("出售", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 16)
            $0.addTarget(self, action: #selector(submitBtnTap), for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(cancelBtn.snp.right).offset(8)
                make.right.equalTo(-20)
                make.centerY.height.equalTo(cancelBtn)
            }
        }
    }
    
    @objc fileprivate func dismissBtnTap() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func submitBtnTap() {
        if let price = Int(priceTextField.text.nonnull), price > 0 {
            HUD.show()
            Network.request(NFTAPI.onSaleByProxy, parameters: ["userGoodsId": (userNFTItem?.userGoodsId).nonnull, "points": price]).responseData { response in
                HUD.hide()
                if let error = response.error {
                    Toast.toast(title: error.localizedDescription)
                } else {
                    self.dismiss(animated: true) {
                        Alert.show(title: "寄售成功", message: "您的藏品已上架，成功出售后系统会通知您", cancelBtnTitle: nil, submitBtnTitle: "确定")
                    }
                }
            }
        } else {
            Toast.toast(title: "请输入正确的售价")
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
}
