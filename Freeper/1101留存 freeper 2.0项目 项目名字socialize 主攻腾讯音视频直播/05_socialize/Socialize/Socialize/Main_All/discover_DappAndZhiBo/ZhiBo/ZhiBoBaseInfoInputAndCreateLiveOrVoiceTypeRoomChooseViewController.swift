//
//  ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController.swift
//  Socialize
//
//  Created by 余莹 on 2023/6/26.
//

import UIKit
import ImSDK_Plus
import TUIVoiceRoom
import Toast_Swift
import SnapKit

@objcMembers
public class ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController: ZhiCreateChooseVc_Base {
    

    var isLijiZhiBoCreatIng:Int = 0;//是否立即直播且正在创建
    
    @objc lazy var boolPushLastVcIsWebOrNotClearnNavVc:Bool = {
        return false; //跳转到本vc的前一页面 (webv 或者透明nav的 都要做yes)
    }()
    
    let dependencyContainer = TRTCVoiceRoomEnteryControl.init(sdkAppId: Int32(SDKAppID), userId: ShareUserInfo.share().userInfo.imId)
    
    //高度计算大概是380 nav8
    var topMainView:CreateLiveOrVoiceView = CreateLiveOrVoiceView.init(frame: CGRectMake(0, 0, ScreenWidth, 380+88))
    lazy var topView: CreateLiveOrVoiceView = {
        var view = self.topMainView
        self.topMainView.delegate = self
        return view;
    }()
    
    lazy var centerBgZheXianView: UIImageView = {
        let bg = UIImageView(frame: .zero)
        bg.image = UIImage.init(named: "voice_Zhe")
        bg.contentMode = .scaleAspectFill
        return bg
    }()
    lazy var maxBgView: UIImageView = {
        let bg = UIImageView(frame: .zero)
        //bg.image = UIImage.init(named: "img_live_create") 不给图片 防止切换时的闪烁
        bg.contentMode = .scaleAspectFill
        bg.tag = 555;//做个层级位置 在旧背景图上层放置实时view
        return bg
    }()
    
    
    var footerBtnView:CreatOfBottomBtnView? = CreatOfBottomBtnView.init(frame: CGRectZero)
    lazy var footerBtnV:CreatOfBottomBtnView = {
        var view = self.footerBtnView;
        self.footerBtnView!.footerB.setTitle(.wanchengS, for: .normal)
        self.footerBtnView!.footerB.setTitleColor(.black, for: .normal)
        self.footerBtnView!.footerB.addTarget(self, action: #selector(footerBtnAction), for: .touchUpInside)
        return view!
    }()
    
    var isPublicType:Bool = true;
    var nowWillCreateTypeIsVoice:Bool = true;
    //
    var saveFenMianImgStr:NSString = "";
    var saveTitleStr:NSString = "";
    var saveKaiBoTimeStr:NSString = "";
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:    ------- mainDidLoad
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
        self.isLijiZhiBoCreatIng = 0;

    }
//    public func setNavBlack(){
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 27/255, green: 26/255, blue: 39/255, alpha: 1) //背景色 暗色 不变它
//        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 27/255, green: 26/255, blue: 39/255, alpha: 1) //背景色 暗色 不变它
//        self.navigationController?.navigationBar.backIndicatorImage = UIImage(color: UIColor(red: 27/255, green: 26/255, blue: 39/255, alpha: 1),
//                                                                              size: CGSizeMake(ScreenWidth, CGFloat(NavBar_Height))); //背景色 暗色 不变它
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        //修改导航栏按钮颜色
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        let hNav :CGFloat = (ScreenHeight>=812.0) ? 88.0 : 64.0;
////        let bknavImg :UIImage = UIImage.init(color: .clear, size: CGSizeMake(ScreenWidth, hNav))
//        let bknavImg :UIImage = UIImage.init(color: UIColor(red: 27/255, green: 26/255, blue: 39/255, alpha: 1), size: CGSizeMake(ScreenWidth, hNav))
//        self.navigationController?.navigationBar.setBackgroundImage(bknavImg, for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
//
//        self.navigationController?.navigationBar.subviews.last?.isHidden = true;
//        //tag 3333
//        self.navigationController?.navigationBar.subviews.forEach({ subView in
//            print("subView.tag  ---\(subView.tag)")
//            if(subView.tag == 3333){
//                subView.isHidden = true;
//            }else{
//            }
//        });
//
//        if(self.navigationItem.titleView?.tag == 3333 ||  self.navigationController?.navigationItem.titleView?.tag == 3333){
//            //            self.navigationItem.titleView = nil;
//            self.navigationItem.titleView?.backgroundColor =  UIColor(red: 27/255, green: 26/255, blue: 39/255, alpha: 1) //背景色 暗色 不变它
//            print("titleView颜色处理");
//        }
//
//        //
//        //self.setupNavigationBarWhiteTextColor(withBackViewCustomColor: UIColor(red: 27/255, green: 26/255, blue: 39/255, alpha: 1));
//
//     }
    
 
    
    public func initViews(){
        self.view.backgroundColor =   UIColor(red: 27, green: 26, blue: 39, alpha: 1) //背景色 暗色 不变它

        self.view.addSubview(self.maxBgView)
        self.view.addSubview(self.centerBgZheXianView)
        self.view.addSubview(self.topView)
        self.view.addSubview(self.footerBtnV)
        maxBgView.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview()
        }
        centerBgZheXianView.snp.makeConstraints { make in
            make.width.centerX.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        
        //0906 主直播列表页跳创建页 用yes
        if(boolPushLastVcIsWebOrNotClearnNavVc == true){
            topView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(0)
                make.left.right.equalToSuperview()
                make.height.equalTo(380+88)
            }
        }else{
            let hNav :CGFloat = (ScreenHeight>=812.0) ? 88.0 : 64.0;

            topView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(hNav)
                make.left.right.equalToSuperview()
                make.height.equalTo(hNav + 380);//(380+88)
            }
        }
      
        
        footerBtnV.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
      
        maxBgView.isHidden = true;
        centerBgZheXianView.isHidden = false;
    }
    
    /**
     实时摄像头获取获取图 用的时候新增 不用的时候删除
     */
    public func showLiveUseCarmeraView(){
        let liveUseCarmeraView = LiveUseCarmeraView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight));
        liveUseCarmeraView.setupCamera(with: AVCaptureDevice.Position.front, on: AVCaptureVideoOrientation.portrait);
        liveUseCarmeraView.backgroundColor = .clear;//透明颜色
        liveUseCarmeraView.tag = 666;
        self.maxBgView.addSubview(liveUseCarmeraView);

    }
    public func notShowLiveUseCarmeraView(){
        self.maxBgView.removeAllSubViews();
    }
    
}




