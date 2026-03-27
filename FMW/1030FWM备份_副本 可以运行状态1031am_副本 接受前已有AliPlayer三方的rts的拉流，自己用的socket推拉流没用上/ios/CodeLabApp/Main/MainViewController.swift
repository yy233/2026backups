//
//  SegmentDemoViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2022/10/27.
//

import Foundation
import BasicUIKit
import UIKit
import SnapKit
import PageControls
import YYImage
import VideoPlayerKit
import AVFoundation
import APIKit
import Alamofire

class MainViewController: TableViewController {
    
    fileprivate var userRanks = [UserRankItem]()
    fileprivate var nftRanks = [NFTRankItem]()
    fileprivate var nftMallList = [NFTMallViewController.InnerItem]()
    fileprivate var recommendCommunitys = [RecommendFeedChildCommunityItem]()

    fileprivate var swipeRight: UISwipeGestureRecognizer?
    
    private lazy var leftMenuVC = MainLeftMenuViewController().then {
        view.superview?.addSubview($0.view)
        $0.view.snp.makeConstraints { make in
            make.width.top.bottom.equalToSuperview()
            make.left.equalTo(-UIManager.shared.screenWidth)
        }
        $0.view.superview?.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        showLoadMoreFooter = false
        showRefreshHeader = true
        super.viewDidLoad()
        customBar.isHidden = false
        customBar.backgroundColor = .clear
        startRefresh()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeToRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        self.swipeRight = swipeRight
        
        let menuBtn = UIButton().then {
            $0.setImage(UIImage(named: "ge_icon_main_menu"), for: .normal)
            $0.addTarget(self, action: #selector(menuBtnTap), for: .touchUpInside)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            customBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.left.equalTo(18)
                make.bottom.equalTo(-10)
            }
        }
        
        let _ = UIButton().then {
            $0.setImage(UIImage(named: "icon_main_title"), for: .normal)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -0, bottom: -10, right: -10)
            $0.addTarget(self, action: #selector(menuBtnTap), for: .touchUpInside)
            customBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(46)
                make.height.equalTo(25)
                make.centerY.equalTo(menuBtn)
                make.right.equalTo(-18)
            }
        }
        
