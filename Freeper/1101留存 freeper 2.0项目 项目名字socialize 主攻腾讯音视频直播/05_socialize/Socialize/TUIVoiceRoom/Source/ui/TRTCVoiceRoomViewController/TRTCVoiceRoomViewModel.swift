//
//  TRTCVoiceRoomViewModel.swift
//  TRTCVoiceRoomDemo
//
//  Created by abyyxwang on 2020/6/8.
//  Copyright © 2020 tencent. All rights reserved.
//

import Foundation

protocol TRTCVoiceRoomViewResponder: class {
    func showToast(message: String)
    func showToastActivity()
    func hiddenToastActivity()
    func popToPrevious()
    func switchView(type: VoiceRoomViewType)
    func changeRoom(info: VoiceRoomInfo)
    func refreshAnchorInfos()
    func onSeatMute(isMute: Bool)
    func onAnchorMute(isMute: Bool)
    func showAlert(info: (title: String, message: String), sureAction: @escaping () -> Void, cancelAction: (() -> Void)?)
    func showActionSheet(actionTitles:[String], actions: @escaping (Int) -> Void)
    func refreshMsgView()
    func refreshComsView()
    func msgInput(show: Bool)
    func audiceneList(show: Bool)
    func audienceListRefresh()
    func showAudioEffectView()
    func stopPlayBGM()
    func recoveryVoiceSetting()
    func showBgMusicAlert()
    func showMoreAlert()
    func showAudienceAlert(seat: SeatInfoModel)
    func showConnectTimeoutAlert()
    func disApperOfRoomMainViewDeal()
    func showComsAlertWithLianMaiShenQing()
    func reshRedEnvInfoAction(cmd: String)
    func nowActivityXuniPerson(indx:Int)

 }

@objc
class TRTCVoiceRoomViewModel: NSObject {
    
    
    //————————
    //人数 当前总人数，当前上麦人数，当前没上麦的观众人数。
    public var thisRoomAllPerson_Now:NSMutableArray  = []
    public var thisRoomAllShangMai_Now:NSMutableArray  = []
    public var thisRoomAllNoShangMai_Now:NSMutableArray  = []
    //————————
    
    
    //红包：主播发送的红包 （最新的放到头一位）,观众抢到的红包（暂时使用较少 用firstObj做赋值），观众发送的红包打赏（先后顺序放置 可循环显示完，或者最新的覆盖旧的），观众送的礼物之后做的类型
    public var thisRoomAllRedEnv_ZhuBoSendInfoList:NSMutableArray  = []
    public var thisRoomAllRedEnv_GuanZhongSendDaSangInfoList:NSMutableArray  = []
    public var thisRoomAllRedEnv_GuanZhongSendGiftsInfoList:NSMutableArray  = []
     //————————
    
    
    
//    private let dependencyContainer: TRTCVoiceRoomEnteryControl
    public let dependencyContainer: TRTCVoiceRoomEnteryControl

    private(set) var roomType: VoiceRoomViewType {
        didSet {
            roleChange(viewType: roomType)
        }
    }
    public weak var viewResponder: TRTCVoiceRoomViewResponder?
    var isOwner: Bool {
        print(" isOwnerisOwnerisOwnerisOwner  isOwner == 1=\(dependencyContainer.userId) 2=\(roomInfo.ownerId)  相同则是是创建者")
        return dependencyContainer.userId == roomInfo.ownerId
    }
    private(set) var isSelfMute: Bool = false {
        didSet {
            // Sync the muting status of the local `userMuteMap` user
            userMuteMap[dependencyContainer.userId] = isSelfMute
        }
    }
    // Prevent multiple room exits
    private var isExitingRoom: Bool = false
    
    private(set) var roomInfo: VoiceRoomInfo
    private(set) var isSeatInitSuccess: Bool = false
    private(set) var mSelfSeatIndex: Int = -1
    
    private(set) var masterAnchor: SeatInfoModel? //主播席
    private(set) var anchorSeatList: [SeatInfoModel] = [] //仅仅是上麦观众席一直有多位数据
    private(set) var memberAudienceList: [AudienceInfoModel] = [] //成员席
    private(set) var memberAudienceDic: [String: AudienceInfoModel] = [:]
    public func getRealMemberAudienceList() -> [AudienceInfoModel] {//观众？全体
        var res : [AudienceInfoModel] = []
        for audience in memberAudienceList {
            if memberAudienceDic.keys.contains(audience.userInfo.userId) {
                res.append(audience)
            }
            
        }
        print("getRealMemberAudienceList  观众？还是全体？空？ ===  \(res)")
        return res
    }
 
    public enum RoomUserType {
        case owner
        case anchor
        case audience
    }
    
    public var userType : RoomUserType = .audience
    
    //---
    public var saveLianMaiShenQing: [String] = []//当前收到了连麦申请存放数据 f=msg l=id的位置
    public var saveAllOnSpeakerList: [VoiceRoomUserInfo] = [] //已经连麦者的列表
    
    public var saveAllUserList: [VoiceRoomUserInfo] = []//全部成员列表
    public func getAllUserLest()->[VoiceRoomUserInfo]{
        var res : [VoiceRoomUserInfo] = []
        self.voiceRoom.getAllUserList { (code, msg, infos:[VoiceRoomUserInfo]) in
            res = infos;
        }
        return res 
    }
    
    public var saveAllMamagerList: [VoiceRoomUserInfo] = []//管理员列表
    public func getMamagerLest()->[VoiceRoomUserInfo]{
        var res : [VoiceRoomUserInfo] = []
        self.voiceRoom.getMamagerList { (code, msg, infos:[VoiceRoomUserInfo]) in
            res = infos;
        }
        return res
    }

    
    
    //---
    private(set) var msgEntityList: [MsgEntity] = []//消息list
    /// Seat for invitation
    private var currentInvitateSeatIndex: Int = -1
    /// Mic-on information (audience member))
    private var mInvitationSeatDic: [String: Int] = [:]
    /// Mic-on information (anchor)
    private var mTakeSeatInvitationDic: [String: String] = [:]
    /// Information of user seat placement
    private var mPickSeatInvitationDic: [String: SeatInvitation] = [:]
    
    public var userMuteMap : [String : Bool] = [:]
    
    init(container: TRTCVoiceRoomEnteryControl, roomInfo: VoiceRoomInfo, roomType: VoiceRoomViewType) {//此处的roomInfo 带有自定义的几个键值
        self.dependencyContainer = container
        self.roomType = roomType
        self.roomInfo = roomInfo
        super.init()
        voiceRoom.setDelegate(delegate: self)
        roleChange(viewType: self.roomType)
        initAnchorListData()
    }
    
    deinit {
        TRTCLog.out("deinit \(type(of: self))")
    }
    
    public var voiceRoom: TRTCVoiceRoom {
        return dependencyContainer.getVoiceRoom()
    }
    
    lazy var effectViewModel: TRTCVoiceRoomSoundEffectViewModel = {
        return TRTCVoiceRoomSoundEffectViewModel(self)
    }()
    
    func exitRoom() {
        guard !isExitingRoom else { return }
        viewResponder?.popToPrevious()
        isExitingRoom = true
        if voiceEarMonitor {
            voiceEarMonitor = false
        }
        if dependencyContainer.userId == roomInfo.ownerId && roomType == .anchor {
            dependencyContainer.destroyRoom(roomID: "\(roomInfo.roomID)", success: {
                TRTCLog.out("---deinit room success 销毁房间 ")
                ////做状态处理
                if((self.isOwner) == true){
                    self.zhuBoCloseThisRoomOfNetWorkAction()
                }

            }) { (code, message) in
                TRTCLog.out("---deinit room failed")
            }
            voiceRoom.destroyRoom { [weak self] (code, message) in
                guard let `self` = self else { return }
                self.isExitingRoom = false
                ////做状态处理
                if((self.isOwner) == true){
                    self.zhuBoCloseThisRoomOfNetWorkAction()
                }
                
                
            }
            return
        }
        voiceRoom.exitRoom { [weak self] (code, message) in
            guard let `self` = self else { return }
            self.isExitingRoom = false
        }
    }
    
  
    func zhuBoCloseThisRoomOfNetWorkAction(){
        
        print(" viewWillDisappear 语音vc -----TRTCVoiceRoomViewController----  roomInfo.activityIdStr =  \( roomInfo.activityIdStr)")
        if(roomInfo.activityIdStr == "" || roomInfo.activityIdStr.isEmpty ){//存在activityIdStr 的是创建者
            print(" -----TRTCVoiceRoomViewController----  roomInfo.activityIdStr 缺数据")

        }else{
            if((self.isOwner) == true){//是创建者
//            if(roomInfo.ownerId == viewModel.dependencyContainer.userId){
                //destroyRoom----- 销毁时调用状态接口处理关闭
                //离开时的状态更改
                //          当前状态更改方法 是在主线程里走通知
                let changeQ =  DispatchQueue.main
                changeQ.async {
                    ChangeVoiceInfoWithNoticeNetWorkTool.changeVoiceInfo(withActivityIdStr: self.roomInfo.activityIdStr, withNowState: Active_State_JieSu) { (isSuccess:Bool, dataDic:[AnyHashable : Any]) in
                        
                        if(isSuccess){
                            print(" --------- changeVoiceInfo 关闭状态已修改  --------activityIdStr-  \(self.roomInfo.activityIdStr)")
                        }else{
                            print(" --------- changeVoiceInfo 关闭状态 修改失败  --------activityIdStr-  \(self.roomInfo.activityIdStr)")
                        }
                    }
                }
              
                //destroyRoom------------------------------
            }else{
                print(" --------- changeVoiceInfo 观众退出  --------activityIdStr-  \(self.roomInfo.activityIdStr)")

            }
           
        }
        
    }
    