extension ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController{
    
    
    public func zhiBoInfoDataInsetAction(isLiJiKaiBoBool:Bool) -> (dataOkBool: Bool , canUseModel: ZhiBoBaseInfo) {
        //数据上传
        let addZhiBoModel :ZhiBoBaseInfo = ZhiBoBaseInfo.init();
        
        //
        self.saveTitleStr = self.topView.inputTitleTF.text as? NSString ?? ""
        if(self.saveTitleStr.length <= 0 || self.isEmpty(self.saveTitleStr as String)){//无填写名字 或者 名字空格处理
            SVProgressHUD.showError(withStatus: .mybts)//"没有设置标题"
            SVProgressHUD.dismiss(withDelay: 2.0)
            return (false,addZhiBoModel)
        }
        
        //标题长度
        let titleLongNum : Int = Int(Y_ToolOfOthers.convert(toInt: self.saveTitleStr as String))
        if( titleLongNum >= 30){
            SVProgressHUD.showError(withStatus: .btLong)//"长度过了 -- 暂时的提示文本 上传失败"
            SVProgressHUD.dismiss(withDelay: 2.0)
            print("标题长度 titleLongNum \(titleLongNum)")
            return  (false,addZhiBoModel);
        }
        
        
        if(self.saveFenMianImgStr.length <= 0){
            SVProgressHUD.showError(withStatus: .myfms) //"没有设置封面"
            SVProgressHUD.dismiss(withDelay: 2.0)
            return (false,addZhiBoModel)
        }
        
        //公开=选中状态
        var gongKaiBool:Bool = false;
        if(self.topView.btnOfPubOrPir.isSelected){
            gongKaiBool = true;
        }else{
            gongKaiBool = false;
        }
        
        if(isLiJiKaiBoBool == true){//是立即开播 数据要求是半个小时后 这样提交才能过
            let banHours:Date = Date(timeIntervalSinceNow: 3600*0.5)
            self.saveKaiBoTimeStr =  YTimeStamp.getTimeTimestamp_haoMiao_Date(banHours) as NSString;
        }else{
            //不是立即开播
            if(self.saveKaiBoTimeStr.length <= 0 ){
                SVProgressHUD.showError(withStatus: .qxzkbrqs);//"请选择开播的日期"
                return (false,addZhiBoModel)
            }
        }
       
        addZhiBoModel.title = self.saveTitleStr as String
        addZhiBoModel.picture = self.saveFenMianImgStr as String
        addZhiBoModel.startDatetime = self.saveKaiBoTimeStr as String
        addZhiBoModel.recode = gongKaiBool ? "" :.smzb ; //"私密直播"//有值表示私密直播，无值表示公共直播
        addZhiBoModel.category = self.nowWillCreateTypeIsVoice ? "2": "1" ;//video音视频， 2、audio音频， 3、else 其他

        return (true,addZhiBoModel)
        
    }
    
