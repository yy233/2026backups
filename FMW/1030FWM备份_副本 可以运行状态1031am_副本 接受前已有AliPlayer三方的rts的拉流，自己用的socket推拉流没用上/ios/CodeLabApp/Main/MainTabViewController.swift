//
//  MainTabViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/11.
//

import Foundation
import BasicUIKit
import UIKit
import Combine

final class MainTabViewController: TabBarViewController {

    private var cancellableList: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.publisher(for: .notificationFeedDidPublish).sink {[unowned self] _ in
            selectTab(index: 1)
        }.store(in: &cancellableList)
        
        NotificationCenter.default.publisher(for: .notificationPointsDidTapFeedRecommend).sink {[unowned self] _ in
            selectTab(index: 1)
        }.store(in: &cancellableList)
        
        NotificationCenter.default.publisher(for: .notificationPointsDidTapNFTMall).sink {[unowned self] _ in
            selectTab(index: 2)
        }.store(in: &cancellableList)
    }
    
    override func transition(from current: TabBarItem?, to: TabBarItem?) {
        super.transition(from: current, to: to)
        AppContext.current.userContext?.refreshUnread()
    }
}
