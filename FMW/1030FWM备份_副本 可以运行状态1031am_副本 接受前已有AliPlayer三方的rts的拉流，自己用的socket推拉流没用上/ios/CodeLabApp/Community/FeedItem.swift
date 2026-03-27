//
//  FeedItem.swift
//  CodeLabApp
//
//  Created by Sera on 2023/8/25.
//

import Foundation
import YYImage
import BasicKit
import BasicUIKit

class FeedItem: Codable, Identifiable, IdentifierElement {
    var id: String = ""
    var content: String?
    var images: [ImageElement] = []
    var uniqueIdentifier: String { id }

    var createTime: Double = 0
    
    var isLike: Bool = false
    var commentsCount: Int = 0
    var likesCount: Int = 0
    var shareCount: Int = 0
    var isMark: Bool = false
    var markCount: Int = 0

    var topic: [TopicItem]?
    var location: LocationItem?
    var community: CommunityItem?
    var city: String?

    var user: UserInfo?
    
    class ImageElement: Codable {
        var ext: String = ""
        var guid: String = ""
        var ht: Double = 0
        var wt: Double = 0
        var duration: Double = 0
        
        enum CodingKeys: CodingKey {
            case ext
            case guid
            case ht
            case wt
            case duration
        }
        
        var isVideo: Bool {
            return ext == "mp4"
        }
        
        lazy var imageWidth: CGFloat = UIManager.shared.screenWidth - 32
        lazy var imageHeight: CGFloat = {
            var imageHeight = imageWidth
            var ratio = min(4.0/3.0, max(3.0/4.0, ht/wt))
            imageHeight = ratio*imageHeight
            return ceil(imageHeight)
        }()
        
        lazy var imageCollectionWidth: CGFloat = (UIManager.shared.screenWidth - 16*2 - 13)/2.0
        
        lazy var imageCollectionHeight: CGFloat = {
            var imageHeight = imageCollectionWidth
            var ratio = min(4.0/3.0, max(3.0/4.0, ht/wt))
            imageHeight = ratio*imageHeight
            return ceil(imageHeight)
        }()
    }
    
    lazy var hasExtra: Bool = {
        community != nil || topic != nil || location != nil
    }()
    
    lazy var contentAttributedText: NSAttributedString = {
        NSAttributedString(string: content.nonnull, attributes: [.font: UIFont.mediumPingFangSCFont(ofSize: 14)])
    }()
    
    lazy var contentHeight: CGFloat = {
        ceil(contentAttributedText.boundingRect(with: CGSize(width: UIManager.shared.screenWidth - 32, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).height) + 1
    }()
    
    lazy var contentCollectionHeight: CGFloat = {
        ceil(contentAttributedText.boundingRect(with: CGSize(width: (UIManager.shared.screenWidth - 16*2 - 13)/2.0, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin, .usesDeviceMetrics], context: nil).height) + 1
    }()
    
    enum CodingKeys: String, CodingKey {
        case id = "feedId"
        case content = "desc"
        case images
        case createTime = "createTimeMills"
        case isLike = "like"
        case isMark = "mark"
        case commentsCount = "commentNum"
        case likesCount = "likeNum"
        case shareCount = "shareNum"
        case markCount = "markNum"
        case topic = "labels"
        case location = "poi"
        case community
        case user
        case city = "location"
    }
}

struct LocationItem: Codable, IdentifierElement {
    var id: String = ""
    var name: String = ""
    var location: String?
    var pname: String?
    var cname: String?
    var address: String?
    
    var uniqueIdentifier: String { id }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case location
        case pname
        case cname
        case address
    }
}

struct TopicItem: Codable, IdentifierElement {
    var id: String = ""
    var name: String = ""
    
    var uniqueIdentifier: String { id }
    
    enum CodingKeys: CodingKey {
        case id
        case name
    }
}

struct CommunityItem: Codable, IdentifierElement {
    var id: String = ""
    var name: String = ""
    var image: String = ""
    var intro: String?
    
    var isFollow: Bool?
    var followCount: Int?
    var feedCount: Int?
    
    var manager: [UserInfo]?
    var topFeed: FeedInfo?
    var broadcastFeed: FeedInfo?
    
    var uniqueIdentifier: String { id }
    
    struct FeedInfo: Codable {
        var feedId: String = ""
        var desc: String = ""
        
        enum CodingKeys: CodingKey {
            case feedId
            case desc
        }
        
        var feedItem: FeedItem {
            let feed = FeedItem()
            feed.id = feedId
            feed.content = desc
            return feed
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image = "icon"
        case intro = "introduction"
        case isFollow = "follow"
        case followCount = "followNum"
        case feedCount = "feedNum"
        case manager = "admins"
        case topFeed = "topFeedInfo"
        case broadcastFeed = "noticeFeedInfo"
    }
}

class CommentReplyResponse: Codable {
    var hasNext: Bool = false
    var nextOffset: Int = 0
    var total: Int = 0
    var list: [CommentItem] = []
    
    enum CodingKeys: CodingKey {
        case hasNext
        case nextOffset
        case total
        case list
    }
}

class CommentItem: Codable, Identifiable, IdentifierElement {
    var id: String = ""
    var content: String = ""
    var location: String?
    var time: Double = 0
    var feedId: String = ""
    
    var uniqueIdentifier: String { id }
    
    var user: UserInfo?
    var replyUser: UserInfo?
    
    var isReply: Bool { replyUser != nil }
    var isFeedOwner: Bool = false
    var reply: CommentReplyResponse?
    
    lazy var contentAttributedText: NSAttributedString = {
        if isReply {
            let attribute = NSMutableAttributedString()
            attribute.append(NSAttributedString(string: "回复 ", attributes: [.font: UIFont.regularPingFangSCFont(ofSize: 14)]))
            attribute.append(NSAttributedString(string: "\((replyUser?.userName).nonnull)", attributes: [.font: UIFont.regularPingFangSCFont(ofSize: 14), .foregroundColor: color(0, 0, 0, 0.6)]))
            attribute.append(NSAttributedString(string: " \(content)", attributes: [.font: UIFont.regularPingFangSCFont(ofSize: 14)]))
            return attribute
        }
        return NSAttributedString(string: content, attributes: [.font: UIFont.regularPingFangSCFont(ofSize: 14)])
    }()
    
    lazy var contentHeight: CGFloat = {
        ceil(contentAttributedText.boundingRect(with: CGSize(width: UIManager.shared.screenWidth - 76 - 16, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).height) + 1
    }()
    
    enum CodingKeys: String, CodingKey {
        case id = "commentId"
        case content
        case location
        case time = "createTimeMills"
        case feedId
        case user
        case reply
        case replyUser = "toUser"
    }
}
