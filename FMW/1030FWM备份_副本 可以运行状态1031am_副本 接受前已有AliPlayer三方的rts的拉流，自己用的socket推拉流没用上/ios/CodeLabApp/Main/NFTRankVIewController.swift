//
//  NFTRankVIewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/21.
//

import Foundation
import BasicUIKit

struct NFTRankItem: Codable, IdentifierElement {
    var score: Int?
    var nftInfo: NFTInfo?
    
    var uniqueIdentifier: String { (nftInfo?.id).nonnull }
    
    enum CodingKeys: String, CodingKey {
        case score
        case nftInfo = "goods"
    }
}

final class NFTRankViewController: TableViewController {
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        let viewModel = InnerViewModel()
        viewModel.listKey = "ranks"
        viewModel.url = MainAPI.nftRank.rawValue
        self.viewModel = viewModel
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "数藏趋势"
        customBar.backgroundColor = .clear
        
        let _ = LinearGradientView().then {
            $0.startPoint = CGPoint(x: 0, y: 0)
            $0.endPoint = CGPoint(x: 0, y: 1)
            $0.colors = [color(255, 255, 255), color(243, 243, 243)]
            view.insertSubview($0, belowSubview: customBar)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        if let tableView = tableView {
            view.addSubview(tableView)
            tableView.backgroundColor = .clear
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
            tableView.register(cellWithClass: NFTRankListCell.self)
            tableView.register(cellWithClass: NFTRankTopTableViewCell.self)
            tableView.snp.makeConstraints({ make in
                make.top.equalTo(customBar.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            })
        }
    }
    
    //MARK: - Cell
    override func numberOfSections(in tableView: UITableView) -> Int {
        let count = (viewModel?.numberOfElements).nonnull
        if count == 0 {
            return count
        } else if count < 3 {
            return 1
        }
        return count - 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 261 : 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: NFTRankTopTableViewCell.self)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.bindModels(item1: viewModel?.element(at: 0) as? NFTRankItem,
                            item2: viewModel?.element(at: 1) as? NFTRankItem,
                            item3: viewModel?.element(at: 2) as? NFTRankItem)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withClass: NFTRankListCell.self)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.titleLabel.text = "\(indexPath.section + 3)"
        cell.bindModel(viewModel?.element(at: indexPath.section + 2) as? NFTRankItem, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0, let item = viewModel?.element(at: indexPath.section + 2) as? NFTRankItem {
            UIManager.push(to: NFTDetailViewController().then { $0.nftInfo = item.nftInfo })
        }
    }
    
    class NFTRankTopTableViewCell: UITableViewCell {
        lazy var indexLabel1 = UILabel().then {
            $0.text = "1ST"
            $0.font = .gothamBlackItalicFont(ofSize: 18)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.lessThanOrEqualTo(40)
                make.height.equalTo(25)
                make.top.equalTo(20)
            }
        }
        
