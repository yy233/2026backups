//
//  FansViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/24.
//

import Foundation
import BasicUIKit
import YYImage
import BasicKit
import APIKit
import Combine

class FansViewController: SegmentViewController {
    var index: Int = 0
    var userID: String = ""
    
    private var cancelables = Set<AnyCancellable>()

    override func viewDidLoad() {
        segmentStyle = .navigation
        segmentBarHeight = 40
        super.viewDidLoad()
        customBackBtn.isHidden = false
        
        bind(segments: [ChildViewController().then {
            $0.isFollow = true
            let viewModel = InnerViewModel()
            viewModel.url = UserAPI.followList.rawValue
            viewModel.innerPara = ["remoteId": userID]
            $0.viewModel = viewModel
        }, ChildViewController().then {
            $0.isFollow = false
            let viewModel = InnerViewModel()
            viewModel.url = UserAPI.fansList.rawValue
            viewModel.innerPara = ["remoteId": userID]
            $0.viewModel = viewModel
        }])
        
        NotificationCenter.default.publisher(for: .notificationFansDidRemove).sink {[unowned self] obj in
            guard let user = obj.object as? UserInfo else { return }
            (viewControllers.last as? ChildViewController)?.viewModel?.remove(user)
            (viewControllers.last as? ChildViewController)?.tableView?.reloadData()
        }.store(in: &cancelables)
    }
    
