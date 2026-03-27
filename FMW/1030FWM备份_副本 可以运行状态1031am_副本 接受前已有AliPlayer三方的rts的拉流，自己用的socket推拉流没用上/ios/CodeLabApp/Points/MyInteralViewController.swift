//
//  MyInteralViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/16.
//

import Foundation
import BasicUIKit
import APIKit
import Alamofire
import Combine

final class MyInteralViewController: BaseViewController {
    
    fileprivate let pointsLabel = UILabel()
    fileprivate let taskContentView = UIView()
    fileprivate var cancelables = Set<AnyCancellable>()

    override func viewDidLoad() {
        navigationHidden = true
        navigationControlEnable = true
        super.viewDidLoad()
        view.backgroundColor = color(240, 240, 240)
        customBar.isHidden = false
        customBar.backgroundColor = .clear
        customBackBtn.isHidden = false
        
        let _ = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -16)
            $0.setTitle("积分明细", for: .normal)
            $0.titleLabel?.font = .semiboldPingFangSCFont(ofSize: 16)
            $0.setTitleColor(.black, for: .normal)
            $0.addAction(UIAction() { _ in
                UIManager.present(modal: PointsDetailSegmentViewController().then { $0.modalPresentationStyle = .overFullScreen })
            }, for: .touchUpInside)
            customBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(64)
                make.height.equalTo(22)
                make.right.equalTo(-16)
                make.centerY.equalTo(customBackBtn)
            }
        }
        
        let headerView = UIImageView().then {
            $0.image = UIImage(named: "ge_mail_header")
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            view.insertSubview($0, belowSubview: customBar)
            $0.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(291.0)
            }
        }
        
        pointsLabel.do {
            $0.text = "0"
            $0.textColor = UIColor.black
            $0.font = .gothamBoldFont(ofSize: 40)
            $0.textAlignment = .left
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(36)
                make.width.lessThanOrEqualTo(200)
                make.top.equalTo(customBar.snp.bottom).offset(19)
                make.height.lessThanOrEqualTo(60)
            }
        }
        
        let _ = UILabel().then {
            $0.text = "积分"
            $0.textColor = UIColor.black
            $0.font = UIFont.mediumPingFangSCFont(ofSize: 14)
            $0.textAlignment = .left
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(pointsLabel.snp.right).offset(8)
                make.width.lessThanOrEqualTo(50)
                make.bottom.equalTo(pointsLabel).offset(-8)
                make.height.equalTo(20)
            }
        }
        
        let awardBtn = UIButton().then {
            $0.setImage(UIImage(named: "lab_points_award"), for: .normal)
            $0.addAction(UIAction() {[unowned self] _ in
                NotificationCenter.default.post(name: .notificationPointsDidTapNFTMall, object: nibName)
                UIManager.popToRoot(animated: true)
            }, for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(104)
                make.height.equalTo(47)
                make.left.equalTo(pointsLabel).offset(-5)
                make.top.equalTo(pointsLabel.snp.bottom).offset(8)
            }
        }
        
        let btnBackView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10.0
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(orderListBtnTapHandler)))
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.left.equalTo(16)
                make.top.equalTo(awardBtn.snp.bottom).offset(20)
                make.height.equalTo(61)
            }
            
            let image = UIImageView()
            image.image = UIImage(named: "lab_points_my_order")
            $0.addSubview(image)
            image.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.left.equalTo(16)
                make.centerY.equalToSuperview()
            }
            
            let label = UILabel()
            label.text = "我的订单"
            label.font = .semiboldPingFangSCFont(ofSize: 18)
            label.textColor = .black
            $0.addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalTo(image.snp.right).offset(4)
                make.top.bottom.equalToSuperview()
                make.right.equalTo(-10)
            }
        }
        
        let backView = UIScrollView().then {
            $0.backgroundColor = view.backgroundColor
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.contentInsetAdjustmentBehavior = .never
            $0.alwaysBounceVertical = true
            $0.keyboardDismissMode = .none
            view.insertSubview($0, belowSubview: headerView)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(btnBackView.snp.bottom).offset(16)
            }
        }
        
        taskContentView.do {
            $0.backgroundColor = backView.backgroundColor
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalTo(view)
            }
        }
        
        refreshTask()
        
        NotificationCenter.default.publisher(for: .notificationPointsDidUpdate).sink {[unowned self] _ in
            refreshPoints()
        }.store(in: &cancelables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshPoints()
    }
    
    fileprivate func refreshPoints() {
        Network.request(PointsAPI.userPoints, encoding: URLEncoding.default).responseData { response in
            if let points = response.data?["points"] as? Int {
                self.pointsLabel.text = "\(points)"
            }
        }
    }
    
    fileprivate func refreshTask() {
        Network.request(PointsAPI.taskList).responseData { response in
            if let error = response.error {
                Toast.toast(title: error.localizedDescription)
            } else if let data = (response.data?["list"] as? [Any])?.jsonString.data(using: .utf8),
                      let tasks = try? JSONDecoder().decode([PointsTaskSectionItem].self, from: data) {
                
                self.taskContentView.subviews.forEach { ($0 as? PointsMallTaskListView)?.removeFromSuperview() }
                
                var topView: PointsMallTaskListView?
                for item in tasks.enumerated() {
                    let taskView = PointsMallTaskListView()
                    taskView.clipsToBounds = true
                    taskView.bindTask(item.element, isShowFull: item.offset == 0)
                    self.taskContentView.addSubview(taskView)
                    
                    let height = item.offset == 0 ? taskView.totalContentHeight : 61
                    taskView.snp.makeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.height.equalTo(height)
                        
                        if let topView = topView {
                            make.top.equalTo(topView.snp.bottom).offset(16)
                        }
                        else {
                            make.top.equalToSuperview()
                        }
                        
                        if item.offset == tasks.count - 1 {
                            make.bottom.equalTo(-80)
                        }
                    }
                    
                    topView = taskView
                }
            }
        }
    }
    
    @objc fileprivate func orderListBtnTapHandler() {
        UIManager.push(to: MyPointsOrderViewController())
    }
}