        lazy var badgeView1 = UIImageView().then {
            $0.image = UIImage(named: "lab_nft_rank_badge_1")
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(14)
                make.height.equalTo(9)
                make.centerX.equalTo(indexLabel1)
                make.top.equalTo(indexLabel1.snp.bottom)
            }
        }
        
        lazy var backView1 = UIImageView().then {
            $0.image = UIImage(named: "lab_nft_rank_1")
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rankTop1Tap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(90)
                make.centerX.equalTo(indexLabel1)
                make.top.equalTo(indexLabel1.snp.bottom).offset(14)
            }
        }
        
        lazy var iconView1 = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(76)
                make.centerX.equalTo(backView1)
                make.centerY.equalTo(backView1).offset(-2)
            }
        }
        
        lazy var titleLabel1 = UILabel().then {
            $0.font = .semiboldPingFangSCFont(ofSize: 16)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(indexLabel1)
                make.width.lessThanOrEqualTo(90)
                make.height.equalTo(22)
                make.top.equalTo(backView1.snp.bottom).offset(14)
            }
        }
        
        lazy var descLabel1 = UILabel().then {
            $0.font = .gothamMediumFont(ofSize: 10)
            $0.textColor = color(0, 0, 0, 0.3)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(indexLabel1)
                make.width.lessThanOrEqualTo(90)
                make.height.equalTo(14)
                make.top.equalTo(titleLabel1.snp.bottom).offset(3)
            }
        }
        
        lazy var scoreLabel1 = UIButton().then {
            $0.setImage(UIImage(named: "lab_nft_main_mark"), for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .gothamMediumFont(ofSize: 14)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(indexLabel1)
                make.width.lessThanOrEqualTo(90)
                make.height.lessThanOrEqualTo(30)
                make.top.equalTo(descLabel1.snp.bottom).offset(12)
            }
        }
        
        lazy var indexLabel2 = UILabel().then {
            $0.text = "2ST"
            $0.font = .gothamBlackItalicFont(ofSize: 18)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView2)
                make.width.lessThanOrEqualTo(40)
                make.height.equalTo(25)
                make.bottom.equalTo(backView2.snp.top).offset(-14)
            }
        }
        
        lazy var backView2 = UIImageView().then {
            $0.image = UIImage(named: "lab_nft_rank_2")
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rankTop2Tap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(64)
                make.left.equalTo(45)
                make.bottom.equalTo(backView1)
            }
        }
        
        lazy var iconView2 = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(50)
                make.centerX.equalTo(backView2)
                make.centerY.equalTo(backView2).offset(-2)
            }
        }
        
        lazy var titleLabel2 = UILabel().then {
            $0.font = .semiboldPingFangSCFont(ofSize: 16)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(indexLabel2)
                make.width.lessThanOrEqualTo(90)
                make.height.equalTo(22)
                make.top.equalTo(backView2.snp.bottom).offset(14)
            }
        }
        
        lazy var descLabel2 = UILabel().then {
            $0.font = .regularPingFangSCFont(ofSize: 10)
            $0.textColor = color(0, 0, 0, 0.3)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(indexLabel2)
                make.width.lessThanOrEqualTo(90)
                make.height.equalTo(14)
                make.top.equalTo(titleLabel2.snp.bottom).offset(3)
            }
        }
        
        lazy var scoreLabel2 = UIButton().then {
            $0.setImage(UIImage(named: "lab_nft_main_mark"), for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .gothamMediumFont(ofSize: 14)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(indexLabel2)
                make.width.lessThanOrEqualTo(90)
                make.height.lessThanOrEqualTo(30)
                make.top.equalTo(descLabel2.snp.bottom).offset(12)
            }
        }
        
        lazy var indexLabel3 = UILabel().then {
            $0.text = "3ST"
            $0.font = .gothamBlackItalicFont(ofSize: 18)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView3)
                make.width.lessThanOrEqualTo(40)
                make.height.equalTo(25)
                make.bottom.equalTo(backView3.snp.top).offset(-14)
            }
        }
        
        lazy var backView3 = UIImageView().then {
            $0.image = UIImage(named: "lab_nft_rank_2")
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rankTop3Tap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(64)
                make.right.equalTo(-45)
                make.bottom.equalTo(backView1)
            }
        }
        
        lazy var iconView3 = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(50)
                make.centerX.equalTo(backView3)
                make.centerY.equalTo(backView3).offset(-2)
            }
        }
        
        lazy var titleLabel3 = UILabel().then {
            $0.font = .semiboldPingFangSCFont(ofSize: 16)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(indexLabel3)
                make.width.lessThanOrEqualTo(90)
                make.height.equalTo(22)
                make.top.equalTo(backView3.snp.bottom).offset(14)
            }
        }
        
        lazy var descLabel3 = UILabel().then {
            $0.font = .regularPingFangSCFont(ofSize: 10)
            $0.textColor = color(0, 0, 0, 0.3)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(indexLabel3)
                make.width.lessThanOrEqualTo(90)
                make.height.equalTo(14)
                make.top.equalTo(titleLabel3.snp.bottom).offset(3)
            }
        }
        
        lazy var scoreLabel3 = UIButton().then {
            $0.setImage(UIImage(named: "lab_nft_main_mark"), for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .gothamMediumFont(ofSize: 14)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(indexLabel3)
                make.width.lessThanOrEqualTo(90)
                make.height.lessThanOrEqualTo(30)
                make.top.equalTo(descLabel3.snp.bottom).offset(12)
            }
        }
        
        @objc fileprivate func rankTop1Tap() {
            UIManager.push(to: NFTDetailViewController().then { $0.nftInfo = topItem1 })
        }
        
        @objc fileprivate func rankTop2Tap() {
            UIManager.push(to: NFTDetailViewController().then { $0.nftInfo = topItem2 })
        }
        
        @objc fileprivate func rankTop3Tap() {
            UIManager.push(to: NFTDetailViewController().then { $0.nftInfo = topItem3 })
        }
        
        fileprivate var topItem1: NFTInfo?
        fileprivate var topItem2: NFTInfo?
        fileprivate var topItem3: NFTInfo?
        
        func bindModels(item1: NFTRankItem?, item2: NFTRankItem?, item3: NFTRankItem?) {
            if let item = item1, let info = item.nftInfo {
                topItem1 = info
                titleLabel1.text = info.name
                descLabel1.text = info.minSalePrice.nonnull > 0 ? "最低价 \(info.minSalePrice.nonnull)积分" : "暂无出售"
                scoreLabel1.setTitle(info.minDealPrice.nonnull > 0 ? " \(info.minDealPrice.nonnull)积分" : " 暂无成交", for: .normal)
                iconView1.setWebImage(url: OSSUploader.imageNFTURLFor((info.cover?.guid).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
            }
            
            if let item = item2, let info = item.nftInfo {
                topItem2 = info
                titleLabel2.text = info.name
                descLabel2.text = info.minSalePrice.nonnull > 0 ? "最低价 \(info.minSalePrice.nonnull)积分" : "暂无出售"
                scoreLabel2.setTitle(info.minDealPrice.nonnull > 0 ? " \(info.minDealPrice.nonnull)积分" : " 暂无成交", for: .normal)
                iconView2.setWebImage(url: OSSUploader.imageNFTURLFor((info.cover?.guid).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
            }
            
            if let item = item3, let info = item.nftInfo {
                topItem3 = info
                titleLabel3.text = info.name
                descLabel3.text = info.minSalePrice.nonnull > 0 ? "最低价 \(info.minSalePrice.nonnull)积分" : "暂无出售"
                scoreLabel3.setTitle(info.minDealPrice.nonnull > 0 ? " \(info.minDealPrice.nonnull)积分" : " 暂无成交", for: .normal)
                iconView3.setWebImage(url: OSSUploader.imageNFTURLFor((info.cover?.guid).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
            }
        }
    }
    
    fileprivate class InnerViewModel: NetworkViewModel {
        override var parameters: [String : Any]? { ["rankType": "all"] }
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([NFTRankItem].self, from: data)
                if isLoadingMore {
                    var list = [NFTRankItem]()
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

    class NFTRankListCell: UITableViewCell {
        lazy var backView = UIView().then {
            $0.backgroundColor = color(252, 252, 252)
            $0.layer.cornerRadius = 13.0
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1.0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalTo(18)
                make.right.equalTo(-18)
                make.height.equalTo(68)
            }
        }
        
        lazy var titleLabel = UILabel().then {
            $0.font = .gothamBlackItalicFont(ofSize: 16)
            $0.textColor = .black
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.width.lessThanOrEqualTo(30)
                make.height.equalTo(22)
                make.centerY.equalToSuperview()
            }
        }
        
        lazy var avatarView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(52)
                make.left.equalTo(titleLabel.snp.right).offset(10)
                make.centerY.equalToSuperview()
            }
        }
        
        lazy var nameLabel = UILabel().then {
            $0.font = .semiboldPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(avatarView.snp.right).offset(10)
                make.right.lessThanOrEqualTo(-100)
                make.height.equalTo(20)
                make.top.equalTo(14)
            }
        }
        
        lazy var descLabel = UILabel().then {
            $0.font = .gothamMediumFont(ofSize: 12)
            $0.textColor = color(0, 0, 0, 0.5)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(nameLabel)
                make.right.lessThanOrEqualTo(-100)
                make.height.equalTo(17)
                make.top.equalTo(nameLabel.snp.bottom).offset(4)
            }
        }
        
        lazy var scoreLabel1 = UIButton().then {
            $0.setImage(UIImage(named: "lab_nft_main_mark"), for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .gothamMediumFont(ofSize: 14)
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-18)
                make.width.lessThanOrEqualTo(100)
                make.height.lessThanOrEqualTo(30)
                make.centerY.equalTo(nameLabel)
            }
        }
        
        lazy var scoreLabel2 = UILabel().then {
            $0.font = .gothamMediumFont(ofSize: 12)
            $0.textAlignment = .right
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-18)
                make.width.lessThanOrEqualTo(100)
                make.height.lessThanOrEqualTo(20)
                make.centerY.equalTo(descLabel)
            }
        }
        
        var nftInfo: NFTInfo?
        func bindModel(_ item: NFTRankItem?, indexPath: IndexPath) {
            if let item = item, let info = item.nftInfo {
                nftInfo = info
                avatarView.setWebImage(url: OSSUploader.imageNFTURLFor((info.cover?.guid).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
                nameLabel.text = info.name
                descLabel.text = info.minSalePrice.nonnull > 0 ? "最低价 \(info.minSalePrice.nonnull)积分" : "暂无出售"
                scoreLabel1.setTitle(info.minDealPrice.nonnull > 0 ? " \(info.minDealPrice.nonnull)积分" : " 暂无成交", for: .normal)
                let percent = info.pointsRase.nonnull*100
                scoreLabel2.text = percent >= 0 ? "+\(Int(percent))%" : "\(Int(percent))%"
                scoreLabel2.textColor = percent <= 0 ? color(58, 230, 93) : color(255, 38, 111)
            }
        }
    }
}
