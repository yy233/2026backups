//
//  TCAudienceToolbarView.swift
//  TUILiveRoom
//
//  Created by origin 李 on 2021/6/23.
//  Copyright © 2022 Tencent. All rights reserved.

import Foundation
import TUICore

protocol TCAudienceToolbarDelegate: NSObjectProtocol {
    func closeVC(_ popViewController: Bool)
    func clickScreen(_ position: CGPoint)
    func clickPlayVod()
    func clickLog()
    func clickLike()
    func clickChat()
    func onSeek(_ slider: UISlider?)
    func onSeekBegin(_ slider: UISlider?)
    func onDrag(_ slider: UISlider?)
    func onRecvGroupDeleteMsg()
}

/// TCAudienceToolbarView
public class TCAudienceToolbarView: UIView, TCAudienceListDelegate, UITextFieldDelegate ,UIAlertViewDelegate,BottomUsePopViewDelegate{
    
    weak var delegate: TCAudienceToolbarDelegate?
    weak var liveRoom: TRTCLiveRoom?
    weak var  tcAudienceViewController:TCAudienceViewController?

    var playDuration: UILabel = UILabel()
    var playProgress: UISlider = UISlider()
    var playLabel: UILabel = UILabel()
    var playBtn: UIButton = UIButton(type: .custom)
    var closeBtn: UIButton = UIButton(type: .custom)
    var btnChat: UIButton = UIButton(type: .custom)
    var setting : UIButton = UIButton(type: .custom)
    
