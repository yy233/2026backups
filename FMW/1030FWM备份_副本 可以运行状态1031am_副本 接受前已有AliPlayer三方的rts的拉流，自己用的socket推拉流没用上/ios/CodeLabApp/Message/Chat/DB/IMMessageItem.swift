//
//  IMMessageItem.swift
//  Genz
//
//  Created by Sera on 2022/3/16.
//

import Foundation
import HyphenateChat
import BasicKit
import BasicUIKit

final class IMMessageItem {
    //基础数据
    var from: String = ""
    var to: String = ""
    var chatWith: String = ""
    var chatType: IMChatType = .single
    var messageID: String = ""
    var createTime: Int64 = 0
    var messageType: IMMessageType = .text
    var messageStatus: IMMessageStatus = .succeed
    var extra: [String:Any]?
    
    //文本消息
    var text: String?
    
    //自定义消息
    var customArg1: Int32 = 0
    var customData: [String: String]?
    
    //媒体消息
    var localFileName: String?
    var serverFileURL: String?
    var mediaSize: CGSize = .zero
    var mediaTime: Int32 = 0
    var isLocalMediaPlayed: Bool = false

    var profile: UserProfile?
    
    //只允许生成一次
    var sdkMessage: EMChatMessage?
    func generateSDKMessage() -> EMChatMessage {
        let body: EMMessageBody = {
            switch messageType {
            case .image:
                return EMCustomMessageBody(event: IMMessageExtraKey.imageEvent.rawValue,
                                           customExt: [IMMessageExtraKey.width.rawValue: "\(mediaSize.width)",
                                                       IMMessageExtraKey.height.rawValue: "\(mediaSize.height)",
                                                       IMMessageExtraKey.guid.rawValue: localFileName.nonnull.deletingPathExtension,
                                                       IMMessageExtraKey.ext.rawValue: "jpg"])
            case .text:
                return EMTextMessageBody(text: text)
            case .video:
                return EMCustomMessageBody(event: IMMessageExtraKey.videoEvent.rawValue,
                                           customExt: [IMMessageExtraKey.width.rawValue: "\(mediaSize.width)",
                                                       IMMessageExtraKey.height.rawValue: "\(mediaSize.height)",
                                                       IMMessageExtraKey.guid.rawValue: localFileName.nonnull.deletingPathExtension,
                                                       IMMessageExtraKey.ext.rawValue: "mp4",
                                                       IMMessageExtraKey.duration.rawValue: "\(mediaTime)"])
            default:
                return EMCustomMessageBody(event: IMMessageExtraKey.customEvent.rawValue, customExt: customData)
            }
        }()
        
        let message = EMChatMessage(conversationID: chatWith, from: from, to: to, body: body, ext: extra)
        messageID = message.messageId
        message.chatType = .chat
        message.direction = from == AppContext.current.userID ? .send : .receive
        message.localTime = createTime
        message.isListened = isLocalMediaPlayed
        
        switch messageStatus {
        case .failed:
            message.status = .failed
        case .sending:
            message.status = .delivering
        case .succeed:
            message.status = .succeed
        }
        return message
    }
}

extension IMMessageItem: IdentifierElement {
    var uniqueIdentifier: String { return messageID }
}

extension IMMessageItem {
    enum IMChatType: Int {
        case single = 1
        case group
        case custom
        case room
    }
    
    enum IMMessageStatus: Int {
        case sending
        case failed
        case succeed
    }
    
    enum IMMessageType: Int {
        case raw
        case text
        case image
        case video
    }
}

extension EMChatMessage {
    var wrapToIMMessageItem: IMMessageItem {
        let messageItem = IMMessageItem()
        messageItem.chatWith = conversationId
        messageItem.from = from
        messageItem.to = to
        messageItem.chatType = .single
        messageItem.messageID = messageId
        messageItem.createTime = timestamp
        messageItem.isLocalMediaPlayed = isListened
        
        if let body = body as? EMTextMessageBody {
            messageItem.messageType = .text
            messageItem.text = body.text
        } else if let body = body as? EMCustomMessageBody {
            if body.event == IMMessageExtraKey.imageEvent.rawValue {
                messageItem.messageType = .image
                if let extra = body.customExt {
                    let width = Double(extra[IMMessageExtraKey.width.rawValue].nonnull).nonnull
                    let height = Double(extra[IMMessageExtraKey.height.rawValue].nonnull).nonnull
                    let guid = extra[IMMessageExtraKey.guid.rawValue].nonnull
                    messageItem.mediaSize = CGSize(width: width, height: height)
                    messageItem.localFileName = guid.appendingPathExtension(".jpg")
                    messageItem.serverFileURL = OSSUploader.imageIMURLFor(guid)
                }
            } else if body.event == "video" {//视频暂不处理
                messageItem.messageType = .video
            } else {
                messageItem.messageType = .raw
                messageItem.extra = body.customExt
            }
        }
        
        switch status {
        case .pending, .delivering:
            messageItem.messageStatus = .sending
        case .failed:
            messageItem.messageStatus = .failed
        default:
            messageItem.messageStatus = .succeed
        }
        messageItem.extra = ext as? [String: Any]
        return messageItem
    }
}
