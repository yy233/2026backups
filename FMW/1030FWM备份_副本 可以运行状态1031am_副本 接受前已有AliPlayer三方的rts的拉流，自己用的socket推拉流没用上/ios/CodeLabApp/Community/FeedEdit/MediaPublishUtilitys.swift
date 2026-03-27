//
//  MediaPublishUtilitys.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/6.
//

import Foundation
import CoreGraphics
import UIKit
import AVFoundation

struct MediaPublishUtilities {
    
    struct ImageInfo {
        let width: Int
        let height: Int
    }
    
    static func imageInfo(from data: Data) -> ImageInfo? {
        if let imageSource = CGImageSourceCreateWithData(data as CFData, [kCGImageSourceShouldCache: false] as CFDictionary) {
            if CGImageSourceGetCount(imageSource) > 0, let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) {
                let width = cgImage.width
                let height = cgImage.height
                return ImageInfo(width: width, height: height)
            }
        }
        return nil
    }
    
    struct VideoInfo {
        let width: Int
        let height: Int
        let duration: TimeInterval
        let thumbnailImage: UIImage
    }
    
    static func videoInfo(from url: URL) -> VideoInfo? {
        let asset = AVURLAsset(url: url, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        if let cgImage = try? generator.copyCGImage(at: .zero, actualTime: nil).copy(colorSpace: CGColorSpaceCreateDeviceRGB()) {
            let width = cgImage.width
            let height = cgImage.height
            return VideoInfo(width: width, height: height, duration: asset.duration.seconds, thumbnailImage: UIImage(cgImage: cgImage))
        }
        return nil
    }
}
