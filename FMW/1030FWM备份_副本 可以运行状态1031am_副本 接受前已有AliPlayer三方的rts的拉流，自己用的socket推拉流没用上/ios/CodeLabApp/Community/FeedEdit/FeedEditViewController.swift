//
//  FeedEditViewController.swift
//  Genz
//
//  Created by Sera on 2021/5/21.
//

import Foundation
import Combine
import BasicUIKit
import BasicKit
import UIKit
import AlbumUIKit
import PhotosUI
import APIKit
import VideoToolbox

final class FeedEditViewController: BaseViewController {

    var didSubmitHandler: ((FeedEditItem) -> Void)?
    fileprivate var editFeedItem: FeedEditItem
    private var exportSession: AssetExportSession?

    required init(editItem: FeedEditItem) {
        editFeedItem = editItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationControlEnable = true
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "发布"
        setupView()
        
        communitySelectTipsBtn.setTitle(editFeedItem.communityitem?.name ?? "请选择社区", for: .normal)
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
        $0.setTitle("发布", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.mediumPingFangSCFont(ofSize: 16)
        $0.addTarget(self, action: #selector(submitBtnTapHandler), for: .touchUpInside)
    }
    
//    fileprivate lazy var draftBtn = UIButton().then {
//        $0.setImage(UIImage(named: "ge_feed_edit_draft"), for: .normal)
//        $0.imageView?.contentMode = .scaleAspectFit
//        $0.addTarget(self, action: #selector(draftBtnTapHandler), for: .touchUpInside)
//    }
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.itemSize = CGSize(width: 158, height: 158)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.clipsToBounds = false
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(cellWithClass: FeedEditPhotoCollectionCell.self)
        collectionView.register(cellWithClass: FeedEditPhotoAddCollectionCell.self)
        return collectionView
    }()
        
    fileprivate lazy var textView = RSKPlaceholderTextView().then {
        $0.backgroundColor = .white
        $0.textContainerInset = .zero
        $0.font = UIFont.regularPingFangSCFont(ofSize: 16)
        $0.textColor = .black
        $0.placeholder = "添加正文"
        $0.placeholderColor = color(0, 0, 0, 0.3)
        $0.textAlignment = .left
        $0.keyboardType = .default
        $0.delegate = self
    }
    
    fileprivate lazy var topicBtn = FeedEditLocationButton().then {
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0)
        $0.setImage(UIImage(named: "ge_feed_edit_tag_tips"), for: .normal)
        $0.setTitle("添加标签", for: .normal)
        $0.setTitleColor(color(0, 0, 0, 0.6), for: .normal)
        $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
        $0.addTarget(self, action: #selector(topicSelectBtnTapHandler), for: .touchUpInside)
    }
    
    fileprivate lazy var topicSelectTipsBtn = UIButton().then {
        $0.setTitle("请选择标签", for: .normal)
        $0.setTitleColor(color(0, 0, 0, 0.3), for: .normal)
        $0.titleLabel?.font = UIFont.regularPingFangSCFont(ofSize: 14)
        $0.addTarget(self, action: #selector(topicSelectBtnTapHandler), for: .touchUpInside)
    }
    
    fileprivate lazy var topicArrowView = UIImageView().then {
        $0.image = UIImage(named: "ge_base_arrow_right_gray")
        $0.contentMode = .scaleAspectFit
    }
    
    fileprivate lazy var locationBtn = FeedEditLocationButton().then {
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0)
        $0.setImage(UIImage(named: "ge_feed_edit_location_tips"), for: .normal)
        $0.setTitle("所在位置", for: .normal)
        $0.setTitleColor(color(0, 0, 0, 0.6), for: .normal)
        $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
        $0.addTarget(self, action: #selector(locationSelectBtnTapHandler), for: .touchUpInside)
    }
    
    fileprivate lazy var locationSelectTipsBtn = UIButton().then {
        $0.setTitle("请选择位置", for: .normal)
        $0.setTitleColor(color(0, 0, 0, 0.3), for: .normal)
        $0.titleLabel?.font = UIFont.regularPingFangSCFont(ofSize: 14)
        $0.addTarget(self, action: #selector(locationSelectBtnTapHandler), for: .touchUpInside)
    }
    
    fileprivate lazy var locationArrowView = UIImageView().then {
        $0.image = UIImage(named: "ge_base_arrow_right_gray")
        $0.contentMode = .scaleAspectFit
    }
    
    fileprivate lazy var communityBtn = FeedEditLocationButton().then {
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0)
        $0.setImage(UIImage(named: "ge_feed_edit_community"), for: .normal)
        $0.setTitle("添加社区", for: .normal)
        $0.setTitleColor(color(0, 0, 0, 0.6), for: .normal)
        $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
        $0.addTarget(self, action: #selector(communitySelectBtnTapHandler), for: .touchUpInside)
    }
    
    fileprivate lazy var communitySelectTipsBtn = UIButton().then {
        $0.setTitle("请选择社区", for: .normal)
        $0.setTitleColor(color(0, 0, 0, 0.3), for: .normal)
        $0.titleLabel?.font = UIFont.regularPingFangSCFont(ofSize: 14)
        $0.addTarget(self, action: #selector(communitySelectBtnTapHandler), for: .touchUpInside)
    }
    
    fileprivate lazy var communityArrowView = UIImageView().then {
        $0.image = UIImage(named: "ge_base_arrow_right_gray")
        $0.contentMode = .scaleAspectFit
    }
}

//MARK: - View
extension FeedEditViewController {
    fileprivate func setupView() {
        let _ = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.02)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(10)
                make.top.equalTo(customBar.snp.bottom)
            }
        }
        
        view.addSubview(backView)
//        view.addSubview(draftBtn)
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
        
        contentView.addSubview(collectionView)
        contentView.insertSubview(textView, belowSubview: collectionView)

        collectionView.snp.makeConstraints { make in
            make.left.width.equalToSuperview()
            make.top.equalTo(6)
            make.height.equalTo(158)
        }
        
        textView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(collectionView.snp.bottom).offset(24)
            make.height.equalTo(160)
        }
        
        topicBtn.addSubview(topicSelectTipsBtn)
        topicBtn.addSubview(topicArrowView)
        contentView.addSubview(topicBtn)
        
        let _ = UIView().then {
            $0.backgroundColor = color(246, 248, 250)
            topicBtn.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(0.5)
                make.bottom.equalToSuperview()
            }
        }
        
