//
//  GoodsPayViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/10/13.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import APIKit

final class GoodsPayViewController: BaseViewController {
    
    var goodsItem: GoodsItem?
    var selectSize: GoodsItem.GoodsSize?
    private var selectAddress: AddressItem?
    
    private let addressLabel = UILabel()
    private let payLabel = UILabel()
    private let payImageView = UIImageView()
    private let numberLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "结算"
        
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
        
        let submitBtn = UIButton().then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 8
            $0.setTitle(String(format: "￥ %.02f 立即支付", (selectSize?.price).nonnull), for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 16)
            $0.addAction(UIAction() {[unowned self] _ in
                if selectAddress == nil {
                    Toast.toast(title: "请填写收件人信息")
                    return
                }
                    
                let count = Int(numberLabel.text.nonnull).nonnull
                let price = (selectSize?.price).nonnull*Double(count)
                
                let para: [String: Any] = ["goodsId": (goodsItem?.id).nonnull,
                                           "chooseSize": (selectSize?.type).nonnull,
                                           "chooseAddressId": (selectAddress?.id).nonnull,
                                           "goodsNum": count,
                                           "payGoodsMoney": price,
                                           "payFreightMoney": 9,
                                           "payAllMoney": price,
                                           "payType": 1]
                
                HUD.show()
                Network.request(GoodsAPI.orderCreate, parameters: para).responseData { response in
                    HUD.hide()
                    if let error = response.error {
                        Toast.toast(title: error.localizedDescription)
                    } else {
                        //唤起支付宝支付
                        UIManager.push(to: GoodsOrderListViewController(), latestRemoved: true)
                    }
                }
            }, for: .touchUpInside)
            bottomBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(50)
                make.right.equalTo(-50)
                make.top.equalTo(14)
                make.height.equalTo(44)
            }
        }
        
        let scrollView = UIScrollView().then {
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.alwaysBounceVertical = true
            view.insertSubview($0, belowSubview: bottomBar)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(customBar.snp.bottom)
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
        
        let addressBtn = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -UIManager.shared.screenWidth)
            $0.setTitle("配送信息", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 16)
            $0.contentHorizontalAlignment = .left
            $0.addAction(UIAction() {[unowned self] _ in
                let addressVC = GoodsAddressListViewController()
                addressVC.addressItem = selectAddress
                addressVC.didSelectAddressHandler = { item in
                    self.selectAddress = item
                    self.addressLabel.text = "\(item.city)\(item.address) \(item.name)\(item.mobile)"
                    self.addressLabel.textColor = color(0, 0, 0, 0.4)
                }
                UIManager.push(to: addressVC)
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.top.equalTo(20)
                make.width.equalTo(100)
                make.height.equalTo(23)
            }
        }
        
        addressLabel.do {
            $0.textColor = color(167, 55, 55)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textAlignment = .right
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-37)
                make.height.equalTo(20)
                make.left.equalTo(addressBtn.snp.right).offset(40)
                make.centerY.equalTo(addressBtn)
            }
        }
        
        Network.request(GoodsAPI.addressList, parameters: ["offset": 0]).responseData { response in
            if let data = (response.data?["list"] as? [Any])?.jsonString.data(using: .utf8),
               let list = try? JSONDecoder().decode([AddressItem].self, from: data),
                let item = list.first {
                self.selectAddress = item
                self.addressLabel.text = "\(item.city)\(item.address) \(item.name)\(item.mobile)"
                self.addressLabel.textColor = color(0, 0, 0, 0.4)
            } else {
                self.addressLabel.text = "填写收件人信息"
            }
        }
        
        let _ = UIImageView().then {
            $0.image = UIImage(named: "ge_main_arrow")
            $0.contentMode = .scaleAspectFit
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.height.equalTo(16)
                make.centerY.equalTo(addressBtn)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.2)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(0.5)
                make.top.equalTo(addressBtn.snp.bottom).offset(20)
            }
        }
        
        let payBtn = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -UIManager.shared.screenWidth)
            $0.setTitle("付款方式", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 16)
            $0.contentHorizontalAlignment = .left
