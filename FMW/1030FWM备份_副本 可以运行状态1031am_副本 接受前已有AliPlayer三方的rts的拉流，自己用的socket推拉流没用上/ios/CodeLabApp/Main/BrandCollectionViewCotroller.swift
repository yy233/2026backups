//
//  BrandCollectionViewCotroller.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/13.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import YYImage

final class BrandCollectionViewController: CollectionViewController {
    
    private var innerImage: [YYImage] = []
    private let names = ["#Adamash", "#AUTK", "#ATOMOHYA", "#BLACK SCALE", "#BLOCCO 5", "#Disney"]
    private let userNames = ["Daniel", "James", "Charlotte", "lsabella", "Haper"]

    override func viewDidLoad() {
        showRefreshHeader = false
        showLoadMoreFooter = false
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "品牌推荐"
        
        if let flowlayout = flowLayout as? CollectionWaterFlowLayout {
            flowlayout.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 60, right: 10)
            flowlayout.columnCount = 2
            flowlayout.columnSpacing = 15
            flowlayout.lineSpacing = 15
            flowlayout.indexPathHeightHandler = {[unowned self] indexPath,width in
                let image = innerImage[indexPath.item%innerImage.count]
                let imageHeight = image.size.height/image.size.width*width
                return imageHeight + 70
            }
        }
        
        collectionView?.register(cellWithClass: ImageCollectionCell.self)
        collectionView?.snp.makeConstraints({ make in
            make.top.equalTo(customBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let strongSelf = self else { return }
            for i in 1...8 {
                if let image = YYImage(named: "ge_icon_brand_list_item_\(i)") {
                    strongSelf.innerImage.append(image)
                }
            }
            
            DispatchQueue.main.async {
                strongSelf.collectionView?.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return innerImage.count*5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
        cell.contentView.backgroundColor = .white
        cell.imageView.image = innerImage[indexPath.item%innerImage.count]
        cell.topicView.image = indexPath.item == 0 ? UIImage(named: "ge_icon_brand_list_topic_1") : ( indexPath.item == 1 ? UIImage(named: "ge_icon_nft_list_topic_2") : nil )
        cell.textLabel.text = names[indexPath.item%names.count]
        cell.avatarView.image = UIImage(named: "ge_icon_user_rank_avatar_\(indexPath.item%5 + 1)")
        cell.nameLabel.text = userNames[indexPath.item%userNames.count]
        cell.likeLabel.text = "999+"
        cell.isLike = indexPath.item%4 == 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIManager.push(to: BrandDetailViewController())
    }
    
    fileprivate class ImageCollectionCell: UICollectionViewCell {
        fileprivate lazy var imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(-70)
            }
        }
        
        fileprivate lazy var topicView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(topicTap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.bottom.equalTo(imageView).offset(-10)
                make.width.equalTo(65)
                make.height.equalTo(24)
            }
        }
        
        fileprivate lazy var textLabel = UILabel().then {
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textColor = color(62, 62, 62)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(imageView)
                make.height.equalTo(20)
                make.top.equalTo(imageView.snp.bottom).offset(10)
            }
        }
        
        fileprivate lazy var avatarView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.left.equalTo(imageView)
                make.top.equalTo(textLabel.snp.bottom).offset(10)
            }
        }
        
        fileprivate lazy var nameLabel = UILabel().then {
            $0.font = .regularPingFangSCFont(ofSize: 12)
            $0.textColor = color(62, 62, 62)
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(avatarView.snp.right).offset(8)
                make.right.lessThanOrEqualTo(-100)
                make.height.equalTo(17)
                make.centerY.equalTo(avatarView)
            }
        }
        
        fileprivate lazy var likeView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeTap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.right.equalTo(imageView)
                make.centerY.equalTo(avatarView)
            }
        }
        
        fileprivate lazy var likeLabel = UILabel().then {
            $0.font = .regularPingFangSCFont(ofSize: 12)
            $0.textColor = color(191, 30, 30)
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeTap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(likeView.snp.left)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(17)
                make.centerY.equalTo(avatarView)
            }
        }
        
        var isLike = false {
            didSet {
                likeView.image = isLike ? UIImage(named: "ge_icon_nft_list_like") : UIImage(named: "ge_icon_nft_list_unlike")
            }
        }
        
        @objc func likeTap() {
            isLike = !isLike
        }
        
        @objc func topicTap() {
            UIManager.push(to: CommunityFeedListViewController())
        }
        
        @objc func userTap() {
            UIManager.push(to: UserViewController())
        }
    }
}

