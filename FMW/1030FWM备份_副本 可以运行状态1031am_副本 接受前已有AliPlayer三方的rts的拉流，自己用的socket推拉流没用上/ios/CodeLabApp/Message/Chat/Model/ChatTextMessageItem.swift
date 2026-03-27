//
//  ChatTextMessageItem.swift
//  Genz
//
//  Created by Sera on 2021/5/12.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit

final class ChatTextMessageItem: ChatMessageItem {
    var supportSingleEmojiEnlarge = false               //是否支持单个Emoji时放大显示
    var isOnlySingleEmoji = false                       //文本是否只有单个Emoji
    var content: String = ""                            //文本

    lazy var contentAttributeText: NSAttributedString = {
        return NSAttributedString(string: content, attributes: [.font: UIFont.regularPingFangSCFont(ofSize: 14), .foregroundColor: color(0, 0, 0)])
    }()
    
    fileprivate lazy var innerContentSize: CGSize = {
        if contentAttributeText.length > 0, isOnlySingleEmoji {
            return CGSize(width: ChatTextMessageLayout.singleEmojiSize, height: ChatTextMessageLayout.singleEmojiSize)
        }
        return contentAttributeText.boundingRect(with: CGSize(width: ChatTextMessageLayout.maximumContentWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size
    }()
    
    override var contentHeight: CGFloat { return max(ceil(innerContentSize.height) + ChatTextMessageLayout.textPaddingTopBottom, ChatTextMessageLayout.minimumContentHeight) }
    override var contentWidth: CGFloat { return max(ceil(innerContentSize.width), ChatTextMessageLayout.minimumContentHeight - ChatTextMessageLayout.textPaddingLeftRight) }
    
    override func wrapSendingMessage(chatType: IMMessageItem.IMChatType, chatWith: String) -> IMMessageItem {
        let imMessage = super.wrapSendingMessage(chatType: chatType, chatWith: chatWith)
        imMessage.messageType = .text
        imMessage.text = content
        return imMessage
    }
}

extension ChatTextMessageItem {
    struct ChatTextMessageLayout {
        static let maximumContentWidth: CGFloat = UIManager.shared.screenWidth - 68*2
        static let minimumContentHeight: CGFloat = ChatMessageItem.ChatMessageLayout.minimumContentBackgroundHeight
        static let singleEmojiSize: CGFloat = 100.0
        static let textPaddingLeftRight: CGFloat = 12
        static let textPaddingTopBottom: CGFloat = 12
    }
}
