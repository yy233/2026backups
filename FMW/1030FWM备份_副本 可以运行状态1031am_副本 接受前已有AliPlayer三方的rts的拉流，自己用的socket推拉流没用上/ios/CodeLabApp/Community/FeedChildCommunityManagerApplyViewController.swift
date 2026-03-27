//
//  FeedChildCommunityManagerApplyViewController.swift
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

final class FeedChildCommunityManagerApplyViewController: BaseViewController {
        
    var communityItem: CommunityItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "管理员申请"
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
        $0.setTitle("申请", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.mediumPingFangSCFont(ofSize: 16)
        $0.addAction(UIAction() {[unowned self] _ in
            if textView.text.nonnull.isEmpty {
                Toast.toast(title: "请填写申请理由")
                return
            }
            
            HUD.show()
            Network.request(FeedAPI.communityManagerApply, parameters: ["id": (communityItem?.id).nonnull, "reason": textView.text.nonnull]).responseData { response in
                if let error = response.error {
                    Toast.toast(title: error.localizedDescription)
                } else {
                    Toast.toast(title: "申请成功")
                    self.backBtnTapHandler()
                }
            }
        }, for: .touchUpInside)
    }
    
    fileprivate lazy var textView = RSKPlaceholderTextView().then {
        $0.backgroundColor = color(245, 245, 245)
        $0.textContainerInset = .zero
        $0.font = UIFont.regularPingFangSCFont(ofSize: 16)
        $0.textColor = .black
        $0.placeholder = "请填写您的申请宣言"
        $0.placeholderColor = color(0, 0, 0, 0.3)
        $0.textAlignment = .left
        $0.keyboardType = .default
    }
}

//MARK: - View
extension FeedChildCommunityManagerApplyViewController {
    fileprivate func setupView() {
        view.addSubview(backView)
        view.addSubview(submitBtn)
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(customBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(submitBtn.snp.top).offset(-10)
        }
        
        backView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }
        
        let nameLabel = UILabel().then {
            $0.text = "申请宣言"
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
        
        let introBackView = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 8
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(view).offset(-16)
                make.height.equalTo(140)
                make.top.equalTo(nameLabel.snp.bottom).offset(10)
                make.bottom.equalTo(-20)
            }
        }
        
        introBackView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.top.equalTo(12)
            make.right.equalTo(-12)
            make.bottom.equalTo(-12)
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