        topicBtn.snp.makeConstraints { make in
            make.left.width.equalToSuperview()
            make.top.equalTo(textView.snp.bottom).offset(20)
            make.height.equalTo(52)
        }
        
        topicSelectTipsBtn.snp.makeConstraints { make in
            make.right.equalTo(topicArrowView.snp.left)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.lessThanOrEqualTo(100)
        }
        
        topicArrowView.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        locationBtn.addSubview(locationSelectTipsBtn)
        locationBtn.addSubview(locationArrowView)
        contentView.addSubview(locationBtn)
        
        let _ = UIView().then {
            $0.backgroundColor = color(246, 248, 250)
            locationBtn.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(0.5)
                make.bottom.equalToSuperview()
            }
        }
        
        locationBtn.snp.makeConstraints { make in
            make.left.width.equalToSuperview()
            make.top.equalTo(topicBtn.snp.bottom)
            make.height.equalTo(52)
        }
        
        locationSelectTipsBtn.snp.makeConstraints { make in
            make.right.equalTo(locationArrowView.snp.left)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(100)
        }
        
        locationArrowView.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        communityBtn.addSubview(communitySelectTipsBtn)
        communityBtn.addSubview(communityArrowView)
        contentView.addSubview(communityBtn)
        
        let _ = UIView().then {
            $0.backgroundColor = color(246, 248, 250)
            communityBtn.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(0.5)
                make.bottom.equalToSuperview()
            }
        }
        
        communityBtn.snp.makeConstraints { make in
            make.left.width.equalToSuperview()
            make.top.equalTo(locationBtn.snp.bottom)
            make.height.equalTo(52)
            make.bottom.equalTo(-20)
        }
        
        communitySelectTipsBtn.snp.makeConstraints { make in
            make.right.equalTo(communityArrowView.snp.left)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(100)
        }
        
        communityArrowView.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        submitBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-55)
            make.right.equalTo(-16)
            make.height.equalTo(44)
            make.left.equalTo(16)
        }

