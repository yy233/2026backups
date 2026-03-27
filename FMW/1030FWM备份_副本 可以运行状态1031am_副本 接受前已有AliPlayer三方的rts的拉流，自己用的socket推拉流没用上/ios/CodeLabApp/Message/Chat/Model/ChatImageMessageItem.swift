//
//  ChatImageMessageItem.swift
//  Genz
//
//  Created by Sera on 2021/5/12.
//

import Foundation
import Photos
import BasicKit
import BasicUIKit

final class ChatImageMessageItem: ChatMessageItem {
    var imageCacheName: String?                         //本地资源名称
    var imageServerName: String?                        //CDN资源路径
    var imageSize: CGSize = .zero                       //图片尺寸

    fileprivate lazy var innerContentHeight: CGFloat = {
        let ratio = max(1.0, imageSize.width)/max(1.0, imageSize.height)
        return ceil(ChatImageMessageLayout.imageWidth/ratio)
    }()
    
    var fileName: String { return imageCacheName.nonnull }
    var filePath: String { return fileName.isNotEmpty ? LocalFileContext.filePath(for: fileName, module: .im, media: .image, targetUserID: target?.to) : "" }
    override var contentHeight: CGFloat { return innerContentHeight }
    override var contentWidth: CGFloat { return ChatImageMessageLayout.imageWidth }
    
    override func wrapSendingMessage(chatType: IMMessageItem.IMChatType, chatWith: String) -> IMMessageItem {
        let imMessage = super.wrapSendingMessage(chatType: chatType, chatWith: chatWith)
        imMessage.messageType = .image
        imMessage.localFileName = imageCacheName
        imMessage.mediaSize = imageSize
        return imMessage
    }
}

extension ChatImageMessageItem {
    struct ChatImageMessageLayout {
        static let imageWidth: CGFloat = UIManager.shared.screenWidth - 68*2 - 66
        static let cornerRadius: CGFloat = 8.0
    }
}
