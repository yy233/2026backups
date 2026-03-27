//
//  FeedEditLocationSearchViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/8/29.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import Combine
import LocationKit
import CoreLocation

final class FeedEditLocationSearchViewController: TableViewController {

    private let contentView = UIView()
    private let searchTextField = UITextField()
    var didSelectHandler: ((LocationItem?) -> Void)?
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.location(in: view).y < contentView.frame.minY {
            dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        let viewModel = InnerViewModel()
        viewModel.url = FeedAPI.locationSearch.rawValue
        viewModel.lat = LocationContext.default.currentLocation?.coordinate.latitude ?? 0
        viewModel.lng = LocationContext.default.currentLocation?.coordinate.longitude ?? 0
        self.viewModel = viewModel
        triggerRefreshAutomatic = LocationContext.default.currentLocation != nil
        triggerLoadMoreAutomatic = true
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        LocationContext.default.startRequestLocation()
        LocationContext.default.addObserver(self)
        
        contentView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.shadowOffset = CGSize(width: 0, height: -2)
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
            $0.layer.shadowRadius = 4
            $0.layer.shadowOpacity = 1
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(UIManager.shared.screenHeight - 88)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(220, 223, 230)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(44)
                make.height.equalTo(3)
                make.top.equalTo(10)
            }
        }
        
        let titleLabel = UILabel().then {
            $0.text = "搜索地点"
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 16)
            $0.textAlignment = .center
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(22)
                make.top.equalTo(25)
            }
        }
        
        let _ = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setTitle("取消", for: .normal)
            $0.setTitleColor(color(141, 147, 166), for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
            $0.addAction(UIAction() {[unowned self] _ in
                dismiss(animated: true)
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(28)
                make.height.equalTo(20)
                make.left.equalTo(16)
                make.centerY.equalTo(titleLabel)
            }
        }
        
        let _ = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setTitle("完成", for: .normal)
            $0.setTitleColor(color(51, 186, 255), for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 14)
            $0.addAction(UIAction() {[unowned self] _ in
                dismiss(animated: true)
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(28)
                make.height.equalTo(20)
                make.right.equalTo(-16)
                make.centerY.equalTo(titleLabel)
            }
        }
        
        let searchBar = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 4.0
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(40)
            }
        }
        
        searchTextField.do {
            $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            $0.attributedPlaceholder = NSAttributedString(string: "输入地点名称", attributes: [.foregroundColor: color(0, 0, 0, 0.3)])
            $0.textAlignment = .left
            $0.keyboardType = .default
            $0.clearButtonMode = .always
            $0.textPublisher().delay(for: 1, scheduler: RunLoop.main).sink {[unowned self] result in
                viewModel.keyword = result
                viewModel.refresh(shouldLoadCache: false)
            }.store(in: &cancellableList)
            searchBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(15)
                make.top.bottom.equalTo(searchBar)
                make.right.equalTo(-15)
            }
        }
        
        if let tableView = tableView {
            tableView.removeFromSuperview()
            contentView.addSubview(tableView)
            tableView.register(headerFooterViewClassWith: TopicSectionHeaderView.self)
            tableView.register(cellWithClass: TagTableViewCell.self)
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIManager.shared.screenWidth, height: 40))
            tableView.snp.makeConstraints({ make in
                make.top.equalTo(searchBar.snp.bottom).offset(20)
                make.left.right.bottom.equalToSuperview()
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = .clear
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = color(0, 0, 0, 0.6)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && searchTextField.text.nonnull.isNotEmpty {
            return 34
        }
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && searchTextField.text.nonnull.isNotEmpty {
            let headerView = tableView.dequeueReusableHeaderFooterView(withClass: TopicSectionHeaderView.self)
            headerView.nameLabel.text = "搜索结果"
            return headerView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TagTableViewCell.self)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .white
        if let location = viewModel?.element(at: indexPath.section) as? LocationItem {
            cell.nameLabel.text = "\(location.name) · \(location.cname.nonnull) · \(location.address.nonnull)"
            cell.createBtn.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let location = viewModel?.element(at: indexPath.section) as? LocationItem {
            didSelectHandler?(location)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private class InnerViewModel: NetworkViewModel {
        var keyword: String = ""
        var lat = 0.0
        var lng = 0.0
        override var parameters: [String : Any]? {
            return ["name": keyword, "lat": lat, "lng": lng]
        }
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                return try JSONDecoder().decode([LocationItem].self, from: data)
            } catch {
                assertionFailure(error.localizedDescription)
            }
            return nil
        }
    }
}

extension FeedEditLocationSearchViewController: LocationObserver {
    func locationDidUpdate(location: CLLocation?, failed: FailedType) {
        (viewModel as? InnerViewModel)?.lat = location?.coordinate.latitude ?? 0
        (viewModel as? InnerViewModel)?.lng = location?.coordinate.longitude ?? 0
        viewModel?.refresh(shouldLoadCache: false)
    }
}
