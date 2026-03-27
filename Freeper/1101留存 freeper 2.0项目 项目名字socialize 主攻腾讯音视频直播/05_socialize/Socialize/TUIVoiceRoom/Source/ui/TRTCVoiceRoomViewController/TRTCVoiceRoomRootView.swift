//
//  TRTCVoiceRoomRootView.swift
//  TRTCVoiceRoomDemo
//
//  Created by abyyxwang on 2020/6/8.
//Copyright © 2020 tencent. All rights reserved.
//
import UIKit
import Kingfisher
import Toast_Swift
import ImSDK_Plus

 

class TRTCVoiceRoomRootView: UIView {
    
    
//    static let PopView_Tag_Manager:Int  =  1001;
//    static let PopView_Tag_Member_ZhuBo:Int  =  1002;
//    static let PopView_Tag_Member_GuanZhong:Int  =  1003;
//    let float_voiceNewTopView_H:CGFloat = 150.0
    //OC----b
    let voiceNewTopView:VoiceTopView = VoiceTopView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 135))
    //顶部红包相关显示区
    let redEnv_TopView_WaitToGotView:VoiceTopRedEnv_WaitGotView = VoiceTopRedEnv_WaitGotView.init(frame: CGRect(x: 10, y:  135, width: 48.0, height: 44.0))
    let redEnv_TopView_GotedInfoView:VoiceTopRedEnvView_ZhuBoGotDaShangeAndShowTipView = VoiceTopRedEnvView_ZhuBoGotDaShangeAndShowTipView.init(frame: CGRect(x: ScreenWidth*0.6, y: 135, width: ScreenWidth*0.4-10, height: 44.0))

    
    
    var saveNowUserInfo_Name:NSString  = ""
    var saveNowUserInfo_ID:NSString  = ""
    var saveNowUserInfo_HeaderImgUrl:NSString  = ""
    
    var saveZhuBoInfo_Name:NSString  = ""
    var saveZhuBoInfo_ID:NSString  = ""
    var saveZhuBoInfo_HeaderImgUrl:NSString  = ""
    var saveZhuBoInfo_Introduce:NSString  = ""
    var saveThisRoomNoticeStr:NSString  = ""
    var saveThisRoomBkImgUrl:NSString = ""
    var saveThisRoomGroupFaceUrl:NSString = ""
    var saveThisRoomGroupIDStr:NSString = "" //群id
    var saveThisRoomID:NSString = ""//保存房间信息
    var saveThisRoomName:NSString = ""//保存房间信息
    var saveThisRoomOwnerId:NSString = ""//保存房主信息
    var saveThisRoomOwnerName:NSString = ""//保存房主信息
    var saveThisRoomOwnerFaceUrl:NSString = ""//保存房主信息
    //
    var saveAllMemberListArr:NSMutableArray? = [] as NSMutableArray //保存所有成员arr
    var saveVoiceZhuBoMember: V2TIMGroupMemberFullInfo? //主播
    var saveVoiceGuanLiYuanMemberListArr:NSMutableArray? = [] as NSMutableArray //管理员列表 //直播不支持管理员相关数据
    var saveVoicePuTongMemberListArr:NSMutableArray? = [] as NSMutableArray //普通成员列表｜非主播
    var saveVoicePuTongShangMaiListArr:NSMutableArray? = [] as NSMutableArray //上麦的观众｜非主播
    var saveVoicePuTongShangMaiShenQingMemberListArr:NSMutableArray? = [] as NSMutableArray //上麦申请的列表 未处理同意未处理成功的list
    
    //0630观众上麦后 普通成员list就没有该数据了，总成员不会根据上麦变化。---已经上麦人员数据可以使用减法

    
    
    //关注
    var guanZhuPopView:GuanZhuPopView?
    //分享
    var shareBottomPopView:ShareBottomPopView?
    //聊天
    var chatPopView:ChatPopView?
    
    
 
    var voiceBottomToolPopView:VoiceBottomToolPopView?
    var voiceMemberListPopView:VoiceMemberPopListView?//base 当前listpop的总父类
    var voiceSetManagerPearsonsPopView:VoiceSetManagerPearsonsPopView? //设置管理缘
    var voiceManagerShangMaiShengQingPopView:VoiceManagerShangMaiShengQingPopView? //上麦管理
    var voiceOnSpeckOrOnLinePopView:VoiceOnSpeckOrOnLinePopView? //在线list 在麦上list
    var voiceOnSpeckOrOnLine_willShowBool:Bool = false //防止短时间多次调用导致数据问题
    var save_thisActivity_Id : NSString? //活动ID
    var save_thisActivity_Res_PasswordStr:NSString?
    var save_thisActivity_otherDic:NSDictionary?
    
    var save_DanMuJinYanIdsArr: NSMutableArray? = []//成员中 被弹幕禁言的id
    var save_shangMaiJinYinIdsArr: NSMutableArray? = []//成员中 上麦者 禁止推声音流的id 相当于给上麦的观众静音了


    var thisVcPersonAllInfo:NSArray? = [] //0920 总成员数据
    
    
     
    //OC----e
    private var isViewReady: Bool = false
    let viewModel: TRTCVoiceRoomViewModel
    public weak var rootViewController: UIViewController?
    
    init(frame: CGRect = .zero, viewModel: TRTCVoiceRoomViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        bindInteraction()
        topViewInfoChange()//初始topview位置

    }
    
    required init?(coder: NSCoder) {
        fatalError("can't init this viiew from coder")
    }
    
    let backgroundLayer: CALayer = {
        // fillCode
        let layer = CAGradientLayer()
        layer.colors = [UIColor.init(0x13294b).cgColor, UIColor.init(0x000000).cgColor]
        layer.locations = [0.2, 1.0]
        layer.startPoint = CGPoint(x: 0.4, y: 0)
        layer.endPoint = CGPoint(x: 0.6, y: 1.0)
        return layer
    }()
    
    lazy var bgView: UIImageView = {
        let bg = UIImageView(frame: .zero)
        bg.contentMode = .scaleAspectFill
//        bg.image = UIImage(named: "")//0906l背景色backgroundLayer
 
        return bg
    }()
    
    let masterContainer: UIView = {
        let view = UIView.init(frame: .zero)
        return view
    }()
 
    
    lazy var topView : VoiceTopView = {
        print("----- 房间ID --------\(viewModel.roomInfo.roomID)")
        //topVoew
        var view = self.voiceNewTopView
        voiceNewTopView.topViewDelegate = self;
        voiceNewTopView.closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        voiceNewTopView.guanZhuRedBtn.addTarget(self, action: #selector(guanZhuBtnClick), for: .touchUpInside)
        self.getThisRoomInfoSetTopViews()
  
        //房间名字位置
        self.saveThisRoomName =  viewModel.roomInfo.roomName.isEmpty ? ""  : viewModel.roomInfo.roomName as NSString;
        self.voiceNewTopView.topViewSetInfo(withRoomName: self.saveThisRoomName as String)
        //热度位置 房间ID数据
        // view.topViewSetReDuNum(Int32(viewModel.roomInfo.roomID));
        
        //成员
        if(viewModel.roomInfo.memberCount > 0){
            // getRealMemberAudienceList
           // view.topViewSetList(withMemberListInfo: viewModel.getRealMemberAudienceList());
        }
        return view
    }()
    
    lazy var topView_redEnv:VoiceTopRedEnv_WaitGotView = {
        var view = self.redEnv_TopView_WaitToGotView;
        self.redEnv_TopView_WaitToGotView.delegate = self;
        
        return view;
    }()
    
    lazy var topView_redEnvZhuBoGoted_DaShang:VoiceTopRedEnvView_ZhuBoGotDaShangeAndShowTipView = {
        var view = self.redEnv_TopView_GotedInfoView;
        return view;
    }()
    
    //MARK: _____自定义的方法 一部分 begin
    //MARK: === 初始topViews
    @objc func getThisRoomInfoSetTopViews(){
      
        //房间信息
        if (( self.viewModel.roomInfo.roomID ) != 0){
            
            viewModel.voiceRoom.getRoomInfoList(roomIdList: [NSNumber(value: viewModel.roomInfo.roomID)]) {  (code,msg,roomInfoList : [VoiceRoomInfo]) in
                var roomInfo:VoiceRoomInfo?
                if(roomInfoList.count>0){
                    roomInfo = roomInfoList.first
                    self.saveThisRoomName = roomInfo!.roomName as NSString;
                
                    self.saveThisRoomID = String(roomInfo!.roomID) as NSString;
                    self.saveThisRoomOwnerId = roomInfo!.ownerId as NSString;
                    self.saveThisRoomOwnerName = String(roomInfo!.ownerName) as NSString
                    
                    
                    //top 房间名字
                    self.voiceNewTopView.topViewSetInfo(withRoomName: self.saveThisRoomName as String)
                    //背景图
                    let bkImg_url =  String(roomInfo!.coverUrl) as NSString //背景图
                    if(bkImg_url.length>0){
                        if ( self.saveThisRoomBkImgUrl.length<=0 || !( self.saveZhuBoInfo_ID == bkImg_url)){//空或者不是同一个图
                            self.saveThisRoomBkImgUrl = bkImg_url
                            //self.bgView.kf.setImage(with: URL(string: self.saveThisRoomBkImgUrl as String), placeholder: nil, options: [.backgroundDecode], completionHandler: nil)
                        }
                    }
                    print(" getThisRoomInfoSetTopViews =\(code)=\(msg)====  \(String(describing: roomInfo?.roomName)) \(String(describing: roomInfo?.roomID)) \(String(describing: roomInfo?.ownerId)) \nroomInfo?.ownerName==\(String(describing: roomInfo?.ownerName))")//拥有者
                    //公告 此处没有简介数据 ，头像是主播头像 此处无该数据
                    // 自定义传入的几个参数 不再接口返回范围内

                }
           }
        }
        
      
        //延时获取 房间简介信息 主播头像 成员各类型信息
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            self.getRoomInfoIntroduAction()
            self.getThisRoomZhuBoUserFaceUrlInfoAction()
            self.getNowUserInfoAction()
            self.getAllTypesMemberDatas()
      
 
        }

        
    }
    
    @objc func getRoomInfoIntroduAction(){
        //群信息-//群简介 空的简介
        V2TIMManager.sharedInstance().getGroupsInfo([String(viewModel.roomInfo.roomID)]) { [weak self] (roomInfoList:[V2TIMGroupInfoResult]?) in
            guard let `self` = self else { return }
            
            print("getRoomInfoIntroduAction  ---- roomInfoList \(String(describing: roomInfoList))")
            guard let roomInfo = roomInfoList?.first?.info else {
                return
            }
            self.saveThisRoomGroupIDStr = roomInfo.groupID.isEmpty ? "" :   roomInfo.groupID as NSString;
            //群头像 保存后暂时用到分享的位置其他地方未使用
            if((roomInfo.faceURL) != nil){
                self.saveThisRoomGroupFaceUrl = roomInfo.faceURL.isEmpty ? "" : roomInfo.faceURL as NSString
            }
            let qGongGao =  roomInfo.notification;
            let jianJie = roomInfo.introduction
            //优先用简介
            if jianJie != nil {
                //公告简介
                self.voiceNewTopView.topViewSetGongGaoInfo(withGongGaoStr: String(roomInfo.introduction) ) //简介
                self.saveZhuBoInfo_Introduce = (roomInfo.introduction as? NSString)!;
                self.topView.topViewSetGongGaoInfo(withGongGaoStr: self.saveZhuBoInfo_Introduce as String)
           
            }else{
                //群简介 空的简介--- 在看看公告有没得
                if qGongGao != nil{
                    //公告简介
                    self.voiceNewTopView.topViewSetGongGaoInfo(withGongGaoStr: String(roomInfo.notification) ) //简介
                    self.saveThisRoomNoticeStr = (roomInfo.notification as? NSString)!
                    self.topView.topViewSetGongGaoInfo(withGongGaoStr: self.saveThisRoomNoticeStr as String)

                }
            }
            //群创建人/管理员 roomInfo.owner)
            print(" getRoomInfoList 群 introduction====  \( String(describing: roomInfo.introduction)) notification==\( String(describing: roomInfo.notification) )")
            print(" getRoomInfoList 群  \(String(describing: roomInfo.groupName)) \(String(describing: roomInfo.groupID))  当前用户的角色role \(String(describing: roomInfo.role)) \n roomInfo?.owner 群创建人/管理员  ==\(String(describing: roomInfo.owner))")

        } fail: { (code:Int32, msg:String?) in
            print("getRoomInfoIntroduAction  ---- fail")
        }
    }
    
    @objc func getThisRoomZhuBoUserFaceUrlInfoAction(){
        //主播头像信息
        if(!viewModel.roomInfo.ownerId.isEmpty){
            
            
            self.viewModel.voiceRoom.getUserInfoList(userIDList: [ viewModel.roomInfo.ownerId ]) { (code,msg,userIdListArr : [VoiceRoomUserInfo]) in
                print("主播头像信息 getThisRoomZhuBoUserFaceUrlInfoAction roomInfo.ownerId =\(code)=\(msg)===")
                
                if(code == 0){
                    let ownInfo:VoiceRoomUserInfo = userIdListArr.first!
                    if(ownInfo.userAvatar.count > 0){
                        self.saveZhuBoInfo_HeaderImgUrl =  ownInfo.userAvatar as NSString
                        self.voiceNewTopView.topViewSetInfo(withHeaderUrlStr: self.saveZhuBoInfo_HeaderImgUrl as String)
                        //self.viewModel.masterAnchor?.seatUser?.userAvatar = self.saveZhuBoInfo_HeaderImgUrl as String //不确定是不是主麦序
                    }
                    self.saveZhuBoInfo_Name = ((ownInfo.userName !=  "") ? ownInfo.userName : "" ) as NSString; //主播名字暂未使用
                    print("userName=\(ownInfo.userName)=   头像1userAvatar =\( self.saveZhuBoInfo_HeaderImgUrl ) ")

                }
            }
        
        }else{
            print("主播头像信息 getThisRoomZhuBoUserFaceUrlInfoAction saveThisRoomOwnerId=\(saveThisRoomOwnerId)= v ower id\(viewModel.roomInfo.ownerId)===")
        }
       
    }
    
    //当前用户的名字和头像
    func getNowUserInfoAction() {
    
        
        if( viewModel.dependencyContainer.userId.isEmpty){
            return
        }
        self.saveNowUserInfo_ID = viewModel.dependencyContainer.userId as NSString ;
        self.viewModel.voiceRoom.getUserInfoList(userIDList: [ viewModel.dependencyContainer.userId ]) { (code,msg,userIdListArr : [VoiceRoomUserInfo]) in
            print("当前用户的名字和头像相关信息 getThisRoomZhuBoUserFaceUrlInfoAction roomInfo.ownerId =\(code)=\(msg)===")
            
            if(code == 0){
                let myInfo:VoiceRoomUserInfo = userIdListArr.first!
                if(myInfo.userAvatar.count > 0){
                    self.saveNowUserInfo_HeaderImgUrl =  myInfo.userAvatar as NSString
                }
                self.saveNowUserInfo_Name = ((myInfo.userName !=  "") ? myInfo.userName : "" ) as NSString; //主播名字暂未使用
                print("当前用户的名字和头像 userName=\(myInfo.userName)=   头像userAvatar =\( self.saveNowUserInfo_HeaderImgUrl ) ")
                TRTCVoiceRoomIMManager.shared.curUserID = self.saveNowUserInfo_ID as String;
                TRTCVoiceRoomIMManager.shared.curUserAvatar = self.saveNowUserInfo_HeaderImgUrl as String;
                TRTCVoiceRoomIMManager.shared.curUserName = self.saveNowUserInfo_Name as String;
                TRTCVoiceRoomIMManager.shared.curUserID = self.saveNowUserInfo_ID as String;
                //当前用户 是 --- TRTCVoiceRoomIMManager c

            }else{
                TRTCVoiceRoomIMManager.shared.loadData()
            }
        }
    
    }
    
    /**
     //群成员 V2TIMGroupMemberFullInfo 各个popcell用到的类型
     V2TIM_GROUP_MEMBER_FILTER_ALL          = 0x00,  ///< 全部成员
     V2TIM_GROUP_MEMBER_FILTER_OWNER        = 0x01,  ///< 群主
     V2TIM_GROUP_MEMBER_FILTER_ADMIN        = 0x02,  ///< 管理员
     V2TIM_GROUP_MEMBER_FILTER_COMMON       = 0x04,  ///< 普通成员

     */
    @objc func getAllTypesMemberDatas() {
        getAllMembers()
        getQunZhuMember()
        //getGuanLiYuanMember()//msg "AVChatRoom not support admin role" 直播类型管理员不支持
        getPuTongMembers()
    }
    
