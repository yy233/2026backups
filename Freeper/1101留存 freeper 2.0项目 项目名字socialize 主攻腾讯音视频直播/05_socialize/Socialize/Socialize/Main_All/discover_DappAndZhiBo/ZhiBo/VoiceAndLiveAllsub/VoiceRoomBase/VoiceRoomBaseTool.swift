//
//  VoiceRoomBaseTool.swift
//  Socialize
//
//  Created by 余莹 on 2023/5/27.
//

import UIKit
import ImSDK_Plus
import TUIVoiceRoom
import Toast_Swift


@objc public class VoiceRoomBaseTool: NSObject, TRTCVoiceRoomEnteryControlDelegate {
    
    public func voiceRoomCreateRoom(roomId: String, success: @escaping () -> Void, failed: @escaping (Int32, String) -> Void) {
        print("-VoiceRoomBaseTool--- voiceRoomCreateRoom  ----- \(roomId)")
    }
    
    public func voiceRoomDestroyRoom(roomId: String, success: @escaping () -> Void, failed: @escaping (Int32, String) -> Void) {
        print("-VoiceRoomBaseTool--- voiceRoomDestroyRoom  ----- \(roomId)")
    }
    
    
    @objc   let dependencyContainer = TRTCVoiceRoomEnteryControl.init(sdkAppId: Int32(SDKAppID), userId: ShareUserInfo.share().userInfo.imId)
 
    
    
    @objc  public func makeVoiceVcActionWithRootVc(rootVc :UIViewController ,
                                                   roomInfo: VoiceRoomInfo,
                                                   isAnchorBool:Bool) -> UIViewController {
    
 
        
        
        dependencyContainer.delegate  = rootVc as? any TRTCVoiceRoomEnteryControlDelegate; //不能oc swift可以
        
//        self.dependencyContainer.delegate  = self;//会nil
        
        print("---- makeVoiceVcActionWithGetRoomVc  ----- \(String(describing: roomInfo))")
        print("---- makeVoiceVcActionWithGetRoomVc nnnnnnnnnnnn  ----- \( roomInfo.roomName) \(roomInfo.roomID)")
        print("---- makeVoiceVcActionWithGetRoomVc nnnnnnnnnnnn  ----- \( roomInfo.ownerId) \(roomInfo.ownerName)")
        Thread.sleep(forTimeInterval: 0.2)//短暂延时 防止delegate没付成功nil了
        print("---- makeVoiceVcActionWithGetRoomVc  dependencyContainer delegate ----- \(String(describing: self.dependencyContainer.delegate))")
        if(isAnchorBool){
            //主播
            let vc = self.dependencyContainer.makeVoiceRoomViewController(roomInfo: roomInfo,
                                                                          role: .anchor,
                                                                          toneQuality: .defaultQuality)
        
            return vc
            
        }else{
            //观众
            let vc = self.dependencyContainer.makeVoiceRoomViewController(roomInfo: roomInfo,
                                                                          role: .audience,
                                                                          toneQuality: .defaultQuality)
            
            return vc
        }
        
    }
    
}


//extension zh