    public var voiceEarMonitor: Bool = false {
        willSet {
            self.voiceRoom.setVoiceEarMonitor(enable: newValue)
        }
    }
    
    public func refreshView() {
        roleChange(viewType: roomType)
    }
    
    public func openMessageTextInput() {
        viewResponder?.msgInput(show: true)
    }
    public func clearnDanMuTextList(){//清空弹幕数据
        msgEntityList = []
    }
    
    public func openAudioEffectMenu() {
        guard checkButtonPermission() else { return }
        viewResponder?.showAudioEffectView()
    }
    
    public func muteAction(isMute: Bool) -> Bool {//麦克风打开与否 ｜ 禁言
        guard checkButtonPermission() else { return false }
        if let userSeatInfo = getUserSeatInfo(userId: dependencyContainer.userId)?.seatInfo, userSeatInfo.mute {
            viewResponder?.showToast(message: .seatmutedText)
            return false
        }
        
        isSelfMute = isMute
        voiceRoom.muteLocalAudio(mute: isMute)
        if isMute {
            viewResponder?.showToast(message: .micmutedText)
        } else {
            viewResponder?.recoveryVoiceSetting()
            viewResponder?.showToast(message: .micunmutedText)
        }
        return true
    }
    
    public func moreBtnClick() {
        viewResponder?.showMoreAlert()
    }
    
    public func spechAction(isMute: Bool) {//静音
        voiceRoom.muteAllRemoteAudio(isMute: isMute)
        if isMute {
            viewResponder?.showToast(message: .mutedText)
        } else {
            viewResponder?.showToast(message: .unmutedText)
        }
    }
    
    public func clickSeat(model: SeatInfoModel) {
        guard isSeatInitSuccess else {
            viewResponder?.showToast(message: .seatuninitText)
            return
        }
        if roomType == .audience || dependencyContainer.userId != roomInfo.ownerId {//观众端点击麦序位置某item
            audienceClickItem(model: model)
        } else {
            anchorClickItem(model: model)//主播端点击麦序位置某item
        }
    }
    
    public func clickAudienceAgree(model: AudienceInfoModel) {
        
    }
    
    public func clickSeatLock(isLock: Bool, model: SeatInfoModel) {
        self.voiceRoom.closeSeat(seatIndex: model.seatIndex, isClose: isLock, callback: nil)
    }
    
    public func enterRoom(toneQuality: Int = VoiceRoomToneQuality.defaultQuality.rawValue) {//进入房间
        voiceRoom.enterRoom(roomID: roomInfo.roomID) { [weak self] (code, message) in
            guard let `self` = self else { return }
            if code == 0 {
                self.viewResponder?.showToast(message: .enterSuccessText)
                self.voiceRoom.setAuidoQuality(quality: toneQuality)
                self.getAudienceList()
            } else {
                self.viewResponder?.showToast(message: .enterFailedText)
                self.viewResponder?.popToPrevious()
            }
        }
    }
    
    @objc  func suoDuanAddressStr(yuanStr:NSString) -> NSString{//0810

        let okStr = VoiceOcTool.suoDuanAddressStr(yuanStr as String)
        return okStr as NSString

    }
    
    public func upDataRommName(strofNewRoomName:String){
        if strofNewRoomName.isEmpty{
            print("空数据 --- 不可使用")
            return
        }
        
        print("---upDataRommName-\(self.roomInfo)--self.roomInfo.activityIdStr ===== \(self.roomInfo.activityIdStr)")
        
        print("---upDataRommName  22222 -\(roomInfo)--self.roomInfo.activityIdStr ===== \(roomInfo.activityIdStr)")
        print("---upDataRommName  3333333 -\(roomInfo.roomID)-\(roomInfo.roomName) \(roomInfo.ownerId)=== \(roomInfo.activityIdStr)")
            
        let activeId_Str = roomInfo.activityIdStr;
        let  changeQ =  DispatchQueue.main
        changeQ.async {
            ChangeVoiceInfoWithNoticeNetWorkTool.changeVoiceInfo(withActivityIdStr: activeId_Str, withRoomNewName: strofNewRoomName) { (isSuccess:Bool, dataDic:[AnyHashable : Any]) in
                 print( " withRoomNewName ===isSuccess \(isSuccess),  dataDic = \(dataDic)" )
                if(isSuccess == true){
                    self.roomInfo.roomName = strofNewRoomName
                    self.viewResponder?.changeRoom(info: self.roomInfo)
                }
            }
        }
        
    }
    
    public func createRoom(toneQuality: Int = 0) {//创建房间
        voiceRoom.setAuidoQuality(quality: toneQuality)
//        roomInfo.ownerName = "dev5的测试昵称1"
//        var faceUrl = TRTCVoiceRoomIMManager.shared.curUserAvatar
//        if(faceUrl.isEmpty || faceUrl == ""){
//            faceUrl = "https://wx2.sinaimg.cn/mw2000/007WXOPDly1hfey7hbehqj31jk2gi4qp.jpg";//测试头像

        print("---upDataRommName  00000 -\(roomInfo.roomID)-\(roomInfo.roomName) \(roomInfo.ownerId)=== \(roomInfo.activityIdStr)")
        roomInfo.ownerName = (self.suoDuanAddressStr(yuanStr: ( roomInfo.ownerName as NSString  )) as NSString ) as String
        var faceUrl = TRTCVoiceRoomIMManager.shared.curUserAvatar
        if(faceUrl.isEmpty || faceUrl == ""){
            faceUrl = roomInfo.ownHeaderImgStr;
        }
        print("TRTCVoiceRoomViewModel createRoom createRoom createRoom createRoom ownerName=\(roomInfo.ownerName)  faceUrl=\(faceUrl)")
        print("TRTCVoiceRoomViewModel createRoom createRoom createRoom createRoom")
       // voiceRoom.setSelfProfile(userName: roomInfo.ownerName, avatarURL: faceUrl) { [weak self] (code, message) in
//            guard let `self` = self else { return }
//            TRTCLog.out("createRoom setSelfProfile\(code)\(message)")
            TRTCLog.out("createRoom internalCreateRoom 1111 -- \(self.roomInfo.roomID)")

            TRTCLog.out(" self.dependencyContainer == \(self.dependencyContainer)")

            self.dependencyContainer.createRoom(roomID: "\(self.roomInfo.roomID)") {  [weak self] in
                TRTCLog.out("createRoom internalCreateRoom 2a ---  www)")
                guard let `self` = self else { return }
                TRTCLog.out("createRoom internalCreateRoom 2 --- \(self.roomInfo.roomID)")
                self.internalCreateRoom()
            } failed: { [weak self] code, message in
                
                TRTCLog.out("createRoom internalCreateRoom 3a 4a --- www")
                guard let `self` = self else { return }
                if code == -1301 {
                    TRTCLog.out("createRoom internalCreateRoom 3 --- \(self.roomInfo.roomID)")
                    self.internalCreateRoom()
                } else {
                    TRTCLog.out("createRoom internalCreateRoom 4 --- \(self.roomInfo.roomID)")
                    self.viewResponder?.showToast(message: .createRoomFailedText)
                    self.viewResponder?.popToPrevious()
                }
            }
//        }//0906 去掉设置昵称 在外部已经设置
    }
    
    public func onTextMsgSend(message: String) {
        if message.count == 0 {
            return
        }
        let entity = MsgEntity.init(userId: dependencyContainer.userId, userName: .meText, content: message, invitedId: "", type: MsgEntity.TYPE_NORMAL)
        notifyMsg(entity: entity)
        voiceRoom.sendRoomTextMsg(message: message) { [weak self] (code, message) in
            guard let `self` = self else { return }
            self.viewResponder?.showToast(message: code == 0 ? .sendSuccessText :  localizeReplaceXX(.sendFailedText, message))
        }
    }
    
    public func acceptTakeSeat(identifier: String) {//同意上麦按钮
        print("acceptTakeSeat 同意上麦按钮 \( identifier ) list = \(memberAudienceDic)")
        if let audience = memberAudienceDic[identifier] {
            acceptTakeSeatInvitation(userInfo: audience.userInfo)
        }
    }
    
 
}

// MARK: - private method
extension TRTCVoiceRoomViewModel {
    
