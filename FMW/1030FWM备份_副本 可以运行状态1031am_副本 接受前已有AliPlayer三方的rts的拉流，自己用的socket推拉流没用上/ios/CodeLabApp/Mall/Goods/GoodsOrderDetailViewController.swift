//
//  GoodsOrderDetailViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/10/16.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import APIKit

final class GoodsOrderDetailViewController: BaseViewController {

    var orderItem: GoodsOrderItem?
    
    private let statusLabel = UILabel()
    private let statusDesc = UILabel()
    private let copyBtn = UIButton()
    private let payBtn = UIButton()
    private let afterSaleBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "订单详情"
        
        let _ = UIButton().then {
            $0.setImage(UIImage(named: "lab_goods_chat"), for: .normal)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.addAction(UIAction() { _ in
                UIManager.push(to: ChatViewController().then { $0.chatWith = AppContext.assistorUserID })
            }, for: .touchUpInside)
            customBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.right.equalTo(-16)
                make.centerY.equalTo(customBackBtn)
            }
        }
        
        Network.request(GoodsAPI.orderDetailInfo, parameters: ["orderId": (orderItem?.id).nonnull]).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let data = response.data?.jsonData(), let orderItem = try? JSONDecoder().decode(GoodsOrderItem.self, from: data) {
                self.orderItem = orderItem
                
                let bottomBar = UIView().then {
                    $0.backgroundColor = .white
                    $0.layer.shadowOffset = CGSize(width: 0, height: -2)
                    $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
                    $0.layer.shadowRadius = 4
                    $0.layer.shadowOpacity = 1
                    self.view.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.right.bottom.equalToSuperview()
                        make.height.equalTo(UIManager.shared.isNotchScreen ? 84 : 60)
                    }
                }
                
                //MARK: - 底部菜单
                switch orderItem.status {
                case .needPay:
                    self.payBtn.do {
                        $0.backgroundColor = .black
                        $0.layer.cornerRadius = 8
                        $0.setTitle("去支付", for: .normal)
                        $0.setTitleColor(.white, for: .normal)
                        $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                        $0.addAction(UIAction() { _ in
                            HUD.show()
                            Network.request(GoodsAPI.orderPay, parameters: ["orderId": orderItem.id]).responseData { response in
                                HUD.hide()
                                if let error = response.error {
                                    Toast.toast(title: error.localizedDescription)
                                } else {
                                    Toast.toast(title: "支付完成")
                                    self.orderItem?.status = .payWaitSend
                                    self.statusLabel.text = self.orderItem?.statusTitle
                                    self.statusDesc.text = self.orderItem?.statusDesc
                                    self.payBtn.setTitle("已支付", for: .normal)
                                    self.payBtn.isEnabled = false
                                    NotificationCenter.default.post(name: .notificationOrderDidUpdate, object: self.orderItem)
                                }
                            }
                        }, for: .touchUpInside)
                        bottomBar.addSubview($0)
                        $0.snp.makeConstraints { make in
                            make.right.equalTo(-16)
                            make.width.equalTo(102)
                            make.top.equalTo(14)
                            make.height.equalTo(44)
                        }
                    }
                    
                    let _ = UIButton().then {
                        $0.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
                        $0.setTitle("取消订单", for: .normal)
                        $0.setTitleColor(color(0, 0, 0, 0.4), for: .normal)
                        $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
                        $0.addAction(UIAction() { _ in
                            Alert.show(title: "确认要取消此订单?", submitBtnTapHandler: {
                                HUD.show()
                                Network.request(GoodsAPI.orderCancel, parameters: ["orderId": orderItem.id]).responseData { response in
                                    HUD.hide()
                                    if let error = response.error {
                                        Toast.toast(title: error.localizedDescription)
                                    } else {
                                        Toast.toast(title: "订单已取消")
                                        self.orderItem?.status = .cancel
                                        self.statusLabel.text = self.orderItem?.statusTitle
                                        self.statusDesc.text = self.orderItem?.statusDesc
                                        self.copyBtn.isHidden = true
                                        bottomBar.isHidden = true
                                        NotificationCenter.default.post(name: .notificationOrderDidUpdate, object: self.orderItem)
                                    }
                                }
                            })
                        }, for: .touchUpInside)
                        bottomBar.addSubview($0)
                        $0.snp.makeConstraints { make in
                            make.left.equalTo(16)
                            make.width.equalTo(48)
                            make.centerY.equalTo(self.payBtn)
                            make.height.equalTo(17)
                        }
                    }
                case .payWaitSend, .sendWaitReceive:
                    let _ = UIButton().then {
                        $0.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
                        $0.layer.cornerRadius = 8.0
                        $0.layer.borderColor = color(0, 0, 0, 0.4).cgColor
                        $0.layer.borderWidth = 1.0
                        $0.setTitle("取消订单", for: .normal)
                        $0.setTitleColor(color(0, 0, 0, 0.4), for: .normal)
                        $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                        $0.addAction(UIAction() { _ in
                            Alert.show(title: "确认要取消此订单?", submitBtnTapHandler: {
                                HUD.show()
                                Network.request(GoodsAPI.orderCancel, parameters: ["orderId": orderItem.id]).responseData { response in
                                    HUD.hide()
                                    if let error = response.error {
                                        Toast.toast(title: error.localizedDescription)
                                    } else {
                                        Toast.toast(title: "订单已取消")
                                        self.orderItem?.status = .cancel
                                        self.statusLabel.text = self.orderItem?.statusTitle
                                        self.statusDesc.text = self.orderItem?.statusDesc
                                        self.copyBtn.isHidden = true
                                        bottomBar.isHidden = true
                                        NotificationCenter.default.post(name: .notificationOrderDidUpdate, object: self.orderItem)
                                    }
                                }
                            })
                        }, for: .touchUpInside)
                        bottomBar.addSubview($0)
                        $0.snp.makeConstraints { make in
                            make.centerX.equalToSuperview()
                            make.width.equalTo(136)
                            make.top.equalTo(14)
                            make.height.equalTo(40)
                        }
                    }
                case .receivedFinish, .saleServiceHanding:
                    self.afterSaleBtn.do {
                        $0.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
                        $0.layer.cornerRadius = 8.0
                        $0.layer.borderColor = color(0, 0, 0, 0.4).cgColor
                        $0.layer.borderWidth = 1.0
                        $0.setTitle(self.orderItem?.status == .saleServiceHanding ? "取消" : "申请售后", for: .normal)
                        $0.setTitleColor(color(0, 0, 0, 0.4), for: .normal)
                        $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                        $0.addAction(UIAction() { _ in
                            if self.orderItem?.status == .saleServiceHanding {
                                Alert.show(title: "确认要取消退货申请?", submitBtnTapHandler: {
                                    HUD.show()
                                    Network.request(GoodsAPI.orderAfterSaleCancel, parameters: ["orderId": orderItem.id]).responseData { response in
                                        HUD.hide()
                                        if let error = response.error {
                                            Toast.toast(title: error.localizedDescription)
                                        } else {
                                            Toast.toast(title: "退货申请已取消")
                                            self.orderItem?.status = .receivedFinish
                                            self.statusLabel.text = self.orderItem?.statusTitle
                                            self.statusDesc.text = self.orderItem?.statusDesc
                                            self.afterSaleBtn.setTitle("申请售后", for: .normal)
                                            self.copyBtn.isHidden = false
                                            NotificationCenter.default.post(name: .notificationOrderDidUpdate, object: self.orderItem)
                                        }
                                    }
                                })
                            } else {
                                Alert.show(title: "确认要申请退货?", submitBtnTapHandler: {
                                    HUD.show()
                                    Network.request(GoodsAPI.orderAfterSale, parameters: ["orderId": orderItem.id]).responseData { response in
                                        HUD.hide()
                                        if let error = response.error {
                                            Toast.toast(title: error.localizedDescription)
                                        } else {
                                            Toast.toast(title: "退货申请已提交")
                                            self.orderItem?.status = .saleServiceHanding
                                            self.statusLabel.text = self.orderItem?.statusTitle
                                            self.statusDesc.text = self.orderItem?.statusDesc
                                            self.afterSaleBtn.setTitle("取消", for: .normal)
                                            self.copyBtn.isHidden = true
                                            NotificationCenter.default.post(name: .notificationOrderDidUpdate, object: self.orderItem)
                                        }
                                    }
                                })
                            }
                        }, for: .touchUpInside)
                        bottomBar.addSubview($0)
                        $0.snp.makeConstraints { make in
                            make.centerX.equalToSuperview()
                            make.width.equalTo(136)
                            make.top.equalTo(14)
                            make.height.equalTo(40)
                        }
                    }
                default:
                    bottomBar.isHidden = true
                }
                
                let scrollView = UIScrollView().then {
                    $0.backgroundColor = .white
                    $0.showsVerticalScrollIndicator = false
                    $0.showsHorizontalScrollIndicator = false
                    $0.alwaysBounceVertical = true
                    self.view.insertSubview($0, belowSubview: bottomBar)
                    $0.snp.makeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.top.equalTo(self.customBar.snp.bottom)
                        make.bottom.equalTo(bottomBar.snp.top)
                    }
                }
                
                let contentView = UIView().then {
                    $0.backgroundColor = .white
                    scrollView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.top.bottom.equalToSuperview()
                        make.width.equalTo(self.view)
                    }
                }
                
                //MARK: - 状态
                let headerView = UIView().then {
                    $0.backgroundColor = .black
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.top.equalTo(self.customBar.snp.bottom)
                        make.height.equalTo(118)
                    }
                }
                
                self.statusLabel.do {
                    $0.text = orderItem.statusTitle
                    $0.textColor = .white
                    $0.font = .regularPingFangSCFont(ofSize: 20)
                    headerView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(16)
                        make.height.equalTo(28)
                        make.top.equalTo(30)
                        make.right.equalTo(-16)
                    }
                }
                
                self.statusDesc.do {
                    $0.text = orderItem.statusDesc
                    $0.textColor = .white
                    $0.font = .regularPingFangSCFont(ofSize: 14)
                    headerView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(16)
                        make.height.equalTo(20)
                        make.top.equalTo(self.statusLabel.snp.bottom).offset(10)
                        make.right.lessThanOrEqualTo(-16)
                    }
                }
                
                self.copyBtn.do {
                    $0.isHidden = orderItem.status != .sendWaitReceive && orderItem.status != .receivedFinish
                    $0.setImage(UIImage(named: "lab_order_header_copy"), for: .normal)
                    $0.addAction(UIAction() { _ in
                        UIPasteboard.general.string = self.statusDesc.text
                        Toast.toast(title: "快递单号已复制到粘贴板")
                    }, for: .touchUpInside)
                    headerView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.width.height.equalTo(24)
                        make.centerY.equalTo(self.statusDesc)
                        make.left.equalTo(self.statusDesc.snp.right).offset(8)
                    }
                }
                
                //MARK: - 商品信息
                let goodsImageView = UIImageView().then {
                    $0.setWebImage(url: (orderItem.goodsInfo?.cover?.guid).nonnull)
                    $0.layer.cornerRadius = 8.0
                    $0.layer.borderColor = color(0, 0, 0, 0.4).cgColor
                    $0.layer.borderWidth = 1.0
                    $0.layer.masksToBounds = true
                    $0.contentMode = .scaleAspectFill
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(16)
                        make.top.equalTo(headerView.snp.bottom).offset(20)
                        make.width.height.equalTo(100)
                    }
                }
                
                let nameLabel = UILabel().then {
                    $0.text = orderItem.goodsInfo?.name
                    $0.textColor = .black
                    $0.font = .mediumPingFangSCFont(ofSize: 16)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(goodsImageView.snp.right).offset(20)
                        make.right.equalTo(-20)
                        make.height.equalTo(23)
                        make.top.equalTo(goodsImageView)
                    }
                }
                
                let sizeLabel = UILabel().then {
                    $0.text = orderItem.chooseSize
                    $0.textColor = color(0, 0, 0, 0.4)
                    $0.font = .regularPingFangSCFont(ofSize: 14)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(nameLabel)
                        make.right.equalTo(-20)
                        make.height.equalTo(20)
                        make.top.equalTo(nameLabel.snp.bottom).offset(10)
                    }
                }
                
                let _ = UILabel().then {
                    $0.text = String(format: "￥ %.02f", orderItem.payAllMoney.nonnull)
                    $0.textColor = color(0, 0, 0, 0.4)
                    $0.font = .regularPingFangSCFont(ofSize: 14)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(nameLabel)
                        make.right.equalTo(-20)
                        make.height.equalTo(20)
                        make.top.equalTo(sizeLabel.snp.bottom).offset(10)
                    }
                }
                
                let _ = UIView().then {
                    $0.backgroundColor = color(246, 246, 246)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.height.equalTo(20)
                        make.top.equalTo(goodsImageView.snp.bottom).offset(20)
                    }
                }
                
                let _ = UIButton().then {
                    $0.addAction(UIAction() { _ in
                        UIManager.push(to: GoodsDetailViewController().then { $0.goodItem = orderItem.goodsInfo })
                    }, for: .touchUpInside)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.top.bottom.equalTo(goodsImageView)
                        make.right.equalTo(-16)
                    }
                }
                
                //MARK: - 配送信息
                let sendLabel = UILabel().then {
                    $0.text = "配送信息"
                    $0.textColor = .black
                    $0.font = .mediumPingFangSCFont(ofSize: 16)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(16)
                        make.width.equalTo(80)
                        make.height.equalTo(23)
                        make.top.equalTo(goodsImageView.snp.bottom).offset(74.5)
                    }
                }
                
                let _ = UILabel().then {
                    $0.text = "\((orderItem.addressInfo?.name).nonnull)\n\((orderItem.addressInfo?.mobile).nonnull)\n\((orderItem.addressInfo?.city).nonnull)\((orderItem.addressInfo?.address).nonnull)"
                    $0.textColor = color(0, 0, 0, 0.4)
                    $0.font = .regularPingFangSCFont(ofSize: 14)
                    $0.adjustsFontSizeToFitWidth = true
                    $0.textAlignment = .right
                    $0.numberOfLines = 0
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.right.equalTo(-16)
                        make.left.equalTo(120)
                        make.height.equalTo(54)
                        make.centerY.equalTo(sendLabel)
                    }
                }
                
                let _ = UIView().then {
                    $0.backgroundColor = color(246, 246, 246)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.height.equalTo(20)
                        make.top.equalTo(sendLabel.snp.bottom).offset(34.5)
                    }
                }
                
                //MARK: - 快递信息
                var topView = sendLabel
                if orderItem.expressNo.nonnull.isNotEmpty {
                    let mailLabel = UILabel().then {
                        $0.text = "快递信息"
                        $0.textColor = .black
                        $0.font = .mediumPingFangSCFont(ofSize: 16)
                        contentView.addSubview($0)
                        $0.snp.makeConstraints { make in
                            make.left.equalTo(16)
                            make.width.equalTo(80)
                            make.height.equalTo(23)
                            make.top.equalTo(sendLabel.snp.bottom).offset(74.5)
                        }
                    }
                    topView = mailLabel
                    
                    let _ = UILabel().then {
                        $0.text = orderItem.expressNo
                        $0.textColor = color(0, 0, 0, 0.4)
                        $0.font = .regularPingFangSCFont(ofSize: 14)
                        $0.textAlignment = .right
                        contentView.addSubview($0)
                        $0.snp.makeConstraints { make in
                            make.right.equalTo(-50)
                            make.left.equalTo(120)
                            make.height.equalTo(20)
                            make.centerY.equalTo(mailLabel)
                        }
                    }
                    
                    let _ = UIButton().then {
                        $0.setImage(UIImage(named: "lab_order_copy"), for: .normal)
                        $0.addAction(UIAction() { _ in
                            UIPasteboard.general.string = orderItem.expressNo
                            Toast.toast(title: "快递单号已复制到粘贴板")
                        }, for: .touchUpInside)
                        contentView.addSubview($0)
                        $0.snp.makeConstraints { make in
                            make.right.equalTo(-16)
                            make.width.height.equalTo(24)
                            make.centerY.equalTo(mailLabel)
                        }
                    }
                    
                    let _ = UIView().then {
                        $0.backgroundColor = color(246, 246, 246)
                        contentView.addSubview($0)
                        $0.snp.makeConstraints { make in
                            make.left.right.equalToSuperview()
                            make.height.equalTo(20)
                            make.top.equalTo(mailLabel.snp.bottom).offset(20)
                        }
                    }
                }
                
                //MARK: - 订单编号
                let orderLabel = UILabel().then {
                    $0.text = "订单编号"
                    $0.textColor = .black
                    $0.font = .mediumPingFangSCFont(ofSize: 16)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(16)
                        make.width.equalTo(80)
                        make.height.equalTo(23)
                        make.top.equalTo(topView.snp.bottom).offset(74.5)
                    }
                }
                
                let _ = UILabel().then {
                    $0.text = "\(orderItem.id)"
                    $0.textColor = color(0, 0, 0, 0.4)
                    $0.font = .regularPingFangSCFont(ofSize: 14)
                    $0.textAlignment = .right
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.right.equalTo(-16)
                        make.left.equalTo(120)
                        make.height.equalTo(20)
                        make.centerY.equalTo(orderLabel)
                    }
                }
                
                let _ = UIView().then {
                    $0.backgroundColor = color(246, 246, 246)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.height.equalTo(1)
                        make.top.equalTo(orderLabel.snp.bottom).offset(20)
                    }
                }
                
                //MARK: - 订单日期
                let dateLabel = UILabel().then {
                    $0.text = "订单日期"
                    $0.textColor = .black
                    $0.font = .mediumPingFangSCFont(ofSize: 16)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.equalTo(16)
                        make.width.equalTo(80)
                        make.height.equalTo(23)
                        make.top.equalTo(orderLabel.snp.bottom).offset(41)
                    }
                }
                
                let _ = UILabel().then {
                    $0.text = Date(timeIntervalSince1970: orderItem.createTimeMills.nonnull/1000.0).displayString(specific: true, relative: .full)
                    $0.textColor = color(0, 0, 0, 0.4)
                    $0.font = .regularPingFangSCFont(ofSize: 14)
                    $0.textAlignment = .right
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.right.equalTo(-16)
                        make.left.equalTo(120)
                        make.height.equalTo(20)
                        make.centerY.equalTo(dateLabel)
                    }
                }
                
                let _ = UIView().then {
                    $0.backgroundColor = color(246, 246, 246)
                    contentView.addSubview($0)
                    $0.snp.makeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.height.equalTo(1)
                        make.top.equalTo(dateLabel.snp.bottom).offset(20)
                        make.bottom.equalTo(-20)
                    }
                }
            }
        }
    }
}
