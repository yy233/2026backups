//
//  PointsDetailSegmentViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/11.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit

final class PointsDetailSegmentViewController: UIViewController {
    
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        contentView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16.0
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(UIManager.shared.screenHeight - UIManager.shared.statusBarHeight - 148)
            }
        }
        
        contentView.addSubview(segmentView)
        segmentView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(52)
        }
        
        addChild(pageViewController)
        contentView.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(segmentView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = color(0, 0, 0, 0.5)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.backgroundColor = .clear
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.location(in: view).y < contentView.top {
            dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate lazy var pageViewController = PageboyViewController().then {
        $0.delegate = self
        $0.dataSource = self
        $0.bounces = false
    }
    
    fileprivate lazy var receivePointsViewController = PointsListViewController(type: .receive)
    fileprivate lazy var payPointsViewController = PointsListViewController(type: .pay)
    
    fileprivate lazy var segmentView = PointsDetailSegmentView().then {
        $0.didChangeSegmentHandler = {[unowned self] index in
            switch index {
            case .previous:
                pageViewController.scrollToPage(.previous, animated: true)
            case .last:
                pageViewController.scrollToPage(.last, animated: true)
            }
        }
    }
}

extension PointsDetailSegmentViewController: PageboyViewControllerDataSource, PageboyViewControllerDelegate {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return 2
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        if index == 0 {
            return receivePointsViewController
        }
        return payPointsViewController
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .previous
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        if index == 0 {
            segmentView.segmentIndex = .previous
        }
        else if index == 1 {
            segmentView.segmentIndex = .last
        }
    }
    
    fileprivate class PointsDetailSegmentView: UIView {
        enum SegmentIndex {
            case previous
            case last
        }
        
        fileprivate lazy var segmentPreviousBtn = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setTitle("收入", for: .normal)
            $0.setTitleColor(color(0, 0, 0, 0.3), for: .normal)
            $0.setTitleColor(.black, for: .selected)
            $0.titleLabel?.font = UIFont.mediumPingFangSCFont(ofSize: 18)
            $0.addTarget(self, action: #selector(segmentPreviousBtnTapHandler), for: .touchUpInside)
            addSubview($0)
        }
        
        fileprivate lazy var segmentLastBtn = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setTitle("支出", for: .normal)
            $0.setTitleColor(color(0, 0, 0, 0.3), for: .normal)
            $0.setTitleColor(.black, for: .selected)
            $0.titleLabel?.font = UIFont.mediumPingFangSCFont(ofSize: 18)
            $0.addTarget(self, action: #selector(segmentLastBtnTapHandler), for: .touchUpInside)
            addSubview($0)
        }
        
        fileprivate lazy var segmentLineView = UIImageView().then {
            $0.image = UIImage(named: "lab_tab_segment_line")
            insertSubview($0, belowSubview: segmentPreviousBtn)
        }
            
        init() {
            super.init(frame: .zero)
            segmentPreviousBtn.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.top.equalTo(20)
                make.height.equalTo(25)
                make.width.equalTo(36)
            }
            
            segmentLastBtn.snp.makeConstraints { make in
                make.left.equalTo(segmentPreviousBtn.snp.right).offset(32)
                make.top.equalTo(20)
                make.height.equalTo(25)
                make.width.equalTo(36)
            }
            
            segmentPreviousBtn.isSelected = true
            segmentLineView.snp.makeConstraints { make in
                make.width.equalTo(25)
                make.height.equalTo(7.6)
                make.top.equalTo(segmentPreviousBtn.snp.bottom)
                make.centerX.equalTo(segmentPreviousBtn)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var didChangeSegmentHandler: ((SegmentIndex) -> Void)?
        var segmentIndex: SegmentIndex = .previous {
            didSet {
                if segmentIndex != oldValue {
                    selectedAt(index: segmentIndex)
                }
            }
        }
        
        fileprivate func selectedAt(index: SegmentIndex) {
            switch index {
            case .previous:
                segmentIndex = .previous
                segmentPreviousBtn.isSelected = true
                segmentLastBtn.isSelected = false
                
                segmentLineView.snp.remakeConstraints { make in
                    make.width.equalTo(25)
                    make.height.equalTo(7.6)
                    make.top.equalTo(segmentPreviousBtn.snp.bottom)
                    make.centerX.equalTo(segmentPreviousBtn)
                }
                
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                }
            case .last:
                segmentIndex = .last
                segmentPreviousBtn.isSelected = false
                segmentLastBtn.isSelected = true
                
                segmentLineView.snp.remakeConstraints { make in
                    make.width.equalTo(25)
                    make.height.equalTo(7.6)
                    make.top.equalTo(segmentLastBtn.snp.bottom)
                    make.centerX.equalTo(segmentLastBtn)
                }
                
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                }
            }
        }
        
        @objc fileprivate func segmentPreviousBtnTapHandler() {
            if !segmentPreviousBtn.isSelected {
                selectedAt(index: .previous)
                didChangeSegmentHandler?(.previous)
            }
        }
        
        @objc fileprivate func segmentLastBtnTapHandler() {
            if !segmentLastBtn.isSelected {
                selectedAt(index: .last)
                didChangeSegmentHandler?(.last)
            }
        }
    }

    fileprivate class PointsListViewController: TableViewController {
        
        init(type: PointsListViewModel.SortType) {
            super.init(nibName: nil, bundle: nil)
            viewModel = PointsListViewModel(type: type)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            triggerRefreshAutomatic = true
            triggerLoadMoreAutomatic = true
            super.viewDidLoad()

            tableView?.register(cellWithClass: PointsListTableViewCell.self)
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withClass: PointsListTableViewCell.self)
            cell.selectionStyle = .none
            if let item = viewModel?.element(at: indexPath.section) as? PointsItem {
                cell.bind(model: item, type: (viewModel as? PointsListViewModel)?.type ?? .receive)
            }
            return cell
        }
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 79
        }
    }

    final class PointsListViewModel: NetworkViewModel {
        enum SortType: Int {
            case receive = 1
            case pay = -1
        }
        
        let type: SortType
        init(type: SortType) {
            self.type = type
            super.init()
            url = PointsAPI.pointsLogList.rawValue
        }
        
        override var parameters: [String : Any]? {
            return ["type": type.rawValue]
        }
        
        override func flattenAndFilterElement(isLoadingMore: Bool, data: [Any]) -> [IdentifierElement]? {
            guard let data = data.jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode([PointsItem].self, from: data)
                if isLoadingMore {
                    var list = [PointsItem]()
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

    fileprivate struct PointsItem: Codable, IdentifierElement {
        var pointId = ""
        var desc = ""
        var time: TimeInterval = 0
        var points: Int = 0
        
        var uniqueIdentifier: String { pointId }
        
        enum CodingKeys: String, CodingKey {
            case pointId = "recordId"
            case desc = "action"
            case time = "actionTimeMillis"
            case points
        }
    }

    fileprivate final class PointsListTableViewCell: UITableViewCell {

        fileprivate lazy var descLabel = UILabel().then {
            $0.font = UIFont.mediumPingFangSCFont(ofSize: 16)
            $0.textColor = .black
            $0.textAlignment = .left
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(16.5)
                make.left.equalTo(16)
                make.right.equalTo(-100)
                make.height.equalTo(22)
            }
        }
        
        fileprivate lazy var timeLabel = UILabel().then {
            $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
            $0.textColor = color(0, 0, 0, 0.4)
            $0.textAlignment = .left
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(descLabel.snp.bottom).offset(4)
                make.left.right.equalTo(descLabel)
                make.height.equalTo(20)
            }
        }

        fileprivate lazy var pointsLabel = UILabel().then {
            $0.font = .gothamBoldFont(ofSize: 16)
            $0.textColor = color(255, 38, 111)
            $0.textAlignment = .right
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerY.height.equalToSuperview()
                make.right.equalTo(-16)
                make.width.equalTo(80)
            }
        }
        
        fileprivate lazy var lineView = UIView.singleLine().then {
            $0.backgroundColor = color(216, 216, 216)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(0.5)
                make.bottom.equalToSuperview()
            }
        }
        
        fileprivate func bind(model: PointsItem, type: PointsListViewModel.SortType) {
            descLabel.text = model.desc
            timeLabel.text = Date(timeIntervalSince1970: model.time/1000.0).displayString()
            pointsLabel.text = "\(type == .receive ? "+" : "")\(model.points)"
            pointsLabel.textColor = type == .pay ? color(38, 242, 255) : color(255, 38, 111)
            lineView.isHidden = false
        }
    }
}
