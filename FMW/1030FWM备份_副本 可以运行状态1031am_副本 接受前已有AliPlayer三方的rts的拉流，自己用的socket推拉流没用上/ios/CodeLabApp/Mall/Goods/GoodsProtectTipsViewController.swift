//
//  GoodsProtectTipsViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/13.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit

final class GoodsProtectTipsViewController: UIViewController {
    
    var goodsItem: GoodsItem?

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
            $0.text = "保障"
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
        
        if let goodsItem = goodsItem {
            if let guarantees = goodsItem.guarantees {
                var topLabel: UIView?
                for item in guarantees {
                    let imageView1 = UIImageView().then {
                        $0.image = UIImage(named: "ge_icon_tips_lead")
                        contentView.addSubview($0)
                        $0.snp.makeConstraints { make in
                            make.left.equalTo(titleLabel)
                            make.width.height.equalTo(14)
                            
                            if let topLabel = topLabel {
                                make.top.equalTo(topLabel.snp.bottom).offset(24)
                            } else {
                                make.top.equalTo(titleLabel.snp.bottom).offset(22)
                            }
                        }
                    }
                    
                    let lable1 = UILabel().then {
                        $0.text = item.title
                        $0.textColor = .black
                        $0.font = .semiboldPingFangSCFont(ofSize: 14)
                        contentView.addSubview($0)
                        $0.snp.makeConstraints { make in
                            make.left.equalTo(imageView1.snp.right).offset(6)
                            make.right.equalTo(-20)
                            make.height.equalTo(20)
                            make.centerY.equalTo(imageView1)
                        }
                    }
                    
                    let lable11 = UILabel().then {
                        $0.text = item.desc
                        $0.textColor = .black.withAlphaComponent(0.4)
                        $0.font = .regularPingFangSCFont(ofSize: 12)
                        $0.numberOfLines = 0
                        contentView.addSubview($0)
                        $0.snp.makeConstraints { make in
                            make.left.right.equalTo(lable1)
                            make.height.lessThanOrEqualTo(200)
                            make.top.equalTo(lable1.snp.bottom).offset(8)
                        }
                    }
                    topLabel = lable11
                }
            }
        } else {
            let imageView1 = UIImageView().then {
                $0.image = UIImage(named: "ge_icon_tips_lead")
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(titleLabel)
                    make.top.equalTo(titleLabel.snp.bottom).offset(22)
                    make.width.height.equalTo(14)
                }
            }
            
            let lable1 = UILabel().then {
                $0.text = "假一赔十"
                $0.textColor = .black
                $0.font = .semiboldPingFangSCFont(ofSize: 14)
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(imageView1.snp.right).offset(6)
                    make.right.equalTo(-20)
                    make.height.equalTo(20)
                    make.centerY.equalTo(imageView1)
                }
            }
            
            let lable11 = UILabel().then {
                $0.text = "我们所有的商品都是合作品牌源头直供及全球潮流买手精心挑选的高品质正品，平台内所有合作商家均具有品牌方授权，官方正品保障，假一赔十"
                $0.textColor = .black.withAlphaComponent(0.4)
                $0.font = .regularPingFangSCFont(ofSize: 12)
                $0.numberOfLines = 0
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalTo(lable1)
                    make.height.lessThanOrEqualTo(200)
                    make.top.equalTo(lable1.snp.bottom).offset(8)
                }
            }
            
            let imageView2 = UIImageView().then {
                $0.image = UIImage(named: "ge_icon_tips_lead")
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(imageView1)
                    make.top.equalTo(lable11.snp.bottom).offset(24)
                    make.width.height.equalTo(14)
                }
            }
            
            let lable2 = UILabel().then {
                $0.text = "极速退款"
                $0.textColor = .black
                $0.font = .semiboldPingFangSCFont(ofSize: 14)
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(imageView2.snp.right).offset(6)
                    make.right.equalTo(-20)
                    make.height.equalTo(20)
                    make.centerY.equalTo(imageView2)
                }
            }
            
            let lable22 = UILabel().then {
                $0.text = "高信誉用户在退货寄出后，享受2小时极速退款到账服务"
                $0.textColor = .black.withAlphaComponent(0.4)
                $0.font = .regularPingFangSCFont(ofSize: 12)
                $0.numberOfLines = 0
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalTo(lable2)
                    make.height.lessThanOrEqualTo(200)
                    make.top.equalTo(lable2.snp.bottom).offset(8)
                }
            }
        }
        
        
        let _ = UIButton().then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 12
            $0.setTitle("确定", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 16)
            $0.addTarget(self, action: #selector(dismissBtnTap), for: .touchUpInside)
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