    @objc func footerBtnAction()  {
        print("footerBtnAction 完成按钮")

        //立即开播
        if(self.topView.typeOfAtOnce.isSelected){
            self.nowGoTokaiBo()
            return;
        }
        //非立即开播
        let willUseInsetDatas = self.zhiBoInfoDataInsetAction(isLiJiKaiBoBool: false) //是否立刻开播 否
        if(willUseInsetDatas.dataOkBool == true){
            
            ZhiBoBaseNetTools.insertActivityData(willUseInsetDatas.canUseModel) {[weak self] (dicOfBloc: [AnyHashable : Any], succes) in
                if(succes){
                    print("上传成功 ---- \(succes)")
                    print("上传成功 dicOfBloc---- \(dicOfBloc)")
                    DispatchQueue.main.async {
                        print("  self ---- \(String(describing: self))")
                        SVProgressHUD.showSuccess(withStatus: .tjcgs)//"提交成功"
                        self?.navigationController?.popViewController(animated: true)

                    }
                    
                }
            }
        }

        
    }
    
}


//MARK:    -------  创建协议
extension ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController:TRTCVoiceRoomEnteryControlDelegate{
    public func voiceRoomCreateRoom(roomId: String, success: @escaping () -> Void, failed: @escaping (Int32, String) -> Void) {
        print("---主创建界面- voiceRoomCreateRoom  ----- \(roomId)")
        //        success()
    }
    
    public func voiceRoomDestroyRoom(roomId: String, success: @escaping () -> Void, failed: @escaping (Int32, String) -> Void) {
        print("---主创建界面- voiceRoomDestroyRoom  ----- \(roomId)")

    }
     
    
}


//MARK:    ------- 点击事件
extension ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController : CreateLiveOrVoiceViewDelegate{
    public func touchChooseFengMianPic() {
         print("照片")
        self.view.endEditing(true)
        self.iconImgTap()
       
    }
    
    public func touchChangePubOrPriType() {
        self.view.endEditing(true);
        print("公开私有")
        if(self.topView.btnOfPubOrPir.isSelected == true){
            print("公开类型 ");
            isPublicType = true
        }else{
            print("私有类型");
            isPublicType = false
        }
    }

    public func touchChooseVoiceType() {
        print("touchChooseVoiceType 语音类型")
        self.nowWillCreateTypeIsVoice = true;
        self.maxBgView.isHidden = true;
        self.notShowLiveUseCarmeraView()
        self.centerBgZheXianView.isHidden = false;
       
    }
    
    public func touchChooseLiveType() {
        print("touchChooseLiveType 视频类型")
        self.nowWillCreateTypeIsVoice = false;
        self.maxBgView.isHidden = false;
        self.showLiveUseCarmeraView()
        self.centerBgZheXianView.isHidden = true;
       
    }
    
    public func touchKaiBoTime() {
        print("开播时间")
        self.touchChooseTimes()
    }
    
