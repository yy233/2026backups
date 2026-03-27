//
//  ZhiBoAllMianListAndCanCreatNewZhiBoViewController_Sw.swift
//  Socialize
//
//  Created by 余莹 on 2023/6/28.
//

import UIKit
import ImSDK_Plus
import TUIVoiceRoom
import Toast_Swift
import SnapKit


@objc
public class ZhiBoAllMianListAndCanCreatNewZhiBoViewController_Sw: ZhiBoAllMianListAndCanCreatNewZhiBoViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    public override func creatVoiceRoomUseSwiftVc(withInfo vChuanZhiModel: VoiceRoomChuanZhiModel) {
    
    
        print("creatVoiceRoomUseSwiftVc ---- 创建voice 时 更换成swift版本的 做跳转")
        VoiceRoomBase.shareVoice().creatVoiceRoom(withRootVc: self, withVoiceXiangGuanInfo: vChuanZhiModel) {[weak self] (succes: Bool, vc :UIViewController) in
             
            if(succes){
                print( "creatVoiceRoomUseSwiftVc  创建去语音房间成功")
                vc.navigationItem.titleView = nil;
                DispatchQueue.main.async {
                    self?.pushVc(vc)
                }

            }else{
                print( "creatVoiceRoomUseSwiftVc  创建去语音房间失败")
            }
        }
        
//    withVcBlock:^(BOOL succes, UIViewController * _Nonnull vc) {
//       if(succes){
//           DLog(@" -------creatVoiceRoomUseSwiftVcWithInfo ---------进语音房间  succ ");
//
//           [weakSelf pushVc:vc];
//
//       }else{
//           DLog(@"进语音房间失败");
//       }
    }
}


//MARK:    -------  创建协议
extension ZhiBoAllMianListAndCanCreatNewZhiBoViewController_Sw:TRTCVoiceRoomEnteryControlDelegate{
    public func voiceRoomCreateRoom(roomId: String, success: @escaping () -> Void, failed: @escaping (Int32, String) -> Void) {
        print("---MianList 界面- voiceRoomCreateRoom  创建----- roomId\(roomId)")
        //        success()
    }
    //销毁
    public func voiceRoomDestroyRoom(roomId: String, success: @escaping () -> Void, failed: @escaping (Int32, String) -> Void) {
        print("---MianList 界面- voiceRoomDestroyRoom  销毁----- roomId\(roomId)")

    }
     
    
}
