       //
//  OSSUploader.swift
//  CodeLabApp
//
//  Created by Sera on 2023/8/31.
//

import Foundation
import AliyunOSSiOS
import BasicKit
import APIKit
import Alamofire

struct OSSUploader {
    static let endpoint = "https://oss-cn-shanghai.aliyuncs.com"
    static let bucket = "fmw-feed"
    
    static let sourceUrl = "https://fmw-feed.oss-cn-shanghai.aliyuncs.com/"
    static let imageFolder = "feed/"
    static let videoFolder = "feed/"
    static let imageIMFolder = "im/"
    static let videoIMFolder = "im/"
    static let imageNFTFolder = "nft/"
    
    enum Crop: String {
        case origin = ""
        case small = "s"
        case medium = "m"
        case big = "b"
        
        func suffixAppendFor(url: String) -> String {
            if url.contains("x-oss-process") || rawValue.isEmpty { return url }
            return url.appending("\(url.contains("?") ? "&" : "?")x-oss-process=style/\(rawValue)")
        }
    }

    private static var accessKeyId = ""
    private static var accessKeySecret = ""
    private static var securityToken = ""

    static func videoURLFor(_ name: String) -> String {
        if name.hasPrefix("http://") || name.hasPrefix("https://") {
            return name
        }
        return "\(sourceUrl)\(videoFolder)\(name)" + (name.pathExtension.isEmpty ? ".mp4" : "")
    }
    
    static func imageURLFor(_ name: String, crop: Crop = .big) -> String {
        if name.hasPrefix("http://") || name.hasPrefix("https://") {
            return crop.suffixAppendFor(url: name)
        }
        
        let url = "\(sourceUrl)\(imageFolder)\(name)" + (name.pathExtension.isEmpty ? ".jpg" : "")
        return crop.suffixAppendFor(url: url)
    }
    
    static func avatarURLFor(_ name: String, crop: Crop = .big) -> String {
        if name.hasPrefix("http://") || name.hasPrefix("https://") {
            return crop.suffixAppendFor(url: name)
        }
        
        let url = "\(sourceUrl)\(imageFolder)\(name)" + (name.pathExtension.isEmpty ? ".jpg" : "")
        return crop.suffixAppendFor(url: url)
    }
    
    static func videoIMURLFor(_ name: String) -> String {
        if name.hasPrefix("http://") || name.hasPrefix("https://") {
            return name
        }
        return "\(sourceUrl)\(videoIMFolder)\(name)" + (name.pathExtension.isEmpty ? ".mp4" : "")
    }
    
    static func imageIMURLFor(_ name: String, crop: Crop = .big) -> String {
        if name.hasPrefix("http://") || name.hasPrefix("https://") {
            return crop.suffixAppendFor(url: name)
        }
        
        let url = "\(sourceUrl)\(imageIMFolder)\(name)" + (name.pathExtension.isEmpty ? ".jpg" : "")
        return crop.suffixAppendFor(url: url)
    }
    
    static func imageNFTURLFor(_ name: String, crop: Crop = .big) -> String {
        if name.hasPrefix("http://") || name.hasPrefix("https://") {
            return crop.suffixAppendFor(url: name)
        }
        
        let url = "\(sourceUrl)\(name.hasPrefix(imageNFTFolder) ? name : "\(imageNFTFolder)\(name)")" + (name.pathExtension.isEmpty ? ".jpg" : "")
        return crop.suffixAppendFor(url: url)
    }
    
    static var retryCount = 0
    static func refreshOSSToken() {
        Network.request(LoginAPI.getOSSToken, encoding: URLEncoding.default).responseData { response in
            if let _ = response.error {
                if retryCount < 5 {
                    retryCount += 1
                    refreshOSSToken()
                }
            } else {
                retryCount = 0
                accessKeyId = response.data?["accessKeyId"] as? String ?? ""
                accessKeySecret = response.data?["accessKeySecret"] as? String ?? ""
                securityToken = response.data?["securityToken"] as? String ?? ""
                ossClient.credentialProvider = OSSStsTokenCredentialProvider(accessKeyId: accessKeyId, secretKeyId: accessKeySecret, securityToken: securityToken)
            }
        }
    }
    