        if let tableView = tableView {
            tableView.backgroundColor = .clear
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 220, right: 0)
            tableView.register(headerFooterViewClassWith: MainHeaderCell.self)
            tableView.register(cellWithClass: MainBrandTableViewCell.self)
            tableView.register(cellWithClass: MainNFTMallTableViewCell.self)
            tableView.register(cellWithClass: MainUserRankTableViewCell.self)
            tableView.register(cellWithClass: MainChildCommunityTableViewCell.self)
            tableView.register(cellWithClass: NFTRankViewController.NFTRankListCell.self)
            tableView.register(cellWithClass: NFTRankViewController.NFTRankTopTableViewCell.self)
            tableView.snp.makeConstraints({ make in
                make.top.equalTo(customBar.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            })
            
            let headerImageView = UIImageView().then {
                $0.image = UIImage(named: "lab_login_background")
                $0.contentMode = .scaleAspectFill
                view.insertSubview($0, belowSubview: customBar)
                view.insertSubview($0, belowSubview: tableView)
                $0.snp.makeConstraints { make in
                    make.left.top.right.equalToSuperview()
                    make.height.equalTo(UIManager.shared.screenWidth*367.0/375.0)
                }
            }
            
            let _ = LinearGradientView().then {
                $0.startPoint = CGPoint(x: 0, y: 0)
                $0.endPoint = CGPoint(x: 0, y: 1)
                $0.colors = [color(255, 255, 255), color(243, 243, 243)]
                view.insertSubview($0, belowSubview: headerImageView)
                $0.snp.makeConstraints { make in
                    make.top.equalTo(headerImageView.snp.bottom).offset(-20)
                    make.left.right.bottom.equalTo(UIEdgeInsets.zero)
                }
            }
        }
    }
    
    override func startRefresh() {
        Network.request(MainAPI.mainList, encoding: URLEncoding.default).responseData {[weak self] response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let list = response.data?["models"] as? [[String: Any]] {
                for dic in list {
                    let type = dic["type"] as? String
                    if type == DataType.userRank.rawValue {
                        let ranks = (dic["obj"] as? [String: Any])?["ranks"] as? [Any]
                        if let data = ranks?.jsonString.data(using: .utf8),
                           let result = try? JSONDecoder().decode([UserRankItem].self, from: data) {
                            self?.userRanks.removeAll()
                            self?.userRanks.append(contentsOf: result)
                        }
                    } else if type == DataType.nftRank.rawValue {
                        let ranks = (dic["obj"] as? [String: Any])?["ranks"] as? [Any]
                        if let data = ranks?.jsonString.data(using: .utf8),
                           let result = try? JSONDecoder().decode([NFTRankItem].self, from: data) {
                            self?.nftRanks.removeAll()
                            self?.nftRanks.append(contentsOf: result)
                        }
                    } else if type == DataType.community.rawValue {
                        let nftList = (dic["obj"] as? [String: Any])?["list"] as? [Any]
                        if let data = nftList?.jsonString.data(using: .utf8),
                           let result = try? JSONDecoder().decode([RecommendFeedChildCommunityItem].self, from: data) {
                            self?.recommendCommunitys.removeAll()
                            self?.recommendCommunitys.append(contentsOf: result)
                        }
                    } else if type == DataType.nftMall.rawValue {
                        let nftList = (dic["obj"] as? [String: Any])?["list"] as? [Any]
                        
                        if let data = nftList?.jsonString.data(using: .utf8),
                           let result = try? JSONDecoder().decode([NFTMallViewController.InnerItem].self, from: data) {
                            self?.nftMallList.removeAll()
                            self?.nftMallList.append(contentsOf: result)
                        }
                    }
                }
                
                self?.tableView?.reloadData()
            }
            self?.tableView?.mj_header?.endRefreshing()
            self?.isRefreshing = false
        }
    }
    
    @objc fileprivate func menuBtnTap() {
        swipeToRight()
    }
    
    @objc fileprivate func swipeToRight() {
        leftMenuVC.willMove(toParent: parent)
        parent?.addChild(leftMenuVC)
        view.superview?.addSubview(leftMenuVC.view)
        leftMenuVC.swipeToRight()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { //实时趋势
            return 1
        } else if section == 1 { //数字商城
            return 1
        } else if section == 2 { //实时排行(暂时隐藏)
            return 0
        } else if section == 3 { //数藏趋势
            return nftRanks.count > 3 ? nftRanks.count - 3 : 1
        } else if section == 4 { //热门社区
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withClass: MainHeaderCell.self)
        if section == 0 {
            header.titleLabel.text = "实时趋势"
            header.module = .user
        } else if section == 1 {
            header.titleLabel.text = "数字商城"
            header.module = .nft
        } else if section == 2 {
            header.titleLabel.text = "实时排行"
            header.module = .rank
            return nil
        } else if section == 3 {
            header.titleLabel.text = "数藏趋势"
            header.module = .brand
        } else if section == 4 {
            header.titleLabel.text = "热门社区"
            header.module = .community
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { //实时趋势
            return 43
        } else if section == 1 { //数字商城
            return 57
        } else if section == 2 { //实时排行
//            return 25
            return CGFloat.leastNormalMagnitude
        } else if section == 3 { //数藏趋势
            return 57
        } else if section == 4 { //热门社区
            return 45
        }
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { //实时趋势
            return 75
        } else if indexPath.section == 1 { //数字商城
            return 429
        } else if indexPath.section == 2 { //实时排行
            return 106
        } else if indexPath.section == 3 { //数藏趋势
            if indexPath.row == 0 {
                return 269
            }
            return 80
        } else if indexPath.section == 4 { //热门社区
            return 112
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { //实时趋势
            let cell = tableView.dequeueReusableCell(withClass: MainBrandTableViewCell.self)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.users = userRanks
            cell.collectionView.reloadData()
            return cell
        } else if indexPath.section == 1 { //数字商城
            let cell = tableView.dequeueReusableCell(withClass: MainNFTMallTableViewCell.self)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.bindList(nftMallList)
            if let pan = cell.panGesture {
                swipeRight?.require(toFail: pan)
            }
            return cell
        } else if indexPath.section == 2 { //实时排行
            let cell = tableView.dequeueReusableCell(withClass: MainUserRankTableViewCell.self)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.collectionView.reloadData()
            return cell
        } else if indexPath.section == 3 { //数藏趋势
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withClass: NFTRankViewController.NFTRankTopTableViewCell.self)
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.contentView.backgroundColor = .clear
                cell.bindModels(item1: nftRanks[safe: 0], item2: nftRanks[safe: 1], item3: nftRanks[safe: 2])
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withClass: NFTRankViewController.NFTRankListCell.self)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.titleLabel.text = "\(indexPath.row + 3)"
            cell.bindModel(nftRanks[safe: indexPath.row + 2], indexPath: indexPath)
            return cell
        } else if indexPath.section == 4 { //热门社区
            let cell = tableView.dequeueReusableCell(withClass: MainChildCommunityTableViewCell.self)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.communitys = recommendCommunitys
            cell.collectionView.reloadData()
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? NFTRankViewController.NFTRankListCell,
           let item = cell.nftInfo {
            UIManager.push(to: NFTDetailViewController().then { $0.nftInfo = item })
        }
    }
}

