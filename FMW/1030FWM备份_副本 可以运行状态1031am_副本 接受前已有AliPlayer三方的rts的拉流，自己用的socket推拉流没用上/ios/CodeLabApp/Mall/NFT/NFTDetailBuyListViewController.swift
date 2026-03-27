//
//  NFTDetailBuyListViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/15.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import APIKit

final class NFTDetailBuyListViewController: TableViewController {
    
    var nftInfo: NFTInfo?
    
    private let contentView = UIView()
    private let submitBtn = UIButton()
    private let countLabel = UILabel()
    private let priceBtn = UIButton()
    private let priceArrowView = UIImageView()
    private let numberBtn = UIButton()
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.location(in: view).y < contentView.frame.minY {
            dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        triggerRefreshAutomatic = true
        triggerLoadMoreAutomatic = true
        var sort = 0
        let viewModel = InnerViewModel()
        viewModel.url = NFTAPI.nftSaleList.rawValue
        viewModel.innerPara = ["goodsId": (nftInfo?.id).nonnull, "sortField": "no", "sort": sort]
        self.viewModel = viewModel
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        contentView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(UIManager.shared.screenHeight - 200 > 501 ? 501 : UIManager.shared.screenHeight - 200)
            }
        }
        
        let titleLabel = UILabel().then {
            $0.text = "寄售列表"
            $0.textColor = .black
            $0.font = .mediumPingFangSCFont(ofSize: 18)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.width.lessThanOrEqualTo(150)
                make.height.lessThanOrEqualTo(50)
                make.top.equalTo(26)
            }
        }
        
        countLabel.do {
            $0.textColor = color(0, 0, 0, 0.4)
            $0.font = .regularPingFangSCFont(ofSize: 12)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(titleLabel.snp.right).offset(2)
                make.width.lessThanOrEqualTo(150)
                make.centerY.height.equalTo(titleLabel)
            }
        }
        
        viewModelDidFinishLoad = {[weak self] _ in
            self?.countLabel.text = "（\(viewModel.numberOfElements)份）"
        }
        
        numberBtn.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
            $0.setTitle("编号", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 12)
            $0.addAction(UIAction() {[unowned self] _ in
                numberBtn.setTitleColor(.black, for: .normal)
                numberBtn.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 12)
                priceBtn.setTitleColor(color(147, 148, 152), for: .normal)
                priceBtn.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
                viewModel.innerPara = ["goodsId": (nftInfo?.id).nonnull, "sortField": "no", "sort": sort]
                viewModel.refresh(shouldLoadCache: false)
                tableView?.scrollToTop()
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(titleLabel)
                make.width.equalTo(24)
                make.height.equalTo(17)
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
            }
        }
        
        priceBtn.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -30)
            $0.setTitle("价格", for: .normal)
            $0.setTitleColor(color(147, 148, 152), for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
            $0.addAction(UIAction() {[unowned self] _ in
                sort = sort == 1 ? -1 : 1
                priceBtn.setTitleColor(.black, for: .normal)
                priceBtn.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 12)
                numberBtn.setTitleColor(color(147, 148, 152), for: .normal)
                numberBtn.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
                priceArrowView.transform = sort != 1 ? .identity : .init(rotationAngle: .pi)
                viewModel.innerPara = ["goodsId": (nftInfo?.id).nonnull, "sortField": "points", "sort": sort]
                viewModel.refresh(shouldLoadCache: false)
                tableView?.scrollToTop()
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(numberBtn.snp.right).offset(28)
                make.width.equalTo(24)
                make.height.equalTo(17)
                make.centerY.equalTo(numberBtn)
            }
        }
        
        priceArrowView.do {
            $0.image = UIImage(named: "lab_nft_buy_price")
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(14)
                make.left.equalTo(priceBtn.snp.right).offset(6)
                make.centerY.equalTo(priceBtn)
            }
        }
        
        let _ = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "ge_icon_modal_dismiss"), for: .normal)
            $0.addTarget(self, action: #selector(dismissBtnTap), for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-20)
                make.width.height.equalTo(20)
                make.centerY.equalTo(titleLabel)
            }
        }
        
        submitBtn.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 12
            $0.setTitle("委托购买", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 16)
            $0.addAction(UIAction() {[unowned self] _ in
                dismiss(animated: true) {
                    UIManager.push(to: NFTDetailBuyProxyViewController().then {
                        $0.nftInfo = self.nftInfo
                    })
                }
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.bottom.equalTo(UIManager.shared.isNotchScreen ? -42 : -18)
                make.height.equalTo(44)
            }
        }
        
        if let tableView = tableView {
            tableView.removeFromSuperview()
            contentView.addSubview(tableView)
            tableView.register(cellWithClass: TableCell.self)
            tableView.snp.makeConstraints({ make in
                make.left.right.equalToSuperview()
                make.top.equalTo(priceBtn.snp.bottom).offset(16)
                make.bottom.equalTo(submitBtn.snp.top).offset(-15)
            })
        }
    }
    
    @objc fileprivate func dismissBtnTap() {
        dismiss(animated: true)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        view.backgroundColor = color(0, 0, 0, 0.5)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        view.backgroundColor = .clear
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TableCell.self)
        cell.contentView.backgroundColor = .white
        cell.selectionStyle = .none
        if let item = viewModel?.element(at: indexPath.section) as? NFTSaleItem {
            cell.avatarView.setWebImage(url: OSSUploader.avatarURLFor((item.user?.avatar).nonnull, crop: .small), cornerRadius: 150, finalSize: CGSize(width: 300, height: 300))
            cell.nameLabel.text = item.user?.userName
            cell.nftNameLabel.text = (item.nftInfo?.name).nonnull + "#\(item.goodsNum.nonnull)"
            cell.priceLabel.text = "\(item.points.nonnull)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = viewModel?.element(at: indexPath.section) as? NFTSaleItem {
            if item.user?.userID == AppContext.current.userID {
                Alert.show(title: "取消寄售?", message: "该数字藏品是由你寄售的，是否需要取消", submitBtnTapHandler: {
                    HUD.show()
                    Network.request(NFTAPI.nftCancelSale, parameters: ["id": item.id]).responseData { response in
                        HUD.hide()
                        if let error = response.error {
                            Toast.toast(title: error.localizedDescription)
                        } else {
                            Toast.toast(title: "已取消寄售")
                            self.viewModel?.remove(item)
                            tableView.reloadData()
                        }
                    }
                })
            } else {
                dismiss(animated: true) {
                    UIManager.present(modal: NFTDetailBuySelectResultViewController().then {
                        $0.nftSale = item
                        $0.modalPresentationStyle = .overFullScreen
                    })
                }
            }
        }
    }
    
    fileprivate class InnerViewModel: NetworkViewModel {
        var innerPara: [String: Any]?
        override var parameters: [String : Any]? { innerPara }
        
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([NFTSaleItem].self, from: data)
                if isLoadingMore {
                    var list = [NFTSaleItem]()
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
    
    fileprivate class TableCell: UITableViewCell {
        lazy var avatarView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(52)
                make.left.equalTo(20)
                make.top.equalToSuperview()
            }
        }
        
        lazy var nameLabel = UILabel().then {
            $0.font = .mediumPingFangSCFont(ofSize: 16)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(avatarView.snp.right).offset(10)
                make.height.equalTo(22)
                make.right.equalTo(-100)
                make.top.equalTo(avatarView)
            }
        }
        
        lazy var nftMarkView = UIButton().then {
            $0.isEnabled = false
            $0.adjustsImageWhenDisabled = false
            $0.backgroundColor = color(230, 247, 255)
            $0.layer.cornerRadius = 9.0
            $0.setTitle("寄售", for: .normal)
            $0.setTitleColor(color(51, 185, 255), for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 10)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(nameLabel)
                make.height.equalTo(18)
                make.width.equalTo(32)
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
            }
        }
        
        lazy var nftNameLabel = UILabel().then {
            $0.font = .regularPingFangSCFont(ofSize: 14)
            $0.textColor = color(0, 0, 0, 0.4)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(nftMarkView.snp.right).offset(6)
                make.height.equalTo(20)
                make.right.equalTo(-100)
                make.centerY.equalTo(nftMarkView)
            }
        }
        
        lazy var priceLabel1 = UILabel().then {
            $0.text = "积分"
            $0.font = .mediumPingFangSCFont(ofSize: 10)
            $0.textColor = color(255, 38, 111)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-20)
                make.height.equalTo(14)
                make.width.equalTo(20)
                make.centerY.equalTo(avatarView)
            }
        }
        
        lazy var priceLabel = UILabel().then {
            $0.font = .gothamMediumFont(ofSize: 14)
            $0.textColor = color(255, 38, 111)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(priceLabel1.snp.left).offset(-3)
                make.height.equalTo(20)
                make.width.lessThanOrEqualTo(80)
                make.centerY.equalTo(avatarView)
            }
        }
    }
}