    public func creatWithNumOfdispatch_later(_ block:@escaping () -> ()) {
        if(self.isLijiZhiBoCreatIng <= 0){// 循环完后 已经变成0  不走赋0方法
            return
        }
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: block)
    }
 
    
    
    
    //MARK: --------- 立即开播
    public func nowGoTokaiBo() {
        print("立即开播")
        let willUseInsetDatas = self.zhiBoInfoDataInsetAction(isLiJiKaiBoBool: true) //是否立刻开播 带上传数据 更新为当前时间
         if(willUseInsetDatas.dataOkBool == true){
             //--- 时间处理 立即开播的防治误点击 误上传后台 防创建多次
             if(self.isLijiZhiBoCreatIng > 0){
                 return
             }
             self.isLijiZhiBoCreatIng = 5
             self.creatWithNumOfdispatch_later {
                 self.isLijiZhiBoCreatIng = 0
             }
             //----

             //立即开播 间隔时间30分钟
             let banHours:Date = Date(timeIntervalSinceNow: 3600*0.5)
             self.saveKaiBoTimeStr =  YTimeStamp.getTimeTimestamp_haoMiao_Date(banHours) as NSString;
             willUseInsetDatas.canUseModel.startDatetime = self.saveKaiBoTimeStr as String
             SVProgressHUD.show(withStatus: .jzz);
             ZhiBoBaseNetTools.insertActivityData(willUseInsetDatas.canUseModel) { (dicOfBloc: [AnyHashable : Any], succes) in
                 SVProgressHUD.dismiss(withDelay: 0.3)
                 if(succes){
               
                     print("上传成功 ---- \(succes)")
                     print("上传成功 dicOfBloc---- \(dicOfBloc)")
                     
                     let getDataDic:NSDictionary = dicOfBloc as NSDictionary;
                     
                     if let dict = getDataDic as NSDictionary? as! [String:Any]? {
 
                         let activityId =   dict["activityId"] as! String
                         let roomId =   dict["id"] as! NSNumber
                         let roomIdstr = String(describing: roomId)
                         
                         var rec_password = ""
                         
                         let getKeyArr : NSArray = getDataDic.allKeys as NSArray;
                         if(getKeyArr.contains("recode")){
                              rec_password = dict["recode"] as! String
                         }
                         
                         let otherInfo : NSDictionary  = [ : ]
                         print("立即开播两个ID数据。 ---- activityId =\(String(describing: activityId)) ，roomIdstr = \(String(describing: roomIdstr))")

                         if (self.isPublicType  == true) {//公开
                             if(self.nowWillCreateTypeIsVoice){
                                
                                 self.kaiBo_voice_Action(activityId: activityId, roomId: roomIdstr)
                             }else{
                                 self.KaiBo_Live_Action(activityId: activityId, roomId: roomIdstr)
                             }
                         }else{//私密
                              if(self.nowWillCreateTypeIsVoice){
                                  self.kaiBo_voice_Action(activityId: activityId, roomId: roomIdstr, rec_passwordStr: rec_password,otherDic: otherInfo)
                             }else{
                                 self.KaiBo_Live_Action(activityId: activityId, roomId: roomIdstr ,rec_passwordStr:rec_password,otherDic:otherInfo);
                             }
                         }
                         
                        
                     }
                     
                     //                     let roomIdstr = dicOfBloc[AnyHashable("id")]  as! String
//                     let activityId = getDataDic.object(forKey: "activityId")  as! String
//                     let roomIdstr = getDataDic.object(forKey: "id")  as! String
//                     print("立即开播两个ID数据。 ---- activityId =\(String(describing: activityId)) ，roomIdstr = \(String(describing: roomIdstr))")
//                     if(self.nowWillCreateTypeIsVoice){
//                         self.kaiBo_voice_Action(activityId: activityId, roomId: roomIdstr)
//                     }else{
//                         self.KaiBo_Live_Action(activityId: activityId, roomId: roomIdstr)
//                     }
                 }else{
                     print("上传失败 --")
                 }
             }
         }
        
       
    }
    
    func KaiBo_Live_Action(activityId:String, roomId :String){
        print("开视频了")
        
     
        LiveRoomBase.liveroomCreate(withRoomIdStr: roomId,
                                    withActivityIdstr:activityId,
                                    withTitle: self.saveTitleStr as String,
                                    withFengMianUrlStr: self.saveFenMianImgStr as String,
                                    withIsPublicBool: self.isPublicType)
      
 
    }
    
    public func kaiBo_voice_Action(activityId:String, roomId :String){
        print("开语音了")
        let romId_int = Int32(roomId) ?? 0
        let roomParam_m = creatRoomInfoPam()
        
//        __block let romId_int_block =  romId_int;//0630创建接口 -- 获取接口 -- makeVc --设置麦序接口
        
        TRTCVoiceRoom.shared().createRoom(roomID: romId_int, roomParam:  roomParam_m ) { [self] (code, message) in
            if code == 0 {
                // 成功
                
                //                CreateAction()
                
                V2TIMManager.sharedInstance().getGroupsInfo([ roomId ]) { [weak self] groupInfos in
                    guard let `self` = self else { return }
                    guard let groupInfo = groupInfos?.first else { return }
                    if groupInfo.resultCode == 0 {
                        //当前房间正常到达
                        print("直播  roomId === \(roomId)");
                        print("将进入直播  groupInfos === \(String(describing: groupInfos))");
                        //                        guard let introduction = groupInfo.info.introduction else { return }
                        //                        let voiceRoomInfo = VoiceRoomInfo.init(roomID: Int(roomId) ?? 0, ownerId: introduction, memberCount: 0)
                        
                        print("将进入直播  groupInfo first  === \(String(describing: groupInfo.info))");
                        
                        print("将进入直播  groupInfo first introduction === \(String(describing: groupInfo.info.introduction))");
                        print("将进入直播  groupInfo first name === \(String(describing: groupInfo.info.groupName))");
                        print("将进入直播  groupInfo first memberCount === \(String(describing: groupInfo.info.memberCount))");

                        
                        let thisRoomInfoModel = creatRoomInfoData(roomI:Int(romId_int))
                        thisRoomInfoModel.activityIdStr = activityId
//                        thisRoomInfoModel.rec_passWordStr =
//                        thisRoomInfoModel.otherDic =
                        self.dependencyContainer.delegate = self;
                        let vc = self.dependencyContainer.makeVoiceRoomViewController(roomInfo: thisRoomInfoModel, role: .anchor, toneQuality: .defaultQuality)
                        
                        print(" kaiBo_voice_Action---- activityIdStr === \(thisRoomInfoModel.activityIdStr)");
                        print(" ----  roomID === \(thisRoomInfoModel.roomID) ");
                        
                       
                        
                        self.navigationController?.pushViewController(vc, animated: false)
                        
                        
                        TRTCVoiceRoom.shared().enterSeat(seatIndex: 0) {  (code, message) in
                            if code == 0 {
                                print(" ---- ok enterSeat");
                            }else{
                                print(" ---- errrrrrr enterSeat \(code)  \(message)");
                                SVProgressHUD.showInfo(withStatus: message);
                                SVProgressHUD.dismiss(withDelay: 2.0)
                            }
                        }
                        
                    } else {
                        print(" ---- errrrrrr 房间不存在");
                      
                    }
                } fail: { code, message in
                    debugPrint("code = \(code), message = \(message ?? "")")
                }
            } else{
                print(" ---- errrrrrr \(code) 失败信息 \(message)");
                SVProgressHUD.showInfo(withStatus: message);
                SVProgressHUD.dismiss(withDelay: 2.0)
               
            }
        }
        
        
    }
    
    public func kaiBo_voice_Action(activityId:String, roomId :String, rec_passwordStr:String,otherDic:NSDictionary){
        print("开语音了")
        let romId_int = Int32(roomId) ?? 0
        let roomParam_m = creatRoomInfoPam()
        
//        __block let romId_int_block =  romId_int;//0630创建接口 -- 获取接口 -- makeVc --设置麦序接口
        
        TRTCVoiceRoom.shared().createRoom(roomID: romId_int, roomParam:  roomParam_m ) { [self] (code, message) in
            if code == 0 {
                // 成功
                
                //                CreateAction()
                
                V2TIMManager.sharedInstance().getGroupsInfo([ roomId ]) { [weak self] groupInfos in
                    guard let `self` = self else { return }
                    guard let groupInfo = groupInfos?.first else { return }
                    if groupInfo.resultCode == 0 {
                        //当前房间正常到达
                        print("直播  roomId === \(roomId)");
                        print("将进入直播  groupInfos === \(String(describing: groupInfos))");
                        //                        guard let introduction = groupInfo.info.introduction else { return }
                        //                        let voiceRoomInfo = VoiceRoomInfo.init(roomID: Int(roomId) ?? 0, ownerId: introduction, memberCount: 0)
                        
                        print("将进入直播  groupInfo first  === \(String(describing: groupInfo.info))");
                        
                        print("将进入直播  groupInfo first introduction === \(String(describing: groupInfo.info.introduction))");
                        print("将进入直播  groupInfo first name === \(String(describing: groupInfo.info.groupName))");
                        print("将进入直播  groupInfo first memberCount === \(String(describing: groupInfo.info.memberCount))");

                        
                        let thisRoomInfoModel = creatRoomInfoData(roomI:Int(romId_int))
                        thisRoomInfoModel.activityIdStr = activityId
                        thisRoomInfoModel.rec_passWordStr = rec_passwordStr;
                        thisRoomInfoModel.otherDic = otherDic as! [AnyHashable : Any];
                        self.dependencyContainer.delegate = self;
                        let vc = self.dependencyContainer.makeVoiceRoomViewController(roomInfo: thisRoomInfoModel, role: .anchor, toneQuality: .defaultQuality)
                        
                        print(" kaiBo_voice_Action---- activityIdStr === \(thisRoomInfoModel.activityIdStr)");
                        print(" ----  roomID === \(thisRoomInfoModel.roomID) ");
                        
                       
                        
                        self.navigationController?.pushViewController(vc, animated: false)
                        
                        
                        TRTCVoiceRoom.shared().enterSeat(seatIndex: 0) {  (code, message) in
                            if code == 0 {
                                print(" ---- ok enterSeat");
                            }else{
                                print(" ---- errrrrrr enterSeat \(code)  \(message)");
                                SVProgressHUD.showInfo(withStatus: message);
                                SVProgressHUD.dismiss(withDelay: 2.0)
                            }
                        }
                        
                    } else {
                        print(" ---- errrrrrr 房间不存在");
                      
                    }
                } fail: { code, message in
                    debugPrint("code = \(code), message = \(message ?? "")")
                }
            } else{
                print(" ---- errrrrrr \(code) 失败信息 \(message)");
                SVProgressHUD.showInfo(withStatus: message);
                SVProgressHUD.dismiss(withDelay: 2.0)
               
            }
        }
        
        
    }
    
    public func KaiBo_Live_Action(activityId:String, roomId :String, rec_passwordStr:String,otherDic:NSDictionary){
        print("开视频了")
        
     
        LiveRoomBase.liveroomCreate(withRoomIdStr: roomId,
                                    withActivityIdstr:activityId,
                                    withTitle: self.saveTitleStr as String,
                                    withFengMianUrlStr: self.saveFenMianImgStr as String,
                                    withIsPublicBool: self.isPublicType,
                                    withResPasswordStr: rec_passwordStr,
                                    withOtherDic: otherDic as! [AnyHashable : Any])
      
 
    }
    
    
    func   creatRoomInfoPam()->VoiceRoomParam{
        
        // 初始化语聊房参数
        let roomParam = VoiceRoomParam()
        roomParam.roomName = saveTitleStr as String
        roomParam.needRequest = true // 听众上麦是否需要房主同意
        roomParam.coverUrl  = saveFenMianImgStr as String //"房间封面图的 URL 地址"
        roomParam.seatCount = 9 // 房间座位数，这里一共7个座位，房主占了一个后听众剩下6个座位
        roomParam.seatInfoList = []
        
        // 初始化麦位信息
        for _ in 0 ..< roomParam.seatCount {
            let seatInfo = VoiceRoomSeatInfo()
            roomParam.seatInfoList.append(seatInfo)
        }
        
        return roomParam;
    }
    