    private func internalCreateRoom() {
        let param = VoiceRoomParam.init()
        param.roomName = roomInfo.roomName
        param.needRequest = roomInfo.needRequest
        param.seatCount = roomInfo.memberCount
        param.coverUrl = roomInfo.coverUrl
        param.seatCount = 9
        param.seatInfoList = []
        
    print("internalCreateRoom 麦位信息正在初始")
        for _ in 0..<param.seatCount {
            let seatInfo = VoiceRoomSeatInfo.init()
            param.seatInfoList.append(seatInfo)
        }
        //创建房要刷新的数据changeRoom takeMainSeat takeMainSeat
        voiceRoom.createRoom(roomID: Int32(roomInfo.roomID), roomParam: param) { [weak self] (code, message) in
            guard let `self` = self else { return }
            if code == 0 {
                self.viewResponder?.changeRoom(info: self.roomInfo)
                self.takeMainSeat()
                self.getAudienceList()
            } else {
                self.viewResponder?.showToast(message: .enterFailedText)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    guard let `self` = self else { return }
                    self.viewResponder?.popToPrevious()
                }
            }
        }
    }
    
    private func takeMainSeat() {//麦序//主播0麦克风
        
        print("------ takeMainSeat ----- 麦序//主播0麦克风")
        voiceRoom.enterSeat(seatIndex: 0) { [weak self] (code, message) in
            guard let `self` = self else { return }
            if code == 0 {
                self.userMuteMap[self.roomInfo.ownerId] = false
                self.viewResponder?.showToast(message: .cupySeatSuccessText)
            } else {
                self.viewResponder?.showToast(message: .cupySeatFailedText)
            }
        }
    }
    
    private func getAudienceList() {//用户信息 传空 的到空
        
        // 附带查询的数据
        
        self.saveAllUserList =   self.getAllUserLest()
        self.saveAllMamagerList =  self.getMamagerLest()
        
        
        //
        voiceRoom.getUserInfoList(userIDList: nil) { [weak self] (code, message, infos) in
            guard let `self` = self else { return }
            if code == 0 {
                let audienceInfoModels = infos.map { (userInfo) -> AudienceInfoModel in
                    return AudienceInfoModel.init(userInfo: userInfo) { [weak self] (index) in
                        // Event of clicking to send mic-on invitation and invitation acceptance even
                        guard let `self` = self else { return }
                        if index == 0 {
                            self.sendInvitation(userInfo: userInfo) //0邀请相关 1同意 2拒绝
                        } else if(index == 1){
                            self.acceptTakeSeatInvitation(userInfo: userInfo)
                        } else if(index == 2){//拒绝{
                            print(" getAudienceList  --- 拒绝。2222222 \(userInfo)")
                            self.notAcceptTakeSeatInvitation(userInfo: userInfo)
                          
                        }
                    }
                }
                self.memberAudienceList.removeAll()
                for item in audienceInfoModels {
                    if !self.memberAudienceList.contains(where: {$0.userInfo.userId == item.userInfo.userId}) {
                        self.memberAudienceList.append(item)
                    }
                }
                audienceInfoModels.forEach { (info) in
                    self.memberAudienceDic[info.userInfo.userId] = info
                }
                self.viewResponder?.audienceListRefresh()//处理好后要去刷新view
            }
        }
        

    }
    
    func checkButtonPermission() -> Bool {
        if roomType == .audience {
            viewResponder?.showToast(message: .onlyAnchorOperationText)
            return false
        }
        return true
    }
    
    private func roleChange(viewType: VoiceRoomViewType) {
        viewResponder?.switchView(type: viewType)
    }
    
    private func initAnchorListData() {//初始麦序 或点击了centerviews麦序
        for _ in 0...7 {
        
            var model = SeatInfoModel.init { [weak self] (seatIndex) in
                guard let `self` = self else { return }
                if seatIndex > 0 && seatIndex <= self.anchorSeatList.count {
                    let model = self.anchorSeatList[seatIndex - 1]
                    print("=点击了centerviews麦序=initAnchorListData===\(model.seatIndex)")
                    self.clickSeat(model: model)
                }
            }
            model.isOwner = dependencyContainer.userId == roomInfo.ownerId
            model.isClosed = false
            model.isUsed = false
            print(" 麦序变化 anchorSeatList.a \(model)")
            anchorSeatList.append(model)
        }
    }
    
    public func audienceClickMicoff(model: SeatInfoModel) {//关掉麦克风  麦序关闭
        leaveSeat()
    }
    
    private func audienceClickItem(model: SeatInfoModel) {
        guard model.seatIndex != -1 else {
            viewResponder?.showToast(message: .notInitText)
            return
        }
        guard !model.isClosed else {
            viewResponder?.showToast(message: .seatLockedText)
            return
        }
        if model.isUsed {
            if dependencyContainer.userId == model.seatUser?.userId ?? "" {
                // The seat is used by yourself
            } else {
                // The seat is used by another user
                viewResponder?.showToast(message: "\(model.seatUser?.userName ?? .otherAnchorText)")
            }
        } else {
            // Check whether the current user is in a seat
            let currentSeatInfo = isInSeat(userId: dependencyContainer.userId)
            if currentSeatInfo.inSeat {
                // The user is already in a seat
                if currentSeatInfo.seatIndex == model.seatIndex {
                    viewResponder?.showToast(message: localizeReplaceXX(.isInxxSeatText, String(currentSeatInfo.seatIndex)))
                    return
                }
                // The user is already in a seat and needs to apply to move to another seat
                viewResponder?.showActionSheet(actionTitles: [.moveSeatText], actions: { [weak self] (index) in
                    guard let `self` = self else { return }
                    self.startMoveToSeat(targetIndex: model.seatIndex)
                })
            } else {
                // The user is not in a seat and requests to speak
                viewResponder?.showActionSheet(actionTitles: [.handsupText], actions: { [weak self] (index) in
                    guard let `self` = self else { return }
                    self.startTakeSeat(seatIndex: model.seatIndex)
                })
            }
        }
    }
    
    //
    private func anchorClickItem(model: SeatInfoModel) {
        if model.isUsed {
            let isMute = model.seatInfo?.mute ?? false
            viewResponder?.showActionSheet(actionTitles: [localizeReplaceXX(.totaxxText, (isMute ? String.unmuteOneText : String.muteOneText)), .makeAudienceText], actions: { [weak self] (index) in
                guard let `self` = self else { return }
                if index == 0 {//禁言解除禁言相关
                    // Mute 静音/解除静音某个麦位（ isMuteYES：静音对应麦位；NO：解除静音对应麦位。）
                    self.voiceRoom.muteSeat(seatIndex: model.seatIndex, isMute: !isMute, callback: nil)
                    
                } else {
                    // Mic off。下麦相关 踢人下麦（房主调用）。
                    self.voiceRoom.kickSeat(seatIndex: model.seatIndex, callback: nil)
                }
            })
            return
        }
        viewResponder?.showAudienceAlert(seat: model) //观众席点击某个item且无数据model。used 则会调起设置框
        currentInvitateSeatIndex = model.seatIndex
    }
    
    private func onAnchorSeatSelected(seatIndex: Int) {
        viewResponder?.audiceneList(show: true)
        currentInvitateSeatIndex = seatIndex
    }
    
    private func sendInvitation(userInfo: VoiceRoomUserInfo) {//房间信息 发送邀请信息
        guard currentInvitateSeatIndex != -1 else { return }
        // Invite
        let seatEntity = anchorSeatList[currentInvitateSeatIndex - 1]
        if seatEntity.isUsed {
            viewResponder?.showToast(message: .seatBusyText)
            return
        }
        let seatInvitation = SeatInvitation.init(seatIndex: currentInvitateSeatIndex, inviteUserId: userInfo.userId)
        let inviteId = voiceRoom.sendInvitation(cmd: VoiceRoomConstants.CMD_PICK_UP_SEAT,
                                                userId: seatInvitation.inviteUserId,
                                                content: "\(seatInvitation.seatIndex)") { [weak self] (code, message) in
                                                    guard let `self` = self else { return }
                                                    if code == 0 {
                                                        self.viewResponder?.showToast(message: .sendInviteSuccessText)
                                                    }
        }
        mPickSeatInvitationDic[inviteId] = seatInvitation
        viewResponder?.audiceneList(show: false)
    }
    
    private func acceptTakeSeatInvitation(userInfo: VoiceRoomUserInfo) {//同意
        // Agree
        guard let inviteID = mTakeSeatInvitationDic[userInfo.userId] else {
            viewResponder?.showToast(message: .reqExpiredText)
            return
        }
        //接受同意action id不是用户id是上麦相关id
        voiceRoom.acceptInvitation(identifier: inviteID) { [weak self] (code, message) in
            guard let `self` = self else { return }
            if code == 0 {
                // The request is accepted. Update the external chat list
                if let index = self.msgEntityList.firstIndex(where: { (msg) -> Bool in
                    return msg.invitedId == inviteID //msgtype=2成功上麦
                }) {
                    var msg = self.msgEntityList[index]
                    msg.type = MsgEntity.TYPE_AGREED
                    self.msgEntityList[index] = msg
                    self.viewResponder?.refreshMsgView()
                }
            } else {
                self.viewResponder?.showToast(message: .acceptReqFailedText)
            }
        }
    }
    
    private func notAcceptTakeSeatInvitation(userInfo: VoiceRoomUserInfo) {//拒绝
        // notAgree
        guard let inviteID = mTakeSeatInvitationDic[userInfo.userId] else { //不存在过期了
            viewResponder?.showToast(message: .reqExpiredText)
            return
        }
        //接受同意action id不是用户id是上麦相关id
        voiceRoom.rejectInvitation(identifier: inviteID) { [weak self] (code, message) in
            guard let `self` = self else { return }
            if code == 0 {
                // The request is accepted. Update the external chat list
                if let index = self.msgEntityList.firstIndex(where: { (msg) -> Bool in
                    print("notAcceptTakeSeatInvitation 拒绝上麦申请msg = \(msg)")
                    return msg.invitedId == inviteID //"拒绝"
                 }) {
                    //要做旧cell更新+新cell已经拒绝弹幕 |更新poplist数据状态为初始状态 显示0邀请
                    var msg = self.msgEntityList[index]
                    msg.type = MsgEntity.TYPE_AGREED //刷新旧的
                    self.msgEntityList[index] = msg
                    self.msgEntityList.append(MsgEntity.init(userId: msg.userId, userName: msg.userName, content: voiceRoomLocalize( "申请已被拒绝"), invitedId: msg.invitedId, type: MsgEntity.TYPE_NORMAL))
                    
                    //AudienceInfoModel ------
 
//                    if let index_up = self.memberAudienceList.firstIndex(where: { (obj) -> Bool in
//                        print("notAcceptTakeSeatInvitation 更新poplist数据 = \(obj)")
//                        return obj.userInfo.userId == userInfo.userId //"当前被拒绝的人"位置
//                    }){
//                        var upDataListObjWithJuJueInfo = self.memberAudienceList[index_up]
//                        upDataListObjWithJuJueInfo.type =  AudienceInfoModel.TYPE_IDEL //初始状态
//                        self.memberAudienceList[index_up] = upDataListObjWithJuJueInfo
//
//                    }
                    // AudienceInfoModel ------
                    changeAudience(status: AudienceInfoModel.TYPE_IDEL, user: userInfo)
                    
                    
                    self.viewResponder?.refreshMsgView()
                }
            } else {
                self.viewResponder?.showToast(message: voiceRoomLocalize("未能成功地拒绝"))
            }
        }
    }
    
    private func leaveSeat() {//关闭麦序
        voiceRoom.leaveSeat { [weak self] (code, message) in
            guard let `self` = self else { return }
            if code == 0 {
                self.viewResponder?.showToast(message: .audienceSuccessText)
            } else {
                self.viewResponder?.showToast(message: localizeReplaceXX(.audienceFailedxxText, message))
            }
        }
    }
    
    private func startTakeSeat(seatIndex: Int) {//上几号麦序 sendInvitation 发邀请给当前ownerId
        if roomType == .anchor {//不是观众了 就已经不用上麦了
            viewResponder?.showToast(message: .beingArchonText)
            return
        }
        if roomInfo.needRequest {//需要同意时
            // A request to speak is required
            guard roomInfo.ownerId != "" else {
                viewResponder?.showToast(message: .roomNotReadyText)
                return
            }
            let cmd = VoiceRoomConstants.CMD_REQUEST_TAKE_SEAT
            let targetUserId = roomInfo.ownerId
            let inviteId = voiceRoom.sendInvitation(cmd: cmd, userId: targetUserId, content: "\(seatIndex)") { [weak self] (code, message) in
                guard let `self` = self else { return }
                if code == 0 {
                    self.viewResponder?.showToast(message: .reqSentText)
                } else {
                    self.viewResponder?.showToast(message: localizeReplaceXX(.reqSendFailedxxText, message))
                }
            }
            mInvitationSeatDic[inviteId] = seatIndex
        } else {//直接上麦序
            self.viewResponder?.showToastActivity() //
            // Directly mic on when a mic-on request is not required
            voiceRoom.enterSeat(seatIndex: seatIndex) { [weak self] (code, message) in
                guard let `self` = self else { return }
                self.viewResponder?.hiddenToastActivity()
                if code == 0 {
                    self.viewResponder?.showToast(message: .handsupSuccessText)
                } else {
                    self.viewResponder?.showToast(message: .handsupFailedText)
                }
            }
        }
    }
    
    private func startMoveToSeat(targetIndex: Int) {//麦序转移
        if roomInfo.needRequest {
            guard roomInfo.ownerId != "" else {
                viewResponder?.showToast(message: .roomNotReadyText)
                return
            }
            let cmd = VoiceRoomConstants.CMD_REQUEST_TAKE_SEAT
            let targetUserId = roomInfo.ownerId
            let inviteId = voiceRoom.sendInvitation(cmd: cmd, userId: targetUserId, content: "\(targetIndex)") { [weak self] (code, message) in
                guard let `self` = self else { return }
                if code == 0 {
                    self.viewResponder?.showToast(message: .reqSentText)
                } else {
                    self.viewResponder?.showToast(message: localizeReplaceXX(.reqSendFailedxxText, message))
                }
            }
            mInvitationSeatDic[inviteId] = targetIndex
        } else {
            self.viewResponder?.showToastActivity()
            // Directly move to a different seat when a request to speak is not required
            voiceRoom.moveSeat(seatIndex: targetIndex) { [weak self](code, message) in
                guard let `self` = self else { return }
                self.viewResponder?.hiddenToastActivity()
                if code == 0 {
                    self.viewResponder?.showToast(message: .handsupSuccessText)
                } else {
                    self.viewResponder?.showToast(message: .handsupFailedText)
                }
            }
        }
    }
    
    private func recvPickSeat(identifier: String, cmd: String, content: String) {
        guard let seatIndex = Int.init(content) else { return }
        viewResponder?.showAlert(info: (title: .alertText, message: localizeReplaceXX(.invitexxSeatText, String(seatIndex))), sureAction: { [weak self] in
            guard let `self` = self else { return }
            self.voiceRoom.acceptInvitation(identifier: identifier) { [weak self] (code, message) in
                guard let `self` = self else { return }
                if code != 0 {
                    self.viewResponder?.showToast(message: .acceptReqFailedText)
                }
            }
        }, cancelAction: { [weak self] in
            guard let `self` = self else { return }
            self.voiceRoom.rejectInvitation(identifier: identifier) { [weak self] (code, message) in
                guard let `self` = self else { return }
                self.viewResponder?.showToast(message: .refuseHandsupText)
            }
        })
    }
    
    private func recvTakeSeat(identifier: String, inviter: String, content: String) {//收到观众的上麦请求
        if let index = msgEntityList.firstIndex(where: { (msg) -> Bool in
            return msg.userId == inviter && msg.type == MsgEntity.TYPE_WAIT_AGREE
        }) {
            var msg = msgEntityList[index]
            msg.type = MsgEntity.TYPE_AGREED
            msgEntityList[index] = msg
        }
        let audinece = memberAudienceDic[inviter]
        let seatIndex = (Int.init(content) ?? 0)
        let content = localizeReplaceXX(.applyxxSeatText, String(seatIndex))
        let msgEntity = MsgEntity.init(userId: inviter, userName: audinece?.userInfo.userName ?? inviter, content: content, invitedId: identifier, type: MsgEntity.TYPE_WAIT_AGREE)
        msgEntityList.append(msgEntity)
        viewResponder?.refreshMsgView()
        if var audienceModel = audinece {
            audienceModel.type = AudienceInfoModel.TYPE_WAIT_AGREE
            memberAudienceDic[audienceModel.userInfo.userId] = audienceModel
            if let index = memberAudienceList.firstIndex(where: { (model) -> Bool in
                return model.userInfo.userId == audienceModel.userInfo.userId
            }) {
                memberAudienceList[index] = audienceModel
            }
            viewResponder?.audienceListRefresh()
        }
        mTakeSeatInvitationDic[inviter] = identifier
    }
    
    private func notifyMsg(entity: MsgEntity) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            if self.msgEntityList.count > 1000 {
                self.msgEntityList.removeSubrange(0...99)
            }
            self.msgEntityList.append(entity)
            self.viewResponder?.refreshMsgView()
        }
    }
    private func notifyComsMsg(entity: MsgEntityCustoms) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }

//            self.

           
       
            
          
        }
    }
    //全部红包相关调起都在此处分拣
    private func notifyComsAllTypeRedEnvMsg(cmd: String, message: String, userInfo: VoiceRoomUserInfo) {
        print("全部红包相关调起都在此处分拣 notifyComsAllTypeRedEnvMsg | cmd = \(cmd)")
        self.viewResponder?.reshRedEnvInfoAction(cmd: cmd)
        
    }
    
    private func notifyComsMsgOfShenQingShangMai(entity: MsgEntityCustoms) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
 
            if(entity.type == MsgEntityCustoms.TYPE_GuanZhongShengQingLianMai){
                let idstr = entity.invitedId
                let namestr = entity.userName
                let mesStr = namestr + "的上麦申请"
                
                self.saveLianMaiShenQing = [mesStr,idstr];
                self.viewResponder?.showComsAlertWithLianMaiShenQing();
                
            }else{
                //其他类型
            }
        }
    }
    
    
    private func showNotifyMsg(messsage: String, userName: String) {
        let msgEntity = MsgEntity.init(userId: "", userName: userName, content: messsage, invitedId: "", type: MsgEntity.TYPE_NORMAL)
        if msgEntityList.count > 1000 {
            msgEntityList.removeSubrange(0...99)
        }
        msgEntityList.append(msgEntity)
        viewResponder?.refreshMsgView()
    }
    
    private func changeAudience(status: Int, user: VoiceRoomUserInfo) {
        print("观众进出房间时更新数据")
        //观众进出时changeAudience
        ChangeVoiceInfoWithNoticeNetWorkTool.getActivityXuniNumWithactivityId(self.roomInfo.activityIdStr) { ( succ:Bool,xuniIndex:Int) in
            print("拿到虚拟人数数据 \(succ) \(xuniIndex)")
            if succ{
                self.viewResponder?.nowActivityXuniPerson(indx: xuniIndex)
            }else{
                self.viewResponder?.nowActivityXuniPerson(indx: xuniIndex)
            }
            
        }
        //----
        guard [AudienceInfoModel.TYPE_IDEL, AudienceInfoModel.TYPE_IN_SEAT, AudienceInfoModel.TYPE_WAIT_AGREE].contains(status) else { return }
        if dependencyContainer.userId == roomInfo.ownerId && roomType == .anchor {
            let audience = memberAudienceDic[user.userId]
            if var audienceModel = audience {
                if audienceModel.type == status { return }
                audienceModel.type = status
                memberAudienceDic[audienceModel.userInfo.userId] = audienceModel
                if let index = memberAudienceList.firstIndex(where: { (model) -> Bool in
                    return model.userInfo.userId == audienceModel.userInfo.userId
                }) {
                    memberAudienceList[index] = audienceModel
                }
            }
        }
        viewResponder?.audienceListRefresh()
      
    }
    
    private func isInSeat(userId:String) -> (inSeat:Bool, seatIndex:Int) {
        if userId.isEmpty {
            return (false, -1)
        }
        if let user = masterAnchor?.seatUser, user.userId == userId {
            return (true, 0)
        }
        for item in anchorSeatList {
            if let seatInfo = item.seatInfo, seatInfo.userId == userId {
                return (true, item.seatIndex)
            }
        }
        return (false, -1)
    }
    
    private func resetSelfDatasOnSeatLeave() {
        mSelfSeatIndex = -1
        isSelfMute = false
        if voiceEarMonitor {
            voiceEarMonitor = false
        }
    }
    
    private func getUserSeatInfo(userId:String) -> SeatInfoModel?{
        if userId.isEmpty {
            return nil
        }
        if let user = masterAnchor?.seatUser, user.userId == userId {
            return masterAnchor
        }
        for item in anchorSeatList {
            if let seatInfo = item.seatInfo, seatInfo.userId == userId {
                return item
            }
        }
        return nil
    }
}

