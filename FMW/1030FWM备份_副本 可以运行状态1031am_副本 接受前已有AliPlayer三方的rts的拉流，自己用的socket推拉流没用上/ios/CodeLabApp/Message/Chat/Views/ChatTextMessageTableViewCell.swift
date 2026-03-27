//
//  ChatTextMessageTableViewCell.swift
//  Genz
//
//  Created by Sera on 2021/5/12.
//

import Foundation
import SnapKit
import BasicKit
import BasicUIKit
import VideoPlayerKit
import ImagePreviewKit

final class ChatTextMessageTableViewCell: ChatBaseMessageTableViewCell {
    fileprivate lazy var contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .left
        contentView.insertSubview($0, aboveSubview: contentBackgroundImageView)
        $0.snp.makeConstraints { make in
            make.top.equalTo(contentBackgroundImageView)
            make.width.height.equalTo(ChatMessageItem.ChatMessageLayout.minimumContentBackgroundHeight)
            make.centerX.equalTo(contentBackgroundImageView)
        }
    }
    
    override func bindModel(_ messageItem: ChatMessageItem?) {
        guard let messageItem = messageItem as? ChatTextMessageItem else { return }
        
        contentLabel.attributedText = messageItem.contentAttributeText
        if messageItem.isOnlySingleEmoji {
            contentBackgroundImageView.backgroundColor = .clear
        }
        else {
            contentBackgroundImageView.backgroundColor = .white
            contentBackgroundImageView.layer.cornerRadius = 8.0
        }
        
        super.bindModel(messageItem)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        guard let messageItem = messageItem as? ChatTextMessageItem else { return }
        
        contentLabel.snp.updateConstraints { make in
            make.width.equalTo(messageItem.contentWidth)
            make.height.equalTo((messageItem.contentHeight))
        }
        
        if messageItem.isOnlySingleEmoji {
            contentBackgroundImageView.snp.updateConstraints { make in
                make.width.height.equalTo(messageItem.contentWidth)
            }
        }
        else {
            contentBackgroundImageView.snp.updateConstraints { make in
                make.width.equalTo(messageItem.contentWidth + ChatTextMessageItem.ChatTextMessageLayout.textPaddingLeftRight*2)
                make.height.equalTo(messageItem.contentHeight)
            }
        }
    }
}

final class ChatImageMessageTableViewCell: ChatBaseMessageTableViewCell {
    override func bindModel(_ messageItem: ChatMessageItem?) {
        guard let messageItem = messageItem as? ChatImageMessageItem else { return }
        
        if messageItem.filePath.isNotEmpty, FileManager.default.fileExists(atPath: messageItem.filePath) {
            contentBackgroundImageView.setWebImage(url: URL(fileURLWithPath: messageItem.filePath).absoluteString, cornerRadius: ChatImageMessageItem.ChatImageMessageLayout.cornerRadius*3.0, finalSize: CGSize(width: ChatImageMessageItem.ChatImageMessageLayout.imageWidth*3.0, height: messageItem.contentHeight*3.0))
        } else {
            contentBackgroundImageView.setWebImage(url: OSSUploader.imageIMURLFor(messageItem.imageServerName.nonnull), cornerRadius: ChatImageMessageItem.ChatImageMessageLayout.cornerRadius*3.0, finalSize: CGSize(width: ChatImageMessageItem.ChatImageMessageLayout.imageWidth*3.0, height: messageItem.contentHeight*3.0))
        }
        
        super.bindModel(messageItem)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        guard let messageItem = messageItem as? ChatImageMessageItem else { return }
        
        contentBackgroundImageView.snp.updateConstraints { make in
            make.width.equalTo(ChatImageMessageItem.ChatImageMessageLayout.imageWidth)
            make.height.equalTo(messageItem.contentHeight)
        }
    }
    
