//
//  MainLeftMenuViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/11.
//

import Foundation
import UIKit
import BasicUIKit
import BasicKit

struct MagazineItem: Codable, IdentifierElement {
    var id: String = ""
    var title: String?
    var summary: String?
    var cover: NFTInfo.MediaCover?
    var contents: [NFTInfo.MediaCover]?
    
    var uniqueIdentifier: String { id }
    
    enum CodingKeys: String, CodingKey {
        case id = "magazineId"
        case title
        case summary
        case cover
        case contents
    }
}

final class MainLeftMenuViewController: CollectionViewController, UIGestureRecognizerDelegate {
    
    fileprivate static let viewWidth = 289
    
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = InnerViewModel()
        viewModel.url = MainAPI.magazineList.rawValue
        self.viewModel = viewModel
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isHidden = true
        
        let contentView = UIView().then {
            $0.backgroundColor = .white
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.width.equalTo(MainLeftMenuViewController.viewWidth)
            }
        }
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeToLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let tapDismiss = UITapGestureRecognizer(target: self, action: #selector(swipeToLeft))
        tapDismiss.delegate = self
        view.addGestureRecognizer(tapDismiss)
        
        let searchBack = UIButton().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 8.0
            $0.addTarget(self, action: #selector(searchTap), for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(UIManager.shared.statusBarHeight + 16)
                make.height.equalTo(38)
            }
        }
        
        let searchIcon = UIImageView().then {
            $0.image = UIImage(named: "ge_icon_main_left_search")
            searchBack.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(16)
                make.centerY.equalToSuperview()
                make.left.equalTo(16)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "请输入杂志名称"
            $0.font = .regularPingFangSCFont(ofSize: 12)
            $0.textColor = color(179, 179, 179)
            $0.textAlignment = .left
            searchBack.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(searchIcon.snp.right).offset(6)
                make.centerY.equalToSuperview()
                make.right.equalTo(-16)
                make.height.equalTo(20)
            }
        }
        
        if let flowlayout = flowLayout as? CollectionWaterFlowLayout {
            flowlayout.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 60, right: 16)
            flowlayout.columnCount = 1
            flowlayout.columnSpacing = 12
            flowlayout.lineSpacing = 12
            flowlayout.indexPathHeightHandler = { indexPath, width in
                if let item = viewModel.element(at: indexPath.item) as? MagazineItem, let cover = item.cover {
                    let height = max(1, cover.ht.nonnull)/max(1, cover.wt.nonnull)*Double(width)
                    return height
                }
                return width
            }
        }
        
        if let collectionView = collectionView {
            collectionView.removeFromSuperview()
            contentView.addSubview(collectionView)
        }
        
        collectionView?.register(cellWithClass: ImageCollectionCell.self)
        collectionView?.snp.makeConstraints({ make in
            make.top.equalTo(searchBack.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        })
    }
    
    @objc fileprivate func searchTap() {
        swipeToLeft()
        UIManager.push(to: MagazineSearchViewController())
    }
    
    @objc fileprivate func swipeToLeft() {
        if !view.isHidden {
            view.backgroundColor = .clear
            view.snp.updateConstraints { make in
                make.left.equalTo(-UIManager.shared.screenWidth)
            }
            
            UIView.animate(withDuration: 0.25) {
                self.view.superview?.layoutIfNeeded()
            } completion: { _ in
                self.view.isHidden = true
            }
        }
    }
    
    func swipeToRight() {
        if view.isHidden {
            view.isHidden = false
            view.backgroundColor = .clear
            view.snp.updateConstraints { make in
                make.left.equalTo(0)
            }
            
            UIView.animate(withDuration: 0.25) {
                self.view.superview?.layoutIfNeeded()
            } completion: { _ in
                self.view.backgroundColor = color(0, 0, 0, 0.6)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
        cell.contentView.backgroundColor = .clear
        if let item = viewModel?.element(at: indexPath.item) as? MagazineItem, let cover = item.cover {
            let width = MainLeftMenuViewController.viewWidth - 16*2
            let height = max(1, cover.ht.nonnull)/max(1, cover.wt.nonnull)*Double(width)
            cell.imageView.image = nil
            cell.imageView.setWebImage(url: OSSUploader.imageURLFor(cover.guid, crop: .medium), cornerRadius: 12*3.0, finalSize: CGSize(width: Double(width)*3.0, height: height*3.0))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = viewModel?.element(at: indexPath.item) as? MagazineItem {
            UIManager.push(to: MagazineDetailViewController().then { $0.magazineItem = item })
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view == view, gestureRecognizer is UITapGestureRecognizer {
            return gestureRecognizer.location(in: view).x > 289
        }
        return true
    }
    
    class InnerViewModel: NetworkViewModel {
        var innerPara: [String: Any]?
        override var parameters: [String : Any]? { innerPara }
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([MagazineItem].self, from: data)
                if isLoadingMore {
                    var list = [MagazineItem]()
                    for item in result {
                        if element(for: item.uniqueIdentifier) == nil {
                            list.append(item)
                        }
                    }
                    return list
                }
                return result
            } catch {
                assertionFailure(error.localizedDescription)
            }
            return nil
        }
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
