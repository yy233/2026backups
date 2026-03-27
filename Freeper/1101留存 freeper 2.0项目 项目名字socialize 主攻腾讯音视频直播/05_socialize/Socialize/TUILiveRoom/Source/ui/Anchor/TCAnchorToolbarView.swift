//
//  TCAnchorToolbarView.swift
//  TUILiveRoom
//
//  Created by origin 李 on 2021/6/28.
//  Copyright © 2022 Tencent. All rights reserved.

import Foundation
import TUICore

typealias ShowResultComplete = () -> Void

protocol TCAnchorToolbarDelegate: NSObjectProtocol {
    func closeRTMP()
    func closeVC()
    func clickScreen(_ gestureRecognizer: UITapGestureRecognizer?)
    func clickCamera(_ button: UIButton?)
    func clickBeauty(_ button: UIButton?)
    func clickMusic(_ button: UIButton?)
    func clickChat(_ button: UIButton?)
    func clickPK(_ button: UIButton?)
    func pk(withRoom room: TRTCLiveRoomInfo?)
    func clickLog()
}

class TCPushShowResultView: UIView {
    
    var titleLabel: UILabel = UILabel()
    var durationLabel: UILabel = UILabel()
    var durationTipLabel: UILabel = UILabel()
    var viewerCountLabel: UILabel = UILabel()
    var viewerCountTipLabel: UILabel = UILabel()
    var praiseLabel: UILabel = UILabel()
    var praiseTipLabel: UILabel = UILabel()
    var backBtn: UIButton = UIButton(type: .custom)
    var line: UILabel = UILabel()
    var backHomepage: ShowResultComplete?
    var resultData: TCShowLiveTopView?
    
    init(frame: CGRect, resultData: TCShowLiveTopView?, backHomepage: @escaping ShowResultComplete) {
        super.init(frame: frame)
        self.resultData = resultData
        self.backHomepage = backHomepage
        initUI()
        backBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
    }
    
