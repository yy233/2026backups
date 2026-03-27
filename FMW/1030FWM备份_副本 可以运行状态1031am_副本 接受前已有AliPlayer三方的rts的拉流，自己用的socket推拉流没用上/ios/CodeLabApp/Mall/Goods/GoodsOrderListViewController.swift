//
//  GoodsOrderListViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/10/16.
//

import Foundation
import BasicKit
import BasicUIKit
import APIKit

final class GoodsOrderListViewController: SegmentViewController {
    override func viewDidLoad() {
        segmentStyle = .fixed
        segmentBarHeight = 44
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "我的订单"
        
        bind(segments: [InnerListViewController().then { 
            $0.name = "全部"
            $0.status = 0
        },
        InnerListViewController().then {
            $0.name = "待付款"
            $0.status = 1
            
        },
        InnerListViewController().then {
            $0.name = "待发货"
            $0.status = 2
        },
        InnerListViewController().then {
            $0.name = "待收货"
            $0.status = 5
        },
        InnerListViewController().then {
            $0.name = "退货/售后"
            $0.status = 7
        },
        InnerListViewController().then {
            $0.name = "已完成"
            $0.status = 6
        }])
    }
    
    override func didScrolToPage(index: Int) {
        super.didScrolToPage(index: index)
        (viewControllers[index] as? InnerListViewController)?.viewModel?.refresh(shouldLoadCache: false)
        (viewControllers[index] as? InnerListViewController)?.tableView?.scrollToTop(animated: false)
    }
    
    fileprivate class InnerListViewController: TableViewController, SegmentBarItem {
        
        //MARK: - Segment
        var segmentTitle: String {
            return name
        }
        
        var name: String = "全部"
        var status: Int = 0
        var normalColor: UIColor { color(0, 0, 0, 0.3) }
        var selectColor: UIColor { .black }
        var font: UIFont { UIFont.regularPingFangSCFont(ofSize: 16) }
        var selectFont: UIFont { UIFont.semiboldPingFangSCFont(ofSize: 18) }
        var viewController: UIViewController { self }
        var segmentPadding: CGFloat { 16 }
        var segmentMargin: CGFloat { 30 }
        var segmentIndicatorEnable: Bool { false }
        var contentSize: CGSize { tableView?.contentSize ?? .zero }
        
        func updateContentOffset(_ offset: CGPoint) {
            tableView?.contentOffset = offset
        }
        
        override func viewDidLoad() {
            triggerRefreshAutomatic = true
            triggerLoadMoreAutomatic = true
            let viewModel = InnerViewModel()
            viewModel.url = GoodsAPI.orderList.rawValue
            viewModel.innerPara = ["status": status]
            self.viewModel = viewModel
            super.viewDidLoad()
            
            tableView?.backgroundColor = color(246, 246, 246)
            tableView?.scrollsToTop = true
            tableView?.register(cellWithClass: OrderTableCell.self)
            tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIManager.shared.screenWidth, height: 40))
            tableView?.snp.makeConstraints({ make in
                make.top.left.right.bottom.equalToSuperview()
            })
            
