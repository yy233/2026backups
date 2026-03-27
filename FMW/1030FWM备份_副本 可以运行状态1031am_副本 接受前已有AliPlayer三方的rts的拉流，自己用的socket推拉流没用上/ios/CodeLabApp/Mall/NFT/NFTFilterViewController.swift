//
//  NFTFilterViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/11.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import APIKit
import Alamofire

struct NFTClassificationItem: Codable {
    var classificationId: String = ""
    var classificationName: String = ""
    
    enum CodingKeys: CodingKey {
        case classificationId
        case classificationName
    }
}

final class NFTFilterViewController: UIViewController {
    
    var didSelectTypeHandler: ((NFTClassificationItem) -> Void)?
    
    private let contentView = UIView()
    private var types = [NFTClassificationItem]()
    
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
            $0.layer.cornerRadius = 14
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(UIManager.shared.screenHeight - UIManager.shared.navBarHeight - 100)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(230, 230, 230)
            $0.layer.cornerRadius = 2.0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(24)
                make.width.equalTo(26)
                make.height.equalTo(4)
                make.centerX.equalToSuperview()
            }
        }
        
        let titleLabel = UILabel().then {
            $0.text = "品类"
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 16)
            $0.textAlignment = .center
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.width.lessThanOrEqualTo(100)
                make.top.equalTo(28)
                make.height.equalTo(22)
            }
        }
        
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.minimumLineSpacing = 8
            $0.minimumInteritemSpacing = 8
            $0.itemSize = CGSize(width: floor((UIManager.shared.screenWidth - 32 - 16)/3.0), height: 36)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
            $0.backgroundColor = .white
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.delegate = self
            $0.dataSource = self
            $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 60, right: 16)
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.register(cellWithClass: TypeCollectionCell.self)
            $0.keyboardDismissMode = .onDrag
            $0.contentInsetAdjustmentBehavior = .never
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(12)
                make.bottom.equalToSuperview()
            }
        }
        
        Network.request(NFTAPI.typeList, encoding: URLEncoding.default).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let list = response.data?["list"] as? [Any], let data = list.jsonString.data(using: .utf8),
                      let result = try? JSONDecoder().decode([NFTClassificationItem].self, from: data) {
                self.types.append(contentsOf: result)
                collectionView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = color(0, 0, 0, 0.5)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.backgroundColor = .clear
    }
    
    fileprivate class TypeCollectionCell: UICollectionViewCell {
        fileprivate lazy var backView = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 6.0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        fileprivate lazy var contentLabel = UILabel().then {
            $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            $0.textAlignment = .center
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
    }
}

extension NFTFilterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: TypeCollectionCell.self, for: indexPath)
        cell.contentLabel.text = types[indexPath.item].classificationName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectTypeHandler?(types[indexPath.item])
        dismiss(animated: true)
    }
}
