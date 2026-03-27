//
//  LoginViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/8/23.
//

import Foundation
import BasicUIKit
import SnapKit
import Combine

fileprivate struct LoginNote {
    
    static let eulaURL: URL = URL(string: "http://api.fmwworld.com:88/eula.html")!
    static let privacyPolicyURL: URL = URL(string: "http://api.fmwworld.com:88/privacy.html")!

    var version: Int = 1
    var text: RichText = try! RichText(content: """
    <body>
    我已阅读并同意<a href="\(LoginNote.privacyPolicyURL.absoluteString)">《隐私政策》</a>与<a href="\(LoginNote.eulaURL.absoluteString)">《用户协议》</a>
    </body>
    """)
}

final class LoginViewController: BaseViewController {
    
    private let countryCodeLabel = UIButton()
    private let phoneTextField = UITextField()
    private let checkboxBtn = UIButton()
    private let loginBtn = UIButton()
    private var eulaNote = LoginNote()
    public var cancellableList: [AnyCancellable] = []

    override func viewDidLoad() {
        navigationHidden = true
        navigationControlEnable = true
        super.viewDidLoad()
        
        let headerImageView = UIImageView().then {
            $0.image = UIImage(named: "lab_login_background")
            $0.contentMode = .scaleAspectFit
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(UIManager.shared.screenWidth*310.0/375.0)
            }
        }
        
