//
//  FeedEditItem.swift
//  Genz
//
//  Created by Sera on 2021/5/24.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit
import Combine
import AlbumUIKit

enum EditElementMedia {
    case video
    case livephoto
    case gif
    case photo
}

protocol FeedEditElement: IdentifierElement {
    var elementType: EditElementMedia { get }                   //视频、LivePhoto、GIF、图片
    var elementDuration: TimeInterval { get }                   //视频时长
    var elementWidth: Int { get }                               //分辨率宽
    var elementHeight: Int { get }                              //分辨率高
    var elementLocation: CLLocation? { get }                    //地点
    
    func fetchElementImage(isBig: Bool, saveToAlbum: Bool, isSynchrouns: Bool, completionHandler: @escaping (UIImage?, String) -> Void)
    func fetchElementVideo(saveToAlbum: Bool, completionHandler: @escaping (AVAsset?, UIImage?, String) -> Void)
    func fetchElementGifData(saveToAlbum: Bool, isSynchrouns: Bool, completionHandler: @escaping (Data?, String) -> Void)
    func fetchElementLivePhoto(saveToAlbum: Bool, completionHandler: @escaping (AVAsset?, UIImage?, String) -> Void)
}

extension FeedEditElement {
    func fetchElementImage(isBig: Bool, saveToAlbum: Bool, isSynchrouns: Bool, completionHandler: @escaping (UIImage?, String) -> Void) {}
    func fetchElementVideo(saveToAlbum: Bool, completionHandler: @escaping (AVAsset?, UIImage?, String) -> Void) {}
    func fetchElementGifData(saveToAlbum: Bool, isSynchrouns: Bool, completionHandler: @escaping (Data?, String) -> Void) {}
    func fetchElementLivePhoto(saveToAlbum: Bool, completionHandler: @escaping (AVAsset?, UIImage?, String) -> Void) {}
}

class FeedEditItem: IdentifierElement {
    var uniqueIdentifier: String { id }
    
    var id: String
    var createTime: TimeInterval
    
    var content: String?
    var location: LocationItem?
    var tagItem: TopicItem?
    var communityitem: CommunityItem?
    var saveToAlbum: Bool = false
    var thumbnailImage: UIImage?
    var elements: [any FeedEditElement] = []
    var isCommunityBroadcast: Bool = false
    
    var uploadedMedias: [FeedItem.ImageElement] = []
    
    init() {
        createTime = Date().timeIntervalSince1970
        id = "\(ApplicationInfo.bundleID).\(FeedEditItem.self).\(createTime).\(arc4random())"
    }
}

extension PHAsset: FeedEditElement {
    
    var elementType: EditElementMedia {
        if mediaType == .video {
            return .video
        } else if mediaType == .image {
            if mediaSubtypes == .photoLive {
                return .livephoto
            }
            if isGIF() {
                return .gif
            }
        }
        return .photo
    }
    
    var elementDuration: TimeInterval { return duration }
    var elementWidth: Int { return pixelWidth }
    var elementHeight: Int { return pixelHeight }
    var elementLocation: CLLocation? { return location }
    
    func fetchElementImage(isBig: Bool, saveToAlbum: Bool, isSynchrouns: Bool, completionHandler: @escaping (UIImage?, String) -> Void) {
        let identifier = uniqueIdentifier
        AlbumAssetsContext.fetchImage(for: self, resolution: isBig ? .feed : .detail, isSynchrous: isSynchrouns, progressHandler: nil) { image, _ in
            completionHandler(image, identifier)
        }
    }
    
    func fetchElementVideo(saveToAlbum: Bool, completionHandler: @escaping (AVAsset?, UIImage?, String) -> Void) {
        let identifier = uniqueIdentifier
        var thumbImage: UIImage?
        fetchElementImage(isBig: true, saveToAlbum: false, isSynchrouns: true) { image,_ in
            thumbImage = image
        }
        
        AlbumAssetsContext.fetchVideo(for: self) { avasset, _ in
            completionHandler(avasset, thumbImage, identifier)
        }
    }
    
