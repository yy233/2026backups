//
//  SystemNoticeViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/9.
//

import Foundation
import BasicUIKit
import YYImage
import BasicKit
import APIKit
import Combine

fileprivate class SystemNoticeItem: Codable, IdentifierElement {
    var id: String = ""
    var title: String?
    var content: String?
    var timestamp: Int64?
    var gotoString: String?
    
    var uniqueIdentifier: String { id }
    
    lazy var contentAttributedText: NSAttributedString = {
        NSAttributedString(string: content.nonnull, attributes: [.font: UIFont.mediumPingFangSCFont(ofSize: 14)])
    }()
    
    lazy var contentHeight: CGFloat = {
        ceil(contentAttributedText.boundingRect(with: CGSize(width: UIManager.shared.screenWidth - 32 - 60, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).height) + 1
    }()
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case timestamp = "createTimeMills"
        case gotoString
    }
}

final class SystemNoticeViewController: TableViewController {
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = InnerViewModel()
        viewModel.url = NoticeAPI.systemList.rawValue
        self.viewModel = viewModel
        super.viewDidLoad()
        view.backgroundColor = color(245, 245, 245)
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.text = "消息通知"
        customBarTitleLabel.isHidden = false
        
        tableView?.backgroundColor = view.backgroundColor
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView?.register(cellWithClass: NoticeCell.self)
        tableView?.snp.makeConstraints({ make in
            make.top.equalTo(customBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
    }
    
    //MARK: - Cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let item = viewModel?.element(at: indexPath.section) as? SystemNoticeItem {
            return item.contentHeight + 16 + 17 + 10 + 20 + 22 + 8 + 20
        }
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: NoticeCell.self)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = view.backgroundColor
        if let user = viewModel?.element(at: indexPath.section) as? SystemNoticeItem {
            cell.bindModel(user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = viewModel?.element(at: indexPath.section) as? SystemNoticeItem,
           let url = URL(string: model.gotoString.nonnull) {
            URLRouter.handleGoto(url: url, source: .api)
        }
    }
    
    private class NoticeCell: UITableViewCell {
        fileprivate lazy var backView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 12
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(timeLabel.snp.bottom).offset(10)
                make.bottom.equalToSuperview()
            }
        }
        
        fileprivate lazy var titleLabel = UILabel().then {
            $0.font = .mediumPingFangSCFont(ofSize: 16)
            $0.textColor = .black
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(22)
                make.top.equalTo(20)
            }
        }
        
        fileprivate lazy var timeLabel = UILabel().then {
            $0.font = .regularPingFangSCFont(ofSize: 12)
            $0.textAlignment = .center
            $0.textColor = color(0, 0, 0, 0.3)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(16)
                make.left.right.equalToSuperview()
                make.height.equalTo(17)
            }
        }
        
        fileprivate lazy var contentLabel = UILabel().then {
            $0.textColor = color(0, 0, 0, 0.4)
            $0.numberOfLines = 0
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-60)
                make.bottom.equalTo(-20)
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
            }
        }
        
        var user: SystemNoticeItem?
        func bindModel(_ user: SystemNoticeItem) {
            self.user = user
            titleLabel.text = user.title
            timeLabel.text = Date(timeIntervalSince1970: Double(user.timestamp.nonnull)/1000.0).displayString()
            contentLabel.attributedText = user.contentAttributedText
        }
    }
        
    class InnerViewModel: NetworkViewModel {
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([SystemNoticeItem].self, from: data)
                if isLoadingMore {
                    var list = [SystemNoticeItem]()
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
