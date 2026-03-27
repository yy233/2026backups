//
//  NFTOwnProxyListViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/15.
//

import Foundation
import BasicKit
import UIKit
import BasicUIKit
import APIKit

final class NFTOwnProxyContainerViewController: SegmentViewController {
    override func viewDidLoad() {
        segmentStyle = .navigation
        segmentBarHeight = 40
        super.viewDidLoad()
        customBackBtn.isHidden = false

        bind(segments: [NFTOwnProxyListViewController(), NFTOwnSaleListViewController()])
    }
}

fileprivate class NFTOwnProxyListViewController: TableViewController, SegmentBarItem {
    
    //MARK: - Segment
    var segmentTitle: String {
        return "委托购买"
    }
    
    var normalColor: UIColor { color(0, 0, 0, 0.3) }
    var selectColor: UIColor { .black }
    var font: UIFont { .mediumPingFangSCFont(ofSize: 18) }
    var selectFont: UIFont { .semiboldPingFangSCFont(ofSize: 18) }
    var viewController: UIViewController { self }
    var segmentPadding: CGFloat { 20 }
    var segmentMargin: CGFloat { 20 }
    var segmentIndicatorEnable: Bool { false }
    
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = InnerViewModel()
        viewModel.url = NFTAPI.ownProxyList.rawValue
        self.viewModel = viewModel
        super.viewDidLoad()
        view.backgroundColor = color(245, 245, 245)
        
        tableView?.backgroundColor = view.backgroundColor
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        tableView?.register(cellWithClass: TableViewCell.self)
        tableView?.snp.makeConstraints({ make in
            make.top.bottom.left.right.equalToSuperview()
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TableViewCell.self)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = tableView.backgroundColor
        cell.backgroundColor = tableView.backgroundColor
        
        if let item = viewModel?.element(at: indexPath.section) as? ProxyItem {
            cell.nftImageView.setWebImage(url: OSSUploader.imageNFTURLFor((item.nftInfo?.cover?.guid).nonnull, crop: .medium), cornerRadius: 8.0*3, finalSize: CGSize(width: 100*3.0, height: 100*3.0))
            cell.nftNameLabel.text = item.nftInfo?.name
            cell.priceShowLabel.text = "\(item.points.nonnull)积分"
            cell.countShowLabel.text = "\(item.num.nonnull)"
            
            if item.num == item.dealNum {
                cell.statueBtn.backgroundColor = color(230, 250, 234)
                cell.statueBtn.setTitle("已完成", for: .normal)
                cell.statueBtn.setTitleColor(color(58, 230, 93), for: .normal)
            } else if item.dealNum.nonnull > 0 {
                cell.statueBtn.backgroundColor = color(230, 247, 255)
                cell.statueBtn.setTitle("部分完成(\(item.dealNum.nonnull)/\(item.num.nonnull)", for: .normal)
                cell.statueBtn.setTitleColor(color(51, 186, 255), for: .normal)
            } else {
                cell.statueBtn.backgroundColor = color(255, 229, 237)
                cell.statueBtn.setTitle("委托中", for: .normal)
                cell.statueBtn.setTitleColor(color(255, 38, 111), for: .normal)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = viewModel?.element(at: indexPath.section) as? ProxyItem {
            if item.dealNum != item.num {
                Alert.show(title: "确认取消委托吗？", message: "已购买部分不退", submitBtnTapHandler: {
                    HUD.show()
                    Network.request(NFTAPI.proxyCancel, parameters: ["id": item.id]).responseData { response in
                        HUD.hide()
                        if let error = response.error {
                            Toast.toast(title: error.localizedDescription)
                        } else {
                            Toast.toast(title: "已取消")
                            item.dealNum = item.num
                            tableView.reloadData()
                        }
                    }
                })
            } else {
                UIManager.push(to: NFTDetailViewController().then { $0.nftInfo = item.nftInfo })
            }
        }
    }
    
    fileprivate class ProxyItem: Codable, IdentifierElement {
        var id: String = ""
        var nftInfo: NFTInfo?
        var points: Int?
        var num: Int?
        var dealNum: Int?
        var commissionTime: String?
        var status: Int?
        var uniqueIdentifier: String { id }
        
        enum CodingKeys: String, CodingKey {
            case id = "commissionId"
            case nftInfo = "goods"
            case points
            case num
            case dealNum
            case commissionTime
            case status
        }
    }
    
    fileprivate class InnerViewModel: NetworkViewModel {
        override var parameters: [String : Any]? { ["id": ""] }
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([ProxyItem].self, from: data)
                if isLoadingMore {
                    var list = [ProxyItem]()
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
            $0.layer.masksToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.bottom.equalToSuperview()
            }
        }
        
        lazy var nftImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.equalTo(16)
                make.width.height.equalTo(100)
            }
        }
        
        lazy var nftNameLabel = UILabel().then {
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 18)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(nftImageView.snp.right).offset(16)
                make.right.equalTo(-16)
                make.height.equalTo(25)
                make.top.equalTo(nftImageView.snp.top).offset(9)
            }
        }
        
        lazy var priceLabel = UILabel().then {
            $0.text = "委托价格"
            $0.textColor = color(0, 0, 0, 0.4)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(nftNameLabel)
                make.width.equalTo(56)
                make.height.equalTo(20)
                make.top.equalTo(nftNameLabel.snp.bottom).offset(12)
            }
        }
        
        lazy var countLabel = UILabel().then {
            $0.text = "委托数量"
            $0.textColor = color(0, 0, 0, 0.4)
            $0.font = .regularPingFangSCFont(ofSize: 14)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(nftNameLabel)
                make.width.equalTo(56)
                make.height.equalTo(20)
                make.top.equalTo(priceLabel.snp.bottom).offset(6)
            }
        }
        
        lazy var priceShowLabel = UILabel().then {
            $0.font = .gothamMediumFont(ofSize: 14)
            $0.textColor = color(255, 38, 111)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(priceLabel.snp.right).offset(6)
                make.right.equalTo(-16)
                make.centerY.equalTo(priceLabel)
                make.height.equalTo(20)
            }
        }
        
        lazy var countShowLabel = UILabel().then {
            $0.font = .mediumPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(countLabel.snp.right).offset(6)
                make.right.equalTo(-16)
                make.centerY.equalTo(countLabel)
                make.height.equalTo(20)
            }
        }
        
        lazy var statueBtn = UIButton().then {
            $0.backgroundColor = color(255, 229, 237)
            $0.layer.cornerRadius = 10.0
            $0.layer.maskedCorners = [.layerMinXMaxYCorner]
            $0.setTitle("委托中", for: .normal)
            $0.setTitleColor(color(255, 38, 111), for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 10)
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.right.equalToSuperview()
                make.width.lessThanOrEqualTo(200)
                make.height.equalTo(22)
            }
        }
    }
}

