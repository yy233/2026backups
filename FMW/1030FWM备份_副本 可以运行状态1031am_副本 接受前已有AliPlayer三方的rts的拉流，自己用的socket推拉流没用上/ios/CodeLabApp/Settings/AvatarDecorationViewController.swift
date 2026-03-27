//
//  AvatarDecorationViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/19.
//

import Foundation
import BasicKit
import BasicUIKit
import YYImage
import CodeLabUnityBridge

final class AvatarDecorationViewController: BaseViewController {
    
    var backBtnDidTap: PureCompletionHandler?
    var userID: String?

    fileprivate enum Segment: String {
        case head = "头部"
        case face = "面部"
        case makeup = "妆容"
        case hair = "发型"
        case bothCloth = "套装"
        case topCloth = "上装"
        case bottomCloth = "下装"
        case mood = "心情"
    }
    
    fileprivate static let segments: [Segment] = [.head, .face, .makeup, .hair, .bothCloth, .topCloth, .bottomCloth, .mood]
    
    fileprivate let contentView = UIView()
    fileprivate let segmentScrollView = UIScrollView()
    fileprivate let tabPinchBtn = UIButton()
    fileprivate let tabMakeUpBtn = UIButton()
    fileprivate let tabMoodBtn = UIButton()
    
    fileprivate var topSelectIndex: Int?
    fileprivate var bottomSelectIndex: Int?
    
    fileprivate var collectionView: UICollectionView?
    fileprivate var selectBtn: UIButton?
    fileprivate var selectSegment: Segment = .head {
        didSet {
            if selectSegment != oldValue {
                collectionView?.reloadData()
            }
        }
    }
    
    override func backBtnTapHandler() {
        backBtnDidTap?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        view.backgroundColor = .clear
        customBar.backgroundColor = .clear
        view.backgroundColor = .clear
        
        contentView.do {
            $0.isHidden = userID != AppContext.current.userID
            $0.backgroundColor = .white
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(UIManager.shared.screenHeight > 800 ? 474 : 300)
            }
        }
        
