//
//  ChatVoiceMessageItem.swift
//  Genz
//
//  Created by Sera on 2021/5/12.
//

import Foundation
import BasicKit
import BasicUIKit

final class ChatVideoMessageItem: ChatMessageItem {
    var videoServerName: String?                //CDN资源路径，不包含扩展
    var videoCacheName: String?                 //本地资源名称，不包含扩展
    var duration: Int32 = 0                     //语音时长
    var hasPlayed: Bool = false                 //视频是否已播放过
    var imageSize: CGSize = .zero               //图片尺寸

    fileprivate lazy var innerContentHeight: CGFloat = {
        let ratio = max(1.0, imageSize.width)/max(1.0, imageSize.height)
        return ceil(ChatVideoMessageLayout.imageWidth/ratio)
    }()
    
    override var contentHeight: CGFloat { return innerContentHeight }
    override var contentWidth: CGFloat { return ChatVideoMessageLayout.imageWidth }

    var fileName: String { return videoCacheName.nonnull }
    var filePath: String { return fileName.isNotEmpty ? LocalFileContext.filePath(for: fileName, module: .im, media: .video, targetUserID: target?.to) : "" }
    var imagePath: String { return fileName.isNotEmpty ? LocalFileContext.filePath(for: fileName, module: .im, media: .image, targetUserID: target?.to) : "" }

    override func wrapSendingMessage(chatType: IMMessageItem.IMChatType, chatWith: String) -> IMMessageItem {
        let imMessage = super.wrapSendingMessage(chatType: chatType, chatWith: chatWith)
        imMessage.messageType = .video
        imMessage.localFileName = videoCacheName
        imMessage.serverFileURL = videoServerName
        imMessage.mediaTime = duration
        imMessage.isLocalMediaPlayed = true
        imMessage.mediaSize = imageSize
        return imMessage
    }
}

extension ChatVideoMessageItem {
    struct ChatVideoMessageLayout {
        static let imageWidth: CGFloat = UIManager.shared.screenWidth - 68*2 - 66
        static let cornerRadius: CGFloat = 8.0
    }
}
