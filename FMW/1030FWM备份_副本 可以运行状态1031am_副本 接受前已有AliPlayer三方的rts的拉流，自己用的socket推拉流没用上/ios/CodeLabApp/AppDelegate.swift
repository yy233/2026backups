//
//  AppDelegate.swift
//  CodeLabApp
//
//  Created by Sera on 2022/9/29.
//

import Foundation
import UIKit
import BasicUIKit
import APIKit
import CodeLabUnityBridge
import MachO
import IQKeyboardManagerSwift
import Combine
import AliyunPlayer
import Alamofire
import HyphenateChat
import UserNotifications
import BasicKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var cancellableList: [AnyCancellable] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        APIClient.baseURL = "http://api.fmwworld.com:88/"
        APIClient.cdnBaseURL = ""
        APIClient.sessionExpirationHandler = {
            AppContext.current.logout()
            NotificationCenter.default.post(name: .notificationUserDidLogout, object: nil)
            Toast.toast(title: "此用户已在其他设备登录")
        }
        
        AliPrivateService.initLicense()
        IMClient.shared.initlize()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        if AppContext.current.hasLogin() {
            let vcs: [TabModule] = [TabModuleMain(),
                                    TabModuleCommunity(),
                                    TabModuleMall(),
                                    TabModuleSettings()]
            window?.rootViewController = NavigationViewController(rootViewController: MainTabViewController(modules: vcs))
        } else {
            window?.rootViewController = NavigationViewController(rootViewController: LoginViewController())
        }
        
        window?.makeKeyAndVisible()
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()

        if UserDefaults.standard.string(forKey: "com.fmw.make.welcome.protocol") == "1" {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == .notDetermined {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { granted, _ in
                        DispatchQueue.main.async {
                            if granted {
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        }
                    }
                } else if settings.authorizationStatus == .authorized {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        
        EMLocalNotificationManager.shared().launch(with: self)

        NotificationCenter.default.publisher(for: .notificationUserDidLogin).sink {[unowned self] _ in
            let vcs: [TabModule] = [TabModuleMain(),
                                    TabModuleCommunity(),
                                    TabModuleMall(),
                                    TabModuleSettings()]
            window?.rootViewController = NavigationViewController(rootViewController: MainTabViewController(modules: vcs))
        }.store(in: &cancellableList)
        
        NotificationCenter.default.publisher(for: .notificationUserDidLogout).sink {[unowned self] _ in
            window?.rootViewController = NavigationViewController(rootViewController: LoginViewController())
        }.store(in: &cancellableList)
        
        let machHeader = UnsafeMutablePointer<mach_header_64>.allocate(capacity: 1)
        machHeader.pointee = _mh_execute_header
        
        if let window = window {
            CodeLabUnityInstance.registerHostWindow(window, executableHader: machHeader)
            warmupUnity()
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        Network.request(LoginAPI.appLaunch, encoding: URLEncoding.default).responseEmpty()
        return true
    }
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        if AppContext.current.userID.isNotEmpty {
            OSSUploader.refreshOSSToken()
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        EMClient.shared().applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        EMClient.shared().applicationWillEnterForeground(application)
    }
    
    func warmupUnity() {
        @MainActor
        struct Once {
            static let setup: Void = {
                CodeLabUnityInstance.shared.warmup(completionHandler: {})
            }()
        }
        let _ = Once.setup
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if URLRouter.handleGoto(url: url, source: .external) {
            return true
        }
            
        return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let url = userActivity.webpageURL, url.path == "/universal-link/oia",
           let queryItems = URLComponents(string: url.absoluteString)?.queryItems,
           let gotoItem = queryItems.first(where: { $0.name == "goto" }),
           let gotoString = gotoItem.value?.removingPercentEncoding, let gotoURL = URL(string: gotoString) {
            return URLRouter.handleGoto(url: gotoURL, source: .trustedWeb)
        }
        return false
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        dPrint("APNS token -- \(deviceToken.base64EncodedString())")
        
        DispatchQueue.global().async {
            EMClient.shared().bindDeviceToken(deviceToken)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        dPrint("APNS error - \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        EMLocalNotificationManager.shared().userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        EMLocalNotificationManager.shared().userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
    }
}

extension AppDelegate: EMLocalNotificationDelegate {
    func emuserNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .list, .banner])
    }
    
    func emuserNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        dPrint("APNS userInfo -- \(response.notification.request.content.userInfo)")
        let userInfo = response.notification.request.content.userInfo
        if let operation = userInfo["operation"] as? [AnyHashable: Any],
            let string = operation["open_url"] as? String, let url = URL(string: string) {
            URLRouter.handleGoto(url: url, source: .push)
        }
        completionHandler()
    }
    
    func emDidRecivePushSilentMessage(_ messageDic: [AnyHashable : Any]) {
        dPrint("silent push -- \(messageDic)")
    }
}