//        draftBtn.snp.makeConstraints { make in
//            make.left.equalTo(16)
//            make.centerY.equalTo(submitBtn)
//            make.width.equalTo(30)
//            make.height.equalTo(42)
//        }
        
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

//MARK: - Event
extension FeedEditViewController {
    @objc fileprivate func submitBtnTapHandler() {
        view.endEditing(true)
        
        if editFeedItem.elements.isEmpty {
            Toast.toast(title: "请选择图片或视频")
            return
        }

        HUD.show()
        if editFeedItem.elements.count == editFeedItem.uploadedMedias.count {
            submitFeed()
        } else if let editItem = editFeedItem.elements.first, editItem.elementType == .video {
            let name = "iOS_\(Date().timeIntervalSince1970)-\(arc4random())-0".md5
            editItem.fetchElementVideo(saveToAlbum: false) { asset, image,_ in
                if let asset = asset as? AVURLAsset, let info = MediaPublishUtilities.videoInfo(from: asset.url) {
                    let filePath = NSTemporaryDirectory().appendingPathComponent("\(name).mp4")
                    let videoSize = AVMakeRect(aspectRatio: CGSize(width: info.width, height: info.height), insideRect: CGRect(x: 0, y: 0, width: 1920, height: 1920)).size
                    let configuration = AssetExportSession.Configuration(fileType: .mp4, videoSettings: .h264(videoSize: videoSize, averageBitRate: 2000_000), audioSettings: .aac(channels: 1, sampleRate: 48_000, bitRate: 128_000))
                    self.exportSession = try? AssetExportSession(asset: asset, outputURL: URL(fileURLWithPath: filePath), configuration: configuration)
                    self.exportSession?.export(progress: nil, completion: { error in
                        if let _ = error {
                            HUD.hide()
                            Toast.toast(title: "视频转码失败")
                        } else {
                            let object = OSSUploader.videoFolder + name + ".mp4"
                            OSSUploader.uploadFile(path: filePath, name: object) { _ in
                                
                            } completion: { error in
                                if let _ = error {
                                    HUD.hide()
                                    Toast.toast(title: "视频上传失败")
                                } else if let image = image, let data = image.jpegData(compressionQuality: 1.0) {
                                    let object = OSSUploader.imageFolder + name + ".jpg"
                                    OSSUploader.uploadData(data: data, name: object) { _ in
                                        
                                    } completion: { error in
                                        if let _ = error {
                                            HUD.hide()
                                            Toast.toast(title: "图片上传失败")
                                        } else {
                                            let element = FeedItem.ImageElement()
                                            element.ext = "mp4"
                                            element.ht = Double(info.height)
                                            element.wt = Double(info.width)
                                            element.guid = name
                                            element.duration = info.duration*1000
                                            self.editFeedItem.uploadedMedias.append(element)
                                            self.submitFeed()
                                            self.exportSession = nil
                                        }
                                    }
                                } else {
                                    HUD.hide()
                                    Toast.toast(title: "视频封面获取失败")
                                }
                            }
                        }
                    })
                } else {
                    HUD.hide()
                    Toast.toast(title: "视频获取失败")
                }
            }
        } else {
            DispatchQueue.global().async {
                let semaphore = DispatchSemaphore(value: 0)
                
                var keep = true
                
                for i in self.editFeedItem.uploadedMedias.count..<self.editFeedItem.elements.count {
                    if !keep { return }
                    let editItem = self.editFeedItem.elements[i]
                    let name = "iOS_\(Date().timeIntervalSince1970)-\(arc4random())-\(i)".md5

                    editItem.fetchElementImage(isBig: true, saveToAlbum: false, isSynchrouns: false) { image,_ in
                        if let image = image, let data = image.jpegData(compressionQuality: 1.0) {
                            let object = OSSUploader.imageFolder + name + ".jpg"
                            OSSUploader.uploadData(data: data, name: object) { _ in
                                
                            } completion: { error in
                                if let _ = error {
                                    HUD.hide()
                                    Toast.toast(title: "图片上传失败")
                                    keep = false
                                } else {
                                    let element = FeedItem.ImageElement()
                                    element.ext = "jpg"
                                    element.ht = image.size.height*image.scale
                                    element.wt = image.size.width*image.scale
                                    element.guid = name
                                    self.editFeedItem.uploadedMedias.append(element)
                                }
                                semaphore.signal()
                            }
                        } else {
                            HUD.hide()
                            Toast.toast(title: "图片获取失败")
                            keep = false
                            semaphore.signal()
                        }
                    }
                    semaphore.wait()
                }
                
                if self.editFeedItem.uploadedMedias.count == self.editFeedItem.elements.count {
                    self.submitFeed()
                }
            }
        }
    }
    