fileprivate class PointsTaskSectionItem: Codable {
    var title = ""
    var taskList: [PointsTaskItem]?
    
    enum CodingKeys: String, CodingKey {
        case title = "headTitle"
        case taskList = "list"
    }
}

fileprivate class PointsTaskItem: Codable {
    var taskID = ""
    var name = ""
    var desc = ""
    var type: Int = 0
    var limitNum = 0
    var finishNum = 0
    var points: Int = 0
    var gotoString: String?
    var status: TaskStatus = .execute
    
    enum CodingKeys: String, CodingKey {
        case taskID = "taskId"
        case name = "title"
        case desc
        case type
        case limitNum = "progressTotal"
        case finishNum = "progressCurrent"
        case points
        case status
        case gotoString
    }
}

extension PointsTaskItem {
    enum TaskStatus: Int, Codable {
        case execute = 1        //未完成
        case done = 2           //可领取
        case received = 3       //已领取
    }
}

fileprivate class PointsMallTaskListView: UIView {
    
    fileprivate var taskItem: PointsTaskSectionItem?
    fileprivate var elementViews = [PointsMallTaskElementView]()
    var totalContentHeight: CGFloat = 0
    var isShowFull: Bool = false
    
    func bindTask(_ task: PointsTaskSectionItem, isShowFull: Bool) {
        titleLabel.setTitle(task.title, for: .normal)
        self.isShowFull = isShowFull
        fullArrowView.transform = isShowFull ? CGAffineTransform.identity.rotated(by: .pi/2.0) : CGAffineTransform.identity
        taskItem = task
        configCountDisplay()
        
        var totalHeight: CGFloat = 43

        if let taskList = task.taskList {
            elementViews.removeAll()
            
            var top: CGFloat = 0
            for item in taskList.enumerated() {
                let elementView = PointsMallTaskElementView()
                let isNotSingleLine = elementView.bindModel(item.element)
                let height: CGFloat = isNotSingleLine ? 75 : 58
                elementView.isHidden = !isShowFull
                elementView.tag = item.offset
                elementView.lineView.isHidden = item.offset == taskList.count - 1
                elementViews.append(elementView)
                addSubview(elementView)
                elementView.snp.makeConstraints { make in
                    make.top.equalTo(titleLabel.snp.bottom).offset(top)
                    make.left.right.equalTo(backView)
                    make.height.equalTo(height)
                }
                top += height
                totalHeight += height
            }
        }
        
        totalContentHeight = totalHeight + 8
    }
    
    fileprivate func configCountDisplay() {
        let count = taskItem?.taskList?.filter { $0.status == .done }.count
        taskCountLabel.text = "\(count.nonnull)"
        taskCountLabel.isHidden = count.nonnull == 0 || isShowFull
    }
    
    @objc fileprivate func fullBtnTapHandler() {
        isShowFull = !isShowFull
        configCountDisplay()
        
        if isShowFull {
            fullArrowView.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi/2.0)
            elementViews.forEach { $0.isHidden = false }
            
            snp.updateConstraints { make in
                make.height.equalTo(totalContentHeight)
            }
            
            superview?.layoutIfNeeded()
        } else {
            fullArrowView.transform = CGAffineTransform.identity
            elementViews.forEach { $0.isHidden = true }
            
            snp.updateConstraints { make in
                make.height.equalTo(61)
            }
            
            superview?.layoutIfNeeded()
        }
    }
    
    fileprivate lazy var backView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10.0
        insertSubview($0, at: 0)
        $0.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
    }
    
    fileprivate lazy var titleLabel = UIButton().then {
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -UIManager.shared.screenWidth)
        $0.setTitle("", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.semiboldPingFangSCFont(ofSize: 18)
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(fullBtnTapHandler), for: .touchUpInside)
        addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(backView).offset(18)
            make.top.equalTo(backView).offset(18)
            make.height.equalTo(25)
        }
    }
    
    fileprivate lazy var fullArrowView = UIButton().then {
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
        $0.setImage(UIImage(named: "ge_main_arrow"), for: .normal)
        $0.addTarget(self, action: #selector(fullBtnTapHandler), for: .touchUpInside)
        addSubview($0)
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.right.equalTo(backView).offset(-15)
            make.centerY.equalTo(titleLabel)
        }
    }
    
    fileprivate lazy var taskCountLabel = UILabel().then {
        $0.backgroundColor = color(51, 186, 255)
        $0.layer.cornerRadius = 9.0
        $0.layer.masksToBounds = true
        $0.textColor = .white
        $0.font = UIFont.semiboldPingFangSCFont(ofSize: 12)
        $0.textAlignment = .center
        addSubview($0)
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.left.equalTo(titleLabel.snp.right).offset(7)
            make.centerY.equalTo(titleLabel)
        }
    }
}