        let welcomeLabel = UILabel().then {
            $0.text = "Welcome to\nFMW"
            $0.numberOfLines = 2
            $0.textColor = .black
            $0.font = .gothamBlackItalicFont(ofSize: 40)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(24)
                make.right.equalTo(-24)
                
                if UIManager.shared.screenHeight < 800 {
                    make.top.equalTo(UIManager.shared.navBarHeight)
                } else {
                    make.bottom.equalTo(headerImageView).offset(-16)
                }
            }
        }
        
        let phoneTitleLabel = UILabel().then {
            $0.text = "手机号登录"
            $0.textColor = .black
            $0.font = .semiboldPingFangSCFont(ofSize: 24)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(welcomeLabel)
                make.height.equalTo(33)
                
                if UIManager.shared.screenHeight < 800 {
                    make.top.equalTo(welcomeLabel.snp.bottom).offset(60)
                } else {
                    make.top.equalTo(headerImageView.snp.bottom).offset(16)
                }
            }
        }
        
        let phoneDescLabel = UILabel().then {
            $0.text = "未注册的手机号验证后自动完成注册"
            $0.textColor = color(0, 0, 0, 0.3)
            $0.font = .semiboldPingFangSCFont(ofSize: 14)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(welcomeLabel)
                make.height.equalTo(20)
                make.top.equalTo(phoneTitleLabel.snp.bottom).offset(6)
            }
        }
        
        let phoneBackView = UIView().then {
            $0.backgroundColor = color(244, 244, 244)
            $0.layer.cornerRadius = 12.0
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(phoneDescLabel)
                make.top.equalTo(phoneDescLabel.snp.bottom).offset(25)
                make.height.equalTo(48)
            }
        }
        
        countryCodeLabel.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: -20)
            $0.setTitle("+86", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
            $0.addAction(UIAction() { _ in
                let vc = CountryCodeViewController()
                vc.didSelectItemHandler = {[unowned self] item in
                    countryCodeLabel.setTitle("+\(item.areaCode)", for: .normal)
                }
                UIManager.present(modal: vc)
            }, for: .touchUpInside)
            phoneBackView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.width.lessThanOrEqualTo(50)
                make.height.centerY.equalToSuperview()
            }
        }
        
        let _ = UIImageView().then {
            $0.image = UIImage(named: "lab_login_country_code")
            phoneBackView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(8)
                make.left.equalTo(countryCodeLabel.snp.right).offset(6)
                make.centerY.equalToSuperview()
            }
        }
        
        let lineView = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.06)
            phoneBackView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(80)
                make.width.equalTo(1)
                make.height.equalTo(20)
                make.centerY.equalToSuperview()
            }
        }
        
        phoneTextField.do {
            $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            $0.attributedPlaceholder = NSAttributedString(string: "请输入手机号", attributes: [.foregroundColor: color(0, 0, 0, 0.4)])
            $0.textAlignment = .left
            $0.keyboardType = .phonePad
            $0.returnKeyType = .done
            $0.clearButtonMode = .never
            $0.textPublisher().receive(on: RunLoop.main).sink {[unowned self] result in
                if countryCodeLabel.currentTitle == "+86" {
                    loginBtn.backgroundColor = result.count == 11 ? color(0, 0, 0) : color(0, 0, 0, 0.5)
                } else {
                    loginBtn.backgroundColor = result.count >= 7 ? color(0, 0, 0) : color(0, 0, 0, 0.5)
                }
            }.store(in: &cancellableList)
            phoneBackView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(lineView.snp.right).offset(20)
                make.top.bottom.equalToSuperview()
                make.right.equalTo(-20)
            }
        }
        
        loginBtn.do {
            $0.backgroundColor = color(0, 0, 0, 0.4)
            $0.layer.cornerRadius = 12.0
            $0.setTitle("立即登录", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 16)
            $0.addAction(UIAction() {[unowned self] _ in
                if !checkboxBtn.isSelected {
                    Alert.show(title: "有协议及隐私保护", message: "已阅读并同意 用户协议 和 隐私协议 ，我们将对你的手机号进行验证\n\nFMW将严格保护你的个人信息安全", cancelBtnTitle: "取消", submitBtnTitle: "确定") {[unowned self] in
                        checkboxBtn.isSelected = true
                        submitBtnDidTap()
                    }
                } else {
                    submitBtnDidTap()
                }
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(24)
                make.right.equalTo(-24)
                make.height.equalTo(48)
                make.bottom.equalTo(-49)
            }
        }
        
        checkboxBtn.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
            $0.setImage(UIImage(named: "lab_login_protocol_default"), for: .normal)
            $0.setImage(UIImage(named: "lab_login_protocol_selected"), for: .selected)
            $0.addAction(UIAction() {[unowned self] _ in
                checkboxBtn.isSelected = !checkboxBtn.isSelected
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(24)
                make.bottom.equalTo(loginBtn.snp.top).offset(-12)
                make.width.height.equalTo(16)
            }
        }
        
        let _ = UITextView().then {
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLinkTap(_:))))
            $0.textContainerInset = .zero
            $0.textContainer.lineFragmentPadding = 0
            $0.linkTextAttributes = [
                .foregroundColor: color(51, 186, 255)
            ]
            $0.attributedText = eulaNote.text.attributedString(style: RichText.Style(
                attributes: [
                    .font: UIFont.regularPingFangSCFont(ofSize: 12),
                    .foregroundColor: color(0, 0, 0, 0.3),
                    .baselineOffset: NSNumber(value: UIFont.regularPingFangSCFont(ofSize: 12).lineHeight/2.0 - 20.0)
                ],
                linkAttributes: [
                    .font: UIFont.mediumPingFangSCFont(ofSize: 12),
                    .foregroundColor: color(51, 186, 255),
                ], strongAttributes: nil, userAttributes: nil), modifier: nil)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(checkboxBtn.snp.right).offset(6)
                make.centerY.equalTo(checkboxBtn)
                make.height.equalTo(40)
                make.right.equalTo(-24)
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
                else if keyboardFrame.origin.y - 10 - 80 > phoneBackView.bottom {
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
        
        if UserDefaults.standard.string(forKey: "com.fmw.make.welcome.protocol") != "1" {
            Alert.show(title: "有协议及隐私保护", message: "已阅读并同意 用户协议 和 隐私协议 ，我们将对你的手机号进行验证\n\nFMW将严格保护你的个人信息安全", cancelBtnTitle: "取消", submitBtnTitle: "确定") {[unowned self] in
                checkboxBtn.isSelected = true
                UserDefaults.standard.set("1", forKey: "com.fmw.make.welcome.protocol")
                
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    if settings.authorizationStatus == .notDetermined {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { granted, _ in
                            DispatchQueue.main.async {
                                if granted {
                                    UIApplication.shared.registerForRemoteNotifications()
                                }
                            }
                        }
                    } else if settings.authorizationStatus == .authorized {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            }
        }
    }
    
    private func submitBtnDidTap() {
        if countryCodeLabel.currentTitle == "+86" {
            if phoneTextField.text.nonnull.count != 11 {
                Toast.toast(title: "请输入正确的手机号")
                return
            }
        } else {
            if phoneTextField.text.nonnull.count < 7 {
                Toast.toast(title: "请输入正确的手机号")
                return
            }
        }
        
        UIManager.push(to: PhoneCodeViewController().then {
            $0.countryCode = countryCodeLabel.currentTitle.nonnull
            $0.phone = phoneTextField.text.nonnull
        })
    }
    
    @objc private func handleLinkTap(_ recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: recognizer.view)
        guard
            let textPosition = (recognizer.view as? UITextView)?.closestPosition(to: tapLocation),
            let url = (recognizer.view as? UITextView)?.textStyling(at: textPosition, in: .forward)?[NSAttributedString.Key.link] as? URL
        else { return }
        UIManager.push(to: InAppWebViewController().then { $0.url = url })
    }
}