fileprivate extension MainViewController {
    enum DataType: String {
        case userRank = "userRank"
        case nftRank = "goodsRank"
        case community = "community"
        case nftMall = "nftMall"
    }
}

fileprivate class MainHeaderCell: UITableViewHeaderFooterView {
    fileprivate lazy var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .semiboldPingFangSCFont(ofSize: 18)
        $0.textAlignment = .left
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.height.equalTo(25)
            make.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(200)
        }
    }
    
    fileprivate lazy var arrowView = UIButton().then {
        $0.setImage(UIImage(named: "ge_main_arrow"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -UIManager.shared.screenWidth, bottom: -15, right: -15)
        $0.addTarget(self, action: #selector(arrowTap), for: .touchUpInside)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.width.height.equalTo(20)
            make.centerY.equalTo(titleLabel)
        }
    }
    
    fileprivate lazy var moreBtn = UIButton().then {
        $0.setTitle("查看更多", for: .normal)
        $0.setTitleColor(color(0, 0, 0, 0.3), for: .normal)
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -UIManager.shared.screenWidth, bottom: -15, right: -15)
        $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
        $0.contentEdgeInsets = .zero
        $0.addTarget(self, action: #selector(arrowTap), for: .touchUpInside)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.right.equalTo(-18)
            make.height.equalTo(17)
            make.width.equalTo(48)
            make.centerY.equalTo(titleLabel)
        }
    }
    
    enum Module {
        case rank
        case user
        case nft
        case brand
        case community
    }
    
    var module: Module = .rank {
        didSet {
            arrowView.isHidden = module == .community
            moreBtn.isHidden = !arrowView.isHidden
        }
    }
    
    @objc fileprivate func arrowTap() {
        switch module {
        case .rank:
            UIManager.push(to: BrandRankViewController())
        case .user:
            UIManager.push(to: UserRankViewController())
        case .nft:
            UIManager.push(to: NFTMallViewController())
        case .brand:
            UIManager.push(to: NFTRankViewController())
        case .community:
            UIManager.push(to: RecommendChildCommunityViewController())
        }
    }
}

