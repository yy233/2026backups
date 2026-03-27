//
//  GoodsAddressListViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/10/13.
//

import Foundation
import BasicKit
import BasicUIKit

final class GoodsAddressListViewController: TableViewController {
    
    var addressItem: AddressItem?
    var didSelectAddressHandler: ((AddressItem) -> Void)?
    
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = InnerViewModel()
        viewModel.url = GoodsAPI.addressList.rawValue
        self.viewModel = viewModel
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "地址管理"
        
        let addBtn = UIButton().then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 12
            $0.setTitle("添加配送地址", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 16)
            $0.addAction(UIAction() { _ in
                let addVC = GoodsAddressAddViewController()
                UIManager.push(to: addVC)
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.bottom.equalTo(UIManager.shared.isNotchScreen ? -42 : -8)
                make.height.equalTo(44)
            }
        }
        
        tableView?.backgroundColor = view.backgroundColor
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        tableView?.register(cellWithClass: TableViewCell.self)
        tableView?.snp.makeConstraints({ make in
            make.top.equalTo(customBar.snp.bottom)
            make.bottom.equalTo(addBtn.snp.top).offset(-20)
            make.left.right.equalToSuperview()
        })
        
        NotificationCenter.default.publisher(for: .notificationAddressDidDelete).sink {[unowned self] object in
            guard let address = object.object as? AddressItem else { return }
            if let index = viewModel.elementIndex(for: address) {
                viewModel.remove(address)
                tableView?.deleteSections(IndexSet(integer: index), with: .none)
            }
        }.store(in: &cancellableList)
        
        NotificationCenter.default.publisher(for: .notificationAddressDidUpdate).sink {[unowned self] object in
            if let address = object.object as? AddressItem, let currentAddress = viewModel.element(for: address.id) as? AddressItem {
                currentAddress.name = address.name
                currentAddress.mobile = address.mobile
                currentAddress.city = address.city
                currentAddress.address = address.address
                currentAddress.isDefault = address.isDefault
                tableView?.reloadData()
            } else {
                viewModel.refresh(shouldLoadCache: false)
                tableView?.scrollToTop(animated: false)
            }
        }.store(in: &cancellableList)
    }
    
    override func showEmptyView() {
        guard showEmptyPlaceholder, emptyView == nil else { return }
        emptyView = UILabel().then {
            $0.text = "暂无地址信息"
            $0.font = .regularPingFangSCFont(ofSize: 16)
            $0.textColor = color(0, 0, 0, 0.3)
            reloadableView?.addSubview($0)
            $0.snp.makeConstraints { make in
                make.height.equalTo(22)
                make.width.lessThanOrEqualTo(200)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(emptyPlaceholderOffsetY)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TableViewCell.self)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = tableView.backgroundColor
        cell.backgroundColor = tableView.backgroundColor
        cell.lineView.isHidden = indexPath.section + 1 == viewModel?.numberOfElements
        cell.editBtn.isHidden = false

        if let item = viewModel?.element(at: indexPath.section) as? AddressItem {
            cell.addressItem = item
            cell.nameLabel.text = "\(item.name)\n\(item.mobile)\n\(item.city)\n\(item.address)"
            if addressItem != nil {
                cell.selectBtn.image = UIImage(named: item.id == addressItem?.id ? "lab_pay_selected" : "lab_pay_normal")
            } else {
                cell.selectBtn.image = UIImage(named: item.isDefault == 1 ? "lab_pay_selected" : "lab_pay_normal")
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = viewModel?.element(at: indexPath.section) as? AddressItem {
            if didSelectAddressHandler != nil {
                didSelectAddressHandler?(item)
                backBtnTapHandler()
            } else {
                let addVC = GoodsAddressAddViewController()
                addVC.addressItem = item
                UIManager.push(to: addVC)
            }
        }
    }
    
    fileprivate class InnerViewModel: NetworkViewModel {
        override var parameters: [String : Any]? { ["id": ""] }
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([AddressItem].self, from: data)
                if isLoadingMore {
                    var list = [AddressItem]()
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
        lazy var selectBtn = UIImageView().then {
            $0.image = UIImage(named: "lab_pay_normal")
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.width.height.equalTo(24)
                make.centerY.equalToSuperview()
            }
        }
        
        lazy var nameLabel = UILabel().then {
            $0.textColor = .black
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.numberOfLines = 0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(selectBtn.snp.right).offset(20)
                make.right.equalTo(-80)
                make.height.centerY.equalToSuperview()
            }
        }
        
        lazy var lineView = UIView().then {
            $0.backgroundColor = color(0, 0, 0, 0.1)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
        }
        
        var addressItem: AddressItem?
        lazy var editBtn = UIButton().then {
            $0.setTitle("编辑", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
            $0.addAction(UIAction() {[unowned self] _ in
                let addVC = GoodsAddressAddViewController()
                addVC.addressItem = addressItem
                UIManager.push(to: addVC)
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.equalTo(28)
                make.height.equalTo(20)
                make.centerY.equalToSuperview()
            }
        }
    }
}
