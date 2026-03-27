//
//  ChatBaseMessageTableViewCell.swift
//  Genz
//
//  Created by Sera on 2021/5/12.
//

import Foundation
import SnapKit
import UIKit
import BasicKit
import BasicUIKit

class ChatBaseMessageTableViewCell: UITableViewCell {
    
    var resendMessageTapHandler: PureCompletionHandler?
    
    var showMenuPressHandler: ((CGRect) -> Void)?

    var messageItem: ChatMessageItem?
    func bindModel(_ messageItem: ChatMessageItem?) {
        selectionStyle = .none
        
        self.messageItem = messageItem
        guard let messageItem = messageItem, let targetMessage = messageItem.target else { return }
        
        if messageItem.displayTimeSection {
            timeSectionLabel.isHidden = false
            timeSectionLabel.text = Date(timeIntervalSince1970: TimeInterval(messageItem.timestamp)).displayString()
        } else {
            timeSectionLabel.isHidden = true
        }
        
        switch messageItem.from {
        case .myself:
            switch targetMessage.messageStatus {
            case .sending:
                sendingIndicatorView.isHidden = false
                sendingIndicatorView.startAnimating()
                sentFailedBtn.isHidden = true
            case .failed:
                sentFailedBtn.isHidden = false
                sendingIndicatorView.isHidden = true
            default:
                sendingIndicatorView.isHidden = true
                sentFailedBtn.isHidden = true
            }
        default:
            sendingIndicatorView.isHidden = true
            sentFailedBtn.isHidden = true
        }
        
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        guard let messageItem = messageItem else { return }

        switch messageItem.from {
        case .myself:
            avatarBtn.snp.remakeConstraints { make in
                make.width.height.equalTo(ChatMessageItem.ChatMessageLayout.avatarSize)
                make.right.equalTo(-ChatMessageItem.ChatMessageLayout.avatarMarginLeft)
                
                if messageItem.displayTimeSection {
                    make.top.equalTo(timeSectionLabel.snp.bottom).offset(ChatMessageItem.ChatMessageLayout.avatarMarginTime)
                }
                else {
                    make.top.equalTo(ChatMessageItem.ChatMessageLayout.contentMarginTopWithoutTime)
                }
            }

            contentBackgroundImageView.snp.remakeConstraints { make in
                make.right.equalTo(avatarBtn.snp.left).offset(-ChatMessageItem.ChatMessageLayout.contentBackgroundMarginLeftRight)
                make.top.equalTo(avatarBtn)
                make.width.height.equalTo(ChatMessageItem.ChatMessageLayout.minimumContentBackgroundHeight)
            }
        
            sendingIndicatorView.snp.remakeConstraints { make in
                make.width.height.equalTo(ChatMessageItem.ChatMessageLayout.sendingIndicationSize)
                make.centerY.equalTo(contentBackgroundImageView)
                make.right.equalTo(contentBackgroundImageView.snp.left).offset(-ChatMessageItem.ChatMessageLayout.sendingIndicationMarginContentBackground)
            }
            
            sentFailedBtn.snp.remakeConstraints { make in
                make.width.height.equalTo(ChatMessageItem.ChatMessageLayout.sentStatusSize)
                make.centerY.equalTo(contentBackgroundImageView)
                make.right.equalTo(contentBackgroundImageView.snp.left).offset(-ChatMessageItem.ChatMessageLayout.sentStatusMarginContentBackground)
            }
        default:
            avatarBtn.snp.remakeConstraints { make in
                make.width.height.equalTo(ChatMessageItem.ChatMessageLayout.avatarSize)
                make.left.equalTo(ChatMessageItem.ChatMessageLayout.avatarMarginLeft)
                
                if messageItem.displayTimeSection {
                    make.top.equalTo(timeSectionLabel.snp.bottom).offset(ChatMessageItem.ChatMessageLayout.avatarMarginTime)
                }
                else {
                    make.top.equalTo(ChatMessageItem.ChatMessageLayout.contentMarginTopWithoutTime)
                }
            }
            
            contentBackgroundImageView.snp.remakeConstraints { make in
                make.left.equalTo(avatarBtn.snp.right).offset(ChatMessageItem.ChatMessageLayout.contentBackgroundMarginLeftRight)
                make.top.equalTo(avatarBtn)
                make.width.height.equalTo(ChatMessageItem.ChatMessageLayout.minimumContentBackgroundHeight)
            }
            
            sendingIndicatorView.snp.remakeConstraints { make in
                make.width.height.equalTo(ChatMessageItem.ChatMessageLayout.sendingIndicationSize)
                make.centerY.equalTo(contentBackgroundImageView)
                make.left.equalTo(contentBackgroundImageView.snp.right).offset(ChatMessageItem.ChatMessageLayout.sendingIndicationMarginContentBackground)
            }
            
            sentFailedBtn.snp.remakeConstraints { make in
                make.width.height.equalTo(ChatMessageItem.ChatMessageLayout.sentStatusSize)
                make.centerY.equalTo(contentBackgroundImageView)
                make.left.equalTo(contentBackgroundImageView.snp.right).offset(ChatMessageItem.ChatMessageLayout.sentStatusMarginContentBackground)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeSectionLabel.text = nil
        sendingIndicatorView.isHidden = true
        sendingIndicatorView.stopAnimating()
        avatarBtn.image = nil
        avatarBtn.cancelCurrentWebImageLoad()
        contentBackgroundImageView.image = nil
        contentBackgroundImageView.cancelCurrentWebImageLoad()
    }
    
    //MARK: - View
    lazy var contentBackgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contentBackgroundTapHandler)))
        $0.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(contentBackgroundLongPressHandler(sender:))))
        contentView.addSubview($0)
    }
    
    lazy var avatarBtn = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarTapHandler)))
        contentView.addSubview($0)
    }
    
    fileprivate lazy var timeSectionLabel = UILabel().then {
        $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
        $0.textColor = color(0, 0, 0, 0.5)
        $0.textAlignment = .center
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.top.equalTo(ChatMessageItem.ChatMessageLayout.timeSectionMarginTop)
            make.height.equalTo(ChatMessageItem.ChatMessageLayout.timeSectionHeight)
            make.left.equalTo(ChatMessageItem.ChatMessageLayout.avatarMarginLeft)
            make.right.equalTo(-ChatMessageItem.ChatMessageLayout.avatarMarginLeft)
        }
    }
        
    fileprivate lazy var sentFailedBtn = UIButton().then {
        $0.setImage(UIImage(named: "lab_chat_failure_icon"), for: .normal)
        $0.addTarget(self, action: #selector(sentFailedBtnTapHandler), for: .touchUpInside)
        contentView.addSubview($0)
    }
    
    fileprivate lazy var sendingIndicatorView = UIActivityIndicatorView().then {
        if #available(iOS 13.0, *) {
            $0.style = .medium
        } else {
            $0.style = .white
        }
        contentView.addSubview($0)
    }
}

extension ChatBaseMessageTableViewCell {
    //MARK: - Tap
    @objc func contentBackgroundTapHandler() {}
    
    @objc fileprivate func contentBackgroundLongPressHandler(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        showMenuPressHandler?(contentBackgroundImageView.frame)
    }
    
    @objc fileprivate func avatarTapHandler() {
        guard let target = messageItem?.target else { return }
        UIManager.push(to: UserViewController().then { $0.userID = target.from })
    }
    
    @objc fileprivate func sentFailedBtnTapHandler() {
        guard let target = messageItem?.target else { return }
        IMClient.shared.resendMessage(message: target, messageItem: messageItem)
    }
}