// MARK: - room delegate TRTCVoiceRoomDelegate
extension TRTCVoiceRoomViewModel: TRTCVoiceRoomDelegate {
    func onError(code: Int32, message: String) {
        if code == gERR_CONNECT_SERVICE_TIMEOUT {
            viewResponder?.showConnectTimeoutAlert()
        }
    }
    
    func onWarning(code: Int32, message: String) {
        
    }
    
    func onDebugLog(message: String) {
        
    }
    
    func onRoomDestroy(message: String) {
        if let window = UIApplication.shared.windows.first {
            window.makeToast(.closeRoomText)
        }
        viewResponder?.showToast(message: .closeRoomText)
        voiceRoom.exitRoom(callback: nil)
        viewResponder?.popToPrevious()
#if RTCube_APPSTORE
        guard isOwner else { return }
        let selector = NSSelectorFromString("showAlertUserLiveTimeOut")
        if UIViewController.responds(to: selector) {
            UIViewController.perform(selector)
        }
#endif
    }
    
    func onRoomInfoChange(roomInfo: VoiceRoomInfo) {
        print("onRoomInfoChange 房间有变化")
        if roomInfo.memberCount == -1 {
            roomInfo.memberCount = self.roomInfo.memberCount
        }
        //自定义的键值会被覆盖 所以  self.roomInfo = roomInfo重新处理键值位置赋值
        let activity_str = self.roomInfo.activityIdStr;
        let otherDic = self.roomInfo.otherDic;
        let rec_password = self.roomInfo.rec_passWordStr;
        let ownHeaderImgStr = self.roomInfo.ownHeaderImgStr;
        self.roomInfo = roomInfo
        self.roomInfo.ownHeaderImgStr = ownHeaderImgStr;
        self.roomInfo.rec_passWordStr = rec_password;
        self.roomInfo.otherDic = otherDic;
        self.roomInfo.activityIdStr = activity_str;
        viewResponder?.changeRoom(info: self.roomInfo)
        
        ChangeVoiceInfoWithNoticeNetWorkTool.getActivityXuniNumWithactivityId(self.roomInfo.activityIdStr) { ( succ:Bool,xuniIndex:Int) in
            print("拿到虚拟人数数据 \(succ) \(xuniIndex)")
            if succ{
                self.viewResponder?.nowActivityXuniPerson(indx: xuniIndex)
            }else{
                self.viewResponder?.nowActivityXuniPerson(indx: xuniIndex)
            }
            
        }
    }
    
    //收到 onSeatListChange 回调，刷新您的麦位列表
    func onSeatListChange(seatInfoList: [VoiceRoomSeatInfo]) {
        TRTCLog.out("收到 onSeatListChange 回调，刷新您的麦位列表 roomLog: onSeatListChange: \(seatInfoList)")
        isSeatInitSuccess = true
        var currentUserSeatIndex:Int = -1
        seatInfoList.enumerated().forEach { (item) in
            let seatIndex = item.offset
            let seatInfo = item.element
            var anchorSeatInfo = SeatInfoModel.init { [weak self] (seatIndex) in
                guard let `self` = self else { return }
                if seatIndex > 0 && seatIndex <= self.anchorSeatList.count {
                    let model = self.anchorSeatList[seatIndex - 1]
                    self.clickSeat(model: model)
                }
            }
            anchorSeatInfo.seatInfo = seatInfo
            if seatIndex == 0 {
                anchorSeatInfo.seatInfo?.mute = seatInfo.mute
            }
            else {
                anchorSeatInfo.seatInfo?.mute = seatInfo.mute
            }
            anchorSeatInfo.isUsed = seatInfo.status == 1
            anchorSeatInfo.isClosed = seatInfo.status == 2
            anchorSeatInfo.seatIndex = seatIndex
            anchorSeatInfo.isOwner = roomInfo.ownerId == dependencyContainer.userId
            if seatInfo.userId == dependencyContainer.userId {
                currentUserSeatIndex = seatIndex
            }
            if seatIndex == 0 {
                anchorSeatInfo.seatUser = masterAnchor?.seatUser
                masterAnchor = anchorSeatInfo
            } else {
                let listIndex = seatIndex - 1
                if anchorSeatList.count >= seatInfoList.count - 1 {//等于更换为大于等于 做替换动作
                    let anchorSeatModel = anchorSeatList[listIndex]
                    anchorSeatInfo.seatUser = anchorSeatModel.seatUser
                    if !anchorSeatInfo.isUsed {
                        anchorSeatInfo.seatUser = nil
                    }
                    anchorSeatList[listIndex] = anchorSeatInfo
                } else {
                    print(" 麦序变化 anchorSeatList.aaa \(anchorSeatInfo)")
                    anchorSeatList.append(anchorSeatInfo)
                }
            }
        }
        mSelfSeatIndex = currentUserSeatIndex
        let seatUserIds = seatInfoList.filter({ (seat) -> Bool in
            return seat.userId != ""
        }).map { (seatInfo) -> String in
            return seatInfo.userId
        }
        voiceRoom.getUserInfoList(userIDList: seatUserIds) { [weak self] (code, message, userInfos) in
            guard let `self` = self else { return }
            guard code == 0 else { return }
            var userdic: [String : VoiceRoomUserInfo] = [:]
            userInfos.forEach { (info) in
                userdic[info.userId] = info
            }
            if seatInfoList.count > 0 {
                if self.masterAnchor?.seatUser == nil, !self.userMuteMap.keys.contains(seatInfoList[0].userId) {
                    self.userMuteMap[seatInfoList[0].userId] = true
                }
                self.masterAnchor?.seatUser = userdic[seatInfoList[0].userId]
            } else {
                return
            }
            if self.anchorSeatList.count != seatInfoList.count - 1 {
                TRTCLog.out(String.seatlistWrongText)
                return
            }
            for index in 0..<self.anchorSeatList.count {
                let seatInfo = seatInfoList[index + 1]
                if self.anchorSeatList[index].seatUser == nil, let user = userdic[seatInfo.userId], !self.userMuteMap.keys.contains(user.userId) {
                    self.userMuteMap[user.userId] = true
                }
                self.anchorSeatList[index].seatUser = userdic[seatInfo.userId]
              
            }
            print("self.anchorSeatList== \(self.anchorSeatList)")
            print("self.userMuteMap== \(self.userMuteMap)")
            print("self.viewResponder== \(self.viewResponder)")
            self.viewResponder?.refreshAnchorInfos()
            self.viewResponder?.onAnchorMute(isMute: false)
        }
    }
    
