//
//  NFTDetailBuySelectResultViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/15.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import APIKit

final class NFTDetailBuySelectResultViewController: UIViewController {
    
    private var nftInfo: NFTInfo?
    var nftSale: NFTSaleItem? { didSet { nftInfo = nftSale?.nftInfo } }
    
    private let contentView = UIView()

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
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(441)
            }
        }
        
        let titleLabel = UILabel().then {
            $0.text = "数字藏品订单信息"
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
                make.top.equalTo(titleLabel.snp.bottom).offset(44)
            }
        }
        
        let priceLabel = UILabel().then {
            $0.text = "\((nftSale?.points).nonnull)"
            $0.font = .gothamBoldFont(ofSize: 24)
            $0.textColor = color(255, 38, 111)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(nftImageView.snp.right).offset(16)
                make.height.lessThanOrEqualTo(50)
                make.width.lessThanOrEqualTo(150)
                make.bottom.equalTo(nftImageView)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "积分"
            $0.font = .mediumPingFangSCFont(ofSize: 14)
            $0.textColor = color(255, 38, 111)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(priceLabel.snp.right).offset(5)
                make.height.equalTo(20)
                make.width.equalTo(28)
                make.centerY.equalTo(priceLabel)
            }
        }
        
        let _ = UILabel().then {
            $0.text = (nftInfo?.name).nonnull + "#\((nftSale?.goodsNum).nonnull)"
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 16)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(priceLabel)
                make.right.equalTo(-16)
                make.height.equalTo(22)
                make.bottom.equalTo(priceLabel.snp.top).offset(-8)
            }
        }
        
        let _ = UIButton().then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 12
            $0.setTitle("立即支付 \(priceLabel.text.nonnull)积分", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .gothamMediumFont(ofSize: 16)
            $0.addAction(UIAction() {[weak self] _ in
                HUD.show()
                Network.request(NFTAPI.nftPay, parameters: ["commissionId": (self?.nftSale?.id).nonnull]).responseData { response in
                    HUD.hide()
                    if let error = response.error {
                        Toast.toast(title: error.localizedDescription)
                    } else {
                        Toast.toast(title: "支付成功")
                        self?.dismiss(animated: true)
                    }
                }
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.bottom.equalTo(UIManager.shared.isNotchScreen ? -42 : -18)
                make.height.equalTo(44)
            }
        }
    }
    
    @objc fileprivate func dismissBtnTap() {
        dismiss(animated: true)
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
