//
//  UserContext.swift
//  CodeLabApp
//
//  Created by Sera on 2023/8/23.
//

import Foundation
import BasicUIKit
import APIKit
import Combine
import Alamofire

class UserContext {
    var user: LoginInfo?
    
    @Published var unreadTotalCount = 0
    @Published var unreadCommentNoticeCount = 0
    @Published var unreadFollowNoticeCount = 0
    @Published var unreadLikeNoticeCount = 0
    @Published var unreadSystemNoticeCount = 0
    @Published var systemNoticeMessage: String?
    @Published var systemMessageTimestamp: Double?
    @Published var imUnreadCount = 0

    func refreshUnread() {
        imUnreadCount = Int(IMClient.shared.unreadCount())
        
        Network.request(NoticeAPI.unreadCount, encoding: URLEncoding.default).responseData {[weak self] response in
            if response.error == nil {
                let commentCount = response.data?["comment"] as? Int
                let followCount = response.data?["follow"] as? Int
                let likeCount = response.data?["likeMark"] as? Int
                let systemCount = response.data?["system"] as? Int
                
                self?.unreadCommentNoticeCount = commentCount.nonnull
                self?.unreadFollowNoticeCount = followCount.nonnull
                self?.unreadLikeNoticeCount = likeCount.nonnull
                self?.unreadSystemNoticeCount = systemCount.nonnull
                self?.unreadTotalCount = commentCount.nonnull + followCount.nonnull + likeCount.nonnull + systemCount.nonnull + (self?.imUnreadCount).nonnull
                
                if let dic = response.data?["lastSystemNotice"] as? [String: Any] {
                    self?.systemNoticeMessage = dic["title"] as? String
                    self?.systemMessageTimestamp = dic["createTimeMills"] as? Double
                }
                
//                UIApplication.shared.applicationIconBadgeNumber = (self?.unreadTotalCount).nonnull
            }
        }
    }
}

class UserInfo: Codable, IdentifierElement {
    var userID: String = ""
    var userName: String = ""
    var avatar: String = ""
    var introduction: String?
    var needInitRole: Bool?
    var relationship: UserProfile.Relation?

    var uniqueIdentifier: String { userID }
    
    enum CodingKeys: String, CodingKey {
        case userID = "uid"
        case userName = "nickName"
        case avatar
        case introduction
        case needInitRole
        case relationship
    }
}

class UserProfile: Codable {
    var userInfo: UserInfo?
    var relationship: Relation = .stranger
    var fansNum: Int = 0
    var followNum: Int = 0
    var feedNum: Int?
    var nftNum: Int?

    enum Relation: Int, Codable {
        case stranger = 0
        case own = 1
        case follow = 2
        case fan = 3
        case friend = 4
    }
    
    enum CodingKeys: String, CodingKey {
        case userInfo
        case relationship
        case fansNum
        case followNum
        case feedNum
        case nftNum = "nftGoodsNum"
    }
}

struct LoginInfo: Codable {
    var user: UserProfile?
    var sessionId: String?
    var huanXinImToken: String?
    
    enum CodingKeys: CodingKey {
        case user
        case sessionId
        case huanXinImToken
    }
}
