//
//  textREplaykitFile.swift
//  CodeLabApp
//
//  Created by yuying on 2026/3/19.
//

import Foundation
import ReplayKit
//import LFlivekit


let groupid = "group.com.testaaa.live"
if let defs = UserDefaults(suiteName: groupid){
    defs.set("rtmp://xxxxxxxxxxxx/live/steam", forKey: "rtmp_url")
    defs.synchronize()
}