fileprivate final class PointsMallTaskElementView: UIView {
    
    var taskItem: PointsTaskItem?
    func bindModel(_ taskItem: PointsTaskItem) -> Bool {
        let attributeText = NSMutableAttributedString()
        attributeText.append(NSAttributedString(string: "\(taskItem.name)", attributes: [.font: UIFont.mediumPingFangSCFont(ofSize: 14), .foregroundColor: UIColor.black]))
        if taskItem.limitNum > 0 {
            attributeText.append(NSAttributedString(string: " (\(taskItem.finishNum)/\(taskItem.limitNum))", attributes: [.font: UIFont.mediumPingFangSCFont(ofSize: 14), .foregroundColor: UIColor.black]))
        }
        attributeText.append(NSAttributedString(string: " +\(taskItem.points)", attributes: [.font: UIFont.semiboldPingFangSCFont(ofSize: 14), .foregroundColor: color(51, 186, 255)]))
        titleLabel.attributedText = attributeText
        descLabel.text = taskItem.desc
        self.taskItem = taskItem
        configStatusBtnDisplay()
        return descLabel.sizeThatFits(CGSize(width: UIManager.shared.screenWidth - 34 - 16 - 100, height: 50)).height > 30
    }
    
    fileprivate func configStatusBtnDisplay() {
        guard let taskItem = taskItem else { return }

        switch taskItem.status {
        case .done:
            statusBtn.backgroundColor = color(51, 186, 255)
            statusBtn.setTitleColor(.white, for: .normal)
            statusBtn.setTitle("领取", for: .normal)
            statusBtn.layer.borderColor = nil
            statusBtn.layer.borderWidth = 0
        case .execute:
            statusBtn.backgroundColor = color(230, 246, 255)
            statusBtn.layer.borderWidth = 1.0
            statusBtn.layer.borderColor = color(51, 186, 255).cgColor
            statusBtn.setTitle("去完成", for: .normal)
            statusBtn.setTitleColor(color(51, 186, 255), for: .normal)
        case .received:
            statusBtn.backgroundColor = color(245, 245, 245)
            statusBtn.layer.borderWidth = 0
            statusBtn.layer.borderColor = nil
            statusBtn.setTitle("已完成", for: .normal)
            statusBtn.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc fileprivate func statusBtnTapHandler() {
        guard let taskItem = taskItem else { return }
        switch taskItem.status {
        case .done:
            HUD.show()
            Network.request(PointsAPI.pointsReceive, parameters: ["type": taskItem.type, "taskId": taskItem.taskID]).responseData {
                response in
                HUD.hide()
                if let error = response.error {
                    Toast.toast(title: error.localizedDescription)
                } else {
                    Toast.toast(title: "已完成")
                    taskItem.status = .received
                    self.configStatusBtnDisplay()
                    NotificationCenter.default.post(name: .notificationPointsDidUpdate, object: nil)
                }
            }
        default:
            if let goto = taskItem.gotoString, let url = URL(string: goto) {
                URLRouter.handleGoto(url: url, source: .api)
            } else {
                let items = ["我在这里发现一个超棒的内容，快来下载吧http://www.fmwworld.com", URL(string: "http://www.fmwworld.com").nonnull] as [Any]
                let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
                activityVC.modalPresentationStyle = .overFullScreen
                UIManager.present(modal: activityVC)
            }
        }
    }
    
    fileprivate lazy var lineView = UIView.singleLine().then {
        $0.backgroundColor = color(243, 243, 243)
        addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }
    
    fileprivate lazy var titleLabel = UILabel().then {
        $0.textColor = UIColor.black
        $0.font = UIFont.mediumPingFangSCFont(ofSize: 14)
        $0.textAlignment = .left
        addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.right.equalTo(statusBtn.snp.left).offset(-20)
            make.top.equalTo(10)
            make.height.equalTo(20)
        }
    }
    
    fileprivate lazy var descLabel = UILabel().then {
        $0.textColor = color(0, 0, 0, 0.3)
        $0.font = UIFont.regularPingFangSCFont(ofSize: 12)
        $0.textAlignment = .left
        $0.numberOfLines = 2
        addSubview($0)
        $0.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalTo(-100)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.height.lessThanOrEqualTo(50)
        }
    }
    
    fileprivate lazy var statusBtn = UIButton().then {
        $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0)
        $0.layer.cornerRadius = 4
        $0.setTitle("领取", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.mediumPingFangSCFont(ofSize: 12)
        $0.addTarget(self, action: #selector(statusBtnTapHandler), for: .touchUpInside)
        addSubview($0)
        $0.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(28)
            make.right.equalTo(-18)
            make.centerY.equalToSuperview()
        }
    }
}