fileprivate class MainBrandTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 12
        $0.minimumInteritemSpacing = 12
        $0.scrollDirection = .horizontal
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.backgroundColor = .clear
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.delegate = self
        $0.dataSource = self
        $0.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(cellWithClass: CollectionCell.self)
        $0.keyboardDismissMode = .onDrag
        $0.contentInsetAdjustmentBehavior = .never
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    var users = [UserRankItem]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 142, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CollectionCell.self, for: indexPath)
        cell.contentView.backgroundColor = .clear
        cell.backView.image = YYImage(named: "ge_icon_brand_main")
        
        if let item = users[safe: indexPath.item], let user = item.userInfo {
            cell.avatarView.image = nil
            cell.avatarView.setWebImage(url: OSSUploader.avatarURLFor((user.userInfo?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
            cell.nameLabel.text = user.userInfo?.userName
            cell.percentLabel.text = "\(item.points.nonnull)"
            cell.percentLabel.textColor = color(38, 242, 255)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = users[safe: indexPath.item], let user = item.userInfo?.userInfo {
            UIManager.push(to: UserViewController().then {
                $0.userID = user.userID
                $0.userInfo = user
            })
        }
    }
    
    class CollectionCell: UICollectionViewCell {
        lazy var backView = UIImageView().then {
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        lazy var backCoverView = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.3)
            $0.layer.cornerRadius = 30.0
            contentView.insertSubview($0, aboveSubview: backView)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        lazy var avatarView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            backCoverView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.left.equalTo(6)
                make.width.height.equalTo(48)
            }
        }
        
        lazy var nameLabel = UILabel().then {
            $0.font = .mediumPingFangSCFont(ofSize: 14)
            $0.textColor = .white
            backCoverView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(avatarView.snp.right).offset(12)
                make.top.equalTo(12)
                make.right.equalTo(-10)
                make.height.equalTo(20)
            }
        }
        
        lazy var percentLabel = UILabel().then {
            $0.font = .gothamMediumFont(ofSize: 12)
            backCoverView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(nameLabel)
                make.top.equalTo(nameLabel.snp.bottom).offset(4)
                make.height.equalTo(15)
            }
        }
    }
}

fileprivate class MainUserRankTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 17
        $0.minimumInteritemSpacing = 17
        $0.scrollDirection = .horizontal
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.backgroundColor = .clear
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.delegate = self
        $0.dataSource = self
        $0.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(cellWithClass: CollectionCell.self)
        $0.keyboardDismissMode = .onDrag
        $0.contentInsetAdjustmentBehavior = .never
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(92)
            make.bottom.equalToSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 157, height: 92)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CollectionCell.self, for: indexPath)
        cell.contentView.backgroundColor = .clear
        cell.backView.image = YYImage(named: "ge_icon_user_rank_main")
        cell.avatarView.image = UIImage(named: "ge_icon_brand_rank_avatar_3")
        cell.nameLabel.text = "MoonJun"
        cell.descLabel.text = "ATLB"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        UIManager.push(to: UserViewController())
    }
    
    class CollectionCell: UICollectionViewCell {
        lazy var backView = UIImageView().then {
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        lazy var backCoverView = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.3)
            $0.layer.cornerRadius = 14.0
            contentView.insertSubview($0, aboveSubview: backView)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        lazy var avatarView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            backCoverView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-9)
                make.bottom.equalTo(-12)
                make.width.height.equalTo(34)
            }
        }
        
        lazy var nameLabel = UILabel().then {
            $0.font = .mediumPingFangSCFont(ofSize: 14)
            $0.textColor = .white
            backCoverView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(10)
                make.bottom.equalTo(descLabel.snp.top).offset(-1)
                make.right.equalTo(avatarView.snp.left).offset(-10)
                make.height.equalTo(20)
            }
        }
        
        lazy var descLabel = UILabel().then {
            $0.font = .regularPingFangSCFont(ofSize: 12)
            $0.textColor = color(255, 255, 255, 0.5)
            backCoverView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(10)
                make.right.equalTo(avatarView.snp.left).offset(-10)
                make.height.equalTo(17)
                make.bottom.equalTo(-8)
            }
        }
    }
}

fileprivate class MainChildCommunityTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 12
        $0.minimumInteritemSpacing = 12
        $0.scrollDirection = .horizontal
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.backgroundColor = .clear
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.delegate = self
        $0.dataSource = self
        $0.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(cellWithClass: CollectionCell.self)
        $0.keyboardDismissMode = .onDrag
        $0.contentInsetAdjustmentBehavior = .never
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    var communitys = [RecommendFeedChildCommunityItem]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return communitys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CollectionCell.self, for: indexPath)
        cell.contentView.backgroundColor = .clear
        let data = communitys[indexPath.item]
        cell.backView.image = nil
        cell.backView.setWebImage(url: OSSUploader.avatarURLFor(data.icon.nonnull, crop: .medium), cornerRadius: 16.0*3, finalSize: CGSize(width: 100*3.0, height: 100*3.0))
        cell.nameLabel.text = "#\(data.name.nonnull)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = communitys[indexPath.item]
        UIManager.push(to: FeedChildCommunityDetailViewController().then {
            var item = CommunityItem()
            item.id = data.id
            item.image = data.icon.nonnull
            item.name = data.name.nonnull
            $0.communityItem = item
        })
    }
    
    class CollectionCell: UICollectionViewCell {
        lazy var backView = UIImageView().then {
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        lazy var backCoverView = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.3)
            $0.layer.cornerRadius = 16.0
            contentView.insertSubview($0, aboveSubview: backView)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        lazy var nameLabel = UILabel().then {
            $0.font = .semiboldPingFangSCFont(ofSize: 14)
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.textColor = .white
            backCoverView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
    }
}


