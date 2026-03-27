//
//  RegisterNameViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/8/24.
//

import Foundation
import BasicKit
import BasicUIKit
import CodeLabUnityBridge
import Combine
import YYImage
import APIKit
import Alamofire

final class RegisterNameViewController: BaseViewController {
    var loginBtnDidTap: PureCompletionHandler?
    
    struct AvatarItem: Codable {
        var avatarId: String = ""
        var smallUrl: String?
        var bigUrl: String?
        
        enum CodingKeys: CodingKey {
            case avatarId
            case smallUrl
            case bigUrl
        }
    }
    
    private let nameTextField = UITextField()
    private let loginBtn = UIButton()
    private let avatarImageView = UIImageView()
    
    private var currentIndex = 0
    private var cancellableList: [AnyCancellable] = []
    private var avatars: [AvatarItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color(239, 239, 239)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: UIManager.shared.screenWidth*150.0/375.0, width: UIManager.shared.screenWidth, height: 150)
        gradientLayer.colors = [color(255, 255, 255).cgColor, color(239, 239, 239).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        view.layer.addSublayer(gradientLayer)
        
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
            $0.text = "请选择你的头像&昵称"
            $0.textColor = .black
            $0.font = .semiboldPingFangSCFont(ofSize: 24)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(24)
                make.right.equalTo(-24)
                make.height.equalTo(33)
                
                if UIManager.shared.screenHeight < 800 {
                    make.top.equalTo(44)
                } else {
                    make.top.equalTo(headerImageView.snp.bottom).offset(16)
                }
            }
        }
        
        let phoneDescLabel = UILabel().then {
            $0.text = "完善个人资料，快速结识更多朋友"
            $0.textColor = color(0, 0, 0, 0.3)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(phoneTitleLabel)
                make.height.equalTo(20)
                make.top.equalTo(phoneTitleLabel.snp.bottom).offset(6)
            }
        }
        
        loginBtn.do {
            $0.backgroundColor = color(0, 0, 0, 0.5)
            $0.layer.cornerRadius = 12.0
            $0.setTitle("立即登录", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 16)
            $0.addAction(UIAction() {[unowned self] _ in
                loginBtnDidTap?()
                if nameTextField.text.nonnull.isEmpty {
                    Toast.toast(title: "请输入昵称")
                    return
                }

                HUD.show()
                Network.request(LoginAPI.registerUserName, parameters: ["avatarId": avatars[currentIndex].avatarId, "nickName": nameTextField.text.nonnull]).responseData { response in
                    HUD.hide()
                    if let error = response.error {
                        Toast.toast(title: error.localizedDescription)
                    } else {
                        AppContext.current.userContext?.user?.user?.userInfo?.avatar = ""
                        AppContext.current.userContext?.user?.user?.userInfo?.userName = self.nameTextField.text.nonnull
                        NotificationCenter.default.post(name: .notificationUserDidLogin, object: nil)
                    }
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
        
        let nameBackView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 12.0
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(24)
                make.right.equalTo(-24)
                make.height.equalTo(48)
                make.bottom.equalTo(loginBtn.snp.top).offset(-51)
            }
        }
        
        nameTextField.do {
            $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            $0.keyboardType = .default
            $0.returnKeyType = .done
            $0.clearButtonMode = .never
            $0.delegate = self
            $0.attributedPlaceholder = NSAttributedString(string: "请输入昵称", attributes: [.font: UIFont.regularPingFangSCFont(ofSize: 14), .foregroundColor: color(0, 0, 0, 0.4)])
            $0.textPublisher().receive(on: RunLoop.main).sink {[unowned self] result in
                loginBtn.backgroundColor = !result.isEmpty ? .black : color(0, 0, 0, 0.5)
            }.store(in: &cancellableList)
            nameBackView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.bottom.equalToSuperview()
            }
        }
        
        let avatarBackView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 22
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.layer.shadowColor = color(227, 227, 227, 0.64).cgColor
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowRadius = 20
            view.insertSubview($0, belowSubview: loginBtn)
            $0.snp.makeConstraints { make in
                make.left.equalTo(24)
                make.right.equalTo(-24)
                make.bottom.equalTo(-209)
                make.top.equalTo(phoneDescLabel.snp.bottom).offset(135)
            }
        }
        
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.minimumLineSpacing = 8
            $0.minimumInteritemSpacing = 8
            $0.scrollDirection = .horizontal
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
            $0.backgroundColor = .white
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.delegate = self
            $0.dataSource = self
            $0.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.register(cellWithClass: AvatarCollectionCell.self)
            $0.keyboardDismissMode = .onDrag
            $0.contentInsetAdjustmentBehavior = .never
            avatarBackView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(70)
                make.bottom.equalTo(-24)
            }
        }
        
        avatarImageView.do {
            $0.contentMode = .scaleAspectFit
            view.insertSubview($0, belowSubview: loginBtn)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(phoneDescLabel.snp.bottom).offset(UIManager.shared.screenHeight < 800 ? 20 : 42)
                make.bottom.equalTo(collectionView.snp.top).offset(-20)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = view.backgroundColor
            view.insertSubview($0, belowSubview: loginBtn)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(nameBackView).offset(-10)
                make.bottom.equalTo(loginBtn).offset(10)
            }
        }
        
        NotificationCenter.default.publisher(for: UIApplication.keyboardWillChangeFrameNotification).sink {[weak self] notification in
            guard let strongSelf = self else { return }
            if strongSelf.nameTextField.isFirstResponder,
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
        
        Network.request(LoginAPI.registerAvatarList, encoding: URLEncoding.default).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let data = (response.data?["list"] as? [Any])?.jsonString.data(using: .utf8), let avatars = try? JSONDecoder().decode([AvatarItem].self, from: data), !avatars.isEmpty {
                self.avatars = avatars
                collectionView.reloadData()
                self.avatarImageView.setWebImage(url: avatars[0].bigUrl.nonnull)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (navigationController as? NavigationViewController)?.popGestureEnable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (navigationController as? NavigationViewController)?.popGestureEnable = true
    }
}

extension RegisterNameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isNotEmpty, textField.text.nonnull.count >= 15 { return false }
        return true
    }
}

extension RegisterNameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: AvatarCollectionCell.self, for: indexPath)
        cell.contentView.backgroundColor = .white
        cell.imageView.setWebImage(url: avatars[indexPath.item].smallUrl.nonnull, cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
        cell.borderView.isHidden = indexPath.item != currentIndex
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.item
        avatarImageView.setWebImage(url: avatars[currentIndex].bigUrl.nonnull)
        collectionView.reloadData()
    }
}

fileprivate class AvatarCollectionCell: UICollectionViewCell {
    fileprivate lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 31
        $0.layer.masksToBounds = true
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        }
    }
    
    fileprivate lazy var borderView = UIView().then {
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 2.0
        $0.layer.cornerRadius = 35
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
}