//    func getRoomId() -> Int {
//        //        let userId = userID ?? dependencyContainer.userId
//        let userId = IM_userID
//        let result = "\(userId)_voice_room".hash & 0x7FFFFFFF
//        TRTCLog.out("房间号---- hashValue:room id:\(result), userId: \(userId)")
//        return result
//    }
    
    @objc func creatRoomInfoData(roomI:Int )->VoiceRoomInfo{
         
        let  baseVoiceRoomInfo = VoiceRoomInfo.init(roomID: roomI, ownerId: ShareUserInfo.share().userInfo.imId, memberCount: 9);
        baseVoiceRoomInfo.coverUrl = saveFenMianImgStr as String;
        baseVoiceRoomInfo.roomName = saveTitleStr as String;
        baseVoiceRoomInfo.ownerName = self.suoDuanAddressStr() as String
        baseVoiceRoomInfo.ownHeaderImgStr = ShareUserInfo.share().userInfo.profileImageUrl;
        baseVoiceRoomInfo.needRequest = true;//上麦相关
        return baseVoiceRoomInfo
    }
     
    @objc  func suoDuanAddressStr() -> NSString{
        let yuanStr =  ShareUserInfo.share().userInfo.address;
        print("\(ShareUserInfo.share().userInfo)")
        print("\(ShareUserInfo.share().userInfo.address)")
        print("\(ShareUserInfo.share().userInfo.address)")
        return LiveRoomBase.suoDuanAddressStr(yuanStr) as NSString
    
    }
    
    /**
     + (NSString *)suoDuanAddressStr{
         if( [ShareUserInfo share].userInfo.address.length > 8){
             NSString *okStr = @"";
             //取后四位和前四位
             NSString *preStr = [[ShareUserInfo share].userInfo.address substringToIndex:4];
             NSString *suStr = [[ShareUserInfo share].userInfo.address substringFromIndex: [ShareUserInfo share].userInfo.address.length-4];//倒数4的位置截取
             okStr = [NSString stringWithFormat:@"%@***%@",preStr,suStr];
             return  okStr;
         }else if ( [ShareUserInfo share].userInfo.address.length > 0){
             return [ShareUserInfo share].userInfo.address;
         }else{
             return @"地址缺失";
         }
     }*/
    
    
}