    func onAnchorEnterSeat(index: Int, user: VoiceRoomUserInfo) {
        if index == 0{
            return;
        }
        showNotifyMsg(messsage: localizeReplace(.beyySeatText, "xxx", String(index)), userName: user.userName)
        if user.userId == dependencyContainer.userId {
            roomType = .anchor
            mSelfSeatIndex = index
            viewResponder?.recoveryVoiceSetting()
            let seatMute = getUserSeatInfo(userId: user.userId)?.seatInfo?.mute ?? false
            if seatMute {
                isSelfMute = true
            }
            let mute = isSelfMute || seatMute
            viewResponder?.onAnchorMute(isMute: mute)
            viewResponder?.onSeatMute(isMute: mute)
        }
        
        changeAudience(status: AudienceInfoModel.TYPE_IN_SEAT, user: user)
       
    }
    
    func onAnchorLeaveSeat(index: Int, user: VoiceRoomUserInfo) {
        if index == 0{
            return;
        }
        showNotifyMsg(messsage: localizeReplace(.audienceyySeatText, "xxx", String(index)), userName: user.userName)
        if user.userId == dependencyContainer.userId {
            let currentSeatInfo = isInSeat(userId: user.userId)
            if currentSeatInfo.inSeat {
                return
            }
            // 身份切换
            roomType = .audience
            viewResponder?.stopPlayBGM()
            resetSelfDatasOnSeatLeave()
        }
        if !memberAudienceDic.keys.contains(user.userId) {
            for model in memberAudienceList {
                if model.userInfo.userId == user.userId {
                    memberAudienceDic[user.userId] = model
                    break
                }
            }
        }
        changeAudience(status: AudienceInfoModel.TYPE_IDEL, user: user)
    }
    
    func onSeatMute(index: Int, isMute: Bool) {
        debugPrint("seat \(index) is mute : \(isMute ? "true" : "false")")
        if isMute {
            showNotifyMsg(messsage: localizeReplaceXX(.bemutedxxText, String(index)), userName: "")
        } else {
            showNotifyMsg(messsage: localizeReplaceXX(.beunmutedxxText, String(index)), userName: "")
        }
        if index > 0 && index <= anchorSeatList.count {
            anchorSeatList[index-1].seatInfo?.mute = isMute
        }
        if let userSeatInfo = getUserSeatInfo(userId: dependencyContainer.userId), userSeatInfo.seatIndex == index {
            userSeatInfo.seatInfo?.mute = isMute
            if isMute {
                isSelfMute = true
            }
            let userMute = isMute || isSelfMute
            viewResponder?.onSeatMute(isMute: userMute)
        }
        viewResponder?.onAnchorMute(isMute: isMute)
    }
    
    func onUserMicrophoneMute(userId: String, mute: Bool) {
        if dependencyContainer.userId == userId {
            isSelfMute = mute
        }
        userMuteMap[userId] = mute
        viewResponder?.onAnchorMute(isMute: mute)
    }
    
    func onSeatClose(index: Int, isClose: Bool) {
        showNotifyMsg(messsage: localizeReplace(.ownerxxSeatText, isClose ? .banSeatText : .unmuteOneText, String(index)), userName: "")
        if isClose {
            // Disable the seat, mic off, and initialize the relevant settings
            // 1. mSelfSeatIndex == index The current user is in a seat. The user’s mic is turned off and the user is removed from the seat
            // 2. mSelfSeatIndex == -1 The current user is not in a seat. Initialize the data again
            if mSelfSeatIndex == index || mSelfSeatIndex == -1{
                // Reset seat configuration data
                resetSelfDatasOnSeatLeave()
            }
        }
    }
    
    func onAudienceEnter(userInfo: VoiceRoomUserInfo) {
        showNotifyMsg(messsage: localizeReplaceXX(.inRoomText, "xxx"), userName: userInfo.userName)
        let memberEntityModel = AudienceInfoModel.init(type: 0, userInfo: userInfo) { [weak self] (index) in
            guard let `self` = self else { return }
            if index == 0 {
                self.sendInvitation(userInfo: userInfo)
            } else if(index == 1){//1同意
                self.acceptTakeSeatInvitation(userInfo: userInfo)
                self.viewResponder?.audiceneList(show: false)
            }else if(index == 2){//拒绝
                self.notAcceptTakeSeatInvitation(userInfo: userInfo)
                self.viewResponder?.audiceneList(show: false)

                
            }
        }
        if !memberAudienceDic.keys.contains(userInfo.userId) {
            memberAudienceDic[userInfo.userId] = memberEntityModel
            memberAudienceList.removeAll(where: {$0.userInfo.userId == userInfo.userId})
            memberAudienceList.append(memberEntityModel)
        }
        viewResponder?.audienceListRefresh()
        changeAudience(status: AudienceInfoModel.TYPE_IDEL, user: userInfo)
    }
    
    func onAudienceExit(userInfo: VoiceRoomUserInfo) {
        showNotifyMsg(messsage: localizeReplaceXX(.exitRoomText, "xxx"), userName: userInfo.userName)
        memberAudienceList.removeAll { (model) -> Bool in
            return model.userInfo.userId == userInfo.userId
        }
        memberAudienceDic.removeValue(forKey: userInfo.userId)
        viewResponder?.refreshAnchorInfos()
        viewResponder?.audienceListRefresh()
        changeAudience(status: AudienceInfoModel.TYPE_IDEL, user: userInfo)
    }
    
    func onUserVolumeUpdate(userVolumes: [TRTCVolumeInfo], totalVolume: Int) {
        var volumeDic: [String: UInt] = [:]
        userVolumes.forEach { (info) in
            if let userId = info.userId {
                volumeDic[userId] = info.volume
            } else {
                volumeDic[dependencyContainer.userId] = info.volume
            }
        }
        var needRefreshUI = false
        if let master = masterAnchor, let userId = master.seatUser?.userId {
            let newIsTalking = (volumeDic[userId] ?? 0) > 25
            if master.isTalking != newIsTalking {
                masterAnchor?.isTalking = newIsTalking
                needRefreshUI = true
            }
        }
        
        for (index, seat) in self.anchorSeatList.enumerated() {
            if let user = seat.seatUser {
                let isTalking = (volumeDic[user.userId] ?? 0) > 25
                if seat.isTalking != isTalking {
                    self.anchorSeatList[index].isTalking = isTalking
                    needRefreshUI = true
                }
            }
        }
        
        if needRefreshUI {
            viewResponder?.refreshAnchorInfos()
        }
    }
    
    // 接收端：监听文本消息
    func onRecvRoomTextMsg(message: String, userInfo: VoiceRoomUserInfo) {
        print( "接收到onRecvRoomTextMsg 消息  message=\(message) 发送者其他信息= \(userInfo.userId) \(userInfo.userName)" );
        let msgEntity = MsgEntity.init(userId: userInfo.userId,
                                       userName: userInfo.userName,
                                       content: message,
                                       invitedId: "",
                                       type: MsgEntity.TYPE_NORMAL)
        notifyMsg(entity: msgEntity)
    }
    
