//
//  IMMessageItem-ChatMessageItem.swift
//  Genz
//
//  Created by Sera on 2022/6/21.
//

import Foundation
import BasicKit
import BasicUIKit

extension IMMessageItem {
    func wrapViewMessageItem() -> ChatMessageItem {
        var messageItem: ChatMessageItem?
        switch messageType {
        case .text:
            let textItem = ChatTextMessageItem()
            textItem.content = text.nonnull
            messageItem = textItem
        case .image:
            let imageItem = ChatImageMessageItem()
            imageItem.imageServerName = serverFileURL
            imageItem.imageCacheName = localFileName
            imageItem.imageSize = mediaSize
            messageItem = imageItem
        case .video:
            let videoItem = ChatVideoMessageItem()
            videoItem.videoServerName = serverFileURL
            videoItem.videoCacheName = localFileName
            videoItem.hasPlayed = isLocalMediaPlayed
            videoItem.duration = mediaTime
            videoItem.imageSize = mediaSize
            messageItem = videoItem
        default:
            break
        }
                
        if messageItem == nil {
            let textItem = ChatTextMessageItem()
            textItem.content = "当前版本不支持查看此类消息"
            messageItem = textItem
        }

        messageItem?.timestamp = createTime
        messageItem?.from = (from == AppContext.current.userID ? .myself : .other)
        messageItem?.messageID = messageID
        messageItem?.tipText = extra?[IMMessageExtraKey.notice.rawValue] as? String
        messageItem?.target = self
        messageItem?.extra = extra
        
        return messageItem!
    }
    
    var lastTextDesc: String? {
        switch messageType {
        case .text:
            return text
        case .image:
            return "[图片]"
        case .video:
            return "[视频]"
        case .raw:
            if let _ = ChatCustomMessageItem.ChatCustomMessageType(rawValue: Int(customArg1)) {
                return "[系统消息]"
            } else {
                return "[未知消息类型]"
            }
        default:
            return "[未知消息类型]"
        }
    }
}