//时间选择 图片相关选择
extension ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    
    public func touchChooseTimes(){
        if(self.saveKaiBoTimeStr.length<=0){//滚轮show时 不滚动不确定时 就不会有数据 --做个初始的数据
//            self.saveKaiBoTimeStr =  YTimeStamp.getNowTimeTimestamp_haoMiao() as NSString
//            self.topView.kaiBoTimeL.text =  YTimeStamp.getCurrentTimeStr_nianToMiao() as String //点击后 就有初始值 则需要赋予界面UI

            self.saveKaiBoTimeStr =  YTimeStamp.getTimeTimestamp_haoMiao_Date( Date(timeIntervalSinceNow: 3600*0.5) ) as NSString //后半个小时
            self.topView.kaiBoTimeL.text =  YTimeStamp.getYMDhmsTimeStrUseInfoTimeIvStr( self.saveKaiBoTimeStr as String  ) as String //点击后 就有初始值 则需要赋予界面UI  //后半个小时
        }
        
        let datePickerView:BRDatePickerView =  BRDatePickerView.init()
        datePickerView.pickerMode = .YMDHMS
        datePickerView.title = ""
        datePickerView.maxDate = Date(timeIntervalSinceNow: 3600*24*365)
        datePickerView.minDate = Date(timeIntervalSinceNow: 3600*0.5)
        datePickerView.selectDate = Date(timeIntervalSinceNow: 3600*0.5)
        datePickerView.isAutoSelect = true
        let customStyle:BRPickerStyle = BRPickerStyle.init()
        customStyle.pickerColor = .white
        customStyle.pickerTextColor = BR_RGB_HEX(0x4bb030,1.0)
        customStyle.separatorColor = .black
        
        
        /**
         //语言设置
         // language: zh-Hans（简体中文）、zh-Hant（繁体中文）、en（英语 ）
         NSString *nowLangs =  [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Locale_Type"]];
         if(nowLangs.length>0 && ( [nowLangs containsString:@"zh-Hans"] || [nowLangs containsString:@"zh-Hant"] || [nowLangs containsString:@"en"]) ){
         customStyle.language = nowLangs;
         }else{//跟随系统
         }
         datePickerView.pickerStyle = customStyle;
         */
        let nowLangs : NSString = UserDefaults.standard.object(forKey: "Locale_Type") as! NSString ;
        if(nowLangs.length>0 && ( nowLangs.contains("zh-Hans")   || nowLangs.contains("zh-Hant")  || nowLangs.contains("en") )){
            customStyle.language = nowLangs as String;
        }else{//跟随系统
        }
        
        datePickerView.pickerStyle = customStyle
        datePickerView.resultRangeBlock = {[weak self]  (beginD:Date? , endDtae:Date?  ,v: String?) in
            print("时间---变化中 ddddd ==\(String(describing: beginD))   ==\(String(describing: endDtae))  vvvvv = \(String(describing: v))")
            self?.saveKaiBoTimeStr =  YTimeStamp.getTimeTimestamp_haoMiao_Date(endDtae!) as NSString;
            self?.topView.kaiBoTimeL.text =  v! as String
            
            
        }
        datePickerView.resultBlock = { [weak self] (d:Date?,v: String?) in
            print("时间--- ddddd ==\(String(describing: d))  vvvvv = \(String(describing: v))")
            self?.saveKaiBoTimeStr =  YTimeStamp.getTimeTimestamp_haoMiao_Date(d!) as NSString;
            self?.topView.kaiBoTimeL.text =  v! as String
        }
        datePickerView.show()
        
    }
        
    public func iconImgTap(){
        let alertVC:UIAlertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        //"拍照"
        let photographAction : UIAlertAction =  UIAlertAction.init(title: .pzs, style: .default) { [weak self] alertaction in
            self?.chooseImageWithType(type: 0)
        }
        //"相册"
        let photoalbumAction : UIAlertAction =  UIAlertAction.init(title: .xcs, style: .default) { [weak self] alertaction in
            self?.chooseImageWithType(type: 1)
        }
        
        //"取消"
        let cancleAction : UIAlertAction =  UIAlertAction.init(title: .qxs, style: .cancel)
        alertVC.addAction(photographAction)
        alertVC.addAction(photoalbumAction)
        alertVC.addAction(cancleAction)
        alertVC.modalPresentationStyle = .fullScreen
        self.present(alertVC, animated: true)
        
        
        
    }
    
    func chooseImageWithType(type:Int)  {

        let pickVC:UIImagePickerController = UIImagePickerController.init()
        pickVC.delegate = self;
        if(type == 0){//相机
            pickVC.allowsEditing = false;
            pickVC.sourceType =  .camera
        }else if(type == 1){//相册
            pickVC.sourceType =  .savedPhotosAlbum
        }
        let hNav :CGFloat = (ScreenHeight>=812.0) ? 88.0 : 64.0;
        let bknavImg :UIImage = UIImage.init(color: .blue, size: CGSizeMake(ScreenWidth, hNav))
        pickVC.navigationBar.setBackgroundImage(bknavImg, for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        pickVC.navigationBar.tintColor = .cyan
        
        pickVC.modalPresentationStyle = .fullScreen
        self.present(pickVC, animated: true )
     }
    
    
    //
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        self.dismiss(animated: true)
        let photo = info[.originalImage]
        if(photo == nil){
            return
        }
        self.imgDetalWithPhoto(photo: photo as! UIImage)
    }
    
    func imgDetalWithPhoto(photo:UIImage) {
        let upImgDic:NSMutableDictionary = NSMutableDictionary.init(object: Img_ModuleType_im, forKey: Img_Module_Key as NSCopying)
        PubNetwork.pub_sendImg(withOneImgObj: photo, andParms: upImgDic) { [weak self] (dicOfBlock : [AnyHashable : Any], success) in
 
            if(success){
                self?.topView.fengMianImgV.image = photo
                let onePubSendUpImgOkGetArrObjModel:PubSendUpImgOkGetArrObjModel = PubSendUpImgOkGetArrObjModel.mj_object(withKeyValues: dicOfBlock)
                self?.saveFenMianImgStr = onePubSendUpImgOkGetArrObjModel.url as NSString
                print(" saveFenMianImgStr --- \(self!.saveFenMianImgStr)")
            }else{
                SVProgressHUD.showInfo(withStatus: .scsbs) //"上传失败"
            }
             
        }
 
       
    }
    
    
    
}



