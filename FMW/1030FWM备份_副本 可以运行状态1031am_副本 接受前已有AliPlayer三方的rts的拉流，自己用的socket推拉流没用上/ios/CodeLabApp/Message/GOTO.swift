//
//  GOTO.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/9.
//

import Foundation
import BasicUIKit

enum GotoSource: CaseIterable {
    case external
    case api
    case push
    case web
    case trustedWeb
    case message
    case systemMessage
    
    static let trustedSources = Set<GotoSource>([.api, .push])
}

@MainActor
protocol GotoHandler {
    associatedtype Parameters: Codable
    var host: String { get }
    var allowedSources: Set<GotoSource> { get }
    func handleGoto(url: URL, parameters: Parameters)
}

extension GotoHandler {
    var allowedSources: Set<GotoSource> { GotoSource.trustedSources }
}

@MainActor
struct AnyGotoHandler {
    let host: String
    let allowedSources: Set<GotoSource>
    private let _handler: (URL, GotoSource) -> Void
    
    init<Handler: GotoHandler>(_ handler: Handler) {
        host = handler.host
        allowedSources = handler.allowedSources
        _handler = { url, source in
            if let components = URLComponents(string: url.absoluteString) {
                let queryItems = components.queryItems ?? []
                var dict: [String: String] = [:]
                for item in queryItems where item.value != nil {
                    dict[item.name] = item.value!
                }
                do {
                    let data = try JSONEncoder().encode(dict)
                    let parameters = try JSONDecoder().decode(Handler.Parameters.self, from: data)
                    handler.handleGoto(url: url, parameters: parameters)
                } catch {
                    print("""
                    === Goto Hanlder ==
                    URL: \(url)
                    Source: \(source)
                    Error: \(error)
                    ===================
                    """)
                }
            }
        }
    }
    
    func handleGoto(url: URL, source: GotoSource) {
        _handler(url, source)
    }
}

import UIKit

@MainActor
class URLRouter {
    static let scheme = "fmw"
    
    private static let handlers: [String: AnyGotoHandler] = { () -> [String: AnyGotoHandler] in
        let gotoHandlers: [any GotoHandler] = [
            AppStoreGotoHandler(),
            FeedDetailGotoHandler(),
            ProfileGotoHandler(),
            FeedRecommendGotoHandler(),
            NFTMallGotoHandler(),
            FeedChildCommunityGotoHandler()
        ]
        return gotoHandlers.reduce(into: [String: AnyGotoHandler](), { handlers, value in
            handlers[value.host.lowercased()] = AnyGotoHandler(value)
        })
    }()
    
    @discardableResult
    static func handleGoto(url: URL, source: GotoSource) -> Bool {
        guard let host = url.host else {
            return false
        }
        
        if url.scheme?.lowercased() == "https" || url.scheme?.lowercased() == "http" {
            if host.lowercased() == "apps.apple.com" && UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                return true
            } else {
                UIManager.shared.showSafariViewController(url: url)
                return true
            }
        }
        
        guard (url.scheme?.lowercased() == scheme || url.scheme?.lowercased() == Bundle.main.bundleIdentifier) else {
            return false
        }
        
        if let handler = handlers[host.lowercased()], handler.allowedSources.contains(source) {
            handler.handleGoto(url: url, source: source)
            return true
        } else {
            return false
        }
    }
}


// MARK: - Goto handlers

struct AppStoreGotoHandler: GotoHandler {
    let host: String = "itunes.apple.com"
    let allowedSources = Set<GotoSource>(GotoSource.allCases)
    struct Parameters: Codable {}
    func handleGoto(url: URL, parameters: Parameters) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

struct DescriptiveError: Hashable, LocalizedError {
    let errorDescription: String?
    init(_ info: String) {
        self.errorDescription = info
    }
}

struct DescriptiveAlertError: LocalizedError, CustomStringConvertible {
    var errorDescription: String? { description }
    
    let description: String
    let title: String?
    
    init(title: String?, description: String) {
        self.title = title
        self.description = description
    }
    
    init(_ info: String) {
        self.description = info
        self.title = nil
    }
}

extension GotoHandler {
    
    func asURL(parameter: Parameters) throws -> URL {
        var components: URLComponents = .init()
        components.scheme = URLRouter.scheme
        components.host = host
        
        let data = try JSONEncoder().encode(parameter)
        guard let dict = try JSONSerialization.jsonObject(with: data) as? [String: String] else {
            throw DescriptiveError("参数数据结构不合法")
        }
        
        var queryItems: [URLQueryItem] = []
        for (k, v) in dict {
            queryItems.append(.init(name: k, value: v))
        }
        components.queryItems = queryItems
        
        return try components.asURL()
    }
}

struct FeedDetailGotoHandler: GotoHandler {
    let host: String = "feed"
    
    struct Parameters: Codable {
        var id: String
    }
    
    func handleGoto(url: URL, parameters: Parameters) {
        UIManager.push(to: CommunityFeedDetailViewController().then {
            let feed = FeedItem()
            feed.id = parameters.id
            $0.feedItem = feed
        })
    }
}

struct ProfileGotoHandler: GotoHandler {
    let host: String = "user"
    
    struct Parameters: Codable {
        var id: String
    }
    
    func handleGoto(url: URL, parameters: Parameters) {
        UIManager.push(to: UserViewController().then { $0.userID = parameters.id })
    }
}

struct FeedRecommendGotoHandler: GotoHandler {
    let host: String = "feedRecommend"
    
    struct Parameters: Codable {}
    
    func handleGoto(url: URL, parameters: Parameters) {
        NotificationCenter.default.post(name: .notificationPointsDidTapFeedRecommend, object: nil)
        UIManager.popToRoot(animated: true)
    }
}

struct FeedChildCommunityGotoHandler: GotoHandler {
    let host: String = "community"
    
    struct Parameters: Codable {
        var id: String
    }
    
    func handleGoto(url: URL, parameters: Parameters) {
        UIManager.push(to: FeedChildCommunityDetailViewController().then {
            var communityItem = CommunityItem()
            communityItem.id = parameters.id
            $0.communityItem = communityItem
        })
    }
}

struct NFTMallGotoHandler: GotoHandler {
    let host: String = "mall"
    
    struct Parameters: Codable {}
    
    func handleGoto(url: URL, parameters: Parameters) {
        UIManager.push(to: NFTMallViewController())
    }
}
