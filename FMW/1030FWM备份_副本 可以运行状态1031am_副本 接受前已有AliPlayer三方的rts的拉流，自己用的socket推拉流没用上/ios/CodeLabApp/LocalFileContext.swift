//
//  UserFileManager.swift
//  Genz
//
//  Created by Sera on 2021/5/13.
//

import Foundation
import BasicKit

struct LocalFileContext {
    //MARK: - App层文件路径
    private static func directoryPath(for document: Document) -> String {
        let path = document.value.appendingPathComponent(ApplicationInfo.displayName)
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
    
    private static func directoryPath(for media: Media, document: Document) -> String {
        //genz/Video
        let path = directoryPath(for: document).appendingPathComponent(media.rawValue)
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
    
    //MARK: - 用户文件路径
    private static func userPath(for media: Media, document: Document) -> String {
        //genz/User/123435
        let path = directoryPath(for: document).appendingPathComponent("User").appendingPathComponent(AppContext.current.userID)
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
    
    static func generateFileName(for media: Media) -> String {
        return "iOS_\(CFAbsoluteTimeGetCurrent()*1000)_\(arc4random())".md5 + media.pathExtension
    }
    
    static func filePath(for fileName: String?, module: Module, media: Media, targetUserID: String?) -> String {
        if fileName?.hasPrefix("/var") == true || fileName?.hasPrefix("file://") == true {
            return fileName.nonnull
        }
        
        //genz/User/123/im
        var path = userPath(for: media, document: .document).appendingPathComponent(module.rawValue)
        
        //genz/User/123/im/456
        if let userID = targetUserID, userID.isNotEmpty {
            path = path.appendingPathComponent(userID)
        }
        
        if media != .all {
            path = path.appendingPathComponent(media.rawValue)
        }
        
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        
        //genz/User/123/im/456/video/20238120128_12123.mp4
        if let fileName = fileName {
            path = path.appendingPathComponent(fileName)
        }
        
        return path
    }
}

extension LocalFileContext {
    enum Document {
        case tempory
        case cache
        case document
        
        fileprivate var value: String {
            switch self {
            case .document:
                return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first.nonnull
            case .cache:
                return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first.nonnull
            default:
                return NSTemporaryDirectory()
            }
        }
    }
    
    enum Module: String {
        case general = "General"
        case im = "IM"
    }
    
    enum Media: String {
        case all = ""
        case video = "Video"
        case audio = "Audio"
        case image = "Image"
        case gif = "GIF"
        case livePhoto = "Live"
        
        var pathExtension: String {
            switch self {
            case .video:
                return ".mp4"
            case .audio:
                return ".opus"
            case .image:
                return ".jpg"
            case .gif:
                return ".gif"
            case .livePhoto:
                return ".mp4"
            default:
                return ""
            }
        }
    }
}
