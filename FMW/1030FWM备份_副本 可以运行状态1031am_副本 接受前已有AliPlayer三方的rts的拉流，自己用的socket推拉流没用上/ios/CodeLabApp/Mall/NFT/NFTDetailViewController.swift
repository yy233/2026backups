//
//  NFTDetailViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/13.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import APIKit
import DGCharts

final class NFTDetailViewController: BaseViewController {
        
    var nftInfo: NFTInfo?
    var goodsNum: String?
    
    private let nftImageView = UIImageView()
    private let nftNameLabel = UILabel()
    private let nftPriceLabel = UILabel()
    private let markBtn = UIButton()
    private let lineChartsView = LineChartView()
    private let hourBtn = UIButton()
    private let minuteBtn = UIButton()
    private let dayBtn = UIButton()
    private let weekBtn = UIButton()
    private let topChartsFormatter = TopAxisFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBar.backgroundColor = .clear
        customBackBtn.setImage(UIImage(named: "lab_navigation_back_white"), for: .normal)
        view.backgroundColor = .white
        
        markBtn.do {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "lab_nft_mark_normal"), for: .normal)
            $0.setImage(UIImage(named: "ge_icon_brand_detail_mark_selected"), for: .selected)
            $0.isSelected = nftInfo?.isMark == true
            $0.addTarget(self, action: #selector(markBtnTap(sender:)), for: .touchUpInside)
            customBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.centerY.equalTo(customBackBtn)
                make.width.height.equalTo(22)
            }
        }
        
        let _ = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "lab_child_community_share"), for: .normal)
            $0.addAction(UIAction() {_ in
                let items = ["我在这里发现一个超棒的藏品，快来下载吧http://www.fmwworld.com", URL(string: "http://www.fmwworld.com").nonnull]
                let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
                activityVC.modalPresentationStyle = .overFullScreen
                UIManager.present(modal: activityVC)
            }, for: .touchUpInside)
            customBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(markBtn.snp.left).offset(-15)
                make.centerY.equalTo(customBackBtn)
                make.width.height.equalTo(22)
            }
        }
        
        let bottomBar = UIView().then {
            $0.backgroundColor = .white
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(UIManager.shared.isNotchScreen ? 94 : 60)
            }
        }
        
        let officeBtn = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "ge_icon_goods_detail_office"), for: .normal)
            $0.addAction(UIAction() {_ in
                UIManager.push(to: ChatViewController().then { $0.chatWith = AppContext.assistorUserID })
            }, for: .touchUpInside)
            bottomBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.equalTo(16)
                make.width.equalTo(20)
                make.height.equalTo(35)
            }
        }
        
        let buyBtn = UIButton().then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 8
            $0.setTitle("我想要", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 16)
            $0.addTarget(self, action: #selector(buyBtnTap), for: .touchUpInside)
            bottomBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(170)
                make.right.equalTo(-16)
                make.top.equalTo(8)
                make.height.equalTo(44)
            }
        }
        
        let _ = UIButton().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 1.0
            $0.setTitle("寄售", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 16)
            $0.addAction(UIAction() {[weak self] _ in
                HUD.show()
                Network.request(NFTAPI.ownNFTList, parameters: ["uid": AppContext.current.userID, "goodsId": (self?.nftInfo?.id).nonnull, "offset": 0]).responseData { response in
                    HUD.hide()
                    if let error = response.error {
                        Toast.toast(title: error.localizedDescription)
                    } else if let data = (response.data?["list"] as? [Any])?.jsonString.data(using: .utf8),
                              let list = try? JSONDecoder().decode([UserNFTItem].self, from: data) {
                        if list.isEmpty {
                            UIManager.present(modal: NFTDetailSaleEmptyViewController().then {
                                $0.modalPresentationStyle = .overFullScreen
                            })
                        } else {
                            UIManager.present(modal: NFTDetailSaleListViewController().then {
                                $0.list = list
                                $0.nftInfo = self?.nftInfo
                                $0.modalPresentationStyle = .overFullScreen
                            })
                        }
                    }
                }
            }, for: .touchUpInside)
            bottomBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(officeBtn.snp.right).offset(20)
                make.right.equalTo(buyBtn.snp.left).offset(-8)
                make.centerY.equalTo(buyBtn)
                make.height.equalTo(44)
            }
        }
        
        let scrollView = UIScrollView().then {
            $0.backgroundColor = view.backgroundColor
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.contentInsetAdjustmentBehavior = .never
            $0.alwaysBounceVertical = true
            $0.delegate = self
            view.insertSubview($0, belowSubview: bottomBar)
            view.insertSubview($0, belowSubview: customBar)
            $0.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(bottomBar.snp.top)
            }
        }
        
        let contentView = UIView().then {
            $0.backgroundColor = view.backgroundColor
            scrollView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.width.equalTo(view)
            }
        }
        
        nftImageView.do {
            let imageHeight = max(1, (nftInfo?.cover?.ht).nonnull)/max(1, (nftInfo?.cover?.wt).nonnull)*UIManager.shared.screenWidth
            $0.setWebImage(url: OSSUploader.imageNFTURLFor((nftInfo?.cover?.guid).nonnull, crop: .origin))
            $0.contentMode = .scaleAspectFill
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(imageHeight)
            }
        }
        
        nftNameLabel.do {
            $0.text = (nftInfo?.name).nonnull
            $0.font = .mediumPingFangSCFont(ofSize: 27)
            $0.textColor = .white
            $0.textAlignment = .left
            $0.numberOfLines = 2
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.height.lessThanOrEqualTo(100)
                make.bottom.equalTo(nftImageView).offset(-46)
                make.width.equalTo(110)
            }
        }
        
        let priceBack = UIView().then {
            $0.backgroundColor = color(87, 80, 79)
            $0.layer.cornerRadius = 24.5
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buyBtnTap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.equalTo(92)
                make.height.equalTo(49)
                make.bottom.equalTo(nftNameLabel)
            }
        }
        
        nftPriceLabel.do {
            $0.font = .gothamBoldFont(ofSize: 14)
            $0.textColor = .white
            $0.textAlignment = .center
            priceBack.insertSubview($0, aboveSubview: priceBack)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        let _ = UIImageView().then {
            $0.isHidden = priceBack.isHidden
            $0.image = UIImage(named: "ge_icon_mall_draft")
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buyBtnTap)))
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-95)
                make.height.width.equalTo(49)
                make.bottom.equalTo(nftPriceLabel)
            }
        }
        
        let _ = LinearGradientView().then {
            $0.colors = [UIColor.white, color(245, 245, 245)]
            $0.startPoint = CGPoint(x: 0, y: 0)
            $0.endPoint = CGPoint(x: 0, y: 1)
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(nftImageView.snp.bottom).offset(-30)
            }
        }
        
        let protectView = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0)
            $0.addTarget(self, action: #selector(protectBtnTap), for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(nftImageView.snp.bottom).offset(5)
                make.height.equalTo(20)
            }
            
            let title = UILabel()
            title.text = "保障"
            title.font = .mediumPingFangSCFont(ofSize: 14)
            title.textColor = .black
            $0.addSubview(title)
            title.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalTo(16)
                make.width.lessThanOrEqualTo(40)
                make.height.equalTo(20)
            }
            
            let image1 = UIImageView()
            image1.image = UIImage(named: "lab_nft_protect_tips_mark")
            $0.addSubview(image1)
            image1.snp.makeConstraints { make in
                make.width.height.equalTo(12)
                make.left.equalTo(title.snp.right).offset(20)
                make.centerY.equalTo(title)
            }
            
            let desc1 = UILabel()
            desc1.text = "正品保障"
            desc1.font = .regularPingFangSCFont(ofSize: 14)
            desc1.textColor = color(0, 0, 0, 0.5)
            $0.addSubview(desc1)
            desc1.snp.makeConstraints { make in
                make.centerY.equalTo(title)
                make.left.equalTo(image1.snp.right).offset(4)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(20)
            }
            
            let image2 = UIImageView()
            image2.image = UIImage(named: "lab_nft_protect_tips_mark")
            $0.addSubview(image2)
            image2.snp.makeConstraints { make in
                make.width.height.equalTo(12)
                make.left.equalTo(desc1.snp.right).offset(20)
                make.centerY.equalTo(title)
            }
            
            let desc2 = UILabel()
            desc2.text = "假一赔十"
            desc2.font = .regularPingFangSCFont(ofSize: 14)
            desc2.textColor = color(0, 0, 0, 0.5)
            $0.addSubview(desc2)
            desc2.snp.makeConstraints { make in
                make.centerY.equalTo(title)
                make.left.equalTo(image2.snp.right).offset(4)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(20)
            }
            
            let arrow = UIImageView()
            arrow.image = UIImage(named: "ge_icon_goods_detail_arrow")
            $0.addSubview(arrow)
            arrow.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.equalTo(17)
                make.height.equalTo(5)
                make.centerY.equalTo(title)
            }
        }
        
        let _ = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(1)
                make.top.equalTo(protectView.snp.bottom).offset(14)
            }
        }
        
        
        let saleView = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0)
            $0.addTarget(self, action: #selector(saleBtnTap), for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(protectView.snp.bottom).offset(29)
                make.height.equalTo(20)
            }
            
            let title = UILabel()
            title.text = "售后"
            title.font = .mediumPingFangSCFont(ofSize: 14)
            title.textColor = .black
            $0.addSubview(title)
            title.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalTo(16)
                make.width.lessThanOrEqualTo(40)
                make.height.equalTo(20)
            }
            
            let desc = UILabel()
            desc.text = "售出不退不换"
            desc.font = .regularPingFangSCFont(ofSize: 14)
            desc.textColor = color(0, 0, 0, 0.5)
            $0.addSubview(desc)
            desc.snp.makeConstraints { make in
                make.centerY.equalTo(title)
                make.left.equalTo(title.snp.right).offset(20)
                make.right.lessThanOrEqualTo(-100)
                make.height.equalTo(20)
            }
            
            let arrow = UIImageView()
            arrow.image = UIImage(named: "ge_icon_goods_detail_arrow")
            $0.addSubview(arrow)
            arrow.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.width.equalTo(17)
                make.height.equalTo(5)
                make.centerY.equalTo(title)
            }
        }
        
        let dayLabel = UILabel().then {
            $0.text = "价格趋势"
            $0.textColor = .black
            $0.font = .semiboldPingFangSCFont(ofSize: 18)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-20)
                make.height.equalTo(25)
                make.top.equalTo(saleView.snp.bottom).offset(28)
            }
        }
        
        let priceSaleView = UIView().then {
            $0.backgroundColor = color(249, 249, 249)
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 10
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.layer.shadowColor = color(227, 227, 227).cgColor
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowRadius = 2
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(dayLabel.snp.bottom).offset(16)
                make.height.equalTo(246)
            }
        }
        
        hourBtn.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 11.0
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setTitle("1小时", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .gothamMediumFont(ofSize: 10)
            $0.addAction(UIAction() {[unowned self] _ in
                topChartsFormatter.style = .hour
                configChartData(style: .hour)
                lineChartsView.setNeedsDisplay()
                hourBtn.backgroundColor = .black
                hourBtn.setTitleColor(.white, for: .normal)
                minuteBtn.backgroundColor = .clear
                minuteBtn.setTitleColor(.black, for: .normal)
                dayBtn.backgroundColor = .clear
                dayBtn.setTitleColor(.black, for: .normal)
                weekBtn.backgroundColor = .clear
                weekBtn.setTitleColor(.black, for: .normal)
            }, for: .touchUpInside)
            priceSaleView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(priceSaleView.snp.centerX).offset(-20)
                make.bottom.equalTo(-17)
                make.width.equalTo(40)
                make.height.equalTo(22)
            }
        }
        
        minuteBtn.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 11.0
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setTitle("5分钟", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .gothamMediumFont(ofSize: 10)
            $0.addAction(UIAction() {[unowned self] _ in
                topChartsFormatter.style = .minute
                configChartData(style: .minute)
                lineChartsView.setNeedsDisplay()
                minuteBtn.backgroundColor = .black
                minuteBtn.setTitleColor(.white, for: .normal)
                hourBtn.backgroundColor = .clear
                hourBtn.setTitleColor(.black, for: .normal)
                dayBtn.backgroundColor = .clear
                dayBtn.setTitleColor(.black, for: .normal)
                weekBtn.backgroundColor = .clear
                weekBtn.setTitleColor(.black, for: .normal)
            }, for: .touchUpInside)
            priceSaleView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(hourBtn.snp.left).offset(-40)
                make.bottom.equalTo(-17)
                make.width.equalTo(40)
                make.height.equalTo(22)
            }
        }
        
        dayBtn.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 11.0
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setTitle("日K", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .gothamMediumFont(ofSize: 10)
            $0.addAction(UIAction() {[unowned self] _ in
                topChartsFormatter.style = .day
                configChartData(style: .day)
                lineChartsView.setNeedsDisplay()
                dayBtn.backgroundColor = .black
                dayBtn.setTitleColor(.white, for: .normal)
                hourBtn.backgroundColor = .clear
                hourBtn.setTitleColor(.black, for: .normal)
                minuteBtn.backgroundColor = .clear
                minuteBtn.setTitleColor(.black, for: .normal)
                weekBtn.backgroundColor = .clear
                weekBtn.setTitleColor(.black, for: .normal)
            }, for: .touchUpInside)
            priceSaleView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(priceSaleView.snp.centerX).offset(20)
                make.bottom.equalTo(-17)
                make.width.equalTo(40)
                make.height.equalTo(22)
            }
        }
        
        weekBtn.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 11.0
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setTitle("周K", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .gothamMediumFont(ofSize: 10)
            $0.addAction(UIAction() {[unowned self] _ in
                topChartsFormatter.style = .week
                configChartData(style: .week)
                lineChartsView.setNeedsDisplay()
                weekBtn.backgroundColor = .black
                weekBtn.setTitleColor(.white, for: .normal)
                hourBtn.backgroundColor = .clear
                hourBtn.setTitleColor(.black, for: .normal)
                minuteBtn.backgroundColor = .clear
                minuteBtn.setTitleColor(.black, for: .normal)
                dayBtn.backgroundColor = .clear
                dayBtn.setTitleColor(.black, for: .normal)
            }, for: .touchUpInside)
            priceSaleView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(dayBtn.snp.right).offset(40)
                make.bottom.equalTo(-17)
                make.width.equalTo(40)
                make.height.equalTo(22)
            }
        }
        
        lineChartsView.do {
            $0.chartDescription.enabled = false
            $0.maxVisibleCount = 0
            $0.legend.enabled = false
            $0.gridBackgroundColor = .clear
            $0.borderColor = .clear
            $0.drawGridBackgroundEnabled = false
            $0.drawBordersEnabled = false
            $0.noDataText = "数据正在计算中..."
            $0.noDataFont = .regularPingFangSCFont(ofSize: 12)
            $0.noDataTextColor = color(0, 0, 0, 0.3)
            $0.isUserInteractionEnabled = false
            
            $0.doubleTapToZoomEnabled = false
            $0.scaleYEnabled = false
            $0.scaleXEnabled = false

            $0.rightAxis.enabled = false

            $0.xAxis.drawGridLinesEnabled = true
            $0.xAxis.drawLabelsEnabled = true
            $0.xAxis.drawAxisLineEnabled = true
            $0.xAxis.axisLineWidth = 1
            $0.xAxis.axisLineColor = color(0, 0, 0, 0.05)
            $0.xAxis.labelFont = .gothamMediumFont(ofSize: 12)
            $0.xAxis.labelTextColor = color(0, 0, 0, 0.4)
            $0.xAxis.gridColor = color(0, 0, 0, 0.05)
            $0.xAxis.gridLineWidth = 1
            $0.xAxis.valueFormatter = topChartsFormatter
            $0.xAxis.forceLabelsEnabled = true
            $0.xAxis.labelCount = 5
            
            $0.leftAxis.drawGridLinesEnabled = false
            $0.leftAxis.drawLabelsEnabled = true
            $0.leftAxis.drawAxisLineEnabled = false
            $0.leftAxis.axisLineWidth = 1
            $0.leftAxis.axisLineColor = color(0, 0, 0, 0.05)
            $0.leftAxis.labelFont = .gothamMediumFont(ofSize: 12)
            $0.leftAxis.labelTextColor = .black
            $0.leftAxis.valueFormatter = LeftAxisFormatter()
            $0.leftAxis.labelCount = 5
            
            priceSaleView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets(top: 16, left: 16, bottom: 50, right: 16))
            }
            
            configChartData(style: .hour)
        }
        
        let goodsLabel = UILabel().then {
            $0.text = "藏品故事"
            $0.textColor = .black
            $0.font = .semiboldPingFangSCFont(ofSize: 18)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-20)
                make.height.equalTo(25)
                make.top.equalTo(priceSaleView.snp.bottom).offset(16)
            }
        }
        
        let storyBackView = UIView().then {
            $0.backgroundColor = color(248, 248, 248)
            $0.layer.cornerRadius = 10
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.layer.shadowColor = color(227, 227, 227).cgColor
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowRadius = 2
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1.0
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(goodsLabel.snp.bottom).offset(16)
                make.bottom.equalTo(-20)
            }
        }
        
        let _ = UILabel().then {
            let content = (nftInfo?.story).nonnull.data(using: .unicode).nonnull
            $0.attributedText = try? NSAttributedString(data: content, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            $0.textColor = color(0, 0, 0, 0.5)
            $0.numberOfLines = 0
            $0.font = .regularPingFangSCFont(ofSize: 12)
            storyBackView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.lessThanOrEqualTo(CGFloat.greatestFiniteMagnitude)
                make.top.equalTo(18)
                make.bottom.equalTo(-18)
            }
        }
        
        Network.request(NFTAPI.nftDetailInfo, parameters: ["id": (nftInfo?.id).nonnull]).responseData {[weak self] response in
            if response.error == nil, let data = response.data?.jsonData(), let item = try? JSONDecoder().decode(InnerItem.self, from: data) {
                self?.markBtn.isSelected = item.isMark == true
                self?.nftPriceLabel.text = (item.nftInfo?.minDealPrice).nonnull > 0 ? "\((item.nftInfo?.minDealPrice).nonnull)积分" : "暂无出售"
            }
        }
    }
    
    @objc fileprivate func markBtnTap(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let nftInfo = nftInfo else { return }
        nftInfo.isMark = sender.isSelected
        Network.request(sender.isSelected ? NFTAPI.mark : NFTAPI.cancelMark, parameters: ["id": nftInfo.id]).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            }
        }
    }
    
    @objc fileprivate func buyBtnTap() {
        UIManager.present(modal: NFTDetailBuyListViewController().then {
            $0.nftInfo = nftInfo
            $0.modalPresentationStyle = .overFullScreen
        })
    }
    
    @objc fileprivate func protectBtnTap() {
        UIManager.present(modal: GoodsProtectTipsViewController().then {
            $0.modalPresentationStyle = .overFullScreen
        })
    }
    
    @objc fileprivate func saleBtnTap() {
        UIManager.present(modal: GoodsSaleTipsViewController().then {
            $0.modalPresentationStyle = .overFullScreen
        })
    }
    
    fileprivate func configChartData(style: TopAxisFormatter.Style) {
        Network.request(NFTAPI.nftPriceLine, parameters: ["goodsId": (nftInfo?.id).nonnull, "range": style.range]).responseData {[weak self] response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let list = response.data?["klineList"] as? [[String: Any]] {
                var dataEntries = [ChartDataEntry]()
                
                for dic in list {
                    let time = dic["time"] as? Double
                    let points = dic["points"] as? Int
                    
                    let entry = ChartDataEntry(x: time.nonnull, y: Double(points.nonnull))
                    dataEntries.append(entry)
                }
                
                let dataset = LineChartDataSet(entries: dataEntries)
                dataset.drawCirclesEnabled = false
                dataset.drawCircleHoleEnabled = false
                dataset.colors = [color(51, 186, 255)]
                dataset.lineWidth = 2.0
                dataset.drawFilledEnabled = true
                dataset.highlightEnabled = false
                dataset.fillAlpha = 0.5
                
                let gradientColors = [color(51, 186, 255).cgColor, color(51, 186, 255, 0.1).cgColor] as CFArray
                let colorLocations: [CGFloat] = [1.0, 0.0]
                if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) {
                    dataset.fill = LinearGradientFill(gradient: gradient, angle: 90)
                } else {
                    dataset.fillColor = color(51, 186, 255, 0.3)
                }
                
                let data = LineChartData(dataSet: dataset)
                self?.lineChartsView.data = data
            }
        }
    }
    
    fileprivate class LeftAxisFormatter: AxisValueFormatter {
        func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
            return "\(Int(value))积分"
        }
    }
    
    fileprivate class TopAxisFormatter: AxisValueFormatter {
        enum Style: String {
            case minute = "秒"
            case hour = "分钟"
            case day = "小时"
            case week = "天"
            
            var range: String {
                switch self {
                case .minute:
                    return "minute5"
                case .hour:
                    return "hour1"
                case .day:
                    return "day1"
                case .week:
                    return "week1"
                }
            }
        }
        
        var style: Style = .minute
        func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
            switch style {
            case .minute, .hour:
                return Date(timeIntervalSince1970: value/1000.0).formatDisplayHourWithMinute()
            case .day, .week:
                return Date(timeIntervalSince1970: value/1000.0).formatDisplayWeekDay()
            }
        }
    }
    
    fileprivate class InnerItem: Codable {
        var nftInfo: NFTInfo?
        var isMark: Bool?
        var points: Int?
        
        enum CodingKeys: String, CodingKey {
            case nftInfo = "goods"
            case isMark = "mark"
            case points
        }
    }
}

extension NFTDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customBar.backgroundColor = color(0, 0, 0, min(0.5, scrollView.contentOffset.y/400))
    }
}
