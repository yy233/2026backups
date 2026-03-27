//
//  VoiceB_ViewController.swift
//  ystx
//
//  Created by 余莹 on 2023/5/27.
//

import UIKit
import ImSDK_Plus
import TUIVoiceRoom
import Toast_Swift


class VoiceB_ViewController: UIViewController, TRTCVoiceRoomEnteryControlDelegate {
    func voiceRoomCreateRoom(roomId: String, success: @escaping () -> Void, failed: @escaping (Int32, String) -> Void) {
        print(" ---- voiceRoomCreateRoom 1111");
    }
    
    func voiceRoomDestroyRoom(roomId: String, success: @escaping () -> Void, failed: @escaping (Int32, String) -> Void) {
        print(" ---- voiceRoomDestroyRoom   222 ");
    }
    
    let dependencyContainer = TRTCVoiceRoomEnteryControl.init(sdkAppId: Int32(SDKAppID), userId: ShareUserInfo.share().userInfo.imId)
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .brown
        let rightBarBBtn = UIButton(type: .custom)
        rightBarBBtn.setTitle("登录", for: .normal)
        rightBarBBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        rightBarBBtn.sizeToFit()
        let rightItem = UIBarButtonItem(customView: rightBarBBtn)
        rightItem.tintColor = .red
        
        
        
