//
//  ChatCustomMessageItem.swift
//  Genz
//
//  Created by Sera on 2021/5/13.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit

final class ChatCustomMessageItem: ChatMessageItem {
    
    var customMessageType: ChatCustomMessageType = .unknown
    var avatar: String? //全路径
    var title: String?
    var subtitle: String?
    var content: String?

    lazy var contentAttributeText: NSAttributedString = {
        let attributeText = NSMutableAttributedString(string: content.nonnull, attributes: [.font: customMessageType.contentFont, .foregroundColor: customMessageType.contentColor])
        return attributeText
    }()
    
    lazy var innerContentHeight: CGFloat = {
        return contentAttributeText.boundingRect(with: CGSize(width: customMessageType.contentWidth, height: customMessageType.maximumContentHeight), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size.height
    }()
    
    lazy var innerMediaHeight: CGFloat = {
        return 0
    }()
    
    override var contentHeight: CGFloat {
        switch customMessageType {
        default:
            return innerContentHeight
        }
    }
    
    override func wrapSendingMessage(chatType: IMMessageItem.IMChatType, chatWith: String) -> IMMessageItem {
        let imMessage = super.wrapSendingMessage(chatType: chatType, chatWith: chatWith)
        imMessage.messageType = .raw
        imMessage.customArg1 = Int32(customMessageType.rawValue)
        
        var dic = [String: String]()
        dic["avatar"] = avatar.nonnull
        dic["title"] = title.nonnull
        dic["subtitle"] = subtitle.nonnull
        dic["content"] = content.nonnull
        imMessage.customData = dic
        return imMessage
    }
    
    static func mappingFromContent(_ content: [String: Any]) -> ChatCustomMessageItem {
        let messageItem = ChatCustomMessageItem()
        messageItem.avatar = content["avatar"] as? String
        messageItem.title = content["title"] as? String
        messageItem.subtitle = content["subtitle"] as? String
        messageItem.content = content["content"] as? String
        return messageItem
    }
}

extension ChatCustomMessageItem {
    enum ChatCustomMessageType: Int {
        case unknown = 0
        
        //UI消息
        case notice = 1001
    
        var contentColor: UIColor {
            switch self {
            default:
                return color(0, 0, 0)
            }
        }
        
        var contentFont: UIFont {
            switch self {
            default:
                return UIFont.regularPingFangSCFont(ofSize: 14)
            }
        }
        
        var maximumContentHeight: CGFloat {
            switch self {
            default:
                return CGFloat.greatestFiniteMagnitude
            }
        }
        
        var contentWidth: CGFloat {
            switch self {
            default:
                return ChatImageMessageItem.ChatImageMessageLayout.imageWidth - contentPadding
            }
        }
        
        var contentPadding: CGFloat {
            switch self {
            default:
                return 15*2
            }
        }
    }
}