//    func  listZhuanHuanWithV2GmUseAudienceInfoModel( aList: [AudienceInfoModel] ) ->  ([V2TIMGroupMemberFullInfo]){
//
//        var okGMList:[V2TIMGroupMemberFullInfo] = []
//
////        //只读属性 放弃本转换
////        subObj in aList{
////            let  aMeb : V2TIMGroupMemberFullInfo = V2TIMGroupMemberFullInfo.init()
////            aMeb.nickName = subObj.userInfo.userName
////            aMeb.faceURL = subObj.userInfo.userAvatar
////            aMeb.userID = subObj.userInfo.userId
////            okGMList.append( aMeb )
////        }
//
//        return okGMList
//
//    }
    //全部成员
    @objc func getAllMembers() {
 
        V2TIMManager.sharedInstance().getGroupMemberList(String(viewModel.roomInfo.roomID), filter: UInt32(0x00), nextSeq: UInt64(0)) { [weak self](code, memberList: [V2TIMGroupMemberFullInfo]?) in
            guard let `self` = self else { return }
            guard memberList?.first != nil else {
                return
            }
            if ((memberList) != nil) {
                saveAllMemberListArr!.removeAllObjects()
                for memberObj:V2TIMGroupMemberFullInfo in memberList! {
                    saveAllMemberListArr!.add(memberObj as Any)
                }
                topViewInfoChange()
//                topView.topViewSetList(withMemberListInfo: saveAllMemberListArr as! [Any]);//
                var topUseGuanZhongInfo : NSMutableArray = []
                for obj  in viewModel.memberAudienceList {
                    topUseGuanZhongInfo.add(obj.userInfo)
                    print("顶部成员数据 --- topUseGuanZhongInfo addsub  = \(obj.userInfo)  userId= \(obj.userInfo.userId) userAvatar= \(obj.userInfo.userAvatar)")

                }
                //topView.topViewSetList(withMemberListInfo: topUseGuanZhongInfo );
                
                //刷新全部人员头像
               var useTopListShowDataArr:NSMutableArray = [];
               saveAllMemberListArr?.forEach({ (userobj) in
                   let  obj_u = VoiceRoomUserInfo.init();
                   obj_u.userId = (userobj as! V2TIMGroupMemberFullInfo).userID ?? "";
                   obj_u.userName = (userobj as! V2TIMGroupMemberFullInfo).nickName ?? "";
                   obj_u.userAvatar = (userobj as! V2TIMGroupMemberFullInfo).faceURL ?? "";
                   useTopListShowDataArr.add(obj_u)
              })
               
                topView.topViewSetList(withMemberListInfo: useTopListShowDataArr );
               topView.collectionView.reloadData()
            }
            
            
            
            print("全部成员 getAllMembers saveAllMemberListArr= \(String(describing: saveAllMemberListArr))")
            
            if(topView.xuNiPersonSave == 0){
                topView.topViewSetReDuNum(Int32(saveAllMemberListArr?.count ?? 0));//当前全部人数 -- 初始时，后续人数进出需要再次赋值
            }else{
                //重新加载叠加来虚拟数据的总数
                let showNum =  Int32(saveAllMemberListArr?.count ?? 0) + Int32(topView.xuNiPersonSave)
                self.topView.reloadRoomXuNiPersonIndex(showNum);
            }
            
           
        } fail: { (code, msg) in

        }
        
    }
   
   
    //群主
    @objc func getQunZhuMember(){
        /**
        V2TIM_GROUP_MEMBER_FILTER_OWNER        = 0x01,  ///< 群主
         */
 
       
        V2TIMManager.sharedInstance().getGroupMemberList(String(viewModel.roomInfo.roomID), filter: UInt32(0x01), nextSeq: UInt64(0)) { [weak self](code, memberList: [V2TIMGroupMemberFullInfo]?) in
            guard let `self` = self else { return }
            guard memberList?.first != nil else {
                return
            }
            print("群主 getQunZhuMember list \(String(describing: memberList?.first))  \(String(describing: memberList?.first?.role))")
            if ((memberList) != nil) {
                for memberObj:V2TIMGroupMemberFullInfo in memberList! {
                    if(memberObj.role == 400){
                        self.saveVoiceZhuBoMember = memberObj;//留到管理时pop要用
                        let ownIdStr :NSString =  ((memberObj.userID?.isEmpty) == nil) ? "" : memberObj.userID! as NSString;
                        let nameStr :NSString =  ((memberObj.nickName?.isEmpty) == nil) ? "" : memberObj.nickName! as NSString;
                        let faceImgStr  :NSString =  ((memberObj.faceURL?.isEmpty) == nil) ? "" : memberObj.faceURL! as NSString;
                        //更新top view 代改0629
                        saveZhuBoInfo_ID = ownIdStr
                        saveZhuBoInfo_Name = nameStr
                        saveZhuBoInfo_HeaderImgUrl = faceImgStr.length>0 ? faceImgStr : saveZhuBoInfo_HeaderImgUrl;//主播头像
                        
                        if(self.saveZhuBoInfo_HeaderImgUrl.length > 0){
                            self.voiceNewTopView.topViewSetInfo(withHeaderUrlStr: self.saveZhuBoInfo_HeaderImgUrl as String)
                            //self.viewModel.masterAnchor!.seatUser!.userAvatar = self.saveZhuBoInfo_HeaderImgUrl as String;
                        }
                    }
                    print("群主  saveZhuBoInfo_HeaderImgUrl= \(saveZhuBoInfo_HeaderImgUrl)")

                     
                    
                }

            }
            
        } fail: { (code, msg) in

        }
        
    }
    //管理员
    @objc func getGuanLiYuanMember(){ //msg "AVChatRoom not support admin role" 管理员不支持
        /**
         V2TIM_GROUP_MEMBER_FILTER_ADMIN        = 0x02,  ///< 管理员
         */
        print("-________管理员________ voiceGuanLiYuanMemberListArr ")
        V2TIMManager.sharedInstance().getGroupMemberList(String(viewModel.roomInfo.roomID), filter: UInt32(0x02), nextSeq: UInt64(0)) { [weak self](code, memberList: [V2TIMGroupMemberFullInfo]?) in
            guard let `self` = self else { return }
            guard memberList?.first != nil else {
                return
            }
            if ((memberList) != nil) {
                saveVoiceGuanLiYuanMemberListArr!.removeAllObjects()
                for memberObj:V2TIMGroupMemberFullInfo in memberList! {
                    saveVoiceGuanLiYuanMemberListArr!.add(memberObj as Any)
                }
                print("-________管理员________ voiceGuanLiYuanMemberListArr  success \(String(describing: saveVoiceGuanLiYuanMemberListArr))")

            }
            
        } fail: { (code, msg) in
            print("-________管理员________ voiceGuanLiYuanMemberListArr fail")
        }
    }
    //普通成员
    @objc func getPuTongMembers() {
         /**
         V2TIM_GROUP_MEMBER_FILTER_COMMON       = 0x04,  ///< 普通成员
         */
        print("_____________getPuTongMembers___ 普通成员list")

        V2TIMManager.sharedInstance().getGroupMemberList(String(viewModel.roomInfo.roomID), filter: UInt32(0x04), nextSeq: UInt64(0)) { [weak self](code, memberList: [V2TIMGroupMemberFullInfo]?) in
            print("_____________getPuTongMembers___ saveVoicePuTongMemberListArr   code=\(code)   memberList\(String(describing: memberList)) ")
            
            guard let `self` = self else { return }
            guard memberList?.first != nil else {
                return
            }
            if ((memberList) != nil) {
                saveVoicePuTongMemberListArr!.removeAllObjects()
                 for memberObj:V2TIMGroupMemberFullInfo in memberList! {
                     saveVoicePuTongMemberListArr!.add(memberObj as Any)
                }
                print("_____________getPuTongMembers___ saveVoicePuTongMemberListArr \(String(describing: saveVoicePuTongMemberListArr))")
 
            }
            
        } fail: { (code, msg) in
            print("_____________getPuTongMembers___ fail")
        }
    }
    
    //MARK: === btnActions
    //退出按钮
    @objc func closeBtnClick() {
    
        if viewModel.roomType == VoiceRoomViewType.anchor {
            viewModel.viewResponder?.showAlert(info: (title: .exitText, message: ""), sureAction: { [weak self] in
                guard let `self` = self else { return }
                self.viewModel.exitRoom()
            }, cancelAction: {

            })
        } else {
            viewModel.exitRoom()
        }
    }
    //关注按钮
    @objc func guanZhuBtnClick() {
        print(" 关注按钮 guanZhuBtnClick")
        saveZhuBoInfo_Name =            saveZhuBoInfo_Name.length>0 ? saveZhuBoInfo_Name : "";
        saveZhuBoInfo_HeaderImgUrl =    saveZhuBoInfo_HeaderImgUrl.length>0 ? saveZhuBoInfo_HeaderImgUrl : "";
        saveZhuBoInfo_Introduce =       saveZhuBoInfo_Introduce.length>0 ? saveZhuBoInfo_Introduce : "";
        saveZhuBoInfo_ID =              saveZhuBoInfo_ID.length>0 ? saveZhuBoInfo_ID : "";
        
        let popviewUseArr: NSMutableArray = [saveZhuBoInfo_Name,saveZhuBoInfo_HeaderImgUrl,saveZhuBoInfo_Introduce,saveZhuBoInfo_ID];
        print(" 关注按钮 guanZhuBtnClick  popviewUseArr \(popviewUseArr)")

        if(self.saveThisRoomOwnerId.length > 0 ){
//            showToast(message: "关注功能，暂未开放")
//            return
            //传入主播个人信息
            guanZhuPopView = GuanZhuPopView.init(frame: CGRectZero);
            guanZhuPopView?.guanZhuPopViewDelegate = self;
            guanZhuPopView?.setGuanZhuUserInfoWithName(saveZhuBoInfo_Name as String, withHeadImg: saveZhuBoInfo_HeaderImgUrl as String , withUserID: saveZhuBoInfo_ID as String, withIntordace: saveZhuBoInfo_Introduce as String,withTherInfos: "")
//            guanZhuPopView?.show(in: self, thePopViewSubViewHeight: 0.5, with: popviewUseArr);
            guanZhuPopView?.show(in: self, thePopViewSubViewHeight: 0.5, with: []);
        }else{
            print("关注按钮 暂无数据 不出现")
        }
 
    }
    
    //MARK: _____自定义的方法 一部分 end
    //刷新中间的上麦区域数据
    let masterSeatView: TRTCVoiceRoomSeatView = {
        let view = TRTCVoiceRoomSeatView.init(state: .masterSeatEmpty)
        return view
    }()
    //观众区
    let seatCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 64, height: 90)
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 26
        layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TRTCVoiceRoomSeatCell.self, forCellWithReuseIdentifier: "TRTCVoiceRoomSeatCell")
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    lazy var tipsView: TRTCVoiceRoomTipsView = {
        let view = TRTCVoiceRoomTipsView.init(frame: .zero, viewModel: viewModel)
        return view
    }()
    
    let mainMenuView: TRTCVoiceRoomMainMenuView = {//主底部collv按钮
        let icons: [IconTuple] = [
            IconTuple(normal: UIImage(named: "room_message", in: voiceRoomBundle_UseNoTexType(), compatibleWith: nil)!, selected: UIImage(named: "room_message", in: voiceRoomBundle_UseNoTexType(), compatibleWith: nil)!, type: .message),
            IconTuple(normal: UIImage(named: "room_leave_mic", in: voiceRoomBundle_UseNoTexType(), compatibleWith: nil)!, selected: UIImage(named: "room_leave_mic", in: voiceRoomBundle_UseNoTexType(), compatibleWith: nil)!, type: .micoff),
            IconTuple(normal: UIImage(named: "room_bgmusic", in: voiceRoomBundle_UseNoTexType(), compatibleWith: nil)!, selected: UIImage(named: "room_bgmusic", in: voiceRoomBundle_UseNoTexType(), compatibleWith: nil)!, type: .bgmusic),
            IconTuple(normal: UIImage(named: "room_voice_off", in: voiceRoomBundle_UseNoTexType(), compatibleWith: nil)!, selected: UIImage(named: "room_voice_on", in: voiceRoomBundle_UseNoTexType(), compatibleWith: nil)!, type: .mute),
            IconTuple(normal: UIImage(named: "room_more", in: voiceRoomBundle_UseNoTexType(), compatibleWith: nil)!, selected: UIImage(named: "room_more", in: voiceRoomBundle_UseNoTexType(), compatibleWith: nil)!, type: .more),
        ]
        let view = TRTCVoiceRoomMainMenuView.init(icons: icons)
        return view
    }()
    
    lazy var msgInputView: TRTCVoiceRoomMsgInputView = {
        let view = TRTCVoiceRoomMsgInputView.init(frame: .zero, viewModel: viewModel)
        view.isHidden = true
        return view
    }()
    
    lazy var audiceneListView: TRTCAudienceListView = {
        let view = TRTCAudienceListView.init(viewModel: viewModel)
        view.hide()
        return view
    }()
    
    deinit {
        TRTCLog.out("reset audio settings")
    }
    
    // MARK: - ViewLifecycle
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard !isViewReady else {
            return
        }
        isViewReady = true
        constructViewHierarchy()
        activateConstraints()
        //这个位置初始背景 有值
        if(!viewModel.roomInfo.coverUrl.isEmpty){
            saveThisRoomBkImgUrl = viewModel.roomInfo.coverUrl as NSString
        }
        //bgView.kf.setImage(with: URL(string: viewModel.roomInfo.coverUrl), placeholder: nil, options: [.backgroundDecode], completionHandler: nil)
    }
    
    func constructViewHierarchy() {
        backgroundLayer.frame = bounds;
        layer.insertSublayer(backgroundLayer, at: 0)
        addSubview(bgView)
        addSubview(topView)
        //红包信息
        addSubview(topView_redEnv)
        addSubview(topView_redEnvZhuBoGoted_DaShang)
        topView_redEnv.isHidden = true
        topView_redEnvZhuBoGoted_DaShang.isHidden = true
        //
        addSubview(masterContainer)
        masterContainer.addSubview(masterSeatView)
        addSubview(seatCollection)
        addSubview(tipsView)
        addSubview(mainMenuView)
        addSubview(msgInputView)
        addSubview(audiceneListView)
    }

    func activateConstraints() {
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
//        topView.snp.makeConstraints { (make) in
//            make.top.leading.trailing.equalToSuperview()
//        }
        topView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
            
        }
        
        activateConstraintsOfMasterArea()
        activateConstraintsOfCustomSeatArea()
        activateConstraintsOfTipsView()
        activateConstraintsOfMainMenu()
        activateConstraintsOfTextView()
        activateConstraintsOfAudiceneList()
    }
    //成员list 旧 某类型
    func baseInfo(){
        //voiceGuanLiYuanMemberListArr =   viewModel.getRealMemberAudienceList() as NSArray
        
    }
    func bindInteraction() {
        seatCollection.delegate = self
        seatCollection.dataSource = self
        mainMenuView.delegate = self
        
      
    }
}