    //MARK: ---- 底部弹出view bottom tool v
    lazy var bottomPopV : BottomUsePopView  = {
        var bottomV = BottomUsePopView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT));
        bottomV.delegate = self;
        bottomV.isHidden = true;
        bottomV.isAudienceType = true;//观众类型
        return bottomV;
    }()


    
    lazy var reportBtn: UIButton  = {
        let btn = UIButton(type: .custom)
        btn.setBackgroundImage(UIImage(named: "livevideo_report", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }()
    var cover: UIView = UIButton(type: .custom)
    var statusView: UITextView?
    var logViewEvt: UITextView?
    var audienceTableView: TCAudienceListTableView?
    var liveInfo: TRTCLiveRoomInfo?
    var likeBtn: UIButton = UIButton(type: .custom)
    var touchBeginLocation = CGPoint.zero
    var bulletBtnIsOn = false
    var viewsHidden = false
    
    lazy var topView: TCShowLiveTopView  = {
 
        print("观众端的 topView ---- TCShowLiveTopView --roomId= \( String(describing: liveInfo?.roomId))  roomName=\(String(describing: liveInfo?.roomName))  ownerId= \(String(describing: liveInfo?.ownerId)) activityIdstr=\(String(describing: liveInfo?.activityIdstr)) recpassword\(String(describing: liveInfo?.rec_passWordStr))")
        //liveInfo?.coverUrl 是创建时的封面图 非创建者头像
       
        print("观众端的 topView ---- TCShowLiveTopView --coverUrl= \( String(describing: liveInfo?.coverUrl))")
        //先占位 再等接口刷新
        return TCShowLiveTopView(frame: CGRect(x: 5, y: Int(StatusBarHeight) + 5, width: 180, height: 48),
                                 isHost: false,
                                 roomName: (liveInfo?.roomName ?? ""),
                                 audienceCount: 0,
                                 likeCount: 0,
                                 hostFaceUrl: (liveInfo?.coverUrl ?? ""))
      
    }()
    
    init(frame: CGRect, live liveInfo: TRTCLiveRoomInfo?, withLinkMic linkmic: Bool) {
        super.init(frame: frame)
        self.liveInfo = liveInfo
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickScreenTap(_:)))
        addGestureRecognizer(tap)
        initUI(linkmic)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setViewerCount(viewCount: Int,like likeCount: Int) -> Void {
        liveInfo?.memberCount = viewCount
        topView.setViewerCount(_viewerCount: viewCount, _likeCount: likeCount)
    }
    
    func isAlready(inAudienceList model: TCMsgModel) -> Bool {
        guard let audienceTableView = audienceTableView else {
            return false
        }
        return audienceTableView.isAlready(inAudienceList: model)
    }
    
    func setRoomId(_ roomId: String?) {
        topView.setRoomId(roomId)
    }
    func setHeaderImgStr(_ heardimgStr : String){//setHeardImgStr cell的
        topView.setRoomId(heardimgStr)
    }
    
    func onFetchGroupMemberList(_ errCode: Int, memberCount: Int) {
        guard 0 == errCode else {
            return
        }
        topView.setViewerCount(_viewerCount: memberCount, _likeCount: Int(topView.getLikeCount()))
    }
    
    func initAudienceList(_ audienceList: [TRTCLiveUserInfo]) {
//        let audience_width: CGFloat = width - 25 - topView.right
        let audience_width: CGFloat = width - 85 - topView.right
        let x = topView.right + 10 + (audience_width/2) - CGFloat((IMAGE_SIZE/2))
        let y = topView.center.y - audience_width/2
        let frame = CGRect(x: x, y: y, width: topView.height, height: audience_width)
        guard let liveInfo = liveInfo else {
            return
        }
        audienceTableView = TCAudienceListTableView(frame: frame, style: UITableView.Style.grouped, live: liveInfo)
        
        guard let audienceTableView = audienceTableView else {
            return
        }
        audienceTableView.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        audienceTableView.audienceListDelegate = self
        addSubview(audienceTableView)
        for user in audienceList {
            var msgModel = TCMsgModel()
            msgModel.msgType = .memberEnterRoom
            msgModel.userId = user.userId
            msgModel.userName = user.userName
            msgModel.userHeadImageUrl = user.avatarURL
            audienceTableView.refreshAudienceList(msgModel)
            topView.onUserEnterLiveRoom()
        }
    }
    
    
    func initUI(_ linkmic: Bool) -> Void {
        //顶部信息区域
        addSubview(topView)
        topView.clickHead = { [weak self] in
            guard let `self` = self else { return }
            guard let delegate = self.delegate else {
                return
            }
            delegate.clickLog()
        }
        //关闭按钮
        closeBtn.setBackgroundImage(UIImage(named: "live_exit", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        addSubview(closeBtn)
        
//        let audience_width: CGFloat = width - 25 - topView.right
        closeBtn.snp.makeConstraints {  make in
            make.trailing.equalTo(self).offset(-25)
            make.width.height.equalTo(30)
            make.bottom.equalTo(topView)
        }
       
        let iconSize = CGFloat(BOTTOM_BTN_ICON_WIDTH)
        let startSpace: CGFloat = 10
        let iconCenterY = CGFloat(height - iconSize / 2) - startSpace
        
        let iconCount: CGFloat = linkmic == true ? 7 : 6
        let iconCenterInterval = (width - 2 * startSpace - CGFloat(iconSize)) / (iconCount - 1)
        let firstIconCenterX = startSpace + CGFloat(iconSize / 2)
        
        //聊天按钮不动位置
        btnChat.center = CGPoint(x: firstIconCenterX + iconSize / 2.0, y: iconCenterY)
        btnChat.bounds = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        btnChat.setBackgroundImage(UIImage(named: "comment", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        btnChat.addTarget(self, action: #selector(clickChat(_:)), for: .touchUpInside)
        addSubview(btnChat)
        
        
        //设置按钮
        setting.setImage(UIImage(named: "live_more", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        setting.addTarget(self, action: #selector(clickSettingWithShowBottomToolView), for: .touchUpInside)
        addSubview(setting)
        setting.snp.makeConstraints({ make in
            make.trailing.equalTo(self).offset(-firstIconCenterX)
            make.size.centerY.equalTo(btnChat)

        })


//        likeBtn.frame = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
//        likeBtn.setImage(UIImage(named: "like_hover", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
//        likeBtn.addTarget(self, action: #selector(clickLike(_:)), for: .touchUpInside)
//        addSubview(likeBtn)
//        likeBtn.snp.makeConstraints({ make in
//            make.centerY.equalTo(closeBtn.snp.centerY)
//            make.centerX.equalTo(closeBtn).offset(-iconCenterInterval * 1.2)
//            make.width.height.equalTo(iconSize)
//        })
#if RTCube_APPSTORE
        addSubview(reportBtn)
        reportBtn.snp.makeConstraints({ make in
            make.centerY.equalTo(btnChat.snp.centerY)
            make.centerX.equalTo(btnChat).offset(iconCenterInterval * 1.2)
            make.width.height.equalTo(iconSize)
        })
        reportBtn.addTarget(self, action: #selector(clickReport), for: .touchUpInside)
#endif
        //LOG UI
        cover.frame = CGRect(x: 10.0, y: 55 + 2 * iconSize, width: width - 20, height: height - 110 - 3 * iconSize)
        cover.backgroundColor = UIColor.white
        cover.alpha = 0.5
        cover.isHidden = true
        addSubview(cover)
        
        let logheadH = 65
        statusView = UITextView(frame: CGRect(x: 10.0, y: 55 + 2 * iconSize, width: width - 20, height: CGFloat(logheadH)))
        guard let statusView = statusView else {
            return
        }
        statusView.backgroundColor = UIColor.clear
        statusView.alpha = 1
        statusView.textColor = UIColor.black
        statusView.isEditable = false
        statusView.isHidden = true
        addSubview(statusView)
        
        logViewEvt = UITextView(frame: CGRect(x: 10.0, y: 55 + 2 * iconSize + CGFloat(logheadH), width:
         width - 20, height: height - 110 - 3 * iconSize - CGFloat(logheadH)))
        guard let logViewEvt = logViewEvt else {
            return
        }
        logViewEvt.backgroundColor = UIColor.clear
        logViewEvt.alpha = 1
        logViewEvt.textColor = UIColor.black
        logViewEvt.isEditable = false
        logViewEvt.isHidden = true
        addSubview(logViewEvt)
    }
    
    
    func initUI_old(_ linkmic: Bool) -> Void {//0809旧版
        closeBtn.setBackgroundImage(UIImage(named: "live_exit", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        addSubview(closeBtn)
        addSubview(topView)
        topView.clickHead = { [weak self] in
            guard let `self` = self else { return }
            guard let delegate = self.delegate else {
                return
            }
            delegate.clickLog()
        }
        let iconSize = CGFloat(BOTTOM_BTN_ICON_WIDTH)
        let startSpace: CGFloat = 10
        let iconCenterY = CGFloat(height - iconSize / 2) - startSpace
        
        let iconCount: CGFloat = linkmic == true ? 7 : 6
        let iconCenterInterval = (width - 2 * startSpace - CGFloat(iconSize)) / (iconCount - 1)
        let firstIconCenterX = startSpace + CGFloat(iconSize / 2)
        
        btnChat.center = CGPoint(x: firstIconCenterX + iconSize / 2.0, y: iconCenterY)
        btnChat.bounds = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        btnChat.setBackgroundImage(UIImage(named: "comment", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        btnChat.addTarget(self, action: #selector(clickChat(_:)), for: .touchUpInside)
        addSubview(btnChat)
        closeBtn.snp.makeConstraints {  make in
            make.centerY.equalTo(btnChat.snp.centerY)
            make.right.equalTo(self).offset(-iconCenterInterval * 0.7)
            make.width.height.equalTo(iconSize)
        }

        likeBtn.frame = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        likeBtn.setImage(UIImage(named: "like_hover", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        likeBtn.addTarget(self, action: #selector(clickLike(_:)), for: .touchUpInside)
        addSubview(likeBtn)
        likeBtn.snp.makeConstraints({ make in
            make.centerY.equalTo(closeBtn.snp.centerY)
            make.centerX.equalTo(closeBtn).offset(-iconCenterInterval * 1.2)
            make.width.height.equalTo(iconSize)
        })
#if RTCube_APPSTORE
        addSubview(reportBtn)
        reportBtn.snp.makeConstraints({ make in
            make.centerY.equalTo(btnChat.snp.centerY)
            make.centerX.equalTo(btnChat).offset(iconCenterInterval * 1.2)
            make.width.height.equalTo(iconSize)
        })
        reportBtn.addTarget(self, action: #selector(clickReport), for: .touchUpInside)
#endif
        //LOG UI
        cover.frame = CGRect(x: 10.0, y: 55 + 2 * iconSize, width: width - 20, height: height - 110 - 3 * iconSize)
        cover.backgroundColor = UIColor.white
        cover.alpha = 0.5
        cover.isHidden = true
        addSubview(cover)
        
        let logheadH = 65
        statusView = UITextView(frame: CGRect(x: 10.0, y: 55 + 2 * iconSize, width: width - 20, height: CGFloat(logheadH)))
        guard let statusView = statusView else {
            return
        }
        statusView.backgroundColor = UIColor.clear
        statusView.alpha = 1
        statusView.textColor = UIColor.black
        statusView.isEditable = false
        statusView.isHidden = true
        addSubview(statusView)
        
        logViewEvt = UITextView(frame: CGRect(x: 10.0, y: 55 + 2 * iconSize + CGFloat(logheadH), width:
         width - 20, height: height - 110 - 3 * iconSize - CGFloat(logheadH)))
        guard let logViewEvt = logViewEvt else {
            return
        }
        logViewEvt.backgroundColor = UIColor.clear
        logViewEvt.alpha = 1
        logViewEvt.textColor = UIColor.black
        logViewEvt.isEditable = false
        logViewEvt.isHidden = true
        addSubview(logViewEvt)
    }
    
    func getLocation(_ bulletView: TCMsgBarrageView) -> CGFloat {
        let view = bulletView.lastAnimateView
        let rect = view.layer.presentation()?.frame
        return (rect?.origin.x ?? 0.0) + (rect?.size.width ?? 0.0)
    }
    
    
    @objc func clickChat(_ button: UIButton?) {
        delegate?.clickChat()
    }
    
    @objc func clickLike(_ button: UIButton) {
        delegate?.clickLike()
    }
    
    @objc func clickReport() {
        let selector = NSSelectorFromString("showReportAlertWithRoomId:ownerId:")
        if responds(to: selector) {
            guard let liveInfo = liveInfo else { return }
            perform(selector, with: liveInfo.roomId, with: liveInfo.ownerId)
        }
    }
    
    func onLogout(_ notice: Notification?) {
        closeVC()
    }
    
    // MARK: TCAudienceToolbarDelegate
    @objc func closeVC() {
        guard let delegate = delegate else {
            return
        }
        NotificationCenter.default.removeObserver(self)
        delegate.closeVC(true)
    }
    
    @objc func clickScreenTap(_ gestureRecognizer: UITapGestureRecognizer?) {
        guard let delegate = delegate else {
            return
        }
        if let position = gestureRecognizer?.location(in: self) {
            delegate.clickScreen(position)
        }
    }
    
    @objc func clickPlayVod() {
        guard let delegate = delegate else {
            return
        }
        if delegate.responds(to: #selector(clickPlayVod)) {
            delegate.clickPlayVod()
        }
    }
    
    @objc func onSeek(_ slider: UISlider?) {
        guard let delegate = delegate else {
            return
        }
        if delegate.responds(to: #selector(onSeek(_:))) {
            delegate.onSeek(slider)
        }
    }
    
    @objc func onSeekBegin(_ slider: UISlider?) {
        guard let delegate = delegate else {
            return
        }
        if delegate.responds(to: #selector(onSeekBegin(_:))) {
            delegate.onSeekBegin(slider)
        }
    }
    
    @objc func onDrag(_ slider: UISlider?) {
        guard let delegate = delegate else {
            return
        }
        if delegate.responds(to: #selector(onDrag(_:))) {
            delegate.onDrag(slider)
        }
    }
    
    func handleIMMessage(_ info: IMUserAble?, msgText: String?) {
        guard let info = info else {
            return
        }
        switch info.cmdType {
        case .memberEnterRoom:
            var msgModel = TCMsgModel()
            msgModel.userId = info.imUserId
            msgModel.userName = info.imUserName
            msgModel.userMsg = liveRoomLocalize("Demo.TRTC.LiveRoom.joininteraction")
            msgModel.userHeadImageUrl = info.imUserIconUrl
            msgModel.msgType = .memberEnterRoom
            if !isAlready(inAudienceList: msgModel) {
                topView.onUserEnterLiveRoom()
            }
            break
        case .memberQuitRoom:
            var msgModel = TCMsgModel()
            msgModel.userId = info.imUserId
            msgModel.userName = info.imUserName
            msgModel.userMsg = liveRoomLocalize("Demo.TRTC.LiveRoom.exitinteraction")
            msgModel.userHeadImageUrl = info.imUserIconUrl
            msgModel.msgType = .memberQuitRoom
            topView.onUserExitLiveRoom()
            break
        case .praise:
            var msgModel = TCMsgModel()
            msgModel.userName = info.imUserName
            msgModel.userMsg = liveRoomLocalize("Demo.TRTC.LiveRoom.clicklike")
            msgModel.userHeadImageUrl = info.imUserIconUrl
            msgModel.msgType = .praise
            topView.onUserSendLikeMessage()
            break
        case .danmaMsg:
            var msgModel = TCMsgModel()
            msgModel.userName = info.imUserName
            msgModel.userMsg = msgText
            msgModel.userHeadImageUrl = info.imUserIconUrl
            msgModel.msgType = .danmaMsg
            break
        default:
            break
        }
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        let touch = event.allTouches?.first
        touchBeginLocation = (touch?.location(in: self))!
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        let touch = event.allTouches?.first
        let location = touch?.location(in: self)
        endMove((location?.x ?? 0.0) - touchBeginLocation.x)
    }
    
    func resetViewAlpha(_ view: UIView) {
        let rect = view.frame
        if (rect.origin.x ) >= SCREEN_WIDTH || (rect.origin.x ) < 0 {
            view.alpha = 0
            viewsHidden = true
        } else {
            view.alpha = 1
            viewsHidden = false
        }
        if view == cover {
            cover.alpha = 0.5
        }
    }
    
    func endMove(_ moveX: CGFloat) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let `self` = self else { return }
            if moveX > 10 {
                for view in self.subviews {
                    if view != self.closeBtn {
                        var rect = view.frame
                        if rect.origin.x >= 0 && rect.origin.x < SCREEN_WIDTH {
                            rect = rect.offsetBy(dx: self.width, dy: 0)
                            view.frame = rect
                            self.resetViewAlpha(view)
                        }
                    }
                }
            } else if moveX < -10 {
                for view in self.subviews {
                    if view != self.closeBtn {
                        var rect = view.frame
                        if rect.origin.x >= SCREEN_WIDTH {
                            rect = rect.offsetBy(dx: -self.width, dy: 0)
                            view.frame = rect
                            self.resetViewAlpha(view)
                        }
                    }
                }
            }
        })
    }
    
    
     // MARK: --------- bottom tool popview used
    //显示隐藏
    // MARK: --------- bottom tool popview used
    ///显示隐藏
    @objc func clickSettingWithShowBottomToolView() {
        print("-----------show btm tool view  ---- clickSetting clickSetting");

        if(self.bottomPopV.isHidden == true ){//显示动作
            if(self.bottomPopV.superview == nil){
                self.superview?.addSubview(self.bottomPopV);//此处加UI 最上层 才能不看见设置等bottombtn
            }
            self.bottomPopV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
            self.bottomPopV.isHidden = false;//显示
            UIView.animate(withDuration: 0.3) {
                self.bottomPopV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            };
            self.superview?.bringSubviewToFront(self.bottomPopV)//显示在最前
            self.bottomPopV.collectionView.isUserInteractionEnabled = true;
            
        }else{//隐藏动作
            
            let  centerpoint : CGPoint = CGPoint(x: self.bottomPopV.frame.size.width/2, y: self.bottomPopV.frame.size.height/2)
            UIView.animate(withDuration: 0.3) {
                self.bottomPopV.center = CGPoint(x: centerpoint.x, y: centerpoint.y+SCREEN_HEIGHT)
            } completion: { finished in
                self.bottomPopV.isHidden = true;
            }
        }
       
        
    }
    ///方法触发
    @objc func bottomToolPopViewHidenAction() {  //点击自己后 做隐藏
        self.clickSettingWithShowBottomToolView()
    }
    
    @objc func bottomToolPopViewShareAction() {//分享
//        let actividyId = self.liveInfo?.activityIdstr ?? "";
//        let showTextPrfu_key =  kShareStr_Open_Freeper_NSLocalStrKey as String
//        let showTextPrfu_obj = liveRoomLocalize(showTextPrfu_key);
//        let willShareMsg = showTextPrfu_obj + kShareStr_Open_Freeper_Io + kShareStr_ActivityId_Prex + actividyId
////        let willShareMsgUrl  = URL(string: willShareMsg)
//
        
        let actividyId = self.liveInfo?.activityIdstr ?? "";
        let recPassWord = self.liveInfo?.rec_passWordStr ?? "";

        
        let showTextPrfu_key =  kShareStr_Open_Freeper_NSLocalStrKey as String
        let showTextPrfu_obj =  liveRoomLocalize(showTextPrfu_key);
        
        let showRecPasswordText_key =  kShareStr_Open_Freeper_NSLocalStrKey_PassStr as String
        let showRecPasswordText_Obj = liveRoomLocalize(showRecPasswordText_key);
        
        
        var willShareMsg = showTextPrfu_obj + kShareStr_Open_Freeper_Io + kShareStr_ActivityId_Prex + actividyId
        if(recPassWord.isEmpty){
        }else{
           let fuhaoA = ":"
            willShareMsg = showTextPrfu_obj  + showRecPasswordText_Obj + fuhaoA +  recPassWord + " " + kShareStr_Open_Freeper_Io + kShareStr_ActivityId_Prex + actividyId
        }
        
        
        
        let activityVc : UIActivityViewController =  UIActivityViewController(activityItems: [willShareMsg ], applicationActivities:[] )
        self.tcAudienceViewController!.present(activityVc, animated: true);
    }
    
    @objc func bottomToolPopViewClearnDanMuAction() {//清除弹幕
        print("清除弹幕");
        let notice_name : String = Notice_ClearnDanMu as String;
        NotificationCenter.default.post(name: NSNotification.Name(notice_name), object:nil);
        
    }
    

     
    //点bottomPopView击事件 BottomUsePopViewDelegate'
    public func touchCell(withBotomToolType type: Botom_Tool_Type) {
        switch type {
        case Botom_Tool_Type_HidenSelfPopView://隐藏
            do {
                bottomToolPopViewHidenAction()
            }
            break;
        case Botom_Tool_Type_GuanBi://关闭直播
            do {
                bottomToolPopViewHidenAction()
                closeVC()
            }
            break;
        case Botom_Tool_Type_FenXiang://分享
            do {
                bottomToolPopViewHidenAction()
                bottomToolPopViewShareAction()
            }
            break;
        case Botom_Tool_Type_DanMuQingKong://清除弹幕
            do {
                bottomToolPopViewHidenAction()
                bottomToolPopViewClearnDanMuAction()
            }
            break;
        case Botom_Tool_Type_GuanLiChengYuan://管理员
            do {
                bottomToolPopViewHidenAction()
            }
            break;
            
            
        default:
            do {
                print("其他点击事件");
            }
            break;
             
        }
    }
    // MARK: --------- bottom tool popview end
    
    ///方法触发
    @objc func admindPopViewHidenAction() {  //点击自己后 做隐藏
        self.clickSettingWithShowBottomToolView()
    }
    
 

    
}
