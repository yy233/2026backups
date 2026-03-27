//
//  NFTDetailBuyProxyViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/15.
//

import Foundation
import BasicKit
import BasicUIKit
import APIKit
import Combine

final class NFTDetailBuyProxyViewController: BaseViewController {

    var nftInfo: NFTInfo?

    private let priceTextField = UITextField()
    private let numberLabel = UILabel()
    private let totalPriceLabel = UILabel()
    private var cancellableList: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "委托购买"
        
        let nftImageView = UIImageView().then {
            $0.setWebImage(url: OSSUploader.imageNFTURLFor((nftInfo?.cover?.guid).nonnull, crop: .medium), cornerRadius: 8*3.0, finalSize: CGSize(width: 100*3.0, height: 100*3.0))
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.width.height.equalTo(100)
                make.top.equalTo(customBar.snp.bottom).offset(24)
            }
        }
        
        let nftNameLabel = UILabel().then {
            $0.text = nftInfo?.name
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 18)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(nftImageView.snp.right).offset(16)
                make.right.equalTo(-16)
                make.height.equalTo(25)
                make.top.equalTo(nftImageView.snp.top).offset(13)
            }
        }
        
        let lowPriceLabel = UILabel().then {
            $0.text = "最低出售价"
            $0.textColor = color(0, 0, 0, 0.4)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(nftNameLabel)
                make.width.equalTo(70)
                make.height.equalTo(20)
                make.top.equalTo(nftNameLabel.snp.bottom).offset(12)
            }
        }
        
        let lowSaleLabel = UILabel().then {
            $0.text = "最低成交价"
            $0.textColor = color(0, 0, 0, 0.4)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(nftNameLabel)
                make.width.equalTo(70)
                make.height.equalTo(20)
                make.top.equalTo(lowPriceLabel.snp.bottom).offset(6)
            }
        }
        
        let _ = UILabel().then {
            $0.text = (nftInfo?.minSalePrice).nonnull > 0 ? "\((nftInfo?.minSalePrice).nonnull)积分" : "暂无出售"
            $0.font = .gothamMediumFont(ofSize: 14)
            $0.textColor = color(255, 38, 111)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(lowPriceLabel.snp.right).offset(6)
                make.right.equalTo(-16)
                make.centerY.equalTo(lowPriceLabel)
                make.height.equalTo(20)
            }
        }
        
        let _ = UILabel().then {
            $0.text = (nftInfo?.minDealPrice).nonnull > 0 ? "\((nftInfo?.minDealPrice).nonnull)积分" : "暂无成交"
            $0.font = .gothamMediumFont(ofSize: 14)
            $0.textColor = color(255, 38, 111)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(lowSaleLabel.snp.right).offset(6)
                make.right.equalTo(-16)
                make.centerY.equalTo(lowSaleLabel)
                make.height.equalTo(20)
            }
        }
        
        let proxyLabel = UILabel().then {
            $0.text = "委托价格"
            $0.font = .mediumPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-16)
                make.top.equalTo(nftImageView.snp.bottom).offset(49)
                make.height.equalTo(20)
            }
        }
        
        let priceBackView = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 8.0
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.height.equalTo(44)
                make.top.equalTo(proxyLabel.snp.bottom).offset(16)
            }
        }
        
        priceTextField.do {
            $0.font = UIFont.mediumPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            $0.keyboardType = .numberPad
            $0.returnKeyType = .done
            $0.clearButtonMode = .never
            $0.attributedPlaceholder = NSAttributedString(string: "请输入价格", attributes: [.font: UIFont.regularPingFangSCFont(ofSize: 14), .foregroundColor: color(152, 152, 152)])
            $0.textPublisher().receive(on: RunLoop.main).sink {[unowned self] result in
                totalPriceLabel.text = result.isEmpty ? "--" : "\(Int(numberLabel.text.nonnull).nonnull*Int(result).nonnull)"
            }.store(in: &cancellableList)
            priceBackView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.bottom.equalToSuperview()
            }
        }
        
        let numberTitleLabel = UILabel().then {
            $0.text = "购买数量"
            $0.font = .mediumPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.width.lessThanOrEqualTo(100)
                make.top.equalTo(priceBackView.snp.bottom).offset(39)
                make.height.equalTo(20)
            }
        }
        
        let addBtn = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -16, left: -16, bottom: -16, right: -16)
            $0.setImage(UIImage(named: "lab_nft_proxy_num_add"), for: .normal)
            $0.addAction(UIAction() {[unowned self] _ in
                var count = Int(numberLabel.text.nonnull).nonnull
                count += 1
                numberLabel.text = "\(count)"
                totalPriceLabel.text = priceTextField.text.nonnull.isEmpty ? "--" : "\(Int(numberLabel.text.nonnull).nonnull*Int(priceTextField.text.nonnull).nonnull)"
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(20)
                make.right.equalTo(-20)
                make.centerY.equalTo(numberTitleLabel)
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
                make.width.equalTo(32)
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
                totalPriceLabel.text = priceTextField.text.nonnull.isEmpty ? "--" : "\(Int(numberLabel.text.nonnull).nonnull*Int(priceTextField.text.nonnull).nonnull)"
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(20)
                make.right.equalTo(numberLabel.snp.left)
                make.centerY.equalTo(addBtn)
            }
        }
        
        let totalLabel = UILabel().then {
            $0.text = "总计"
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textColor = color(0, 0, 0, 0.4)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.width.lessThanOrEqualTo(100)
                make.bottom.equalTo(UIManager.shared.isNotchScreen ? -53 : -33)
                make.height.equalTo(20)
            }
        }
        
        totalPriceLabel.do {
            $0.text = "--"
            $0.font = .gothamMediumFont(ofSize: 24)
            $0.textColor = color(255, 38, 111)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(totalLabel.snp.right).offset(8)
                make.height.lessThanOrEqualTo(50)
                make.width.lessThanOrEqualTo(150).priority(.required)
                make.centerY.equalTo(totalLabel)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "积分"
            $0.font = .mediumPingFangSCFont(ofSize: 14)
            $0.textColor = color(255, 38, 111)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(totalPriceLabel.snp.right).offset(4)
                make.height.equalTo(20)
                make.width.equalTo(28)
                make.centerY.equalTo(totalPriceLabel)
            }
        }
        
        let _ = UIButton().then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 8.0
            $0.setTitle("立即委托", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 16)
            $0.addAction(UIAction() { _ in
                if self.priceTextField.text.nonnull.isEmpty {
                    Toast.toast(title: "请输入委托价格")
                    return
                }
                
                Alert.show(title: "确认委托购买吗？", message: "本次购买将花费\((self.totalPriceLabel.text).nonnull)积分", submitBtnTapHandler: {
                    HUD.show()
                    Network.request(NFTAPI.proxySubmit, parameters: ["goodsId": (self.nftInfo?.id).nonnull, "num": Int(self.numberLabel.text.nonnull).nonnull, "points": Int(self.priceTextField.text.nonnull).nonnull]).responseData { response in
                        if let error = response.error {
                            Toast.toast(title: error.localizedDescription)
                        } else {
                            Toast.toast(title: "委托已提交")
                            UIManager.push(to: NFTOwnProxyContainerViewController(), latestRemoved: true)
                        }
                    }
                })
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(170)
                make.right.equalTo(-16)
                make.centerY.equalTo(totalPriceLabel)
                make.height.equalTo(44)
            }
        }
    }
}