fileprivate class MainNFTMallTableViewCell: UITableViewCell {
    
    var panGesture: UIPanGestureRecognizer?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(recognize:)))
        contentView.addGestureRecognizer(longPress)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(longPressHandler(recognize:)))
        pan.require(toFail: longPress)
        pan.delegate = self
        contentView.addGestureRecognizer(pan)
        panGesture = pan
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer, gestureRecognizer.view == contentView {
            let velocity = gestureRecognizer.velocity(in: contentView)
            let translation = gestureRecognizer.translation(in: contentView)
            if abs(velocity.y) > abs(velocity.x), abs(translation.y) > abs(translation.x) {
                return false
            }
            
            if gestureRecognizer.location(in: self).x < 40 {
                return false
            }
        }
        return true
    }
    
    enum PanRegion {
        case top, bottom
    }
    
    private var firstPoint: CGPoint = .zero
    private var transPoint: CGPoint = .zero
    private var panTouchPoint: CGPoint = .zero
    private var panRegion: PanRegion = .top
    
    @objc func longPressHandler(recognize: UIGestureRecognizer) {
        if topCardView == nil {
            topCardView = cardView1
        }
        
        guard nftList.count > 1, let topCardView = topCardView else { return }
        
        switch recognize.state {
        case .began:
            let location = recognize.location(in: contentView)
            firstPoint = topCardView.center
            transPoint = .zero
            panTouchPoint = recognize.location(in: superview)
            panRegion = location.y < bounds.height/2.0 ? .top : .bottom
            
            UIView.animate(withDuration: 0.25) {
                topCardView.transform = .init(scaleX: 1.02, y: 1.02)
            }
        case .changed:
            let location = recognize.location(in: superview)
            transPoint = CGPoint(x: location.x - panTouchPoint.x, y: location.y - panTouchPoint.y)
            UIView.animate(withDuration: 0.1) {
                topCardView.center = CGPoint(x: self.firstPoint.x + self.transPoint.x, y: self.firstPoint.y + self.transPoint.y)
            }
            
            let rotate = min(transPoint.x/320.0, 1)
            let angel: CGFloat = panRegion == .top ? .pi/8.0*rotate : -.pi/8.0*rotate
            let transform: CGAffineTransform = .init(scaleX: 1.02, y: 1.02).rotated(by: angel)
            topCardView.transform = transform
        case .ended, .cancelled:
            let out = abs(topCardView.frame.midX - firstPoint.x) > 25
            if out {
                if transPoint == .zero {
                    transPoint = CGPoint(x: 1, y: 0)
                }
                
                let vector = sqrt(transPoint.x*transPoint.x + transPoint.y*transPoint.y)
                transPoint = CGPoint(x: transPoint.x/vector, y: transPoint.y/vector)
                isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.3) {
                    let center = topCardView.center
                    topCardView.center = CGPoint(x: center.x + 2*UIManager.shared.screenWidth*self.transPoint.x, y: center.y + 2*UIManager.shared.screenWidth*self.transPoint.y)
                } completion: { _ in
                    self.resetTopShow()
                }
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
                    topCardView.transform = .identity
                    topCardView.center = self.firstPoint
                })
            }
        default:break
        }
    }
    
    var nftList = [NFTMallViewController.InnerItem]()
    var currentIndex: Int = 0
    func bindList(_ model: [NFTMallViewController.InnerItem]) {
        self.nftList.removeAll()
        self.nftList.append(contentsOf: model)
        currentIndex = 0
        
        if let item = model[safe: 0] {
            currentIndex += 1
            if topCardView == cardView2 {
                cardView2.isHidden = false
                cardView2.bindModel(item, index: 0)
            } else {
                cardView1.isHidden = false
                cardView1.bindModel(item, index: 0)
            }
        } else {
            cardView2.isHidden = true
            cardView1.isHidden = true
        }
        
        if let item = model[safe: 1] {
            currentIndex += 1
            if topCardView == cardView2 {
                cardView1.isHidden = false
                cardView1.bindModel(item, index: 1)
            } else {
                cardView2.isHidden = false
                cardView2.bindModel(item, index: 1)
            }
        } else {
            if topCardView == cardView2 {
                cardView1.isHidden = true
            } else {
                cardView2.isHidden = true
            }
        }
    }
    
    var topCardView: CardView?
    @objc fileprivate func resetTopShow() {
        self.topCardView?.isHidden = true
        UIView.animate(withDuration: 0.1) {
            if self.topCardView == self.cardView1 {
                self.contentView.bringSubviewToFront(self.cardView2)
                self.cardView2.transform = .identity
            } else {
                self.cardView1.transform = .identity
                self.contentView.bringSubviewToFront(self.cardView1)
            }
            
            self.topCardView?.transform = .init(rotationAngle: 15.0/180.0)
            self.topCardView?.center = self.firstPoint
        } completion: { _ in
            if self.currentIndex == self.nftList.count {
                self.currentIndex = 0
            }
            
            if let item = self.nftList[safe: self.currentIndex] {
                self.topCardView?.bindModel(item, index: self.currentIndex)
                self.currentIndex += 1
            }
            
            self.topCardView?.isHidden = false
            
            if self.topCardView == self.cardView1 {
                self.topCardView = self.cardView2
            } else {
                self.topCardView = self.cardView1
            }
            
            self.isUserInteractionEnabled = true
        }
    }
    
    lazy var cardView1 = CardView().then {
        $0.iconView.image = YYImage(named: "ge_nft_main_mall_1")
        $0.indexBtn.setTitle("1", for: .normal)
        $0.percentBtn.setTitle("+180%", for: .normal)
        $0.titleLabel.text = "未来已至"
        $0.lowPriceLabel.text = "2,409"
        $0.currentPriceLabel.text = "8,403"
        $0.infoBtn.isHidden = false
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDetailNFT)))
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.bottom.equalTo(-28)
            make.top.equalTo(21)
        }
    }
    
    lazy var cardView2 = CardView().then {
        $0.iconView.image = YYImage(named: "ge_nft_main_mall_1")
        $0.indexBtn.setTitle("2", for: .normal)
        $0.percentBtn.setTitle("+10%", for: .normal)
        $0.titleLabel.text = "未来还没来"
        $0.lowPriceLabel.text = "2,109"
        $0.currentPriceLabel.text = "9,403"
        $0.infoBtn.isHidden = false
        $0.transform = .init(rotationAngle: 15.0/180.0)
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDetailNFT)))
        contentView.insertSubview($0, belowSubview: cardView1)
        $0.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.bottom.equalTo(-28)
            make.top.equalTo(21)
        }
    }
    
    @objc func showDetailNFT() {
        UIManager.push(to: NFTMallViewController())
    }
    
    class CardView: UIView {
        lazy var backView = UIView().then {
            $0.backgroundColor = color(250, 250, 250)
            $0.layer.cornerRadius = 22
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.shadowColor = color(227, 227, 227).cgColor
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.layer.shadowRadius = 20
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(infoBtnTap)))
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        lazy var iconView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 22.0
            $0.layer.masksToBounds = true
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.equalTo(8)
                make.right.equalTo(-8)
                make.height.equalTo(234)
            }
        }
        
        lazy var titleLabel = UILabel().then {
            $0.textColor = .black
            $0.font = .semiboldPingFangSCFont(ofSize: 26)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(24)
                make.top.equalTo(iconView.snp.bottom).offset(21)
                make.right.lessThanOrEqualTo(-80)
                make.height.equalTo(32)
            }
        }
        
        lazy var lowPriceLabel1 = UILabel().then {
            $0.text = "最低价"
            $0.textColor = color(0, 0, 0, 0.5)
            $0.font = .regularPingFangSCFont(ofSize: 10)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-24)
                make.top.equalTo(iconView.snp.bottom).offset(22)
                make.width.equalTo(30)
                make.height.equalTo(14)
            }
        }
        
        lazy var lowPriceLabel = UILabel().then {
            $0.textColor = .black
            $0.font = .gothamMediumFont(ofSize: 12)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(lowPriceLabel1)
                make.top.equalTo(lowPriceLabel1.snp.bottom).offset(4)
                make.width.lessThanOrEqualTo(80)
                make.height.lessThanOrEqualTo(20)
            }
        }
        
        lazy var currentPriceView = UIView().then {
            $0.backgroundColor = color(248, 248, 248)
            $0.layer.cornerRadius = 24.5
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.shadowColor = color(227, 227, 227).cgColor
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.layer.shadowRadius = 20
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(24)
                make.top.equalTo(titleLabel.snp.bottom).offset(13)
                make.width.equalTo(109)
                make.height.equalTo(49)
            }
        }
        
        lazy var currentPriceLabel1 = UILabel().then {
            $0.text = "Current Price"
            $0.textColor = .black
            $0.font = .regularPingFangSCFont(ofSize: 8)
            $0.textAlignment = .center
            currentPriceView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(9)
                make.height.equalTo(11)
            }
        }
        
        lazy var currentPriceLabel = UILabel().then {
            $0.textColor = .black
            $0.font = .gothamBoldFont(ofSize: 12)
            $0.textAlignment = .center
            currentPriceView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(currentPriceLabel1.snp.bottom).offset(1)
                make.height.equalTo(18)
            }
        }
        
        lazy var infoBtn = UIImageView().then {
            $0.image = UIImage(named: "lab_user_mark_btn")
            $0.contentMode = .scaleAspectFill
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-24)
                make.top.equalTo(lowPriceLabel.snp.bottom).offset(15)
                make.width.height.equalTo(49)
            }
        }
        
        lazy var indexBtn = UIButton().then {
            $0.backgroundColor = .white
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .gothamMediumFont(ofSize: 20)
            $0.layer.cornerRadius = 24.5
            $0.isEnabled = false
            $0.adjustsImageWhenDisabled = false
            iconView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.top.equalTo(15)
                make.width.height.equalTo(49)
            }
        }
        
        lazy var percentBtn = UIButton().then {
            $0.backgroundColor = color(76, 79, 75)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .gothamMediumFont(ofSize: 14)
            $0.layer.cornerRadius = 24.5
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            $0.isEnabled = false
            $0.adjustsImageWhenDisabled = false
            iconView.insertSubview($0, belowSubview: indexBtn)
            $0.snp.makeConstraints { make in
                make.left.equalTo(48)
                make.top.equalTo(15)
                make.height.equalTo(49)
                make.width.equalTo(83)
            }
        }
        
        var item: NFTMallViewController.InnerItem?
        func bindModel(_ item: NFTMallViewController.InnerItem, index: Int) {
            if item.id != self.item?.id {
                iconView.image = nil
                iconView.setWebImage(url: OSSUploader.imageNFTURLFor((item.nftInfo?.cover?.guid).nonnull))
            }
            
            self.item = item
            titleLabel.text = item.nftInfo?.name
            currentPriceLabel.text = (item.nftInfo?.minDealPrice).nonnull > 0 ? "\((item.nftInfo?.minDealPrice).nonnull)" : "暂无成交"
            lowPriceLabel.text = (item.nftInfo?.minSalePrice).nonnull > 0 ? "\((item.nftInfo?.minSalePrice).nonnull)" : "暂无出售"
            let percent = (item.nftInfo?.pointsRase).nonnull*100
            percentBtn.setTitle(percent > 0 ? "+\(Int(percent))" : "\(Int(percent))", for: .normal)
            indexBtn.setTitle("\(index + 1)", for: .normal)
        }
        
        @objc func infoBtnTap() {
            UIManager.push(to: NFTDetailViewController().then { $0.nftInfo = item?.nftInfo })
        }
    }
}
