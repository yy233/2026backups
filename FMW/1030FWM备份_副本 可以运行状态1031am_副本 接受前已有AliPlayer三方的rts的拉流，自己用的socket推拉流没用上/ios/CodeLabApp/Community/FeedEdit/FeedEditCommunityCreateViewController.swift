//
//  FeedEditCommunityCreateViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/8/30.
//

import Foundation
import Combine
import BasicUIKit
import BasicKit
import UIKit
import AlbumUIKit
import PhotosUI
import IQKeyboardManagerSwift
import APIKit

final class FeedEditCommunityCreateViewController: BaseViewController {

    var name: String?
    var didSubmitHandler: ((CommunityItem) -> Void)?
    
    private var photoGUID: String?
    private var photoImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "创建社区"
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    //MARK: - View
    fileprivate lazy var backView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.alwaysBounceVertical = true
        $0.keyboardDismissMode = .onDrag
    }
    
    fileprivate lazy var contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    fileprivate lazy var submitBtn = UIButton().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 12
        $0.setTitle("创建", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.mediumPingFangSCFont(ofSize: 16)
        $0.addTarget(self, action: #selector(submitBtnTapHandler), for: .touchUpInside)
    }
        
    fileprivate lazy var nameTextField = UITextField().then {
        $0.text = name
        $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
        $0.textColor = .black
        $0.attributedPlaceholder = NSAttributedString(string: "输入社区名称", attributes: [.foregroundColor: color(0, 0, 0, 0.3)])
        $0.textAlignment = .left
        $0.keyboardType = .default
        $0.delegate = self
    }
    
    fileprivate lazy var iconView = UIImageView().then {
        $0.image = UIImage(named: "ge_feed_edit_photo_add")
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(iconBtnTapHandler)))
    }
    
    fileprivate lazy var textView = RSKPlaceholderTextView().then {
        $0.backgroundColor = color(245, 245, 245)
        $0.textContainerInset = .zero
        $0.font = UIFont.regularPingFangSCFont(ofSize: 16)
        $0.textColor = .black
        $0.placeholder = "请输入..."
        $0.placeholderColor = color(0, 0, 0, 0.3)
        $0.textAlignment = .left
        $0.keyboardType = .default
        $0.delegate = self
    }
    
    fileprivate lazy var textCountLabel = UILabel().then {
        $0.text = "0/500"
        $0.textColor = color(0, 0, 0, 0.3)
        $0.font = .regularPingFangSCFont(ofSize: 12)
        $0.textAlignment = .right
    }
}

//MARK: - View
extension FeedEditCommunityCreateViewController {
    fileprivate func setupView() {
        view.addSubview(backView)
        view.addSubview(submitBtn)
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(customBar.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(submitBtn.snp.top).offset(-10)
        }
        
        backView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }
        
