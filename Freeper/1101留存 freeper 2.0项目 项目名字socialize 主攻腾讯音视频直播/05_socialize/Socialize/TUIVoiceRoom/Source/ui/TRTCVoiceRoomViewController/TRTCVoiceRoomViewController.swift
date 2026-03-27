//
//  TRTCVoiceRoomViewController.swift
//  TRTCVoiceRoomDemo
//
//  Created by abyyxwang on 2020/6/8.
//  Copyright © 2020 tencent. All rights reserved.
//
import UIKit
import TUICore

protocol TRTCVoiceRoomViewModelFactory {
   func makeVoiceRoomViewModel(roomInfo: VoiceRoomInfo, roomType: VoiceRoomViewType) -> TRTCVoiceRoomViewModel
}

public class TRTCVoiceRoomViewController: UIViewController {
    // MARK: - properties:
    
    let viewModelFactory: TRTCVoiceRoomViewModelFactory
    let roomInfo: VoiceRoomInfo
    let role: VoiceRoomViewType
    var viewModel: TRTCVoiceRoomViewModel?
    let toneQuality: VoiceRoomToneQuality
    // MARK: - Methods:
    init(viewModelFactory: TRTCVoiceRoomViewModelFactory, roomInfo: VoiceRoomInfo, role: VoiceRoomViewType, toneQuality: VoiceRoomToneQuality = .music) {
        self.viewModelFactory = viewModelFactory
        self.roomInfo = roomInfo
        self.role = role
        self.toneQuality = toneQuality
        print(" -----TRTCVoiceRoomViewController----  roomInfo.activityIdStr  ---------=  \( roomInfo.activityIdStr)")
        print(" -----TRTCVoiceRoomViewController----  roomInfo.rec password  ---------=  \( roomInfo.rec_passWordStr)")
        print(" -----TRTCVoiceRoomViewController----  roomInfo. other dic  ---------=  \( roomInfo.otherDic)")
        print(" ---------  roomInfo. roomID  ---------  \(roomInfo.roomID)")
        print(" ---------  roomInfo. roomN ---------  \(roomInfo.roomName)")
        print(" ---------  roomInfo. ownerId   =\(roomInfo.ownerId) --------roomInfo. ownern =\(roomInfo.ownerName) ")

        
       
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        //添加红包通知相关self.addNoticeOfRedEnv() 换
        
        
        title = "\(roomInfo.roomName)\(roomInfo.roomID)"
        
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "navigationbar_back", in: voiceRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        backBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        backBtn.sizeToFit()
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        guard let model = viewModel else { return }
        
        print("viewDidLoad  viewModel === \(String(describing: viewModel)) ")
        if model.roomType == .audience {
            model.enterRoom()
        } else {
            model.createRoom(toneQuality: toneQuality.rawValue)
        }
#if RTCube_APPSTORE
        let selector = NSSelectorFromString("showAlertUserLiveTips")
        if responds(to: selector) {
            perform(selector)
        }
#endif
        TUILogin.add(self)
        
        
        print(" ---- viewDidLoad ")
        if(roomInfo.activityIdStr == "" || roomInfo.activityIdStr.isEmpty ){
            print(" -----TRTCVoiceRoomViewController----  roomInfo.activityIdStr 缺数据")

        }else{
            if( viewModel!.isOwner == true) {//是创建者
                print(" ---- isOwner 是创建者")
       
                //当前状态更改方法 是在主线程里走通知
                let changeQ =  DispatchQueue.main
                changeQ.async {
                    ChangeVoiceInfoWithNoticeNetWorkTool.changeVoiceInfo(withActivityIdStr: self.roomInfo.activityIdStr, withNowState: Active_State_KaiQi) { (isSuccess:Bool, dataDic:[AnyHashable : Any]) in
                        
                        if(isSuccess){
                            print(" --------- changeVoiceInfo 开启状态已修改  --------activityIdStr-  \(self.roomInfo.activityIdStr)")
                            
                        }else{
                            print(" --------- changeVoiceInfo 开启状态 修改失败  --------activityIdStr-  \(self.roomInfo.activityIdStr)")
                        }
                    }
                }
            }else{
                print(" --------- changeVoiceInfo 观众 不做状态修改 --------activityIdStr-  \(roomInfo.activityIdStr)")

            }
 
            
        }
        
        self.popGestureChange(vc: self, enbale:false);//不允许侧滑空0904ok
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setNeedsStatusBarAppearanceUpdate()//状态栏更新
       
        UIApplication.shared.isIdleTimerDisabled = true  //禁止自动休眠
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent;
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false) //0902
        viewModel?.refreshView()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false //限制滑动退出pop
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        self.popGestureChange(vc: self, enbale:false);//不允许侧滑空0904ok
        
    }
    /***
     -(void)popGestureChange:(UIViewController *)vc enable:(BOOL)enable{

         if ([vc.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {

             //遍历所有的手势

             for (UIGestureRecognizer *popGesture in vc.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {

                 popGesture.enabled = enable;

             }

         }

     }
     */
    
    public func popGestureChange(vc:UIViewController,enbale:Bool){
        
        let selector = NSSelectorFromString("interactivePopGestureRecognizer");
        
        vc.navigationController?.interactivePopGestureRecognizer?.view?.gestureRecognizers?.forEach({ gesture  in
            gesture.isEnabled = enbale;
        });
        print("popGestureChange 语音 侧滑 限制 有效\(vc) \(enbale)")
        
    }
    
    public override func willMove(toParent parent: UIViewController?) {
        
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false  //可以自动休眠 
        
        //侧滑返回 做个禁止   self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true  //0902限制滑动退出pop 本页无效 wynavc
        
        viewModel!.viewResponder?.disApperOfRoomMainViewDeal()//新加的方法
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
      
    }
 
    
    public override func loadView() {
        // Reload view in this function
        print("直播界面 loadView -----roomInfo sub  activityIdStr \(roomInfo.activityIdStr) rec_passWordStr \(roomInfo.rec_passWordStr) otherDic \(roomInfo.otherDic)")
        let viewModel = viewModelFactory.makeVoiceRoomViewModel(roomInfo: roomInfo, roomType: role)
        let rootView = TRTCVoiceRoomRootView.init(viewModel: viewModel)
        rootView.rootViewController = self
        rootView.save_thisActivity_Id = roomInfo.activityIdStr as NSString //自定的传入数据给到view
        if !roomInfo.rec_passWordStr.isEmpty {
            rootView.save_thisActivity_Res_PasswordStr = roomInfo.rec_passWordStr as NSString
        }else{
            rootView.save_thisActivity_Res_PasswordStr = ""
        }
        if !roomInfo.otherDic.isEmpty {
            rootView.save_thisActivity_otherDic = roomInfo.otherDic as NSDictionary
        }else{
            rootView.save_thisActivity_otherDic = [:]
        }
       
        rootView.viewModel.roomInfo.roomID = roomInfo.roomID;
        rootView.viewModel.roomInfo.roomName = roomInfo.roomName;
        rootView.viewModel.roomInfo.ownerId = roomInfo.ownerId;
        rootView.viewModel.roomInfo.ownerName = roomInfo.ownerName;
        rootView.viewModel.roomInfo.ownHeaderImgStr = roomInfo.ownHeaderImgStr;
        rootView.viewModel.roomInfo.activityIdStr = roomInfo.activityIdStr;
        rootView.viewModel.roomInfo.rec_passWordStr = roomInfo.rec_passWordStr;
        rootView.viewModel.roomInfo.otherDic = roomInfo.otherDic;
        
        viewModel.viewResponder = rootView
        self.viewModel = viewModel
       
        
        self.viewModel?.roomInfo.roomID = roomInfo.roomID;
        self.viewModel?.roomInfo.roomName = roomInfo.roomName;
        self.viewModel?.roomInfo.ownerId = roomInfo.ownerId;
        self.viewModel?.roomInfo.ownerName = roomInfo.ownerName;
        self.viewModel?.roomInfo.ownHeaderImgStr = roomInfo.ownHeaderImgStr;
        self.viewModel?.roomInfo.activityIdStr = roomInfo.activityIdStr;
        self.viewModel?.roomInfo.rec_passWordStr = roomInfo.rec_passWordStr;
        self.viewModel?.roomInfo.otherDic = roomInfo.otherDic;
        view = rootView
    }
    
    deinit {
        TUILogin.remove(self)
        TRTCLog.out("deinit \(type(of: self))")
        NotificationCenter.default.removeObserver(self)

    }
    
    @objc func cancel() {
        if viewModel?.roomType == VoiceRoomViewType.anchor {
            presentAlert(title: .exitText, message: .sureToExitText) { [weak self] in
                guard let `self` = self else { return }
                self.viewModel?.exitRoom() // The anchor terminates the room
               
            }
        } else {
            self.viewModel?.exitRoom()
            
        }
    }
}

