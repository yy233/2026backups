//
//  UnityMessager.swift
//  CodeLabApp
//
//  Created by Sera on 2023/8/7.
//

import Foundation
import CodeLabUnityBridge

extension CodeLabUnityInstance {
    public static func sendMessage(_ msg: Codable) {
        let json = String(data: (try? JSONEncoder().encode(msg)).nonnull, encoding: .utf8)
        CodeLabUnityInstance.shared.sendMessage(json.nonnull)
    }
}

struct UnityHairMessage: Codable {
    var type = 1001
}

struct UnityHairMeshMessage: Codable {
    var type = 1002
}

struct UnityDressMessage: Codable {
    var type = 1003
}
