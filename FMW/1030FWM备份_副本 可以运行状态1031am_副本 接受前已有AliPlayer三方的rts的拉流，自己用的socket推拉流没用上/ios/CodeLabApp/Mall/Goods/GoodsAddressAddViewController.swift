//
//  GoodsAddressAddViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/10/16.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import APIKit

final class GoodsAddressAddViewController: BaseViewController {
    
    var addressItem: AddressItem?
    
    private let nameTextField = UITextField()
    private let phoneTextField = UITextField()
    private let cityLabel = UILabel()
    private let addressTextField = UITextField()
    private let defaultSwitch = SwitchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "添加配送地址"
        
        let submitBtn = UIButton().then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 12
            $0.setTitle("完成", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 16)
            $0.addAction(UIAction() {[unowned self] _ in
                if nameTextField.text.nonnull.isEmpty {
                    Toast.toast(title: "请填写姓名")
                    return
                }
                
                if phoneTextField.text.nonnull.isEmpty {
                    Toast.toast(title: "请填写电话号码")
                    return
                }
                
                if cityLabel.text.nonnull.hasPrefix("省份/") {
                    Toast.toast(title: "请选择省市区县")
                    return
                }
                
                if addressTextField.text.nonnull.isEmpty {
                    Toast.toast(title: "请填写街道和地址信息")
                    return
                }
                
                if let address = addressItem {
                    let para: [String: Any] = ["name": nameTextField.text.nonnull,
                                               "addressId": address.id,
                                               "phone": phoneTextField.text.nonnull,
                                               "administrative": cityLabel.text.nonnull,
                                               "detailAddress": addressTextField.text.nonnull,
                                               "setDefault": defaultSwitch.isOn ? 1 : 0]
                    HUD.show()
                    Network.request(GoodsAPI.addressEdit, parameters: para).responseData { response in
                        HUD.hide()
                        if let error = response.error {
                            Toast.toast(title: error.localizedDescription)
                        } else {
                            address.name = self.nameTextField.text.nonnull
                            address.mobile = self.phoneTextField.text.nonnull
                            address.city = self.cityLabel.text.nonnull
                            address.address = self.addressTextField.text.nonnull
                            address.isDefault = self.defaultSwitch.isOn ? 1 : 0
                            Toast.toast(title: "修改成功")
                            NotificationCenter.default.post(name: .notificationAddressDidUpdate, object: address)
                            self.backBtnTapHandler()
                        }
                    }
                } else {
                    let para: [String: Any] = ["name": nameTextField.text.nonnull,
                                               "phone": phoneTextField.text.nonnull,
                                               "administrative": cityLabel.text.nonnull,
                                               "detailAddress": addressTextField.text.nonnull,
                                               "setDefault": defaultSwitch.isOn ? 1 : 0]
                    HUD.show()
                    Network.request(GoodsAPI.addressAdd, parameters: para).responseData { response in
                        HUD.hide()
                        if let error = response.error {
                            Toast.toast(title: error.localizedDescription)
                        } else {
                            Toast.toast(title: "添加成功")
                            NotificationCenter.default.post(name: .notificationAddressDidUpdate, object: nil)
                            self.backBtnTapHandler()
                        }
                    }
                }
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.bottom.equalTo(UIManager.shared.isNotchScreen ? -42 : -8)
                make.height.equalTo(44)
            }
        }
        
