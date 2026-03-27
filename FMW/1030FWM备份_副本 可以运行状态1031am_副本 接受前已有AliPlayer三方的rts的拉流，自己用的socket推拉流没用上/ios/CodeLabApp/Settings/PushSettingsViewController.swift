//
//  PushSettingsViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/10/17.
//

import Foundation
import BasicUIKit
import APIKit

final class PushSettingsViewController: BaseViewController {
    
    private let settingSystem = SettingsCell()
    private let settingLike = SettingsCell()
    private let settingComment = SettingsCell()
    private let settingMark = SettingsCell()
    private let settingIM = SettingsCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color(239, 239, 239)
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "通知设置"
        customBar.backgroundColor = view.backgroundColor
        
        let scrollView = UIScrollView().then {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.alwaysBounceVertical = true
            $0.backgroundColor = .clear
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(customBar.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        }
        
        let contentView = UIView().then {
            $0.backgroundColor = .white
            scrollView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(20)
                make.left.bottom.equalToSuperview()
                make.width.equalTo(view)
            }
        }
        
        settingSystem.do {
            $0.titleLabel.text = "系统通知"
            $0.switchView.isOn = false
            $0.lineView.isHidden = false
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(systemPushSettings)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(60)
            }
        }
        
        settingLike.do {
            $0.titleLabel.text = "点赞通知"
            $0.switchView.isOn = false
            $0.lineView.isHidden = false
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likePushSettings)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(settingSystem.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(60)
            }
        }
        
        settingComment.do {
            $0.titleLabel.text = "评论通知"
            $0.switchView.isOn = false
            $0.lineView.isHidden = false
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(commentPushSettings)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(settingLike.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(60)
            }
        }
        
        settingMark.do {
            $0.titleLabel.text = "收藏通知"
            $0.switchView.isOn = false
            $0.lineView.isHidden = false
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(markPushSettings)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(settingComment.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(60)
            }
        }
        
        settingIM.do {
            $0.titleLabel.text = "聊天消息提醒"
            $0.switchView.isOn = false
            $0.lineView.isHidden = false
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imPushSettings)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(settingMark.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(60)
                make.bottom.equalTo(-20)
            }
        }
        
        Network.request(UserAPI.pushSwitchInfo).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let list = response.data?["list"] as? [[String: Any]] {
                for item in list {
                    let name = item["type"] as? String
                    let value = item["pushSwitch"] as? Int
                    
                    if name == "system" {
                        self.settingSystem.switchView.setOn(value.nonnull > 0, animted: true)
                    } else if name == "like" {
                        self.settingLike.switchView.setOn(value.nonnull > 0, animted: true)
                    } else if name == "comment" {
                        self.settingComment.switchView.setOn(value.nonnull > 0, animted: true)
                    } else if name == "mark" {
                        self.settingMark.switchView.setOn(value.nonnull > 0, animted: true)
                    } else if name == "im" {
                        self.settingIM.switchView.setOn(value.nonnull > 0, animted: true)
                    }
                }
            }
        }
    }
    
    @objc fileprivate func systemPushSettings() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        settingSystem.switchView.setOn(!settingSystem.switchView.isOn, animted: true)
        let isOn = settingSystem.switchView.isOn
        Network.request(UserAPI.pushSettings, parameters: ["type": "system", "value": isOn ? 1 : 0]).responseEmpty()
    }
    
    @objc fileprivate func likePushSettings() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        settingLike.switchView.setOn(!settingLike.switchView.isOn, animted: true)
        let isOn = settingLike.switchView.isOn
        Network.request(UserAPI.pushSettings, parameters: ["type": "like", "value": isOn ? 1 : 0]).responseEmpty()
    }
    
    @objc fileprivate func commentPushSettings() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        settingComment.switchView.setOn(!settingComment.switchView.isOn, animted: true)
        let isOn = settingComment.switchView.isOn
        Network.request(UserAPI.pushSettings, parameters: ["type": "comment", "value": isOn ? 1 : 0]).responseEmpty()
    }
    
    @objc fileprivate func markPushSettings() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        settingMark.switchView.setOn(!settingMark.switchView.isOn, animted: true)
        let isOn = settingMark.switchView.isOn
        Network.request(UserAPI.pushSettings, parameters: ["type": "mark", "value": isOn ? 1 : 0]).responseEmpty()
    }
    
    @objc fileprivate func imPushSettings() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        settingIM.switchView.setOn(!settingIM.switchView.isOn, animted: true)
        let isOn = settingIM.switchView.isOn
        Network.request(UserAPI.pushSettings, parameters: ["type": "im", "value": isOn ? 1 : 0]).responseEmpty()
    }
    
    fileprivate class SettingsCell: UIView {
        lazy var titleLabel = UILabel().then {
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 16)
            $0.textAlignment = .left
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.width.lessThanOrEqualTo(200)
                make.height.equalTo(23)
                make.centerY.equalToSuperview()
            }
        }
        
        lazy var lineView = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
        }
        
        lazy var switchView = SwitchView().then {
            $0.onTintColor = color(51, 186, 255)
            $0.offTintColor = color(0, 0, 0, 0.1)
            $0.onStatusTintColor = .white
            $0.offStatusTintColor = .white
            $0.statusHeight = 22
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(44)
                make.height.equalTo(26)
                make.right.equalTo(-16)
                make.centerY.equalTo(titleLabel)
            }
        }
    }
}
