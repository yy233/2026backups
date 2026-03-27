//
//  NoticeRelationViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/8.
//

import Foundation
import BasicUIKit
import YYImage
import BasicKit
import APIKit
import Combine

final class NoticeRelationViewController: TableViewController {
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = NoticeCommentViewController.InnerViewModel()
        viewModel.url = NoticeAPI.noticeList.rawValue
        viewModel.innerPara = ["type": 2]
        self.viewModel = viewModel
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.text = "新增关注"
        customBarTitleLabel.isHidden = false
        
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView?.register(cellWithClass: NoticeCell.self)
        tableView?.snp.makeConstraints({ make in
            make.top.equalTo(customBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
    }
    
    //MARK: - Cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: NoticeCell.self)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .white
        if let user = viewModel?.element(at: indexPath.section) as? NoticeItem {
            cell.bindModel(user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = viewModel?.element(at: indexPath.section) as? NoticeItem,
           let url = URL(string: model.gotoString.nonnull) {
            URLRouter.handleGoto(url: url, source: .api)
        }
    }
    
    private class NoticeCell: UITableViewCell {
        fileprivate lazy var avatarView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(52)
                make.left.top.equalTo(16)
            }
        }
        
        fileprivate lazy var nameLabel = UILabel().then {
            $0.font = .mediumPingFangSCFont(ofSize: 16)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(avatarView.snp.right).offset(10)
                make.right.lessThanOrEqualTo(-100)
                make.height.equalTo(23)
                make.top.equalTo(avatarView).offset(3)
            }
        }
        
        fileprivate lazy var timeLabel = UILabel().then {
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textColor = color(0, 0, 0, 0.4)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(nameLabel)
                make.height.equalTo(20)
                make.top.equalTo(nameLabel.snp.bottom).offset(4)
            }
        }
        
        fileprivate lazy var chatBtn = UIButton().then {
            $0.backgroundColor = color(229, 246, 255)
            $0.layer.cornerRadius = 4
            $0.setTitleColor(color(51, 186, 255), for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 12)
            $0.setTitle("打招呼", for: .normal)
            $0.addAction(UIAction() {_ in
                UIManager.push(to: ChatViewController().then { $0.chatWith = (self.user?.user?.userID).nonnull })
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.equalTo(64)
                make.height.equalTo(28)
                make.centerY.equalTo(avatarView)
            }
        }
        
        fileprivate lazy var followBtn = UIButton().then {
            $0.backgroundColor = color(51, 186, 255)
            $0.layer.cornerRadius = 4
            $0.setTitle(" 回关", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 12)
            $0.setImage(UIImage(named: "lab_user_fans_follow"), for: .normal)
            $0.addAction(UIAction() {_ in
                self.followTap()
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.equalTo(64)
                make.height.equalTo(28)
                make.centerY.equalTo(avatarView)
            }
        }
        
        fileprivate lazy var lineView = UIView().then {
            $0.backgroundColor = color(250, 250, 250)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
                make.left.equalTo(16)
                make.right.equalTo(-16)
            }
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            avatarView.cancelCurrentWebImageLoad()
            avatarView.image = nil
        }
        
        func followTap() {
            guard let user = self.user?.user else { return }
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
                    self.chatBtn.isHidden = false
                }
            }
        }
        
        var user: NoticeItem?
        func bindModel(_ user: NoticeItem) {
            avatarView.setWebImage(url: OSSUploader.avatarURLFor((user.user?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
            nameLabel.text = user.user?.userName
            timeLabel.text = "\(user.title.nonnull) \(Date(timeIntervalSince1970: Double(user.timestamp.nonnull)/1000.0).displayString())"
            followBtn.isHidden = user.user?.relationship == .follow || user.user?.relationship == .friend
            chatBtn.isHidden = !followBtn.isHidden
            lineView.isHidden = false
            self.user = user
        }
    }
}
