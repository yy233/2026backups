//
//  NFTCollectionCell.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/6.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit

class NFTCollectionCell: UICollectionViewCell {
    lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(-30)
        }
    }
    
    lazy var textLabel = UILabel().then {
        $0.font = .semiboldPingFangSCFont(ofSize: 14)
        $0.textColor = .black
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.right.equalTo(imageView)
            make.height.equalTo(20)
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
    }
    
    lazy var pointsLabel = UIButton().then {
        $0.backgroundColor = color(0, 0, 0, 0.6)
        $0.layer.cornerRadius = 12.0
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .gothamBoldFont(ofSize: 12)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.bottom.right.equalTo(imageView).offset(-12)
            make.height.equalTo(24)
            make.width.lessThanOrEqualTo(imageView)
        }
    }
}

class GoodsCollectionCell: UICollectionViewCell {
    lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(-72)
        }
    }
    
    lazy var textLabel = UILabel().then {
        $0.font = .semiboldPingFangSCFont(ofSize: 14)
        $0.textColor = .black
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(imageView)
            make.right.equalTo(imageView)
            make.height.equalTo(20)
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
    }
    
    lazy var priceLabel = UILabel().then {
        $0.font = .semiboldPingFangSCFont(ofSize: 16)
        $0.textColor = color(255, 38, 111)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.right.equalTo(textLabel)
            make.height.equalTo(22)
            make.top.equalTo(textLabel.snp.bottom).offset(2)
        }
    }
}
