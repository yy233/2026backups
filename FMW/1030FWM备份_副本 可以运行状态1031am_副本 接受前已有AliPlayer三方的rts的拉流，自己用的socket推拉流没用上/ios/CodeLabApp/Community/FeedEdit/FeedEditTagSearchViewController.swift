//
//  FeedEditTagSearchViewController.swift
//  Genz
//
//  Created by Sera on 2021/9/1.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import Combine
import APIKit

final class FeedEditTagSearchViewController: TableViewController {

    private let contentView = UIView()
    private let searchTextField = UITextField()
    
    var didSelectHandler: ((TopicItem?) -> Void)?
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.location(in: view).y < contentView.frame.minY {
            dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        let viewModel = InnerViewModel()
        viewModel.url = FeedAPI.tagSearch.rawValue
        self.viewModel = viewModel
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        super.viewDidLoad()
        view.backgroundColor = .clear
        
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
            $0.text = "搜索标签"
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
            $0.attributedPlaceholder = NSAttributedString(string: "输入标签名称", attributes: [.foregroundColor: color(0, 0, 0, 0.3)])
            $0.textAlignment = .left
            $0.keyboardType = .default
            $0.clearButtonMode = .always
            $0.delegate = self
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
        if section == 0 && !searchTextField.text.nonnull.isEmpty {
            return 34
        }
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && !searchTextField.text.nonnull.isEmpty {
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
        if let tag = viewModel?.element(at: indexPath.section) as? TopicItem {
            cell.bind(item: tag)
        }
        
        cell.createSelectHandler = {[weak self] topicItem in
            guard let strongSelf = self else { return }
            strongSelf.didSelectHandler?(topicItem)
            strongSelf.dismiss(animated: true, completion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tag = viewModel?.element(at: indexPath.section) as? TopicItem {
            if tag.id.isEmpty, let cell = tableView.cellForRow(at: indexPath) as? TagTableViewCell {
                cell.createBtnTapHandler()
            } else {
                didSelectHandler?(tag)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private class InnerViewModel: NetworkViewModel {
        var keyword: String = ""
        override var parameters: [String : Any]? {
            return ["name": keyword]
        }
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                var result = try JSONDecoder().decode([TopicItem].self, from: data)
                if !isLoadingMore, keyword.isNotEmpty, !result.contains(where: { $0.name == keyword }) {
                    result.append(TopicItem(id: "", name: keyword))
                }
                return result
            } catch {
                assertionFailure(error.localizedDescription)
            }
            return nil
        }
    }
}

extension FeedEditTagSearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isNotEmpty, textField.text.nonnull.appending(string).utf16.count > 15 {
            textField.unmarkText()
            return false
        }
        
        return true
    }
}

final class TagTableViewCell: UITableViewCell {
    lazy var nameLabel = UILabel().then {
        $0.textColor = color(11, 21, 38)
        $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
        $0.textAlignment = .left
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.height.equalToSuperview()
            make.right.lessThanOrEqualTo(createBtn.snp.left).offset(-10)
        }
    }
    
    lazy var createBtn = UIButton().then {
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -10, bottom: -15, right: -10)
        $0.setTitle("创建新标签", for: .normal)
        $0.setTitleColor(color(51, 186, 255), for: .normal)
        $0.titleLabel?.font = UIFont.regularPingFangSCFont(ofSize: 12)
        $0.addTarget(self, action: #selector(createBtnTapHandler), for: .touchUpInside)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(17)
        }
    }
    
    fileprivate var createSelectHandler: ((TopicItem) -> Void)?
    @objc fileprivate func createBtnTapHandler() {
        HUD.show()
        var name = nameLabel.text.nonnull
        name.removeFirst()
        Network.request(FeedAPI.tagCreate, parameters: ["name": name]).responseData { response in
            HUD.hide()
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let data = response.data?.jsonData(), let tag = try? JSONDecoder().decode(TopicItem.self, from: data) {
                self.createSelectHandler?(tag)
            }
        }
    }
    
    func bind(item: TopicItem) {
        nameLabel.text = "#\(item.name)"
        createBtn.isHidden = item.id.isNotEmpty
    }
}

final class TopicSectionHeaderView: UITableViewHeaderFooterView {
    lazy var nameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.mediumPingFangSCFont(ofSize: 16)
        $0.textAlignment = .left
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalToSuperview()
            make.right.equalTo(-16)
            make.height.equalTo(22)
        }
    }
}
