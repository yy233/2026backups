//
//  IMClient.swift
//  Genz
//
//  Created by Sera on 2021/5/12.
//

import Foundation
import UIKit
import HyphenateChat
import BasicKit
import BasicUIKit
import AlbumUIKit

final class IMClient: NSObject {
    
    static let shared = IMClient()
        
    fileprivate override init() { super.init() }
    
    enum IMStatus: Int {
        case unknown = 0
        case failed = 1
        case linking = 2
        case syncing = 3
        case idle = 4
    }
    
    @Published var imStatus: IMStatus = .unknown
    
    func initlize() {
        let options = EMOptions(appkey: "1181230919209314#fmw")
        
        #if DEBUG
        options.enableConsoleLog = true
        options.apnsCertName = "fmw-apns" //环信后台配置同名，秘钥fmw123
        #else
        options.apnsCertName = "fmw-apns-release" //环信后台配置同名，秘钥fmw123
        #endif
        EMClient.shared().initializeSDK(with: options)
    }
}

//MARK: - 登录
extension IMClient {
    func login(userID: String, token: String) {
        if !EMClient.shared().isAutoLogin {
            EMClient.shared().login(withUsername: userID, token: token) {[weak self] name, error in
                if let error = error {
                    self?.imStatus = .failed
                    dPrint("IM登录失败 -- \(error.code.rawValue) -- \(error.errorDescription.nonnull)")
                } else {
                    dPrint("IM登录成功 -- \(name)")
                }
            }
        }
        EMClient.shared().add(self, delegateQueue: nil)
    }
    
    func logout() {
        EMClient.shared().removeDelegate(self)
        EMClient.shared().logout(true) { error in
            if let error = error {
                dPrint("IM退出失败 -- \(error.code)")
            } else {
                dPrint("IM退出成功")
            }
        }
    }
    
    func isLogined() -> Bool {
        return EMClient.shared().isLoggedIn
    }
    
    func unreadCount() -> Int32 {
        return EMClient.shared().chatManager?.getAllConversations()?.reduce(0, { partialResult, item in
            return partialResult.nonnull + item.unreadMessagesCount
        }) ?? 0
    }
}

//MARK: - Message
extension IMClient: EMClientDelegate {
    func userDidForbidByServer() {
        AppContext.current.logout()
        NotificationCenter.default.post(name: .notificationUserDidLogout, object: nil)
        Toast.toast(title: "此用户被禁用")
    }
    
    func userAccountDidForced(toLogout aError: EMError?) {
        AppContext.current.logout()
        NotificationCenter.default.post(name: .notificationUserDidLogout, object: nil)
        Toast.toast(title: aError?.errorDescription ?? "此用户被踢出")
    }
    
    func userAccountDidRemoveFromServer() {
        dPrint("IM账号被服务端移除")
    }
    
    func userAccountDidLogin(fromOtherDevice aDeviceName: String?) {
        AppContext.current.logout()
        NotificationCenter.default.post(name: .notificationUserDidLogout, object: nil)
        Toast.toast(title: "此用户已在其他设备登录")
    }
    
    func connectionStateDidChange(_ aConnectionState: EMConnectionState) {
        switch aConnectionState {
        case .connected:
            imStatus = .idle
        case .disconnected:
            imStatus = .failed
        default:break
        }
    }
}

//MARK: - 发送消息
extension IMClient {
    func sendTextMessage(messageItem: ChatTextMessageItem) {
        guard let imMessage = messageItem.target else { return assertionFailure() }
        sendIMMessage(message: imMessage, messageItem: messageItem)
    }
    
    func sendImageMessage(messageItems: [ChatImageMessageItem]) {
        for messageItem in messageItems {
            guard let imMessage = messageItem.target else { return assertionFailure() }
            uploadMediaFile(message: imMessage, messageItem: messageItem)
        }
    }
    
    func sendVideoMessage(messageItem: ChatVideoMessageItem) {
        guard let imMessage = messageItem.target else { return assertionFailure() }
        uploadMediaFile(message: imMessage, messageItem: messageItem)
    }
    
    func sendCustomMessage(messageItem: ChatCustomMessageItem) {
        guard let imMessage = messageItem.target else { return assertionFailure() }
        sendIMMessage(message: imMessage, messageItem: messageItem)
    }
    