    private func submitFeed() {
        let jsonEncoder = JSONEncoder()
        var para: [String: Any] = ["desc": editFeedItem.content.nonnull,
                                   "isNotice": editFeedItem.isCommunityBroadcast ? 1 : 0]
        
        if let data = try? jsonEncoder.encode(editFeedItem.uploadedMedias),
            let dic = data.jsonArray {
            para["images"] = dic
        }
        
        if let location = editFeedItem.location,
           let data = try? jsonEncoder.encode(location),
            let dic = data.jsonDictionary {
            para["poi"] = dic
        }
        
        if let topic = editFeedItem.tagItem,
           let data = try? jsonEncoder.encode([topic]),
            let dic = data.jsonArray {
            para["labels"] = dic
        }
        
        if let community = editFeedItem.communityitem,
           let data = try? jsonEncoder.encode(community),
            let dic = data.jsonDictionary {
            para["community"] = dic
        }
        
        Network.request(FeedAPI.feedPublish, parameters: para).responseData { response in
            HUD.hide()
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let data = response.data?.jsonData(), let feed = try? JSONDecoder().decode(FeedItem.self, from: data) {
                Toast.toast(title: "发布成功")
                if self.editFeedItem.isCommunityBroadcast {
                    NotificationCenter.default.post(name: .notificationCommunityFeedDidUpdateStatus, object: self.editFeedItem.communityitem)
                    NotificationCenter.default.post(name: .notificationCommunityBroadcastFeedDidPublish, object: feed)
                } else {
                    NotificationCenter.default.post(name: .notificationFeedDidPublish, object: feed)
                }
                
                self.backBtnTapHandler()
            }
        }
    }
    
    @objc fileprivate func topicSelectBtnTapHandler() {
        view.endEditing(true)
        
        let topicSearchVC = FeedEditTagSearchViewController()
        topicSearchVC.modalPresentationStyle = .overFullScreen
        topicSearchVC.didSelectHandler = {[unowned self] topicItem in
            topicSelectTipsBtn.setTitle("#\((topicItem?.name).nonnull)", for: .normal)
            editFeedItem.tagItem = topicItem
        }
        UIManager.present(modal: topicSearchVC)
    }
    
    @objc fileprivate func locationSelectBtnTapHandler() {
        view.endEditing(true)
        
        let searchVC = FeedEditLocationSearchViewController()
        searchVC.modalPresentationStyle = .overFullScreen
        searchVC.didSelectHandler = {[unowned self] locationItem in
            locationSelectTipsBtn.setTitle(locationItem?.name, for: .normal)
            editFeedItem.location = locationItem
        }
        UIManager.present(modal: searchVC)
    }
    
