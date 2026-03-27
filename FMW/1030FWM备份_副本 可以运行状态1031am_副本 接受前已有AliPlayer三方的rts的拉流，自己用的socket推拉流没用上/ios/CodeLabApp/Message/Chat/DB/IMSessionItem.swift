//
//  IMSessionItem.swift
//  Genz
//
//  Created by Sera on 2022/3/15.
//

import Foundation
import HyphenateChat
import BasicKit
import BasicUIKit

final class IMSessionItem {
    var chatWith: String = ""
    var chatType: IMMessageItem.IMChatType = .single
    var updateTime: Int64 = 0
    var unreadCount: Int32 = 0
    var lastMessage: IMMessageItem?
        
    var profile: UserProfile?
}

extension IMSessionItem: IdentifierElement {
    var uniqueIdentifier: String { return chatWith }
}

extension EMConversation {
    var sessionItem: IMSessionItem {
        let sessionItem = IMSessionItem()
        sessionItem.chatType = .single
        sessionItem.chatWith = conversationId
        sessionItem.updateTime = (latestMessage?.timestamp).nonnull
        sessionItem.unreadCount = unreadMessagesCount
        sessionItem.lastMessage = latestMessage?.wrapToIMMessageItem
        return sessionItem
    }
}