    override func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        .at(index: index)
    }
    
    class InnerViewModel: NetworkViewModel {
        var innerPara: [String: Any]?
        override var parameters: [String : Any]? { innerPara }
        
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([UserInfo].self, from: data)
                if isLoadingMore {
                    var list = [UserInfo]()
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
    
    fileprivate class ChildViewController: TableViewController, SegmentBarItem {
        //MARK: - Segment
        var segmentTitle: String {
            return isFollow ? "关注" : "粉丝"
        }
        
        var normalColor: UIColor { color(0, 0, 0, 0.3) }
        var selectColor: UIColor { .black }
        var font: UIFont { .mediumPingFangSCFont(ofSize: 18) }
        var selectFont: UIFont { .semiboldPingFangSCFont(ofSize: 18) }
        var viewController: UIViewController { self }
        var segmentPadding: CGFloat { 20 }
        var segmentMargin: CGFloat { 20 }
        var segmentIndicatorEnable: Bool { false }
        var isFollow = false
        
        override func viewDidLoad() {
            triggerRefreshAutomatic = true
            triggerLoadMoreAutomatic = true
            super.viewDidLoad()
            
            tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
            tableView?.register(cellWithClass: RankCell.self)
            tableView?.snp.makeConstraints({ make in
                make.top.left.right.bottom.equalToSuperview()
            })
        }
        
        //MARK: - Cell
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 72
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withClass: RankCell.self)
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = .white
            if let user = viewModel?.element(at: indexPath.section) as? UserInfo {
                cell.bindModel(user)
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let user = viewModel?.element(at: indexPath.section) as? UserInfo {
                UIManager.push(to: UserViewController().then {
                    $0.userID = user.userID
                    $0.userInfo = user
                })
            }
        }
        
        class RankCell: UITableViewCell {
            fileprivate lazy var avatarView = UIImageView().then {
                $0.contentMode = .scaleAspectFit
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.height.equalTo(40)
                    make.left.equalTo(16)
                    make.centerY.equalToSuperview()
                }
            }
            
            fileprivate lazy var nameLabel = UILabel().then {
                $0.font = .regularPingFangSCFont(ofSize: 14)
                $0.textColor = .black
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(avatarView.snp.right).offset(10)
                    make.right.lessThanOrEqualTo(-100)
                    make.height.equalTo(23)
                    make.centerY.equalToSuperview()
                }
            }
            
            fileprivate lazy var badgeView = UIImageView().then {
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.right.bottom.equalTo(avatarView)
                    make.width.height.equalTo(13)
                }
            }
            
            fileprivate lazy var fansBtn = UIButton().then {
                $0.backgroundColor = color(229, 246, 255)
                $0.layer.cornerRadius = 4
                $0.setTitleColor(color(51, 186, 255), for: .normal)
                $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 12)
                $0.addTarget(self, action: #selector(stateTap), for: .touchUpInside)
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.right.equalTo(moreBtn.snp.left).offset(-10)
                    make.width.equalTo(64)
                    make.height.equalTo(28)
                    make.centerY.equalTo(avatarView)
                }
            }
            
            fileprivate lazy var followBtn = UIButton().then {
                $0.backgroundColor = color(51, 186, 255)
                $0.layer.cornerRadius = 4
                $0.setTitle(" 关注", for: .normal)
                $0.setTitleColor(.white, for: .normal)
                $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 12)
                $0.setImage(UIImage(named: "lab_user_fans_follow"), for: .normal)
                $0.addTarget(self, action: #selector(stateTap), for: .touchUpInside)
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.right.equalTo(moreBtn.snp.left).offset(-10)
                    make.width.equalTo(64)
                    make.height.equalTo(28)
                    make.centerY.equalTo(avatarView)
                }
            }
            
            fileprivate lazy var moreBtn = UIButton().then {
                $0.setImage(UIImage(named: "lab_community_feed_cell_more"), for: .normal)
                $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
                $0.addTarget(self, action: #selector(menuTap), for: .touchUpInside)
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.height.equalTo(24)
                    make.centerY.equalToSuperview()
                    make.right.equalTo(-16)
                }
            }
            
            fileprivate lazy var lineView = UIView().then {
                $0.backgroundColor = color(246, 248, 250)
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.bottom.equalToSuperview()
                    make.height.equalTo(0.5)
                    make.left.equalTo(16)
                    make.right.equalTo(-16)
                }
            }

            override func prepareForReuse() {
                super.prepareForReuse()
                avatarView.cancelCurrentWebImageLoad()
                avatarView.image = nil
            }
            
            func bindModel(_ user: UserInfo) {
                avatarView.setWebImage(url: OSSUploader.avatarURLFor(user.avatar, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
                nameLabel.text = user.userName
                badgeView.image = UIImage(named: "lab_user_badge_1")
                followBtn.isHidden = user.relationship == .follow || user.relationship == .friend
                fansBtn.isHidden = !followBtn.isHidden
                fansBtn.setTitle(user.relationship == .friend ? "互相关注" : "已关注", for: .normal)
                lineView.isHidden = false
                self.user = user
            }
            
            var user: UserInfo?
            @objc func stateTap() {
                guard let user = user, let relation = user.relationship else { return }
                switch relation {
                case .stranger, .fan:
                    HUD.show()
                    Network.request(UserAPI.userFollow, parameters: ["remoteId": user.userID]).responseData { response in
                        HUD.hide()
                        if let error = response.error {
                            Toast.toast(title: error.localizedDescription)
                        } else {
                            Toast.toast(title: "已关注")
                            if user.relationship == .stranger {
                                user.relationship = .follow
                            } else {
                                user.relationship = .friend
                            }
                            self.followBtn.isHidden = true
                            self.fansBtn.isHidden = false
                            self.fansBtn.setTitle(user.relationship == .friend ? "互相关注" : "已关注", for: .normal)
                        }
                    }
                case .follow, .friend:
                    Alert.show(title: "取消关注", message: "取消关注后,对方将从你的关注列表移除", cancelBtnTitle: "取消", cancelBtnTapHandler: nil, submitBtnTitle: "确定") {
                        HUD.show()
                        Network.request(UserAPI.userCancelFollow, parameters: ["remoteId": user.userID]).responseData { response in
                            HUD.hide()
                            if let error = response.error {
                                Toast.toast(title: error.localizedDescription)
                            } else {
                                Toast.toast(title: "已取消关注")
                                if user.relationship == .follow {
                                    user.relationship = .stranger
                                } else {
                                    user.relationship = .fan
                                }
                                self.followBtn.isHidden = false
                                self.fansBtn.isHidden = true
                            }
                        }
                    }
                default:break
                }
            }
            
            @objc func menuTap() {
                guard let user = user else { return }
                switch user.relationship {
                case .fan:
                    Alert.show(title: "移除粉丝", message: "移除粉丝后,你将从对方的关注列表移除", cancelBtnTitle: "取消", cancelBtnTapHandler: nil, submitBtnTitle: "确定") {
                        HUD.show()
                        Network.request(UserAPI.fanRemove, parameters: ["remoteId": user.userID]).responseData { response in
                            if let error = response.error {
                                Toast.toast(title: error.localizedDescription)
                            } else {
                                Toast.toast(title: "已移除")
                                if user.relationship == .follow {
                                    user.relationship = .stranger
                                } else {
                                    user.relationship = .fan
                                }
                                self.followBtn.isHidden = false
                                self.fansBtn.isHidden = true
                                NotificationCenter.default.post(name: .notificationFansDidRemove, object: user)
                            }
                        }
                    }
                case .follow, .friend:
                    Alert.show(title: "取消关注", message: "取消关注后,对方将从你的关注列表移除", cancelBtnTitle: "取消", cancelBtnTapHandler: nil, submitBtnTitle: "确定") {
                        HUD.show()
                        Network.request(UserAPI.userCancelFollow, parameters: ["remoteId": user.userID]).responseData { response in
                            if let error = response.error {
                                Toast.toast(title: error.localizedDescription)
                            } else {
                                Toast.toast(title: "已取消关注")
                                if user.relationship == .follow {
                                    user.relationship = .stranger
                                } else {
                                    user.relationship = .fan
                                }
                                self.followBtn.isHidden = false
                                self.fansBtn.isHidden = true
                            }
                        }
                    }
                default:break
                }
            }
        }
    }
}
