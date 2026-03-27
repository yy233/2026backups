//
//  TabModule.swift
//  CodeLabApp
//
//  Created by Sera on 2022/10/25.
//

import Foundation
import BasicKit
import UIKit
import BasicUIKit

struct TabModuleMain: TabModule {
    let vc = MainViewController()
    var tabBarItemStyle: TabBarItemStyle { .normal(defaultIcon: UIImage(basicBundleNamed: "ge_tab_main_selected"), selectedIcon: UIImage(basicBundleNamed: "ge_tab_main_selected"), text: "首页") }
    var tabBarNormalTextColor: UIColor? { color(192, 192, 192) }
    var tabBarSelectedTextColor: UIColor? { color(51, 186, 255) }
    var moduleViewController: UIViewController? { vc }
    var tabIndex: Int { 0 }
}

struct TabModuleCommunity: TabModule {
    let vc = CommunityContainerViewController()
    var tabBarItemStyle: TabBarItemStyle { .normal(defaultIcon: UIImage(basicBundleNamed: "ge_tab_community_selected"), selectedIcon: UIImage(basicBundleNamed: "ge_tab_community_selected"), text: "社区") }
    var tabBarNormalTextColor: UIColor? { color(192, 192, 192) }
    var tabBarSelectedTextColor: UIColor? { color(51, 186, 255) }
    var moduleViewController: UIViewController? { vc }
    var tabIndex: Int { 1 }
}

struct TabModuleMall: TabModule {
    let vc = MallViewController()
    var tabBarItemStyle: TabBarItemStyle { .normal(defaultIcon: UIImage(basicBundleNamed: "ge_tab_mall_selected"), selectedIcon: UIImage(basicBundleNamed: "ge_tab_mall_selected"), text: "商城") }
    var tabBarNormalTextColor: UIColor? { color(192, 192, 192) }
    var tabBarSelectedTextColor: UIColor? { color(51, 186, 255) }
    var moduleViewController: UIViewController? { vc }
    var tabIndex: Int { 2 }
}

struct TabModuleSettings: TabModule {
    let vc = UserViewController().then {
        $0.tabUser = true
        $0.userID = AppContext.current.userID
        $0.userInfo = AppContext.current.userContext?.user?.user?.userInfo
    }
    var tabBarItemStyle: TabBarItemStyle { .normal(defaultIcon: UIImage(basicBundleNamed: "ge_tab_user_selected"), selectedIcon: UIImage(basicBundleNamed: "ge_tab_user_selected"), text: "主页") }
    var tabBarNormalTextColor: UIColor? { color(192, 192, 192) }
    var tabBarSelectedTextColor: UIColor? { color(51, 186, 255) }
    var moduleViewController: UIViewController? { vc }
    var tabIndex: Int { 3 }
}