    @objc func clickBackBtn()  {
        self.backHomepage?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initUI() {
        let duration = Int(resultData?.getLiveDuration() ?? 0)
        let hour = duration / 3600
        let min = (duration - hour * 3600) / 60
        let sec = duration - hour * 3600 - min * 60
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.textColor = UIColor.black
        titleLabel.text = liveRoomLocalize("Demo.TRTC.LiveRoom.interactionitsover")
        addSubview(titleLabel)
        durationLabel.textAlignment = .center
        durationLabel.font = UIFont.boldSystemFont(ofSize: 15)
        durationLabel.textColor = UIColor.black
        durationLabel.text = String(format: "%02d:%02d:%02d", hour, min, sec)
        addSubview(durationLabel)
        durationTipLabel.textAlignment = .center
        durationTipLabel.font = UIFont.boldSystemFont(ofSize: 12)
        durationTipLabel.textColor = UIColor.gray
        durationTipLabel.text = liveRoomLocalize("Demo.TRTC.LiveRoom.interactionduration")
        addSubview(durationTipLabel)
        viewerCountLabel.textAlignment = .center
        viewerCountLabel.font = UIFont.boldSystemFont(ofSize: 12)
        viewerCountLabel.textColor = UIColor.black
        guard let resultData = resultData else { return }
        viewerCountLabel.text = String(format: "%ld", resultData.getTotalViewerCount())
        addSubview(viewerCountLabel)
        viewerCountTipLabel.textAlignment = .center
        viewerCountTipLabel.font = UIFont.boldSystemFont(ofSize: 12)
        viewerCountTipLabel.textColor = UIColor.gray
        viewerCountTipLabel.text = liveRoomLocalize("Demo.TRTC.LiveRoom.viewers")
        addSubview(viewerCountTipLabel)
        praiseLabel.textAlignment = .center
        praiseLabel.font = UIFont.boldSystemFont(ofSize: 12)
        praiseLabel.textColor = UIColor.black
        praiseLabel.text = String(format: "%ld\n", resultData.getLikeCount())
        addSubview(praiseLabel)
        praiseTipLabel.textAlignment = .center
        praiseTipLabel.font = UIFont.boldSystemFont(ofSize: 12)
        praiseTipLabel.textColor = UIColor.gray
        praiseTipLabel.text = liveRoomLocalize("Demo.TRTC.LiveRoom.numberoflikes")
        addSubview(praiseTipLabel)
        line.backgroundColor = UIColor(hex: "EEEEEE")
        addSubview(line)
        backBtn.backgroundColor = UIColor.clear
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        backBtn.setTitle(liveRoomLocalize("Demo.TRTC.LiveRoom.back"), for: .normal)
        backBtn.setTitleColor(UIColor.flatBlue(), for: .normal)
        addSubview(backBtn)
        relayout()
    }
    
    func relayout() {
        let rect = bounds
        titleLabel.size(with: CGSize(width: rect.size.width, height: 24))
        titleLabel.alignParentTop(withMargin: 20)
        
        durationLabel.size(with: CGSize(width: rect.size.width, height: 15))
        durationLabel.layout(below: titleLabel, margin: 20)
        durationTipLabel.size(with: CGSize(width: rect.size.width, height: 14))
        durationTipLabel.layout(below: durationLabel, margin: 7)
        
        viewerCountLabel.frame = CGRect(x: rect.size.width / 4.0 - 10, y: 0, width: rect.size.width / 4.0, height: 15)
        viewerCountLabel.layout(below: durationTipLabel, margin: 20)
        viewerCountTipLabel.frame = CGRect(x: rect.size.width / 5.5, y: 0, width: rect.size.width / 3.5, height: 15)
        viewerCountTipLabel.layout(below: viewerCountLabel, margin: 7)
        
        praiseLabel.frame = CGRect(x: rect.size.width / 2.0 + 10, y: 0, width: rect.size.width / 4.0, height: 15)
        praiseLabel.layout(below: durationTipLabel, margin: 20)
        praiseTipLabel.frame = CGRect(x: rect.size.width / 1.88, y: 0, width: rect.size.width / 3.5, height: 15)
        praiseTipLabel.layout(below: praiseLabel, margin: 7)
        
        backBtn.size(with: CGSize(width: rect.size.width, height: 35))
        backBtn.layoutParentHorizontalCenter()
        backBtn.layout(below: praiseTipLabel, margin: 30)
        
        line.size(with: CGSize(width: rect.size.width, height: 0.5))
        line.layout(below: praiseTipLabel, margin: 30)
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}

 
class TCAnchorToolbarView: UIView, UITextFieldDelegate, UIGestureRecognizerDelegate ,BottomUsePopViewDelegate,AdmainManagerPopViewDelegate{
    
    
    
    var btnChat: UIButton  = UIButton(type: .custom)
    var btnCamera: UIButton = UIButton(type: .custom)
    var btnBeauty: UIButton = UIButton(type: .custom)
    var btnPK: UIButton = UIButton(type: .custom)
    var btnMusic: UIButton = UIButton(type: .custom)
    var setting : UIButton = UIButton(type: .custom)
    var btnJinYing: UIButton = UIButton(type: .custom)//静音切换按钮
    
    //MARK: ---- 底部弹出view bottom tool v
    lazy var bottomPopV : BottomUsePopView  = {
        var bottomV = BottomUsePopView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT));
        bottomV.delegate = self;
        bottomV.isHidden = true;
        return bottomV;
    }()
    //MARK: ---- 底部弹出view 管理v
    lazy var admainManagerView : AdmainManagerPopView  = {
        var admainManagerView = AdmainManagerPopView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT));
        admainManagerView.delegate = self;
        admainManagerView.isHidden = true;
        return admainManagerView;
    }()
    
    //MARK: ----
    var cover: UIView = UIView()
    var vPKPanel: AnchorPKPanel = AnchorPKPanel()
    var isPreview = false
    weak var delegate: TCAnchorToolbarDelegate?
    weak var liveRoom: TRTCLiveRoom?
    weak var anchorViewController: TCAnchorViewController?
    var showLikeHeartStartRectFreqControl: TCFrequeControl?
    var resultView: TCPushShowResultView?
    var audienceTableView: TCAudienceListTableView?
    var liveInfo: TRTCLiveRoomInfo?
    var clearView: UIView?
    var closeBtn: UIButton = UIButton(type: .custom)
    var pkView: UIImageView?
    var touchBeginLocation = CGPoint.zero
    var bulletBtnIsOn = false
    var closeAlert: UIAlertController?
    var viewsHidden = false
    var heartAnimationPoints: [CGPoint] = [CGPoint]()
    let moreSettingVC = TRTCLiveRoomMoreControllerUI()
    lazy var topView: TCShowLiveTopView = {
        let statusBarHeight = Int(UIApplication.shared.statusBarFrame.size.height)
        
        var topView = TCShowLiveTopView(
            frame: CGRect(x: 5, y: statusBarHeight + 5, width: 180, height: 48),
            isHost: true,
            roomName: self.liveInfo?.roomName ?? "",
            audienceCount: self.liveInfo?.memberCount ?? 0,
            likeCount: 0,
            hostFaceUrl: self.liveInfo?.coverUrl ?? "")
        //        var topView = TCShowLiveTopView(
        //            frame: CGRect(x: 5, y: statusBarHeight + 5, width: 180, height: 48),
        //            isHost: true,
        //            roomName: self.liveInfo?.roomName ?? "",
        //            audienceCount: self.liveInfo?.memberCount ?? 0,
        //            likeCount: 0,
        //            hostFaceUrl: self.liveInfo?.streamUrl ?? "") // self.liveInfo?.streamUrl  主播头像
        print("elf.liveInfo?.streamUrl  需要展示主播头像     TUILogin.getFaceUrl() == \(String(describing: TUILogin.getFaceUrl())) 然而streamUrl是视频流数据ID\(String(describing: self.liveInfo?.streamUrl)) ")
        
        
        
        return topView
    }()
    lazy private var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickScreen(_:)))
        return tap
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(tap)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setButtonHidden(_ buttonHidden: Bool) {
        btnChat.isHidden = buttonHidden
        btnCamera.isHidden = buttonHidden
        btnBeauty.isHidden = buttonHidden
        btnPK.isHidden = buttonHidden
        btnMusic.isHidden = buttonHidden
        closeBtn.isHidden = buttonHidden
        setting.isHidden = buttonHidden
        btnJinYing.isHidden = buttonHidden
    }
    
    func setLive(_ liveInfo: TRTCLiveRoomInfo!) {
        isPreview = false
        self .setButtonHidden(false)
        self.liveInfo = liveInfo
        
        addSubview(topView)
        topView.snp.makeConstraints({ make in
            make.centerY.equalTo(closeBtn)
            make.leading.equalTo(self).offset(20)
            make.width.equalTo(160)
            make.height.equalTo(48)
        })
        topView.clickHead = { [weak self] in
            guard let `self` = self else { return }
            guard let delegate = self.delegate else {
                return
            }
            delegate.clickLog()
        }
        topView.startLive()
        topView.setRoomId(liveInfo.roomId)
        
        let audience_width: CGFloat = width - 25 - topView.right
        let x = topView.right + 10 + (audience_width  - CGFloat(IMAGE_SIZE)) / 2
        let y = topView.center.y - audience_width / 2
        audienceTableView = TCAudienceListTableView(frame: CGRect(x: x, y: y, width: topView.height, height: audience_width), style: UITableView.Style.grouped, live: self.liveInfo!)
        
        audienceTableView!.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        insertSubview(audienceTableView!, at: 0)
        let center = CGPoint(x: audienceTableView?.center.x ?? 0, y: closeBtn.center.y)
        audienceTableView?.center = center
    }
    
    func setLiveRoom(_ liveRoom: TRTCLiveRoom?) {
        self.liveRoom = liveRoom
        vPKPanel.liveRoom = self.liveRoom
    }
    
    func ZhuBoNowBottomView(){
        isPreview = true
        let icon_size = BOTTOM_BTN_ICON_WIDTH
        let margin = (UIScreen.main.bounds.size.width - CGFloat(icon_size * 6)) / 7
        
        btnChat.setBackgroundImage(UIImage(named: "comment", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        btnChat.addTarget(self, action: #selector(clickChat(_:)), for: .touchUpInside)
        addSubview(btnChat)
        btnChat.snp.makeConstraints({ make in
            make.leading.equalTo(self).offset(margin)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self).offset(-35)
            } else {
                make.bottom.equalTo(self).offset(-15)
            }
            make.size.equalTo(CGSize(width: icon_size, height: icon_size))
        })
        
        
        
    }
    func initUI() {//20240808改动。留1+3 （1输入 3静音按钮 切换镜头按钮 工具按钮） 有空可以加上一个美颜暂时不加
        
        //——————————————————————
        isPreview = true
        let icon_size = BOTTOM_BTN_ICON_WIDTH
        let margin = (UIScreen.main.bounds.size.width - CGFloat(icon_size * 6)) / 7  //间隙w
        
        
        
        //输入
        btnChat.setBackgroundImage(UIImage(named: "comment", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        btnChat.addTarget(self, action: #selector(clickChat(_:)), for: .touchUpInside)
        addSubview(btnChat)
        btnChat.snp.makeConstraints({ make in
            make.leading.equalTo(self).offset(margin)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self).offset(-35)
            } else {
                make.bottom.equalTo(self).offset(-15)
            }
            make.size.equalTo(CGSize(width: icon_size, height: icon_size))
        })
        
        //设置
        setting.setImage(UIImage(named: "live_more", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        setting.addTarget(self, action: #selector(clickSettingWithShowBottomToolView), for: .touchUpInside)
        addSubview(setting)
        setting.snp.makeConstraints({ make in
            make.trailing.equalTo(self).offset(-margin)
            make.size.centerY.equalTo(btnChat)
        })
        
        //切换镜头
        btnCamera.setImage(UIImage(named: "live_camera", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        btnCamera.addTarget(self, action: #selector(clickCamera(_:)), for: .touchUpInside)
        addSubview(btnCamera)
        btnCamera.snp.makeConstraints({ make in
            make.trailing.equalTo(setting.snp.leading).offset(-margin)
            make.size.centerY.equalTo(btnChat)
        })
        
        
        //3静音 160rgb "开启麦克风" 关闭麦克风
        //        let bakColor = UIColor(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1.0);
        btnJinYing.layer.cornerRadius = 22.0//BOTTOM_BTN_ICON_WIDTH*0.5;
        btnJinYing.backgroundColor = .black.withAlphaComponent(0.3);
        btnJinYing.setImage(UIImage(named: "开启麦克风", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        btnJinYing.setImage(UIImage(named: "关闭麦克风", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .selected)
        btnJinYing.addTarget(self, action: #selector(clickJingYing(_:)), for: .touchUpInside)
        addSubview(btnJinYing)
        btnJinYing.snp.makeConstraints({ make in
            make.trailing.equalTo(btnCamera.snp.leading).offset(-margin)
            make.size.centerY.equalTo(btnChat)
        })
        //主播开播 默认声音开启
        self.liveRoom?.muteLocalAudio(false)
        
        
        //其他旧版的按钮
        closeBtn.setImage(UIImage(named: "live_exit", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        closeBtn.backgroundColor = UIColor.clear
        closeBtn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        addSubview(closeBtn)
        bringSubviewToFront(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.trailing.equalTo(self).offset(-20)
            make.width.equalTo(52)
            make.height.equalTo(52)
            if #available(iOS 11.0, *) {
                make.top.equalTo(self).offset(60)
            } else {
                make.top.equalTo(self).offset(20)
            }
        }
        
        vPKPanel = AnchorPKPanel()
        vPKPanel.backgroundColor = UIColor.clear
        vPKPanel.isHidden = true
        vPKPanel.pkWithRoom = { [weak self] room in
            guard let `self` = self else { return }
            guard let delegate = self.delegate else {return }
            delegate.pk(withRoom: room)
        }
        vPKPanel.shouldHidden = { [weak self] in
            guard let `self` = self else { return }
            self.addGestureRecognizer(self.tap)
        }
        addSubview(vPKPanel)
        var bottomOffset: CGFloat = 0
        if #available(iOS 11, *) {
            bottomOffset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
        }
        vPKPanel.size(with: CGSize(width: width, height: 348 + bottomOffset))
        vPKPanel.alignParentTop(withMargin: height - vPKPanel.height)
        vPKPanel.alignParentLeft(withMargin: 0)
        
        cover.frame = CGRect(x: 10.0, y: CGFloat(55 + 2 * icon_size), width: width - 20, height: height - 75 - CGFloat(3 * icon_size))
        cover.backgroundColor = UIColor.white
        cover.alpha = 0.5
        cover.isHidden = true
        addSubview(cover)
        self.setButtonHidden(true)
        
    }
    
    //0808旧版的底部按钮
    func initUI_0808OOOld() {
        isPreview = true
        let icon_size = BOTTOM_BTN_ICON_WIDTH
        let margin = (UIScreen.main.bounds.size.width - CGFloat(icon_size * 6)) / 7
        
        btnChat.setBackgroundImage(UIImage(named: "comment", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        btnChat.addTarget(self, action: #selector(clickChat(_:)), for: .touchUpInside)
        addSubview(btnChat)
        btnChat.snp.makeConstraints({ make in
            make.leading.equalTo(self).offset(margin)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self).offset(-35)
            } else {
                make.bottom.equalTo(self).offset(-15)
            }
            make.size.equalTo(CGSize(width: icon_size, height: icon_size))
        })
        
        btnCamera.setImage(UIImage(named: "live_camera", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        btnCamera.addTarget(self, action: #selector(clickCamera(_:)), for: .touchUpInside)
        addSubview(btnCamera)
        btnCamera.snp.makeConstraints({ make in
            make.leading.equalTo(btnChat.snp.trailing).offset(margin)
            make.size.centerY.equalTo(btnChat)
        })
        
        btnPK.setImage(UIImage(named: "live_pk_start", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        btnPK.setImage(UIImage(named: "live_pk_end", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .selected)
        btnPK.addTarget(self, action: #selector(clickPK(_:)), for: .touchUpInside)
        addSubview(btnPK)
        btnPK.snp.makeConstraints({ make in
            make.leading.equalTo(btnCamera.snp.trailing).offset(margin)
            make.size.centerY.equalTo(btnChat)
        })
        
        //美颜
        btnBeauty.setImage(UIImage(named: "live_beauty", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        btnBeauty.addTarget(self, action: #selector(clickBeauty(_:)), for: .touchUpInside)
        addSubview(btnBeauty)
        btnBeauty.snp.makeConstraints({ make in
            make.leading.equalTo(btnPK.snp.trailing).offset(margin)
            make.size.centerY.equalTo(btnChat)
        })
        //音效
        btnMusic.setImage(UIImage(named: "music_icon", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        btnMusic.addTarget(self, action: #selector(clickMusic(_:)), for: .touchUpInside)
        addSubview(btnMusic)
        btnMusic.snp.makeConstraints({ make in
            make.leading.equalTo(btnBeauty.snp.trailing).offset(margin)
            make.size.centerY.equalTo(btnChat)
        })
        
        setting.setImage(UIImage(named: "live_more", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        setting.addTarget(self, action: #selector(clickSetting(_:)), for: .touchUpInside)
        addSubview(setting)
        setting.snp.makeConstraints({ make in
            make.leading.equalTo(btnMusic.snp.trailing).offset(margin)
            make.size.centerY.equalTo(btnChat)
        })
        
        
        //pk view
        pkView = UIImageView(image: UIImage(named: "PK", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil))
        pkView!.frame = CGRect(
            x: UIScreen.main.bounds.size.width / 2.0 - 25,
            y: UIScreen.main.bounds.size.height / 2.0 - 25,
            width: 50,
            height: 25)
        pkView!.isHidden = true
        addSubview(pkView!)
        
        closeBtn.setImage(UIImage(named: "live_exit", in: liveRoomBundle_UseNoTexType(), compatibleWith: nil), for: .normal)
        closeBtn.backgroundColor = UIColor.clear
        closeBtn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        addSubview(closeBtn)
        bringSubviewToFront(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.trailing.equalTo(self).offset(-20)
            make.width.equalTo(52)
            make.height.equalTo(52)
            if #available(iOS 11.0, *) {
                make.top.equalTo(self).offset(60)
            } else {
                make.top.equalTo(self).offset(20)
            }
        }
        
        vPKPanel = AnchorPKPanel()
        vPKPanel.backgroundColor = UIColor.clear
        vPKPanel.isHidden = true
        vPKPanel.pkWithRoom = { [weak self] room in
            guard let `self` = self else { return }
            guard let delegate = self.delegate else {return }
            delegate.pk(withRoom: room)
        }
        vPKPanel.shouldHidden = { [weak self] in
            guard let `self` = self else { return }
            self.addGestureRecognizer(self.tap)
        }
        addSubview(vPKPanel)
        var bottomOffset: CGFloat = 0
        if #available(iOS 11, *) {
            bottomOffset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
        }
        vPKPanel.size(with: CGSize(width: width, height: 348 + bottomOffset))
        vPKPanel.alignParentTop(withMargin: height - vPKPanel.height)
        vPKPanel.alignParentLeft(withMargin: 0)
        
        cover.frame = CGRect(x: 10.0, y: CGFloat(55 + 2 * icon_size), width: width - 20, height: height - 75 - CGFloat(3 * icon_size))
        cover.backgroundColor = UIColor.white
        cover.alpha = 0.5
        cover.isHidden = true
        addSubview(cover)
        self.setButtonHidden(true)
    }
    
    func triggeValue() {
        
    }
    
    
    
    @objc func clickScreen(_ gestureRecognizer: UITapGestureRecognizer?) {
        _ = gestureRecognizer?.location(in: self)
        vPKPanel.hiddenPanel()
        delegate?.clickScreen(gestureRecognizer)
        
    }
    
    @objc  func clickBullet(_ btn: UIButton?) {
        bulletBtnIsOn = !bulletBtnIsOn
        btn?.isSelected = bulletBtnIsOn
    }
    
    @objc func clickChat(_ button: UIButton?) {
        guard let delegate = delegate else {
            return
        }
        delegate.clickChat(button)
    }
    
    @objc func clickCamera(_ button: UIButton?) {
        guard let delegate = delegate else {
            return
        }
        delegate.clickCamera(button)
    }
    
    
    @objc func clickPK(_ button: UIButton?) {
        removeGestureRecognizer(tap)
        guard let delegate = delegate else {
            return
        }
        delegate.clickPK(button)
    }
    
    @objc func changeButtonText() {
        closeBtn.isHidden = false
        pkView?.isHidden = true
    }
    
    @objc func clickBeauty(_ button: UIButton?) {
        guard let delegate = delegate else { return }
        delegate.clickBeauty(button)
    }
    
    @objc func clickMusic(_ button: UIButton?) {
        guard let delegate = delegate else { return }
        delegate.clickMusic(button)
    }
    @objc func clickJingYing(_ button: UIButton?){
        print("click btnJinYing");
        button?.isSelected = !(button!.isSelected);
        //主播点击后的切换 点击后yes=静音
        self.liveRoom?.muteLocalAudio(button!.isSelected)
    }
    
    
    
    @objc func clickSetting(_ button: UIButton?) {
        anchorViewController?.presentBottom(self.moreSettingVC)//0808 设置功能 改成显示自定义view
    }
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
        anchorViewController?.present(activityVc, animated: true);
        
    }
    
    @objc func bottomToolPopViewClearnDanMuAction() {//清除弹幕
        print("清除弹幕");
        let notice_name : String = Notice_ClearnDanMu as String;
        NotificationCenter.default.post(name: NSNotification.Name(notice_name), object:nil);
        
    }
    
    @objc func bottomToolPopViewShowMangerPopListAction() {//管理员popView出现
        print("管理员popView出现");
        self.touchCellWithHidenAdmangerPopView()
        
    }
     
    //点bottomPopView击事件
    func touchCell(withBotomToolType type: Botom_Tool_Type) {
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
                bottomToolPopViewShowMangerPopListAction()
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
    
    // MARK: --- manager deg
    
    func touchCellWithHidenAdmangerPopView() {
        
        print("隐藏")
        if(self.admainManagerView.isHidden == true ){//显示动作
            if(self.admainManagerView.superview == nil){
                self.superview?.addSubview(self.admainManagerView);//此处加UI 最上层 才能不看见设置等bottombtn
            }
            self.admainManagerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
            self.admainManagerView.isHidden = false;//显示
            UIView.animate(withDuration: 0.3) {
                self.admainManagerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            };
            self.superview?.bringSubviewToFront(self.admainManagerView)//显示在最前
            self.admainManagerView.tableView.isUserInteractionEnabled = true;
            
            
        }else{//隐藏动作
            
            let  centerpoint : CGPoint = CGPoint(x: self.admainManagerView.frame.size.width/2, y: self.admainManagerView.frame.size.height/2)
            UIView.animate(withDuration: 0.3) {
                self.admainManagerView.center = CGPoint(x: centerpoint.x, y: centerpoint.y+SCREEN_HEIGHT)
            } completion: { finished in
                self.admainManagerView.isHidden = true;
            }
        }
        
    }
    
    
    
    // MARK: --- manager deg end
    // MARK: TCAnchorToolbarDelegate
    @objc func closeVC() {
        closeAlert = UIAlertController(title: nil, message: liveRoomLocalize("Demo.TRTC.LiveRoom.interactioninprogress"), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: liveRoomLocalize("Demo.TRTC.LiveRoom.subCancel"), style: .cancel, handler: { action in
        })
        let otherAction = UIAlertAction(title: liveRoomLocalize("Demo.TRTC.LiveRoom.subConfirm"), style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            guard let delegate = self.delegate else{
                return
            }
            self.topView.pauseLive()
            NotificationCenter.default.removeObserver(self)
            delegate.closeRTMP()
//            self.anchorViewController?.beautyViewModel?.applyDefaultSetting()
            let resultFrame = CGRect(x: UIScreen.main.bounds.size.width / 4.0,
                                     y: UIScreen.main.bounds.size.height / 3.0,
                                     width: UIScreen.main.bounds.size.width / 2.0,
                                     height: 222)
            self.resultView = TCPushShowResultView(frame: resultFrame,
                                                   resultData: self.topView,
                                                   backHomepage: {
                delegate.closeVC() //互动时间长度小提示框的返回按钮 离开直播间
            })
            self.clearView = UIView(frame: self.bounds)
            self.clearView!.backgroundColor = UIColor.black
            self.clearView!.alpha = 0.3
            self.addSubview(self.clearView!)
            self.addSubview(self.resultView!)
            self.superview?.bringSubviewToFront(self)
        })
        closeAlert!.addAction(cancelAction)
        closeAlert!.addAction(otherAction)
        anchorViewController!.present(closeAlert!, animated: true)
    }
    
    @objc func changeButtonStopPK() {
        closeBtn.isHidden = false
        pkView!.isHidden = false
        closeBtn.removeTarget(nil, action: nil, for: .allEvents)
        closeBtn.addTarget(self, action: #selector(quitRoomPKAction(_:)), for: .touchUpInside)
    }
    
    @objc func quitRoomPKAction(_ sender: UIButton?) {
        guard let liveRoom = liveRoom else { return }
        liveRoom.quitRoomPK(callback: { code, error in })
        closeBtn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
    }
    
    func getLocation(_ bulletView: TCMsgBarrageView?) -> CGFloat {
        guard let bulletView = bulletView else { return 0.0 }
        let view = bulletView.lastAnimateView
        let rect = view.layer.presentation()?.frame
        return (rect?.origin.x ?? 0.0) + (rect?.size.width ?? 0.0)
    }
    
    func onLogout(notice: Notification?) {
        closeInternal()
    }
    
    func closeInternal() {
        topView.pauseLive()
        NotificationCenter.default.removeObserver(self)
        guard let delegate = delegate else { return  }
        delegate.closeRTMP()
        delegate.closeVC()
    }
    
    func enableMix(disable: Bool) {
        btnMusic.isEnabled = disable
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return true
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
    
    func isAlready(inAudienceList model: TCMsgModel) -> Bool {
        guard let audienceTableView = audienceTableView else {
            return false
        }
        return audienceTableView.isAlready(inAudienceList: model)
    }
    
    func onEffectViewHidden(_ isHidden: Bool) {
        if isHidden {
            addGestureRecognizer(tap)
        }
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let allTouches = event.allTouches else { return }
        let touch = allTouches.first
        guard let touch = touch else { return }
        touchBeginLocation = touch.location(in: self)
        if !vPKPanel.isHidden {
            vPKPanel.isHidden = true
            closeBtn.isHidden = false
            addGestureRecognizer(tap)
        }
    }
}
