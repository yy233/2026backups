//
//  NoticeCommentViewController.swift
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

struct NoticeItem: Codable, IdentifierElement {
    var id: String = ""
    var type: Int?
    var user: UserInfo?
    var rightImage: String?
    var title: String?
    var content: String?
    var toContent: String?
    var gotoString: String?
    var timestamp: Int64?
    
    var uniqueIdentifier: String { id }
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case user
        case rightImage
        case title
        case content
        case toContent
        case gotoString
        case timestamp = "createTimeMills"
    }
}

final class NoticeCommentViewController: TableViewController {
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = InnerViewModel()
        viewModel.url = NoticeAPI.noticeList.rawValue
        viewModel.innerPara = ["type": 1]
        self.viewModel = viewModel
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.text = "收到的评论"
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
        if let user = viewModel?.element(at: indexPath.section) as? NoticeItem {
            return user.toContent.nonnull.isEmpty ? 110 : 140
        }
        return CGFloat.leastNormalMagnitude
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
            $0.font = .regularPingFangSCFont(ofSize: 12)
            $0.textColor = color(0, 0, 0, 0.3)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(nameLabel)
                make.height.equalTo(17)
                make.top.equalTo(nameLabel.snp.bottom).offset(6)
            }
        }
        
        fileprivate lazy var contentLabel = UILabel().then {
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(nameLabel)
                make.right.equalTo(-16)
                make.height.equalTo(20)
                make.top.equalTo(timeLabel.snp.bottom).offset(10)
            }
        }
        
        fileprivate lazy var replyLineView = UIView().then {
            $0.backgroundColor = color(216, 216, 216)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(contentLabel.snp.bottom).offset(10)
                make.height.equalTo(12)
                make.left.equalTo(nameLabel)
                make.width.equalTo(2)
            }
        }
        
        fileprivate lazy var replyContentLabel = UILabel().then {
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textColor = color(0, 0, 0, 0.5)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(replyLineView.snp.right).offset(8)
                make.right.equalTo(-16)
                make.height.equalTo(20)
                make.centerY.equalTo(replyLineView)
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

        fileprivate lazy var iconView = UIImageView().then {
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(52)
                make.top.equalTo(avatarView)
                make.right.equalTo(-16)
            }
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            avatarView.cancelCurrentWebImageLoad()
            avatarView.image = nil
            iconView.cancelCurrentWebImageLoad()
            iconView.image = nil
        }
        
        var user: NoticeItem?
        func bindModel(_ user: NoticeItem) {
            avatarView.setWebImage(url: OSSUploader.avatarURLFor((user.user?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
            nameLabel.text = user.user?.userName
            timeLabel.text = "\(user.title.nonnull) \(Date(timeIntervalSince1970: Double(user.timestamp.nonnull)/1000.0).displayString())"
            contentLabel.text = user.content
            replyContentLabel.text = user.toContent
            replyContentLabel.isHidden = user.toContent.nonnull.isEmpty
            replyLineView.isHidden = replyContentLabel.isHidden
            iconView.setWebImage(url: OSSUploader.imageURLFor(user.rightImage.nonnull, crop: .small), cornerRadius: 8*3.0, finalSize: CGSize(width: 52*3.0, height: 52*3.0))
            lineView.isHidden = false
            self.user = user
        }
    }
        
    class InnerViewModel: NetworkViewModel {
        var innerPara: [String: Any]?
        override var parameters: [String : Any]? { innerPara }
        
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([NoticeItem].self, from: data)
                if isLoadingMore {
                    var list = [NoticeItem]()
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
}