        segmentScrollView.do {
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .white
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(50)
            }
        }
        
        let segmentContentView = UIView().then {
            $0.backgroundColor = .white
            segmentScrollView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(50)
            }
        }
        
        var leftBtn: UIButton?
        var btnList = [UIButton]()
        for text in AvatarDecorationViewController.segments {
            let btn = UIButton().then {
                $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
                $0.setTitle(text.rawValue, for: .normal)
                $0.setTitleColor(color(177, 180, 195), for: .normal)
                $0.setTitleColor(.black, for: .selected)
                $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 16)
                $0.addTarget(self, action: #selector(segmentBtnTapHandler(button:)), for: .touchUpInside)
                segmentContentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.equalTo(32)
                    make.height.equalTo(22)
                    make.top.equalTo(16)
                    
                    if let leftBtn = leftBtn {
                        make.left.equalTo(leftBtn.snp.right).offset(36)
                    } else {
                        make.left.equalTo(32)
                    }
                    
                    if text == AvatarDecorationViewController.segments.last {
                        make.right.equalTo(-32)
                    }
                }
            }
            
            leftBtn = btn
            btnList.append(btn)
            
            if selectBtn == nil {
                selectBtn = btn
                selectBtn?.isSelected = true
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(216, 216, 216)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(segmentScrollView)
                make.height.equalTo(0.5)
            }
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 6
        flowLayout.minimumInteritemSpacing = 6
        flowLayout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout).then {
            $0.backgroundColor = .white
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.delegate = self
            $0.dataSource = self
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 100, right: 16)
            $0.register(cellWithClass: ImageCollectionCell.self)
            $0.register(cellWithClass: MoodCollectionCell.self)
            $0.register(cellWithClass: ColorCollectionCell.self)
            $0.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: HeaderTitleView.self)
            $0.register(supplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withClass: UICollectionReusableView.self)
            $0.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: UICollectionReusableView.self)
            $0.contentInsetAdjustmentBehavior = .never
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(segmentScrollView.snp.bottom).offset(15)
            }
        }
        
        let tabBar = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 23.0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(244)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(-34)
                make.height.equalTo(46)
            }
        }
        
        tabPinchBtn.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 20
            $0.setTitle("捏脸", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
            $0.addAction(UIAction() {[unowned self] _ in
                tabPinchBtn.backgroundColor = .black
                tabPinchBtn.setTitleColor(.white, for: .normal)
                tabMakeUpBtn.backgroundColor = .clear
                tabMakeUpBtn.setTitleColor(.black, for: .normal)
                tabMoodBtn.backgroundColor = .clear
                tabMoodBtn.setTitleColor(.black, for: .normal)
                
                if ![Segment.head, .face, .makeup, .hair].contains(selectSegment), let btn = btnList.first(where: { $0.currentTitle.nonnull == Segment.head.rawValue }), !btn.isSelected {
                    segmentBtnTapHandler(button: btn)
                }
            }, for: .touchUpInside)
            tabBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(3)
                make.width.equalTo(79)
                make.height.equalTo(40)
                make.centerY.equalToSuperview()
            }
        }
        
        tabMakeUpBtn.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 20
            $0.setTitle("造型", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
            $0.addAction(UIAction() {[unowned self] _ in
                tabPinchBtn.backgroundColor = .clear
                tabPinchBtn.setTitleColor(.black, for: .normal)
                tabMakeUpBtn.backgroundColor = .black
                tabMakeUpBtn.setTitleColor(.white, for: .normal)
                tabMoodBtn.backgroundColor = .clear
                tabMoodBtn.setTitleColor(.black, for: .normal)

                if ![Segment.bothCloth, .bottomCloth, .topCloth].contains(selectSegment), let btn = btnList.first(where: { $0.currentTitle.nonnull == Segment.bothCloth.rawValue }), !btn.isSelected {
                    segmentBtnTapHandler(button: btn)
                }
            }, for: .touchUpInside)
            tabBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(79)
                make.height.equalTo(40)
                make.centerY.equalToSuperview()
            }
        }
        
        tabMoodBtn.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 20
            $0.setTitle("心情", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
            $0.addAction(UIAction() {[unowned self] _ in
                tabPinchBtn.backgroundColor = .clear
                tabPinchBtn.setTitleColor(.black, for: .normal)
                tabMakeUpBtn.backgroundColor = .clear
                tabMakeUpBtn.setTitleColor(.black, for: .normal)
                tabMoodBtn.backgroundColor = .black
                tabMoodBtn.setTitleColor(.white, for: .normal)
                
                if selectSegment != .mood, let btn = btnList.first(where: { $0.currentTitle.nonnull == Segment.mood.rawValue }) {
                    segmentBtnTapHandler(button: btn)
                }
            }, for: .touchUpInside)
            tabBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-3)
                make.width.equalTo(79)
                make.height.equalTo(40)
                make.centerY.equalToSuperview()
            }
        }
    }
    
    @objc fileprivate func dismissBtnTap() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func segmentBtnTapHandler(button: UIButton) {
        selectBtn?.isSelected = false
        button.isSelected = true
        selectBtn = button
        selectSegment = Segment(rawValue: button.currentTitle.nonnull) ?? .head
        
        let converFrame = button.superview?.convert(button.frame, to: view) ?? .zero
        if converFrame.minX < 0 {
            segmentScrollView.setContentOffset(CGPoint(x: button.left - 16, y: 0), animated: true)
        } else if converFrame.maxX > view.width {
            segmentScrollView.setContentOffset(CGPoint(x: button.right - segmentScrollView.width + 16, y: 0), animated: true)
        }
        
        switch selectSegment {
        case .head, .face, .makeup, .hair:
            tabPinchBtn.sendActions(for: .touchUpInside)
        case .bothCloth, .topCloth, .bottomCloth:
            tabMakeUpBtn.sendActions(for: .touchUpInside)
        case .mood:
            tabMoodBtn.sendActions(for: .touchUpInside)
        }
    }
}

extension AvatarDecorationViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return selectSegment == .face || selectSegment == .makeup || selectSegment == .hair ? 2 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch selectSegment {
        case .head:
            return 9
        case .face:
            return section == 0 ? 7 : 9
        case .makeup:
            return section == 0 ? 7 : 9
        case .hair:
            return section == 0 ? 7 : 9
        case .bothCloth:
            return 9
        case .topCloth:
            return 9
        case .bottomCloth:
            return 9
        case .mood:
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = floor((UIManager.shared.screenWidth - 16*2 - 6*2)/3.0)
        let colorSize = floor((UIManager.shared.screenWidth - 16*2 - 6*6)/7.0)
        