//            $0.addAction(UIAction() {[unowned self] _ in
//                let payVC = GoodsPaySelectViewController()
//                payVC.isAlipay = payLabel.text == "支付宝"
//                payVC.modalPresentationStyle = .overFullScreen
//                payVC.didSelectHandler = {[unowned self] isAlipay in
//                    payLabel.text = isAlipay ? "支付宝" : "微信"
//                    payImageView.image = UIImage(named: isAlipay ? "lab_goods_pay_alipay" : "lab_goods_pay_wechat")
//                }
//                UIManager.present(modal: payVC)
//            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.top.equalTo(addressBtn.snp.bottom).offset(41)
                make.width.equalTo(100)
                make.height.equalTo(23)
            }
        }
        
        payLabel.do {
            $0.text = "支付宝"
            $0.textColor = color(0, 0, 0, 0.4)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textAlignment = .right
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-66)
                make.height.equalTo(20)
                make.left.equalTo(payBtn.snp.right).offset(40)
                make.centerY.equalTo(payBtn)
            }
        }
        
        payImageView.do {
            $0.image = UIImage(named: "lab_goods_pay_alipay")
            $0.contentMode = .scaleAspectFit
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-37)
                make.width.height.equalTo(24)
                make.centerY.equalTo(payBtn)
            }
        }
        
        let _ = UIImageView().then {
            $0.image = UIImage(named: "ge_main_arrow")
            $0.contentMode = .scaleAspectFit
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.height.equalTo(16)
                make.centerY.equalTo(payBtn)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.2)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(0.5)
                make.top.equalTo(payBtn.snp.bottom).offset(20)
            }
        }
        
        let goodsImageView = UIImageView().then {
            $0.setWebImage(url: (goodsItem?.cover?.guid).nonnull)
            $0.layer.cornerRadius = 8.0
            $0.layer.borderColor = color(0, 0, 0, 0.4).cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.top.equalTo(payBtn.snp.bottom).offset(40)
                make.width.height.equalTo(100)
            }
        }
        
        let nameLabel = UILabel().then {
            $0.text = goodsItem?.name
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
        
        let _ = UILabel().then {
            $0.text = selectSize?.type
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
        
        let _ = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.2)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(0.5)
                make.top.equalTo(goodsImageView.snp.bottom).offset(20)
            }
        }
        
        let countLabel = UILabel().then {
            $0.text = "购买数量"
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 16)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.width.equalTo(80)
                make.height.equalTo(23)
                make.top.equalTo(goodsImageView.snp.bottom).offset(40)
            }
        }
        
        let addBtn = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -16, left: -16, bottom: -16, right: -16)
            $0.setImage(UIImage(named: "lab_nft_proxy_num_add"), for: .normal)
            $0.addAction(UIAction() {[unowned self] _ in
                var count = Int(numberLabel.text.nonnull).nonnull
                count += 1
                numberLabel.text = "\(count)"
                submitBtn.setTitle(String(format: "￥ %.02f 立即支付", (selectSize?.price).nonnull*Double(count)), for: .normal)
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(20)
                make.right.equalTo(-16)
                make.centerY.equalTo(countLabel)
            }
        }
        
        numberLabel.do {
            $0.text = "1"
            $0.font = .mediumPingFangSCFont(ofSize: 16)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(addBtn.snp.left)
                make.width.equalTo(40)
                make.centerY.height.equalTo(addBtn)
            }
        }
        
        let _ = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -16, left: -16, bottom: -16, right: -16)
            $0.setImage(UIImage(named: "lab_nft_proxy_num_delete"), for: .normal)
            $0.addAction(UIAction() {[unowned self] _ in
                var count = Int(numberLabel.text.nonnull).nonnull
                count = max(1, count - 1)
                numberLabel.text = "\(count)"
                submitBtn.setTitle(String(format: "￥ %.02f 立即支付", (selectSize?.price).nonnull*Double(count)), for: .normal)
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(20)
                make.right.equalTo(numberLabel.snp.left)
                make.centerY.equalTo(addBtn)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.2)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(0.5)
                make.top.equalTo(countLabel.snp.bottom).offset(20)
            }
        }
        
        let allPriceLabel = UILabel().then {
            $0.text = "商品金额"
            $0.textColor = .black
            $0.font = .regularPingFangSCFont(ofSize: 14)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.width.equalTo(80)
                make.height.equalTo(20)
                make.top.equalTo(countLabel.snp.bottom).offset(40)
            }
        }
        
        let _ = UILabel().then {
            $0.text = String(format: "￥ %.02f", (selectSize?.price).nonnull)
            $0.font = .gothamMediumFont(ofSize: 14)
            $0.textColor = .black
            $0.textAlignment = .right
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.lessThanOrEqualTo(150)
                make.centerY.height.equalTo(allPriceLabel)
            }
        }
        
        let sendLabel = UILabel().then {
            $0.text = "运费"
            $0.textColor = .black
            $0.font = .regularPingFangSCFont(ofSize: 14)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.width.equalTo(80)
                make.height.equalTo(20)
                make.top.equalTo(allPriceLabel.snp.bottom).offset(10)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "￥ 0.00"
            $0.font = .gothamMediumFont(ofSize: 14)
            $0.textColor = .black
            $0.textAlignment = .right
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.lessThanOrEqualTo(150)
                make.centerY.height.equalTo(sendLabel)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "购买前请确认：\n本平台包含品牌直营商品和海外发售商品。您在平台购买的海外商品等同于在境外的原销售地购买，适用原销售地的法律法规，所以可能会在以下方面不同于自营商品:\n(1) 可能无中文标签，您可以通过平台或者客服了解详细信息。\n(2) 海外商品的质量、安全、标识等信息可能不同于我国标准，您需要自行承担风险。\n(3) 您确认下单，表示您同意我们处理您的订单信息，以使您能够在我们平台上正常购物。\n(4) 海外商品由境外卖方直接销售，我方无增值税发票开具义务，您可以联系客服索取由境外卖方提供的形式发票。"
            $0.font = .regularPingFangSCFont(ofSize: 12)
            $0.textColor = color(0, 0, 0, 0.4)
            $0.textAlignment = .left
            $0.numberOfLines = 0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.left.equalTo(16)
                make.top.equalTo(sendLabel.snp.bottom).offset(20)
                make.height.lessThanOrEqualTo(CGFloat.greatestFiniteMagnitude)
                make.bottom.equalTo(-30)
            }
        }
    }
}