            NotificationCenter.default.publisher(for: .notificationOrderDidUpdate).sink {[unowned self] object in
                guard let order = object.object as? GoodsOrderItem,
                let currentOrder = viewModel.element(for: order.id) as? GoodsOrderItem else { return }
                currentOrder.status = order.status
                tableView?.reloadData()
            }.store(in: &cancellableList)
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withClass: OrderTableCell.self)
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = tableView.backgroundColor
            
            if let orderItem = viewModel?.element(at: indexPath.section) as? GoodsOrderItem {
                cell.orderItem = orderItem
                cell.iconView.setWebImage(url: (orderItem.goodsInfo?.cover?.guid).nonnull)
                cell.nameLabel.text = orderItem.goodsInfo?.name
                cell.descLabel.text = "\(orderItem.chooseSize.nonnull) 数量*\(orderItem.goodsNum.nonnull)"
                cell.priceLabel.text = String(format: "￥ %.02f", orderItem.payAllMoney.nonnull)
                cell.statusLabel.text = orderItem.statusTitle

                switch orderItem.status {
                case .cancel:
                    cell.cancelBtn.isHidden = true
                    cell.payBtn.isHidden = true
                    cell.orderLabel.isHidden = true
                case .needPay:
                    cell.cancelBtn.isHidden = false
                    cell.cancelBtn.setTitle("取消订单", for: .normal)
                    cell.payBtn.isHidden = false
                    cell.orderLabel.isHidden = true
                    cell.cancelBtn.snp.updateConstraints { make in
                        make.right.equalTo(-138)
                    }
                case .payWaitSend:
                    cell.cancelBtn.isHidden = false
                    cell.cancelBtn.setTitle("取消订单", for: .normal)
                    cell.payBtn.isHidden = true
                    cell.orderLabel.isHidden = true
                    cell.cancelBtn.snp.updateConstraints { make in
                        make.right.equalTo(-16)
                    }
                case .sendWaitReceive:
                    cell.cancelBtn.isHidden = true
                    cell.payBtn.isHidden = true
                    cell.orderLabel.isHidden = false
                    cell.orderLabel.text = orderItem.expressNo
                case .saleServiceHanding:
                    cell.cancelBtn.isHidden = false
                    cell.cancelBtn.setTitle("联系客服", for: .normal)
                    cell.payBtn.isHidden = true
                    cell.orderLabel.isHidden = true
                    cell.cancelBtn.snp.updateConstraints { make in
                        make.right.equalTo(-16)
                    }
                default:
                    cell.cancelBtn.isHidden = true
                    cell.payBtn.isHidden = true
                    cell.orderLabel.isHidden = false
                    cell.orderLabel.text = orderItem.expressNo
                }
            }
        
            return cell
        }
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 162
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let orderItem = viewModel?.element(at: indexPath.section) as? GoodsOrderItem {
                UIManager.push(to: GoodsOrderDetailViewController().then { $0.orderItem = orderItem })
            }
        }
    }
    
    fileprivate class InnerViewModel: NetworkViewModel {
        var innerPara: [String: Any]?
        override var parameters: [String : Any]? { innerPara }
        
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([GoodsOrderItem].self, from: data)
                if isLoadingMore {
                    var list = [GoodsOrderItem]()
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
    
    fileprivate class OrderTableCell: UITableViewCell {
        lazy var backView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 8.0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.bottom.equalToSuperview()
                make.top.equalTo(10)
            }
        }
        
        lazy var iconView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.top.equalTo(20)
                make.width.height.equalTo(50)
            }
        }
        
        lazy var nameLabel = UILabel().then {
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 16)
            $0.textAlignment = .left
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(iconView.snp.right).offset(20)
                make.top.equalTo(iconView)
                make.right.equalTo(-20)
                make.height.equalTo(23)
            }
        }
        
        lazy var descLabel = UILabel().then {
            $0.textColor = color(0, 0, 0, 0.4)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textAlignment = .left
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalTo(nameLabel)
                make.bottom.equalTo(iconView)
                make.height.equalTo(20)
            }
        }
        
        lazy var priceLabel = UILabel().then {
            $0.textColor = color(0, 0, 0)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textAlignment = .right
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.centerY.equalTo(descLabel)
                make.height.equalTo(20)
                make.width.lessThanOrEqualTo(150)
            }
        }
        
        lazy var lineView = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.2)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(iconView.snp.bottom).offset(22)
                make.height.equalTo(0.5)
            }
        }
        
        lazy var statusLabel = UILabel().then {
            $0.textColor = color(0, 0, 0)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textAlignment = .left
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.top.equalTo(lineView.snp.bottom).offset(25)
                make.height.equalTo(20)
                make.width.lessThanOrEqualTo(150)
            }
        }
        
        lazy var orderLabel = UILabel().then {
            $0.textColor = color(0, 0, 0, 0.4)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textAlignment = .right
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.centerY.equalTo(statusLabel)
                make.height.equalTo(20)
                make.left.lessThanOrEqualTo(statusLabel.snp.right).offset(20)
            }
        }
        
        var orderItem: GoodsOrderItem?
        @objc private func handleOrderPay() {
            HUD.show()
            Network.request(GoodsAPI.orderPay, parameters: ["orderId": (orderItem?.id).nonnull]).responseData { response in
                HUD.hide()
                if let error = response.error {
                    Toast.toast(title: error.localizedDescription)
                } else {
                    Toast.toast(title: "支付完成")
                    self.orderItem?.status = .payWaitSend
                    self.statusLabel.text = self.orderItem?.statusTitle
                    self.cancelBtn.isHidden = false
                    self.cancelBtn.setTitle("取消订单", for: .normal)
                    self.payBtn.isHidden = true
                    self.orderLabel.isHidden = true
                    self.cancelBtn.snp.updateConstraints { make in
                        make.right.equalTo(-16)
                    }
                }
            }
        }
        
        @objc private func handleOrderCancel() {
            if orderItem?.status == .saleServiceHanding {
                UIManager.push(to: ChatViewController().then { $0.chatWith = AppContext.assistorUserID })
                return
            }
            
            HUD.show()
            Network.request(GoodsAPI.orderCancel, parameters: ["orderId": (orderItem?.id).nonnull]).responseData { response in
                HUD.hide()
                if let error = response.error {
                    Toast.toast(title: error.localizedDescription)
                } else {
                    Toast.toast(title: "订单已取消")
                    self.orderItem?.status = .cancel
                    self.statusLabel.text = self.orderItem?.statusTitle
                    self.cancelBtn.isHidden = true
                    self.payBtn.isHidden = true
                    self.orderLabel.isHidden = true
                }
            }
        }
        
        lazy var payBtn = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 5.0
            $0.setTitle("去支付", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
            $0.addTarget(self, action: #selector(handleOrderPay), for: .touchUpInside)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.centerY.equalTo(statusLabel)
                make.height.equalTo(30)
                make.width.equalTo(82)
            }
        }
        
        lazy var cancelBtn = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setTitle("取消订单", for: .normal)
            $0.setTitleColor(color(0, 0, 0, 0.4), for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
            $0.addTarget(self, action: #selector(handleOrderCancel), for: .touchUpInside)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.centerY.equalTo(statusLabel)
                make.height.equalTo(40)
                make.width.equalTo(56)
            }
        }
    }
}