        switch selectSegment {
        case .head:
            return CGSize(width: size, height: size)
        case .face:
            if indexPath.section == 0 {
                return CGSize(width: colorSize, height: colorSize)
            }
            
            return CGSize(width: size, height: size)
        case .makeup:
            if indexPath.section == 0 {
                return CGSize(width: colorSize, height: colorSize)
            }
            
            return CGSize(width: size, height: size)
        case .hair:
            if indexPath.section == 0 {
                return CGSize(width: colorSize, height: colorSize)
            }
            
            return CGSize(width: size, height: size)
        case .bothCloth:
            return CGSize(width: size, height: size)
        case .topCloth:
            return CGSize(width: size, height: size)
        case .bottomCloth:
            return CGSize(width: size, height: size)
        case .mood:
            return CGSize(width: size, height: size)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch selectSegment {
        case .face, .makeup, .hair:
            if section == 0 {
                return CGSize(width: UIManager.shared.screenWidth, height: 33)
            } else if selectSegment == .makeup {
                return CGSize(width: UIManager.shared.screenWidth, height: 21)
            }
            
            return CGSize(width: UIManager.shared.screenWidth, height: 56)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            switch selectSegment {
            case .face, .makeup, .hair:
                if indexPath.section == 0 {
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: HeaderTitleView.self, for: indexPath)
                    header.backgroundColor = .white
                    if selectSegment == .face {
                        header.textLabel.text = "肤色"
                    } else if selectSegment == .makeup {
                        header.textLabel.text = "唇妆"
                    } else if selectSegment == .hair {
                        header.textLabel.text = "发色"
                    }
                    return header
                } else if selectSegment == .makeup {
                    return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: UICollectionReusableView.self, for: indexPath)
                }
                
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: HeaderTitleView.self, for: indexPath)
                header.backgroundColor = .white
                if selectSegment == .face {
                    header.textLabel.text = "脸型"
                } else if selectSegment == .hair {
                    header.textLabel.text = "发型"
                }
                return header
            default:
                break
            }
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: UICollectionReusableView.self, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch selectSegment {
        case .head:
            let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
            cell.contentView.backgroundColor = .white
            cell.imageView.image = UIImage(named: "lab_unity_head")
            cell.selectView.isHidden = indexPath.item != topSelectIndex
            cell.imageView.snp.remakeConstraints { make in
                make.edges.equalTo(UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0))
            }
            return cell
        case .face:
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withClass: ColorCollectionCell.self, for: indexPath)
                cell.contentView.backgroundColor = .white
                cell.backView.backgroundColor = color(246, 201, 178)
                cell.selectView.isHidden = indexPath.item != topSelectIndex
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
            cell.contentView.backgroundColor = .white
            cell.imageView.image = UIImage(named: "lab_unity_face")
            cell.selectView.isHidden = indexPath.item != bottomSelectIndex
            cell.imageView.snp.remakeConstraints { make in
                make.edges.equalTo(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            }
            return cell
        case .makeup:
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withClass: ColorCollectionCell.self, for: indexPath)
                cell.contentView.backgroundColor = .white
                cell.backView.backgroundColor = color(175, 115, 89)
                cell.selectView.isHidden = indexPath.item != topSelectIndex
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
            cell.contentView.backgroundColor = .white
            cell.imageView.image = UIImage(named: "lab_unity_makeup")
            cell.selectView.isHidden = indexPath.item != bottomSelectIndex
            cell.imageView.snp.remakeConstraints { make in
                make.edges.equalTo(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            }
            return cell
        case .hair:
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withClass: ColorCollectionCell.self, for: indexPath)
                cell.contentView.backgroundColor = .white
                cell.backView.backgroundColor = color(93, 66, 49)
                cell.selectView.isHidden = indexPath.item != topSelectIndex
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
            cell.contentView.backgroundColor = .white
            cell.imageView.image = UIImage(named: "lab_unity_face")
            cell.selectView.isHidden = indexPath.item != bottomSelectIndex
            return cell
        case .bothCloth:
            let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
            cell.contentView.backgroundColor = .white
            cell.imageView.image = YYImage(named: "ge_icon_brand_detail_item_8")
            cell.selectView.isHidden = indexPath.item != topSelectIndex
            return cell
        case .topCloth:
            let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
            cell.contentView.backgroundColor = .white
            cell.imageView.image = YYImage(named: "ge_icon_brand_detail_item_6")
            cell.selectView.isHidden = indexPath.item != topSelectIndex
            return cell
        case .bottomCloth:
            let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
            cell.contentView.backgroundColor = .white
            cell.imageView.image = YYImage(named: "ge_icon_brand_detail_item_2")
            cell.selectView.isHidden = indexPath.item != topSelectIndex
            return cell
        case .mood:
            let cell = collectionView.dequeueReusableCell(withClass: MoodCollectionCell.self, for: indexPath)
            cell.contentView.backgroundColor = .white
            cell.imageView.image = UIImage(named: "ge_icon_brand_rank_avatar_1")
            cell.textLabel.text = "开心中"
            cell.selectView.isHidden = indexPath.item != topSelectIndex
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch selectSegment {
        case .head:
            topSelectIndex = indexPath.item
            collectionView.reloadData()
            CodeLabUnityInstance.sendMessage(UnityHairMessage())
        case .face:
            if indexPath.section == 0 {
                topSelectIndex = indexPath.item
                collectionView.reloadData()
                CodeLabUnityInstance.sendMessage(UnityHairMessage())
                break
            }
            
            bottomSelectIndex = indexPath.item
            collectionView.reloadData()
            CodeLabUnityInstance.sendMessage(UnityHairMeshMessage())
        case .makeup:
            if indexPath.section == 0 {
                topSelectIndex = indexPath.item
                collectionView.reloadData()
                CodeLabUnityInstance.sendMessage(UnityHairMessage())
                break
            }
            
            bottomSelectIndex = indexPath.item
            collectionView.reloadData()
            CodeLabUnityInstance.sendMessage(UnityHairMeshMessage())
        case .hair:
            if indexPath.section == 0 {
                topSelectIndex = indexPath.item
                collectionView.reloadData()
                CodeLabUnityInstance.sendMessage(UnityHairMessage())
                break
            }
            
            bottomSelectIndex = indexPath.item
            collectionView.reloadData()
            CodeLabUnityInstance.sendMessage(UnityHairMeshMessage())
        case .bothCloth:
            topSelectIndex = indexPath.item
            collectionView.reloadData()
            CodeLabUnityInstance.sendMessage(UnityDressMessage())
        case .topCloth:
            topSelectIndex = indexPath.item
            collectionView.reloadData()
            CodeLabUnityInstance.sendMessage(UnityDressMessage())
        case .bottomCloth:
            topSelectIndex = indexPath.item
            collectionView.reloadData()
            CodeLabUnityInstance.sendMessage(UnityDressMessage())
        case .mood:
            topSelectIndex = indexPath.item
            collectionView.reloadData()
            CodeLabUnityInstance.sendMessage(UnityDressMessage())
        }
    }
    
    fileprivate class ColorCollectionCell: UICollectionViewCell {
        lazy var backView = UIView().then {
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
            }
        }
        
        lazy var selectView = UIView().then {
            $0.backgroundColor = .clear
            $0.layer.borderColor = color(0, 0, 0, 0.3).cgColor
            $0.layer.borderWidth = 2.0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            backView.layer.cornerRadius = (width - 6)/2.0
            selectView.layer.cornerRadius = width/2.0
        }
    }
    
    fileprivate class ImageCollectionCell: UICollectionViewCell {
        lazy var backView = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 12.0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
            }
        }
        
        lazy var imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            }
        }
        
        lazy var selectView = UIView().then {
            $0.layer.cornerRadius = 14.0
            $0.backgroundColor = .clear
            $0.layer.borderColor = color(0, 0, 0, 0.3).cgColor
            $0.layer.borderWidth = 2.0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
    }
    
    fileprivate class MoodCollectionCell: UICollectionViewCell {
        lazy var backView = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 12.0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
            }
        }
        
        lazy var imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.bottom.equalTo(textLabel.snp.top).offset(-10)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(40)
            }
        }
        
        lazy var textLabel = UILabel().then {
            $0.font = .semiboldPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            $0.textAlignment = .center
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(20)
                make.bottom.equalTo(-19)
            }
        }
        
        lazy var selectView = UIView().then {
            $0.layer.cornerRadius = 14.0
            $0.backgroundColor = .clear
            $0.layer.borderColor = color(0, 0, 0, 0.3).cgColor
            $0.layer.borderWidth = 2.0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
    }
    
    fileprivate class HeaderTitleView: UICollectionReusableView {
        lazy var textLabel = UILabel().then {
            $0.font = .semiboldPingFangSCFont(ofSize: 16)
            $0.textColor = color(177, 180, 195)
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(22)
                make.bottom.equalTo(-11)
            }
        }
    }
}
