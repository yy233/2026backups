//
//  NFTDetailSaleEmptyViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/15.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import YYImage

final class NFTDetailSaleEmptyViewController: UIViewController {
    
    var nftInfo: NFTInfo?
    
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
                make.height.equalTo(273)
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
            $0.text = nftInfo?.name ?? "HENRY 未来已至"
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
        
        let _ = UIButton().then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 12
            $0.setTitle("确定", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 16)
            $0.addTarget(self, action: #selector(dismissBtnTap), for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.bottom.equalTo(UIManager.shared.isNotchScreen ? -42 : -18)
                make.height.equalTo(44)
            }
        }
        
        let _ = UIImageView().then {
            $0.image = UIImage(named: "lab_nft_sale_empty")
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(180)
                make.height.equalTo(46)
                make.centerX.equalToSuperview()
                make.top.equalTo(descLabel.snp.bottom).offset(30)
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