    //接收到消息
    func onRecvRoomCustomMsg(cmd: String, message: String, userInfo: VoiceRoomUserInfo) {
        print( "接收到自定义消息 cmd= cmd= cmd= cmd= cmd= cmd= cmd=\(cmd) message=\(message) 其他= \(userInfo.userId) \(userInfo.userName)" );
        if(cmd=="CMD_DANMU"){
            print( "接收到弹幕消息");
        }else  if(cmd=="CMD_LIKE"){
            print( "接收到点赞消息");
            
        }else  if(cmd=="onRequestJoinAnchor"){
            print( "接收 申请上麦");
//            let inviteId = msg
            
        }else{
            print( "接收到 \(cmd) 类型 消息");
        }
        //{"eventType":"onRequestJoinAnchor","inviteId":"235e328bf4238060c0de32c8901d72bf","timeout":10000,"userInfo":{"avatar":"https://img-blog.csdnimg.cn/20201014180756927.png","isApplying":true,"isMute":false,"nick":"10086.free","position":"0","userID":"10086"}} 10086 10086.free
        
        
//        public static let TYPE_ZhuBoKaiQiLainMai   = 0
//        public static let TYPE_GuanZhongShengQingLianMai = 1
//        public static let TYPE_AGREEDLianMai     = 2
//        public static let TYPE_oneSubLianMaiPareantJinYin = 3
//        public static let TYPE_allSubLianMaiPareantJinYin = 4
//        public static let TYPE_mangerMemberSetOrCof = 5
        if(cmd=="onStartJoinAnchor"){
           print( "房主开启连麦功能");
            let msgEntityCustoms =  MsgEntityCustoms.init(userId: userInfo.userId,
                                                          userName: userInfo.userName,
                                                          content: message,
                                                          invitedId: "",
                                                          type: MsgEntityCustoms.TYPE_ZhuBoKaiQiLainMai);
            
            notifyComsMsg(entity: msgEntityCustoms)
            
        }else if(cmd=="onRequestJoinAnchor"){
            print( "接收 申请上麦");
            //邀请id来处理数据
            let msgEntityCustoms =  MsgEntityCustoms.init(userId: userInfo.userId,
                                                          userName: userInfo.userName,
                                                          content: message,
                                                          invitedId: "",
                                                          type: MsgEntityCustoms.TYPE_GuanZhongShengQingLianMai);
            
            notifyComsMsgOfShenQingShangMai(entity: msgEntityCustoms)

        }else if(cmd=="onResponseJoinAnchor"){
            print( "房主，管理员 观众的处理连麦请求");
            let msgEntityCustoms =  MsgEntityCustoms.init(userId: userInfo.userId,
                                                          userName: userInfo.userName,
                                                          content: message,
                                                          invitedId: "",
                                                          type: MsgEntityCustoms.TYPE_AGREEDLianMai);
            
            notifyComsMsg(entity: msgEntityCustoms)
            
        }else if(cmd=="onMuteJoinAnchor" || cmd=="onMuteFalseJoinAnchor"){
            print( "房主对 某个连麦观众 静音/取消静音 ");
            let msgEntityCustoms =  MsgEntityCustoms.init(userId: userInfo.userId,
                                                          userName: userInfo.userName,
                                                          content: message,
                                                          invitedId: "",
                                                          type: MsgEntityCustoms.TYPE_oneSubLianMaiPareantJinYin);
            
            notifyComsMsg(entity: msgEntityCustoms)
            
        }else if(cmd=="onMuteAllJoinAnchor" || cmd=="onMuteFalseAllJoinAnchor"){
            print( "房主对 所有连麦观众 静音/取消静音 ");
            let msgEntityCustoms =  MsgEntityCustoms.init(userId: userInfo.userId,
                                                          userName: userInfo.userName,
                                                          content: message,
                                                          invitedId: "",
                                                          type: MsgEntityCustoms.TYPE_allSubLianMaiPareantJinYin);
            
            notifyComsMsg(entity: msgEntityCustoms)
            
        }else if(cmd=="onSettingAdmin"){
            print( "设置/取消管理员");
            let msgEntityCustoms =  MsgEntityCustoms.init(userId: userInfo.userId,
                                                          userName: userInfo.userName,
                                                          content: message,
                                                          invitedId: "",
                                                          type: MsgEntityCustoms.TYPE_mangerMemberSetOrCof);
            
            notifyComsMsg(entity: msgEntityCustoms)
            
        }else if(cmd=="GROUP"){
            print( "用于标识该消息");
            let msgEntityCustoms =  MsgEntityCustoms.init(userId: userInfo.userId,
                                                          userName: userInfo.userName,
                                                          content: message,
                                                          invitedId: "",
                                                          type: MsgEntityCustoms.TYPE_9999);
            
            notifyComsMsg(entity: msgEntityCustoms)
            
        //红包相关
        }else if(cmd==BussinessID_ZhiBo_CUSTOM_onAnchorSendRedEnvelope){
            print( "用于红包消息 主播发了红包");
            thisRoomAllRedEnv_ZhuBoSendInfoList .add(message);
            notifyComsAllTypeRedEnvMsg(cmd: cmd, message: message, userInfo: userInfo);
        }else if(cmd==BussinessID_ZhiBo_CUSTOM_onAudienceSendRedEnvelope){
            print( "用于红包消息 观众发了红包 / 打赏 ");
            thisRoomAllRedEnv_GuanZhongSendDaSangInfoList .add(message);
            notifyComsAllTypeRedEnvMsg(cmd: cmd, message: message, userInfo: userInfo);
        }else if(cmd==BussinessID_ZhiBo_CUSTOM_onSendGifts){
            print( "用于 观众 发了礼物消息  ");
            thisRoomAllRedEnv_GuanZhongSendGiftsInfoList .add(message);
            notifyComsAllTypeRedEnvMsg(cmd: cmd, message: message, userInfo: userInfo);
            
        }else{
            print( " 未处理的自定义类型 cmd   == \(cmd)");
        }
     
   
        
     
    }
    
    // 听众端视角
    // 1.听众收到请求
    func onReceiveNewInvitation(identifier: String, inviter: String, cmd: String, content: String) {
        TRTCLog.out("receive message: \(cmd) : \(content)")
        if roomType == .audience {
            if cmd == VoiceRoomConstants.CMD_PICK_UP_SEAT {
                recvPickSeat(identifier: identifier, cmd: cmd, content: content)
            }
        }
        if roomType == .anchor && roomInfo.ownerId == dependencyContainer.userId {
            if cmd == VoiceRoomConstants.CMD_REQUEST_TAKE_SEAT {
                recvTakeSeat(identifier: identifier, inviter: inviter, content: content)
            }
        }
    }
    //房主端视角
    //收到邀请的同意请求 观众正式上麦 更新UI
    func onInviteeAccepted(identifier: String, invitee: String) {
        
        let seatIndexInfo = mInvitationSeatDic.removeValue(forKey: identifier)
        if let seatIndex = seatIndexInfo {
            guard let seatModel = anchorSeatList.filter({ (seatInfo) -> Bool in
                return seatInfo.seatIndex == seatIndex
            }).first else {
                return
            }
            if !seatModel.isUsed {
                self.viewResponder?.showToastActivity()
                if roomType == .audience {
                    voiceRoom.enterSeat(seatIndex: seatIndex) { [weak self] (code, message) in
                        guard let `self` = self else { return }
                        self.viewResponder?.hiddenToastActivity()
                        if code == 0 {
                            self.viewResponder?.showToast(message: .handsupSuccessText)
                        } else {
                            self.viewResponder?.showToast(message: .handsupFailedText)
                        }
                    }
                } else if roomType == .anchor  {
                    voiceRoom.moveSeat(seatIndex: seatIndex) { [weak self] (code, message) in
                        guard let `self` = self else { return }
                        self.viewResponder?.hiddenToastActivity()
                        if code == 0 {
                            self.viewResponder?.showToast(message: .handsupSuccessText)
                        } else {
                            self.viewResponder?.showToast(message: .handsupFailedText)
                        }
                    }
                }
            }
        }
        if roomType == .anchor && roomInfo.ownerId == dependencyContainer.userId{
            guard let seatInvitation = mPickSeatInvitationDic.removeValue(forKey: identifier) else {
                return
            }
            guard let seatModel = anchorSeatList.filter({ (model) -> Bool in
                return model.seatIndex == seatInvitation.seatIndex
            }).first else {
                return
            }
            if !seatModel.isUsed {
                voiceRoom.pickSeat(seatIndex: seatInvitation.seatIndex, userId: seatInvitation.inviteUserId) { [weak self] (code, message) in
                    guard let `self` = self else { return }
                    if code == 0 {
                        guard let audience = self.memberAudienceDic[seatInvitation.inviteUserId] else { return }
                        self.viewResponder?.showToast(message: localizeReplaceXX(.hugHandsupSuccessText, audience.userInfo.userName))
                    }
                }
            }
        }
    }
    
    func onInviteeRejected(identifier: String, invitee: String) {
        print("  onInviteeRejected  被拒绝 mPickSeatInvitationDic=\(mPickSeatInvitationDic) identifier=\(identifier) invitee=\(invitee)")
        //空或者没有该ID则主动弹出
      

        if let seatInvitation = mPickSeatInvitationDic.removeValue(forKey: identifier) {
            guard let audience = memberAudienceDic[seatInvitation.inviteUserId] else {
                return
            }
            viewResponder?.showToast(message: localizeReplaceXX(.refuseBespeakerText, audience.userInfo.userName))
            changeAudience(status: AudienceInfoModel.TYPE_IDEL, user: audience.userInfo)
     
            return
        }
        if mPickSeatInvitationDic.count == 0  {
            viewResponder?.showToast(message: .isJuJueText)
            return
        }
        if !mPickSeatInvitationDic.keys.contains(identifier){
            viewResponder?.showToast(message: .isJuJueText)
            return
        }
        
    }
    
    func onInvitationCancelled(identifier: String, invitee: String) {
        
    }
}