extension TRTCVoiceRoomRootView: TRTCVoiceRoomMainMenuDelegate {
    func menuView(menu: TRTCVoiceRoomMainMenuView, shouldClick item: IconTuple) -> Bool {
        if item.type == .mute && !viewModel.isOwner && viewModel.mSelfSeatIndex != -1 {
            let res = !(viewModel.anchorSeatList[viewModel.mSelfSeatIndex - 1].seatInfo?.mute ?? false)
            if !res {
                makeToast(.seatmutedText)
            }
            return res
        }
        return true
    }
    func menuView(menu: TRTCVoiceRoomMainMenuView, click item: IconTuple) -> Bool {
        switch item.type {
        case .message:
            viewModel.openMessageTextInput()
            break
        case .bgmusic:
            //音效设置
            showBgMusicAlert()
            break
        case .mute:
            //声音
            if viewModel.isOwner {
                if let user = viewModel.masterAnchor?.seatUser {
                    viewModel.userMuteMap[user.userId] = item.isSelect
                    onAnchorMute(isMute: item.isSelect)
                }
            }
            else {
                if viewModel.mSelfSeatIndex > 0, let user = viewModel.anchorSeatList[viewModel.mSelfSeatIndex-1].seatUser, !(viewModel.anchorSeatList[viewModel.mSelfSeatIndex-1].seatInfo?.mute ?? true) {
                    viewModel.userMuteMap[user.userId] = item.isSelect
                    onAnchorMute(isMute: item.isSelect)
                }
            }
            return viewModel.muteAction(isMute: item.isSelect)
        case .more:
//            viewModel.moreBtnClick()//原本的工具
            //更多--> 当前工具Collv
            
            voiceBottomToolPopView = VoiceBottomToolPopView.init(frame: CGRectZero)
            voiceBottomToolPopView?.delegate = self;
            if(viewModel.isOwner == false){
                voiceBottomToolPopView?.changeArrInfoIsGuanZhong()//非创建者
                print("非创建者")
            }else{
                print("创建者")
            }
            voiceBottomToolPopView?.show(in: self, thePopViewSubViewHeight: 0, with: [])
            break
        case .micoff:
            let seatIndex = viewModel.mSelfSeatIndex
            if seatIndex > 0 && seatIndex <= viewModel.anchorSeatList.count {
                let model = viewModel.anchorSeatList[seatIndex - 1]
                viewModel.audienceClickMicoff(model: model)
            }
            break
        }
        return false
    }
}

// MARK: - collection view delegate
extension TRTCVoiceRoomRootView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModel.anchorSeatList[indexPath.row]
        model.action?(indexPath.row + 1)
        print("collectionView didSelectItemAt 麦序cells-row 点击动作anchorSeatList观众list0开始 =\(indexPath.row)  userId = \(String(describing: model.seatUser?.userId))  ")

    }
}

extension TRTCVoiceRoomRootView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.anchorSeatList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TRTCVoiceRoomSeatCell", for: indexPath)
        let model = viewModel.anchorSeatList[indexPath.item]
        //print("collectionView 麦序cells model -item=\(indexPath.item) model=\(model) ")//实时刷新
        if let seatCell = cell as? TRTCVoiceRoomSeatCell {//观众
            seatCell.setCell(model: model, userMuteMap: viewModel.userMuteMap)
        }
        return cell
    }
}