        let scrollView = UIScrollView().then {
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.alwaysBounceVertical = true
            $0.keyboardDismissMode = .onDrag
            view.insertSubview($0, belowSubview: submitBtn)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(customBar.snp.bottom)
                make.bottom.equalTo(submitBtn.snp.top)
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
        
        let titleLabel = UILabel().then {
            $0.text = "收货地址"
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 16)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.height.equalTo(23)
                make.top.equalTo(customBar.snp.bottom).offset(20)
                make.right.equalTo(-16)
            }
        }
        
        nameTextField.do {
            $0.text = addressItem?.name
            $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            $0.keyboardType = .default
            $0.returnKeyType = .done
            $0.clearButtonMode = .never
            $0.attributedPlaceholder = NSAttributedString(string: "姓名", attributes: [.font: UIFont.regularPingFangSCFont(ofSize: 14), .foregroundColor: color(0, 0, 0, 0.4)])
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(titleLabel.snp.bottom).offset(22)
                make.height.equalTo(50)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.2)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalTo(nameTextField)
                make.height.equalTo(0.5)
            }
        }
        
        phoneTextField.do {
            $0.text = addressItem?.mobile
            $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            $0.keyboardType = .default
            $0.returnKeyType = .done
            $0.clearButtonMode = .never
            $0.attributedPlaceholder = NSAttributedString(string: "电话号码", attributes: [.font: UIFont.regularPingFangSCFont(ofSize: 14), .foregroundColor: color(0, 0, 0, 0.4)])
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(nameTextField.snp.bottom)
                make.height.equalTo(50)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.2)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalTo(phoneTextField)
                make.height.equalTo(0.5)
            }
        }
        
        cityLabel.do {
            $0.text = addressItem?.city ?? "省份/城市/乡镇区县"
            $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
            $0.textColor = addressItem == nil ? color(0, 0, 0, 0.4) : UIColor.black
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCitySelect)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(phoneTextField.snp.bottom)
                make.height.equalTo(50)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.2)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalTo(cityLabel)
                make.height.equalTo(0.5)
            }
        }
        
        addressTextField.do {
            $0.text = addressItem?.address
            $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            $0.keyboardType = .default
            $0.returnKeyType = .done
            $0.clearButtonMode = .never
            $0.attributedPlaceholder = NSAttributedString(string: "街道和地址信息", attributes: [.font: UIFont.regularPingFangSCFont(ofSize: 14), .foregroundColor: color(0, 0, 0, 0.4)])
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(cityLabel.snp.bottom)
                make.height.equalTo(50)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.2)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalTo(addressTextField)
                make.height.equalTo(0.5)
            }
        }
        
        let defaultLabel = UILabel().then {
            $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
            $0.textColor = color(0, 0, 0)
            $0.text = "设为默认收货地址"
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(addressTextField.snp.bottom).offset(30)
                make.height.equalTo(20)
                
                if addressItem == nil {
                    make.bottom.equalTo(-20)
                }
            }
        }
        
        defaultSwitch.do {
            $0.onTintColor = color(51, 186, 255)
            $0.offTintColor = color(0, 0, 0, 0.1)
            $0.onStatusTintColor = .white
            $0.offStatusTintColor = .white
            $0.statusHeight = 22
            $0.setOn((addressItem?.isDefault).nonnull > 0)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(44)
                make.height.equalTo(26)
                make.right.equalTo(-16)
                make.centerY.equalTo(defaultLabel)
            }
        }
        
        if let addressItem = addressItem {
            let _ = UIView().then {
                $0.backgroundColor = color(0, 0, 0, 0.2)
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalTo(addressTextField)
                    make.height.equalTo(0.5)
                    make.top.equalTo(defaultLabel.snp.bottom).offset(20)
                }
            }
            
            let deleteBtn = UIButton().then {
                $0.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
                $0.setTitle("删除收货地址", for: .normal)
                $0.setTitleColor(color(167, 55, 55), for: .normal)
                $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
                $0.addAction(UIAction() { _ in
                    Alert.show(title: "确认要删除此收货地址？", submitBtnTapHandler: {
                        HUD.show()
                        Network.request(GoodsAPI.addressDelete, parameters: ["addressId": addressItem.id]).responseData { response in
                            HUD.hide()
                            if let error = response.error {
                                Toast.toast(title: error.localizedDescription)
                            } else {
                                Toast.toast(title: "删除成功")
                                NotificationCenter.default.post(name: .notificationAddressDidDelete, object: addressItem)
                                self.backBtnTapHandler()
                            }
                        }
                    })
                }, for: .touchUpInside)
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(16)
                    make.width.lessThanOrEqualTo(200)
                    make.top.equalTo(defaultLabel.snp.bottom).offset(40)
                    make.height.equalTo(20)
                }
            }
            
            let _ = UIView().then {
                $0.backgroundColor = color(0, 0, 0, 0.2)
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalTo(addressTextField)
                    make.height.equalTo(0.5)
                    make.top.equalTo(deleteBtn.snp.bottom).offset(20)
                    make.bottom.equalTo(-20)
                }
            }
        }
    }
    
    @objc private func showCitySelect() {
        let cityVC = GoodsCitySelectViewController()
        cityVC.modalPresentationStyle = .overFullScreen
        cityVC.didSelectHandler = { city in
            self.cityLabel.text = city
            self.cityLabel.textColor = .black
        }
        UIManager.present(modal: cityVC)
    }
}