// MARK: ---0922 相关方法
extension TRTCVoiceRoomViewModel {
    func  initNoticeOfVoiveRoomDataChangeAndOtherInfo() {
    
//        self.thisRoomAllPerson_Now =
//        self.thisRoomAllShangMai_Now
//        self.thisRoomAllNoShangMai_Now
      
    }
    
    
}
//发红包等信息处理和发送
extension TRTCVoiceRoomViewModel {
    func sendCustMsgWithSendRedEnvelopeSuccess(msg:NSString,userInfo:VoiceRoomUserInfo) ->  (){
        
        /**
         
         let msgEntityCustoms =  MsgEntityCustoms.init(userId: self.dependencyContainer.userId,
                                                       userName: userInfo.userName,
                                                       content: msg as String,
                                                       invitedId: "",
                                                       type: MsgEntityCustoms.TYPE_9999);
         notifyComsMsg(entity: msgEntityCustoms)
         
         发红包等信息处理和发送 {
           "eventType" : "onAnchorSendRedEnvelope",
           "customInfo" : "{\n  \"id\" : \"20230923095821801133639\",\n  \"title\" : \"哈哈哈6\",\n  \"unit\" : \"F-U\"\n}",
           "userInfo" : {
             "avatar" : "",
             "nick" : "aaaaaaaaaa.free",
             "userID" : "ueVPpA2rSrKnT"
           },
           "timeout" : 10000
         }  <VoiceRoomUserInfo: 0x2821bcae0>
         
         */
        
        let getMsgDic = (self.stringValueDic(msg as String) ?? [:]) as [String : Any]
        var sendUserStr = ""
        var centerStr = ""
        var moneyStr = ""
        var moneyUnitStr = ""
        for (key,value) in getMsgDic{
            if(key == "customInfo"){
                let value_customInfoDic = (self.stringValueDic(value as! String) ?? [:]) as [String : Any]
                for (key_customInfoSub,value_customInfoSub) in value_customInfoDic{
                    if(key_customInfoSub == "unit"){
                        moneyUnitStr = value_customInfoSub as! String
                    }
                    if(key_customInfoSub == "amount"){
                        //科学计数 除10 18
                        let longDecimalNum_Amount = NSDecimalNumber(string: value_customInfoSub as? String)
                        let pwInfo = NSDecimalNumber(string: "10").raising(toPower: 18)
                        let showDecimalNum:NSDecimalNumber = longDecimalNum_Amount.dividing(by: pwInfo)
                        moneyStr = showDecimalNum.stringValue
                    }
                }
            }
            if(key == "userInfo"){
                 //value userInfo Dic
                
                var value_userInfoDic = [String : Any]();
                if ((value as AnyObject).isKind(of: NSDictionary.classForCoder()) ){
                    value_userInfoDic = value as! [String : Any]
                }else if((value as AnyObject).isKind(of: NSString.classForCoder()) ){
                    value_userInfoDic = (self.stringValueDic(value as! String) ?? [:]) as [String : Any]
                }else{
                    break;
                }
        
                for (key_userInfoSub,value_userInfoSub) in value_userInfoDic{
                    if(key_userInfoSub == "nick"){
                        sendUserStr = value_userInfoSub as! String
                    }
                }
            }
        }
        
    
        if msg.contains(BussinessID_ZhiBo_CUSTOM_onAnchorSendRedEnvelope){
            print("/发红包等信息处理和发送sendCustMsgWithon AnchorSendRedEnvelope \(msg) ");
            sendUserStr = "主播"
            centerStr = "发送了红包"
           
            self.sendAllCustMsg(MsgBussinessIDTypeStr: BussinessID_ZhiBo_CUSTOM_onAnchorSendRedEnvelope, msgInfoStr: msg, userInfo: userInfo)
        }else if msg.contains(BussinessID_ZhiBo_CUSTOM_onAudienceSendRedEnvelope){
            print("/发红包等信息处理和发送sendCustMsgWithon AudienceSendRedEnvelope \(msg) ");
            sendUserStr = sendUserStr.isEmpty ? "观众" : sendUserStr;
            centerStr = "打赏了主播"
            self.sendAllCustMsg(MsgBussinessIDTypeStr: BussinessID_ZhiBo_CUSTOM_onAudienceSendRedEnvelope, msgInfoStr: msg, userInfo: userInfo)
        }else if msg.contains(BussinessID_ZhiBo_CUSTOM_onSendGifts){
            sendUserStr = sendUserStr.isEmpty ? "观众" : sendUserStr;
            centerStr = "发送了礼物"
            self.sendAllCustMsg(MsgBussinessIDTypeStr: BussinessID_ZhiBo_CUSTOM_onSendGifts, msgInfoStr: msg, userInfo: userInfo)
        }
        
        //----发送自定义信息后 增入发送群信息用于弹幕展示
        let willShowDanMuTextMsgStr = sendUserStr + " " + centerStr + " " + moneyStr + moneyUnitStr
        voiceRoom.sendRoomTextMsg(message: willShowDanMuTextMsgStr);
        
    }
    
    func sendAllCustMsg(MsgBussinessIDTypeStr :String,msgInfoStr:NSString,userInfo:VoiceRoomUserInfo) ->  (){
        print("/发红包等信息处理和发送 msgtype \(MsgBussinessIDTypeStr) msginfo \(msgInfoStr) ");
        TRTCVoiceRoom.shared().sendRoomCustomMsg(cmd: MsgBussinessIDTypeStr , message: msgInfoStr as String);
        //viewResponder?.showToast(message: .fasongDaSange)
        
    }
    
    func stringValueDic(_ str:String) -> [String :Any]?{
        if str.isEmpty{
            return [:]
        }
        let data = str.data(using: String.Encoding.utf8)
        if  let dict = try?JSONSerialization.jsonObject(with: data!,options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any]{
            return dict
        }else{
            return [:]
        }
    }
    
    
}




// MARK: - internationalization string
fileprivate extension String {
    static let seatmutedText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.onseatmuted")
    static let micmutedText = voiceRoomLocalize("Demo.TRTC.Salon.micmuted")
    static let micunmutedText = voiceRoomLocalize("Demo.TRTC.Salon.micunmuted")
    static let mutedText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.ismuted")
    static let unmutedText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.isunmuted")
    static let seatuninitText = voiceRoomLocalize("Demo.TRTC.Salon.seatlistnotinit")
    static let enterSuccessText = voiceRoomLocalize("Demo.TRTC.Salon.enterroomsuccess")
    static let enterFailedText = voiceRoomLocalize("Demo.TRTC.Salon.enterroomfailed")
    static let createRoomFailedText = voiceRoomLocalize("Demo.TRTC.LiveRoom.createroomfailed")
    static let meText = voiceRoomLocalize("Demo.TRTC.LiveRoom.me")
    static let sendSuccessText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.sendsuccess")
    static let sendFailedText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.sendfailedxx")
    static let cupySeatSuccessText = voiceRoomLocalize("Demo.TRTC.Salon.hostoccupyseatsuccess")
    static let cupySeatFailedText = voiceRoomLocalize("Demo.TRTC.Salon.hostoccupyseatfailed")
    static let onlyAnchorOperationText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.onlyanchorcanoperation")
    static let seatLockedText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.seatislockedandcanthandup")
    static let audienceText = voiceRoomLocalize("Demo.TRTC.Salon.audience")
    static let otherAnchorText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.otheranchor")
    static let isInxxSeatText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.isinxxseat")
    static let notInitText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.seatisnotinittocanthandsup")
    static let handsupText = voiceRoomLocalize("Demo.TRTC.Salon.handsup")
    static let moveSeatText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.requestmoveseat")
    static let totaxxText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.totaxx")
    static let unmuteOneText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.unmuteone")
    static let muteOneText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.muteone")
    static let makeAudienceText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.makeoneaudience")
    static let inviteHandsupText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.invitehandsup")
    static let banSeatText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.banseat")
    static let liftbanSeatText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.liftbanseat")
    static let seatBusyText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.seatisbusy")
    static let sendInviteSuccessText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.sendinvitesuccess")
    static let reqExpiredText = voiceRoomLocalize("Demo.TRTC.Salon.reqisexpired")
    static let acceptReqFailedText = voiceRoomLocalize("Demo.TRTC.Salon.acceptreqfailed")
    static let audienceSuccessText = voiceRoomLocalize("Demo.TRTC.Salon.audiencesuccess")
    static let audienceFailedxxText = voiceRoomLocalize("Demo.TRTC.Salon.audiencefailedxx")
    static let beingArchonText = voiceRoomLocalize("Demo.TRTC.Salon.isbeingarchon")
    static let roomNotReadyText = voiceRoomLocalize("Demo.TRTC.Salon.roomnotready")
    static let reqSentText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.reqsentandwaitforarchondeal")
    static let reqSendFailedxxText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.reqsendfailedxx")
    static let handsupSuccessText = voiceRoomLocalize("Demo.TRTC.Salon.successbecomespaker")
    static let handsupFailedText = voiceRoomLocalize("Demo.TRTC.Salon.failedbecomespaker")
    
    static let alertText = voiceRoomLocalize("Demo.TRTC.LiveRoom.prompt")
    static let invitexxSeatText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.anchorinvitexxseat")
    static let refuseHandsupText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.refusehandsupreq")
    static let applyxxSeatText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.applyforxxseat")
    static let closeRoomText = voiceRoomLocalize("Demo.TRTC.Salon.archonclosedroom")
    static let seatlistWrongText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.seatlistwentwrong")
    static let beyySeatText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.xxbeyyseat")
    static let audienceyySeatText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.xxaudienceyyseat")
    static let bemutedxxText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.xxisbemuted")
    static let beunmutedxxText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.xxisbeunmuted")
    static let ownerxxSeatText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.ownerxxyyseat")
    static let banText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.ban")
    static let inRoomText = voiceRoomLocalize("Demo.TRTC.LiveRoom.xxinroom")
    static let exitRoomText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.xxexitroom")
    static let hugHandsupSuccessText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.hugxxhandsupsuccess")
    static let refuseBespeakerText = voiceRoomLocalize("Demo.TRTC.VoiceRoom.refusebespeaker")
    static let isJuJueText = voiceRoomLocalize("申请已被拒绝")
    static let fasongDaSange = voiceRoomLocalize("已发送打赏")
}
