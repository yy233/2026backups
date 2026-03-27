//
//  RichText.swift
//  VChat
//
//  Created by Sr on 2020/10/25.
//  Copyright © 2020 Sr. All rights reserved.
//

import Foundation
@_implementationOnly import XML

protocol RichTextModifier {
    func displayName(for user: RichText.User) -> String
}

struct RichTextBlockModifier: RichTextModifier {
    func displayName(for user: RichText.User) -> String {
        self.displayNameModifier(user)
    }
    private let displayNameModifier: (RichText.User) -> String
    init(displayNameModifier: @escaping (RichText.User) -> String) {
        self.displayNameModifier = displayNameModifier
    }
}

struct RichText {
    
    enum XMLError: Swift.Error, LocalizedError {
        case emptyXMLDocument
        var errorDescription: String? {
            switch self {
            case .emptyXMLDocument:
                return "Empty rich text document."
            }
        }
    }
    
    struct User {
        var id: String
        var name: String
    }
    
    struct Style {
        enum LinkAttributeType {
            case link
            case attachment
        }
        var attributes: [NSAttributedString.Key: Any] = [:]
        var linkAttributes: [NSAttributedString.Key: Any]? = nil
        var linkAttributeType: LinkAttributeType = .link
        var strongAttributes: [NSAttributedString.Key: Any]? = nil
        var userAttributes: [NSAttributedString.Key: Any]? = nil
        var boldAttributes: [NSAttributedString.Key: Any]? = nil
    }
    
    private enum Tags: String {
        case user
        case link = "a"
        case linebreak = "br"
        case strong = "strong"
        case bold = "b"
    }
    
    private let xmlDocument: XML.Document
    
    private static func attributedString(for node: XML.Node, style: Style, modifier: RichTextModifier?) -> NSAttributedString {
        let string = NSMutableAttributedString()
        for node in node.children {
            if let element = node as? XML.Element {
                let sanitizedText = element.text.removingBidirectionalControlCharacters()
                switch element.name {
                case Tags.user.rawValue:
                    if let id = element["id"], sanitizedText.count > 0, let modifier = modifier {
                        let user = User(id: id, name: sanitizedText)
                        let displayName = modifier.displayName(for: user)
                        string.append(NSAttributedString(string: displayName, attributes: style.userAttributes ?? style.attributes))
                    } else {
                        string.append(NSAttributedString(string: sanitizedText, attributes: style.userAttributes ?? style.attributes))
                    }
                case Tags.link.rawValue:
                    var substring: NSMutableAttributedString
                    if element.children.count > 0 {
                        substring = attributedString(for: node, style: style, modifier: modifier).mutableCopy() as! NSMutableAttributedString
                    } else {
                        substring = NSMutableAttributedString(string: sanitizedText, attributes: style.attributes)
                    }
                    substring.addAttributes(style.linkAttributes ?? style.attributes, range: NSRange(location: 0, length: substring.length))
                    if let href = element["href"], let url = URL(string: href) {
                        switch style.linkAttributeType {
                        case .link:
                            substring.addAttributes([.link: url], range: NSRange(location: 0, length: substring.length))
                        case .attachment:
                            substring.addAttributes([.attachment: url], range: NSRange(location: 0, length: substring.length))
                        }
                    }
                    string.append(substring)
                case Tags.strong.rawValue:
                    string.append(NSAttributedString(string: sanitizedText, attributes: style.strongAttributes ?? style.attributes))
                case Tags.linebreak.rawValue:
                    string.append(NSAttributedString(string: "\n", attributes: style.attributes))
                case Tags.bold.rawValue:
                    string.append(NSAttributedString(string: sanitizedText, attributes: style.boldAttributes ?? style.attributes))
                default:
                    string.append(NSAttributedString(string: sanitizedText, attributes: style.attributes))
                }
            } else {
                let sanitizedText = node.content?.trimmingCharacters(in: .whitespacesAndNewlines).removingBidirectionalControlCharacters()
                if let text = sanitizedText, text.count > 0 {
                    string.append(NSAttributedString(string: text, attributes: style.attributes))
                }
            }
        }
        return string
    }
    
    func attributedString(style: Style, modifier: RichTextModifier?) -> NSAttributedString {
        if let rootElement = xmlDocument.root {
            return RichText.attributedString(for: rootElement, style: style, modifier: modifier)
        } else {
            return NSAttributedString(string: content, attributes: style.attributes)
        }
    }
    
    private let content: String
    
    let isEmpty: Bool
    
    init(content: String) throws {
        self.content = content
        self.isEmpty = content.isEmpty
        if let document = try XML.Document(string: content) {
            xmlDocument = document
        } else {
            throw XMLError.emptyXMLDocument
        }
    }
}

extension RichText: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let content = try container.decode(String.self)
        try self.init(content: content)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(content)
    }
}

extension RichText: Hashable {
    static func == (lhs: RichText, rhs: RichText) -> Bool {
        return lhs.content == rhs.content
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(content)
    }
}
