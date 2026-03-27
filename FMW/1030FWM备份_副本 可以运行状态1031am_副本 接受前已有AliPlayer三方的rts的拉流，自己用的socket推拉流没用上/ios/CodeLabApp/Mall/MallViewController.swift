//
//  ModalDemoViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2022/10/27.
//

import Foundation
import BasicUIKit
import Combine

class MallViewController: SegmentViewController {
    
    private let rightBtn = UIButton()
    private var cancellableList: [AnyCancellable] = []

    override func viewDidLoad() {
        segmentStyle = .navigationLeft
        segmentBarHeight = 44
        super.viewDidLoad()
        customBackBtn.isHidden = true
        bind(segments: [BusinessInteralViewController(), BusinessGoodsViewController()])
        
        rightBtn.do {
            $0.isHidden = true
            $0.layer.cornerRadius = 4.0
            $0.layer.borderColor = color(0, 0, 0, 0.4).cgColor
            $0.layer.borderWidth = 0.5
            $0.setTitle("我的订单", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .mediumPingFangSCFont(ofSize: 14)
            $0.addAction(UIAction() { _ in
                UIManager.push(to: GoodsOrderListViewController())
            }, for: .touchUpInside)
            customBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(76)
                make.height.equalTo(30)
                make.right.equalTo(-16)
                make.centerY.equalTo(customBackBtn)
            }
        }
        
        NotificationCenter.default.publisher(for: .notificationPointsDidTapNFTMall).sink {[unowned self] _ in
            pageViewController.scrollToPage(.first, animated: true)
        }.store(in: &cancellableList)
    }
    
    override func didScrolToPage(index: Int) {
        rightBtn.isHidden = index == 0
    }
}