/**
 
 
 #pragma mark - UIImagePickerControllerDelegate 图片 回调
 
         if(succes){
             weakSelf.topView.fengMianImgV.image = photo;
             
             PubSendUpImgOkGetArrObjModel *mo = [PubSendUpImgOkGetArrObjModel mj_objectWithKeyValues:dicOfBlock];
             weakSelf.saveFenMianImgStr = mo.url;
             DLog(@"weakSelf.saveFenMianImgStr === %@ ",weakSelf.saveFenMianImgStr);
             
         }else{
             Y_SVP_SHOW_ERR_MES(@"上传失败");
         }
     }];
 }
 
 */


/// MARK: - internationalization string
fileprivate extension String {
    static let wanchengS = mainSwiftUseLanguageStr("完成")
    static let mybts = mainSwiftUseLanguageStr("没有设置标题")
    static let myfms = mainSwiftUseLanguageStr("没有设置封面")
    static let qxzkbrqs = mainSwiftUseLanguageStr("请选择开播的日期")
    static let smzb = mainSwiftUseLanguageStr("私密直播")
    static let tjcgs = mainSwiftUseLanguageStr("提交成功")
    static let dzqss = mainSwiftUseLanguageStr("地址缺失")//在遵守协议的vc扩展内调用无效了
    static let scsbs = mainSwiftUseLanguageStr("上傳失敗")
    static let pzs = mainSwiftUseLanguageStr("拍照")
    static let xcs = mainSwiftUseLanguageStr("相册")
    static let qxs = mainSwiftUseLanguageStr("取消")
    static let jzz = mainSwiftUseLanguageStr("加载中")
    static let btLong = mainSwiftUseLanguageStr("标题长度限制")
   
    
}
