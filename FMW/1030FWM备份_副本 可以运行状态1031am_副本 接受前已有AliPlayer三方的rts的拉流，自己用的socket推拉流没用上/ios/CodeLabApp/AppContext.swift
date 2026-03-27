//
//  AppContext.swift
//  CodeLabApp
//
//  Created by Sera on 2023/8/23.
//

import Foundation
import APIKit
import BasicKit

class AppContext {
    static let current = AppContext()
    fileprivate init() {}
    static let loginUserKey = "com.fmw.make.login.user"
    static let assistorUserID = "4ezmxyzn"
    
    var userContext: UserContext?
    var userID: String {
        AppContext.current.userContext?.user?.user?.userInfo?.userID ?? ""
    }
    
    lazy var ossUploader = OSSUploader()
    
    func hasLogin() -> Bool {
        guard let user = UserDefaults.standard.data(forKey: AppContext.loginUserKey),
              let info = try? JSONDecoder().decode(LoginInfo.self, from: user)
        else { return false }
        
        login(user: info, save: false)
        return true
    }
    
    func login(user: LoginInfo, save: Bool = true) {
        userContext = UserContext()
        userContext?.user = user
        APIClient.credential = APIClient.Credential(userID: (user.user?.userInfo?.userID).nonnull, accessToken: user.sessionId.nonnull)
        OSSUploader.refreshOSSToken()
        IMClient.shared.login(userID: (user.user?.userInfo?.userID).nonnull, token: user.huanXinImToken.nonnull)
        
        dPrint("当前登录用户 -- \(userID)")
        
        if save {
            UserDefaults.standard.set(try? JSONEncoder().encode(user), forKey: AppContext.loginUserKey)
        }
    }
    
    func logout() {
        IMClient.shared.logout()
        userContext = nil
        APIClient.credential = nil
        UserDefaults.standard.set(nil, forKey: AppContext.loginUserKey)
        Network.request(LoginAPI.logout).responseEmpty()
    }
}
