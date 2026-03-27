//
//  GoodsFilterViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/16.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit

final class GoodsFilterViewController: UIViewController {
    
    var didFilterHandler: ((Double?, Double?, String) -> Void)?
    
    private let contentView = UIView()
    private let priceLowTextField = UITextField()
    private let priceHighTextField = UITextField()
    
    private let sizeSBtn = UIButton()
    private let sizeMBtn = UIButton()
    private let sizeLBtn = UIButton()
    private let sizeXLBtn = UIButton()
    private let sizeXXLBtn = UIButton()
    
    private var currentSize = "M"
    
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
                make.height.equalTo(UIManager.shared.screenHeight - 216)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "筛选"
            $0.textColor = .black
            $0.font = .regularPingFangSCFont(ofSize: 18)
            $0.textAlignment = .center
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(10)
                make.height.equalTo(25)
            }
        }
        
        let priceLabel = UILabel().then {
            $0.text = "价格范围"
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 18)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(56)
                make.height.equalTo(25)
            }
        }
        
        let lineView = UIView().then {
            $0.backgroundColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(40)
                make.height.equalTo(2)
                make.top.equalTo(priceLabel.snp.bottom).offset(34.5)
            }
        }
        
        priceLowTextField.do {
            $0.font = UIFont.regularPingFangSCFont(ofSize: 18)
            $0.textColor = .black
            $0.keyboardType = .phonePad
            $0.returnKeyType = .done
            $0.clearButtonMode = .never
            $0.textAlignment = .center
            $0.attributedPlaceholder = NSAttributedString(string: "￥最低价格", attributes: [.font: UIFont.regularPingFangSCFont(ofSize: 18), .foregroundColor: color(0, 0, 0, 0.4)])
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(90)
                make.height.equalTo(25)
                make.right.equalTo(lineView.snp.left).offset(-30)
                make.centerY.equalTo(lineView)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.4)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.centerX.bottom.equalTo(priceLowTextField)
                make.height.equalTo(1)
            }
        }
        
        priceHighTextField.do {
            $0.font = UIFont.regularPingFangSCFont(ofSize: 18)
            $0.textColor = .black
            $0.keyboardType = .phonePad
            $0.returnKeyType = .done
            $0.clearButtonMode = .never
            $0.textAlignment = .center
            $0.attributedPlaceholder = NSAttributedString(string: "￥最高价格", attributes: [.font: UIFont.regularPingFangSCFont(ofSize: 18), .foregroundColor: color(0, 0, 0, 0.4)])
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(90)
                make.height.equalTo(25)
                make.left.equalTo(lineView.snp.right).offset(30)
                make.centerY.equalTo(lineView)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.4)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.centerX.bottom.equalTo(priceHighTextField)
                make.height.equalTo(1)
            }
        }
        
        let sizeLabel = UILabel().then {
            $0.text = "尺码选择"
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 18)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(priceLabel.snp.bottom).offset(89)
                make.height.equalTo(25)
            }
        }
        
        sizeSBtn.do {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 10.0
            $0.setTitle("S", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 18)
            $0.addAction(UIAction() {[unowned self] _ in
                currentSize = "S"
                sizeSBtn.backgroundColor = .black
                sizeSBtn.setTitleColor(.white, for: .normal)
                sizeMBtn.backgroundColor = color(245, 245, 245)
                sizeMBtn.setTitleColor(.black, for: .normal)
                sizeLBtn.backgroundColor = color(245, 245, 245)
                sizeLBtn.setTitleColor(.black, for: .normal)
                sizeXLBtn.backgroundColor = color(245, 245, 245)
                sizeXLBtn.setTitleColor(.black, for: .normal)
                sizeXXLBtn.backgroundColor = color(245, 245, 245)
                sizeXXLBtn.setTitleColor(.black, for: .normal)
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(sizeLabel)
                make.width.equalTo(80)
                make.height.equalTo(50)
                make.top.equalTo(sizeLabel.snp.bottom).offset(12)
            }
        }
        
        sizeMBtn.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 10.0
            $0.setTitle("M", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 18)
            $0.addAction(UIAction() {[unowned self] _ in
                currentSize = "M"
                sizeMBtn.backgroundColor = .black
                sizeMBtn.setTitleColor(.white, for: .normal)
                sizeSBtn.backgroundColor = color(245, 245, 245)
                sizeSBtn.setTitleColor(.black, for: .normal)
                sizeLBtn.backgroundColor = color(245, 245, 245)
                sizeLBtn.setTitleColor(.black, for: .normal)
                sizeXLBtn.backgroundColor = color(245, 245, 245)
                sizeXLBtn.setTitleColor(.black, for: .normal)
                sizeXXLBtn.backgroundColor = color(245, 245, 245)
                sizeXXLBtn.setTitleColor(.black, for: .normal)
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(80)
                make.height.equalTo(50)
                make.top.equalTo(sizeSBtn)
            }
        }
        
        sizeLBtn.do {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 10.0
            $0.setTitle("L", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 18)
            $0.addAction(UIAction() {[unowned self] _ in
                currentSize = "L"
                sizeLBtn.backgroundColor = .black
                sizeLBtn.setTitleColor(.white, for: .normal)
                sizeSBtn.backgroundColor = color(245, 245, 245)
                sizeSBtn.setTitleColor(.black, for: .normal)
                sizeMBtn.backgroundColor = color(245, 245, 245)
                sizeMBtn.setTitleColor(.black, for: .normal)
                sizeXLBtn.backgroundColor = color(245, 245, 245)
                sizeXLBtn.setTitleColor(.black, for: .normal)
                sizeXXLBtn.backgroundColor = color(245, 245, 245)
                sizeXXLBtn.setTitleColor(.black, for: .normal)
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-20)
                make.width.equalTo(80)
                make.height.equalTo(50)
                make.top.equalTo(sizeSBtn)
            }
        }
        
        sizeXLBtn.do {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 10.0
            $0.setTitle("XL", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 18)
            $0.addAction(UIAction() {[unowned self] _ in
                currentSize = "XL"
                sizeXLBtn.backgroundColor = .black
                sizeXLBtn.setTitleColor(.white, for: .normal)
                sizeSBtn.backgroundColor = color(245, 245, 245)
                sizeSBtn.setTitleColor(.black, for: .normal)
                sizeMBtn.backgroundColor = color(245, 245, 245)
                sizeMBtn.setTitleColor(.black, for: .normal)
                sizeLBtn.backgroundColor = color(245, 245, 245)
                sizeLBtn.setTitleColor(.black, for: .normal)
                sizeXXLBtn.backgroundColor = color(245, 245, 245)
                sizeXXLBtn.setTitleColor(.black, for: .normal)
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.width.equalTo(80)
                make.height.equalTo(50)
                make.top.equalTo(sizeSBtn.snp.bottom).offset(12)
            }
        }
        
        sizeXXLBtn.do {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 10.0
            $0.setTitle("XXL", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 18)
            $0.addAction(UIAction() {[unowned self] _ in
                currentSize = "XXL"
                sizeXXLBtn.backgroundColor = .black
                sizeXXLBtn.setTitleColor(.white, for: .normal)
                sizeSBtn.backgroundColor = color(245, 245, 245)
                sizeSBtn.setTitleColor(.black, for: .normal)
                sizeMBtn.backgroundColor = color(245, 245, 245)
                sizeMBtn.setTitleColor(.black, for: .normal)
                sizeLBtn.backgroundColor = color(245, 245, 245)
                sizeLBtn.setTitleColor(.black, for: .normal)
                sizeXLBtn.backgroundColor = color(245, 245, 245)
                sizeXLBtn.setTitleColor(.black, for: .normal)
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(80)
                make.height.equalTo(50)
                make.top.equalTo(sizeXLBtn)
            }
        }
        
        let _ = UIButton().then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 10.0
            $0.setTitle("确认筛选", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 18)
            $0.addAction(UIAction() {[unowned self] _ in
                didFilterHandler?(Double(priceLowTextField.text.nonnull), Double(priceHighTextField.text.nonnull), currentSize)
                dismiss(animated: true)
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(192)
                make.height.equalTo(45)
                make.bottom.equalTo(-40)
            }
        }
    }
}