fileprivate class NFTOwnSaleListViewController: TableViewController, SegmentBarItem {
    
    //MARK: - Segment
    var segmentTitle: String {
        return "寄售列表"
    }
    
    var normalColor: UIColor { color(0, 0, 0, 0.3) }
    var selectColor: UIColor { .black }
    var font: UIFont { .mediumPingFangSCFont(ofSize: 18) }
    var selectFont: UIFont { .semiboldPingFangSCFont(ofSize: 18) }
    var viewController: UIViewController { self }
    var segmentPadding: CGFloat { 20 }
    var segmentMargin: CGFloat { 20 }
    var segmentIndicatorEnable: Bool { false }
    
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = NFTOwnProxyListViewController.InnerViewModel()
        viewModel.url = NFTAPI.ownSaleList.rawValue
        self.viewModel = viewModel
        super.viewDidLoad()
        view.backgroundColor = color(245, 245, 245)
        
        tableView?.backgroundColor = view.backgroundColor
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        tableView?.register(cellWithClass: TableViewCell.self)
        tableView?.snp.makeConstraints({ make in
            make.top.bottom.left.right.equalToSuperview()
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TableViewCell.self)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = tableView.backgroundColor
        cell.backgroundColor = tableView.backgroundColor
        
        if let item = viewModel?.element(at: indexPath.section) as? NFTOwnProxyListViewController.ProxyItem {
            cell.nftImageView.setWebImage(url: OSSUploader.imageNFTURLFor((item.nftInfo?.cover?.guid).nonnull, crop: .medium), cornerRadius: 8.0*3, finalSize: CGSize(width: 100*3.0, height: 100*3.0))
            cell.nftNameLabel.text = item.nftInfo?.name
            cell.priceShowLabel.text = "\(item.points.nonnull)"
            cell.priceTextLabel.isHidden = false
            
            if item.status == 3 {
                cell.statueBtn.backgroundColor = color(230, 250, 234)
                cell.statueBtn.setTitle("已完成", for: .normal)
                cell.statueBtn.setTitleColor(color(58, 230, 93), for: .normal)
            } else if item.status == 2 {
                cell.statueBtn.backgroundColor = color(230, 247, 255)
                cell.statueBtn.setTitle("已取消", for: .normal)
                cell.statueBtn.setTitleColor(color(51, 186, 255), for: .normal)
            } else {
                cell.statueBtn.backgroundColor = color(255, 229, 237)
                cell.statueBtn.setTitle("寄售中", for: .normal)
                cell.statueBtn.setTitleColor(color(255, 38, 111), for: .normal)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = viewModel?.element(at: indexPath.section) as? NFTOwnProxyListViewController.ProxyItem {
            if item.status != 2, item.status != 3 {
                Alert.show(title: "确认取消寄售吗？", message: "已购买部分不退", submitBtnTapHandler: {
                    HUD.show()
                    Network.request(NFTAPI.nftCancelSale, parameters: ["id": item.id]).responseData { response in
                        HUD.hide()
                        if let error = response.error {
                            Toast.toast(title: error.localizedDescription)
                        } else {
                            Toast.toast(title: "已取消寄售")
                            item.status = 2
                            tableView.reloadData()
                        }
                    }
                })
            } else {
                UIManager.push(to: NFTDetailViewController().then { $0.nftInfo = item.nftInfo })
            }
        }
    }
    
    fileprivate class TableViewCell: UITableViewCell {
        lazy var backView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10.0
            $0.layer.masksToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.bottom.equalToSuperview()
            }
        }
        
        lazy var nftImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.equalTo(16)
                make.width.height.equalTo(100)
            }
        }
        
        lazy var nftNameLabel = UILabel().then {
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 18)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(nftImageView.snp.right).offset(16)
                make.right.equalTo(-16)
                make.height.equalTo(25)
                make.top.equalTo(nftImageView.snp.top).offset(9)
            }
        }
        
        lazy var priceShowLabel = UILabel().then {
            $0.font = .gothamMediumFont(ofSize: 26)
            $0.textColor = color(255, 38, 111)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(nftNameLabel)
                make.width.lessThanOrEqualTo(150)
                make.top.equalTo(nftNameLabel.snp.bottom).offset(16)
                make.height.equalTo(34)
            }
        }
        
        lazy var priceTextLabel = UILabel().then {
            $0.text = "积分"
            $0.font = .regularPingFangSCFont(ofSize: 18)
            $0.textColor = color(255, 38, 111)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(priceShowLabel.snp.right).offset(10)
                make.width.lessThanOrEqualTo(50)
                make.bottom.equalTo(priceShowLabel)
                make.height.equalTo(25)
            }
        }
        
        lazy var statueBtn = UIButton().then {
            $0.backgroundColor = color(255, 229, 237)
            $0.layer.cornerRadius = 10.0
            $0.layer.maskedCorners = [.layerMinXMaxYCorner]
            $0.setTitle("寄售中", for: .normal)
            $0.setTitleColor(color(255, 38, 111), for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 14)
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.right.equalToSuperview()
                make.width.lessThanOrEqualTo(200)
                make.height.equalTo(40)
            }
        }
    }
}