extension TRTCVoiceRoomViewController: TUILoginListener {
    public func onConnecting() {
        
    }
    
    public func onConnectSuccess() {
        
    }
    
    public func onConnectFailed(_ code: Int32, err: String!) {
        
    }
    
    public func onKickedOffline() {
        viewModel?.exitRoom()
        print("被踢离线");
        

    }
    
    public func onUserSigExpired() {
        
    }
}

extension TRTCVoiceRoomViewController {
    func presentAlert(title: String, message: String, sureAction:@escaping () -> Void) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertOKAction = UIAlertAction.init(title: .confirmText, style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
            sureAction()
        }
        let alertCancelAction = UIAlertAction.init(title: .cancelText, style: .cancel) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(alertCancelAction)
        alertVC.addAction(alertOKAction)
        present(alertVC, animated: true, completion: nil)
    }
}
 

/**
 换到view内做处理
 

extension TRTCVoiceRoomViewController{
    
    func addNoticeOfRedEnv() {
        
        let notice_name_GotSuccess : String = Chat_Got_RedEnv_Notice_Result as String;
        let notice_name_GotFail : String = Chat_Got_RedEnv_Notice_Result_isFail as String;
        
        NotificationCenter.default.addObserver(self, selector: #selector(red_Got_SucessAction(_:)), name:NSNotification.Name(notice_name_GotSuccess) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(red_Got_FailAction(_:)), name:NSNotification.Name(notice_name_GotFail) , object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(red_Got_FailAction(_:))), name:NSNotification.Name(notice_name_GotFail)  , object: nil)
    }
 
    
    @objc func red_Got_SucessAction(_ notification: Notification?) {
        let n_obj = notification?.object ?? "";
        if n_obj  && viewModel.thisRoomAllRedEnv_ZhuBoSendInfoList.count == 1 {
            viewModel?.thisRoomAllRedEnv_ZhuBoSendInfoList.removeAllObjects()
            self.topredview hiden
        }
        
        viewModel?.thisRoomAllRedEnv_ZhuBoSendInfoList.forEach({ redEnvdic in
        });
        
    }
    
    @objc func red_Got_FailAction(_ notification: Notification?)  {
    }
}
 */

private extension String {
    static let exitText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.exit")
    static let sureToExitText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.isvoicingandsuretoexit")
    static let confirmText = voiceRoomLocalize("Demo.TRTC.LiveRoom.confirm")
    static let cancelText = voiceRoomLocalize("Demo.TRTC.LiveRoom.cancel")
}


