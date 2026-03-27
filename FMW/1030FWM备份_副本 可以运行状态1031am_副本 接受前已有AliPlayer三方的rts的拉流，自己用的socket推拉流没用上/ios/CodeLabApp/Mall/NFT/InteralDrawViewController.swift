//
//  InteralDrawViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/16.
//

import Foundation
import BasicUIKit
import APIKit
import APNGKit
import YYImage
import Alamofire

final class InteralDrawViewController: BaseViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private let topImageView = UIImageView()
    private let tipsLabel = UILabel()
    private let animateView = APNGImageView()
    private let resultView = NFTResultView()
    
    private var getNFTInfo: NFTInfo?
    var nftSeriesItem: NFTSeriesItem!
    
    deinit {
        animateView.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBar.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "数藏积分抽奖"
        customBackBtn.isHidden = false
        customBar.backgroundColor = .clear
        
        let bottomBtn = UIButton().then {
            $0.layer.cornerRadius = 12
            $0.backgroundColor = .black
            $0.setTitle("获取", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 16)
            $0.addAction(UIAction() {_ in
                HUD.show()
                Network.request(PointsAPI.userPoints, encoding: URLEncoding.default).responseData { response in
                    HUD.hide()
                    if let error = response.error {
                        Toast.toast(title: error.localizedDescription)
                    }
                    else {
                        let points = response.data?["points"] as? Int
                        if points.nonnull < self.nftSeriesItem.points.nonnull {
                            Toast.toast(title: "当前积分不足")
                            return
                        }
                        
                        Alert.show(title: "抽奖详情", message: "本次抽奖消耗\(self.nftSeriesItem.points.nonnull)积分，打开后将获取随机奖励之一", submitBtnTapHandler: {
                            self.animateView.isHidden = false
                            self.animateView.startAnimating()
                            Network.request(NFTAPI.pointsGetRandomNFT, parameters: ["seriesId": self.nftSeriesItem.id, "times": 1]).responseData { response in
                                if let error = response.error {
                                    try? self.animateView.reset()
                                    self.animateView.isHidden = true
                                    Toast.toast(title: error.localizedDescription)
                                } else if let result = response.data?["raffleResults"] as? [Any],
                                          let first = result.first as? [String: Any],
                                          let nftInfo = first["goods"] as? [String: Any],
                                          let data = nftInfo.jsonData(),
                                          let nftInfo = try? JSONDecoder().decode(NFTInfo.self, from: data)
                                {
                                    self.getNFTInfo = nftInfo
                                    if !self.animateView.isAnimating {
                                        self.showResult()
                                    }
                                }
                            }
                        })
                    }
                }
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(50)
                make.bottom.equalTo(UIManager.shared.isNotchScreen ? -42 : -8)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(240, 240, 240)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
                make.bottom.equalTo(bottomBtn.snp.top).offset(-8)
            }
        }
        
        let scrollView = UIScrollView().then {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            view.insertSubview($0, belowSubview: customBar)
            $0.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(bottomBtn.snp.top).offset(-20)
            }
        }
        
        let contentView = UIView().then {
            scrollView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.width.equalTo(view)
            }
        }
        
        topImageView.do {
            $0.image = UIImage(named: "lab_nft_points_background")
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(-40)
                make.left.right.equalToSuperview()
                make.height.equalTo(UIManager.shared.screenWidth + 40)
            }
        }
        
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.minimumLineSpacing = 8
            $0.minimumInteritemSpacing = 8
            $0.scrollDirection = .horizontal
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
            $0.backgroundColor = .white
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.delegate = self
            $0.dataSource = self
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.keyboardDismissMode = .onDrag
            $0.contentInsetAdjustmentBehavior = .never
            $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            $0.register(cellWithClass: ImageCollectionCell.self)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(topImageView.snp.bottom).offset(16)
                make.height.equalTo(88)
            }
        }
        
        let sectionLabel = UILabel().then {
            $0.text = "活动说明"
            $0.font = .mediumPingFangSCFont(ofSize: 18)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(collectionView.snp.bottom).offset(30)
                make.height.equalTo(25)
            }
        }
        
        tipsLabel.do {
            $0.text = nftSeriesItem.desc
            $0.font = .regularPingFangSCFont(ofSize: 12)
            $0.textColor = color(0, 0, 0, 0.5)
            $0.numberOfLines = 0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(sectionLabel.snp.bottom).offset(12)
                make.height.lessThanOrEqualTo(CGFloat.greatestFiniteMagnitude)
                make.bottom.equalTo(-50)
            }
        }
        
        animateView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.isHidden = true
            $0.autoStartAnimationWhenSetImage = false
            $0.onAllPlaysDone.delegate(on: self) {[unowned self] _,_ in
                if self.getNFTInfo != nil {
                    self.showResult()
                }
            }
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
            
            if let path = Bundle.main.path(forResource: "ge_nft_get_animate", ofType: "png"),
               let image = try? APNGImage(filePath: path) {
                image.numberOfPlays = 3
                image.onFramesInformationPrepared.delegate(on: self) { _,_ in
                    switch image.duration {
                    case .full(let duration):
                        print("动画时长 -- \(duration) -- \(image.numberOfFrames)")
                    default:break
                    }
                }
                $0.image = image
            }
        }
        
        resultView.do {
            $0.isHidden = true
            $0.submitBtn.addAction(UIAction() {[unowned self] _ in
                resultView.isHidden = true
                backBtnTapHandler()
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
    }
    
    fileprivate func showResult() {
        resultView.alpha = 0
        resultView.isHidden = false
        resultView.nftNameView.setTitle(getNFTInfo?.name ?? "HENRY未来已至", for: .normal)
        resultView.nftIconView.setWebImage(url: OSSUploader.imageNFTURLFor((getNFTInfo?.cover?.guid).nonnull, crop: .origin))
        animateView.stopAnimating()
        
        UIView.animate(withDuration: 0.3) {
            self.animateView.alpha = 0
            self.resultView.alpha = 1
        } completion: { _ in
            self.animateView.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (nftSeriesItem.nftList?.count).nonnull
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 88, height: 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ImageCollectionCell.self, for: indexPath)
        cell.contentView.backgroundColor = .white
        if let media = nftSeriesItem.nftList?[safe: indexPath.item]?.cover {
            cell.imageView.setWebImage(url: OSSUploader.imageNFTURLFor(media.guid, crop: .medium), cornerRadius: 14*3.0, finalSize: CGSize(width: 88*3.0, height: 88*3.0))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let info = nftSeriesItem.nftList?[safe: indexPath.item] {
            UIManager.present(modal: NFTInfoShowViewController().then {
                $0.nftInfo = info
                $0.modalPresentationStyle = .overFullScreen
            })
        }
    }
    
    fileprivate class ImageCollectionCell: UICollectionViewCell {
        fileprivate lazy var imageView = UIImageView().then {
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            imageView.cancelCurrentWebImageLoad()
            imageView.image = nil
        }
    }
}

fileprivate class NFTResultView: UIView {
    lazy var backView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
        $0.clipsToBounds = true
        $0.image = UIImage(named: "lab_nft_points_get_result_back")
        $0.backgroundColor = color(0, 0, 0, 0.6)
        addSubview($0)
        $0.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    lazy var titleView = UIImageView().then {
        $0.image = UIImage(named: "lab_nft_points_get_title")
        $0.contentMode = .scaleAspectFit
        backView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.top.equalTo(83)
            make.width.equalTo(210)
            make.height.equalTo(53)
            make.centerX.equalToSuperview()
        }
    }
    
    lazy var nftNameView = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16.0
        $0.setTitleColor(color(9, 69, 122), for: .normal)
        $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 18)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        backView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(UIManager.shared.screenWidth - 60)
            make.height.equalTo(32)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom).offset(11)
        }
    }
    
    lazy var submitBtn = UIButton().then {
        $0.setImage(UIImage(named: "lab_nft_points_get_result_submit"), for: .normal)
        backView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.width.equalTo(193)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(UIManager.shared.isNotchScreen ? -129 : -90)
        }
    }
    
    lazy var nftIconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        backView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.top.equalTo(nftNameView.snp.bottom).offset(30)
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.bottom.equalTo(submitBtn.snp.top).offset(-30)
        }
    }
}
