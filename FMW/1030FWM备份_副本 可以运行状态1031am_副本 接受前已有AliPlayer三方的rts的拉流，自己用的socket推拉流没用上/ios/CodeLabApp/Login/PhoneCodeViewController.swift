//
//  PhoneCodeViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/8/23.
//

import Foundation
import BasicUIKit
import Combine
import CodeLabUnityBridge
import APIKit

final class PhoneCodeViewController: BaseViewController {
    
    var phone: String?
    var countryCode: String?
    
    private let phoneTextField = UITextField()
    private let phoneCodeLabel1 = UILabel()
    private let phoneCodeLabel2 = UITextField()
    private let phoneCodeLabel3 = UITextField()
    private let phoneCodeLabel4 = UITextField()
    private let loginBtn = UIButton()
    public var cancellableList: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendCodeRequest()
        
        let headerImageView = UIImageView().then {
            $0.image = UIImage(named: "lab_login_phone_code_background")
            $0.contentMode = .scaleAspectFit
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(UIManager.shared.screenWidth*150.0/375.0)
            }
        }
        
        let phoneTitleLabel = UILabel().then {
            $0.text = "输入手机号验证码"
            $0.textColor = .black
            $0.font = .semiboldPingFangSCFont(ofSize: 24)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(24)
                make.right.equalTo(-24)
                make.height.equalTo(33)
                
                if UIManager.shared.screenHeight < 800 {
                    make.top.equalTo(UIManager.shared.navBarHeight)
                } else {
                    make.top.equalTo(headerImageView.snp.bottom).offset(16)
                }
            }
        }
        
        let phoneDescLabel = UILabel().then {
            $0.text = "已发送验证码至\(phone.nonnull)"
            $0.textColor = color(0, 0, 0, 0.3)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(phoneTitleLabel)
                make.height.equalTo(20)
                make.top.equalTo(phoneTitleLabel.snp.bottom).offset(6)
            }
        }
        
        phoneTextField.do {
            $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            $0.keyboardType = .phonePad
            $0.returnKeyType = .done
            $0.clearButtonMode = .never
            $0.delegate = self
            $0.textPublisher().receive(on: RunLoop.main).sink {[unowned self] result in
                phoneCodeLabel1.text = result.count > 0 ? String(result[result.startIndex]) : nil
                phoneCodeLabel2.text = result.count > 1 ? String(result[result.index(result.startIndex, offsetBy: 1)]) : nil
                phoneCodeLabel3.text = result.count > 2 ? String(result[result.index(result.startIndex, offsetBy: 2)]) : nil
                phoneCodeLabel4.text = result.count > 3 ? String(result[result.index(result.startIndex, offsetBy: 3)]) : nil
                
                loginBtn.backgroundColor = result.count >= 4 ? .black : color(0, 0, 0, 0.5)
                
                phoneCodeLabel1.layer.borderColor = phoneCodeLabel1.text.nonnull.isEmpty ? color(230, 230, 230).cgColor : color(51, 186, 255).cgColor
                phoneCodeLabel2.layer.borderColor = phoneCodeLabel2.text.nonnull.isEmpty ? color(230, 230, 230).cgColor : color(51, 186, 255).cgColor
                phoneCodeLabel3.layer.borderColor = phoneCodeLabel3.text.nonnull.isEmpty ? color(230, 230, 230).cgColor : color(51, 186, 255).cgColor
                phoneCodeLabel4.layer.borderColor = phoneCodeLabel4.text.nonnull.isEmpty ? color(230, 230, 230).cgColor : color(51, 186, 255).cgColor
            }.store(in: &cancellableList)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(-20)
                make.height.equalTo(10)
            }
        }
        
        phoneCodeLabel1.do {
            $0.backgroundColor = color(244, 244, 244)
            $0.textColor = color(51, 186, 255)
            $0.font = .gothamBoldFont(ofSize: 39)
            $0.textAlignment = .center
            $0.layer.borderColor = color(230, 230, 230).cgColor
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 12.0
            $0.layer.masksToBounds = true
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phoneTapHandler)))
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(64)
                make.height.equalTo(84)
                make.top.equalTo(phoneDescLabel.snp.bottom).offset(41)
                make.left.equalTo(24)
            }
        }
        
        phoneCodeLabel2.do {
            $0.backgroundColor = color(244, 244, 244)
            $0.textColor = color(51, 186, 255)
            $0.font = .gothamBoldFont(ofSize: 39)
            $0.textAlignment = .center
            $0.layer.borderColor = color(230, 230, 230).cgColor
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 12.0
            $0.layer.masksToBounds = true
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phoneTapHandler)))
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(64)
                make.height.equalTo(84)
                make.top.equalTo(phoneCodeLabel1)
                make.left.equalTo(phoneCodeLabel1.snp.right).offset(16)
            }
        }
        
        phoneCodeLabel3.do {
            $0.backgroundColor = color(244, 244, 244)
            $0.textColor = color(51, 186, 255)
            $0.font = .gothamBoldFont(ofSize: 39)
            $0.textAlignment = .center
            $0.layer.borderColor = color(230, 230, 230).cgColor
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 12.0
            $0.layer.masksToBounds = true
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phoneTapHandler)))
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(64)
                make.height.equalTo(84)
                make.top.equalTo(phoneCodeLabel2)
                make.left.equalTo(phoneCodeLabel2.snp.right).offset(16)
            }
        }
        
        phoneCodeLabel4.do {
            $0.backgroundColor = color(244, 244, 244)
            $0.textColor = color(51, 186, 255)
            $0.font = .gothamBoldFont(ofSize: 39)
            $0.textAlignment = .center
            $0.layer.borderColor = color(230, 230, 230).cgColor
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 12.0
            $0.layer.masksToBounds = true
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phoneTapHandler)))
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(64)
                make.height.equalTo(84)
                make.top.equalTo(phoneCodeLabel2)
                make.left.equalTo(phoneCodeLabel3.snp.right).offset(16)
            }
        }
        
        let _ = UIButton().then {
            let attributedText = NSMutableAttributedString(string: "未收到验证码？重新获取", attributes: [
                .font: UIFont.regularPingFangSCFont(ofSize: 14),
                .foregroundColor: color(0, 0, 0, 0.3),
            ])
            attributedText.setAttributes([
                .font: UIFont.mediumPingFangSCFont(ofSize: 14),
                .foregroundColor: color(51, 186, 255),
            ], range: NSRange(location: 7, length: 4))
            $0.setAttributedTitle(attributedText, for: .normal)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: 0, bottom: -15, right: 0)
            $0.addAction(UIAction() {_ in
                Alert.show(title: "是否重新获取验证码?", cancelBtnTitle: "取消", submitBtnTitle: "确定") {[unowned self] in
                    sendCodeRequest()
                }
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(24)
                make.top.equalTo(phoneCodeLabel1.snp.bottom).offset(20)
                make.height.equalTo(20)
                make.width.lessThanOrEqualTo(200)
            }
        }
        
        loginBtn.do {
            $0.backgroundColor = color(0, 0, 0, 0.5)
            $0.layer.cornerRadius = 12.0
            $0.setTitle("立即登录", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 16)
            $0.addAction(UIAction() {[unowned self] _ in
                if phoneTextField.text.nonnull.count < 4 {
                    Toast.toast(title: "请输入完整验证码")
                    return
                }
                
                HUD.show()
                Network.request(LoginAPI.phoneLogin, parameters: ["areaCode": countryCode.nonnull, "mobile": phone.nonnull, "verifyCode": phoneTextField.text.nonnull]).responseData { response in
                    HUD.hide()
                    if let error = response.error {
                        Toast.toast(title: error.localizedDescription)
                    } else if let data = response.data?.jsonData(), let result = try? JSONDecoder().decode(LoginInfo.self, from: data) {
                        
                        AppContext.current.login(user: result, save: true)

                        if result.user?.userInfo?.needInitRole == true {
                            UIManager.push(to: RegisterNameViewController())
                        } else {
                            NotificationCenter.default.post(name: .notificationUserDidLogin, object: nil)
                        }
                    }
                }
                
//                let unityVC = RegisterNameViewController()
//                let options = CodeLabUnityWindowPresentationOptions()
//                options.transitionStyle = .push
//                CodeLabUnityInstance.shared.presentUnityWindow(with: options, overlayViewController: unityVC) {
//
//                } completion: { handle, error in
//                    unityVC.loginBtnDidTap = {
//                        handle?.dismiss(animated: true, completion: { _ in })
//                    }
//                }
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(24)
                make.right.equalTo(-24)
                make.height.equalTo(48)
                make.bottom.equalTo(-49)
            }
        }
        
        NotificationCenter.default.publisher(for: UIApplication.keyboardWillChangeFrameNotification).sink {[weak self] notification in
            guard let strongSelf = self else { return }
            if strongSelf.phoneTextField.isFirstResponder,
               let keyboardFrame = notification.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? CGRect,
               let duration = notification.userInfo?[UIApplication.keyboardAnimationDurationUserInfoKey] as? Double {
                if keyboardFrame.origin.y >= UIManager.shared.screenHeight { //隐藏键盘
                    strongSelf.loginBtn.snp.updateConstraints { make in
                        make.bottom.equalTo(-49)
                    }
                    UIView.animate(withDuration: duration) {
                        strongSelf.loginBtn.superview?.layoutIfNeeded()
                    }
                }
                else {
                    strongSelf.loginBtn.snp.updateConstraints { make in
                        make.bottom.equalTo(keyboardFrame.origin.y - 10 - UIManager.shared.screenHeight)
                    }
                    UIView.animate(withDuration: duration) {
                        strongSelf.loginBtn.superview?.layoutIfNeeded()
                    }
                }
            }
        }.store(in: &cancellableList)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneTextField.becomeFirstResponder()
    }
    
    @objc private func phoneTapHandler() {
        phoneTextField.becomeFirstResponder()
    }
    
    private func sendCodeRequest() {
        Network.request(LoginAPI.phoneCodeSend, parameters: ["areaCode": countryCode.nonnull, "mobile": phone.nonnull]).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else {
                Toast.toast(title: "发送成功")
            }
        }
    }
}

extension PhoneCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isNotEmpty, textField.text.nonnull.count >= 4 { return false }
        return true
    }
}