extension TRTCVoiceRoomRootView {
    func activateConstraintsOfMasterArea() {
        masterContainer.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        masterSeatView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalTo(convertPixel(w: 80))
        }
    }
    
    func activateConstraintsOfCustomSeatArea() {
        seatCollection.snp.makeConstraints { (make) in
            make.top.equalTo(masterContainer.snp.bottom).offset(20)
            make.height.equalTo(200)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    func activateConstraintsOfTipsView() {
        tipsView.snp.makeConstraints { (make) in
            make.top.equalTo(seatCollection.snp.bottom).offset(25)
            make.bottom.equalTo(mainMenuView.snp.top).offset(-25)
            make.left.right.equalToSuperview()
        }
    }
    
    func activateConstraintsOfMainMenu() {
        mainMenuView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(52)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
            } else {
                // Fallback on earlier versions
                make.bottom.equalToSuperview().offset(-20)
            }
        }
    }
    
    func activateConstraintsOfTextView() {
        msgInputView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    func activateConstraintsOfAudiceneList() {
        audiceneListView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
    }
}

extension TRTCVoiceRoomRootView: TRTCVoiceRoomViewResponder {
 
    
    func stopPlayBGM() {
        mainMenuView.audienceType()
    }
    
    func recoveryVoiceSetting() {
        
    }
    
    func showAudioEffectView() {
        
    }
    
    func audienceListRefresh() {//成员信息更新 所以list需要重新获取
        audiceneListView.refreshList()//刷新
        topViewInfoChange()
//        getAllMembers()//获取全部成员
        getAllTypesMemberDatas()//poplist数据重新获取一遍
        
        //topView.topViewSetList(withMemberListInfo: viewModel.getRealMemberAudienceList())//top数据更新
        //topView.collectionView.reloadData()
     
//        topView.reloadAudienceList(viewModel.getRealMemberAudienceList())//更新成员相关数据UI
        
    }
    func topViewInfoChange()  {
        
        
        var isZhuBo = (viewModel.userType == .owner) ? true : false
        isZhuBo = viewModel.isOwner
        topView.topViewInfoIsZhuBoBool(isZhuBo)
        
        if( viewModel.isOwner != true){//更新顶部展示数据
//            let zhuBoVoiceRoomUserInfo :VoiceRoomUserInfo = VoiceRoomUserInfo.init()
//            zhuBoVoiceRoomUserInfo.userId = viewModel.masterAnchor.seatUser!.userId;
//            zhuBoVoiceRoomUserInfo.userName = viewModel.masterAnchor!.seatUser!.userName;
//            zhuBoVoiceRoomUserInfo.userAvatar = viewModel.masterAnchor!.seatUser!.userAvatar;
//
           
//            print("\(viewModel.masterAnchor?.seatIndex.userId) \( viewModel.masterAnchor!.seatUser!.userName)  \(viewModel.masterAnchor!.seatUser!.userAvatar) \(viewModel.masterAnchor!.seatUser!.mute)")
//
//            print("\(viewModel.masterAnchor.seatUser!.userId) \( viewModel.masterAnchor!.seatUser!.userName)  \(viewModel.masterAnchor!.seatUser!.userAvatar) \(viewModel.masterAnchor!.seatUser!.mute)")
//            topView.collectionView.isHidden = true;//观众端隐藏其他成员//不隐藏
            topView.topViewSetGongGaoInfo(withGongGaoStr: self.saveZhuBoInfo_Introduce as String) //公告信息
            //topView.topViewSetReDuNum(Int32(viewModel.roomInfo.roomID)) //ID信息
            topView.topViewSetInfo(withRoomName: viewModel.roomInfo.roomName, withHeaderUrl: self.saveZhuBoInfo_HeaderImgUrl as String) //暂定ID 暂定头像
            
            //viewModel.roomInfo.coverUrl背景
            if( !viewModel.roomInfo.coverUrl.isEmpty ){
                //bgView.kf.setImage(with: URL(string: viewModel.roomInfo.coverUrl), placeholder: nil, options: [.backgroundDecode], completionHandler: nil)
                print("刷新房间信息 1 coverUrl =观众viewModel coverUrl== \(viewModel.roomInfo.coverUrl)")
            }
        
        
            
        }else{
            topView.collectionView.isHidden = false;//主播端不隐藏其他成员
            topView.topViewSetInfo(withRoomName: viewModel.roomInfo.roomName, withHeaderUrl: self.saveZhuBoInfo_HeaderImgUrl as String) //暂定ID 暂定头像
             if( !viewModel.roomInfo.coverUrl.isEmpty ){
               // bgView.kf.setImage(with: URL(string: viewModel.roomInfo.coverUrl), placeholder: nil, options: [.backgroundDecode], completionHandler: nil) //背景
                print("刷新房间信息 2 coverUrl =主播 viewModel coverUrl== \(viewModel.roomInfo.coverUrl)")
            }

        }
//        //顶部view 基础数据VoiceRoomUserInfo和 成员数量更新

    }
    
    func onSeatMute(isMute: Bool) {
        if isMute {
            makeToast(.mutedText, duration: 0.3)
        } else {
            makeToast(.unmutedText, duration: 0.3)
            if viewModel.isSelfMute {
                return;
            }
        }
        var muteModel: IconTuple?
        for model in mainMenuView.dataSource {
            if model.type == .mute {
                muteModel = model
                break
            }
        }
        if let model = muteModel {
            model.isSelect = !isMute
        }
        mainMenuView.changeMixStatus(isMute: isMute)
    }
    
    //刷新中间的上麦区域数据
    func onAnchorMute(isMute: Bool) {
        if let master = viewModel.masterAnchor {//主播观众
            print("masterSeatView.setSeatInf。modeaaaa \(master)")
            print("masterSeatView.setSeatInf。modeaaaa  master主播观众=\(String(describing: master.seatUser?.userName)) \(String(describing: master.seatUser?.userId)) ");
            print("麦序上面的总人数信息 onAnchorMute viewModel.userMuteMap = count: \( viewModel.userMuteMap.count)  keys:\( viewModel.userMuteMap.keys) values:\( viewModel.userMuteMap.values)")
            masterSeatView.setSeatInfo(model: master, userMuteMap: viewModel.userMuteMap)
        }
        seatCollection.reloadData()
    }
    
    func showAlert(info: (title: String, message: String), sureAction: @escaping () -> Void, cancelAction: (() -> Void)?) {
        let alertController = UIAlertController.init(title: info.title, message: info.message, preferredStyle: .alert)
        let sureAlertAction = UIAlertAction.init(title: .acceptText, style: .default) { (action) in
            sureAction()
        }
        let cancelAlertAction = UIAlertAction.init(title: .refuseText, style: .cancel) { (action) in
            cancelAction?()
        }
        alertController.addAction(sureAlertAction)
        alertController.addAction(cancelAlertAction)
        rootViewController?.present(alertController, animated: false, completion: {
            
        })
    }
    
