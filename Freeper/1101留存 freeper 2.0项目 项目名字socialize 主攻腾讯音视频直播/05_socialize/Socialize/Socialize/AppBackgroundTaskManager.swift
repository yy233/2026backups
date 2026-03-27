//
//  AppBackgroundTaskManager.swift
//  Socialize
//
//  Created by 余莹 on 2023/10/11.
//

import UIKit

class AppBackgroundTaskManager: NSObject {
    static let shared = AppBackgroundTaskManager.init()
        
        func startToApplyTimeForBackgroundTask() {
            applyTimeForBackgroundTaskTime()
        }
        
        /// 申请进行后台任务
        /// 这是一个不间断的申请，在结束的时候再次进行申请 提供后台保活功能
        func applyTimeForBackgroundTaskTime() {
            var bgTask: UIBackgroundTaskIdentifier!
            bgTask = UIApplication.shared.beginBackgroundTask(withName: "bg task") {[weak self] in
                UIApplication.shared.endBackgroundTask(bgTask)
                self?.applyTimeForBackgroundTaskTime()
            }
        }
}
