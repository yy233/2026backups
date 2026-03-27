//
//  MagazineDetailViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/11.
//

import Foundation
import UIKit
import BasicUIKit
import BasicKit
import APIKit

final class MagazineDetailViewController: CollectionViewController {
    
    var magazineItem: MagazineItem?
    
    override func viewDidLoad() {
        showRefreshHeader = false
        showLoadMoreFooter = false
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "杂志"
        
        if let flowlayout = flowLayout as? CollectionWaterFlowLayout {
            flowlayout.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
            flowlayout.columnCount = 1
            flowlayout.columnSpacing = 0
            flowlayout.lineSpacing = 0
            flowlayout.indexPathHeightHandler = {[unowned self] indexPath, width in
                if let item = magazineItem?.contents?[indexPath.item] {
                    return max(1, item.ht.nonnull)/max(1, item.wt.nonnull)*width
                }
                return width
            }
        }
        
        collectionView?.showsVerticalScrollIndicator = true
        collectionView?.register(cellWithClass: ImageCollectionCell.self)
        collectionView?.snp.makeConstraints({ make in
            make.top.equalTo(customBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
        
        Network.request(MainAPI.magazineDetail, parameters: ["id": (magazineItem?.id).nonnull]).responseData {[weak self] response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let data = response.data?.jsonData(), let item = try? JSONDecoder().decode(MagazineItem.self, from: data) {
                self?.magazineItem = item
                self?.collectionView?.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (magazineItem?.contents?.count).nonnull
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
        cell.imageView.image = nil
        if let item = magazineItem?.contents?[indexPath.item] {
            cell.imageView.setWebImage(url: OSSUploader.imageURLFor(item.guid, crop: .origin))
        }
        cell.contentView.backgroundColor = .white
        return cell
    }
    
    fileprivate class ImageCollectionCell: UICollectionViewCell {
        fileprivate lazy var imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
    }
}
