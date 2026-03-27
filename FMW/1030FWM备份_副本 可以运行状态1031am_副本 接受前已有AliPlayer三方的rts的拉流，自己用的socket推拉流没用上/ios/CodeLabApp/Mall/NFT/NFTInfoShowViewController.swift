//
//  NFTInfoShowViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/18.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import YYImage

final class NFTInfoShowViewController: UIViewController {
    
    var nftInfo: NFTInfo?
    
    private let contentView = UIView()

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
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(UIManager.shared.screenHeight - 200 > 501 ? 501 : UIManager.shared.screenHeight - 200)
            }
        }
        
        let titleLabel = UILabel().then {
            $0.text = nftInfo?.name
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 18)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-50)
                make.height.lessThanOrEqualTo(50)
                make.top.equalTo(26)
            }
        }
        
        let descLabel = UILabel().then {
            $0.text = "积分抽奖数藏展示"
            $0.textColor = color(0, 0, 0, 0.4)
            $0.font = .regularPingFangSCFont(ofSize: 12)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(titleLabel)
                make.height.equalTo(18)
                make.top.equalTo(titleLabel.snp.bottom).offset(2)
            }
        }
        
        let _ = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "ge_icon_modal_dismiss"), for: .normal)
            $0.addTarget(self, action: #selector(dismissBtnTap), for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-20)
                make.width.height.equalTo(20)
                make.centerY.equalTo(titleLabel)
            }
        }
        
        let nftImageView = UIImageView().then {
            $0.setWebImage(url: OSSUploader.imageNFTURLFor((nftInfo?.cover?.guid).nonnull, crop: .medium), cornerRadius: 8*3.0, finalSize: CGSize(width: 100*3.0, height: 100*3.0))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(titleLabel)
                make.width.height.equalTo(100)
                make.top.equalTo(descLabel.snp.bottom).offset(24)
            }
        }
        
        let storyLabel = UILabel().then {
            $0.text = "藏品故事"
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 14)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(titleLabel)
                make.height.equalTo(20)
                make.top.equalTo(nftImageView.snp.bottom).offset(20)
            }
        }
        
        let _ = UITextView().then {
            $0.backgroundColor = .white
            let content = (nftInfo?.story).nonnull.data(using: .unicode).nonnull
            $0.attributedText = try? NSAttributedString(data: content, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            $0.textColor = color(0, 0, 0, 0.5)
            $0.isEditable = false
            $0.font = .regularPingFangSCFont(ofSize: 12)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(storyLabel.snp.bottom).offset(10)
                make.bottom.equalTo(UIManager.shared.isNotchScreen ? -50 : -20)
            }
        }
    }
    
    @objc fileprivate func dismissBtnTap() {
        dismiss(animated: true)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        view.backgroundColor = color(0, 0, 0, 0.5)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        view.backgroundColor = .clear
//    }
}
