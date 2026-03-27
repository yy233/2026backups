//
//  CountryCodeViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/8/23.
//

import Foundation
import BasicUIKit
import BasicKit

final class CountryCodeViewController: TableViewController {
    
    var didSelectItemHandler: ((CountryItem) -> Void)?
    private var list = [CountrySectionItem]()
    
    override func loadView() {
        tableViewStyle = .plain
        super.loadView()
    }
    
    override func viewDidLoad() {
        showRefreshHeader = false
        showLoadMoreFooter = false
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "选择国家和地区"
        
        tableView?.register(cellWithClass: CountryCodeTableCell.self)
        tableView?.register(headerFooterViewClassWith: CountryCodeHeaderView.self)
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        tableView?.snp.makeConstraints({ make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(customBar.snp.bottom)
        })
        
        if let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "CountryCode", ofType: "json").nonnull)),
           let list = try? JSONDecoder().decode([CountrySectionItem].self, from: data) {
            self.list.append(contentsOf: list)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list[section].list.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = list[section]
        if section.name.isEmpty { return nil }
        let headerView = tableView.dequeueReusableHeaderFooterView(withClass: CountryCodeHeaderView.self)
        headerView.titleLabel.text = section.name
        headerView.contentView.backgroundColor = color(244, 244, 244)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = list[section]
        if section.name.isEmpty { return CGFloat.leastNormalMagnitude }
        return 32
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CountryCodeTableCell.self)
        cell.contentView.backgroundColor = .white
        let item = list[indexPath.section].list[indexPath.row]
        cell.titleLabel.text = item.countryName + "  +" + item.areaCode
        cell.lineView.isHidden = indexPath.row == list[indexPath.section].list.count - 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItemHandler?(list[indexPath.section].list[indexPath.row])
        dismiss(animated: true)
    }
}

fileprivate struct CountrySectionItem: Codable {
    var name: String = ""
    var list: [CountryItem] = []
}

struct CountryItem: Codable {
    var areaCode = ""
    var countryName = ""
}

fileprivate class CountryCodeHeaderView: UITableViewHeaderFooterView {
    lazy var titleLabel = UILabel().then {
        $0.textColor = color(21, 21, 21, 0.5)
        $0.font = .mediumPingFangSCFont(ofSize: 14)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-16)
        }
    }
}

fileprivate class CountryCodeTableCell: UITableViewCell {
    lazy var titleLabel = UILabel().then {
        $0.textColor = color(21, 21, 21)
        $0.font = .mediumPingFangSCFont(ofSize: 14)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-16)
        }
    }
    
    lazy var lineView = UIView.singleLine().then {
        $0.backgroundColor = color(0, 0, 0, 0.05)
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
    }
}