        let createBarBBtn = UIButton(type: .custom)
        createBarBBtn.setTitle("创建", for: .normal)
        //        createBarBBtn.addTarget(self, action: #selector(CreateAction), for: .touchUpInside)
//        createBarBBtn.addTarget(self, action: #selector(CreateActionBBB), for: .touchUpInside)
        createBarBBtn.addTarget(self, action: #selector(CreateActionCCC), for: .touchUpInside)
        
        createBarBBtn.sizeToFit()
        let rightItemCC = UIBarButtonItem(customView: createBarBBtn)
        rightItemCC.tintColor = .red
        
        
        let  nicBBtn = UIButton(type: .custom)
        nicBBtn.setTitle("昵称", for: .normal)
        nicBBtn.addTarget(self, action: #selector(nickAction), for: .touchUpInside)
        nicBBtn.sizeToFit()
        let rightItemN = UIBarButtonItem(customView: nicBBtn)
        rightItemN.tintColor = .red
        
        
        
        navigationItem.rightBarButtonItems = [rightItem,rightItemCC,rightItemN];
        
        
    }
    @objc  func nickAction()  {
        TRTCVoiceRoom.shared().setSelfProfile(userName: "dev003Nik", avatarURL: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2F4d2a8885-131d-4530-835a-0ee12ae4201b%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1687765377&t=ee61d1320c1668366c988c53715b0c3e") { ( code, message )  in
            if(code == 0){
                print(" ---- 昵称 头像 OK ");
            }else{
                print(" ---- errrrrrr ");
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        UIWindow *window = [[UIApplication sharedApplication]windows].lastObject;
        //        window.backgroundColor = [UIColor blueColor];
        //        window.hidden = NO;
        //        window.rootViewController = navvv;
        //        [ window makeKeyAndVisible];
        
      
        
        
    }
    
    @objc func loginAction(){
        /**
         
         NSString *userID = ([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"");
         NSString *sig = ([ShareUserInfo share].userInfo.imSignature.length > 0 ? [ShareUserInfo share].userInfo.imSignature : @"")//IM_sig;
         
         
         
         [[TRTCVoiceRoom sharedInstance] login:SDKAppID userId:userID userSig:sig callback:^(int code, NSString * _Nonnull message) {
         if (code == 0) {
         NSLog(@"初始化成功 ____________________________ %@",message);
         }else{
         NSLog(@"初始化 err ____________________________ %d %@" ,code,message);
         }
         }];
         
         */
//        TRTCVoiceRoom().getRoomInfoList(roomIdList: [NSNumber])
        //([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"")
        TRTCVoiceRoom.shared().login(sdkAppID: SDKAppID, userId: ShareUserInfo.share().userInfo.imId , userSig: ShareUserInfo.share().userInfo.imSignature) { (code, message) in
            if code == 0 {
                //登录成功
                print(" ---- 0 登录成功 %@",message);
                self.view.backgroundColor = .orange;
            }else{
                print(" ---- errrrrrr \(message)");
            }
        }
    }
    
    
    
    
    
    
    @objc func CreateActionCCC() {//0630创建接口 -- 获取接口 -- makeVc --设置麦序接口
        
        TRTCVoiceRoom.shared().createRoom(roomID: Int32(getRoomId()), roomParam: creatRoomInfoPam()) { [self] (code, message) in
            if code == 0 {
                // 成功
                
//                CreateAction()
             
                V2TIMManager.sharedInstance().getGroupsInfo([String(getRoomId())]) { [weak self] groupInfos in
                    guard let `self` = self else { return }
                    guard let groupInfo = groupInfos?.first else { return }
                    if groupInfo.resultCode == 0 {
                        //当前房间正常到达
                        print("直播  roomId === \(getRoomId())");
                        print("将进入直播  groupInfos === \(String(describing: groupInfos))");
//                        guard let introduction = groupInfo.info.introduction else { return }
//                        let voiceRoomInfo = VoiceRoomInfo.init(roomID: Int(roomId) ?? 0, ownerId: introduction, memberCount: 0)
                        
                        print("将进入直播  groupInfo first  === \(String(describing: groupInfo.info))");
                        
                        print("将进入直播  groupInfo first introduction === \(String(describing: groupInfo.info.introduction))");
                        print("将进入直播  groupInfo first name === \(String(describing: groupInfo.info.groupName))");
                        print("将进入直播  groupInfo first memberCount === \(String(describing: groupInfo.info.memberCount))");
//                        let vc = self.dependencyContainer.makeVoiceRoomViewController(roomInfo: creatRoomInfoData(), role: .audience, toneQuality: .music)
                        
                        let ccccrinfo = creatRoomInfoData()
                      
                        ccccrinfo.ownerName = "ccc房主名字"
                        ccccrinfo.roomName = "ccc房Nma"
                        
                        ccccrinfo.memberCount = Int(groupInfo.info.memberCount);
                        
                        let vc = self.dependencyContainer.makeVoiceRoomViewController(roomInfo: ccccrinfo, role: .anchor, toneQuality: .defaultQuality)

//                        print("进入直播  introduction === \(introduction)");
//                        print("进入直播  voiceRoomInfo === \(voiceRoomInfo)");
                        
                        
                        self.navigationController?.pushViewController(vc, animated: false)
                        
                        
                        TRTCVoiceRoom.shared().enterSeat(seatIndex: 0) {  (code, message) in
                            if code == 0 {
                                print(" ---- 创建者 设置麦序0 ok enterSeat");
                            }else{
                                print(" ---- 创建者 设置麦序0 失败 errrrrrr enterSeat");
                            }
                        }
                        
                    } else {
                        print(" ---- 创建者 设置麦序0 errrrrrr 不存在");
                        //当前房间不存在
//                        DispatchQueue.main.async {
//                            let alertVC = UIAlertController.init(title: .promptText, message: .roomdoesnotexistText, preferredStyle: .alert)
//                            let alertAction = UIAlertAction.init(title: .okText, style: .default, handler: nil)
//                            alertVC.addAction(alertAction)
//                            self.present(alertVC, animated: true, completion: nil)
//                        }
                    }
                } fail: { code, message in
                    debugPrint("code = \(code), message = \(message ?? "")")
                }
            } else{
                print(" ---- errrrrrr ");
            }
        }
        
        
    }
    
    
    @objc func CreateActionBBB() {
        
        TRTCVoiceRoom.shared().createRoom(roomID: Int32(getRoomId()), roomParam: creatRoomInfoPam()) { [self](code, message) in
            if code == 0 {
                // 成功
                print(" ---- 0  createRoom成功 %@",message);
                self.view.backgroundColor = .green;
                
                // 1.听众调用加入房间
                TRTCVoiceRoom.shared().enterRoom(roomID:getRoomId()) { (code, message) in
                    // 进入房间结果回调
                    print(" ---- errrrrrrent \(message)");
                    if code == 0 {
                        // 进房成功
                        print(" ---- 0  进房成功 %@",message);
                        let seatIndex = 0; //麦位的index
                        TRTCVoiceRoom.shared().enterSeat(seatIndex: seatIndex) { (code, message) in
                            
                            print(" ---- errrrrrrseat \(message)");
                            if code == 0 {
                                // 上麦成功
                                print(" ---- 0  上麦成功 %@",message);
                            }else{
                                print(" ---- errrrrrrseat \(message)");
                            }
                        }
                        
                    }else{
                        print(" ---- errrrrrrent \(message)");
                    }
                }
                
            }else{
                print(" ---- errrrrrr ");
            }
            
            
        }}
    
    @objc func CreateAction() {
        print(" ---- CreateAction---- ");
        
        print(" ---- CreateAction- room \n \(creatRoomInfoData().roomID)  \(creatRoomInfoData().roomName) \n  roomUser --- \(creatRoomInfoData().ownerId)  \(creatRoomInfoData().ownerName)");
        
        dependencyContainer.delegate = self
        
        print("\(dependencyContainer.getVoiceRoom())  --------- getVoiceRoom ")
        
        print(" ---- CreateAction---- get info \(dependencyContainer.getVoiceRoom())");
        //dependencyContainer.makeVoiceRoomViewModel(roomInfo: VoiceRoomInfo.init(roomID: 111, ownerId: ([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @""), memberCount: 7), roomType: VoiceRoomViewType.anchor)
        //        dependencyContainer.makeCreateVoiceRoomViewModel()
        //        TRTCVoiceRoomViewController.init(viewModelFactory: TRTCVoiceRoomViewModelFactory, roomInfo: creatRoomInfoData(), role: VoiceRoomViewType.anchor, toneQuality: VoiceRoomToneQuality.defaultQuality);
        
        
        
        //        TRTCVoiceRoomViewController.viewModelFactory
        //        let  voiceRoomModelttt: TRTCCreateVoiceRoomViewModel?
        //        voiceRoomModelttt?.voiceRoom.setSelfProfile(userName: "民资aaa", avatarURL: creatRoomInfoData().coverUrl, callback: ActionCallback)
        //        let rootView = TRTCCreateVoiceRoomRootView.init(viewModel: voiceRoomModelttt)
        
        //        let Vm = TRTCCreateVoiceRoomViewModel.init();
        //
        //        Vm.voiceRoom.createRoom(roomID:  , roomParam:  , callback: ActionCallback)
        
        
        
        let viewController = dependencyContainer.makeCreateVoiceRoomViewController()
        if viewController is TRTCCreateVoiceRoomViewController {
            print("\(viewController)  --------- 判断中 ")
            
            let vc = viewController as! TRTCCreateVoiceRoomViewController
            print("\(vc)  --------- TRTCCreateVoiceRoomViewController类型 ")
            vc.screenShot = view.snapshotView(afterScreenUpdates: false)
            
            //            vc.dependencyContainer.makeVoiceRoomViewModel(roomInfo: creatRoomInfoData(), roomType: VoiceRoomViewType.anchor);
        }
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    
    //
    //    @objc func initViewModelFactory()->TRTCVoiceRoomViewModelFactory{
    //     }
    
    @objc func creatRoomInfoPam()->VoiceRoomParam{
        
        //        VoiceRoomParam *roomParam = [[VoiceRoomParam alloc] init];
        //        roomParam.roomName = @"房间名称AAAAAA";
        //        // 听众上麦是否需要房主同意
        //        roomParam.needRequest = NO;
        //    //    roomParam.coverUrl = @"房间封面图的 URL 地址";
        //        roomParam.coverUrl = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fblog%2F202111%2F05%2F20211105154541_23fe2.thumb.1000_0.jpg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1685018029&t=ac00a835d533de90cf8f8c0514f3ac2a";
        //        // 房间座位数，这里一共7个座位，房主占了一个后听众剩下6个座位
        //        roomParam.seatCount = 7;
        //
        //
        //        // 初始化麦位信息
        //        NSMutableArray *seatInfoArray = [[NSMutableArray alloc]init];
        //        for (NSInteger i = 0; i < roomParam.seatCount; i++) {
        //            VoiceRoomSeatInfo *seatInfo = [[VoiceRoomSeatInfo alloc] init];
        //            [seatInfoArray addObject:seatInfo];
        //        }
        //        roomParam.seatInfoList = seatInfoArray;
        
        
        // 初始化语聊房参数
        let roomParam = VoiceRoomParam()
        roomParam.roomName = "房间名称ppp"
        roomParam.needRequest = false // 听众上麦是否需要房主同意
        roomParam.coverUrl  = "https://bkimg.cdn.bcebos.com/pic/8d5494eef01f3a297848d3cb9725bc315c607c36?x-bce-process=image/watermark,image_d2F0ZXIvYmFpa2UyMjA=,g_7,xp_5,yp_5" //"房间封面图的 URL 地址"
        roomParam.seatCount = 7 // 房间座位数，这里一共7个座位，房主占了一个后听众剩下6个座位
        roomParam.seatInfoList = []
        
        
        // 初始化麦位信息
        for _ in 0 ..< roomParam.seatCount {
            let seatInfo = VoiceRoomSeatInfo()
            roomParam.seatInfoList.append(seatInfo)
        }
        
        return roomParam;
    }
    
    @objc func creatRoomInfoData()->VoiceRoomInfo{
        
        let roomI = getRoomId()
        //([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"")
        let  baseVoiceRoomInfo = VoiceRoomInfo.init(roomID: roomI, ownerId: ShareUserInfo.share().userInfo.imId, memberCount: 7);
        baseVoiceRoomInfo.coverUrl = "";
        baseVoiceRoomInfo.roomName = "3roomName33";
        baseVoiceRoomInfo.ownerName = "3用户民Name33";
        baseVoiceRoomInfo.coverUrl =  "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fblog%2F202111%2F05%2F20211105154541_23fe2.thumb.1000_0.jpg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1685018029&t=ac00a835d533de90cf8f8c0514f3ac2a";
        baseVoiceRoomInfo.needRequest = true;//上麦相关
        return baseVoiceRoomInfo
    }
    
    func getRoomId() -> Int {
        //        let userId = userID ?? dependencyContainer.userId
        let userId = ShareUserInfo.share().userInfo.imId
        let result = "\(userId)_voice_room".hash & 0x7FFFFFFF
        TRTCLog.out("hashValue:room id:\(result), userId: \(userId)")
        return result
    }
}





