//
//  SettingsViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/18.
//

import Foundation
import BasicUIKit
import CodeLabUnityBridge
import APIKit

final class SettingsViewController: BaseViewController {
    
    private let settingsTabBar = SettingsCell()
    private let settingsFeedStyle = SettingsCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color(239, 239, 239)
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "设置"
        customBar.backgroundColor = view.backgroundColor
        
        let scrollView = UIScrollView().then {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(customBar.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        }
        
        let contentView = UIView().then {
            $0.backgroundColor = .clear
            scrollView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.width.equalTo(view)
            }
        }
        
        let backView1 = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(14)
                make.height.equalTo(240)
            }
        }
        
        let settingPush = SettingsCell().then {
            $0.titleLabel.text = "消息通知"
            $0.arrowView.image = UIImage(named: "lab_settings_push")
            $0.lineView.isHidden = false
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(messageSettings)))
            backView1.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(48)
            }
        }
        
        let settingAvatar = SettingsCell().then {
            $0.titleLabel.text = "数字形象设置"
            $0.arrowView.image = UIImage(named: "lab_settings_avatar")
            $0.lineView.isHidden = false
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarSettings)))
            backView1.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(48)
                make.top.equalTo(settingPush.snp.bottom)
            }
        }
        
        settingsTabBar.do {
            $0.titleLabel.text = "底部导航切换"
            $0.arrowView.image = UIImage(named: "lab_settings_tab")
            $0.lineView.isHidden = false
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabBarSettings)))
            backView1.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(48)
                make.top.equalTo(settingAvatar.snp.bottom)
            }
        }
        
        settingsFeedStyle.do {
            $0.titleLabel.text = "动态列表样式"
            $0.arrowView.image = UIImage(named: "lab_settings_feed")
            $0.lineView.isHidden = false
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(feedStyleSettings)))
            backView1.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(48)
                make.top.equalTo(settingsTabBar.snp.bottom)
            }
        }
        
        let _ = SettingsCell().then {
            $0.titleLabel.text = "我的收货地址"
            $0.arrowView.image = UIImage(named: "lab_settings_adress")
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addressSettings)))
            backView1.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(48)
                make.top.equalTo(settingsFeedStyle.snp.bottom)
            }
        }
        
        let backView2 = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(backView1.snp.bottom).offset(16)
                make.height.equalTo(96)
                make.bottom.equalTo(-10)
            }
        }
        
        let settingsFeedback = SettingsCell().then {
            $0.titleLabel.text = "问题反馈"
            $0.arrowView.image = UIImage(named: "lab_settings_feedback")
            $0.lineView.isHidden = false
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(feedbackSettings)))
            backView2.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(48)
                make.top.equalToSuperview()
            }
        }
        
        let _ = SettingsCell().then {
            $0.titleLabel.text = "注销账号"
            $0.arrowView.image = UIImage(named: "lab_settings_signout")
            $0.lineView.isHidden = true
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userAccountSettings)))
            backView2.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(48)
                make.top.equalTo(settingsFeedback.snp.bottom)
            }
        }
        
        let _ = UIButton().then {
            $0.backgroundColor = color(0, 0, 0)
            $0.layer.cornerRadius = 12.0
            $0.setTitle("退出登录", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 16)
            $0.addAction(UIAction() { _ in
                Alert.show(title: "确定要退出当前账号?", submitBtnTapHandler: {
                    AppContext.current.logout()
                    NotificationCenter.default.post(name: .notificationUserDidLogout, object: nil)
                })
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.height.equalTo(48)
                make.bottom.equalTo(-49)
            }
        }
    }
    
    @objc fileprivate func messageSettings() {
        UIManager.push(to: PushSettingsViewController())
    }
    
    @objc fileprivate func addressSettings() {
        UIManager.push(to: GoodsAddressListViewController())
    }
    
    @objc fileprivate func userAccountSettings() {
        Alert.show(title: "确定要注销当前账号?", submitBtnTapHandler: {
            HUD.show()
            Network.request(UserAPI.userRemoveAccount).responseData { response in
                if let error = response.error {
                    Toast.toast(title: error.localizedDescription)
                } else {
                    Toast.toast(title: "注销成功")
                    AppContext.current.logout()
                    NotificationCenter.default.post(name: .notificationUserDidLogout, object: nil)
                }
            }
        })
    }
    
    @objc fileprivate func feedbackSettings() {
        UIManager.push(to: ChatViewController().then { $0.chatWith = AppContext.assistorUserID })
    }
    
    @objc fileprivate func avatarSettings() {
        let unityVC = AvatarDecorationViewController()
        unityVC.userID = AppContext.current.userID
        CodeLabUnityInstance.shared.presentUnityWindow(with: CodeLabUnityWindowPresentationOptions(), overlayViewController: unityVC) {
            
        } completion: { handle, error in
            unityVC.backBtnDidTap = {
                handle?.dismiss(animated: true, completion: { _ in })
            }
        }
    }
    
    @objc fileprivate func tabBarSettings() {
        if UserDefaults.standard.bool(forKey: TabBarViewController.tabBarCircleKey) != true {
            UserDefaults.standard.set(true, forKey: TabBarViewController.tabBarCircleKey)
            Toast.toast(title: "底部导航切换至动态")
        } else {
            UserDefaults.standard.set(false, forKey: TabBarViewController.tabBarCircleKey)
            Toast.toast(title: "底部导航切换至静止")
        }
        NotificationCenter.default.post(name: TabBarViewController.tabBarChangeNotification, object: nil)
    }
    
    @objc fileprivate func feedStyleSettings() {
        if UserDefaults.standard.bool(forKey: CommunityContainerViewController.feedStyleKey) != true {
            UserDefaults.standard.set(true, forKey: CommunityContainerViewController.feedStyleKey)
            Toast.toast(title: "动态列表换至单列")
        } else {
            UserDefaults.standard.set(false, forKey: CommunityContainerViewController.feedStyleKey)
            Toast.toast(title: "动态列表换至双列")
        }
        NotificationCenter.default.post(name: CommunityContainerViewController.feedStyleChangeNotification, object: nil)
    }
}

fileprivate class SettingsCell: UIView {
    lazy var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .regularPingFangSCFont(ofSize: 14)
        $0.textAlignment = .left
        addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(arrowView.snp.right).offset(4)
            make.right.equalTo(-14)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }
    
    lazy var arrowView = UIImageView().then {
        addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    lazy var lineView = UIView().then {
        $0.backgroundColor = color(0, 0, 0, 0.05)
        addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.right.equalTo(-25)
        }
    }
}
