//
//  Notification.Name.swift
//  CodeLabApp
//
//  Created by Sera on 2023/8/24.
//

import Foundation

extension Notification.Name {
    static let notificationUserDidLogin = Notification.Name("notificationUserDidLogin")
    static let notificationUserDidLogout = Notification.Name("notificationUserDidLogout")

    static let notificationFeedDidPublish = Notification.Name("notificationFeedDidPublish")
    static let notificationFeedDidDelete = Notification.Name("notificationFeedDidDelete")
    static let notificationCommunityFeedDidUpdateStatus = Notification.Name("notificationCommunityFeedDidUpdateStatus")
    static let notificationCommunityBroadcastFeedDidPublish = Notification.Name("notificationCommunityBroadcastFeedDidPublish")
    static let notificationFeedDidLikeUpdate = Notification.Name("notificationFeedDidLikeUpdate")
    static let notificationFeedDidCommentUpdate = Notification.Name("notificationFeedDidCommentUpdate")
    static let notificationFeedDidMarkUpdate = Notification.Name("notificationFeedDidMarkUpdate")

    static let notificationFansDidRemove = Notification.Name("notificationFansDidRemove")
    
    static let notificationIMMessageStatusUpdate = Notification.Name("notificationIMMessageStatusUpdate")
    static let notificationIMMessageWillSend = Notification.Name("notificationIMMessageWillSend")

    static let notificationPointsDidUpdate = Notification.Name("notificationPointsDidUpdate")
    static let notificationPointsDidTapNFTMall = Notification.Name("notificationPointsDidTapNFTMall")
    static let notificationPointsDidTapFeedRecommend = Notification.Name("notificationPointsDidTapFeedRecommend")
    
    static let notificationAddressDidDelete = Notification.Name("notificationAddressDidDelete")
    static let notificationAddressDidUpdate = Notification.Name("notificationAddressDidUpdate")
    static let notificationOrderDidUpdate = Notification.Name("notificationOrderDidUpdate")

}
