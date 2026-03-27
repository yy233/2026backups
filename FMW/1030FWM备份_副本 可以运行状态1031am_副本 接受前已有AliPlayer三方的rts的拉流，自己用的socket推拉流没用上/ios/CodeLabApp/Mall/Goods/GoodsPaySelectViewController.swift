//
//  GoodsPaySelectViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/10/13.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit

final class GoodsPaySelectViewController: UIViewController {
    
    var isAlipay = true
    var didSelectHandler: ((Bool) -> Void)?
    
    private let contentView = UIView()
    private let alipyBtn = UIButton()
    private let wechatBtn = UIButton()

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
        
        let titleLabel = UILabel().then {
            $0.text = "选择付款方式"
            $0.textColor = .black
            $0.font = .semiboldPingFangSCFont(ofSize: 18)
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
                make.right.equalTo(-15)
                make.width.height.equalTo(20)
                make.centerY.equalTo(titleLabel)
            }
        }
        
        let imageView1 = UIImageView().then {
            $0.image = UIImage(named: "lab_goods_pay_alipay")
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(titleLabel)
                make.top.equalTo(titleLabel.snp.bottom).offset(30)
                make.width.height.equalTo(44)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "支付宝"
            $0.textColor = .black
            $0.font = .regularPingFangSCFont(ofSize: 16)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(imageView1.snp.right).offset(10)
                make.right.equalTo(-60)
                make.height.equalTo(23)
                make.centerY.equalTo(imageView1)
            }
        }
        
        alipyBtn.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -UIManager.shared.screenWidth, bottom: -10, right: -20)
            $0.isSelected = isAlipay
            $0.setImage(UIImage(named: "lab_pay_normal"), for: .normal)
            $0.setImage(UIImage(named: "lab_pay_selected"), for: .selected)
            $0.addAction(UIAction() {[unowned self] _ in
                alipyBtn.isSelected = true
                wechatBtn.isSelected = false
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.height.equalTo(24)
                make.centerY.equalTo(imageView1)
            }
        }
        
        let imageView2 = UIImageView().then {
            $0.image = UIImage(named: "lab_goods_pay_wechat")
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(titleLabel)
                make.top.equalTo(imageView1.snp.bottom).offset(30)
                make.width.height.equalTo(44)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "微信"
            $0.textColor = .black
            $0.font = .regularPingFangSCFont(ofSize: 16)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(imageView2.snp.right).offset(10)
                make.right.equalTo(-60)
                make.height.equalTo(23)
                make.centerY.equalTo(imageView2)
            }
        }
        
        wechatBtn.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -UIManager.shared.screenWidth, bottom: -10, right: -20)
            $0.isSelected = !isAlipay
            $0.setImage(UIImage(named: "lab_pay_normal"), for: .normal)
            $0.setImage(UIImage(named: "lab_pay_selected"), for: .selected)
            $0.addAction(UIAction() {[unowned self] _ in
                alipyBtn.isSelected = false
                wechatBtn.isSelected = true
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.height.equalTo(24)
                make.centerY.equalTo(imageView2)
            }
        }
        
        let _ = UIButton().then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 12
            $0.setTitle("确定", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 16)
            $0.addAction(UIAction() {[unowned self] _ in
                didSelectHandler?(alipyBtn.isSelected)
                dismiss(animated: true)
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.bottom.equalTo(UIManager.shared.isNotchScreen ? -42 : -8)
                make.height.equalTo(44)
            }
        }
    }
    
    @objc fileprivate func dismissBtnTap() {
        dismiss(animated: true)
    }
}
