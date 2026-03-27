//
//  UserRankViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/12.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import APIKit

struct UserRankItem: Codable, IdentifierElement {
    var points: Int?
    var userInfo: UserProfile?
    
    var uniqueIdentifier: String { (userInfo?.userInfo?.userID).nonnull }
    
    enum CodingKeys: String, CodingKey {
        case points
        case userInfo = "user"
    }
}

class UserRankViewController: TableViewController {
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = InnerViewModel()
        viewModel.listKey = "ranks"
        viewModel.url = MainAPI.userRank.rawValue
        self.viewModel = viewModel
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "实时趋势"
        customBar.backgroundColor = .clear
        
        if let tableView = tableView {
            tableView.backgroundColor = .clear
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
            tableView.register(cellWithClass: RankTopCell.self)
            tableView.register(cellWithClass: RankCell.self)
            tableView.snp.makeConstraints({ make in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(customBar.snp.bottom)
            })
            
            let headerImageView = UIImageView().then {
                $0.image = UIImage(named: "lab_login_background")
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
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
                $0.colors = [color(255, 255, 255), color(249, 249, 249)]
                view.insertSubview($0, belowSubview: headerImageView)
                $0.snp.makeConstraints { make in
                    make.top.equalTo(headerImageView.snp.bottom).offset(-20)
                    make.left.right.bottom.equalTo(UIEdgeInsets.zero)
                }
            }
        }
    }
    
    //MARK: - Cell
    override func numberOfSections(in tableView: UITableView) -> Int {
        let count = (viewModel?.numberOfElements).nonnull
        if count == 0 {
            return count
        } else if count < 3 {
            return 1
        }
        return count - 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 201 : 81
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: RankTopCell.self)
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
            cell.bindUsers(user1: viewModel?.element(at: 0) as? UserRankItem,
                           user2: viewModel?.element(at: 1) as? UserRankItem,
                           user3: viewModel?.element(at: 2) as? UserRankItem)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withClass: RankCell.self)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.titleLabel.text = "\(indexPath.section + 3)"
        if let user = viewModel?.element(at: indexPath.section + 2) as? UserRankItem {
            cell.bindModel(user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0, let user = viewModel?.element(at: indexPath.section + 2) as? UserRankItem {
            UIManager.push(to: UserViewController().then {
                $0.userID = (user.userInfo?.userInfo?.userID).nonnull
                $0.userInfo = user.userInfo?.userInfo
            })
        }
    }
    
    fileprivate class InnerViewModel: NetworkViewModel {
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([UserRankItem].self, from: data)
                if isLoadingMore {
                    var list = [UserRankItem]()
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
    
    fileprivate class RankTopCell: UITableViewCell {
        lazy var backView1 = UIImageView().then {
            $0.image = UIImage(named: "lab_main_user_rank_top_1")
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(topUser1Tap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(88)
                make.height.equalTo(97)
                make.centerX.equalToSuperview()
                make.top.equalTo(24)
            }
        }
        
        lazy var iconView1 = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(72)
                make.centerX.equalTo(backView1)
                make.centerY.equalTo(backView1).offset(2)
            }
        }
        
        lazy var titleLabel1 = UILabel().then {
            $0.font = .semiboldPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView1)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(20)
                make.top.equalTo(backView1.snp.bottom).offset(4)
            }
        }
        
        lazy var descLabel1 = UILabel().then {
            $0.font = .gothamBoldFont(ofSize: 14)
            $0.textColor = color(255, 38, 111)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView1)
                make.width.lessThanOrEqualTo(100)
                make.height.lessThanOrEqualTo(30)
                make.top.equalTo(titleLabel1.snp.bottom).offset(3)
            }
        }
        
        lazy var followBtn1 = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "lab_main_user_rank_top_follow"), for: .normal)
            $0.addTarget(self, action: #selector(topUser1FollowBtnTap), for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView1)
                make.width.equalTo(30)
                make.height.equalTo(20)
                make.bottom.equalTo(backView1).offset(5)
            }
        }
        
        lazy var backView2 = UIImageView().then {
            $0.image = UIImage(named: "lab_main_user_rank_top_2")
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(topUser2Tap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(80)
                make.height.equalTo(89)
                make.left.equalTo(30)
                make.top.equalTo(44)
            }
        }
        
        lazy var iconView2 = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(64)
                make.centerX.equalTo(backView2)
                make.centerY.equalTo(backView2).offset(2)
            }
        }
        
        lazy var titleLabel2 = UILabel().then {
            $0.font = .semiboldPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView2)
                make.width.lessThanOrEqualTo(90)
                make.height.equalTo(20)
                make.top.equalTo(backView2.snp.bottom).offset(4)
            }
        }
        
        lazy var descLabel2 = UILabel().then {
            $0.font = .gothamBoldFont(ofSize: 14)
            $0.textColor = color(255, 38, 111)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView2)
                make.width.lessThanOrEqualTo(100)
                make.height.lessThanOrEqualTo(30)
                make.top.equalTo(titleLabel2.snp.bottom).offset(3)
            }
        }
        
        lazy var followBtn2 = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "lab_main_user_rank_top_follow"), for: .normal)
            $0.addTarget(self, action: #selector(topUser2FollowBtnTap), for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView2)
                make.width.equalTo(30)
                make.height.equalTo(20)
                make.bottom.equalTo(backView2).offset(5)
            }
        }
        
        lazy var backView3 = UIImageView().then {
            $0.image = UIImage(named: "lab_main_user_rank_top_3")
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(topUser3Tap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(80)
                make.height.equalTo(89)
                make.right.equalTo(-30)
                make.top.equalTo(backView2)
            }
        }
        
        lazy var iconView3 = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(64)
                make.centerX.equalTo(backView3)
                make.centerY.equalTo(backView3).offset(2)
            }
        }
        
        lazy var titleLabel3 = UILabel().then {
            $0.font = .semiboldPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView3)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(20)
                make.top.equalTo(backView3.snp.bottom).offset(4)
            }
        }
        
        lazy var descLabel3 = UILabel().then {
            $0.font = .gothamBoldFont(ofSize: 14)
            $0.textColor = color(255, 38, 111)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView3)
                make.width.lessThanOrEqualTo(100)
                make.height.lessThanOrEqualTo(30)
                make.top.equalTo(titleLabel3.snp.bottom).offset(3)
            }
        }
        
        lazy var followBtn3 = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "lab_main_user_rank_top_follow"), for: .normal)
            $0.addTarget(self, action: #selector(topUser3FollowBtnTap), for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView3)
                make.width.equalTo(30)
                make.height.equalTo(20)
                make.bottom.equalTo(backView3).offset(5)
            }
        }
        
        @objc func topUser1FollowBtnTap() {
            guard let user = user1 else { return }
            if user.relationship == .stranger || user.relationship == .fan {
                HUD.show()
                Network.request(UserAPI.userFollow, parameters: ["remoteId": (user.userInfo?.userID).nonnull]).responseData { response in
                    HUD.hide()
                    if let error = response.error {
                        Toast.toast(title: error.localizedDescription)
                    } else {
                        Toast.toast(title: "已关注")
                        user.relationship = .follow
                        self.followBtn1.isHidden = true
                    }
                }
            } else {
                UIManager.push(to: UserViewController().then {
                    $0.userID = (user.userInfo?.userID).nonnull
                    $0.userInfo = user.userInfo
                })
            }
        }
        
        @objc func topUser2FollowBtnTap() {
            guard let user = user2 else { return }
            if user.relationship == .stranger || user.relationship == .fan {
                HUD.show()
                Network.request(UserAPI.userFollow, parameters: ["remoteId": (user.userInfo?.userID).nonnull]).responseData { response in
                    HUD.hide()
                    if let error = response.error {
                        Toast.toast(title: error.localizedDescription)
                    } else {
                        Toast.toast(title: "已关注")
                        user.relationship = .follow
                        self.followBtn2.isHidden = true
                    }
                }
            } else {
                UIManager.push(to: UserViewController().then {
                    $0.userID = (user.userInfo?.userID).nonnull
                    $0.userInfo = user.userInfo
                })
            }
        }
        
        @objc func topUser3FollowBtnTap() {
            guard let user = user3 else { return }
            if user.relationship == .stranger || user.relationship == .fan {
                HUD.show()
                Network.request(UserAPI.userFollow, parameters: ["remoteId": (user.userInfo?.userID).nonnull]).responseData { response in
                    HUD.hide()
                    if let error = response.error {
                        Toast.toast(title: error.localizedDescription)
                    } else {
                        Toast.toast(title: "已关注")
                        user.relationship = .follow
                        self.followBtn3.isHidden = true
                    }
                }
            } else {
                UIManager.push(to: UserViewController().then {
                    $0.userID = (user.userInfo?.userID).nonnull
                    $0.userInfo = user.userInfo
                })
            }
        }
        
        @objc func topUser1Tap() {
            UIManager.push(to: UserViewController().then {
                $0.userID = (user1?.userInfo?.userID).nonnull
                $0.userInfo = user1?.userInfo
            })
        }
        
        @objc func topUser2Tap() {
            UIManager.push(to: UserViewController().then {
                $0.userID = (user2?.userInfo?.userID).nonnull
                $0.userInfo = user2?.userInfo
            })
        }
        
        @objc func topUser3Tap() {
            UIManager.push(to: UserViewController().then {
                $0.userID = (user3?.userInfo?.userID).nonnull
                $0.userInfo = user3?.userInfo
            })
        }
        
        var user1: UserProfile?
        var user2: UserProfile?
        var user3: UserProfile?
        func bindUsers(user1: UserRankItem?, user2: UserRankItem?, user3: UserRankItem?) {
            self.user1 = user1?.userInfo
            self.user2 = user2?.userInfo
            self.user3 = user3?.userInfo
            iconView1.setWebImage(url: OSSUploader.avatarURLFor((user1?.userInfo?.userInfo?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
            titleLabel1.text = user1?.userInfo?.userInfo?.userName
            descLabel1.text = "\((user1?.points).nonnull)"
            followBtn1.isHidden = user1?.userInfo?.relationship != .stranger && user1?.userInfo?.userInfo?.relationship != .fan
            
            iconView2.setWebImage(url: OSSUploader.avatarURLFor((user2?.userInfo?.userInfo?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
            titleLabel2.text = user2?.userInfo?.userInfo?.userName
            descLabel2.text = "\((user2?.points).nonnull)"
            followBtn2.isHidden = user2?.userInfo?.relationship != .stranger && user2?.userInfo?.relationship != .fan
            
            iconView3.setWebImage(url: OSSUploader.avatarURLFor((user3?.userInfo?.userInfo?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
            titleLabel3.text = user3?.userInfo?.userInfo?.userName
            descLabel3.text = "\((user3?.points).nonnull)"
            followBtn3.isHidden = user3?.userInfo?.relationship != .stranger && user3?.userInfo?.relationship != .fan
        }
    }
    
    fileprivate class RankCell: UITableViewCell {
        fileprivate lazy var titleLabel = UILabel().then {
            $0.font = .gothamBoldFont(ofSize: 14)
            $0.textColor = color(174, 181, 196)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.width.lessThanOrEqualTo(100)
                make.height.lessThanOrEqualTo(25)
                make.centerY.equalToSuperview()
            }
        }
        
        fileprivate lazy var avatarView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(48)
                make.left.equalTo(titleLabel.snp.right).offset(16)
                make.centerY.equalToSuperview()
            }
        }
        
        fileprivate lazy var nameLabel = UILabel().then {
            $0.font = .mediumPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(avatarView.snp.right).offset(12)
                make.right.lessThanOrEqualTo(-100)
                make.height.equalTo(20)
                make.top.equalTo(avatarView).offset(5)
            }
        }
        
        fileprivate lazy var scoreLabel = UILabel().then {
            $0.font = .gothamBoldFont(ofSize: 14)
            $0.textColor = color(255, 38, 111)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(nameLabel)
                make.right.lessThanOrEqualTo(-100)
                make.height.lessThanOrEqualTo(20)
                make.top.equalTo(nameLabel.snp.bottom)
            }
        }
        
        fileprivate lazy var stateView = UIImageView().then {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stateTap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.equalTo(38)
                make.height.equalTo(26)
                make.centerY.equalTo(avatarView)
            }
        }
        
        var user: UserProfile?
        func bindModel(_ item: UserRankItem) {
            if let user = item.userInfo {
                self.user = user
                avatarView.setWebImage(url: OSSUploader.avatarURLFor((user.userInfo?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
                nameLabel.text = user.userInfo?.userName
                scoreLabel.text = "\(item.points.nonnull)"
                stateView.image = user.relationship == .follow || user.relationship == .friend || user.relationship == .own ? UIImage(named: "lab_main_user_rank_did_follow") : UIImage(named: "lab_main_user_rank_follow")
            }
        }
        
        @objc func stateTap() {
            guard let user = user else { return }
            if user.relationship == .stranger || user.relationship == .fan {
                HUD.show()
                Network.request(UserAPI.userFollow, parameters: ["remoteId": (user.userInfo?.userID).nonnull]).responseData { response in
                    HUD.hide()
                    if let error = response.error {
                        Toast.toast(title: error.localizedDescription)
                    } else {
                        Toast.toast(title: "已关注")
                        user.relationship = .follow
                        self.stateView.image = UIImage(named: "lab_main_user_rank_did_follow")
                    }
                }
            } else {
                UIManager.push(to: UserViewController().then {
                    $0.userID = (user.userInfo?.userID).nonnull
                    $0.userInfo = user.userInfo
                })
            }
        }
    }
}
