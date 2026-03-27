//
//  MyCommentsViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/15.
//

import Foundation
import BasicKit
import UIKit
import BasicUIKit

final class MyCommentsViewController: TableViewController {
    
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = InnerViewModel()
        viewModel.url = FeedAPI.ownCommentList.rawValue
        self.viewModel = viewModel
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "我的评论"
        view.backgroundColor = color(245, 245, 245)
        
        tableView?.backgroundColor = view.backgroundColor
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        tableView?.register(cellWithClass: TableViewCell.self)
        tableView?.snp.makeConstraints({ make in
            make.top.equalTo(customBar.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TableViewCell.self)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = tableView.backgroundColor
        cell.backgroundColor = tableView.backgroundColor
        if let item = viewModel?.element(at: indexPath.section) as? CommentItem {
            cell.titleLabel.text = item.content
            cell.timeLabel.text = Date(timeIntervalSince1970: item.time/1000.0).displayString()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = viewModel?.element(at: indexPath.section) as? CommentItem {
            UIManager.push(to: CommunityFeedDetailViewController().then {
                let feed = FeedItem()
                feed.id = item.feedId
                $0.feedItem = feed
            })
        }
    }
    
    fileprivate class InnerViewModel: NetworkViewModel {
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([CommentItem].self, from: data)
                if isLoadingMore {
                    var list = [CommentItem]()
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
    
    fileprivate class TableViewCell: UITableViewCell {
        lazy var backView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10.0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.bottom.equalToSuperview()
            }
        }
        
        lazy var titleLabel = UILabel().then {
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 18)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.top.equalTo(18)
                make.right.equalTo(-16)
                make.height.equalTo(25)
            }
        }
        
        lazy var timeLabel = UILabel().then {
            $0.textColor = color(0, 0, 0, 0.3)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(titleLabel)
                make.bottom.equalTo(-18)
                make.height.equalTo(20)
            }
        }
    }
}
