//
//  ChatNoticeMessageItem.swift
//  Genz
//
//  Created by Sera on 2021/5/12.
//

import Foundation
import BasicKit
import BasicUIKit
import UIKit

final class ChatNoticeItem: ChatMessageItem {
    var notice: String = ""
    
    lazy var noticeAttributeText: NSAttributedString = {
        return NSAttributedString.init(string: notice, attributes: [.font: UIFont.regularPingFangSCFont(ofSize: 14), .foregroundColor: color(0, 0, 0, 0.3)])
    }()
    
    fileprivate lazy var innerContentHeight: CGFloat = {
        return noticeAttributeText.boundingRect(with: CGSize(width: ChatNoticeMessageLayout.maximumContentWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).height
    }()
    
    override var contentHeight: CGFloat { return ceil(innerContentHeight) }
    override var rowHeight: CGFloat { return contentHeight + ChatNoticeMessageLayout.noticeMarginTop*3 }
}

extension ChatNoticeItem {
    struct ChatNoticeMessageLayout {
        static let maximumContentWidth: CGFloat = UIManager.shared.screenWidth - 32
        static let noticeMarginTop: CGFloat = 15.0
        static let noticeMarginLeftRight: CGFloat = 16.0
    }
}