        let nameLabel = UILabel().then {
            $0.text = "社区名称"
            $0.textColor = color(0, 0, 0, 0.5)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.top.equalTo(24)
                make.height.equalTo(20)
                make.width.lessThanOrEqualTo(200)
            }
        }
        
        let nameBackView = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 8
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(view).offset(-16)
                make.height.equalTo(44)
                make.top.equalTo(nameLabel.snp.bottom).offset(10)
            }
        }
        
        nameBackView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.height.equalToSuperview()
            make.right.equalTo(-12)
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(0.5)
                make.top.equalTo(nameBackView.snp.bottom).offset(16)
            }
        }
        
        let iconLabel = UILabel().then {
            $0.text = "社区图标"
            $0.textColor = color(0, 0, 0, 0.5)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.top.equalTo(nameBackView.snp.bottom).offset(33)
                make.height.equalTo(20)
                make.width.lessThanOrEqualTo(200)
            }
        }
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.left.equalTo(iconLabel)
            make.top.equalTo(iconLabel.snp.bottom).offset(12)
            make.width.height.equalTo(80)
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(0.5)
                make.top.equalTo(iconView.snp.bottom).offset(16)
            }
        }
        
        let introLabel = UILabel().then {
            $0.text = "社区介绍"
            $0.textColor = color(0, 0, 0, 0.5)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.top.equalTo(iconView.snp.bottom).offset(33)
                make.height.equalTo(20)
                make.width.lessThanOrEqualTo(200)
            }
        }
        
        let introBackView = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 8
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(view).offset(-16)
                make.height.equalTo(100)
                make.top.equalTo(introLabel.snp.bottom).offset(10)
                make.bottom.equalTo(-20)
            }
        }
        
        introBackView.addSubview(textView)
        introBackView.addSubview(textCountLabel)
        textView.snp.makeConstraints { make in
            make.left.top.equalTo(12)
            make.right.equalTo(-12)
            make.bottom.equalTo(-35)
        }
        
        textCountLabel.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.bottom.equalTo(-8)
            make.height.equalTo(17)
            make.width.equalTo(100)
        }
        
        submitBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-55)
            make.right.equalTo(-16)
            make.height.equalTo(44)
            make.left.equalTo(16)
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(240, 240, 240)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
                make.bottom.equalTo(submitBtn.snp.top).offset(-8)
            }
        }
    }
}

extension FeedEditCommunityCreateViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isNotEmpty, textField.text.nonnull.appending(string).utf16.count > 15 {
            textField.unmarkText()
            return false
        }
        
        return true
    }
}

extension FeedEditCommunityCreateViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.isNotEmpty, textView.text.nonnull.appending(text).utf16.count > 500 {
            textView.unmarkText()
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textCountLabel.text = "\(textView.text.nonnull.utf16.count)/500"
    }
}

//MARK: - Event
extension FeedEditCommunityCreateViewController {
    @objc fileprivate func submitBtnTapHandler() {
        view.endEditing(true)
        
        if nameTextField.text.nonnull.isEmpty {
            Toast.toast(title: "请输入社区名称")
            return
        }
        
        if photoImage == nil {
            Toast.toast(title: "请上传社区图标")
            return
        }
        
        HUD.show()
        if let _ = photoGUID {
            submitCommunity()
        } else if let data = photoImage?.jpegData(compressionQuality: 1.0) {
            let name = "iOS_\(Date().timeIntervalSince1970)-\(arc4random())-community".md5
            let object = OSSUploader.imageFolder + name + ".jpg"
            OSSUploader.uploadData(data: data, name: object) { _ in
                
            } completion: { error in
                if let _ = error {
                    HUD.hide()
                    Toast.toast(title: "图片上传失败")
                } else {
                    self.photoGUID = name
                    DispatchQueue.main.async { self.submitCommunity() }
                }
            }
        }
    }
    
    private func submitCommunity() {
        Network.request(FeedAPI.communityCreate, parameters: ["name": nameTextField.text.nonnull, "introduction": textView.text.nonnull, "icon": photoGUID.nonnull]).responseData { response in
            HUD.hide()
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let data = response.data?.jsonData(), let community = try? JSONDecoder().decode(CommunityItem.self, from: data) {
                self.didSubmitHandler?(community)
                self.backBtnTapHandler()
            }
        }
    }
    
    @objc fileprivate func iconBtnTapHandler() {
        view.endEditing(true)
        
        let assetsVC = AssetsListViewController()
        assetsVC.maxSelectCount = 1
        assetsVC.minSelectCount = 1
        assetsVC.type = .photo
        assetsVC.didSubmitHandler = {[unowned self, unowned assetsVC] assets in
            if let asset = assets.first {
                AlbumAssetsContext.fetchImage(for: asset, resolution: .feed) {[unowned self] image, _ in
                    iconView.image = image
                    photoImage = image
                }
            }

            assetsVC.dismiss(animated: true)
        }
        UIManager.present(modal: assetsVC)
    }
}