    override func contentBackgroundTapHandler() {
        guard let messageItem = messageItem as? ChatImageMessageItem else { return }
        
        if messageItem.filePath.isNotEmpty, FileManager.default.fileExists(atPath: messageItem.filePath) {
            ImagePreview.previewLocalPhotos([messageItem.filePath], from: contentBackgroundImageView)
        } else {
            ImagePreview.previewPhotos([OSSUploader.imageIMURLFor(messageItem.imageServerName.nonnull, crop: .origin)], fromView: contentBackgroundImageView)
        }
    }
}

final class ChatVideoMessageTableViewCell: ChatBaseMessageTableViewCell {
    lazy var playerView = VideoPlayerView().then {
        $0.layer.cornerRadius = ChatVideoMessageItem.ChatVideoMessageLayout.cornerRadius
        $0.layer.masksToBounds = true
        contentBackgroundImageView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    lazy var videoCoverView = UIImageView().then {
        $0.image = UIImage(named: "lab_feed_video_cover")
        contentView.insertSubview($0, aboveSubview: playerView)
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.center.equalTo(playerView)
        }
    }
    
    override func bindModel(_ messageItem: ChatMessageItem?) {
        guard let messageItem = messageItem as? ChatVideoMessageItem else { return }
        
        videoCoverView.isHidden = false
        
        if messageItem.filePath.isNotEmpty, FileManager.default.fileExists(atPath: messageItem.filePath) {
            playerView.bind(playerItem: VideoPlayerItem(identifier: messageItem.messageID, parentIdenfifier: "\(ChatViewController.self)-\(ChatVideoMessageTableViewCell.self)", videoURL: URL(fileURLWithPath: messageItem.filePath), thumbnailURL: URL(fileURLWithPath: messageItem.imagePath), contentMode: .scaleAspectFit, extra: nil))
        } else {
            playerView.bind(playerItem: VideoPlayerItem(identifier: messageItem.messageID, parentIdenfifier: "\(ChatViewController.self)-\(ChatVideoMessageTableViewCell.self)", videoURL: URL(string: OSSUploader.videoIMURLFor(messageItem.videoServerName.nonnull)).nonnull, thumbnailURL: URL(string: OSSUploader.imageURLFor(messageItem.videoServerName.nonnull)).nonnull, contentMode: .scaleAspectFit, extra: nil))
        }
        
        super.bindModel(messageItem)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        guard let messageItem = messageItem as? ChatVideoMessageItem else { return }
        
        contentBackgroundImageView.snp.updateConstraints { make in
            make.width.equalTo(ChatVideoMessageItem.ChatVideoMessageLayout.imageWidth)
            make.height.equalTo(messageItem.contentHeight)
        }
    }
    
    override func contentBackgroundTapHandler() {
        guard let messageItem = messageItem as? ChatVideoMessageItem else { return }
        if messageItem.filePath.isNotEmpty, FileManager.default.fileExists(atPath: messageItem.filePath) {
            let playerItem = VideoPlayerItem(identifier: messageItem.messageID, parentIdenfifier: "\(VideoPlayerViewController.self)-\(messageItem.messageID)", videoURL: URL(fileURLWithPath: messageItem.filePath), thumbnailURL: URL(fileURLWithPath: messageItem.imagePath), contentMode: .scaleAspectFit, extra: nil)
            UIManager.present(modal: VideoPlayerViewController(playerItem: playerItem).then {
                $0.modalPresentationStyle = .overFullScreen
            })
        } else {
            let playerItem = VideoPlayerItem(identifier: messageItem.messageID, parentIdenfifier: "\(VideoPlayerViewController.self)-\(messageItem.messageID)", videoURL: URL(string: OSSUploader.videoIMURLFor(messageItem.videoServerName.nonnull)).nonnull, thumbnailURL: URL(string: OSSUploader.imageURLFor(messageItem.videoServerName.nonnull)).nonnull, contentMode: .scaleAspectFit, extra: nil)
            UIManager.present(modal: VideoPlayerViewController(playerItem: playerItem).then {
                $0.modalPresentationStyle = .overFullScreen
            })
        }
    }
}
