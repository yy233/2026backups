//
//  IMMessageViewModel.swift
//  Genz
//
//  Created by Sera on 2021/5/12.
//

import Foundation
import BasicKit
import BasicUIKit

enum ChatMessageFromType {
    case myself
    case other
}

class ChatMessageItem {
    var target: IMMessageItem?
    var messageID: String = ""                                  //消息ID
    var from: ChatMessageFromType = .myself                     //消息发送者类型
    var tipText: String?                                        //消息服务端提示：如spam
    var timestamp: Int64 = 0                                    //消息服务端时间戳，毫秒
    var displayTimeSection: Bool {                              //是否在此消息上方显示时间戳
        return innerShowTime
    }
    var extra:[String:Any]?
    
    fileprivate var innerShowTime: Bool = false                 //内部记录使用
    func configShowTime() {
        if let lastTimestamp = lastMessageTimestamp {
            innerShowTime = abs(timestamp - lastTimestamp) > 15*60*1000
            if innerShowTime {
                lastMessageTimestamp = timestamp
            }
        } else {
            lastMessageTimestamp = timestamp
            innerShowTime = true
        }
    }
    
    //MARK: - Cell
    var contentHeight: CGFloat { return 0 }
    var contentWidth: CGFloat { return 0 }
    var rowHeight: CGFloat {
        var height: CGFloat = 0
        
        if displayTimeSection {
            height += ChatMessageLayout.timeSectionMarginTop + ChatMessageLayout.timeSectionHeight + ChatMessageLayout.avatarMarginTime
        }
        else {
            height += ChatMessageLayout.contentMarginTopWithoutTime
        }
        
        height += contentHeight
        
        if !tipText.nonnull.isEmpty {
            height += ChatMessageLayout.tipsMarginContentBackground + ChatMessageLayout.tipsHeight + ChatMessageLayout.tipsMarginBottom
        }
        
        return height
    }

    required init() {}
    
    func wrapSendingMessage(chatType: IMMessageItem.IMChatType, chatWith: String) -> IMMessageItem {
        let imMessage = IMMessageItem()
        imMessage.from = AppContext.current.userID
        imMessage.to = chatWith
        imMessage.chatWith = chatWith
        imMessage.createTime = Int64(Date().timeIntervalSince1970*1000)
        imMessage.chatType = chatType
        imMessage.messageStatus = .sending
        imMessage.messageID = "iOS_\(chatWith)_\(Int64(Date().timeIntervalSince1970*1000))_\(arc4random())".md5
        
        target = imMessage
        messageID = imMessage.messageID
        return imMessage
    }
}

extension ChatMessageItem: IdentifierElement {
    var uniqueIdentifier: String { return messageID }
}

extension ChatMessageItem {
    struct ChatMessageLayout {
        static let contentMarginTopWithoutTime: CGFloat = 28.0
        static let timeSectionHeight: CGFloat = 20
        static let timeSectionMarginTop: CGFloat = 28.0
        static let avatarSize: CGFloat = 40.0
        static let avatarMarginLeft: CGFloat = 16.0
        static let avatarMarginTime: CGFloat = 28.0
        static let contentBackgroundMarginLeftRight: CGFloat = 12.0
        static let contentBackgroundMarginBottom: CGFloat = 11.0
        static let contentBackgroundMarginTop: CGFloat = 12.0
        static let tipsMarginLeftRight: CGFloat = 10.0
        static let tipsHeight: CGFloat = 20
        static let tipsMarginContentBackground: CGFloat = 10.0
        static let tipsMarginBottom: CGFloat = 0.0
        static let sendingIndicationSize: CGFloat = 28.0
        static let sendingIndicationMarginContentBackground: CGFloat = 10.0
        static let sentStatusSize: CGFloat = 28.0
        static let sentStatusMarginContentBackground: CGFloat = 10.0
        static let minimumContentBackgroundHeight: CGFloat = 46.0
    }
}

//计算聊天页显示时间的间隔
fileprivate var lastMessageTimestamp: Int64?
extension ChatMessageItem {
    static func resetLastMessageTimestamp() {
        lastMessageTimestamp = nil
    }
}

