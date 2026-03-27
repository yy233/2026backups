//
//  MyPointsOrderViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/11.
//

import Foundation
import BasicKit
import UIKit
import BasicUIKit

final class MyPointsOrderViewController: TableViewController {
    
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = InnerViewModel()
        viewModel.url = PointsAPI.orderList.rawValue
        self.viewModel = viewModel
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "我的订单"
        view.backgroundColor = color(245, 245, 245)
        
        tableView?.backgroundColor = view.backgroundColor
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        tableView?.register(cellWithClass: OrderTableViewCell.self)
        tableView?.snp.makeConstraints({ make in
            make.top.equalTo(customBar.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: OrderTableViewCell.self)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = tableView.backgroundColor
        cell.backgroundColor = tableView.backgroundColor
        if let item = viewModel?.element(at: indexPath.section) as? PointsOrderItem {
            cell.titleLabel.text = item.title
            cell.timeLabel.text = item.orderTime
            cell.pointLabel.text = "\(item.points.nonnull)"
            cell.contentLabel.text = "订单号：\(item.id)"
            cell.copyBtn.isHidden = false
            cell.order = item.id
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    fileprivate struct PointsOrderItem: Codable, IdentifierElement {
        var id: String = ""
        var title: String?
        var orderTime: String?
        var points: Int?
        
        var uniqueIdentifier: String { id }
        
        enum CodingKeys: String, CodingKey {
            case id = "orderId"
            case title
            case orderTime
            case points
        }
    }
    
    fileprivate class InnerViewModel: NetworkViewModel {
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([PointsOrderItem].self, from: data)
                if isLoadingMore {
                    var list = [PointsOrderItem]()
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
    
    fileprivate class OrderTableViewCell: UITableViewCell {
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
        
        lazy var contentLabel = UILabel().then {
            $0.textColor = color(0, 0, 0, 0.4)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(titleLabel)
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.right.lessThanOrEqualTo(pointLabel.snp.left).offset(-40)
                make.height.equalTo(20)
            }
        }
        
        var order: String?
        lazy var copyBtn = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "lab_points_order_copy"), for: .normal)
            $0.addAction(UIAction() {[unowned self] _ in
                UIPasteboard.general.string = order
                Toast.toast(title: "订单号已复制到粘贴板")
            }, for: .touchUpInside)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(20)
                make.left.equalTo(contentLabel.snp.right)
                make.centerY.equalTo(contentLabel)
            }
        }
        
        lazy var timeLabel = UILabel().then {
            $0.textColor = color(0, 0, 0, 0.3)
            $0.font = .regularPingFangSCFont(ofSize: 12)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(contentLabel)
                make.right.equalTo(-16)
                make.top.equalTo(contentLabel.snp.bottom).offset(12)
                make.height.equalTo(17)
            }
        }
        
        lazy var pointLabel = UILabel().then {
            $0.textColor = color(255, 38, 111)
            $0.font = .gothamBoldFont(ofSize: 16)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.centerY.equalToSuperview()
                make.height.equalTo(20)
                make.width.lessThanOrEqualTo(100)
            }
        }
    }
}