    @objc fileprivate func communitySelectBtnTapHandler() {
        view.endEditing(true)
        
        let searchVC = FeedEditCommunitySearchViewController()
        searchVC.modalPresentationStyle = .overFullScreen
        searchVC.didSelectHandler = {[unowned self] communityItem in
            communitySelectTipsBtn.setTitle(communityItem?.name, for: .normal)
            editFeedItem.communityitem = communityItem
        }
        UIManager.present(modal: searchVC, containNavigation: true)
    }
    
//    @objc fileprivate func draftBtnTapHandler() {
//        backBtnTapHandler()
//    }
}

extension FeedEditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.isEmpty {
            return true
        }
        
        if text.utf16.count + textView.text.utf16.count > 1000 {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        editFeedItem.content = textView.text
    }
}

//MARK: - UICollectionView
extension FeedEditViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let element = editFeedItem.elements.first, element.elementType == .video || element.elementType == .gif || element.elementType == .livephoto {
            return editFeedItem.elements.count
        }
        else if editFeedItem.elements.count >= 9 {
            return editFeedItem.elements.count
        }
        else {
            return editFeedItem.elements.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == editFeedItem.elements.count {
            let cell = collectionView.dequeueReusableCell(withClass: FeedEditPhotoAddCollectionCell.self, for: indexPath)
            cell.contentView.backgroundColor = .white
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withClass: FeedEditPhotoCollectionCell.self, for: indexPath)
        cell.bindModel(editFeedItem.elements[indexPath.item])
        cell.contentView.backgroundColor = .white
        cell.cancelSelectHandler = {[unowned self, unowned cell, unowned collectionView] in
            guard let indexPath = collectionView.indexPath(for: cell) else { return }
            editFeedItem.elements.remove(at: indexPath.item)
            collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == editFeedItem.elements.count { //新增图片
            ActionSheet.show(titles: ["相册", "相机"]) {[unowned self] index in
                if index == 0 {
                    let assetsVC = AssetsListViewController()
                    assetsVC.maxSelectCount = 9 - editFeedItem.elements.count
                    assetsVC.minSelectCount = 1
                    assetsVC.type = editFeedItem.elements.first?.elementType == .photo ? .photo : .all
                    assetsVC.didSubmitHandler = {[unowned self, unowned assetsVC] assets in
                        if let asset = assets.first, asset.elementType == .video {
                            editFeedItem.elements.removeAll()
                            editFeedItem.elements.append(contentsOf: assets)
                        } else {
                            editFeedItem.elements.append(contentsOf: assets)
                        }
                        collectionView.reloadData()
                        assetsVC.dismiss(animated: true)
                    }
                    UIManager.present(modal: assetsVC)
                } else if index == 1 {
                    let picker = QuickMediaPicker(presenter: self, sourceType: .camera)
                    
                    if editFeedItem.elements.first?.elementType == .photo {
                        picker.pickImage {[unowned self] data, _ in
                            if let image = UIImage(data: data) {
                                let item = CaptureImageItem(image: image)
                                editFeedItem.elements.append(item)
                                collectionView.reloadData()
                            }
                        } cancellation: { _ in
                            
                        }
                    } else {
                        picker.pickMedia {[unowned self] media,_ in
                            switch media {
                            case .image(let data):
                                if let image = UIImage(data: data) {
                                    let item = CaptureImageItem(image: image)
                                    editFeedItem.elements.append(item)
                                    collectionView.reloadData()
                                }
                            case .video(let url):
                                let item = CaptureVideoItem(url: url)
                                editFeedItem.elements.removeAll()
                                editFeedItem.elements.append(item)
                                collectionView.reloadData()
                            }
                        } cancellation: { _ in
                            
                        }
                    }
                }
            }
        }
        else {
            guard let _ = editFeedItem.elements[safe: indexPath.item] else { return }
            
            ActionSheet.show(titles: ["删除"]) {[unowned self] index in
                editFeedItem.elements.remove(at: indexPath.item)
                collectionView.reloadData()
            }
        }
    }
}