    func resendMessage(message: IMMessageItem, messageItem: ChatMessageItem?) {
        message.messageStatus = .sending
        messageItem?.tipText = nil
        message.sdkMessage?.status = .delivering
        
        if let m = message.sdkMessage {
            EMClient.shared().chatManager?.update(m)
        }
        
        NotificationCenter.default.post(name: .notificationIMMessageStatusUpdate, object: messageItem)
        
        switch message.messageType {
        case .video, .image:
            if let url = message.serverFileURL, url.isNotEmpty {
                sendIMMessage(message: message, messageItem: messageItem)
            } else {
                uploadMediaFile(message: message, messageItem: messageItem)
            }
        default:
            sendIMMessage(message: message, messageItem: messageItem)
        }
    }
    
    fileprivate func uploadMediaFile(message: IMMessageItem, messageItem: ChatMessageItem?) {
        let fileName = message.localFileName.nonnull
        var filePath = ""
        var name: String = ""
        if let item = messageItem as? ChatImageMessageItem {
            filePath = item.filePath
            name = OSSUploader.imageIMFolder + fileName
        } else if let item  = messageItem as? ChatVideoMessageItem {
            filePath = item.filePath
            name = OSSUploader.videoIMFolder + fileName
        }
        
        OSSUploader.uploadFile(path: filePath, name: name) { _ in
            
        } completion: { error in
            if error == nil {
                message.serverFileURL = fileName
                self.sendIMMessage(message: message, messageItem: messageItem)
            } else {
                var dic = message.sdkMessage?.ext ?? [:]
                dic[IMMessageExtraKey.notice.rawValue] = "文件上传失败"
                message.sdkMessage?.ext = dic
                message.messageStatus = .failed
                messageItem?.tipText = "文件上传失败"
                if let m = message.sdkMessage {
                    EMClient.shared().chatManager?.update(m)
                }
                NotificationCenter.default.post(name: .notificationIMMessageStatusUpdate, object: messageItem)
            }
        }
    }
    
    func deleteMessage(_ message: IMMessageItem, messageItem: ChatMessageItem) {
        if let obj = messageItem as? ChatImageMessageItem {
            try? FileManager.default.removeItem(atPath: obj.filePath)
        }
        else if let obj = messageItem as? ChatVideoMessageItem {
            try? FileManager.default.removeItem(atPath: obj.filePath)
        }

        if let conversation = EMClient.shared().chatManager?.getConversation(message.chatWith, type: .chat, createIfNotExist: false) {
            conversation.deleteMessage(withId: message.messageID, error: nil)
        }
    }
    
    func deleteSession(_ item: IMSessionItem) {
        EMClient.shared().chatManager?.deleteConversation(item.chatWith, isDeleteMessages: true)
        let filePath = LocalFileContext.filePath(for: nil, module: .im, media: .all, targetUserID: item.chatWith)
        try? FileManager.default.removeItem(atPath: filePath)
    }
     
    func sendIMMessage(message: IMMessageItem, messageItem: ChatMessageItem?) {
        guard let sdkMessage = message.sdkMessage else { return }
        EMClient.shared().chatManager?.send(sdkMessage, progress: nil) { resultMessage, error in
            guard let resultMessage = resultMessage else { return }
            if let error = error {
                messageItem?.tipText = error.errorDescription
                message.messageStatus = .failed
                
                var dic = sdkMessage.ext ?? [:]
                dic[IMMessageExtraKey.notice.rawValue] = error.errorDescription
                resultMessage.ext = dic
            } else {
                messageItem?.tipText = nil
                message.messageStatus = .succeed
                
                var dic = sdkMessage.ext ?? [:]
                dic[IMMessageExtraKey.notice.rawValue] = nil
                resultMessage.ext = dic
            }
            
            message.sdkMessage = resultMessage
            message.messageID = resultMessage.messageId
            messageItem?.messageID = resultMessage.messageId
            EMClient.shared().chatManager?.update(resultMessage)
            NotificationCenter.default.post(name: .notificationIMMessageStatusUpdate, object: messageItem)
        }
    }
}

enum IMMessageExtraKey: String {
    case notice = "notice"
    case width = "width"
    case height = "height"
    case guid = "guid"
    case ext = "ext"
    case originChatWith = "originChatWith"
    case duration = "duration"
    case imageEvent = "image"
    case videoEvent = "video"
    case customEvent = "custom"
}