    static let ossClient: OSSClient = {
        let credential = OSSStsTokenCredentialProvider(accessKeyId: accessKeyId, secretKeyId: accessKeySecret, securityToken: securityToken)
        
        let config = OSSClientConfiguration()
        config.isHttpdnsEnable = true
        config.enableBackgroundTransmitService =  true
        config.userAgentMark = ApplicationInfo.deviceInfo.userAgent
        config.isAllowUACarrySystemInfo = true
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        
        #if DEBUG
        OSSLog.enable()
        #endif
        
        return OSSClient(endpoint: endpoint, credentialProvider: credential, clientConfiguration: config)
    }()
    
    static func uploadFile(path: String,
                           name: String,
                           waitFinished: Bool = false,
                           progress: @escaping (Double) -> Void,
                           completion: @escaping (Error?) -> Void) {
        let put = OSSPutObjectRequest()
        put.bucketName = bucket
        put.objectKey = name
        put.uploadingFileURL = URL(fileURLWithPath: path)
        put.uploadProgress = { bytesSent, totalBytesSent, totalBytesExpectedToSend in
            progress(Double(totalBytesSent)/Double(totalBytesExpectedToSend))
        }
        
        let task = ossClient.putObject(put)
        task.continue({ task in
            if (task.error as? NSError)?.code == OSSClientErrorCODE.codeSignFailed.rawValue {
                refreshOSSToken()
            }
            completion(task.error)
            return nil
        })
        
        if waitFinished {
            task.waitUntilFinished()
        }
    }
    
    static func uploadData(data: Data,
                           name: String,
                           waitFinished: Bool = false,
                           progress: @escaping (Double) -> Void,
                           completion: @escaping (Error?) -> Void) {
        let put = OSSPutObjectRequest()
        put.bucketName = bucket
        put.objectKey = name
        put.uploadingData = data
        put.uploadProgress = { bytesSent, totalBytesSent, totalBytesExpectedToSend in
            progress(Double(totalBytesSent)/Double(totalBytesExpectedToSend))
        }
        
        let task = ossClient.putObject(put)
        task.continue({ task in
            if (task.error as? NSError)?.code == OSSClientErrorCODE.codeSignFailed.rawValue {
                refreshOSSToken()
            }
            completion(task.error)
            return nil
        })
        
        if waitFinished {
            task.waitUntilFinished()
        }
    }
    
    static func uploadChunkFile(path: String,
                                name: String,
                                waitFinished: Bool = false,
                                progress: @escaping (Double) -> Void,
                                completion: @escaping (Error?) -> Void) {
        let put = OSSMultipartUploadRequest()
        put.bucketName = bucket
        put.objectKey = name
        put.partSize = 500*1024
        put.uploadingFileURL = URL(fileURLWithPath: path)
        put.uploadProgress = { bytesSent, totalBytesSent, totalBytesExpectedToSend in
            progress(Double(totalBytesSent)/Double(totalBytesExpectedToSend))
        }
        
        let task = ossClient.multipartUpload(put)
        task.continue({ task in
            if (task.error as? NSError)?.code == OSSClientErrorCODE.codeSignFailed.rawValue {
                refreshOSSToken()
            }
            completion(task.error)
            return nil
        })
        
        if waitFinished {
            task.waitUntilFinished()
        }
    }
    
    static func downloadFile(name: String,
                             progress: @escaping (Double) -> Void,
                             completion: @escaping (Error?, Data?) -> Void) {
        let get = OSSGetObjectRequest()
        get.bucketName = bucket
        get.objectKey = name
        get.downloadProgress = { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
            progress(Double(totalBytesWritten)/Double(totalBytesExpectedToWrite))
        }
        
        let task = ossClient.getObject(get)
        task.continue({ task in
            completion(task.error, (task.result as? OSSGetObjectResult)?.downloadedData)
            return nil
        })
    }
}
