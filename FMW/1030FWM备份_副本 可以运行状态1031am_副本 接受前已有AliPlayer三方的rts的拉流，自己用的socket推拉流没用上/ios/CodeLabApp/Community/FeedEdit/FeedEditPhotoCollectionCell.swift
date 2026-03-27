//
//  FeedEditPhotoCollectionCell.swift
//  Genz
//
//  Created by Sera on 2021/5/22.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import Combine

final class FeedEditPhotoCollectionCell: UICollectionViewCell {
    fileprivate lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    fileprivate lazy var videoMarkView = UIImageView().then {
        $0.image = UIImage(named: "ge_feed_edit_video")
        contentView.insertSubview($0, aboveSubview: imageView)
        $0.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    
    fileprivate lazy var cancelBtn = UIButton().then {
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        $0.setImage(UIImage(named: "lab_feed_edit_photo_cancel"), for: .normal)
        $0.addAction(UIAction() {[unowned self] _ in
            cancelSelectHandler?()
        }, for: .touchUpInside)
        contentView.insertSubview($0, aboveSubview: imageView)
        $0.snp.makeConstraints { make in
            make.top.equalTo(4)
            make.right.equalTo(-4)
            make.width.height.equalTo(20)
        }
    }
    
    var overlayImage: UIImage? { return imageView.image }
    var cancelSelectHandler: PureCompletionHandler?

    fileprivate var element: (any FeedEditElement)?
    func bindModel(_ element: any FeedEditElement) {
        self.element = element
        videoMarkView.isHidden = element.elementType != .video
        cancelBtn.isHidden = false
        
        imageView.image = nil
        element.fetchElementImage(isBig: false, saveToAlbum: false, isSynchrouns: false) {[weak self] image, identifier in
            guard let strongSelf = self else { return }
            if (strongSelf.element?.uniqueIdentifier).nonnull == identifier {
                strongSelf.imageView.image = image
            }
        }
    }
}

final class FeedEditPhotoAddCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let _ = UIImageView().then {
            $0.image = UIImage(named: "ge_feed_edit_photo_add")
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