    func fetchElementGifData(saveToAlbum: Bool, isSynchrouns: Bool, completionHandler: @escaping (Data?, String) -> Void) {
        let identifier = uniqueIdentifier
        AlbumAssetsContext.fetchGIFData(for: self, isSynchrous: isSynchrouns) { data,_ in
            completionHandler(data, identifier)
        }
    }
    
    func fetchElementLivePhoto(saveToAlbum: Bool, completionHandler: @escaping (AVAsset?, UIImage?, String) -> Void) {
        let identifier = uniqueIdentifier
        var thumbImage: UIImage?
        fetchElementImage(isBig: true, saveToAlbum: false, isSynchrouns: true) { image,_ in
            thumbImage = image
        }
        
        AlbumAssetsContext.fetchLivePhoto(for: self) { avasset, _ in
            completionHandler(avasset, thumbImage, identifier)
        }
    }
}

class CaptureImageItem: IdentifierElement, FeedEditElement {
    let image: UIImage
    let createTime: TimeInterval
    init(image: UIImage) {
        self.image = image
        createTime = Date().timeIntervalSince1970
    }
    
    var uniqueIdentifier: String { return "com.codelab.capture.image.\(createTime)" }
    
    var elementType: EditElementMedia { return .photo }
    var elementWidth: Int { return Int(image.size.width*image.scale) }
    var elementHeight: Int { return Int(image.size.height*image.scale) }
    var elementDuration: TimeInterval { return 0 }
    var elementLocation: CLLocation? { return nil }
    
    func fetchElementImage(isBig: Bool, saveToAlbum: Bool, isSynchrouns: Bool, completionHandler: @escaping (UIImage?, String) -> Void) {
        completionHandler(image, uniqueIdentifier)
    }
}

class CaptureVideoItem: IdentifierElement, FeedEditElement {
    let url: URL
    let createTime: TimeInterval
    let asset: AVURLAsset
    init(url: URL) {
        self.url = url
        createTime = Date().timeIntervalSince1970
        asset = AVURLAsset(url: url)
    }
    
    var uniqueIdentifier: String { return "com.codelab.capture.image.\(createTime)" }
    
    var elementType: EditElementMedia { return .video }
    var elementWidth: Int {
        if let track = asset.tracks(withMediaType: .video).first {
            let naturalSize = track.naturalSize.applying(track.preferredTransform)
            return Int(abs(naturalSize.width))
        }
        return Int(UIManager.shared.screenWidth)
    }
    var elementHeight: Int {
        if let track = asset.tracks(withMediaType: .video).first {
            let naturalSize = track.naturalSize.applying(track.preferredTransform)
            return Int(abs(naturalSize.height))
        }
        return Int(UIManager.shared.screenWidth)
    }
    var elementDuration: TimeInterval { return asset.duration.seconds }
    var elementLocation: CLLocation? { return nil }
    
    func fetchElementImage(isBig: Bool, saveToAlbum: Bool, isSynchrouns: Bool, completionHandler: @escaping (UIImage?, String) -> Void) {
        let assetImg = AVAssetImageGenerator(asset: asset)
        assetImg.appliesPreferredTrackTransform = true
        assetImg.apertureMode = .encodedPixels
        assetImg.requestedTimeToleranceAfter = CMTime(seconds: 1, preferredTimescale: 30)
        assetImg.requestedTimeToleranceBefore = CMTime(seconds: 1, preferredTimescale: 30)
        assetImg.maximumSize = isBig ? CGSize(width: 1280, height: 1280) : CGSize(width: 300, height: 300)
        
        var thumbnailImage: UIImage?
        do {
            let cgimgref = try assetImg.copyCGImage(at: CMTime(seconds: 1, preferredTimescale: 30), actualTime: nil)
            thumbnailImage = UIImage(cgImage: cgimgref)
        } catch {
            assertionFailure(error.localizedDescription)
        }
        completionHandler(thumbnailImage, uniqueIdentifier)
    }
}