    func showActionSheet(actionTitles: [String], actions: @escaping (Int) -> Void) {
        let actionSheet = UIAlertController.init(title: .selectText, message: "", preferredStyle: .actionSheet)
        actionTitles.enumerated().forEach { (item) in
            let index = item.offset
            let title = item.element
            let action = UIAlertAction.init(title: title, style: UIAlertAction.Style.default) { (action) in
                actions(index)
                actionSheet.dismiss(animated: true, completion: nil)
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction.init(title: .cancelText, style: .cancel) { (action) in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        actionSheet.addAction(cancelAction)
        rootViewController?.present(actionSheet, animated: true, completion: nil)
    }
    
    func showMoreAlert() {
        let alert = TRTCVoiceRoomMoreAlert(viewModel: viewModel)
        addSubview(alert)
        alert.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        alert.layoutIfNeeded()
        alert.show()
    }
    func showBgMusicAlert() {
        let alert = TRTCVoiceRoomSoundEffectAlert(viewModel: viewModel)
        addSubview(alert)
        alert.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        alert.layoutIfNeeded()
        alert.show()
    }
    
    func showAudienceAlert(seat: SeatInfoModel) {
        let audienceList = viewModel.memberAudienceList.filter({$0.userInfo.userId != viewModel.roomInfo.ownerId}) //上麦相关list
        print("ROOTVIEW   showAudienceAlert  --- memberAudienceList=\(viewModel.memberAudienceList)")
        print("ROOTVIEW   showAudienceAlert  --- audienceList=\(audienceList)")
        let alert = TRTCVoiceRoomAudienceAlert(viewModel: viewModel, seatModel: seat, audienceList: audienceList)
        addSubview(alert)
        alert.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        alert.layoutIfNeeded()
        alert.show()
    }
    
    func showToast(message: String) {
        makeToast(message)
    }
    
    func showToastActivity(){//转圈加载
        makeToastActivity(.center)
    }
    
    func hiddenToastActivity() {//停止加载
        hideToastActivity()
    }
    
    func popToPrevious() {
        rootViewController?.navigationController?.popViewController(animated: true)
    }
    
    func switchView(type: VoiceRoomViewType) { //主上麦位置
        switch type {
        case .audience:
            viewModel.userType = .audience
            mainMenuView.audienceType()
        case .anchor:
            if viewModel.isOwner {
                viewModel.userType = .owner
                mainMenuView.ownerType()
            }
            else {
                viewModel.userType = .anchor
                mainMenuView.anchorType()
            }
        }
    }
    
    //刷新房间信息
    func changeRoom(info: VoiceRoomInfo) {
//        topView.reloadRoomInfo(info)
        self.viewModel.roomInfo.roomName = info.roomName;
        self.voiceNewTopView.topViewSetInfo(withRoomName:info.roomName )//0912strofNewRoomName 

        topView.reloadRoomInfo(with: info)
        if(!info.coverUrl.isEmpty){
           // bgView.kf.setImage(with: URL(string: info.coverUrl), placeholder: nil, options: [.backgroundDecode], completionHandler: nil)
            print("刷新房间信息 0 coverUrl === \(info.coverUrl)")
        }
      
    }
    
    //刷新中间的上麦区域数据
    func refreshAnchorInfos() {
        if let masterAnchor = viewModel.masterAnchor { //主播
            print("masterSeatView.setSeatInf。modeaaaa  主播masterAnchor=\(String(describing: masterAnchor.seatUser?.userName)) \(String(describing: masterAnchor.seatUser?.userId)) ");
            print(" refreshAnchorInfos viewModel.userMuteMap = count: \( viewModel.userMuteMap.count)  keys:\( viewModel.userMuteMap.keys) values:\( viewModel.userMuteMap.values)")
            masterSeatView.setSeatInfo(model: masterAnchor, userMuteMap: viewModel.userMuteMap)
        }
        topView.reloadRoomAvatar("")
        seatCollection.reloadData()
    }
    
    //弹幕信息更新
    func refreshMsgView() {
        tipsView.refreshList()
    }
    //自定义消息 需要更新相关数据
    func refreshComsView() {
        print("接收到自定义消息。更新views对应数据")
    }
    
    //上麦申请的弹出框
    func showComsAlertWithLianMaiShenQing()  {
        print("接收到自定义消息  连麦弹出框");
        
        let msgwillshow:String = viewModel.saveLianMaiShenQing.first ?? ""
        let lastObjId:String = viewModel.saveLianMaiShenQing.last ?? ""

        if(msgwillshow != "" && lastObjId != ""){
            print(" 数据 === \(String(describing: msgwillshow)) \( String(describing: lastObjId) )");
            let shagnMaiAlert =  BaseAlertManager.share().crearAlertHaveFirstCancleBtnAndGreenLastBtn(withTitle: "", message:msgwillshow, preferredStyle: .alert , fistCancelTitle: voiceRoomLocalize("取消"), lastTitle: voiceRoomLocalize("确定"))
//                self.viewModel.popOneAlert(oneAlert: shareAlert);
            
            shagnMaiAlert.show(with: rootViewController!) { index in
                if(index != AlertManagerCancelIndex){
                    
                    print("非取消  \(lastObjId) 同意他的申请");
                    //抱人上麦
                    //seatIndex
//                   let  seatIndex = 3
//                    self.viewModel.voiceRoom.pickSeat(seatIndex:seatIndex , userId: lastObjId) { (code, message) in
//                     if code == 0 {
//                         print("非取消  已经同意 \(lastObjId) 上麦");
//                     }
//                    }
                    self.viewModel.voiceRoom.acceptInvitation(identifier: lastObjId);//同意上麦请求
                    
                    
                }
            }
 
        }else{
            print("接收到自定义消息  连麦弹出框 数据有误");
        }
        
    }
    
    func reshRedEnvInfoAction(cmd: String)  {
        if( cmd == BussinessID_ZhiBo_CUSTOM_onAnchorSendRedEnvelope ){
            //主播发了红包
            if(viewModel.thisRoomAllRedEnv_ZhuBoSendInfoList.count>0){
                self.topView_redEnv.isHidden = false;//直接显示即可 点击后做抢红包动作
            }
        }else   if( cmd == BussinessID_ZhiBo_CUSTOM_onAudienceSendRedEnvelope ){
            if(viewModel.thisRoomAllRedEnv_GuanZhongSendDaSangInfoList.count>0){
                //观众发了红包打赏 做显示动画 无需点击
                self.topView_redEnvZhuBoGoted_DaShang.fillData(ofNewOneDataStr: (viewModel.thisRoomAllRedEnv_GuanZhongSendDaSangInfoList.lastObject as! String) );
            }
        }else{
            print("reshRedEnvInfoAction 其他信息")
        }
        
    }
    func nowActivityXuniPerson(indx: Int) {
        //放置虚拟数据给topview
        self.topView.xuNiPersonSave = indx;
        let showNum =  Int32(saveAllMemberListArr?.count ?? 0) + Int32(indx)
        self.topView.reloadRoomXuNiPersonIndex(showNum);
        
    }
    
    
    func msgInput(show: Bool) {
        if show {
            msgInputView.showMsgInput()
        } else {
            msgInputView.hideTextInput()
        }
    }
    
    func audiceneList(show: Bool) {
        if show {
            audiceneListView.show()
        } else {
            audiceneListView.hide()
        }
    }
    
    func showConnectTimeoutAlert() {
        let alertController = UIAlertController.init(title: .alertText, message: .timeoutText, preferredStyle: .alert)
        let sureAlertAction = UIAlertAction.init(title: .acceptText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.exitRoom()
        }
        alertController.addAction(sureAlertAction)
        rootViewController?.present(alertController, animated: true, completion: {
            
        })
    }
    
    func disApperOfRoomMainViewDeal(){//新加的方法
        //离开时所有popViewdismis
        voiceMemberListPopView?.dismissThePop()
        voiceBottomToolPopView?.dismissThePopView()
        voiceSetManagerPearsonsPopView?.dismissThePop()
        voiceOnSpeckOrOnLinePopView?.dismissThePop()
        voiceManagerShangMaiShengQingPopView?.dismissThePop()
        
        
    }
    
   
}

/// MARK: - internationalization string
fileprivate extension String {
    static let mutedText = voiceRoomLocalize("Demo.TRTC.Salon.seatmuted")
    static let unmutedText = voiceRoomLocalize("Demo.TRTC.Salon.seatunmuted")
    static let acceptText = voiceRoomLocalize("Demo.TRTC.LiveRoom.accept")
    static let refuseText = voiceRoomLocalize("Demo.TRTC.LiveRoom.refuse")
    static let selectText = voiceRoomLocalize("Demo.TRTC.Salon.pleaseselect")
    static let cancelText = voiceRoomLocalize("Demo.TRTC.LiveRoom.cancel")
    static let seatmutedText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.onseatmuted")
    static let alertText = voiceRoomLocalize("Demo.TRTC.LiveRoom.prompt")
    static let timeoutText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.connecttimeout")
    static let exitText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.exit")
    //分享用的前缀
    static let kShareStr_Open_Freeper_Des_swift = voiceRoomLocalize("在Freeper，记录美好生活，来和我一起支持Ta吧。复制下方链接，打开【Freeper】，直接观看直播！")
    static let kShareStr_Open_Freeper_PasswordDes_swift = voiceRoomLocalize("直播邀请，房间密码");
    static let fuHaoA = ":";
    static let fuHaoB = " ";

    static let cancelllText = voiceRoomLocalize("Cancel")
    static let copyText = voiceRoomLocalize("Copy")
    
    
    
    static let aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaText = ""

}



//MARK: ----Poplist

extension TRTCVoiceRoomRootView: VoiceListPopViewDelegate {
    func basePopViewTag(_ tag: Int, ofSubTableViewTouchWith indexPath: IndexPath) {
        print("。VoiceListPopViewDelegate    --------------- 成员pop");
    }
    
}



//MARK: ----bottomPop
extension TRTCVoiceRoomRootView: VoiceBottomToolPopViewDelegate {
    
    func showAleartWithIsGuanZhongTypeBuZhiChi()->Bool{
        
        let isZhuBo = (viewModel.userType == .owner) ? true : false
        if( isZhuBo ){//是创建者 不可继续接下的动作
            return false
        }else{//非创建者 提示用户 无此权限
            showToast(message: voiceRoomLocalize("非创建者，暂无此权限"))
            return true
        }
    }
    
    
    
    func bottomToolTouch(_ type: Voice_Botom_Tool_Type) {
        //隐藏pop
        voiceBottomToolPopView?.dismissThePopView()
        
        print("bottomToolTouch --- \(type)")
        switch type {
        case Voice_Botom_Tool_Type_JinYin:
            do {
                
                var newItemsArr:[IconTuple] = []
                var useItem:IconTuple?
                for touchItem:IconTuple in mainMenuView.dataSource {
                    
                    if(touchItem.type == .mute){
                        useItem = touchItem;
                        menuView(menu: mainMenuView, shouldClick: useItem!)
                        menuView(menu: mainMenuView, click: useItem!);
                        useItem?.isSelect = Bool(!touchItem.isSelect)
                    }
                    newItemsArr.append(touchItem)
                }
                mainMenuView.dataSource = newItemsArr;
                mainMenuView.collectionView.reloadData()//UI静音开关按钮更新img
 
            }
        case Voice_Botom_Tool_Type_GuanLiChengYuan:
            do {
                
                if(self.showAleartWithIsGuanZhongTypeBuZhiChi()){
                    return;
                }
                //管理成员。 已经上麦的+普通在线的= 全部
                //普通上麦者 +主播+在线的=全部
                //普通上麦者 +在线的=普通
                
                
                voiceOnSpeckOrOnLine_willShowBool = true
                voiceOnSpeckOrOnLinePopView = VoiceOnSpeckOrOnLinePopView.init(frame: CGRectZero)
                voiceOnSpeckOrOnLinePopView?.onSpeckOrOnLineDelegate = self;
                if(saveAllMemberListArr?.count == 0){//没人数 则传入错误数据 使pop保持空数据即可
                    voiceOnSpeckOrOnLinePopView?.show(in: self, thePopViewTableViewHeight: 0, with: []);
                }else{
                    
                    //0主播 1上麦组 2观众组 VoiceRoomUserInfo
                    let mainCreatUser = self.saveVoiceZhuBoMember
                    let willUseDataArr =  self.popviewUseOnLineAndOnSpkerDataArr()
                    if(willUseDataArr.count == 3){
                        return;//短时不多调用popv
                    }
                    let onSpeak =  willUseDataArr.first ?? []
                    let onLine =   willUseDataArr.last  ?? []
                    voiceOnSpeckOrOnLinePopView?.speckOr(onLinePopViewNowTwoHaveShagnMaiJinYinIdsArr: self.save_shangMaiJinYinIdsArr ?? [], andDanMuJinYanIdsArr: self.save_DanMuJinYanIdsArr ?? [])
                    
                     
                    voiceOnSpeckOrOnLinePopView?.show(in: self, thePopViewTableViewHeight: 0, with: [[mainCreatUser],onSpeak,onLine]);
                }
                voiceOnSpeckOrOnLine_willShowBool = false
                
              
            }
        case Voice_Botom_Tool_Type_QinChu:
            do {
                //清除按钮
                viewModel.clearnDanMuTextList()
                refreshMsgView()//弹幕view刷新
            }
        case Voice_Botom_Tool_Type_FenXiang:
            do {
                //分享
                
                shareBottomPopView = ShareBottomPopView.init(frame: CGRectZero);
                shareBottomPopView?.shareBottomPopViewDelegate = self;
                if(self.saveThisRoomGroupFaceUrl.length>0){
                    shareBottomPopView?.groupFaceUrlStr = self.saveThisRoomGroupFaceUrl as String;
                }
                viewModel.roomInfo.activityIdStr = save_thisActivity_Id! as String //分享弹出前处理活动ID数据
                viewModel.roomInfo.rec_passWordStr = save_thisActivity_Res_PasswordStr! as String //分享弹出前处理活动ID数据
                viewModel.roomInfo.otherDic = (save_thisActivity_otherDic! as NSDictionary) as! [AnyHashable : Any] //分享弹出前处理活动ID数据
                
                shareBottomPopView?.thisActivityIdStr = viewModel.roomInfo.activityIdStr;
                shareBottomPopView?.show(in: self, thePopViewSubViewHeight: 0.3, with: [])
                
            }
        case Voice_Botom_Tool_Type_LiaoTian:
            do {
                // 去聊天 并且显示input
            
                viewModel.openMessageTextInput()//这个是弹幕
                //未完结的聊天pop
                /**
                 chatPopView = ChatPopView.init(frame: CGRectZero);
                 chatPopView?.chatDelegate = self;
                 chatPopView?.showInSuperview(withSendSuperV: self, thePopViewSubViewHeight: 0.8, with: []);
                 */
               
                
            }
        case Voice_Botom_Tool_Type_LianXianSet://连线设置
            do {
                //连线设置 上麦？传入申请上麦的人员listArr
                if(self.showAleartWithIsGuanZhongTypeBuZhiChi()){
                    return;
                }
 
               /**
                voiceManagerShangMaiShengQingPopView = VoiceManagerShangMaiShengQingPopView.init(frame: CGRectZero)
                voiceManagerShangMaiShengQingPopView?.shangMaiSheZhiDelegate = self;
                if(saveVoicePuTongShangMaiShenQingMemberListArr?.count == 0){//普通上麦申请列表
                    voiceManagerShangMaiShengQingPopView?.show(in: self, thePopViewTableViewHeight: 0, with: []);
                }else{
                    voiceManagerShangMaiShengQingPopView?.show(in: self, thePopViewTableViewHeight: 0, with: saveVoicePuTongShangMaiShenQingMemberListArr!);
                }
                */
                
                //本来是邀请上麦的点击事件 有位置信息的哦，做成麦序顺序走向试看看
                
                var nowUseindex = 999
                var nowUseSeat = SeatInfoModel.init()
                for seatinfo:SeatInfoModel in self.viewModel.anchorSeatList {
                    if(seatinfo.seatUser == nil){
                        nowUseindex = seatinfo.seatIndex
                        nowUseSeat = seatinfo
                        break
                    }
                }
                if(nowUseindex == 999){
                    showToast(message: voiceRoomLocalize( "上麦观众已经满员，下麦后可继续设置" ))
                    return
                }
                
                self.showAudienceAlert(seat: nowUseSeat)
            
               
            }
        case Voice_Botom_Tool_Type_ZhiBoSet:  //直播设置-- 改房间名字
            do {
                let alertController = UIAlertController(title: voiceRoomLocalize("房间名字"),message: "", preferredStyle: .alert)
                alertController.addTextField { (textField: UITextField!) -> Void in
                    textField.placeholder = voiceRoomLocalize("请输入")
                    textField.text = self.viewModel.roomInfo.roomName;
                }
                
                let cancelAction = UIAlertAction(title: voiceRoomLocalize("取消"), style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: voiceRoomLocalize("确定"), style: .default, handler: {
                    action in
                    let roomNewName = alertController.textFields!.first!
                    print("房间当前新名：\(String(describing: roomNewName.text)) ")
                    self.viewModel.upDataRommName(strofNewRoomName: roomNewName.text ?? "")
                                                        
                });
                
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.rootViewController?.present(alertController, animated: true ,completion: {
                    
                    
                    print("处理新名字数据")
                });
                
            }
                         
                                             
        case Voice_Botom_Tool_Type_YinXiaoSet:
            do {
                //音效设置
                showBgMusicAlert()
            }
            
        case Voice_Botom_Tool_Type_GuanLiYuan:
            do {
                
                if(self.showAleartWithIsGuanZhongTypeBuZhiChi()){
                    return;
                }
                showToast(message: voiceRoomLocalize("敬请期待")) //管理员设置
                return;
                //管理员 传入总成员listarr
                
                voiceSetManagerPearsonsPopView = VoiceSetManagerPearsonsPopView.init(frame: CGRectZero)
                voiceSetManagerPearsonsPopView?.setManagerPopDelegate = self;
                if(saveAllMemberListArr?.count == 0){
                    voiceSetManagerPearsonsPopView?.show(in: self, thePopViewTableViewHeight: 0, with: []);
                }else{
                    voiceSetManagerPearsonsPopView?.show(in: self, thePopViewTableViewHeight: 0, with: saveAllMemberListArr!);
                }
                
            }
            
        case Voice_Botom_Tool_Type_RewardRedEnv:
            do{
                
                if(viewModel.isOwner){//主播
                    print("主播发红包 观众可以抢")
                    let redEnvVc =  SendRedEnvViewController.init()
                    redEnvVc.isGroupType = true;
                    redEnvVc.zhiBoInfoOfCustomMsgTypeStr = BussinessID_ZhiBo_CUSTOM_onAnchorSendRedEnvelope;//主播发红包
                    redEnvVc.conversationData = viewModel.roomInfo;
                    redEnvVc.selfRoomGroupIDstr = self.saveThisRoomGroupIDStr as String;
                    redEnvVc.creatUserName = self.saveThisRoomOwnerName  as String;
                    redEnvVc.creatUserID = self.saveThisRoomOwnerId  as String;
                    redEnvVc.creatUserFaceUrl = self.saveThisRoomOwnerFaceUrl as String;
                    //
                    redEnvVc.msgVc = self.rootViewController ?? UIViewController.init();
                    redEnvVc.isGroupType = true;
     
                    //红包发送数据待处理
                    redEnvVc.gotSignInfoSsendRedEnvAcBlock = {( msg )->() in
                        
                        print("红包发送数据待处理 ---- gotSignInfoSsendRedEnvAcBlock。msg =\(msg)")
                        let userInfo =   VoiceRoomUserInfo.init()
                        userInfo.userName = self.saveThisRoomOwnerName as String;
                        userInfo.userAvatar = self.saveThisRoomOwnerFaceUrl as String;
                        userInfo.userId = self.saveThisRoomOwnerId as String
                        self.viewModel.sendCustMsgWithSendRedEnvelopeSuccess(msg: msg as NSString, userInfo: userInfo);
                    };
                    redEnvVc.modalPresentationStyle = .fullScreen;
                    self.rootViewController?.present(redEnvVc, animated: true)
                }else{
                    print("观众给主播发红包打赏 不需要抢的红包")
                    
                    let redEnvVc =  SendRedEnvViewController.init()
                    redEnvVc.isGroupType = true;
                    redEnvVc.zhiBoInfoOfCustomMsgTypeStr = BussinessID_ZhiBo_CUSTOM_onAudienceSendRedEnvelope;//观众发红包
                    redEnvVc.zhiBoInfoOfCustomMsgActivityIDStr = self.viewModel.roomInfo.activityIdStr;
                    redEnvVc.conversationData = viewModel.roomInfo;
                    
                    redEnvVc.selfRoomGroupIDstr = self.saveThisRoomGroupIDStr as String;
                    
                    //观众自己的信息
                    redEnvVc.creatUserName = ""  as String;
                    redEnvVc.creatUserID = "" as String;
                    redEnvVc.creatUserFaceUrl = "" as String;
                    
                    
                    if(!TRTCVoiceRoomIMManager.shared.curUserID.isEmpty){
                        redEnvVc.creatUserID  = TRTCVoiceRoomIMManager.shared.curUserID;
                    }
                    if(!TRTCVoiceRoomIMManager.shared.curUserName.isEmpty){
                        redEnvVc.creatUserName = TRTCVoiceRoomIMManager.shared.curUserName;
                    }
                    if(!TRTCVoiceRoomIMManager.shared.curUserAvatar.isEmpty){
                        redEnvVc.creatUserFaceUrl = TRTCVoiceRoomIMManager.shared.curUserAvatar;
                    }
                    if(redEnvVc.creatUserName.isEmpty){
                        redEnvVc.creatUserName = "-";
                    }
                    //
                    redEnvVc.msgVc = self.rootViewController ?? UIViewController.init();
                    redEnvVc.isGroupType = true;
                    //红包发送数据待处理
                    print("红包发送数据  creatUserFaceUrl\(redEnvVc.creatUserFaceUrl) redEnvVc.creatUserName\(redEnvVc.creatUserName)---- gotSignInfoSsendRedEnvAcBlock。msg =\( redEnvVc.creatUserID )")
                    redEnvVc.gotSignInfoSsendRedEnvAcBlock = {( msg )->() in

                        print("红包发送数据待处理 ---- gotSignInfoSsendRedEnvAcBlock。msg =\(msg)")
                        let userInfo =   VoiceRoomUserInfo.init()

                        userInfo.userName = redEnvVc.creatUserName as String;
                        userInfo.userAvatar = redEnvVc.creatUserFaceUrl as String;
                        userInfo.userId = redEnvVc.creatUserID as String
                        
                     
                        self.viewModel.sendCustMsgWithSendRedEnvelopeSuccess(msg: msg as NSString, userInfo: userInfo);
                    };
                    redEnvVc.modalPresentationStyle = .fullScreen;
                    self.rootViewController?.present(redEnvVc, animated: true)
                }
                
                
            }
        case Voice_Botom_Tool_Type_GuanBi:
            do {
                //退出
                closeBtnClick()
                
            }
        case Voice_Botom_Tool_Type_GoToChatWithHasVoiceIng:
            do {
                //保持直播的情况下 去聊天 //直播里跳转聊天会话
                //#define Notice_Name_zhiBoGoToChatWithOnTheAir   @"Notice_Name_zhiBoGoToChatWithOnTheAir"
                
                let notice_name : String = "Notice_Name_zhiBoGoToChatWithOnTheAir";
                NotificationCenter.default.post(name: NSNotification.Name(notice_name),
                                                object: self.rootViewController);

            }
            
        default:
            do {
                print("其他类型")
            }
        }
    }
    
    //MARK: popliset datas
    /**
     var voiceSetManagerPearsonsPopView:VoiceSetManagerPearsonsPopView? //设置管理缘
     var voiceManagerShangMaiShengQingPopView:VoiceManagerShangMaiShengQingPopView? //上麦管理
     var voiceOnSpeckOrOnLinePopView:VoiceOnSpeckOrOnLinePopView? //在线 在麦
     */
    //main[12345] //sun[34] == for嵌套 标记3 4 --main
    
    func popviewUseOnLineAndOnSpkerDataArr() ->  [NSArray] {
         
        //短时间不要多次调用本方法
        if(self.voiceOnSpeckOrOnLine_willShowBool == false){
            return [[],[],[]] //3个来判断
        }
        
        var onSpekArr :NSMutableArray = []
        var onLineArr :NSMutableArray = []
        //a总的-普通的 = 上麦的 ---观众退出后也是普通成员
        //b直接从麦序里面拿 有userinfo的数据 +主播  对比 保留 --0630
//        V2TIMGroupMemberFullInfo;
         
        //全0 返回空在线 空上麦
        if(Int(saveAllMemberListArr?.count ?? 0) == 0){
            return  [onSpekArr,onLineArr]

        }else if(Int(saveAllMemberListArr?.count ?? 0) > 0){//有总 且大于普通==正常数据
//            V2TIMGroupMemberFullInfo
            
            if( !Bool(self.saveVoiceZhuBoMember?.userID.isEmpty ?? true) ){ //主播 默认空 非空则放到上麦arr
                onSpekArr.add(self.saveVoiceZhuBoMember!)
            }
   
            //在上麦的数据
            let manA = saveAllMemberListArr
            let seatArr = self.viewModel.anchorSeatList;//1-7 uid 观众数据
            var jiIndex = 0
            let seatCunt = self.viewModel.anchorSeatList.count
            print("过滤 -------seatCunt \(seatCunt) ")
            print( " 过滤 manA\(String(describing: manA)) ---- spkArr\(String(describing: seatArr)) ")
            
            for seatItem in seatArr {
                print("过滤中 -------jiIndex \(jiIndex) ")
                jiIndex +=  1
            
                
                let userIdstr = seatItem.seatUser?.userId ?? ""
                print("过滤中 -------麦序拿到的 --- \(String(describing: userIdstr)) ")
                if( (userIdstr) == ""){
                    print("过滤中 -------麦序拿到的 是空位置 userIdstr 空 ")
                   
                    if(jiIndex >= seatCunt-1){//麦序循环完
                        print("无需跳出本次 继续online的过滤")
                    }else{
                        print("跳出本次 继续下一次")
                        
                        continue
                    }
                    
                }else{
                    print("过滤中 -------麦序拿到的  userIdstr \(userIdstr) ")
                    
                    print("过滤中 -------麦序拿到的有数据的 --- \(String(describing: userIdstr)) ")
                    //seatItem.seatInfo?.userId

                    let searchPredicate = NSPredicate(format: "userID CONTAINS[c] %@", userIdstr)
                    let thisGetArray = (manA! as NSMutableArray).filtered(using: searchPredicate)
                    print( " 过滤 userIdstr\(String(describing: userIdstr)) ----thisGetArray\(thisGetArray) ")
                    if(Int(thisGetArray.count) == 0){
                    }else{
                        onSpekArr.add(thisGetArray.first!)
                    }
                    print("过滤中 -------jiIndex \(jiIndex) ")
               
                }
            
                 //———————— 循环完成后 做在线的过滤
                if(jiIndex >= seatCunt-1){
                    //非上麦的数据 ==>是 普通在线 online == 全部arr去掉上麦的
                    print( " 过滤 manA\(String(describing: manA)) ----onSpekArr\(String(describing: onSpekArr)) ")
                    if(Int(onSpekArr.count) >= Int( manA?.count ?? 0 )){//都上麦了 普通在线为0
                        onLineArr = []
                    }else{
                      
                        let manB = saveAllMemberListArr
                        let okSpk = onSpekArr
                        let guoLuOnLine = manB!.filter { item in
                            !Bool(okSpk.contains(item) )  //主arr去掉和 上麦状态数组内相同的元素
                        }
                        if( !guoLuOnLine.isEmpty){//非空 不能转 循环加
                            for onlineObj in guoLuOnLine {
                                onLineArr.add(onlineObj)
                            }
                        }
                        print( " 过滤 onLineArr ----\(onLineArr) ")
                        return  [onSpekArr,onLineArr]
                        
                    }
                }else{
                    print(" 还在speark的循环中 -------jiIndex \(jiIndex) ")
                }
             }
           
            return  [onSpekArr,onLineArr]//提前返回的问题。。
            
            
        }else{
            return  [onSpekArr,onLineArr]
        }
 
    }
    
 
    
    
    
    //V2TIMGroupMemberFullInfo
    
    /**
    //申请上麦的数据 同意和拒绝申请
    func dealPopViewUseList_ShenQingSpeakerList(aInfo: V2TIMGroupMemberFullInfo ) -> NSMutableArray {
        
        var shenQingShagnMaiList:NSMutableArray = []
        if(saveVoicePuTongShangMaiShenQingMemberListArr!.count > 0){
            saveVoicePuTongShangMaiShenQingMemberListArr?.add(aInfo)
            shenQingShagnMaiList = saveVoicePuTongShangMaiShenQingMemberListArr!
            
        }else{
            
            saveVoicePuTongShangMaiShenQingMemberListArr?.add(aInfo)
            shenQingShagnMaiList.add(aInfo)
        }
        
        return shenQingShagnMaiList
    }
    
    //普通在麦上的 上麦和下麦
    func dealPopViewUseList_PuTongOnSpeakerList(aInfo: V2TIMGroupMemberFullInfo ,isAddBool:Bool ) {
        var puTongShagnMaiArr : [V2TIMGroupMemberFullInfo] = []
        if (( saveVoicePuTongShangMaiListArr ) != nil){
            puTongShagnMaiArr = saveVoicePuTongShangMaiListArr! as! [V2TIMGroupMemberFullInfo]
        }else{
        }
     
        if(isAddBool){//增加
            //同意接口
            //上麦数据
            puTongShagnMaiArr.append(aInfo)
            saveVoicePuTongShangMaiListArr = puTongShagnMaiArr as? NSMutableArray
            
        }else{//下麦
            
            for memberObj:V2TIMGroupMemberFullInfo in puTongShagnMaiArr {
                
                if (  memberObj.userID  == aInfo.userID){
                    //下麦接口
                    //下麦数据
                    saveVoicePuTongShangMaiListArr?.remove(memberObj)
                }
                 
            }
            

        }
        

         
    }
    
    //在麦上  主+普通在麦上  
    func dealPopViewUseList_AllSpeakerList() -> NSMutableArray {
        let speckerList:NSMutableArray = []
        speckerList.add(saveVoiceZhuBoMember ?? V2TIMGroupMemberFullInfo())
        speckerList.addObjects(from: saveVoicePuTongShangMaiListArr as! [Any])

        return speckerList
         
    }
    //普通不上麦的观众
    func dealPopViewUseList_PuTongOnLineNoSpeakerList() -> NSMutableArray {
         
        var onLineList:NSMutableArray = []
        //普通总观众 - 在麦上观众 === 不在麦
//        for memberObj:V2TIMGroupMemberFullInfo  in saveVoicePuTongShangMaiListArr {
//
//        }
//        for (meb_all:V2TIMGroupMemberFullInfo) in (saveVoicePuTongMemberListArr:[V2TIMGroupMemberFullInfo])? {
//            let haveEq :Bool = false //在上麦list里面没有该成员
//
//            for meb_speak:V2TIMGroupMemberFullInfo in saveVoicePuTongShangMaiListArr:[V2TIMGroupMemberFullInfo]? {
//
//                if(meb_all.userID == meb_speak.userID){
//                    haveEq = true
//
//                }
//
//            }
//        }
////
        
        
        return onLineList
    }
 
    
     
     */
    
    
}
//MARK: popliset datas

//MARK: ===== poplist delegate

extension TRTCVoiceRoomRootView : VoiceSetManagerPearsonsPopViewDelegate{
    func setMamagerPopViewAddPersonWithInfoIDStr(_ idstr: String) {
        print("setMamagerPopViewAddPersonWithInfoIDStr 增加管理员工 \(idstr)");
//        viewModel.voiceRoom.add

    }

    func setMamagerPopViewDeletPersonWithInfoIDStr(_ idstr: String) {
        print("setMamagerPopViewDeletPersonWithInfoIDStr 删除管理员工 \(idstr)");
    }

}

extension TRTCVoiceRoomRootView : VoiceManagerShangMaiShengQingPopViewDelegate{
    func shangMaiTongYi(withIdstr idstr: String) {
        print("shangMaiTongYi 上麦 同意 \(idstr)");
        
    }
    
    func shangMaiJuJue(withIdstr idstr: String) {
        print("shangMaiJuJue 上麦 拒绝 \(idstr)");
    }
    
 
    
    
}


extension TRTCVoiceRoomRootView :VoiceTopViewDelegate{
//    #define Notice_Name_GotoImOneUserInfoVc  @"Notice_Name_GotoImOneUserInfoVc"
    func voiceTopViewDelegate(withTouchMember member: Any) {
       
        if(member is VoiceRoomUserInfo){
            let touchMember :  VoiceRoomUserInfo = member as? VoiceRoomUserInfo ?? (VoiceRoomUserInfo.init());
            print("voiceTopViewDelegate userID = \(String(describing: touchMember.userId))      nickName = \(String(describing: touchMember.userName))");
            let notice_name : String = "Notice_Name_GotoImOneUserInfoVc";
            
            NotificationCenter.default.post(name: NSNotification.Name(notice_name),
                                            object: touchMember.userId,
                                            userInfo: nil);
        }else{
            let touchMember :  V2TIMGroupMemberFullInfo = member as? V2TIMGroupMemberFullInfo ?? V2TIMGroupMemberFullInfo.init();
            print("voiceTopViewDelegate userID = \(String(describing: touchMember.userID))   role = \(touchMember.role)   nickName = \(String(describing: touchMember.nickName))");
            let notice_name : String = "Notice_Name_GotoImOneUserInfoVc";
            
            NotificationCenter.default.post(name: NSNotification.Name(notice_name),
                                            object: touchMember.userID,
                                            userInfo: nil);
        }
            
            
      
        
  
        /**
         群成员角色
        enum V2TIMGroupMemberRole {
            /// 未定义（没有获取该字段）
            V2TIM_GROUP_MEMBER_UNDEFINED = 0,
            /// 群成员
            V2TIM_GROUP_MEMBER_ROLE_MEMBER = 200,
            /// 群管理员
            V2TIM_GROUP_MEMBER_ROLE_ADMIN = 300,
            /// 群主
            V2TIM_GROUP_MEMBER_ROLE_SUPER = 400,*/
    }

}



extension TRTCVoiceRoomRootView :GuanZhuPopViewDelegate{
    func touchRightTopJuBaoBtnAction() {
        print("touchRightTopJuBaoBtnAction 举报  \(saveZhuBoInfo_ID)");
        showToast(message: voiceRoomLocalize("举报功能，暂未开放"))
    }
    
    func touchAtMe() {
        print("touchAtMe @me  \(saveZhuBoInfo_ID)");
        showToast(message: voiceRoomLocalize("@TA功能，暂未开放"))
    }
    
    func touchSiXin() {
        print("touchSiXin 私信  \(saveZhuBoInfo_ID)");
        
        showToast(message: voiceRoomLocalize("私信功能，暂未开放"))
        
    }
    
    func touchGuanZhu() {
        print("touchGuanZhu 关注   \(saveZhuBoInfo_ID)");
//        V2TIMManager.sharedInstance().addFriendListener(listener: V2TIMFriendshipListener!)
        showToast(message: voiceRoomLocalize("关注功能，暂未开放"))
     
    }
    
 
    
    
}

extension TRTCVoiceRoomRootView : ShareBottomPopViewDelegate{
    func touchShare(_ shareType: Now_Share_Type) {
        print("分享 类型--- \(shareType) 是否有密码 rec_passWordStr =\(viewModel.roomInfo.rec_passWordStr)");
        print("分享 activityIdStr --- \(viewModel.roomInfo.activityIdStr)");
        
        switch shareType {
        case Now_Share_Type_Web:
            do {

                self.xiTongFenXiangAction()
                
            }
            break;
        case Now_Share_Type_FreeperApp:
            do{
                var msg = .kShareStr_Open_Freeper_Des_swift + kShareStr_Open_Freeper_Io
                
                if(viewModel.roomInfo.activityIdStr.isEmpty){
                }else{
                    msg = .kShareStr_Open_Freeper_Des_swift + kShareStr_Open_Freeper_Io + kShareStr_ActivityId_Prex+self.viewModel.roomInfo.activityIdStr
                }
                
                if(viewModel.roomInfo.rec_passWordStr.count > 0){
                    msg = .kShareStr_Open_Freeper_Des_swift
                    + viewModel.roomInfo.roomName
                    + .kShareStr_Open_Freeper_PasswordDes_swift
                    + .fuHaoA
                    + viewModel.roomInfo.rec_passWordStr
                    + .fuHaoB
                    + kShareStr_Open_Freeper_Io
                    + kShareStr_ActivityId_Prex
                    + self.viewModel.roomInfo.activityIdStr
                }
                print("Now_Share_Type_FreeperApp --- \(msg)")
                
                let shareAlert =  BaseAlertManager.share().crearAlertHaveFirstCancleBtnAndGreenLastBtn(withTitle: "", message:msg, preferredStyle: .alert , fistCancelTitle:  .cancelllText, lastTitle: .copyText)
//                self.viewModel.popOneAlert(oneAlert: shareAlert);
               
               shareAlert.show(with: rootViewController!) { index in
                   if(index != AlertManagerCancelIndex){
                       //复制
                       UIPasteboard.general.string = msg
                       print("剪切板的文本。   \(String(describing: UIPasteboard.general.string))");
                   }
               }
                   
            }
            break;
        case Now_Share_Type_Group:
            do {
//                self.groupFenXiangAction()
               // #define Notice_Name_Chat_ActivityAction_NowIsZhiBoJoin_WillShowShareTool     @"Notice_Name_Chat_ActivityAction_NowIsZhiBoJoin_WillShowShareTool" //一个是分享用 调起界面的 通知
                let nShareZhiBoInfo : NSMutableDictionary = [:];
                
                
               /**
                vc.zhiBoShare_activityId = @"testtID";
                vc.zhiBoShare_address = @"testaddress";
                vc.zhiBoShare_shareContent = @"testContent";
                vc.category = 1;
                */
                
                nShareZhiBoInfo.setValue(self.viewModel.roomInfo.activityIdStr, forKey: "activityId");
                nShareZhiBoInfo.setValue(self.viewModel.roomInfo.roomName, forKey: "shareContent");
                nShareZhiBoInfo.setValue(self.viewModel.roomInfo.coverUrl, forKey: "activityImage");//封面位置
                //nShareZhiBoInfo.setValue(self.viewModel.roomInfo.ownerId, forKey: "address");// IMID待处理成地址数据
                nShareZhiBoInfo.setValue("", forKey: "address");
                nShareZhiBoInfo.setValue(2, forKey: "category");
                
                let notice_name : String = "Notice_Name_Chat_ActivityAction_NowIsZhiBoJoin_WillShowShareTool";
                NotificationCenter.default.post(name: NSNotification.Name(notice_name),
                                                object: self.rootViewController,
                                                userInfo: nShareZhiBoInfo as? [AnyHashable : Any]);

            }
            break;
            
        default:
            break
             
        }
    }
    
    func xiTongFenXiangAction(){
        var msg = .kShareStr_Open_Freeper_Des_swift + kShareStr_Open_Freeper_Io

        if(viewModel.roomInfo.activityIdStr.isEmpty){
        }else{
            msg = .kShareStr_Open_Freeper_Des_swift + kShareStr_Open_Freeper_Io + kShareStr_ActivityId_Prex+self.viewModel.roomInfo.activityIdStr
        }
        
        if(!viewModel.roomInfo.rec_passWordStr.isEmpty){//密码非0
            msg = .kShareStr_Open_Freeper_Des_swift
            + viewModel.roomInfo.roomName
            + .kShareStr_Open_Freeper_PasswordDes_swift
            + .fuHaoA
            + viewModel.roomInfo.rec_passWordStr
            + .fuHaoB
            + kShareStr_Open_Freeper_Io
            + kShareStr_ActivityId_Prex
            + self.viewModel.roomInfo.activityIdStr
        }
        print("Now_Share_Type_FreeperApp --- \(msg)")
       
        let image = UIImage(named: "freeperIcon")
        let activityVC = UIActivityViewController(activityItems: [msg, image ?? UIImage.init()], applicationActivities: nil)
//        // 如果是ipad, 那么需要使用pop的方式显示方向界面
//        if DeviceInfo.isiPad {
//            let popOver = activityVC.popoverPresentationController
//            popOver?.sourceView = view
//            popOver?.sourceRect = CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth, height: 340)
//        }
        
        rootViewController?.present(activityVC, animated: true)

    }
    
    func groupFenXiangAction(){
        var msg = .kShareStr_Open_Freeper_Des_swift + kShareStr_Open_Freeper_Io
        
        if(viewModel.roomInfo.activityIdStr.isEmpty){
        }else{
            msg = .kShareStr_Open_Freeper_Des_swift + kShareStr_Open_Freeper_Io + kShareStr_ActivityId_Prex+self.viewModel.roomInfo.activityIdStr
        }
        
        if(viewModel.roomInfo.rec_passWordStr.count > 0){
            msg = .kShareStr_Open_Freeper_Des_swift
            + viewModel.roomInfo.roomName
            + .kShareStr_Open_Freeper_PasswordDes_swift
            + .fuHaoA
            + viewModel.roomInfo.rec_passWordStr
            + .fuHaoB
            + kShareStr_Open_Freeper_Io
            + kShareStr_ActivityId_Prex
            + self.viewModel.roomInfo.activityIdStr
        }
        print("Now_Share_Type_FreeperApp --- \(msg)")
        print("群分享 \(msg)");
        
        
        let shareAlert =  BaseAlertManager.share().crearAlertHaveFirstCancleBtnAndGreenLastBtn(withTitle: "", message:msg, preferredStyle: .alert , fistCancelTitle:  .cancelllText, lastTitle: .copyText)
        //                self.viewModel.popOneAlert(oneAlert: shareAlert);
        
        shareAlert.show(with: rootViewController!) { index in
            if(index != AlertManagerCancelIndex){
                //复制
                UIPasteboard.general.string = msg
                print("剪切板的文本。   \(String(describing: UIPasteboard.general.string))");
           }
       }
        
        
    }
    
}


extension TRTCVoiceRoomRootView:ChatPopViewDelegate{
    func touchChatPopSubBiaoQingBtn(_ sendText: String) {
 
        //点击表情图标 暂测试发送功能
        
//        TRTCVoiceRoom.shared().sendRoomCustomMsg(cmd: <#T##String#>, message: <#T##String#>)//弹幕
        
        TRTCVoiceRoom.shared().sendRoomTextMsg(message: sendText) { code, msg in
            print("发送---- \(code) \(msg)");
            
        }
    }
}


extension TRTCVoiceRoomRootView:VoiceOnSpeckOrOnLinePopViewDelegate{
    
    func allJinYin() {
        //全体静音 或 接触全体
//        enableMuteMode(enable: true)
    }
    func allJieChuJinYin() {
        //全体静音 或 接触全体静默
//        enableMuteMode(enable: false)
    }
    
    func touchTopChangeBtnsWithVoiceOnSpeckOr(_ type: VoiceOnSpeckOrOnLineTopChooseTyp_Type) {
        //popview切换两个行
    }
    func touchPopListCellRightItemVoiceOnSpeckOr(_ rightBtnNowNeedType: VoiceOnSpeckOrOnLinePopList_Type, withNowTopChooseTyp_Type nowTopType: VoiceOnSpeckOrOnLineTopChooseTyp_Type, withUserInfo userInfoIDstr: String) {
 
        
//        VoiceOnSpeckOrOnLinePopList_Type_SpeckType,
//        VoiceOnSpeckOrOnLinePopList_Type_NotSpeckType,
//        VoiceOnSpeckOrOnLinePopList_Type_CanCallType,
//        VoiceOnSpeckOrOnLinePopList_Type_NoCallType,
        print(" rightBtnNowNeedType = \(rightBtnNowNeedType)  nowTopType=\(nowTopType) ")
        
        if(nowTopType == VoiceOnSpeckOrOnLineTopChooseType_OnSpeckType){//上麦类型列表数据
            if(rightBtnNowNeedType == VoiceOnSpeckOrOnLinePopList_Type_SpeckType){//允许上麦类型
                print("上麦类型列表数据  允许上麦类型")
                self.seatMuteJinYin(isSeatJinYinType: false, shangMaiGuanZhongIdStr: userInfoIDstr)
                
            }else if(rightBtnNowNeedType == VoiceOnSpeckOrOnLinePopList_Type_NotSpeckType){//上麦且闭麦
                print("上麦类型列表数据  上麦且闭麦")
                self.seatMuteJinYin(isSeatJinYinType: true, shangMaiGuanZhongIdStr: userInfoIDstr)

                
            }
            
        }else{//普通在线成员列表数据 --- 做的弹幕禁言和弹幕解禁动作
            
            
            if(rightBtnNowNeedType == VoiceOnSpeckOrOnLinePopList_Type_CanCallType){//普通 非禁言
                print("普通在线成员列表数据   普通 非禁言")
                self.danMoJingYan(isJingYanType: false, guanZhongIdStr: userInfoIDstr)

                
            }else if(rightBtnNowNeedType == VoiceOnSpeckOrOnLinePopList_Type_NoCallType){//普通禁言
                print("普通在线成员列表数据   普通禁言 ")
                self.danMoJingYan(isJingYanType: true, guanZhongIdStr: userInfoIDstr)
            }
        }
 
    }
//    var save_DanMuJinYanIdsArr: NSMutableArray? = []//成员中 被弹幕禁言的id
//    var save_shangMaiJinYinIdsArr: NSMutableArray? = []//成员中 上麦者 禁止推声音流的id 相当于给上麦的观众静音了
    func danMoJingYan(isJingYanType:Bool ,guanZhongIdStr:String) {
        
        let gID : String =  String( viewModel.roomInfo.roomID )
        let myID  : String = self.saveZhuBoInfo_ID as String;
        let thisChooseUserId:String = guanZhongIdStr
        var timeStr = 60*60*24*30//1个月ays
        if (!isJingYanType){
            timeStr = 5;//5秒后解除该观众的弹幕禁言
        }
        if(thisChooseUserId == myID){
            showToast(message: voiceRoomLocalize("主播无需禁言和下麦"))
            return
        }
        
        print("gID = \(gID)  myID=\(myID) timeStr=\(timeStr)");
        V2TIMManager.sharedInstance().muteGroupMember(gID, member: thisChooseUserId, muteTime: UInt32(timeStr)) {
            if (!isJingYanType){
                print("弹幕解除禁言成功")
                if((self.save_DanMuJinYanIdsArr?.contains(thisChooseUserId)) == true){
                    self.save_DanMuJinYanIdsArr?.remove(thisChooseUserId)
                }
                self.showToast(message: voiceRoomLocalize("解除禁言成功"))
            }else{
                print("弹幕禁言成功 \(thisChooseUserId)")
                if((self.save_DanMuJinYanIdsArr?.contains(thisChooseUserId)) == nil || (self.save_DanMuJinYanIdsArr?.contains(thisChooseUserId)) == false){
                    self.save_DanMuJinYanIdsArr?.add(thisChooseUserId)
                }
                self.showToast(message: voiceRoomLocalize("禁言成功"))
            }
            print( "弹幕禁言的save_DanMuJinYanIdsArr  \(String(describing: self.save_DanMuJinYanIdsArr)) ")
         
        } fail: { (code, msg) in
            print("弹幕禁言失败相关 \(code ) \(String(describing: msg))")
            let showstr = voiceRoomLocalize("禁言失败") + (msg ?? "");
            self.showToast(message: showstr)
        }
    }
    
    func seatMuteJinYin(isSeatJinYinType:Bool ,shangMaiGuanZhongIdStr:String){
        
        var  muteSeatIndex = 999;
        for obj in  self.viewModel.anchorSeatList {
            if ( obj.seatUser?.userId == shangMaiGuanZhongIdStr){
                muteSeatIndex = obj.seatIndex
            }
        }
        if(muteSeatIndex == 999){
            self.showToast(message: voiceRoomLocalize("麦序错误"))
            return
        }
        print("seatMuteJinYin 上麦者 静音 shangMaiGuanZhongIdStr = \(shangMaiGuanZhongIdStr) muteSeatIndex = \(muteSeatIndex)" )
        
        
        viewModel.voiceRoom.muteSeat(seatIndex: muteSeatIndex, isMute: isSeatJinYinType) { [weak self] (code, msg) in
            if(code == 0){
                
                if(isSeatJinYinType){
                    print("viewModel.voiceRoom.muteSea 禁语音了 save_shangMaiJinYinIdsArr 增入 shangMaiGuanZhongIdStr")
                    if((self?.save_shangMaiJinYinIdsArr?.contains(shangMaiGuanZhongIdStr)) == false){
                        self!.save_shangMaiJinYinIdsArr?.add(shangMaiGuanZhongIdStr)
                    }
                }else{
                    print("viewModel.voiceRoom.muteSea 可语音了 save_shangMaiJinYinIdsArr 去掉 shangMaiGuanZhongIdStr")
                    if((self?.save_shangMaiJinYinIdsArr?.contains(shangMaiGuanZhongIdStr)) == true){
                        self!.save_shangMaiJinYinIdsArr?.remove(shangMaiGuanZhongIdStr)
                    }
                }
                if(isSeatJinYinType){
                    self?.showToast(message: voiceRoomLocalize("静音成功"))
                }else{
                    self?.showToast(message: voiceRoomLocalize("解除静音成功"))
                }
               // self?.viewModel.onSeatMute(index: muteSeatIndex, isMute: isSeatJinYinType)
                print("seatMuteJinYin 上麦者 静音IDarr   = \(String(describing: self?.save_shangMaiJinYinIdsArr))" )

            }else{
                if(isSeatJinYinType){
                    self?.showToast(message: voiceRoomLocalize("静音失败"))
                }else{
                    self?.showToast(message: voiceRoomLocalize("解除静音失败"))
                }
                
          
            }
        }
        //（ isMuteYES：静音对应麦位；NO：解除静音对应麦位。）
        
        
    }
    
}




extension TRTCVoiceRoomRootView:VoiceTopRedEnv_WaitGotView_Delegate{
    func touchRedEnvAction() {
         print("//点击红包")
        
        if viewModel.isOwner {
            self.showToast(message: voiceRoomLocalize("房主不能抢"))
//        }else if(){//管理员不能抢
        }else{
            print("观众抢红包动作")
            if(viewModel.thisRoomAllRedEnv_ZhuBoSendInfoList.count>0){
                //抢--如果已经被抢完，删除该uno对应的obj--判断红包imgv显示隐藏
                self.redEnv_TopView_WaitToGotView.willUseGroupIdStr = self.saveThisRoomGroupIDStr as String;
                self.redEnv_TopView_WaitToGotView.fillData(ofNewOneDataStr: viewModel.thisRoomAllRedEnv_ZhuBoSendInfoList.lastObject as! String);
                self.redEnv_TopView_WaitToGotView.zhuBoSendRedEnvList_GotRedEnvSuccessUseListArr = viewModel.thisRoomAllRedEnv_ZhuBoSendInfoList;
                
                //抢完后 弹出成功失败信息
                self.redEnv_TopView_WaitToGotView.showGotRedInfoMsgBlock  = { (messageStr) in
                    self.showToast(message: messageStr);
                }
 
            }else{
                self.topView_redEnv.isHidden = true;
                self.showToast(message: voiceRoomLocalize("已经抢完"))
            }
        }
    }
    
    
    
}
