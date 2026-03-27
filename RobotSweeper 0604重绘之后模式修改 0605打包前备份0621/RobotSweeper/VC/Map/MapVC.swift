//
//  MapVC.swift
//  RobotSweeper
//
//  Created by 余莹 on 2018/2/16.
//  Copyright © 2018年 余莹. All rights reserved.
//

import UIKit
//监控遥控所需的扫地机xmpp相通的协议避免一对一的代理导致的error弹出框不出现在监控遥控页的问题
@objc protocol JkYkNeedMessageAndUserStatusDelegate{
 
    @objc optional func receiveXmppJkYkMessage(message:String)
    @objc optional func receiveXmppJkYkUserStatus(message:String)
    
}

class MapVC: BaseViewController,GCDAsyncUdpSocketDelegate,UIScrollViewDelegate,XmppManagerDelegate {//BaseViewController
    var delegatesJkYk: JkYkNeedMessageAndUserStatusDelegate?
    var strOfThisRobotName:String?
    var statuStr : String?//扫地机状态
    var sweeperStatusLabel : UILabel!
    
    var redPoint : UIView?//右rightItem的升级提示时的红点
    var wifiAndTextShowbtn:UIButton?//0110
    
    var wifiImgView : UIImageView?
    var wifiTimmerNum : Int = 0
    var wifiTimer:Timer?
    var singnOfWifiNum : Int = 0//wifi存下来的int类型数
    
    
    var mapScrollView : UIScrollView! //滚动视图
    var mapImageView : UIImageView!//地图view
    var trajectoryView : TrajectoryView! //地图所对应的轨迹view 20190416新增
    
    var mapSourceImg: UIImage?//地图源img 0124
    var locationImageView : UIImageView!//扫地机图标群
    var dingDianCleanImgView:UIImageView!//定点清扫状态的图标  tag设置为999用于定点选择的专扫定点切换时的显示隐藏。
    var dingDianCleanImgViewPoint:CGPoint! = CGPoint(x: 0, y: 0)//定点清扫图标的坐标存储point

    var homeImgView :UIImageView?//充电座
    
    var mapModeChoosePopV:MapModeChoosePopView?
    var mapStrengthChoosePopV:MapStrengthChoosePopView?
    
    var areaTimeCharge : NSString?
    
    var centerOfL:CGPoint?//蓝色图标父视图变成self.view的坐标
    var saveOffsetPoint:CGPoint?//缩放时时存储的偏移量
    
    var titleLabel:UILabel?//昵称 顶部导航栏的昵称修改
    
    /**
     
     厂商来定点模式显示文本部分
     */
    //模式弹窗的选择数组
  
    var arrOfModelStr = [NSLocalizedString("规划", comment: ""),NSLocalizedString("重点", comment: ""),NSLocalizedString("区域", comment: ""),NSLocalizedString("沿边", comment: ""),NSLocalizedString("4*4", comment: ""),NSLocalizedString("专扫", comment: "")]
    //模式按钮的选择按钮
    var arrOfModelBtnTitleStr = [NSLocalizedString("模式：规划",comment: ""),NSLocalizedString("模式：重点",comment: ""),NSLocalizedString("模式：区域",comment: ""),NSLocalizedString("模式：沿边",comment: ""),NSLocalizedString("模式：4*4",comment: ""),NSLocalizedString("模式：专扫", comment: "")] //初始view上的字符需要更改时更改掉
    
    var arrOfStrengthBtnTitleStr = [NSLocalizedString("力度：标准",comment: ""),NSLocalizedString("力度：静音",comment: ""),NSLocalizedString("力度：强力",comment: "")]

    //模式和力度的xmpp命令Arr
    var modelTransferProtocolArr = ["auto_clean","appoint_clean","map_zone_clean","followall_clean","auto_4_4_clean","area_allow"]//存储的指令前缀 1206修改ing 1212新增4*4清扫 20190313新增专扫区数据
    var liduTransferprotocolArr = ["clean_level 1","clean_level 2","clean_level 3"]
    
    var arrOfSaveModelAndLiDu:NSMutableArray? //当前模式和力度 发送时从此处取
    
    var routeViewIsDrawIng :Bool? //20190329定点处于绘画ing不做数据接收也不做数据info_map里的更新
    var routeViewIsDrawEndAndNotSaveNewInfoWaiteNum :Int = 0 //20190329定点处于绘画后，点击清扫按钮前，设置几秒钟的不接受c扫地机传来的新数据  wifiAction里定时-1 （非0+非清扫+旧数据有效）不可接受新数据 其余可接收新数据

    
    
    //路径规划View
    var routeView : RouteView?
    var routeBottomView : UIView!
    //定点初始化时的假点击点图标super==蓝色光标的super
    var routeViewSignImgV : UIImageView?
    
    var topView : MapTopView!
    var bottomView : MapBottommView!
    
    var mapHelper : MapHelper = MapHelper()
    
    //setListVc所用 在跳转升级页时也使用
    var slamCanUpV :Bool = false
    var fCanUpV :Bool = false
    
    
    //获取地图定时器，每3秒获取一次增量地图
    var mapTimer : Timer!
    var posTimer : Timer!
    
    var failTimer: Timer!

    //scrollView的缩放比例
    var mapScale : CGFloat = 1
    var quanpingSavemapScale : CGFloat = 1;
    //比例尺视图部分
    var labelOfScale : UILabel?
    var viewOfScale : UIView?
    var viewOfScaleRightV : UIView?
    var viewOfScaleLeftV: UIView?

    //测试用
    var directionView : DirectionView!//不用的方向盘
    
    var alertController : UIAlertController? //升级所用弹出框
    var alertNoticeOfWillSleepController:UIAlertController? //休眠提示弹出框
    var errorAlert : UIAlertController?//错误弹出框 1226改回原来的
    var errorPopView : ErrorPopView? //1224错误弹出框
   
    
    //虚拟墙
    var scrollisMoved:Bool = false
    var scrollisOncemove:Int = 0 //虚拟墙使用
    var v : V? //(虚拟墙线)
    var vWallQu:WallQuyuView? //(虚拟墙区域)
    var labelOfWallText:UILabel?
    var btnOfDeletAllXnq:UIButton?//虚拟墙清空按钮
    var btnOfXnqZhuanSaoQu:UIButton?//虚拟墙专扫区按钮
    var btnOfXnqJinSaoQu:UIButton?//虚拟墙禁扫区按钮
    var strOfWallLineInfoSave:NSString? = "" //虚拟墙信息'respone_line ...' （线）
    
    var  strOfWallAllowQuInfoSave:NSString? = "" //专扫区
    var  strOfWallForbidQuInfoSave:NSString? = "" //禁止区
    
    
    var goUpVc:Int = 0
    
    var scrollisOncemoveOfImgCenter:Int = 0 ///mapImg使用做center
    
    //重绘弹框
    var alertControllerOfChongHuaBtn : UIAlertController?//弹出框
    // 模式切换 自动 定点 区域 边角
    var alertControllerOfChangeBtn : UIAlertController?//模式切换弹出框
    // 力度切换 标准 安静 强力
    var alertControllerOfChangeLiDuBtn : UIAlertController?//力度切换弹出框
    
    var areaGetXmppArrOfMessage : NSArray?//得到的区域清扫xmpp数据仅处理成arr
    var timerOfAreaClear: Timer?
    var timerNumOfAreaClear:Int = 0
    
    //区域
    var isWillGetArreaClearBool:Bool = false//该app不接受其他app请求时返回来的区域数据 ture才接受
    var areaClearV : AreaClearView?//显示的区域清扫view
    var areaArrOfSaveTapInfo :NSMutableArray?//区域点击存放的数据最多7个区域元素
    var areaArrOfSaveImgData :NSMutableArray?//区域img对应arr存放的数据,方便tap取值判断是哪种颜色
   //code部分
    ////第一任厂商的code消息部分初始和总timer总状态
    //codeerror用到的数组
    var arrOfCodeErrorNumStr :NSMutableArray?
    var arrOfCodeErrorInfoStr :NSMutableArray?
    var codeErrTimer : Timer?//当前扫地机传来的是否存在codeerrType定时切换
    var codeErrTypeTimerBool : Bool = false;//当前扫地机传来的是否存在 ,true则扫地机存在错误码
    
    ////第二任厂商的code消息部分初始化
    var TwoCodeIMsgArr:NSMutableArray?
    var TwoCodeEMsgArr:NSMutableArray?//判断是否为二厂codeE的集合，不对它做任何操作，仅用于判断。
    var TwoCodeEMsgChangeArr:NSMutableArray?//判断弹出框的arr,要增删

    let mapInfoSerialqueue = OperationQueue() //地图页数据接收
    
    //漂浮按钮
    var liDuBtn:UIButton?
    var moShiBtn:UIButton?
    var chongHuaBtn:UIButton?
    var dingWeiBtn:UIButton?//定位报语音非定点清扫
    var quanPingBtn:UIButton?
    
    var romtePiaofuView:RomtePiaofuView?//20190517监控漂浮按钮

//    var viewOfChonghuiGray:UIView? //1225灰色重绘遮挡v
    
    //点击某按钮后不接受某数据的延时时间
    var clearnInfoTimerNum:Int=0//清扫按钮点击后的clearninfo数据不接收的延时；清扫按钮力度模式按钮暂缓change-6s 时间-1放在刷新Wi-Fi的定时中
    var huichongInfoTimerNum:Int=0//回充按钮点击后的回充类数据不接受的延时；回充按钮暂缓change-3s时间-1放在刷新Wi-Fi的定时中
    var xuniqiangInfoTimerNum:Int=0//回充按钮点击后的回充类数据不接受的延时；回充按钮暂缓change-3s时间-1放在刷新Wi-Fi的定时中
    
    //1206新增关机充电状态
    var offRobotAndCharging:Bool = false //关机充电状态
    
    var huichongStatyThereHaveBeen:Bool = false //0103 本次点击清扫按钮前出现过 回充状态
    var remoteControlPopView:RemoteControlPopView? //20190318 遥控方向盘弹出v
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad_mapvc")
        self.view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        self.getTypeOfXmlChange()//xml+请求监控
        self.initNavTitleView()
        self.setRightBarItem()
        
        //底部顶部
        bottomView = MapBottommView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - _height(103), width: SCREEN_WIDTH, height: _height(103)))
        bottomView.backgroundColor = UIColor.white
         bottomView.clearnBtn.addTarget(self, action: #selector(bottommBtnAction(sender:)), for: UIControlEvents.touchUpInside)
         bottomView.chargeBtn.addTarget(self, action: #selector(bottommBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        bottomView.chargeBtn.imageView?.tintColor = DataManager.shareDataManager.colorOfMainType//回充按钮初始有主题色
         bottomView.yuYueBtn.addTarget(self, action: #selector(bottommBtnAction(sender:)), for: UIControlEvents.touchUpInside)
         bottomView.xuNiQiangBtn.addTarget(self, action: #selector(bottommBtnAction(sender:)), for: UIControlEvents.touchUpInside)
         NotificationCenter.default.addObserver(self, selector: #selector(xuniqiangInfoTimerNumBeginMax), name: NSNotification.Name(rawValue: "xiniqiangNotificationSendAllLine"), object: nil) //虚拟墙发送给机器数据了的通知注册
         NotificationCenter.default.addObserver(self, selector: #selector(xuniqiangFQuInfoTimerNumBeginMax), name: NSNotification.Name(rawValue: "xiniqiangNotificationSendFQuInfoStr"), object: nil) //虚拟墙发送给机器数据了的通知注册
         bottomView.jiankongBtn.addTarget(self, action: #selector(bottommBtnAction(sender:)), for: UIControlEvents.touchUpInside)
       
        //bottomVLabel ges 0121新增手势
        bottomView.gesOfclearnL.addTarget(self, action: #selector(bottommLabelAction(ges:)) )
        bottomView.gesOfchargeL.addTarget(self, action: #selector(bottommLabelAction(ges:)) )
        bottomView.gesOfyuYueL.addTarget(self, action: #selector(bottommLabelAction(ges:)) )
        bottomView.gesOfxuNiQiangL.addTarget(self, action: #selector(bottommLabelAction(ges:)) )
        bottomView.gesOfjiankongL.addTarget(self, action: #selector(bottommLabelAction(ges:)) )
        self.view.addSubview(bottomView)
        
        topView = MapTopView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: _height(80)))
        topView.backgroundColor = UIColor.white
        self.view.addSubview(topView)
        
       
        //地图
        self.initMapView()
   
        //虚拟墙
        self.xuniqiangVofBtnInit()
        mapInfoSerialqueue.maxConcurrentOperationCount = 1 //地图数据处理串行（最大操作队列是1则为窜行>1则为并行）
        
        //code初始化
        self.codeErrorOfArrInit()
        //模式部分和力度部分的 显示文字／弹出框文字／点击命令
        self.arrOfSaveModelAndLiDuInit()
        //漂浮按钮初始化
        self.piaofuBtn()
        self.initJiankongPiaofubtn()//20190517监控漂浮按钮
  
    }
    
    //MARK:____虚拟墙之相关漂浮按钮初始
    func xuniqiangVofBtnInit(){
        
        //新增清除全部虚拟墙按钮
        btnOfDeletAllXnq = UIButton(type: UIButtonType.custom);
        btnOfDeletAllXnq?.setTitle(NSLocalizedString("清除禁扫区", comment: ""), for: UIControlState.normal)
        btnOfDeletAllXnq?.frame = CGRect(x: 10, y: SCREEN_HEIGHT-bottomView.height()-50, width: 120, height: 35)
        btnOfDeletAllXnq?.addTarget(self, action: #selector(deletAllXnq), for: UIControlEvents.touchUpInside)
        self.xuniqiangBtnColorInitSet(btn: btnOfDeletAllXnq!)
//
        //虚拟墙禁扫区按钮
        btnOfXnqJinSaoQu = UIButton(type: UIButtonType.custom);
//        btnOfXnqJinSaoQu?.setTitle(NSLocalizedString("禁扫区", comment: ""), for: UIControlState.normal)
        btnOfXnqJinSaoQu?.setTitle(NSLocalizedString("添加禁扫区", comment: ""), for: UIControlState.normal)
        btnOfXnqJinSaoQu?.frame = CGRect(x: 10, y: SCREEN_HEIGHT-bottomView.height()-50-50, width: 120, height: 35)
        self.xuniqiangBtnColorInitSet(btn: btnOfXnqJinSaoQu!);
        btnOfXnqJinSaoQu?.addTarget(self, action: #selector(btnOfXnqJinSaoQuAction), for: UIControlEvents.touchUpInside)
 
        //虚拟墙提示文本label
        labelOfWallText = UILabel(frame: CGRect(x: 20, y: topView.height()+64, width: SCREEN_WIDTH-40, height: 60+40))
 
        labelOfWallText?.text = NSLocalizedString("当前为编辑禁扫区状态：\n最多可以绘制三个禁扫区。", comment: "")
        
        labelOfWallText?.font = UIFont.systemFont(ofSize: 13)
        labelOfWallText?.textColor = DataManager.shareDataManager.colorOfMainType;
        labelOfWallText?.textAlignment = NSTextAlignment.center
        labelOfWallText?.numberOfLines = 0
        labelOfWallText?.isHidden = true
        self.view.addSubview(labelOfWallText!) //最后添加放于顶层
        
    }
    func xuniqiangBtnColorInitSet(btn:UIButton){
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.titleLabel?.textAlignment = NSTextAlignment.left
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        btn.setTitleColor(DataManager.shareDataManager.colorOfMainType, for: UIControlState.normal)
        btn.tintColor = DataManager.shareDataManager.colorOfMainType;
        btn.backgroundColor = UIColor.white
        btn.layer.shadowOffset = CGSize(width: 1, height: 1)
        btn.layer.shadowOpacity = 1
        btn.layer.shadowRadius = 1
        btn.layer.shadowColor = UIColor.lightGray.cgColor
        btn.isHidden = true
        self.view.addSubview(btn)
    }
    //MARK:____虚拟墙之线7条
    func oldVofXuniqiangLine(){
        
    }
    //MARK:____虚拟墙之清扫专区禁止区 按钮部分
    func newVofXuniqiangQUYu(){
        
    }
    //MARK:____重新获取版本xml
    func getTypeOfXmlChange(){
        
        MapVcGetUpXml.getNewXml()////xml+请求监控

    }

    //MARK:____mapScrollV mapImgV homeImgV locationImageView V.
    func initMapView(){
        
        mapScrollView = UIScrollView(frame: CGRect(x: 0, y: topView.bottomY(), width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - topView.height() - bottomView.height()))
        mapScrollView.delegate = self
      
        mapScrollView.minimumZoomScale = 0.5
        mapScrollView.maximumZoomScale = 6.0
        
        mapScrollView.delaysContentTouches = false
        mapScrollView.autoresizesSubviews = false
        mapScrollView.contentSize = CGSize(width: SCREEN_HEIGHT*2, height: SCREEN_HEIGHT*2)
        mapScrollView.backgroundColor = UIColor.clear
        mapScrollView.decelerationRate = 0.01;
//        mapScrollView.bounces = false//滚动的反弹
        mapScrollView.bouncesZoom = false //缩放的反弹
        //20190429 回弹时轨迹view会出现闪烁移动的问题
        
        self.view.addSubview(mapScrollView)
        //预设的img要大2倍
        mapImageView = UIImageView(frame: CGRect(x: 0, y: topView.bottomY(), width: 0, height: 0))
//        mapImageView.backgroundColor = UIColor.blue
        mapImageView.autoresizesSubviews = false
        mapImageView.isUserInteractionEnabled = true
        mapImageView.layer.shouldRasterize = true
        mapScrollView.addSubview(mapImageView)
        
        //
        if DataManager.shareDataManager.mapImgBeforeData != nil {
            mapImageView.image =  UIImage(data: DataManager.shareDataManager.mapImgBeforeData!)
            print("info_map-----init");
            mapImageView.frame = CGRect(x: 0, y: 0, width: CGFloat(DataManager.shareDataManager.mapRightEnd - DataManager.shareDataManager.mapLeftEnd + 1)*mapScale, height: CGFloat(DataManager.shareDataManager.mapTopEnd - DataManager.shareDataManager.mapBottomEnd + 1)*mapScale)

        }
        
        //
        //20190416轨迹view
        trajectoryView = TrajectoryView.init(frame: mapImageView.frame)
        mapScrollView.addSubview(trajectoryView)
        mapScrollView.bringSubview(toFront: trajectoryView!)
        
        //充电桩
        homeImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: _width(18), height: _width(18)))
        homeImgView?.image = UIImage(named: "chongdianzuo")//充电桩
        mapScrollView.addSubview(homeImgView!)
        mapScrollView.bringSubview(toFront: homeImgView!)
        homeImgView?.isHidden = true
        
        //扫地机图标
//        locationImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: _width(18), height: _width(18)))//20190410更改宽高
        locationImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: _width(18*1.5), height: _width(18*1.5)))
       
        locationImageView.image = SkinManager.skin_imageWithName(imageName: "robotLocation")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        locationImageView.tintColor = DataManager.shareDataManager.colorOfMainType
        mapScrollView.addSubview(locationImageView)//关系到坐标计算或者图片缩放模糊轻易不去动它
        mapScrollView.bringSubview(toFront: locationImageView)
        let aniView = LocationAniView(frame: CGRect(x: 0, y:0, width: locationImageView.width(), height: locationImageView.height())) //20190410修改fram

//        let aniView = LocationAniView(frame: CGRect(x: _width(3), y: _height(3), width: locationImageView.width() + _width(6), height: locationImageView.height() + _height(6))) //20190410修改fram
        locationImageView.addSubview(aniView)
        
        //定点清扫状态的图标
        dingDianCleanImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: _width(10), height: _height(12)))
        dingDianCleanImgView?.image = UIImage(named: "dingdiandasao")//充电桩
        mapScrollView.addSubview(dingDianCleanImgView!)
        mapScrollView.bringSubview(toFront: dingDianCleanImgView!)
        dingDianCleanImgView?.tag = 999
        dingDianCleanImgView?.isHidden = true//初始隐藏，在定点时出现
        
        //虚拟墙(线) 初始化
        if v==nil {
            v = V(frame: CGRect(x: 0, y: 0, width:SCREEN_HEIGHT*2, height: SCREEN_HEIGHT*2))
            v?.isWallCanDraw(false)
            mapScrollView.addSubview(v!)
//            self.view?.bringSubview(toFront: v!)
            v?.isUserInteractionEnabled = true
            v?.center = mapImageView.center;
            v?.setNeedsDisplay()
        }
        //刷新虚拟墙UI数据
        self.getInfoOfThisRobotWallLine(strOfWallLineInfo: strOfWallLineInfoSave!) //1229新增
       //虚拟墙(区域) 初始化0129新增 放在Vline之上
        if(vWallQu==nil){
            vWallQu = WallQuyuView(frame: CGRect(x: 0, y: 0, width:SCREEN_HEIGHT*2, height: SCREEN_HEIGHT*2))
            mapScrollView.addSubview(vWallQu!)
            vWallQu?.isUserInteractionEnabled = true
            vWallQu?.center = mapImageView.center;
            vWallQu?.vofxuniqingLineView = v
//            self.view?.bringSubview(toFront: vWallQu!)
            vWallQu?.setNeedsDisplay()
        }
        if ((v != nil) && (vWallQu != nil)) {//0130
            v?.vbtnInfoBlock = { deletInfodic in ()
                self.vWallQu?.getBtnInfoDic(deletInfodic) //更新deletbtn数据
            }
        }
        if vWallQu != nil {
//            self.getInfoOfThisRobotWallQuyu(strOfWallQuyuInfo: strOfWallAllowQuInfoSave!)
            self.getInfoOfThisRobotWallQuyu(strOfWallQuyuInfo: strOfWallForbidQuInfoSave!)
        }
        
        
        
       
        
        
    }
    //MARK:____________定点清扫的选择界面BtnView
    func initRouteBottomView(){
        
        routeBottomView = UIView(frame: CGRect(x: bottomView.originX(), y: bottomView.originY(), width: bottomView.width(), height: bottomView.height()))
        routeBottomView.backgroundColor = bottomView.backgroundColor
        self.view.addSubview(routeBottomView)
        
        var cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: _originX(20), y: _originY(40), width: _width(100), height: _height(30))
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelBtn.setTitle(NSLocalizedString("取消", comment: ""), for: .normal)
        cancelBtn.setImage(SkinManager.skin_imageWithTypeAndName(imageName: "map_quxiao"), for: UIControlState.normal)
        cancelBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        cancelBtn.titleLabel?.textAlignment = .center
        cancelBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        cancelBtn = ToolOfBasic.btnTextBottomAndImgTop(cancelBtn)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        routeBottomView.addSubview(cancelBtn)
        
        var saveBtn = UIButton(type: .custom)
        saveBtn.frame = CGRect(x: SCREEN_WIDTH - cancelBtn.width() - cancelBtn.originX(), y: _originY(40), width: _width(100), height: _height(30))
        saveBtn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        saveBtn.setTitle(NSLocalizedString("保存", comment: ""), for: .normal)
        saveBtn.setImage(SkinManager.skin_imageWithTypeAndName(imageName: "map_queren"), for: UIControlState.normal)
        saveBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        saveBtn.titleLabel?.textAlignment = .center
        saveBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        saveBtn = ToolOfBasic.btnTextBottomAndImgTop(saveBtn)
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        routeBottomView.addSubview(saveBtn)

    }
    
    //MARK:___________初始化titleView
    func initNavTitleView(){
    
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: _width(155), height: _height(40)))
        titleView.backgroundColor = UIColor.clear
        
        
        wifiImgView = UIImageView(frame: CGRect(x: 0, y: 20, width: _width(15), height: _height(15)))//wifiimgView 需要保留 但不赋值 颜色值 
//        wifiImgView?.backgroundColor = UIColor.green
        self.newWifiImgOfColorNum(num: 3)
        wifiImgView?.contentMode = UIViewContentMode.scaleAspectFit
        wifiImgView?.layer.cornerRadius = 7.5
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: _width(155), height: _height(20)))
        titleLabel?.textColor = UIColor.black
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel?.textAlignment = .center
        
        //titleL文字部分
        //之前用的通知 只能在同一个线程里post+接受 获取的昵称被存储到单利
        let jid = ShareUser.sharedUserInfo().userMode.nowRobotJid
        var nameStrOfThisRobot:String? = ""
        for dicOfRobot in UserTool.shared().listOfRobotsArr {
            if (dicOfRobot as! NSDictionary).object(forKey: "eqOpfJid") as? String == jid  {
                nameStrOfThisRobot = (dicOfRobot as! NSDictionary).object(forKey: "nickName") as? String
            }
        }
        if (nameStrOfThisRobot=="") || (nameStrOfThisRobot == nil) {
            nameStrOfThisRobot = "robot"
        }
        titleLabel?.text = nameStrOfThisRobot
        
        
        titleView.addSubview(titleLabel!)
        titleView.addSubview(wifiImgView!)
        
        sweeperStatusLabel = UILabel(frame: CGRect(x: 0, y: titleLabel!.bottomY() + _height(4), width: titleLabel!.width(), height: _height(15)))
        sweeperStatusLabel.textColor = UIColor.gray
        if #available(iOS 8.2, *) {
            sweeperStatusLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
        } else {
            // Fallback on earlier versions
            sweeperStatusLabel.font = UIFont.systemFont(ofSize: 12)
        }
        
        sweeperStatusLabel.textAlignment = .center
        titleView.addSubview(sweeperStatusLabel)
        
        
        //
        wifiAndTextShowbtn =  UIButton(frame: sweeperStatusLabel.frame);
//   sweeperStatusLabel      CGRect(x: 0, y: titleLabel!.bottomY() + _height(4), width: titleLabel!.width(), height: _height(15))
        wifiAndTextShowbtn = UIButton(frame:CGRect(x: -20, y: titleLabel!.bottomY() + _height(4), width: titleLabel!.width()+20, height: _height(15))) //20文本往中心靠
        wifiAndTextShowbtn?.isUserInteractionEnabled = false;
        wifiAndTextShowbtn?.titleLabel?.text = sweeperStatusLabel.text;
        wifiAndTextShowbtn?.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        wifiAndTextShowbtn?.setTitleColor(UIColor.gray, for: .normal)
        wifiAndTextShowbtn?.titleLabel?.font = sweeperStatusLabel.font //字体大小
        wifiAndTextShowbtn?.titleLabel?.adjustsFontSizeToFitWidth = true//长度自适应
        
        titleView.addSubview(wifiAndTextShowbtn!);
        //
        self.navigationItem.titleView = titleView
        wifiTimer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(wifiTimerNumChangeAction), userInfo: nil, repeats: true)
        
        // sweeperStatusLabel.textColor = UIColor.clear//视觉隐藏不需要更换text赋值
        sweeperStatusLabel.isHidden = true//需要用label的文本更新btn label仅仅隐藏
        if statuStr == "available" {
            sweeperStatusLabel.text = NSLocalizedString("在线中", comment: "");
            wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            self.newWifiImgOfColorNum(num: 2)
            
        }else{
            sweeperStatusLabel.text = NSLocalizedString("离线中", comment: "")
            wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            self.newWifiImgOfColorNum(num: 0)
        }
  
    }
    func newWifiImgOfColorNum(num:Int) {//0 灰 1 红 2 黄 3 绿
        var imgcolor:UIImage = UIImage(named:"mapWifiyuan_gray")!
        if (num==1) {
            imgcolor = UIImage(named:"mapWifiyuan_red")!
        }else if (num==2){
       
            imgcolor = UIImage(named:"mapWifiyuan_yollow")!
        }else if (num==3){
  
            imgcolor = UIImage(named:"mapWifiyuan_green")!

        }else{//0灰色
            imgcolor = UIImage(named:"mapWifiyuan_gray")!
        }
       wifiAndTextShowbtn?.imageView?.image = imgcolor
      wifiAndTextShowbtn?.setImage(imgcolor, for: UIControlState.normal)
        
    }
    
    //MARK:_______昵称更新
    func changeNickNameOfwillAp(){
         //之前用的通知 只能在同一个线程里post+接受 通知有bug 现获取的昵称被存储到单利
        let jid = ShareUser.sharedUserInfo().userMode.nowRobotJid
        var nameStrOfThisRobot:String? = ""
        for dicOfRobot in UserTool.shared().listOfRobotsArr {
            if (dicOfRobot as! NSDictionary).object(forKey: "eqOpfJid") as? String == jid  {
                nameStrOfThisRobot = (dicOfRobot as! NSDictionary).object(forKey: "nickName") as? String
            }
        }
        if (nameStrOfThisRobot=="") || (nameStrOfThisRobot == nil) {
            nameStrOfThisRobot = "扫地机器人"
        }
        titleLabel?.text = nameStrOfThisRobot
        
    }
 
   
    
    //MARK:————————虚拟墙发送了数据 此时num=max 虚拟墙线
    func xuniqiangInfoTimerNumBeginMax(notic:Notification) {
        xuniqiangInfoTimerNum = 5
        //1229返回line数据 新增的字段
        strOfWallLineInfoSave = (notic.object as! NSString  )
        print("xuniqiangInfoNotice str=\(strOfWallLineInfoSave),notic =\(strOfWallLineInfoSave)")
        
    }
    func xuniqiangFQuInfoTimerNumBeginMax(notic:Notification) {
//        xuniqiangInfoTimerNum = 5//不做数值 因为回调很快
   
        var strOfNotice:String =  (notic.object as! String)
        if strOfNotice.contains("Notification") {
            
           xuniqiangInfoTimerNum = 5//
            let arrOfS:NSArray = strOfNotice.components(separatedBy: " ") as NSArray
            let arrOfStrn:NSMutableArray = NSMutableArray.init(array: arrOfS);
            arrOfStrn.removeLastObject() //末尾拼接的数据
            strOfNotice = arrOfStrn.componentsJoined(by: " ")
            strOfWallForbidQuInfoSave = strOfNotice as NSString as NSString
            print("xuniqiangFQuInfoTimerNumBeginMax str=\(strOfWallForbidQuInfoSave)")
        }
        
        
    }
    //MARK:——————wifiTimerNumChangeAction———wifiTimer—————定点清扫的假点击点的删除部分——击某按钮后不受某信息的延时-1部分 数据处理有多种类型在此
    func wifiTimerNumChangeAction() {
        
        /**点击某按钮后不受某信息的延时-1部分*/
        if(clearnInfoTimerNum > 0){
            clearnInfoTimerNum = clearnInfoTimerNum-1
        }
        if(huichongInfoTimerNum > 0){
            huichongInfoTimerNum = huichongInfoTimerNum-1
        }
        if(xuniqiangInfoTimerNum > 0){
            xuniqiangInfoTimerNum = xuniqiangInfoTimerNum-1
        }
        /***/
        if routeViewIsDrawEndAndNotSaveNewInfoWaiteNum > 0 {//20190329专扫区
            routeViewIsDrawEndAndNotSaveNewInfoWaiteNum = routeViewIsDrawEndAndNotSaveNewInfoWaiteNum-1
        }
        
        /**定点清扫的假点击点的删除部分*/
//        if (routeView != nil) && (routeView?.targetBtn != nil) {
//            self.deletRouteViewSignImgV()
//        }
        if (routeViewIsDrawIng==true) && (routeView?.targetBtn != nil) {
            self.deletRouteViewSignImgV()
        }
        //wifi部分
         wifiTimmerNum+=1;
        if wifiTimmerNum<=10{
           //Wi-Ficolor
            //船型开关状态
            if(DataManager.shareDataManager.robotOpenOrNo != "0"){
                if singnOfWifiNum<=25 {
//                    wifiImgView?.backgroundColor = UIColor.red
                    self.newWifiImgOfColorNum(num: 1)
                    
                }else if(singnOfWifiNum<75){
//                    wifiImgView?.backgroundColor = UIColor.yellow
                    self.newWifiImgOfColorNum(num: 2)
                    
                }else{//满格
//                    wifiImgView?.backgroundColor = UIColor.green
                    self.newWifiImgOfColorNum(num: 3)
                    
                }
            }
            //text
            if ((sweeperStatusLabel.text?.contains(NSLocalizedString("离线中", comment: "")))! && !DataManager.shareDataManager.robotOpenOrNo.isEqual(to: "0")){//在小于5的Wi-Fi时 在线 但有船型开关->船型开关状态存在且非0 不存在是置了“”
                 sweeperStatusLabel.text = NSLocalizedString("在线中", comment: "");
                 wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            }else{
                
            }
            
        }else if(wifiTimmerNum==11){
            if(!DataManager.shareDataManager.robotOpenOrNo.isEqual(to: "0")){
//                 wifiImgView?.backgroundColor = UIColor.red
                self.newWifiImgOfColorNum(num: 1)
                
            }

        }else{
           
            
//            wifiImgView?.backgroundColor = UIColor.gray
             self.newWifiImgOfColorNum(num: 0)
            sweeperStatusLabel.text = NSLocalizedString("离线中", comment: "")
             wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
             //0 灰 1 红 2 黄 3 绿

            return
        }
         wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
       
    }
    
    //MARK:____________ RightBarItem
    func setRightBarItem(){
        
        let rightBtn = UIButton(type: UIButtonType.custom)
        rightBtn.frame = CGRect(x: 00, y: 0, width: 54, height: 44)
        rightBtn.setImage(SkinManager.skin_imageWithName(imageName: "zhinan"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBarAction(rightBtn:)), for: UIControlEvents.touchUpInside)
        rightBtn.isSelected = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
    
    func setRightItemRedPoint(boolOfRed:Bool) {
        if boolOfRed{//需要显示红点
            if redPoint == nil{
                redPoint = UIView(frame: CGRect(x:54*0.5+5, y: 44*0.5-10, width: 10, height: 10))
                redPoint?.backgroundColor = UIColor.red
                redPoint?.layer.cornerRadius = 5
            self.navigationItem.rightBarButtonItem?.customView?.addSubview(redPoint!);
                
            }else{
                //不做操作
            }
        }else{//去掉红点
            if redPoint == nil{
                //不做操作
            }else{
                //删除
                redPoint?.removeFromSuperview()
                redPoint = nil
            }
        }
    }
    
    func rightBarAction(rightBtn:UIButton){//1212修改
        
        let setListVc = RobotSetViewController()
        setListVc.isCanUpOfSoftware = slamCanUpV
        setListVc.isCanUpOfhardware = fCanUpV
        if( (self.areaTimeCharge != nil)&&(self.areaTimeCharge?.length != 0) && (self.areaTimeCharge?.contains("|"))!){
            setListVc.areaTimeChargeStr = self.areaTimeCharge! as String
        }
        
       XmppManager.shareXmppManager.sendMessageToRobot(message: "request_robot_info")
        self.navigationController?.pushViewController(setListVc, animated: true)
    }
    
    //MARK:__________________________________________viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear_mapvc")
        self.changeNickNameOfwillAp()//更换昵称后需要刷通知不响应暂时放于此处用数组中的数据更新  //之前用的通知 只能在同一个线程里post+接受 获取的昵称被存储到单利
        XmppManager.shareXmppManager.delegates = self
       self.initSendXmppOfCAndMAndInfo()
       //升级相关更新
        goUpVc = 0
        //codeErr
        self.codeErrTypeChangeTimerInit() //每次回来更新
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:====保存路径规划点定点清扫重点清扫 确认
    func saveAction(){
        
        if routeView?.switchOfDingDianView?.isOn == true{
            self.dingDianSaveOfZhuanSaoQuYU()
            routeViewIsDrawEndAndNotSaveNewInfoWaiteNum = 5;//设置为5次 wifiAction里定时-1为0后可接受新数据+非清扫+旧数据有效时处理
            
        }else{
            self.dingDianSaveOfDian()
        }
        routeViewIsDrawIng = false;
        
    }
    
    func dingDianSaveOfDian() {
        
        if routeView?.targetBtn == nil{ //没有任何点时 使用扫地机所在坐标 扫地机原地清扫
            let x = DataManager.shareDataManager.posX
            let y = DataManager.shareDataManager.posY
            let strOfAppoint_clean = "appoint_clean \(Int(x)) \(Int(y))"
            arrOfSaveModelAndLiDuChange(moshiStr: strOfAppoint_clean, liduStr: "")
            moShiBtn?.setTitle(arrOfModelBtnTitleStr[1], for: UIControlState.normal)
            
            self.codeErrorOfAddCDXWithCleanBtnTap()
            
            routeView?.targetBtn?.isHidden = true
            bottomView.isHidden = false
            routeView?.removeFromSuperview()
            routeBottomView.removeFromSuperview()
            self.piaofuBtnShow()
            //显示定点图标
            dingDianCleanImgView.isHidden = false
            dingDianCleanImgViewPoint = CGPoint(x: x, y: y)
            dingdianCenter(centerX: dingDianCleanImgViewPoint.x, centerY: dingDianCleanImgViewPoint.y)
            
            print("dingDianCleanImgView.center==\(dingDianCleanImgView)")
        }else{//有点时
            
            //点击点 基于self.v
            let btnx :CGFloat = routeView!.targetBtn!.center.x
            let btny :CGFloat = routeView!.targetBtn!.center.y
            //移动相对坐标 基于滚动视图
            let xm :CGFloat = btnx + mapScrollView.contentOffset.x
            let ym :CGFloat = btny + mapScrollView.contentOffset.y - topView.bottomY()
            
            
            var centerx :CGFloat =  mapScrollView.frame.size.width/2
            var centery :CGFloat =  mapScrollView.frame.size.height/2
            if (mapScrollView.contentOffset.x == 0 && mapScrollView.contentOffset.y == 0){
                //没移动过的中心点是在frame上
                centerx = mapScrollView.frame.size.width/2
                centery = mapScrollView.frame.size.height/2
            }else{
                //移动过的中心点是在内容视图中心
                centerx = mapScrollView.contentSize.width > mapScrollView.frame.size.width ? mapScrollView.contentSize.width/2 : mapScrollView.frame.size.width/2
                centery = mapScrollView.contentSize.height > mapScrollView.frame.size.height ? mapScrollView.contentSize.height/2 : mapScrollView.frame.size.height/2
            }
            //图片的center不为00 要用图片的4个参数计算坐标原点进行变动
            let wImg = DataManager.shareDataManager.mapRightEnd-DataManager.shareDataManager.mapLeftEnd
            let hImg = DataManager.shareDataManager.mapTopEnd-DataManager.shareDataManager.mapBottomEnd
            
            let xC = CGFloat(DataManager.shareDataManager.mapRightEnd) - CGFloat(wImg)*0.5
            let yC = CGFloat(DataManager.shareDataManager.mapTopEnd) - CGFloat(hImg)*0.5
            ///-----
            /***/
            //            var x :CGFloat = xm-centerx+xC //xm-centerx是相对于img中心的坐标之后+xc是基于img00点坐标 y相负
            //            var y :CGFloat = ym-centery-yC
            
            //            +xC -yC
            //            y = -y//0114
            
            
            //缩放相对坐标倍数基本影响 倍数关系
            var x :CGFloat = xm-centerx
            var y :CGFloat = -ym+centery //0114
            x = x/mapScale + xC
            y = -y/mapScale - yC
            y = -y//0114
            
            let strOfAppoint_clean = "appoint_clean \(Int(x)) \(Int(y))"
            arrOfSaveModelAndLiDuChange(moshiStr: strOfAppoint_clean, liduStr: "")
            moShiBtn?.setTitle(arrOfModelBtnTitleStr[1], for: UIControlState.normal)
            
            self.codeErrorOfAddCDXWithCleanBtnTap()
            
            routeView?.targetBtn?.isHidden = true
            bottomView.isHidden = false
            routeView?.removeFromSuperview()
            routeBottomView.removeFromSuperview()
            self.piaofuBtnShow()
            ////map重新请求
            dingDianCleanImgView.isHidden = false
            
            dingDianCleanImgViewPoint = CGPoint(x: x, y: y)//0114
            dingdianCenter(centerX: dingDianCleanImgViewPoint.x, centerY: dingDianCleanImgViewPoint.y)
            print("dingDianCleanImgView.center==\(dingDianCleanImgView)  移动相对坐标 基于滚动视图\(xm) \(ym) strOfAppoint_clean=\(strOfAppoint_clean)")
            
        }
        self.deletRouteViewSignImgV()
        

    }
    //MARK:______________专扫区使用的转换str方法，处理y轴的top bottom 因为发送接收的xmpp和用于view更新的不一样
    func getXmppNewAreaAllowStrOfYChange(strOfOldAreaAllowStr:String)->String {
//        strOfViewAreaAllowStr
        
        let arrOfGetStr:NSArray = strOfOldAreaAllowStr.components(separatedBy: " ") as NSArray
        if (arrOfGetStr.count<6 || !(strOfOldAreaAllowStr.contains("area_allow"))){
            return "area_allow 0 0 0 0 0";
        }
        let arrOfNewInfo:NSMutableArray = NSMutableArray.init()
        arrOfNewInfo.add(arrOfGetStr[0])
        arrOfNewInfo.add(arrOfGetStr[1])
        arrOfNewInfo.add(arrOfGetStr[2])
        arrOfNewInfo.add(arrOfGetStr[5])
        arrOfNewInfo.add(arrOfGetStr[4])
        arrOfNewInfo.add(arrOfGetStr[3])
        
        let strOfNew = arrOfNewInfo.componentsJoined(by: " ")
        
        return strOfNew;
        
    }
    //MARK:________专扫区存储的按钮后续
    func dingDianSaveOfZhuanSaoQuYU(){//存储专扫区数据和更新UI 这是专扫区确认按钮的部分
//        routeView?.strOfRouteSaveAllowWall
//        if routeView == nil {
         if routeViewIsDrawIng == false {
            return
        }
        var strOfWillSendZhuanSaoQu:String = (routeView?.strOfRouteSaveAllowWall)!
        if strOfWillSendZhuanSaoQu.count <= 0 {
            strOfWillSendZhuanSaoQu = "area_allow 0 0 0 0 0"
        }
        if (strOfWillSendZhuanSaoQu.contains("0 0 0 0") || strOfWillSendZhuanSaoQu == "area_allow") {
            //数据错误的情况
            return;
        }else{
            //发送 //不发送 在清扫按钮后发送
            
//             XmppManager.shareXmppManager.sendMessageToRobot(message: strOfWillSendZhuanSaoQu)
        }
       
    
       
        moShiBtn?.setTitle(arrOfModelBtnTitleStr[5], for: UIControlState.normal) //模式按钮文本
        //存储的willsend数据
        //top和bottom交换位置后发送 +接收 201903270328g待改
//        strOfWallAllowQuInfoSave = strOfWillSendZhuanSaoQu as NSString //uiview用的str
        let newxmppStr = self.getXmppNewAreaAllowStrOfYChange(strOfOldAreaAllowStr: strOfWillSendZhuanSaoQu) //xmpp发送的str
        strOfWallAllowQuInfoSave = newxmppStr as NSString //uiview用的str
        self.arrOfSaveModelAndLiDuChange(moshiStr:newxmppStr, liduStr: "")
        if(vWallQu != nil){
            vWallQu?.allowedXmppStr = strOfWallAllowQuInfoSave as! String
            vWallQu?.getQuyuXmppStr(strOfWallAllowQuInfoSave as! String)
        }
        
        
        routeView?.targetBtn?.isHidden = true
        bottomView.isHidden = false
        self.piaofuBtnShow()
        //
        routeView?.sendXuNiQiangOKXmppStr(strOfOKXmpp: strOfWillSendZhuanSaoQu)//
        routeView?.removeFromSuperview()
        routeBottomView.removeFromSuperview()
        self.deletRouteViewSignImgV()
 
        
    }
    //接收到专扫数据，只处理mapSaveStr和调用虚拟墙更新ui 此处的str是用于view的str 20190401处理info_map更新数据area111
    func saveZhuanSaoAndNoRouViewTOUPdateXuNiQiangUi(strOfZhuanSaoXmpp:String) {
        if (routeViewIsDrawIng == true){
            return;//绘画状态
        }
        strOfWallAllowQuInfoSave = strOfZhuanSaoXmpp as NSString
        if (strOfWallAllowQuInfoSave ==  "area_allow") {
            //数据不合格
            return;
        }else{
           
            if( bottomView.clearnBtn.isSelected==true && ((moShiBtn?.titleLabel?.text?.contains( NSLocalizedString("专扫", comment: "")))! || (moShiBtn?.titleLabel?.text?.contains( NSLocalizedString("模式：专扫", comment: "")))! ) ){//专扫过程中的数据更新UI
                vWallQu?.getQuyuXmppStr(strOfWallAllowQuInfoSave as String!);//禁止|允许区
            }
            
        }
        if (( bottomView.clearnBtn.isSelected==true) && (strOfWallAllowQuInfoSave ==  "area_allow 0 0 0 0 0") && !((moShiBtn?.titleLabel?.text?.contains( NSLocalizedString("专扫", comment: "")))! || (moShiBtn?.titleLabel?.text?.contains( NSLocalizedString("模式：专扫", comment: "")))! ) ) {
           vWallQu?.getQuyuXmppStr(strOfWallAllowQuInfoSave as String!);//其他状态的时候 且没有花专扫时 清除专扫
        }
        if ((bottomView.clearnBtn.isSelected==false) && !((strOfWallAllowQuInfoSave?.contains("area_allow 0 0 0 0 0"))! || (strOfWallAllowQuInfoSave?.contains("area_allow 1 0 0 0 0"))! || strOfWallAllowQuInfoSave?.length == 0  ) ) {//非清扫状态收到专扫区数据后的UI更新 |20170527 当前专扫区的数据为空 没有更新版本或其他状态时出现该情况 此时 新增长度判断防止进入专扫文本设置
             moShiBtn?.setTitle(arrOfModelBtnTitleStr[5], for: UIControlState.normal)
            arrOfSaveModelAndLiDuChange(moshiStr: strOfWallAllowQuInfoSave! as String, liduStr: "")
            
            vWallQu?.getQuyuXmppStr(strOfWallAllowQuInfoSave as String!);//其他状态的时候 且没有花专扫时 清除专扫
        }
    }
    
    func cancelAction(){
        
        if routeView?.switchOfDingDianView?.isOn == true {
            //专扫区 取消
            routeView?.strOfRouteSaveAllowWall = "area_allow 0 0 0 0 0"
            routeView?.hidenZhuanSao()
            
        }else{
           //定点 取消
            
        }
        
        //若之前为专扫则重现之前的专扫数据
        let strOfModeStr = arrOfSaveModelAndLiDu?.firstObject as! String
        if  (strOfModeStr.contains(modelTransferProtocolArr[5])) {
            routeView?.strOfRouteSaveAllowWall = strOfModeStr
            routeView?.sendXuNiQiangOKXmppStr(strOfOKXmpp: strOfModeStr)
            
        }
       
        
        routeView?.targetBtn?.isHidden = true
        bottomView.isHidden = false
        self.piaofuBtnShow()
        
        routeView?.removeFromSuperview()
        routeBottomView.removeFromSuperview()
        self.deletRouteViewSignImgV()
       
        routeViewIsDrawIng = false;
        
    }
    //MARK:==dealMapLocation
    func dealMapLocation(){
        
        upNumOfBl()//更新比例尺
        if(self.bottomView.xuNiQiangBtn.isSelected==true){
            return//1229 在虚拟墙模式下不更新View
        }
        
      
        saveOffsetPoint = mapScrollView.contentOffset
        if (mapImageView == nil){
            return
        }
         
        var centerX = mapScrollView.frame.size.width/2
        var centerY = mapScrollView.frame.size.height/2
        
        if mapScrollView.contentOffset.x == 0 && mapScrollView.contentOffset.y == 0{
            centerX =  mapScrollView.frame.size.width/2
            centerY = mapScrollView.frame.size.height/2
            //初始化的界面要求地图img比较大现在设放大1.5倍
            if(scrollisOncemoveOfImgCenter == 0){
                mapScale = 1.5
                
                mapScrollView.setZoomScale(mapScale, animated: false)
                
                mapScrollView.contentSize = CGSize(width: SCREEN_HEIGHT*2, height: SCREEN_HEIGHT*2)
                
                self.moveActionOrZoomActionImgChangeOffset() //此设置还用于缩放
                //给虚拟墙更新缩放倍数
                if( v != nil ){
                    v?.changeMapScap(mapScale)
                }
                //0130
                if(vWallQu != nil){
                 vWallQu?.changeQuVScap(mapScale)
                }
                
                
            }
            
        }else{
            scrollisOncemoveOfImgCenter += 1
            centerX = mapScrollView.contentSize.width > mapScrollView.frame.size.width ? mapScrollView.contentSize.width/2 : centerX
            centerY = mapScrollView.contentSize.height > mapScrollView.frame.size.height ? mapScrollView.contentSize.height/2 : centerY
            
            if (scrollisOncemoveOfImgCenter <= 3)  {//只在第一次滑动且更新mapimg时改变offset其余由客户滑动
                //滚动图的显示中心变化 设置滚动视图显示区 1w 1h--2h 2h; 0.5w,0.5h- h h

               self.moveActionOrZoomActionImgChangeOffset() //此设置还用于缩放
                
            }
        }
 
        mapImageView.center = CGPoint(x: centerX, y: centerY)
        if(trajectoryView != nil){
            trajectoryView.center = mapImageView.center//轨迹20190417时时更新
            trajectoryView.mapScale = self.mapScale
//            trajectoryView.backgroundColor = UIColor.brown
 //            trajectoryView.setNeedsDisplay()///20190426轨迹问题
//             TrajectoryViewData.changeTrajectoryPointArr(withXmppinfoStr: "", mapScale: self.mapScale);//有新数据的更新
            trajectoryView.upTraViewOfScrollZooming()
        }else{
            trajectoryView = TrajectoryView.init(frame: mapImageView.frame)
        }
        
    
        routeView?.frame = CGRect(x: 0, y: 0, width: self.view.width(), height: self.view.height())
        
     /****计算充电桩和扫地机位置***/
   
        /***扫地机**/
        self.robotImgViewCenter(centerX: centerX, centerY: centerY)
        
        /**充电桩**/
        self.homeImgViewCenter(centerX: centerX, centerY: centerY)
       
        
        /**定点center*/
        self.dingdianCenter(centerX:centerX,centerY:centerY)
        
        /**wallchange 虚拟墙*/
        if(self.xuniqiangInfoTimerNum<=0||self.bottomView.xuNiQiangBtn.isSelected==false){//1229虚拟墙在绘画模式后延时禁止后
            self.mapImagCenterChangeSetWallChange()
            
        }
    }
    func robotImgViewCenter(centerX:CGFloat,centerY:CGFloat){
        //superv = mapimg的00开始的坐标得到xy  再更具mapScale为滚动视图为父视图的变化的坐标
        //图片的center不为00 要用图片的4个参数计算坐标原点进行变动
        let xm = DataManager.shareDataManager.posX
        let ym = DataManager.shareDataManager.posY
        
 
        let mapImgWAndH = MapDataTool.mapImgWidthAndHeight()
        let wImg = mapImgWAndH.width
        let hImg = mapImgWAndH.height
        
        let pointImgOriginPointAndCenterPoint:CGPoint = MapDataTool.mapImgOriginPointAndCenterPointRelativeCoordinates()
        let xC = pointImgOriginPointAndCenterPoint.x
        let yC = pointImgOriginPointAndCenterPoint.y
        //mapimg原点的相对于屏幕的坐标 原点x=x-中心点x 原点y=y-中心点y，加上1/2得到相对于屏幕的，最后+xm+ym
        let x :CGFloat = CGFloat(xm)-xC+CGFloat(wImg)*0.5// centerx是相对于img中心的坐标之后   xc是基于img00点坐标 y相负
        let y :CGFloat = CGFloat(-ym)+yC+CGFloat(hImg)*0.5        //            +xC -yC
        //父视图为mapimg时的坐标
        
        //蓝色图标的父视图换为mapScrollView  center的中心加原xy来定
        let scrollviewCenterX = mapScrollView.contentSize.width > mapScrollView.frame.size.width ? mapScrollView.contentSize.width/2 : centerX
        let scrollviewCenterY = mapScrollView.contentSize.height > mapScrollView.frame.size.height ? mapScrollView.contentSize.height/2 : centerY
        
        let xLocationV = (x*mapScale+scrollviewCenterX)-CGFloat(wImg)*0.5*mapScale
        let yLocationV = (y*mapScale+scrollviewCenterY)-CGFloat(hImg)*0.5*mapScale
        //      原父视图为img从img的00点算，现不需要0.5wh
        locationImageView.center = CGPoint(x: xLocationV, y: yLocationV);
    }
    
    func homeImgViewCenter(centerX:CGFloat,centerY:CGFloat){
        //充电桩
        
        //superv = mapimg的00开始的坐标得到xy  再更具mapScale为滚动视图为父视图的变化的坐标
        //图片的center不为00 要用图片的4个参数计算坐标原点进行变动
        let xmHome = DataManager.shareDataManager.homeX
        let ymHome = DataManager.shareDataManager.homeY
    
        
        //mapimg原点的相对于自生img的坐标，xc yc 中心点
 
        let mapImgWAndH = MapDataTool.mapImgWidthAndHeight()
        let wImgHome = mapImgWAndH.width
        let hImgHome = mapImgWAndH.height
        
        let pointImgOriginPointAndCenterPoint:CGPoint = MapDataTool.mapImgOriginPointAndCenterPointRelativeCoordinates()
        let xCHome = pointImgOriginPointAndCenterPoint.x
        let yCHome = pointImgOriginPointAndCenterPoint.y
        
        //mapimg原点的相对于屏幕的坐标 原点x=x-中心点x 原点y=y-中心点y，加上1/2得到相对于屏幕的，最后+xm+ym
        let xHome :CGFloat = CGFloat(xmHome)-xCHome+CGFloat(wImgHome)*0.5// centerx是相对于img中心的坐标之后   xc是基于img00点坐标 y相负
        let yHome :CGFloat = CGFloat(-ymHome)+yCHome+CGFloat(hImgHome)*0.5        //            +xC -yC
        
        //父视图为mapimg时的坐标
        //        locationImageView.center = CGPoint(x: x, y: y)
        //          mapImageView.center = CGPoint(x: centerX, y: centerY)
        
        //蓝色图标的父视图换为mapScrollView  center的中心加原xy来定
        let scrollviewCenterXHome = mapScrollView.contentSize.width > mapScrollView.frame.size.width ? mapScrollView.contentSize.width/2 : centerX
        let scrollviewCenterYHome = mapScrollView.contentSize.height > mapScrollView.frame.size.height ? mapScrollView.contentSize.height/2 : centerY
        
        let xLocationVHome = (xHome*mapScale+scrollviewCenterXHome)-CGFloat(wImgHome)*0.5*mapScale
        let yLocationVHome = (yHome*mapScale+scrollviewCenterYHome)-CGFloat(hImgHome)*0.5*mapScale
        homeImgView?.center = CGPoint(x: xLocationVHome, y: yLocationVHome)
    }
    //MARK:————————————dingDianCleanImgViewPoint  定点的  center
    
    func dingdianCenter(centerX:CGFloat,centerY:CGFloat){
        //superv = mapimg的00开始的坐标得到xy  再更具mapScale为滚动视图为父视图的变化的坐标
        //图片的center不为00 要用图片的4个参数计算坐标原点进行变动
        var xm = dingDianCleanImgViewPoint.x
        var ym = dingDianCleanImgViewPoint.y
//        xm = xm + _width(5)
//        ym = ym + _height(6)
        
        
        //mapimg的宽高
//        let wImg = DataManager.shareDataManager.mapRightEnd-DataManager.shareDataManager.mapLeftEnd
//        let hImg = DataManager.shareDataManager.mapTopEnd-DataManager.shareDataManager.mapBottomEnd
//        //mapimg原点的相对于自生img的坐标，xc yc 中心点
//        let xC = CGFloat(DataManager.shareDataManager.mapRightEnd) - CGFloat(wImg)*0.5
//        let yC = CGFloat(DataManager.shareDataManager.mapTopEnd) - CGFloat(hImg)*0.5
        //mapimg原点的相对于屏幕的坐标 原点x=x-中心点x 原点y=y-中心点y，加上1/2得到相对于屏幕的，最后+xm+ym
        let mapImgWAndH = MapDataTool.mapImgWidthAndHeight()
        let wImg = mapImgWAndH.width
        let hImg = mapImgWAndH.height
        
        let pointImgOriginPointAndCenterPoint:CGPoint = MapDataTool.mapImgOriginPointAndCenterPointRelativeCoordinates()
        let xC = pointImgOriginPointAndCenterPoint.x
        let yC = pointImgOriginPointAndCenterPoint.y
        var x :CGFloat = CGFloat(xm)-xC+CGFloat(wImg)*0.5// centerx是相对于img中心的坐标之后   xc是基于img00点坐标 y相负
        var y :CGFloat = CGFloat(-ym)+yC+CGFloat(hImg)*0.5        //            +xC -yC
        
       
        
        let centerX = mapScrollView.frame.size.width/2
        let centerY = mapScrollView.frame.size.height/2
        let scrollviewCenterX = mapScrollView.contentSize.width > mapScrollView.frame.size.width ? mapScrollView.contentSize.width/2 : centerX
        let scrollviewCenterY = mapScrollView.contentSize.height > mapScrollView.frame.size.height ? mapScrollView.contentSize.height/2 : centerY
        
        let xLocationV = (x*mapScale+scrollviewCenterX)-CGFloat(wImg)*0.5*mapScale
        let yLocationV = (y*mapScale+scrollviewCenterY)-CGFloat(hImg)*0.5*mapScale
        //      原父视图为img从img的00点算，现不需要0.5wh
    
        dingDianCleanImgView?.center = CGPoint(x: xLocationV, y: yLocationV);
    }
 
    //MARK:===scrollview delegate
    //移动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
        scrollisMoved = true
    }
    // 返回将要缩放的UIView对象。要执行多次 两个手指放上去准备缩放时
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        if mapImageView != nil{
            return mapImageView!
        }else{
            return nil
        }
        
    }
     //MARK:__缩放时
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        mapScrollView.contentSize = CGSize(width: SCREEN_HEIGHT*2, height: SCREEN_HEIGHT*2)
        saveOffsetPoint = mapScrollView.contentOffset
        mapScale = mapScrollView.zoomScale;
//        if mapScale>1 {
//             self.mapImageView.image = MapDataTool.getNewScaleImg( self.mapSourceImg, scale: self.self.mapScale)//0124 缩放时用源数据更新img  以下更新imgV等控件
//        }else{
//            self.mapImageView.image = self.mapSourceImg;
//        }
       
      /**
         0114 缩放时刷新问题
         在线有robot数据
         dealMapLocation() //更新地图+地图上的控件
         
         */
        var centerX = mapScrollView.frame.size.width/2
        var centerY = mapScrollView.frame.size.height/2
        
         centerX = mapScrollView.contentSize.width > mapScrollView.frame.size.width ? mapScrollView.contentSize.width/2 : centerX
         centerY = mapScrollView.contentSize.height > mapScrollView.frame.size.height ? mapScrollView.contentSize.height/2 : centerY
        self.moveActionOrZoomActionImgChangeOffset()//移动到视图中心
 
        /**地图mapImg*/
        self.mapImageView.center = CGPoint(x: centerX, y: centerY)
        /**轨迹*/
         self.scrollviewZoomUpTrajectoryV()/**轨迹*/
    
        /***扫地机**/
        self.robotImgViewCenter(centerX: centerX, centerY: centerY)
        /**充电桩**/
        self.homeImgViewCenter(centerX: centerX, centerY: centerY)
        /**定点center*/
        self.dingdianCenter(centerX:centerX,centerY:centerY)

        /**wallchange 虚拟墙*/
        
        //虚拟墙更新缩放倍数
        if( v != nil ){
            v?.changeMapScap(mapScale)
        }
        //0130
        if(vWallQu != nil){
            vWallQu?.changeQuVScap(mapScale)
        }
        

    }
   
    //MARK:__缩放完成
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        print("\(#function)")
        mapScale = scale
        dealMapLocation()
      
        mapScrollView.contentSize = CGSize(width: SCREEN_HEIGHT*2, height: SCREEN_HEIGHT*2)
        self.moveActionOrZoomActionImgChangeOffset()//移动到视图中心
        //虚拟墙更新缩放倍数
        if( v != nil ){
            v?.changeMapScap(scale)
        }
        //0130
        if(vWallQu != nil){
            vWallQu?.changeQuVScap(mapScale)
        }
       self.scrollviewZoomUpTrajectoryV()/**轨迹*/
    }
    
    
    //MARK:___ 用户抬起手指时调用,可配合下面的减速方法使用
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            print("traj scrollViewDidEndDragging 用户手指抬起");
        self.scrollviewZoomUpTrajectoryV()/**轨迹*/
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("traj scrollViewDidEndDecelerating 视图减速动画已经完成")
        self.scrollviewZoomUpTrajectoryV()/**轨迹*/
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("traj scrollViewWillBeginDecelerating 滚动视图要减速了")
        self.scrollviewZoomUpTrajectoryV()/**轨迹*/
    }
    func scrollviewZoomUpTrajectoryV() {
        /**轨迹*/
        if(trajectoryView != nil){
            trajectoryView.frame = mapImageView.frame
            trajectoryView.center = mapImageView.center//轨迹20190428时时更新
            trajectoryView.mapScale = self.mapScale
            //            trajectoryView.setNeedsDisplay()//这个太费内存更换成layer
            trajectoryView.upTraViewOfScrollZooming() //没有新数据的更新
            
        }
    }
   
    //MARK:_________移动到滚动视图的内容视图中心点
    func moveActionOrZoomActionImgChangeOffset() {//0808加上偏移量
        mapScrollView.setContentOffset(CGPoint(x: mapScrollView.contentSize.width/2-mapScrollView.frame.size.width/2, y: mapScrollView.contentSize.height/2-mapScrollView.frame.size.height/2), animated: false)
    }
    //MARK:_______缩放时的回到中心点
    //0114
//    func zoomingActionImgChangOffsetGetNewCenter(offsetP:CGPoint) {
//         mapScrollView.setContentOffset(CGPoint(x: (mapScrollView.contentSize.width/2-mapScrollView.frame.size.width/2)+offsetP.x, y: (mapScrollView.contentSize.height/2-mapScrollView.frame.size.height/2)+offsetP.y), animated: false)
//    }
    //缩放时瞄点
    func zoomingActionImgChangOffsetGetNewCenter() {
        if mapScrollView.pinchGestureRecognizer?.state == UIGestureRecognizerState.began{
            let piece:UIView = mapScrollView
            let _:CGPoint = (mapScrollView.pinchGestureRecognizer?.location(in: piece))!
            let locationInSuperview:CGPoint  = (mapScrollView.pinchGestureRecognizer?.location(in: piece.superview))!
             piece.center = locationInSuperview;
        }
    }
    
    
     func zoomActionImgChangeOffset() {//0808加上偏移量
        print("setContentOffset  ,save offset=\(mapScrollView.contentOffset.x)  \(mapScrollView.contentOffset.y) m\(mapImageView.center) zoomActionImgChangeOffset9999999999")

    }
    func dealWithRouteView(){
        routeView?.removeFromSuperview()
    }
    
   
       //MARK:===xmpp delegate
    func sendMessageFail() {
        print("xmpp发送失败")
        if  sweeperStatusLabel.text == NSLocalizedString("离线中", comment: ""){
        }else{
            self.failTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(delaySendRequest), userInfo: nil, repeats: false)
        }
    }
    
    func delaySendRequest()  {
//        XmppManager.shareXmppManager.sendMessageToRobot(message: "request_connect")
//        XmppManager.shareXmppManager.sendMessageToRobot(message: "request_map")
        self.initSendXmppOfCAndMAndInfo()
        
    }
    
    func sendMessageSuccess() {
         print("xmpp发送成功")
    }
    
 
    func receiveXmppMessage(message: String) {
        //20190325传message给底部设置当前显示的单个view或所以view 子btn该z状态暂依原本的设置步骤走不在此方法里做设置0325
        self.getxmmppOfShowBottomOneVorShowBottomAllView(xmppmessage: message)
        
        //如果该协议存在且有协议对象则传输 监控遥控时需要
        if(delegatesJkYk != nil){
            delegatesJkYk?.receiveXmppJkYkMessage?(message: message)
        }
        
        //遥控20190318
        if(remoteControlPopView != nil)&&(remoteControlPopView?.isHidden == false){
            remoteControlPopView?.getxmppMsg(message)
            
        }
         wifiTimmerNum = 0//判断xmpp断开的情况
        
        var array = message.components(separatedBy: " ")
        let type = array[0]
        if !type.contains("info_map") {
//            print(message)
//            print("map页收到的数据")
        }
      
        
        if message == "request_connect ok"{
            
            sweeperStatusLabel.text = NSLocalizedString("在线中", comment: "");
             wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            XmppManager.shareXmppManager.sendMessageToRobot(message: "request_map")
             
        }
        //原本的离线状态受到数据后
        if sweeperStatusLabel.text == NSLocalizedString("离线中", comment: "") {
            self.sweeperStatusLabel.text = NSLocalizedString("在线中", comment: "");
             wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
        }
     
        if ((sweeperStatusLabel.text == NSLocalizedString("充电中", comment: ""))||(sweeperStatusLabel.text == NSLocalizedString("充电完成", comment: ""))||(sweeperStatusLabel.text == NSLocalizedString("充电已满", comment: ""))){
//            bottomView.chargeBtn.imageView?.tintColor = UIColor.gray
            bottomView.chargeBtn.imageView?.tintColor = UIColor.init(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)//0214更改颜色和重绘btn灰色的图片色统一
            bottomView.chargeBtn.isUserInteractionEnabled = false
        }else{
            bottomView.chargeBtn.imageView?.tintColor = DataManager.shareDataManager.colorOfMainType
            bottomView.chargeBtn.isUserInteractionEnabled = true
        }
        
        //回充时的清扫按钮
        if((sweeperStatusLabel.text == NSLocalizedString("回充中", comment: ""))||(sweeperStatusLabel.text == NSLocalizedString("开始回充", comment: ""))){//
        
        }
        
         

        switch type {
            
        case "respond_line":
            if(bottomView.xuNiQiangBtn.isSelected==false && xuniqiangInfoTimerNum<=0){
//                print("respond_line 数据刷新虚拟墙UI")
                return //20190318不接受虚拟墙线数据 已屏蔽该功能
                 self.getInfoOfThisRobotWallLine(strOfWallLineInfo: message as NSString)
            }
           
            break
        case "area_allow":
 
            if (routeViewIsDrawIng == true){//处于x专扫区绘画ing时不更新UI
                print("bool==true area_allow")
                return;
            }
            
            if( (bottomView.clearnBtn.isSelected==false) && (!(strOfWallAllowQuInfoSave?.contains("0 0 0 0"))!) && (routeViewIsDrawEndAndNotSaveNewInfoWaiteNum>0) ){//非清扫，旧数据有效，才画完不久，不接受新数据
                  print("num==true area_allow")
                return;
            }
//              print("getmesegtoDraw==true area_allow")
            strOfWallAllowQuInfoSave = message as NSString
            self.saveZhuanSaoAndNoRouViewTOUPdateXuNiQiangUi(strOfZhuanSaoXmpp: message as! String)
//             vWallQu?.getQuyuXmppStr(strOfWallAllowQuInfoSave as String!);//强制更新UI
 
            
            
            break
        case "area_ban":
            if(bottomView.xuNiQiangBtn.isSelected==false && xuniqiangInfoTimerNum<=0){ //不接受新数据|那么本地数据刷新？
//                print("area_ban 数据刷新虚拟墙UI")
                if(vWallQu != nil){
                    //
                    vWallQu?.forbiddenXmppStr = message
                    self.strOfWallForbidQuInfoSave = message as NSString
                    vWallQu?.getQuyuXmppStr(message);
                }
    
            }else{
//                 print("area_ban 2数据刷新虚拟墙UI")
            }
            
            break
            
        //版本数据
        case "about_device":
            //1031 about_device slam版本/控制板版本/小鸟版本信息/开机时间/语音音量/船型开关状态
           /**例如slam版本v2.0,控制本v2.0.0,小鸟版本:v2.0.0:about_device 2 0 2 0 0 2 0 0  */
          //frieware-控制板-硬件 
          //slam-导航版-软件
//             print(array)
            //设备号
            var strOfcurNav:String = "Nav"+" "+array[1]+" "+array[2]
            var strOfcurFrie:String = "Frie"+" "+array[3]+" "+array[4]+" "+array[5]
            if( array.count > 11 ){
                
                if(array.count)>12{//1212新增设备号
                     DataManager.shareDataManager.robotWillShowId = array[12] as NSString //>12才有次位
                }
                
                strOfcurNav = "Nav"+" "+array[1]+" "+array[2]
                strOfcurFrie = "Frie"+" "+array[3]+" "+array[4]+" "+array[5]
                
                DataManager.shareDataManager.currentNavigationVersion = array[1]+" "+array[2]
                DataManager.shareDataManager.currentFriewareVersion = array[3]+" "+array[4]+" "+array[5]
                
                //开机时间 10
                DataManager.shareDataManager.openTime = array[9]
                //音量11
                DataManager.shareDataManager.volumeStr = array[10]
                //船型开关状态字段 为1 0 在0时置离线
                DataManager.shareDataManager.robotOpenOrNo = array[11] as NSString //>11才有这个位
               
                //1.冠维不支持这个信号  冠维独有休眠sleep协议
                if(DataManager.shareDataManager.appRobotTypeStr.intValue==2){//冠维的不支持船型开关状态位它会一直为0
                     DataManager.shareDataManager.robotOpenOrNo = "" //清空
              
                }
                
                
                //2.控制板20.8后才接受这个信
                var canShengJiKZOf11:Bool = false
                if((DataManager.shareDataManager.lastFriewareVersion == "--")||(DataManager.shareDataManager.lastFriewareVersion == "")){
                    
                    canShengJiKZOf11 = false
                }else{
                    let arrOfKZ = strOfcurFrie.components(separatedBy: " ")
                    if arrOfKZ.count<=1{
                       
                        canShengJiKZOf11 = false
                    }else{
                        let arrOfmsgKZ:NSMutableArray = NSMutableArray.init(array: arrOfKZ)
                        canShengJiKZOf11 = ToolOfBasic.lastxmlKZVersionBigThanCurrentRobotKZVersion(withMsgArr: arrOfmsgKZ, saveXmlKZVersionStr: "Version 20.8.0")
                    }
                    
                }
                if(canShengJiKZOf11==true){//小于20.8.0 不支持该船行开关位 为true时为小于
                     DataManager.shareDataManager.robotOpenOrNo = "" //清空
                }
                //11位的船行开关位end
            }else if( array.count == 11 ){
                strOfcurNav = "Nav"+" "+array[1]+" "+array[2]
                strOfcurFrie = "Frie"+" "+array[3]+" "+array[4]+" "+array[5]
                
                DataManager.shareDataManager.currentNavigationVersion = array[1]+" "+array[2]
                DataManager.shareDataManager.currentFriewareVersion = array[3]+" "+array[4]+" "+array[5]
                
                //开机时间 10
                DataManager.shareDataManager.openTime = array[9]
                //音量11
                DataManager.shareDataManager.volumeStr = array[10]
                
           }else if( array.count == 9 ){
                  strOfcurNav = "Nav"+" "+array[1]+" "+array[2]
                  strOfcurFrie = "Frie"+" "+array[3]+" "+array[4]+" "+array[5]
                
                DataManager.shareDataManager.currentNavigationVersion = array[1]+" "+array[2]
                DataManager.shareDataManager.currentFriewareVersion = array[3]+" "+array[4]+" "+array[5]
            }else if(array.count == 6){
                strOfcurNav = "Nav"+" "+array[1]+" "+array[2]
                strOfcurFrie = "Frie"+" "+array[3]+" "+array[4]+" "+array[5]
                
                DataManager.shareDataManager.currentNavigationVersion = array[1]+" "+array[2]
                DataManager.shareDataManager.currentFriewareVersion = array[3]+" "+array[4]+" "+array[5]
            }else {
                return
            }
           
            
            //smal导航版
            var canShengJi:Bool = false
            if ((DataManager.shareDataManager.lastNavigationVersion == "--")||(DataManager.shareDataManager.lastNavigationVersion == "")) {
//                return
                canShengJi = false
            }else{
               
                let arrOfNV = strOfcurNav.components(separatedBy: " ")
                if arrOfNV.count<=1 {//get的导航版信息
//                    return;
                    canShengJi = false
                }else{
                    let arrOfmsg:NSMutableArray = NSMutableArray.init(array: arrOfNV)
                    
                    canShengJi = ToolOfBasic.lastxmlVersionBigThanCurrentRobotVersion(withMsgArr: arrOfmsg , saveXmlVersionStr: DataManager.shareDataManager.lastNavigationVersion)
                    
                }
            }
            
            //控制板
            var canShengJiKZ:Bool = false
            if((DataManager.shareDataManager.lastFriewareVersion == "--")||(DataManager.shareDataManager.lastFriewareVersion == "")){
//                return
                canShengJiKZ = false
            }else{
                let arrOfKZ = strOfcurFrie.components(separatedBy: " ")
                if arrOfKZ.count<=1{
//                    return;
                    canShengJiKZ = false
                }else{
                    let arrOfmsgKZ:NSMutableArray = NSMutableArray.init(array: arrOfKZ)
                    canShengJiKZ = ToolOfBasic.lastxmlKZVersionBigThanCurrentRobotKZVersion(withMsgArr: arrOfmsgKZ, saveXmlKZVersionStr: DataManager.shareDataManager.lastFriewareVersion)
                }
                
            }
            
            //判断右上角图标红点
            if((canShengJi == true) || (canShengJiKZ == true)){
                self.setRightItemRedPoint(boolOfRed: true)
               
            }else{
                 self.setRightItemRedPoint(boolOfRed: false)
             
            }
          //判断是非存在升级
            if((canShengJi == true) && (canShengJiKZ == true) && (alertController == nil) ){//都要升级
                updateVersionAlert(info: "getSlamVersionAndgetFirewareVersion")

            }else{
                //发送
                if((canShengJi == true) && (alertController == nil)){
                    updateVersionAlert(info: "getSlamVersion")
                    
                }
                //发送
                if((canShengJiKZ == true) && (alertController == nil)){
                    updateVersionAlert(info: "getFirewareVersion")
                    
                }
                
            }
            
            break
            
        case "info_map":
            
//            if(self.bottomView.xuNiQiangBtn.isSelected==true || self.routeView != nil){
            if(self.bottomView.xuNiQiangBtn.isSelected==true || self.routeViewIsDrawIng==true){
//                 XmppManager.shareXmppManager.sendMessageToRobot(message: "request_map")//不在发送请求地图信息它会根据info_map的不连续自己请求20190408
                return//1229 在虚拟墙模式下不更新View //20190329新增在定点绘画时不更新mapimgV
            }
            if(self.mapScrollView.isZooming){//scrollViewDidZoom缩放时不刷新
                XmppManager.shareXmppManager.sendMessageToRobot(message: "request_map")
                print("在缩放不接收info_map信息")
                return
            }
            mapInfoSerialqueue.addOperation {
//                self.mapHelper MapInfoColorCaseHelperAndOtherTool
                let imgmap:UIImage? = self.mapHelper.dealWithMapData(array: array)
                DispatchQueue.main.async {
                    //1.data不为空
                    if(imgmap == nil && DataManager.shareDataManager.mapImgBeforeData != nil){
                        let dat:Data! = DataManager.shareDataManager.mapImgBeforeData
                        self.mapImageView.image = UIImage(data: dat)
                       
                    //2.img不为空
                    }else if(imgmap != nil && DataManager.shareDataManager.mapImgBeforeData == nil){
//                          self.mapImageView.image =  imgmap
                        self.mapSourceImg = imgmap
                        self.mapImageView.image = self.mapSourceImg;
                       
//                        self.mapImageView.image = MapDataTool.getNewScaleImg( self.mapSourceImg, scale: self.self.mapScale)
                    //3.都为空
                    }else if(imgmap == nil && DataManager.shareDataManager.mapImgBeforeData == nil){
                         self.print("—————img和data都为空,不刷新")
//                        self.mapImageView.image = nil;//不更新地图
                    //4.都不为空
                    }else{
//                        self.mapImageView.image = imgmap
                        self.mapSourceImg = imgmap
                        self.mapImageView.image = self.mapSourceImg;
//                        self.mapImageView.image = MapDataTool.getNewScaleImg( self.mapSourceImg, scale: self.self.mapScale)

                    }
    
                    //宽高>3才更新
                    if((DataManager.shareDataManager.mapRightEnd - DataManager.shareDataManager.mapLeftEnd>=3) && (DataManager.shareDataManager.mapTopEnd - DataManager.shareDataManager.mapBottomEnd>=3)){
                        self.mapImageView.frame = CGRect(x: 0, y: 0, width: CGFloat(DataManager.shareDataManager.mapRightEnd - DataManager.shareDataManager.mapLeftEnd + 1)*self.mapScale, height: CGFloat(DataManager.shareDataManager.mapTopEnd - DataManager.shareDataManager.mapBottomEnd + 1)*self.mapScale)
                        //只负责宽高 center固定时则定点计算只用固定center算
                        self.mapImageView.layer.allowsEdgeAntialiasing = false;
                        self.trajectoryView.frame = self.mapImageView.frame
                        self.trajectoryView.center = self.mapImageView.center
                        self.trajectoryView.upTraViewOfScrollZooming()
 
                         //20190301
//                        self.mapImageView.layer.magnificationFilter = "nearest";//kCAFilterNearest
                      self.mapImageView.layer.magnificationFilter = kCAFilterNearest
                    self.trajectoryView.layer.magnificationFilter = kCAFilterNearest
                        self.dealMapLocation()//大白图标 +地图上的一些View的更新
                        if self.vWallQu != nil {//QU不更新问题
                            self.vWallQu?.center = self.mapImageView.center;
                            //刷新虚拟墙UI数据
                            self.getInfoOfThisRobotWallQuyu(strOfWallQuyuInfo: self.strOfWallForbidQuInfoSave!)//0131
                             self.getInfoOfThisRobotAllowWallQuyu(strOfAllowWallInfo: self.strOfWallAllowQuInfoSave!)//0328
                        }
                        
                    }
                  
                }

            }
            
                   break
            
        case "map_zone"://区域数据 true才进行下一步
            if isWillGetArreaClearBool {
                 self.getAreaClearDataOfImg(arrOfMessage: array as NSArray)
            }
            
            break

        case "info_trajectory":
            //轨迹数据接收处//计算后会通知Tview更新UI
            TrajectoryViewData.changeTrajectoryPointArr(withXmppinfoStr: message, mapScale: self.mapScale);
            
            break
        case "respond_home"://充电桩位置信息
            let x = Int(array[1])!
            let y = Int(array[2])!
            let mtheta : Double? = Double(array[3])
            let theta = mtheta
            DataManager.shareDataManager.homeTheta = CGFloat(theta!/10)
            DataManager.shareDataManager.homeX = x
            DataManager.shareDataManager.homeY = y
            
            if  (homeImgView != nil) {//存在homeImgView
                
                //1.其他模式情况时的隐藏
                if bottomView.isHidden {//定点区域虚拟墙全屏
                    homeImgView?.isHidden = true//隐藏
                }else{
                    //地图大小
                    if mapImageView.width() != 0{
                        homeImgView?.isHidden = false//地图存在数据
                    }else{
                        homeImgView?.isHidden = true//地图不存在数据
                    }
                }
                //2.除去全屏
                for btn in self.view.subviews {
                    if (btn.tag == 333){//全屏时的推出按钮
                        homeImgView?.isHidden = false//显示
                        //地图大小
                        if mapImageView.width() != 0{
                            homeImgView?.isHidden = false//地图存在数据
                        }else{
                            homeImgView?.isHidden = true//地图不存在数据
                        }
                    }
                }
            }
            dealMapLocation()
            
            //正为顺时针 负为逆时针
            let t : Double = (Double((DataManager.shareDataManager.homeTheta) / 180))
            //
            homeImgView?.transform = CGAffineTransform(rotationAngle: CGFloat( -M_PI*t ) )
            
            break
        case "pos"://坐标点信息
         
            let x = Int(array[1])!
            let y = Int(array[2])!
            let mtheta : Double? = Double(array[3])
            //用扫地机的行走坐标 测试轨迹
/**
            let strOfceshi:String =  String.init(stringInterpolationSegment:array[0]) + " " + String.init(stringInterpolationSegment: DataManager.shareDataManager.trajectoryNum+1) + " " + String.init(stringInterpolationSegment:array[1])  + " " + String.init(stringInterpolationSegment:array[2])  as String
            TrajectoryViewData.changeTrajectoryPointArr(withXmppinfoStr:strOfceshi, mapScale: self.mapScale)
     */
            let theta = mtheta
            DataManager.shareDataManager.theta = CGFloat(theta!/10)
            DataManager.shareDataManager.posX = x
            DataManager.shareDataManager.posY = y
            dealMapLocation()

            //正为顺时针 负为逆时针
            let t : Double = (Double((DataManager.shareDataManager.theta) / 180))

            locationImageView.transform = CGAffineTransform(rotationAngle: CGFloat( -M_PI*t ) )
            
//             print("处理大白图标t=\(t)")
            break
            
        case "clean_info":// clean_info 的num 0为非清扫，相关arr的0一般为自动清扫或清扫模式位
            if (moShiBtn != nil && clearnInfoTimerNum<=0){//clearnInfoTimerNum延时接受
                
                let numOfmode = Int(array[1] as String)
                let numOfLidu = Int(array[2] as String)
                //模式
                /*s
                 清扫模式：0 未处于任意清扫模式
                 1 自动 2边角 3区域 4定点
                 ;力度等级：1 标准（default） 2静音 3 强力*/
                
                if numOfmode==1 {
                    moShiBtn?.setTitle(arrOfModelBtnTitleStr[0], for: UIControlState.normal)//"模式：自动清扫"
                    
                    bottomView.clearnBtn.isSelected = true;
                     bottomView.clearnL.text = NSLocalizedString("暂停", comment: "")
                    self.arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[0], liduStr: "")
                    //__重绘按钮不可点击状态设置
                    self.chongHuiBtnContTapAction()
                     dingDianCleanImgView.isHidden = true
                     self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: true) //20190520监控按钮
                    
                }else if (numOfmode == 2){
                    moShiBtn?.setTitle(arrOfModelBtnTitleStr[3], for: UIControlState.normal) //"模式：边角清扫"
                     bottomView.clearnBtn.isSelected = true;
                     bottomView.clearnL.text = NSLocalizedString("暂停", comment: "")
                     self.arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[3], liduStr: "")
                    //__重绘按钮不可点击状态设置
                    self.chongHuiBtnContTapAction()
                     dingDianCleanImgView.isHidden = true
                     self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: true) //20190520监控按钮
                    
                }else if (numOfmode == 3){
                    moShiBtn?.setTitle(arrOfModelBtnTitleStr[2], for: UIControlState.normal)//"模式：区域清扫"
                    bottomView.clearnBtn.isSelected = true;
                     bottomView.clearnL.text = NSLocalizedString("暂停", comment: "")
                     self.arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[2], liduStr: "")
                    //__重绘按钮不可点击状态设置
                    self.chongHuiBtnContTapAction()
                     dingDianCleanImgView.isHidden = true
                     self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: true) //20190520监控按钮

                }else if (numOfmode == 4){
                    moShiBtn?.setTitle(arrOfModelBtnTitleStr[1], for: UIControlState.normal)
                    bottomView.clearnBtn.isSelected = true;//"模式：定点清扫"
                    bottomView.clearnL.text = NSLocalizedString("暂停", comment: "")
                     self.arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[1], liduStr: "")

                    //__重绘按钮不可点击状态设置
                    self.chongHuiBtnContTapAction()
//                    dingDianCleanImgView.isHidden = false //本状态的显示根具本机此时情况，不用info
                     self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: true) //20190520监控按钮
                }else if (numOfmode == 5){ //1212 新增4*4模式
                    moShiBtn?.setTitle(arrOfModelBtnTitleStr[4], for: UIControlState.normal)
                    bottomView.clearnBtn.isSelected = true;//"模式：定点清扫"
                    bottomView.clearnL.text = NSLocalizedString("暂停", comment: "")
                    self.arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[4], liduStr: "")
                    
                    //__重绘按钮不可点击状态设置
                    self.chongHuiBtnContTapAction()
                    dingDianCleanImgView.isHidden = true
                     self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: true) //20190520监控按钮
                }else if (numOfmode == 6){ //20190312 新增专扫模式
                    moShiBtn?.setTitle(arrOfModelBtnTitleStr[5], for: UIControlState.normal)
                    bottomView.clearnBtn.isSelected = true;//"模式：定点清扫"
                    bottomView.clearnL.text = NSLocalizedString("暂停", comment: "")
                    self.arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[5], liduStr: "")
                    
                    //__重绘按钮不可点击状态设置
                    self.chongHuiBtnContTapAction()
                    dingDianCleanImgView.isHidden = true
                   self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: true) //20190520监控按钮
                    
                }else{//0非清扫状态
//                    print("clearn_info")
//                    print(array)
                    bottomView.clearnBtn.isSelected = false
                    bottomView.clearnL.text = NSLocalizedString("清扫", comment: "")
                    //__重绘按钮可点击状态设置 在非充电状态可设允许点击
                    if(!bottomView.chargeBtn.isSelected){
                        piaofuBtnShow()
                        self.chongHuiBtnCanTapAction()
                    }
//                    dingDianCleanImgView.isHidden = true  //非清扫情况由定点自己来刷新
                 self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: false) //20190520监控按钮
                }

                //力度
                if numOfLidu==1 {
                    liDuBtn?.setTitle(arrOfStrengthBtnTitleStr.first, for: UIControlState.normal) //"力度：标准"
                    self.arrOfSaveModelAndLiDuChange(moshiStr: "", liduStr: liduTransferprotocolArr[0])
                }else if (numOfLidu == 2){
                    liDuBtn?.setTitle(arrOfStrengthBtnTitleStr[1], for: UIControlState.normal) //"力度：安静"
                    self.arrOfSaveModelAndLiDuChange(moshiStr: "", liduStr: liduTransferprotocolArr[1])
                }else if (numOfLidu == 3){
                    liDuBtn?.setTitle(arrOfStrengthBtnTitleStr[2], for: UIControlState.normal) //"力度：强力"
                    self.arrOfSaveModelAndLiDuChange(moshiStr: "", liduStr: liduTransferprotocolArr[2])
                }
            }
        
            //时间
            var timeNumStr = array[3]
            if (timeNumStr=="0"){
                if (sweeperStatusLabel.text == NSLocalizedString("充电中", comment: "") ){//非清扫状态
                    timeNumStr = "0"
                }else{
                    timeNumStr = "<1"
                }
            }
             topView.setTimeLabel(timeNum: timeNumStr)
            
            //面积
            var areaNumStr = array[4]
            if (areaNumStr=="0"){
    
                if (sweeperStatusLabel.text == NSLocalizedString("充电中", comment: "") ) {//非清扫状态
                    areaNumStr = "0"
                }else{
                    areaNumStr = "<1"
                }
                /**
                 || (sweeperStatusLabel.text?.contains( NSLocalizedString("休眠", comment: "") ))! || (sweeperStatusLabel.text?.contains( NSLocalizedString("待机", comment: "") ))!)*/
            }
            
             topView.setAreaLabel(areaNum: areaNumStr)
            //电量
             topView.setChargeLabel(chargeNum: array[5])
            
            areaTimeCharge  = array[4]+"|"+array[3]+"|"+array[5] as NSString
            break
            
//
        case "response_monitor":
            ShareUser.sharedUserInfo().userMode.nowRobotJidMonitor = array[1]
            
            break
            
            
        case "info_status"://状态显示
            let msgTxt:String? = array[1] as String;
            if ( msgTxt != nil){//非空
                if (ToolOfBasic.haveChinese(msgTxt)){//有中文 直接国际化 数据字母转换后国际化返回
                    sweeperStatusLabel.text =  NSLocalizedString(msgTxt!, comment: "")
                }else{
                    let msgOfnewTxt :String =  MapMsgLocalizeStrChangeTool.localizeCodeMsg(withIntStr: msgTxt!)
                    sweeperStatusLabel.text =  msgOfnewTxt
                }
            }

            break
       
            
        case "connect_wifi_info"://connect_wifi_info ssid level ip mac //20190417Wi-Fi命名有空格时的情况，从后往前取值。
            /*
             灰：0 断网
             红：0-25
             黄：25-75
             绿：75-100
             */
//            Swift.print(array)
            var wifiLevel  = array[2];//初始 （有可能是Wi-Fi等级数据有可能是半截ssid）
            array.removeFirst() //协议头去掉
            if(array.count >= 4){
                DataManager.shareDataManager.robotWifiMac = array.last as! String //mac
                array.removeLast()
                DataManager.shareDataManager.robotWifiIP = array.last as! String //ip
                array.removeLast()
                wifiLevel = array.last as! String //等级
                array.removeLast() //等级
            }else{
                //数据少了
                return
            }
            //Wi-Fi等级部分
            let strOfnum: NSString = wifiLevel as NSString
            if strOfnum.contains(".") || strOfnum.length>=3 { //字符bug情况
                return
            }
            
            let signalS : Int = Int(wifiLevel)!
        
            singnOfWifiNum = signalS;
            
            //船型开关状态
            if(!DataManager.shareDataManager.robotOpenOrNo.isEqual(to: "0")){
                if signalS<=25 {
//                    wifiImgView?.backgroundColor = UIColor.red
                    self.newWifiImgOfColorNum(num: 1)
                      break
                }else if(signalS<75){
//                      wifiImgView?.backgroundColor = UIColor.yellow
                   self.newWifiImgOfColorNum(num: 2)
                    
                      break
                }else{//满格
//                      wifiImgView?.backgroundColor = UIColor.green
                    self.newWifiImgOfColorNum(num: 3)
                      break
                }
            }
            
          
            let wifiSSID:String = array.joined(separator: " ") as! String
            DataManager.shareDataManager.robotWifiSsid = wifiSSID
            
        case "language_info":
            let languageNumStr:String = array[1] as String
            if (languageNumStr == "0") {
                    DataManager.shareDataManager.robotLanguage = "中文"
                }else if(languageNumStr == "1"){
                    DataManager.shareDataManager.robotLanguage = "English"
                }else if(languageNumStr == "9"){
                    DataManager.shareDataManager.robotLanguage = "无语音提示"
                }
            break
        case "prevent_drop_info":
            let preventDropNumStr:String = array[1] as String
            if (preventDropNumStr == "0") {
                DataManager.shareDataManager.robotPreventDrop = false
            }else if(preventDropNumStr == "1"){
                DataManager.shareDataManager.robotPreventDrop = true
            }else{
                //不处理其他数据
            }
            break
            
        default:
            self.getOtherXmppMsg(message: message)
            break
        }
        // 船型开关状态 得到的数据判断船型开关与charge状态 分为开机充电、关机充电、在线中、离线中 1206新增更换原
        if(DataManager.shareDataManager.robotOpenOrNo.isEqual(to: "0")){//关机充电+离线
            if((sweeperStatusLabel.text?.contains( NSLocalizedString("充电中", comment: "") ))! || offRobotAndCharging==true){
                 sweeperStatusLabel.text = NSLocalizedString("关机充电中", comment: "")
                 wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            }else{
            }
        }
        if(DataManager.shareDataManager.robotOpenOrNo.isEqual(to: "1")){//开机充电 + 其他状态
        }
        
        
    }
    //MARK:__xmpp接受消息一部分-----暂时为第二任厂商的code消息处理部分----------状态文本底部按钮漂浮按钮等
    func getOtherXmppMsg(message:String)  {
        wifiTimmerNum = 0//判断xmpp断开的情况
        var array = message.components(separatedBy: ":")
        let type:String? = array[0] as String?
//状态部分
        if (TwoCodeIMsgArr?.contains(type))! {//协议
            let msgTxt:String? = array[1] as String;
            if ( msgTxt != nil){//非空
                if (ToolOfBasic.haveChinese(msgTxt)){//有中文 直接国际化 数据字母转换后国际化返回
                    sweeperStatusLabel.text =  NSLocalizedString(msgTxt!, comment: "")
                }else{
                    let msgOfnewTxt :String =  MapMsgLocalizeStrChangeTool.localizeCodeMsg(withIntStr: msgTxt!)
                    sweeperStatusLabel.text =  msgOfnewTxt
                }
                //1220同样的error弹出框间隔时间长，现用standby/sleep 置空errorChangeArr false
                if(message.contains("standby") || message.contains("sleep")){
                    
                    codeErrTypeTimerBool = false//true==扫地机存在错误码状态
                    TwoCodeEMsgChangeArr = [] // 清空codeErr存储的Arr
                    
                    //1221 "待机中" 文本状态后续判断
                    //
                    if (clearnInfoTimerNum<=0) {
                        if(huichongInfoTimerNum<=0&&clearnInfoTimerNum<=0){
                            bottomView.clearnBtn.isSelected = false//清扫按钮非点击状态
                            bottomView.clearnL.text = NSLocalizedString("清扫", comment: "")
                            self.chongHuiBtnCanTapAction()
                           
                        }
                        
                    }
                    if (huichongInfoTimerNum<=0) {
                        bottomView.chargeBtn.isSelected = false //回充按钮非点击状态
                        self.chongHuiBtnCanTapAction()
                        
                    }
                    if(clearnInfoTimerNum<=0 && huichongInfoTimerNum<=0){
                        //显示全部底部按钮
                        MapBottomViewChangeTool.showAllBottomV(self.bottomView) //20190529
                    }
                    
                }
                
                //1221 停止回充文本修改成待机中后 按钮的切换用协议切"停止回充" "stop_chare","stop_charge 0103+回充失败"回充失败"charging_faild +stop_home 停止回充
                if(type=="stop_chare" || type=="stop_charge" || type=="charging_faild" || type=="stop_home"){
                    if(huichongInfoTimerNum<=0){//回充按钮 恢复原色
                        bottomView.chargeBtn.isSelected = false //回充按钮非点击状态
                    }
                    if(clearnInfoTimerNum<=0 && huichongInfoTimerNum<=0){
                        //显示全部底部按钮
                        MapBottomViewChangeTool.showAllBottomV(self.bottomView) //20190529
                    }
                }

                /**
                 stop_charge:63 停止充电
                 stop_home:12 停止回充
                 start_home//开始回充 回充中
                 charging_faild 回充失败
               
                */
                if(type=="start_home"){//回充中 状态
                   
                    if(huichongInfoTimerNum<=0&&clearnInfoTimerNum<=0){//回充按钮&&huichongInfoTimerNum<=0
                        bottomView.chargeBtn.isSelected = true;//回充按钮按下
                        bottomView.clearnBtn.isSelected = false;//清扫按钮
                        bottomView.clearnL.text = NSLocalizedString("清扫", comment: "")
                        //__重绘按钮不可点击状态设置
                        self.chongHuiBtnContTapAction() //1226
                         huichongStatyThereHaveBeen = true //0103
                    }
                }
            }
//error部分 1.0已经弹出过err
        }else if( (TwoCodeEMsgArr?.contains(type))! && !((TwoCodeEMsgChangeArr?.contains(type))!) ){//第二任厂商的code为空时可弹出，存在某个msg则该msg不弹出。
            //国际化转文本
            let msgTxt:String? = array[1] as String;
            var msgTxtNew:String? = array[1] as String;
            if ( msgTxt != nil){//非空
                if (ToolOfBasic.haveChinese(msgTxt)){//有中文 直接国际化 数据字母转换后国际化返回
                    msgTxtNew =  NSLocalizedString(msgTxt!, comment: "")
                }else{
                    let newTxt :String =  MapMsgLocalizeStrChangeTool.localizeCodeMsg(withIntStr: msgTxt!)
                    msgTxtNew =  newTxt
                }
            }else{
                msgTxtNew = "null"
            }
            showAlet(messageStr: msgTxtNew!, index: 999)//弹出msg
            TwoCodeEMsgChangeArr?.add(type)    //新增元素type
             codeErrTypeTimerBool = true//true//扫地机存在错误码状态
            if(msgTxtNew?.contains("E"))!{//0121
                sweeperStatusLabel.text = NSLocalizedString("异常中", comment: "")//1221新增 "异常中"
                 wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            }else{
                //不是E的文本不显示异常
            }
            
            huichongInfoTimerNum = 0; //0107异常中时 清扫与回充的延时num数据置空利于弹出框的更新；
            clearnInfoTimerNum = 0;
            
        }else if( (TwoCodeEMsgArr?.contains(type))! && ((TwoCodeEMsgChangeArr?.contains(type))!) ){//二厂的codeE,type
            var msgTxtNew:String? = array[1] as String;
            let msgTxt:String? = array[1] as String;
            if ( msgTxt != nil){//非空
                if (ToolOfBasic.haveChinese(msgTxt)){//有中文 直接国际化 数据字母转换后国际化返回
                    msgTxtNew =  NSLocalizedString(msgTxt!, comment: "")
                }else{
                    let newTxt :String =  MapMsgLocalizeStrChangeTool.localizeCodeMsg(withIntStr: msgTxt!)
                    msgTxtNew =  newTxt
                }
            }else{
                msgTxtNew = "null"
            }
            if(msgTxtNew?.contains("E"))!{//0121
                sweeperStatusLabel.text = NSLocalizedString("异常中", comment: "")//1221新增 "异常中"
                wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            }else{
                //不是E的文本不显示异常
            }
            codeErrTypeTimerBool = true//true//扫地机存在错误码 已加过就不加到数组也不弹出
            //1221新增 "异常中"
//            sweeperStatusLabel.text = NSLocalizedString("异常中", comment: "")
//             wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
    
        /////以下不是二厂code的数据，是二厂其他数据
        }else if(type=="nav_cleaning"){//自动清扫
            sweeperStatusLabel.text = self.msgToolOfGjh(msgTxt: array.last!)
             wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            if (moShiBtn != nil && clearnInfoTimerNum<=0){//clearnInfoTimerNum延时接受
                moShiBtn?.setTitle(arrOfModelBtnTitleStr[0], for: UIControlState.normal)//"模式：自动清扫"
                
                bottomView.clearnBtn.isSelected = true;
                bottomView.clearnL.text = NSLocalizedString("暂停", comment: "")
                self.arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[0], liduStr: "")
                //__重绘按钮不可点击状态设置
                self.chongHuiBtnContTapAction()
                dingDianCleanImgView.isHidden = true
                 self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: true) //20190520监控按钮
            }
         
        }else if(type=="followall_cleaning"){//沿边清扫
            sweeperStatusLabel.text = self.msgToolOfGjh(msgTxt: array.last!)
            wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            if (moShiBtn != nil && clearnInfoTimerNum<=0){
                moShiBtn?.setTitle(arrOfModelBtnTitleStr[3], for: UIControlState.normal) //"模式：边角清扫"
                bottomView.clearnBtn.isSelected = true;
                bottomView.clearnL.text = NSLocalizedString("暂停", comment: "")
                self.arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[3], liduStr: "")
                //__重绘按钮不可点击状态设置
                self.chongHuiBtnContTapAction()
                dingDianCleanImgView.isHidden = true
                 self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: true) //20190520监控按钮
            }
        }else if(type=="zone_cleaning"){//区域清扫
            sweeperStatusLabel.text = self.msgToolOfGjh(msgTxt: array.last!)
            wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            if (moShiBtn != nil && clearnInfoTimerNum<=0){
                moShiBtn?.setTitle(arrOfModelBtnTitleStr[2], for: UIControlState.normal)//"模式：区域清扫"
                bottomView.clearnBtn.isSelected = true;
                bottomView.clearnL.text = NSLocalizedString("暂停", comment: "")
                self.arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[2], liduStr: "")
                //__重绘按钮不可点击状态设置
                self.chongHuiBtnContTapAction()
                dingDianCleanImgView.isHidden = true
                 self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: true) //20190520监控按钮
                
            }

        }else if(type=="emphases_cleaning"){//重点清扫
             sweeperStatusLabel.text = self.msgToolOfGjh(msgTxt: array.last!) //导航栏
            wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            if (moShiBtn != nil && clearnInfoTimerNum<=0){
                moShiBtn?.setTitle(arrOfModelBtnTitleStr[1], for: UIControlState.normal)
                bottomView.clearnBtn.isSelected = true;//"模式：定点清扫"
                bottomView.clearnL.text = NSLocalizedString("暂停", comment: "")
                self.arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[1], liduStr: "")
                
                //__重绘按钮不可点击状态设置
                self.chongHuiBtnContTapAction()
                 self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: true) //20190520监控按钮
            }
            
        }else if(type=="nav_cleaning_4_4"){//4*4清扫 1224新增
            sweeperStatusLabel.text = self.msgToolOfGjh(msgTxt: array.last!) //导航栏
            wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            if (moShiBtn != nil && clearnInfoTimerNum<=0){
                moShiBtn?.setTitle(arrOfModelBtnTitleStr[4], for: UIControlState.normal)
                bottomView.clearnBtn.isSelected = true;//"模式：4*4清扫"
                bottomView.clearnL.text = NSLocalizedString("暂停", comment: "")
                self.arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[4], liduStr: "")
                 dingDianCleanImgView.isHidden = true //定点图标隐藏
                //__重绘按钮不可点击状态设置
                self.chongHuiBtnContTapAction()
                 self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: true) //20190520监控按钮
 
            }
        }else if (type=="area_allow_cleaning"){//专扫模式 20190326新增
            sweeperStatusLabel.text = self.msgToolOfGjh(msgTxt: array.last!) //导航栏
            wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            if (moShiBtn != nil && clearnInfoTimerNum<=0){
                moShiBtn?.setTitle(arrOfModelBtnTitleStr[5], for: UIControlState.normal)
                bottomView.clearnBtn.isSelected = true;//"模式：4*4清扫"
                bottomView.clearnL.text = NSLocalizedString("暂停", comment: "")
                self.arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[5], liduStr: "")
                dingDianCleanImgView.isHidden = true //定点图标隐藏
                //__重绘按钮不可点击状态设置
                self.chongHuiBtnContTapAction()
                 self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: true) //20190520监控按钮
            }
            
        }else if(type=="start_upgrade"){//开始升级
            self.view.makeToast(NSLocalizedString("机器人正在升级", comment: "") , duration: 1.5, position: "center");
            perform(#selector(delaypopRootVc), with: self, afterDelay: 1.5)
            
        }else if(type=="upgrading"){//正在升级
            
                self.goUpVc += 1
                if(self.goUpVc>1){
                    return;//只跳转一次
                }
                self.navigationController?.pushViewController(UpViewController(), animated: true)
                print("goUpVc=\(goUpVc)")
            
            
        }else if((type=="start_home") && (huichongInfoTimerNum<=0)){//开始回充／／clearn_info也对clearnBtn有判断
            sweeperStatusLabel.text = msgToolOfGjh(msgTxt: array.last!)
            wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            bottomView.chargeBtn.isSelected = true
            //
            bottomView.clearnBtn.isSelected = false
            bottomView.clearnL.text = NSLocalizedString("清扫", comment: "")
            //__重绘按钮不可点击状态设置
            self.chongHuiBtnContTapAction() //1226
            
           self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: true) //20190520监控按钮
            
   
        }else if((type=="stop_home") && (huichongInfoTimerNum<=0)){//退出回充，停止机器

             sweeperStatusLabel.text = msgToolOfGjh(msgTxt: array.last!)
            wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            bottomView.chargeBtn.isSelected = false
            self.chongHuiBtnCanTapAction() //
             self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: false) //20190520监控按钮隐藏 因为底部有该按钮
        
        }else if(type=="stop_clean"){//停止清扫
            sweeperStatusLabel.text = msgToolOfGjh(msgTxt: array.last!)
            wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            if(clearnInfoTimerNum<=0){//文本及时更新其他的 屏蔽时间过后更新
                bottomView.clearnBtn.isSelected = false
                
                bottomView.clearnL.text = NSLocalizedString("清扫", comment: "")
                bottomView.chargeBtn.isSelected = false
                self.chongHuiBtnCanTapAction()
                self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: false) //20190520监控按钮隐藏 因为底部有该按钮

            }
            
        }else if((type=="charing"||type=="charging")&&clearnInfoTimerNum<=0){//开始充电charing
            
            sweeperStatusLabel.text = msgToolOfGjh(msgTxt: array.last!)
            wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            bottomView.clearnBtn.isSelected = false
            bottomView.clearnL.text = NSLocalizedString("清扫", comment: "")
            bottomView.chargeBtn.isSelected = false
            self.chongHuiBtnCanTapAction()
//            self.chongHuiBtnContTapAction()  //0128修改 在充电中可以选模式 可重绘
            
            if(DataManager.shareDataManager.robotOpenOrNo.isEqual(to: "0")){//关机充电+离线
                offRobotAndCharging = true //关机充电状态
            }else{
                offRobotAndCharging = false //关机充电状态
            }
            self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: false) //20190520监控按钮隐藏 因为底部有该按钮

            
        }else if(type == "charge_or_shutdown"){//7/8分钟提醒用户充电弹出框
            //休眠提醒弹出框 只出现一次 nil+string 且是支持船型开关的 DataManager.shareDataManager.robotOpenOrNo != ""的冠维机
            if(alertNoticeOfWillSleepController == nil) && (array.last != nil) && !(DataManager.shareDataManager.robotOpenOrNo.isEqual(to: "")){

                let msgtext = msgToolOfGjh(msgTxt: array.last!)
                self.showNoticeOfWillSleepAlertV(strOfWillSleep: msgtext)
                self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: false) //20190520监控按钮隐藏 因为底部有该按钮

            }
        }else if(type == "sleep") {//0110 没有sleep的机子收到这个指令时 文本不动只做ui界面
            
                codeErrTypeTimerBool = false//true==扫地机存在错误码状态
                TwoCodeEMsgChangeArr = [] // 清空codeErr存储的Arr
                
                //1221 "待机中" 文本状态后续判断
                //
                if (clearnInfoTimerNum<=0) {
                    if(huichongInfoTimerNum<=0&&clearnInfoTimerNum<=0){
                        bottomView.clearnBtn.isSelected = false//清扫按钮非点击状态
                        bottomView.clearnL.text = NSLocalizedString("清扫", comment: "")
                        self.chongHuiBtnCanTapAction()
                    }
                    
                }
                if (huichongInfoTimerNum<=0) {
                    bottomView.chargeBtn.isSelected = false //回充按钮非点击状态
                    self.chongHuiBtnCanTapAction()
                    
                }
            self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: false) //20190520监控按钮隐藏 因为底部有该按钮

           
        }else{
            //low_power full_dust_box non_dust_box charging_faild charing_full charing stop_home start_home
            //nav_cleaning followall_cleaning zone_cleaning emphases_cleaning
        }
    }
   
    //状态
    func receiveXmppUserStatus(message: String) {
       //如果该协议存在且有协议对象则传输
        delegatesJkYk?.receiveXmppJkYkUserStatus!(message: message)
        //用户掉了又上线
        if message == "用户上线" {
            sweeperStatusLabel.text = NSLocalizedString("在线中", comment: "");
             wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            self.initSendXmppOfCAndMAndInfo()
            
        //扫地机掉了又上线
        }else if message == "扫地机在线" {
            sweeperStatusLabel.text = NSLocalizedString("在线中", comment: "");
             wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
           self.initSendXmppOfCAndMAndInfo()
        //其他状态只需要显示
        }else if message == "扫地机离线" {
            sweeperStatusLabel.text = NSLocalizedString("离线中", comment: "");
             wifiAndTextShowbtn?.setTitle(sweeperStatusLabel.text, for: .normal)
            //其他状态只需要显示
        }else{
        }
    }
    func initSendXmppOfCAndMAndInfo(){
        XmppManager.shareXmppManager.sendMessageToRobot(message: "request_connect")
        XmppManager.shareXmppManager.sendMessageToRobot(message: "request_map")
        XmppManager.shareXmppManager.sendMessageToRobot(message: "request_robot_info")
    }
  
    //MARK:__正在清扫状态不可点击的情况弹框提示。暂时不用这个，已改为直接把按钮交互关闭颜色灰色
    func isOrNotClearningType(strOfShowMesg:NSString?) ->  Bool {
        
        if bottomView.clearnBtn.isSelected {
            let txtstr :String = NSLocalizedString("正在清扫，暂不可选择", comment: "") as String
            let msg : String = strOfShowMesg! as String
            let strOfshowend : String = txtstr + " " + msg
            MBProgressHUD.showError(strOfshowend)
            
            return true
        }else{
            //不在清扫状态
            return false
        }
        
    }

    //MARK:____________________________viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
    print("___________________________________viewDidDisappear")
        super.viewDidDisappear(animated)
        print("viewDidDisappear_mapvc");
        
        if (failTimer != nil) {
            self.failTimer.invalidate()
        }
        if posTimer != nil {
            self.posTimer.invalidate()
        }
        if mapTimer != nil {
            self.mapTimer.invalidate()
        }
        if timerOfAreaClear != nil {
            self.timerOfAreaClear?.invalidate()
            isWillGetArreaClearBool = false
        }
       
        
        self.failTimer = nil
        self.posTimer = nil
        self.mapTimer = nil
        self.timerOfAreaClear = nil
        
        //codeerror码的数据不停 对遥控页的影响小暂不处理
        if codeErrTimer != nil{
            self.codeErrTimer?.invalidate()
            codeErrTypeTimerBool = false
        }
        self.codeErrTimer = nil
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
           print("__________________________________viewWillDisappea")
         print("viewWillDisappear_mapvc");
        
        //模式力度的通知在切换界面回到地图页后会无法响应 1206新增
        mapStrengthChoosePopV?.removeFromSuperview()
        mapStrengthChoosePopV = nil;
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "mapStrengthChangeNotice"), object: nil)
        mapModeChoosePopV?.removeFromSuperview()
        mapModeChoosePopV = nil;
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "mapModeChangeNotice"), object: nil)
        
    }
    
    //MARK:___updateVersionAlert更新发送指令
    func updateVersionAlert(info:String) {
        /*slam升级：upgrade_slam 主版本 副版本 md5
         ctrl升级：upgrade_ctrl 主版本 副版本1 副版本2 md5
         slam和ctrl同时升级：upgrade_ctrl 主版本 副版本1 副版本2 md5 upgrade_slam 主版本 副版本 md5*/
        
        if(info == "getSlamVersion"){//slam版本导航版
            slamCanUpV = true
        }
        if(info  == "getFirewareVersion"){//控制板
            fCanUpV = true
        }
        if(info  == "getSlamVersionAndgetFirewareVersion"){//控制板导航版
            fCanUpV = true
            slamCanUpV = true
        }
        //以上是存下可更新的状态
        
        if goUpVc>0 {
            print("不弹升级弹窗")
            alertController = nil
        }
        /**
         新增强制升级判断 任意一个强制升级 则都要升级 muv字段 导航版6位每三位代表1个数字 控制板9位 转成 ctrl= x.y smal= x.y.z
         强制升级“下次再说”则该返回到列表页的操作
         */
        var isMustUp:Bool = false
        var mustS:Bool = false
        var mustC:Bool = false
        
        //当前版本
        let curS : String = "currentS" + " " + DataManager.shareDataManager.currentNavigationVersion
        let curC : String = "currentC" + " " + DataManager.shareDataManager.currentFriewareVersion
        let curSArr : NSMutableArray = NSMutableArray.init(array: curS.components(separatedBy: " "))
        let curCArr : NSMutableArray = NSMutableArray.init(array: curC.components(separatedBy: " "))
 
        //最低版本
        var minSlam:NSString = DataManager.shareDataManager.fileMuvOfSmal as NSString
        var minCtrl:NSString = DataManager.shareDataManager.fileMuvOfCtrl as NSString
        
        if minSlam.length==6 {
           let minSlamOne =  minSlam.substring(to: 3)
           let minSlamTwo =  minSlam.substring(from: 3)
           let useMinSlam = "minSlam" + " " + minSlamOne + "." + minSlamTwo
            mustS = ToolOfBasic.lastxmlVersionBigThanCurrentRobotVersion(withMsgArr: curSArr, saveXmlVersionStr: useMinSlam)
        }else{
            mustS = false
        }
        
        if minCtrl.length==9 {
           
            let minCtrlOne =  minCtrl.substring(to: 3)
            let minCtrlTwo =  minCtrl.substring(with: NSMakeRange(3, 3))
            let minCtrlThr =  minCtrl.substring(from: 6)
            let useMinCtrl = "minSlam" + " " + minCtrlOne + "." + minCtrlTwo + "." + minCtrlThr
           mustC = ToolOfBasic.lastxmlKZVersionBigThanCurrentRobotKZVersion(withMsgArr: curCArr, saveXmlKZVersionStr: useMinCtrl)
        }else{
           mustC = false
        }
        if mustS||mustC {
            isMustUp = true
        }

        /**弹出框*/
        //开始升级  发现机器人固件有版本更新,是否让它开始进行升级
        
        alertController = UIAlertController(title: NSLocalizedString("升级", comment: ""), message: NSLocalizedString("发现机器人固件有版本更新,是否让它开始进行升级", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("暂不升级", comment: ""), style: UIAlertActionStyle.cancel) { (action) in
            if(isMustUp){
                //必须升级的就返回到主页列表页
                self.navigationController?.popViewController(animated: true)
            }else{
                
            }
        }
        
        let yesAction = UIAlertAction(title: NSLocalizedString("去升级", comment: ""), style: UIAlertActionStyle.destructive) { (action) in
            
            //换成跳转到固件更新界面
            let fvc = FirmwareUpdateDetailViewController()
            fvc.isCanUpOfhardware =  self.fCanUpV;
            fvc.isCanUpOfSoftware =  self.slamCanUpV;//导航版软件
            self.navigationController?.pushViewController(fvc, animated: true);
            
        }
        
        alertController? .addAction(cancelAction)
        alertController?.addAction(yesAction)
        alertController?.view.tintColor = DataManager.shareDataManager.colorOfMainType
        print("升级的present")
       
        if(errorAlert != nil){
            alertController = nil
            return
        }else {

        }
        self.present(alertController!, animated: true, completion: nil)
    }
    
    func showNoticeOfWillSleepAlertV(strOfWillSleep:String){
        /**弹出框*/
        //扫地机进入休眠模式 机器人即将进入休眠
        alertNoticeOfWillSleepController = UIAlertController(title: NSLocalizedString("提示", comment: "") , message:strOfWillSleep , preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("知道了",comment: ""), style: UIAlertActionStyle.cancel) { (action) in
        }
        alertNoticeOfWillSleepController? .addAction(cancelAction)
        alertNoticeOfWillSleepController?.view.tintColor = DataManager.shareDataManager.colorOfMainType
       
        self.present(alertNoticeOfWillSleepController!, animated: true, completion: nil)

    }
  
    //MARK:——————————————————————————-code处理  codeTimerInit
    
    func codeErrTypeChangeTimerInit() {
        if codeErrTimer==nil {
            //5秒---->10秒-15-10
            codeErrTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(codeErrTypeChangeAction), userInfo: nil, repeats: true)
        }
    }
    //////1122由于扫地机性能降低，以前的err数据发送较快，现在较慢了扫地机人员建议*2倍时间 10秒 1217发现10秒不够，得到err间隙时间不规则 暂用15s 但新机得到相关errcode速度很快大约2秒1个数据
    func codeErrTypeChangeAction() {//每5秒转换成无错误码状态。若存在err则在err接受方法中置为true
  
        if codeErrTypeTimerBool==false {//原codeErrTypeTimerBool
            TwoCodeEMsgChangeArr = []
//
        }
        codeErrTypeTimerBool = false
        
    }
     //是否存在err数据从扫地机传来
    func isHaveErrorCodeFromRobot() -> Bool {
        let nowType : String = NSLocalizedString("离线中", comment: "")
        if (sweeperStatusLabel.text == nowType) {
            self.view.makeToast( NSLocalizedString("离线状态暂不可操作", comment: ""), duration: 1.0, position:"center")
            return true
        }
        
        //0213更新
        if(offRobotAndCharging){
            self.view.makeToast( NSLocalizedString("关机充电状态暂不可操作", comment: ""), duration: 1.0, position:"center")
            return true
        }
        //codeErrTypeTimerBool 扫地机所给数据
        return codeErrTypeTimerBool
    }
    
    
    //点击除了4个按钮(返回 右上角 全屏 定位)的其余的按钮都要重新初始化codeERR数据源，使其可以弹出框。（底部按钮，模式，力度，重绘 8个按钮）
    func codeErrOfAddAllErrorWithMostBtnTap(){
        //1.codeerr数据源
        self.codeErrorOfArrInit()
        //2.按钮不切换点击状态。原本的状态clearnbtn由扫地机传来，其余如何判断可切换？
        //点击按钮时判断是否存在err数据，有就执行此方法，并切换到原状态，无则不用此方法。
        
    }
    
    //’请拔下充电线‘的添加,当点击清扫时
    func codeErrorOfAddCDXWithCleanBtnTap(){//充电线
        if (arrOfCodeErrorNumStr?.contains("015") == false) {
            arrOfCodeErrorNumStr?.add("015")
            arrOfCodeErrorInfoStr?.add("请拔下充电线")
        }
    }
    //codeerror数据源init
    func codeErrorOfArrInit() {
        //一厂的初始化
        arrOfCodeErrorNumStr = ["052","011","012","021","031","041","051","061","062","071","072","081","082","101","102","111","121","122","131","132","133","141","142","151","152","09x","015"]
 
        arrOfCodeErrorInfoStr = ["未找到集尘盒","镜头被遮盖","错误012","错误021","错误031","错误041","扫地机被抬起","错误061","错误062","错误071","错误072","错误081","错误082","错误101","错误102","错误111","错误121","错误122","错误131","错误132","错误133","错误141","错误142","错误151","错误152","错误09X","请拔下充电线"]
 
        //二厂的初始化 
        
        /*   low_power
             full_dust_box//积尘盒满
             non_dust_box //未找到积尘盒
         "full_dust_box",
         "out_charge_line"//充电线
             charging_faild 
             charing_full 
             charing 
             stop_home 
             start_home//开始回充
             stop_clean
             stop_charge:停止充电 停止回充
             out_charge_line
             standby 待机中
         //nav_cleaning followall_cleaning zone_cleaning emphases_cleaning
         sleep 休眠

         */
        
        DataManager.shareDataManager.robotOpenOrNo = "";//初始化时为空串防止其他机型的数据存留／冠维机“”有sleep不识别charge_or_shutdown
    
        let strJid:NSString = ShareUser.sharedUserInfo().userMode.nowRobotJid! as NSString
        let strJitType :NSString = strJid.substring(to: 2) as NSString
        let typeNum:Int = Int(strJitType.intValue)
        if(typeNum==2){
             TwoCodeIMsgArr = ["low_power","charging_faild","charing_full","stop_chare","stop_charge","standby","sleep"]//状态字段 sleep 冠维独有  1205
        }else{
            TwoCodeIMsgArr = ["low_power","charging_faild","charing_full","stop_chare","stop_charge","standby"]//
        }
      
        
        TwoCodeEMsgArr = ["put_safe_area","edge_brush_right_error","edge_brush_left_error","wheel_overcurrent_right_error","wheel_overcurrent_left_error","battery_error","edge_brush_error","middle_brush_fixed_error","middle_brush_overcurrent_error","clip_error","wheel_overcurrent_error","wheel_fixed_error","infrared_exception_error","infrared_fixed_error","crush_error","fan_fixed_error","fan_overcurrent_error","drop_right_error","drop_middle_error","drop_left_error","drop_exception_error","drop_fixed_error","ultra_exception_error","ultra_fixed_error","infrared_right_error","infrared_middle_error","infrared_left_error","infrared_exception_error","infrared_fixed_error","dangling_right_error","dangling_left_error","dangling_all_error","communication_nav_error","communication_motion_error","imu_exception_error","video_exception_error","2d_exception_error","2d_fixed_error","non_dust_box","full_dust_box","out_charge_line","crash_in_ctrl","drop_in_ctrl"];//二厂的codeERR的type数据组 错误字段
        
         TwoCodeEMsgChangeArr = []
        
    }
    
    

    func delaypopRootVc(){
        self.navigationController?.popToRootViewController(animated: true)//升级数据时，返回列表

    }
    
    //1226修改errorpop
    func showAlet(messageStr:String,index:Int){
        if(errorAlert==nil){//1217

            errorAlert = UIAlertController(title:"", message: "\n\n\n"+messageStr, preferredStyle: UIAlertControllerStyle.alert) //此处的换行符是用于图标显示所占位置
        }else{
            return
        }
        
        let okAletAction = UIAlertAction(title: NSLocalizedString("确认", comment: ""), style: UIAlertActionStyle.cancel) { (UIAlertAction) in
            self.errorAlert = nil //
        }
        errorAlert?.addAction(okAletAction)
        errorAlert?.view.tintColor = DataManager.shareDataManager.colorOfMainType
        
        let imgVOfErrorA:UIImageView = UIImageView(frame: CGRect(x: 116.5, y: 20.0, width: 38, height: 38)) //270 136 -19 117
        
        if(messageStr.contains("E")){
            imgVOfErrorA.image = UIImage(named: "mapErrorImgRed")//红色图标
        }else{
            imgVOfErrorA.image = UIImage(named: "mapErrorImgGreen")//绿色图标
        }
        errorAlert?.view .addSubview(imgVOfErrorA)
        
        self.present(errorAlert!, animated: true, completion: nil)
    }
   
    //MARK:定点按钮点击时判断有无虚拟墙 有虚拟墙暂不弹出定点相关界面
    func haveVirtualWallView() -> Bool {
        if mapScrollView.isScrollEnabled==true {//可滑动 非虚拟墙模式
            return false
        }else{
            self.view.makeToast(NSLocalizedString("当前暂处于虚拟墙操作状态", comment: ""), duration:1, position: "center")
            return true
        }
    }
    
   //MARK:虚拟墙
    func virtualWallHidden() {//关掉虚拟墙 离开编辑状态
        btnOfXnqZhuanSaoQu?.isHidden = true
        btnOfXnqJinSaoQu?.isHidden = true
        btnOfDeletAllXnq?.isHidden = true//虚拟墙清除按钮隐藏
        bottomView.isHidden = false
        self.piaofuBtnShow()
        mapScrollView.isScrollEnabled = true//可滑动
        
        labelOfWallText?.isHidden = true
        v?.isWallCanDraw(false)
        v?.setNeedsDisplay()
        xuniqiangInfoTimerNum = 5//延时接受虚拟墙数据
        vWallQu?.quyuBtnSubBtnIsShow(false);//0130显示删除按钮 否
        vWallQu?.forbiddenQuXmppStrSend()//发送指令（禁止区）
        
    }

    
    func virtualWallShow() {//显示虚拟墙 进入编辑状态

//        if ((routeView != nil) || (routeBottomView != nil) ) {//定点状态？
        if ((routeViewIsDrawIng == true) || (routeBottomView != nil) ) {//定点状态？
            self.cancelAction()
        }
        self.piaofuBtnHiden()
 
        
        if v==nil {
            v = V(frame: CGRect(x: 0, y: 0, width: SCREEN_HEIGHT*2, height: SCREEN_HEIGHT*2))
            
            mapScrollView.addSubview(v!)
            v?.isUserInteractionEnabled = true
            v?.center = mapImageView.center;
            v?.setNeedsDisplay()
        }
        //刷新虚拟墙UI数据
        self.getInfoOfThisRobotWallLine(strOfWallLineInfo: strOfWallLineInfoSave!)//1229新增
        //虚拟墙(区域) 初始化0129新增 放在Vline之上
        if(vWallQu==nil){
            vWallQu = WallQuyuView(frame: CGRect(x: 0, y: 0, width:SCREEN_HEIGHT*2, height: SCREEN_HEIGHT*2))
            mapScrollView.addSubview(vWallQu!)
            vWallQu?.isUserInteractionEnabled = true
            vWallQu?.center = mapImageView.center;
            vWallQu?.vofxuniqingLineView = v
            vWallQu?.setNeedsDisplay()
        }
        if ((v != nil) && (vWallQu != nil)) {//0130
            v?.vbtnInfoBlock = { deletInfodic in ()
                self.vWallQu?.getBtnInfoDic(deletInfodic)
            }
            
        }
        
        mapScrollView.isScrollEnabled = false  //print("-------------------不滑动")

        labelOfWallText?.isHidden = false
        
        v?.canDraw = true
        v?.isWallCanDraw(true)
        btnOfDeletAllXnq?.isHidden = false//虚拟墙清除按钮显示
        btnOfXnqZhuanSaoQu?.isHidden = false
        btnOfXnqJinSaoQu?.isHidden = false
        
        vWallQu?.quyuBtnSubBtnIsShow(true);//0130显示删除按钮
     }
    //MARK:__虚拟墙中心的变化
    func mapImagCenterChangeSetWallChange() {
  
//        print("mapImagCenterChangeSetWallChange = \(strOfWallLineInfoSave)")
        
        if v != nil {
             v?.center = mapImageView.center;
            //刷新虚拟墙UI数据
            self.getInfoOfThisRobotWallLine(strOfWallLineInfo: strOfWallLineInfoSave!)//1229新增
        }
//        print("mapImagCenterChangeSetWallChange QU = \(strOfWallForbidQuInfoSave)")
//        if vWallQu != nil {
//            vWallQu?.center = mapImageView.center;
//            //刷新虚拟墙UI数据
//            self.getInfoOfThisRobotWallQuyu(strOfWallQuyuInfo: strOfWallForbidQuInfoSave!)//0131
//        }
    }
    
    //MARK:__清空该Robot的虚拟墙 1206/在点击清扫时不调用它 在重绘和清空虚拟墙按钮时调用
    func removeThisRobotWallLine(){
        if (v != nil) {
            for  subv in (v?.subviews)! {
                subv.removeFromSuperview()
            }
            
            let arr :NSMutableArray? = nil
            v?.allLineArr = arr
            v?.getArrAndNumLineOfThisRobot()
            v?.setNeedsDisplay()
        }
    }
    //MARK:----虚拟墙清空
    func remoeThisRobotQuWall(){
        
        XmppManager.shareXmppManager.sendMessageToRobot(message: "area_ban 0 0 0 0 0 0 0 0 0 0 0 0 0")
        if(vWallQu != nil){
            //
            vWallQu?.forbiddenXmppStr = "area_ban 0 0 0 0 0 0 0 0 0 0 0 0 0";
            self.strOfWallForbidQuInfoSave = "area_ban 0 0 0 0 0 0 0 0 0 0 0 0 0";
            vWallQu?.getQuyuXmppStr("area_ban 0 0 0 0 0 0 0 0 0 0 0 0 0");
//            self.strOfWallAllowQuInfoSave = "area_allow 0 0 0 0 0";
//            vWallQu?.getQuyuXmppStr("area_allow 0 0 0 0 0");//20190408清除虚拟墙按钮 不做清空专扫区
            
//
        }
        
    }
    //MARK:_——————————————得到虚拟墙信息strOfWallLineInfoSave 重新刷该Robot的虚拟墙
    func getInfoOfThisRobotWallLine( strOfWallLineInfo:NSString ){
        return //20190318不接收虚拟墙线
        strOfWallLineInfoSave = strOfWallLineInfo//1229新增 用于地图imgV更新时使用已存储的Line信息更新坐标（0点和centerP偏移量有变化）
        //处理str得到arrdic
        print("strOfWallLineInfoSave == \(strOfWallLineInfoSave)")
        if (strOfWallLineInfoSave?.length)!<1 {
            return;//数据空时不更新
        }
       var arr:NSMutableArray? = NSMutableArray(array: strOfWallLineInfo.components(separatedBy: " "))
        arr?.removeObject(at: 0)
        print("strOfWallLineInfoSave remove 0 ~>Arr.count == \(arr?.count)")
//        for itemOfArr in arr! {
//            print("得到虚拟墙信息item=\(itemOfArr)")
//        }
        if (v != nil) {
//            for  subv in (v?.subviews)! {
////                subv.removeFromSuperview() //0124不删除直接赋值给虚拟墙 由虚拟墙做更新操作 它会在非划线状态导致闪烁问题
//            }
            //刷新虚拟墙UI数据
            v?.initNewXNQData(arr) //线

        }
 
    }
    //MARK:_——————————————得到虚拟墙信息F区 重新刷该Robot的虚拟墙

    func getInfoOfThisRobotWallQuyu( strOfWallQuyuInfo:NSString ) {
        strOfWallForbidQuInfoSave = strOfWallQuyuInfo
        if(vWallQu != nil){
            vWallQu?.getQuyuXmppStr(strOfWallQuyuInfo as String!);//禁止|允许区
        }
        
    }
    //MARK:______专扫区的更新部分 在info_map里调用 area111
    func getInfoOfThisRobotAllowWallQuyu(strOfAllowWallInfo:NSString) {
//        if(vWallQu != nil){//专扫
//            if ((strOfAllowWallInfo ==  "area_allow") || (strOfWallAllowQuInfoSave?.length==0)) { //(strOfWallAllowQuInfoSave?.contains("area_allow 0 0 0 0 0"))! //清除时
//                //数据不合格
//            }else{
//                if(bottomView==nil)||(moShiBtn==nil){
//                    return;//初始化才进入地图界面时 状态时view没有 则不做更新
//                }
//                //                if(routeView==nil){//在非定点专扫界面时不做更新
//                if(routeViewIsDrawIng==false){//在非定点专扫界面时不做更新
//                    vWallQu?.getQuyuXmppStr(strOfAllowWallInfo as String!);//允许区
//                    print("更新地图时更新专扫00011111")
//                }
//                print("更新地图时更新专扫000000000000")
//            }
//        }
        self.saveZhuanSaoAndNoRouViewTOUPdateXuNiQiangUi(strOfZhuanSaoXmpp: strOfAllowWallInfo as! String)
        
    }
   
    //MARK:____________模式切换的Alert 现在为view 自动 定点 区域 边角
    func modelChangeBtnShowAlert() {
        
        
        if mapModeChoosePopV == nil { //1206修改位置 每次都注册实验 1206位置不修改 每次删除 ／ 新增 notice
            //notic
         NotificationCenter.default.addObserver(self, selector: #selector(modelChangeWillSetModeBtnTitle), name: NSNotification.Name(rawValue: "mapModeChangeNotice"), object: nil)
            //view
            mapModeChoosePopV = Bundle.main.loadNibNamed("MapModeChoosePopView", owner: self, options: nil)!.first as? MapModeChoosePopView
            mapModeChoosePopV!.frame = self.view.frame;
            
        }
        let strOfBtnTitle :String = (moShiBtn!.titleLabel?.text)!
        var nowModeNum:Int = 0
        if  arrOfModelBtnTitleStr.contains(strOfBtnTitle) {
            nowModeNum = arrOfModelBtnTitleStr.index(of:strOfBtnTitle)!
        }
        mapModeChoosePopV?.setModeAnImgBecomeSelectedImg(Int32(nowModeNum))
      
        //show时的动画
        UIView.animate(withDuration: 0.3) {
            self.mapModeChoosePopV?.mapModeVBottomConstranit.constant = 0;
            self.mapModeChoosePopV?.layoutIfNeeded()
           
             self.mapModeChoosePopV?.backgroundColor =  UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
            
         }
        self.view.addSubview(mapModeChoosePopV!)
        return
     
    }
    //MARK:____________模式切换的notice  对应4种模式的方法调用后再判断是否更改btn
    func modelChangeWillSetModeBtnTitle(notification:NSNotification){ //0-4
        
        let strOfnoticeMode : NSString = notification.object as! NSString
        if strOfnoticeMode.length==1 {
            let modeIndex :Int = Int(strOfnoticeMode.intValue)
            if modeIndex == 0{
                //规划自动
                self.locationBtnOfZiDong()
                //定点隐藏
                dingDianCleanImgView.isHidden = true
            }
            if modeIndex == 1{
                //定点
                self.locationBtnOfDingDian()
                //定点隐藏 --此时新点或yes或no 都要隐藏原点
                dingDianCleanImgView.isHidden = true
            }
            if modeIndex == 2{
                //区域
                self.locationBtnOfQuyu()
                //定点隐藏
                dingDianCleanImgView.isHidden = true
            }
            if modeIndex == 3{
                //边角
                self.locationBtnOfBianjia()
                //定点隐藏
                dingDianCleanImgView.isHidden = true
            }
            if modeIndex == 4{
                //4*4
                self.locationBtnOfnewFourFour()
                //定点隐藏
                dingDianCleanImgView.isHidden = true
            }
            
            //模式切换也需要屏蔽5秒
            clearnInfoTimerNum=5;
        }
    }
    
    
    func locationBtnOfZiDong() {//自动清扫
        moShiBtn?.setTitle(arrOfModelBtnTitleStr[0], for: UIControlState.normal)
        arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[0], liduStr: "")
        self.codeErrorOfAddCDXWithCleanBtnTap()
    }
    func locationBtnOfBianjia() {//沿边清扫
        moShiBtn?.setTitle(arrOfModelBtnTitleStr[3], for: UIControlState.normal)
        arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[3], liduStr: "")
        self.codeErrorOfAddCDXWithCleanBtnTap()
    }
 //MARK:__4*4清扫选择
    func locationBtnOfnewFourFour() {
        moShiBtn?.setTitle(arrOfModelBtnTitleStr[4], for: UIControlState.normal)
        arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[4], liduStr: "")
        self.codeErrorOfAddCDXWithCleanBtnTap()
    }
    
    //MARK:__定点清扫
    func locationBtnOfDingDian() {

        routeView = RouteView(frame: CGRect(x: 0, y: 0, width: self.view.width(), height: self.view.height()))
        routeView?.center = self.view.center
        if vWallQu != nil {
           routeView?.wallV = vWallQu
        }
      
       
        routeView?.saveMapScale = mapScale
        routeView?.hidenZhuanSao()//隐藏专扫20190311
        self.view.addSubview(routeView!)
        routeViewIsDrawIng = true //20190329新增属性判断当前的定点是否在绘画过程中
        
        //更换底部按钮群
        bottomView.isHidden = true
        self.piaofuBtnHiden()//漂浮按钮隐藏
        initRouteBottomView()
        
        //初始化时的点
        self.addRouteViewSignImgV()
        
    }
    //定点初始化时的假点击点图标super==蓝色光标
    func addRouteViewSignImgV() {
   
        routeViewSignImgV = UIImageView.init()
        routeViewSignImgV?.image = UIImage(named: "z_dingdiandasao")
        routeViewSignImgV?.frame = CGRect(x: 0, y: 0, width: _width(10), height: _height(12))
        routeViewSignImgV?.center = CGPoint(x: locationImageView.center.x, y: locationImageView.center.y-8)
        routeViewSignImgV?.tag = 888
        locationImageView.superview?.addSubview(routeViewSignImgV!)
    }
    //定点初始化时的假点击图标在点击后的删除方法
    func deletRouteViewSignImgV() {
        routeViewSignImgV?.removeFromSuperview()
    }
    //MARK:__区域
    func locationBtnOfQuyu() {
        isWillGetArreaClearBool = true //请求区域时true
        print("isWillGetArreaClearBool区域是否可以接受,\(isWillGetArreaClearBool)")
        self.timerOfAreaClear = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerOfAreaClearAction), userInfo: nil, repeats: true)

       MBProgressHUD.showMessage(NSLocalizedString("正在请求区域", comment: ""))
        XmppManager.shareXmppManager.sendMessageToRobot(message: "map_zone_split")
        

    }
    func timerOfAreaClearAction() {
        if (self.timerNumOfAreaClear == 30){
            self.timerOfAreaClear?.invalidate()
            self.timerOfAreaClear = nil
            self.timerNumOfAreaClear = 0
            MBProgressHUD.hide()
            self.view.makeToast(NSLocalizedString("区域清扫请求失败", comment: "") , duration: 2, position: "center")
              isWillGetArreaClearBool = false
        }else{
            self.timerNumOfAreaClear+=1
        }
    }
    //MARK:__区域分割数据得到后的处理
    func getAreaClearDataOfImg(arrOfMessage:NSArray) {// map_zone  宽 高  左 上  右 下 个数/0(失败) data
        print(arrOfMessage)
        MBProgressHUD.hide()
        
        self.timerOfAreaClear?.invalidate()
        self.timerOfAreaClear = nil
        self.timerNumOfAreaClear = 0
        //
        let areaNum : Int = Int(arrOfMessage[7] as! String)!
        if areaNum==0 {
            self.view.makeToast(NSLocalizedString("暂无可清扫区域信息，暂不可执行区域清扫", comment: ""), duration: 2, position: "center")
            isWillGetArreaClearBool = false //失败后关闭数据接收允许
            return
        }else{
            //1122在第一次区域清扫后能够得到区域数据
            isWillGetArreaClearBool = false//得到数据后就关闭接受允许   在取消确认请求的时候都置为false 第二次请求的允许
            self.hiddenBlc() //1122去掉比例尺 确认取消后显示

            areaArrOfSaveTapInfo = NSMutableArray.init()
            for _ in 0  ..< areaNum  {
                //arr7存下
                areaArrOfSaveTapInfo?.add("0")
            }
            print("点击img后置换01的arr7数组为 \(areaArrOfSaveTapInfo)")
            
        }
        //xmppmessage存下
        areaGetXmppArrOfMessage  = arrOfMessage
        //区域数据处理
        let areaW : Int = Int(arrOfMessage[1] as! String)!
        let areaH : Int = Int(arrOfMessage[2] as! String)!
        let areaL : Int = Int(arrOfMessage[3] as! String)!
        let areaT : Int = Int(arrOfMessage[4] as! String)!
        let areaR : Int = Int(arrOfMessage[5] as! String)!
        let areaB : Int = Int(arrOfMessage[6] as! String)!
        
        //处理img区域之间的空隙 计算横纵，前后非0且不相等则变为0
        let arr : NSArray = self.areaDatagetArr()//得到img和imgdataArr
        let img : UIImage = arr.firstObject as! UIImage
        //计算得出arr7那个元素下标需要用到该arrImgData
        let arrOfImgDataWithReverse : NSArray = arr.lastObject  as! NSArray//这个在点击事件中会用到,逆序与图片y轴相符
       
        areaArrOfSaveImgData = NSMutableArray(array: arrOfImgDataWithReverse.reversed())

        //创建区域view
        let imgRect :CGRect = CGRect(x: areaL, y: -areaB, width: areaW, height: areaH)
        addAreaViewWithAreaImg(img: img, imgRect: imgRect)
  
    }
    //MARK:__比例尺的显隐 区域时要用
    func hiddenBlc(){
        viewOfScale?.isHidden = true
        viewOfScaleLeftV?.isHidden = true
        viewOfScaleRightV?.isHidden = true
        labelOfScale?.isHidden = true
    }
    func showBlc(){
        viewOfScale?.isHidden = false
        viewOfScaleLeftV?.isHidden = false
        viewOfScaleRightV?.isHidden = false
        labelOfScale?.isHidden = false
    }
    //MARK:__区域分割数据得到后的处理
    //区域数据转img和arr
    //处理img区域之间的空隙 计算横纵，前后非0且不相等则变为0 areaGetXmppArrOfMessage
    func areaDatagetArr() -> NSArray {
        let arrOfMessage:NSArray = areaGetXmppArrOfMessage!
        let areaW : Int = Int(arrOfMessage[1] as! String)!
        let areaH : Int = Int(arrOfMessage[2] as! String)!
        let areaL : Int = Int(arrOfMessage[3] as! String)!
        let areaT : Int = Int(arrOfMessage[4] as! String)!
        let areaR : Int = Int(arrOfMessage[5] as! String)!
        let areaB : Int = Int(arrOfMessage[6] as! String)!
        let areaDataStr : String = arrOfMessage[8] as! String
        //img + arr
       
        let arr : NSArray = self.mapHelper.dealWithAreaClearDataGetAreaImgAndAreaArr(strOfData: areaDataStr, w: areaW, h: areaH, l: areaL, r: areaR, t: areaT, b: areaB, arrOfChangeColor: areaArrOfSaveTapInfo!)
        
        return arr
    }
     //区域Viewc创建
    func addAreaViewWithAreaImg(img:UIImage?,imgRect:CGRect?) {
        self.areaToHidenOtherV()
        let areaVFrame =  CGRect(x: 0, y:0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        areaClearV = AreaClearView(frame: areaVFrame, imgRext: imgRect!, imgOfImgV: img,bottomHight:   bottomView.height())
        areaClearV?.yesBtn.addTarget(self, action: #selector(areaClearYesBtnAction), for: UIControlEvents.touchUpInside)
        areaClearV?.cancelBtn.addTarget(self, action: #selector(areaClearCancelBtnAction), for: UIControlEvents.touchUpInside)
 
        //手势
        let tapGestureOfImg:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(areaImgVTapAction))
        tapGestureOfImg.numberOfTapsRequired = 1
        areaClearV?.imgV.isUserInteractionEnabled = true
        areaClearV?.imgV.addGestureRecognizer(tapGestureOfImg)
        self.view.addSubview(areaClearV!)
    }
    
    
    //MARK:__区域清扫的Img点击事件
    func areaImgVTapAction(tapGes:UITapGestureRecognizer) {
        let tapPoint : CGPoint =  tapGes.location(in: areaClearV)
        print("点击imgV的相对于父视图point是\n \(tapPoint)")
        //获取arrData对应元素下标 areaGetXmppArrOfMessage是与图像左右颠倒的数据 x取--->w-x
      
        let areaW : Float = Float(areaGetXmppArrOfMessage![1] as! String)!
        let areaH : Float = Float(areaGetXmppArrOfMessage![2] as! String)!
        
        let x : Float = Float(tapPoint.x - SCREEN_WIDTH*0.5) + areaW*0.5
        let y : Float = Float(tapPoint.y - SCREEN_HEIGHT*0.5) + areaH*0.5

         var i : Int = Int(y)*Int(areaW)+Int(areaW)-Int(x)-1

        if i>(areaArrOfSaveImgData?.count)! || i<0 {
            return;//计算下标出错
        }
        let getNumImgDataArr : Int = Int(areaArrOfSaveImgData![i] as! String)!
        if getNumImgDataArr == 0 {
            return;//点击到背景
        }
        //0做为背景图颜色，不计入arr7
        let numOfWillChange : Int = Int(areaArrOfSaveTapInfo?[getNumImgDataArr-1] as! String)!
        if (numOfWillChange == 0) {
            areaArrOfSaveTapInfo?[getNumImgDataArr-1] = "1"
        }else{
            areaArrOfSaveTapInfo?[getNumImgDataArr-1] = "0"
        }

        //重新成img
        self.changeColorOfAreaArr()
    }
    
    //MARK:__区域imgV点击后改变arr7的0，1数据，重新成图刷新img
    func changeColorOfAreaArr() {//点击状态得到的位置是img上的点时，改变img
        if (self.areaClearV != nil) {
            let arr : NSArray = self.areaDatagetArr()//得到img和imgdataArr
            let img : UIImage = arr.firstObject as! UIImage
            areaClearV?.img = nil
            areaClearV?.img = img
            areaClearV?.imgV.image = img
        }
    }
    //MARK:__区域清扫的取消 和 确认按钮
    func areaClearYesBtnAction() {
        self.showBlc() //显示比例尺
        isWillGetArreaClearBool = false //确认和取消都置false 之后是发送数据不需要接收
        areaClearV?.removeFromSuperview()
        
        areaClearV?.removeFromSuperview()
        self.areaToShowOtherV()
    
        let numOfarrWithAdd = 7-(areaArrOfSaveTapInfo?.count)!
        
        
        if numOfarrWithAdd<0 {
            for i in numOfarrWithAdd ..< 0  {
                areaArrOfSaveTapInfo?.removeLastObject()
            }
        }else{
            for i in 0 ..< numOfarrWithAdd  {
                areaArrOfSaveTapInfo?.add("0")
            }
        }
 
        var tapInfoStr:String = areaArrOfSaveTapInfo?.componentsJoined(by: " ") as! String
        tapInfoStr = "map_zone_clean "+tapInfoStr
 
        //清扫按钮 有区域指定数据才改名
        if (areaArrOfSaveTapInfo?.contains("1"))! {
 
             moShiBtn?.setTitle(arrOfModelBtnTitleStr[2], for: UIControlState.normal) //"模式：区域清扫"
             arrOfSaveModelAndLiDuChange(moshiStr: tapInfoStr, liduStr: "");//清扫指令存入//存入不发
            self.codeErrorOfAddCDXWithCleanBtnTap()
        }else{
            //提示框 没选择区域
            let s : NSString = bottomView.chargeL.text! as NSString
            if(s.length>2){
               self.view.makeToast("No cleaning area selected", duration: 2, position: "center")
            }else{
                self.view.makeToast("未选择清扫区域", duration: 2, position: "center")
            }
           
        }
        
    }
    func areaClearCancelBtnAction() {
        self.showBlc() //显示比例尺
        if (areaArrOfSaveImgData?.contains("2"))! {
            print("2")
        }
        isWillGetArreaClearBool = false //确认与取消都置false
        areaClearV?.removeFromSuperview()
        self.areaToShowOtherV()
    }
    //区域创建时
    func areaToHidenOtherV(){
        mapScrollView.isHidden = true
      
        bottomView.isHidden = true
        
        self.piaofuBtnHiden()
        
    }
    func areaToShowOtherV(){
        mapScrollView.isHidden = false
       
        bottomView.isHidden = false
        
        self.piaofuBtnShow()
    }
    
    //MARK:______________漂浮按钮初始化
    func piaofuBtn()  {
        //国际化改变长度
        let sone = arrOfModelBtnTitleStr[0] as NSString;
        var viewIsLongMore = false
        if sone.length > 6 {
            viewIsLongMore = true
        }
        
        moShiBtn = UIButton(type: UIButtonType.custom);
        moShiBtn?.setTitle(arrOfModelBtnTitleStr[0], for: UIControlState.normal)
       
        moShiBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        moShiBtn?.titleLabel?.textAlignment = NSTextAlignment.left
        moShiBtn?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        moShiBtn?.setTitleColor(DataManager.shareDataManager.colorOfMainType, for: UIControlState.normal)
 
        if viewIsLongMore {
            moShiBtn?.frame = CGRect(x: 10, y: SCREEN_HEIGHT-bottomView.height()-100, width: 140, height: 35)
        }else{
            moShiBtn?.frame = CGRect(x: 10, y: SCREEN_HEIGHT-bottomView.height()-100, width: 90, height: 35)

        }
        let moShiBtnImg = UIImage(named: "map_MsLdRightImg")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        moShiBtn?.setImage(moShiBtnImg, for: UIControlState.normal);
        moShiBtn?.tintColor = DataManager.shareDataManager.colorOfMainType;
        
        moShiBtn?.backgroundColor = UIColor.white
        moShiBtn?.layer.shadowOffset = CGSize(width: 1, height: 1)
        moShiBtn?.layer.shadowOpacity = 1
        moShiBtn?.layer.shadowRadius = 1
        moShiBtn?.layer.shadowColor = UIColor.lightGray.cgColor
        moShiBtn?.addTarget(self, action: #selector(moShiBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        
        liDuBtn = UIButton(type: UIButtonType.custom);
        liDuBtn?.setTitle(NSLocalizedString("力度：标准", comment: ""), for: UIControlState.normal)
        liDuBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        liDuBtn?.titleLabel?.textAlignment = NSTextAlignment.left
        liDuBtn?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        liDuBtn?.setTitleColor(DataManager.shareDataManager.colorOfMainType, for: UIControlState.normal)
        if viewIsLongMore {
            liDuBtn?.frame = CGRect(x: 10, y: SCREEN_HEIGHT-bottomView.height()-50, width: 140, height: 35)

        }else{
            liDuBtn?.frame = CGRect(x: 10, y: SCREEN_HEIGHT-bottomView.height()-50, width: 90, height: 35)

        }
        let liDuBtnImg = UIImage(named: "map_MsLdRightImg")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        liDuBtn?.setImage(liDuBtnImg, for: UIControlState.normal);
        liDuBtn?.tintColor = DataManager.shareDataManager.colorOfMainType;
        liDuBtn?.backgroundColor = UIColor.white
        liDuBtn?.layer.shadowOffset = CGSize(width: 1, height: 1)
        liDuBtn?.layer.shadowOpacity = 1
        liDuBtn?.layer.shadowRadius = 1
        liDuBtn?.layer.shadowColor = UIColor.lightGray.cgColor
        liDuBtn?.addTarget(self, action: #selector(liDuBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        
        //左文字右图
        ToolOfBasic.btnTextRightAndImgLeft(moShiBtn!)
         ToolOfBasic.btnTextRightAndImgLeft(liDuBtn!)
        self.view.addSubview(moShiBtn!)
        self.view.addSubview(liDuBtn!)
        moShiBtn?.setTitle(arrOfModelBtnTitleStr[4], for: UIControlState.normal) //20190301的初始化的模式数据在添加后写 按钮的箭头位置在自动清扫文本的最大距离
  
        quanPingBtn = UIButton(type: UIButtonType.custom)
        quanPingBtn?.setImage(SkinManager.skin_imageWithTypeAndName(imageName: "map_quanping"), for: UIControlState.normal)
        quanPingBtn?.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        quanPingBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        quanPingBtn?.titleLabel?.textAlignment = NSTextAlignment.center
        quanPingBtn?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        quanPingBtn?.setTitleColor(UIColor.blue, for: UIControlState.normal)
        quanPingBtn?.frame = CGRect(x: SCREEN_WIDTH - 60, y: topView.height()+topView.origin().y+20, width: 40, height: 40)
        quanPingBtn?.backgroundColor = UIColor.white
        quanPingBtn?.layer.shadowOffset = CGSize(width: 1, height: 1)
        quanPingBtn?.layer.shadowOpacity = 1
        quanPingBtn?.layer.shadowRadius = 1
        quanPingBtn?.layer.shadowColor = UIColor.lightGray.cgColor
        quanPingBtn?.addTarget(self, action: #selector(quanPingBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        quanPingBtn?.backgroundColor = UIColor.clear
        self.view.addSubview(quanPingBtn!)

        
        chongHuaBtn = UIButton(type: UIButtonType.custom)
        chongHuaBtn?.setImage(SkinManager.skin_imageWithTypeAndName(imageName: "map_chonghui"), for: UIControlState.normal)
        chongHuaBtn?.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        chongHuaBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        chongHuaBtn?.titleLabel?.textAlignment = NSTextAlignment.center
        chongHuaBtn?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        chongHuaBtn?.setTitleColor(UIColor.blue, for: UIControlState.normal)
        chongHuaBtn?.frame = CGRect(x: SCREEN_WIDTH - 60, y: topView.height()+topView.origin().y+20+45, width: 40, height: 40)
        chongHuaBtn?.backgroundColor = UIColor.white
        chongHuaBtn?.layer.shadowOffset = CGSize(width: 1, height: 1)
        chongHuaBtn?.layer.shadowOpacity = 1
        chongHuaBtn?.layer.shadowRadius = 1
        chongHuaBtn?.layer.shadowColor = UIColor.lightGray.cgColor
        chongHuaBtn?.addTarget(self, action: #selector(chongHuaBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        chongHuaBtn?.backgroundColor = UIColor.clear
        self.view.addSubview(chongHuaBtn!)
        
        dingWeiBtn = UIButton(type: UIButtonType.custom)
        dingWeiBtn?.setImage(SkinManager.skin_imageWithTypeAndName(imageName: "map_dingwei"), for: UIControlState.normal)
        dingWeiBtn?.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        dingWeiBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        dingWeiBtn?.titleLabel?.textAlignment = NSTextAlignment.center
        dingWeiBtn?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        dingWeiBtn?.setTitleColor(UIColor.blue, for: UIControlState.normal)
        dingWeiBtn?.frame = CGRect(x: SCREEN_WIDTH - 60, y: topView.height()+topView.origin().y+20 + 45+45, width: 40, height: 40)
        dingWeiBtn?.backgroundColor = UIColor.white
        dingWeiBtn?.layer.shadowOffset = CGSize(width: 1, height: 1)
        dingWeiBtn?.layer.shadowOpacity = 1
        dingWeiBtn?.layer.shadowRadius = 1
        dingWeiBtn?.layer.shadowColor = UIColor.lightGray.cgColor
        dingWeiBtn?.addTarget(self, action: #selector(dingWeiBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        dingWeiBtn?.backgroundColor = UIColor.clear
        self.view.addSubview(dingWeiBtn!)
        
        //比例尺width: 25,
        viewOfScale = UIView(frame: CGRect(x: SCREEN_WIDTH - 60, y: SCREEN_HEIGHT-bottomView.height()-30, width: 25, height: 2))
        viewOfScaleLeftV = UIView(frame: CGRect(x: SCREEN_WIDTH - 60-1, y: SCREEN_HEIGHT-bottomView.height()-30-1, width: 1, height: 3))
        viewOfScaleRightV = UIView(frame: CGRect(x: SCREEN_WIDTH - 60+25, y: SCREEN_HEIGHT-bottomView.height()-30-1, width: 1, height: 3))
        
        viewOfScale?.backgroundColor = DataManager.shareDataManager.colorOfMainType
        viewOfScaleLeftV?.backgroundColor = viewOfScale?.backgroundColor
        viewOfScaleRightV?.backgroundColor = viewOfScale?.backgroundColor
        self.view?.addSubview(viewOfScale!)
        self.view?.addSubview(viewOfScaleLeftV!)
        self.view?.addSubview(viewOfScaleRightV!)
        
        labelOfScale = UILabel(frame: CGRect(x: SCREEN_WIDTH - 60, y: SCREEN_HEIGHT-bottomView.height()-60, width: 50, height: 25))
        labelOfScale?.font = UIFont.systemFont(ofSize: 11)
        labelOfScale?.textColor = DataManager.shareDataManager.colorOfMainType
//        labelOfScale?.text = "1m"
        labelOfScale?.text = "100cm"
        self.view.addSubview(labelOfScale!)
        
    }
    //MARK:____监控漂浮按钮和单独的监控界面跳转
    func initJiankongPiaofubtn(){
        if(DataManager.shareDataManager.appNowProductTypeNumStr.isEqual(to: "01") || MapVcGetUpXml.getDeviceEqSerial() == "310") {//晶果 + 310 监控 + 其他遥控
            //监控的机型才初始化这个漂浮按钮
            romtePiaofuView = RomtePiaofuView.init(frame:CGRect(x: SCREEN_WIDTH-60, y: SCREEN_HEIGHT-bottomView.height()-120, width: 40, height: 45));
            romtePiaofuView?.isHidden = true //初始时隐藏
            self.view.addSubview(romtePiaofuView!);
            romtePiaofuView!.parentView = self.view;//mapvc.view为其父图属性
            romtePiaofuView?.addClick({ (UIButton) in
                //跳转到单独的监控界面
                self.print("rpiaofu")
                self.goRomtePiaofuBtnAction()
            })
           
        }
        
    }
    //MARK:____监控漂浮按钮的显示和隐藏
    func showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow:Bool) {
        if romtePiaofuView != nil {//310等摄像头机型 该按钮存在时
            if whenCleanOrHuiChongisShow {
                romtePiaofuView?.isHidden = false
            }else{
                romtePiaofuView?.isHidden = true
            }
        }
        
        
    }
    //MARK:_____监控漂浮按钮跳转到单独的监控按钮
    func  goRomtePiaofuBtnAction() {//去单独的监控界面
        XmppManager.shareXmppManager.sendMessageToRobot(message: "response_monitor")//视频监控地址的请求 监控开启命令
        
        let remoteMonitorVc = RemoteMonitorViewController()//监控
        remoteMonitorVc.isOnlyShowMonitor = true; //漂浮按钮点击过去只显示监控相关，不处理遥控等按钮
        
        if(bottomView.clearnBtn.isSelected){//1210 在清扫状态弹出框的初始值
            remoteMonitorVc.isCanClick = false
        }else{
            remoteMonitorVc.isCanClick = true
        }
        if((areaTimeCharge != "") && (areaTimeCharge != nil)){
            remoteMonitorVc.strOfShowAreaTimeCharge = areaTimeCharge! as String
        }
        //errorcode
        remoteMonitorVc.errDeletbloc = { valeOfdeletAr in ()
            
            self.jiankongyaokongData(valeOfdeletArr:valeOfdeletAr!)
        }
        
        self.delegatesJkYk = remoteMonitorVc as? JkYkNeedMessageAndUserStatusDelegate;
        self.navigationController?.pushViewController(remoteMonitorVc, animated: true);
        
    }
    
    //比例尺数据lable文本更新
    func upNumOfBl() {
        let strOfBl:String = String(format: "%d", Int((1.0/mapScale)*100))//0130 view线25像素 直接用于100cm的计算
        labelOfScale?.text =  strOfBl + "cm"
//        print(strOfBl)
//        print(mapScale)
    }
    //1225新增重绘按钮的灰色遮挡View
//    func getCHGrayView(){
    //        chongHuaBtn?.setTitleColor(UIColor.gray, for: UIControlState.normal)
//        if viewOfChonghuiGray == nil {
//            viewOfChonghuiGray = UIView(frame: (chongHuaBtn?.frame)!)
//            viewOfChonghuiGray?.tag = 444
//            viewOfChonghuiGray?.layer.cornerRadius = 5;
//            viewOfChonghuiGray?.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
//            chongHuaBtn?.superview?.addSubview(viewOfChonghuiGray!)
//        }
//    }
    //MARK:漂浮按钮颜色__重绘按钮不可点击状态设置+模式和力度按钮 置为 灰色
    func chongHuiBtnContTapAction(){
        chongHuaBtn?.isUserInteractionEnabled = false

 
        //重绘灰色0110
//        chongHuaBtn?.setImage(UIImage(named: "map_chonghui_gray"), for: UIControlState.normal)
        chongHuaBtn?.setImage(UIImage(named: "chonghui_gray"), for: UIControlState.normal)
        //模式和力度图标颜色
        //0214更换颜色
//        moShiBtn?.tintColor = UIColor.gray
        moShiBtn?.tintColor = UIColor.init(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
        moShiBtn?.isUserInteractionEnabled = false
        moShiBtn?.setTitleColor(UIColor.init(red: 190/255, green: 190/255, blue: 190/255, alpha: 1), for: UIControlState.normal)
        //1129力度在清扫时可以点击则不需要该gray状态

    }
    //MARK:__重绘按钮可点击状态设置+模式和力度按钮颜色 置为 正常
    func chongHuiBtnCanTapAction(){
        //重绘彩色
        chongHuaBtn?.isUserInteractionEnabled = true
        chongHuaBtn?.setImage(SkinManager.skin_imageWithTypeAndName(imageName: "map_chonghui"), for: UIControlState.normal)
 

        moShiBtn?.isUserInteractionEnabled = true
        moShiBtn?.setTitleColor(DataManager.shareDataManager.colorOfMainType, for: UIControlState.normal)
        liDuBtn?.isUserInteractionEnabled = true
        liDuBtn?.setTitleColor(DataManager.shareDataManager.colorOfMainType, for: UIControlState.normal)
        //模式和力度图标颜色
        moShiBtn?.tintColor = DataManager.shareDataManager.colorOfMainType
        liDuBtn?.tintColor = DataManager.shareDataManager.colorOfMainType
        
    }
    
    //MARK:_________________1129_____力度按钮在清扫时显示，其余情况还是依照原情况
    func liduBtnWillSetHidenOrNorNot() {
        if bottomView.clearnBtn.isSelected {
            //清扫模式-->显示力度 可点击且恢复原色
             liDuBtn?.isHidden = false;
            liDuBtn?.isUserInteractionEnabled = true
            liDuBtn?.setTitleColor(DataManager.shareDataManager.colorOfMainType, for: UIControlState.normal)
            //模式和力度图标颜色
            liDuBtn?.tintColor = DataManager.shareDataManager.colorOfMainType
            
        }else{
            //非清扫模式符合原状态，不做操作
        }
    }
     //MARK:_______漂浮btn的显隐
    func piaofuBtnHiden() {
        moShiBtn?.isHidden = true;
        liDuBtn?.isHidden = true;
        chongHuaBtn?.isHidden = true;
        dingWeiBtn?.isHidden = true;
        quanPingBtn?.isHidden = true;
    }
    func piaofuBtnShow() {
        if bottomView.xuNiQiangBtn.isSelected {//虚拟墙时期不显示漂浮按钮
            return
        }
        //选择了定点和区域 全屏之类的其他模式时也应该return。so在定点和区域全屏切换时，先bottomView.isHidden == f再调用show
        if (bottomView.isHidden == true) {
            return
        }
        moShiBtn?.isHidden = false;
        liDuBtn?.isHidden = false;
        chongHuaBtn?.isHidden = false;
        dingWeiBtn?.isHidden = false;
        quanPingBtn?.isHidden = false;
    }
    
    //MARK:_______模式按钮 是否弹出模式选择v
    func moShiBtnAction(sender:UIButton)  {
        
        let isClearning = self.isOrNotClearningType(strOfShowMesg: NSLocalizedString("清扫模式", comment: "") as NSString )
        if isClearning {
            return
        }
        if isHaveErrorCodeFromRobot() {
            //存在codeerr信息不执行点击按钮事件
            self.codeErrOfAddAllErrorWithMostBtnTap()
        }else{
            self.modelChangeBtnShowAlert()
        }
        
    }
    //MARK:_______力度 按钮 是否弹出模式选择v
    func liDuBtnAction(sender:UIButton){
        if isHaveErrorCodeFromRobot() {
            //存在codeerr信息不执行点击按钮
              self.codeErrOfAddAllErrorWithMostBtnTap()
        }else{
            self.liDuChangeBtnShowAlert()
        }
    }
    
    //MARK:____________力度切换的Alert 现为view 标准安静强力
    
    func liDuChangeBtnShowAlert() {

       if mapStrengthChoosePopV == nil {//1206 改位置 还原
        //notic
        NotificationCenter.default.addObserver(self, selector: #selector(strengthChangeWillSetModeBtnTitle), name: NSNotification.Name(rawValue: "mapStrengthChangeNotice"), object: nil)
        //view
            mapStrengthChoosePopV = Bundle.main.loadNibNamed("MapStrengthChoosePopView", owner: self, options: nil)!.first as? MapStrengthChoosePopView
            mapStrengthChoosePopV!.frame = self.view.frame;
            
        }
        let strOfBtnTitle :String = (liDuBtn!.titleLabel?.text)!
        var nowStrengthNum:Int = 0
        if  arrOfStrengthBtnTitleStr.contains(strOfBtnTitle) {
            nowStrengthNum = arrOfStrengthBtnTitleStr.index(of:strOfBtnTitle)!
        }
        mapStrengthChoosePopV?.setImgSelectedOfStrength(Int32(nowStrengthNum))
        
        //show时的动画
        
        mapStrengthChoosePopV?.showStrengthPopV()
        self.view.addSubview(mapStrengthChoosePopV!)
        return
    }
    
    //MARK:——————力度按钮notice
    func strengthChangeWillSetModeBtnTitle(notification:NSNotification){
        
        let strOfnoticeStrength : NSString = notification.object as! NSString
        if strOfnoticeStrength.length==1 {
            let strengthIndex :Int = Int(strOfnoticeStrength.intValue)
            if strengthIndex == 0{
                //发
                
                if(bottomView.clearnBtn.isSelected){
                    XmppManager.shareXmppManager.sendMessageToRobot(message: liduTransferprotocolArr[0])
                }
                //标准
                liDuBtn?.setTitle(arrOfStrengthBtnTitleStr.first, for: UIControlState.normal)
                self.arrOfSaveModelAndLiDuChange(moshiStr: "", liduStr: liduTransferprotocolArr[0])
 
            }
            if strengthIndex == 1{
                //发
                if(bottomView.clearnBtn.isSelected){
                    XmppManager.shareXmppManager.sendMessageToRobot(message: liduTransferprotocolArr[1])
                }
                //静音 存
                liDuBtn?.setTitle(arrOfStrengthBtnTitleStr[1], for: UIControlState.normal)
                self.arrOfSaveModelAndLiDuChange(moshiStr: "", liduStr: liduTransferprotocolArr[1])
 
            }
            if strengthIndex == 2{
                //发
                if(bottomView.clearnBtn.isSelected){
                   XmppManager.shareXmppManager.sendMessageToRobot(message: liduTransferprotocolArr[2])
                    print("\(liduTransferprotocolArr[2]) 力度按钮3")
                }
                //存
                //强力
                liDuBtn?.setTitle(arrOfStrengthBtnTitleStr.last, for: UIControlState.normal)
                self.arrOfSaveModelAndLiDuChange(moshiStr: "", liduStr: liduTransferprotocolArr[2])
 
            }
           //力度切换也要延时接受
            clearnInfoTimerNum=5;
            
        }
    }
    //MARK:_______全屏按钮
    func quanPingBtnAction(sender:UIButton)  {
        self.piaofuBtnHiden()
        self.navigationController?.navigationBar.isHidden = true
        self.bottomView.isHidden = true;
        self.topView.isHidden = true
        self.mapScrollView.frame = self.view.frame
        let btnOfTCQP :UIButton? = UIButton(type: UIButtonType.custom)
        btnOfTCQP?.frame = CGRect(x: SCREEN_WIDTH-50 , y: 50, width: 40, height: 40)
//        btnOfTCQP?.setTitle("退出全屏", for: UIControlState.normal);
        btnOfTCQP?.setImage(UIImage(named: "map_quanping_guanbi"), for: UIControlState.normal)
        btnOfTCQP?.titleLabel?.font = UIFont.systemFont(ofSize:12)
        btnOfTCQP?.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btnOfTCQP?.backgroundColor = UIColor.clear
        btnOfTCQP?.addTarget(self, action: #selector(tcAction), for: UIControlEvents.touchUpInside);
        btnOfTCQP?.tag = 333;
        self.view.addSubview(btnOfTCQP!)
        let transformOfTcBtn : CGAffineTransform = CGAffineTransform(rotationAngle: CGFloat(90 * Double.pi/180.0));
        btnOfTCQP?.transform = transformOfTcBtn

        quanpingSavemapScale = mapScale//存储原缩放大小
        //背景范围过大时，有效图占比小时也会执行
        if mapImageView.width()>0 {//存在img，宽度不为0时
            if mapImageView.width()<SCREEN_WIDTH*0.8 {//扩大
                let beishu = SCREEN_WIDTH / (mapImageView.width()/quanpingSavemapScale) //img原宽度比屏幕宽度
                self.setMapScaleNumWith(newMapScaleNum: beishu)
            }else if(mapImageView.width()>SCREEN_WIDTH*1.2){//缩小
                
                let beishu = SCREEN_WIDTH / (mapImageView.width()/quanpingSavemapScale) //img原宽度比屏幕宽度
                self.setMapScaleNumWith(newMapScaleNum: beishu)
                
            }

        }else{
            //mapImagW==0时不做滚动视图倍数设置
        }
        
    }
    func setMapScaleNumWith(newMapScaleNum: CGFloat){
        mapScale = newMapScaleNum
        mapScrollView.setZoomScale(mapScale, animated: false)
        mapScrollView.contentSize = CGSize(width: SCREEN_HEIGHT*2, height: SCREEN_HEIGHT*2)
        
        self.moveActionOrZoomActionImgChangeOffset() //此设置还用于缩放
        //给虚拟墙更新缩放倍数
        if( v != nil ){
            v?.changeMapScap(mapScale)
        }
        //0130
        if(vWallQu != nil){
            vWallQu?.changeQuVScap(mapScale)
        }
    }
    func tcAction(){
       
        self.navigationController?.navigationBar.isHidden = false
        self.bottomView.isHidden = false;
        self.topView.isHidden = false
        self.piaofuBtnShow()
        self.mapScrollView.frame = CGRect(x: 0, y: topView.bottomY(), width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - topView.height() - bottomView.height())
        //退出按钮
        for btn in self.view.subviews {
            if (btn.tag == 333){//btn.isKind(of: UIButton())) &&
                btn.removeFromSuperview()
            }
        }
        //恢复原mapScale
         self.setMapScaleNumWith(newMapScaleNum: quanpingSavemapScale)//存储的原倍数
        
    }
    //MARK:_______重绘按钮
    func chongHuaBtnAction(sender:UIButton)  {
        
        let isClearning = self.isOrNotClearningType(strOfShowMesg: NSLocalizedString("重绘", comment: "") as NSString)
        if isClearning {
            return
        }
        if isHaveErrorCodeFromRobot() {
            //存在codeerr信息不执行点击按钮事件
              self.codeErrOfAddAllErrorWithMostBtnTap()
        }else{
        
            if alertControllerOfChongHuaBtn==nil {
                alertControllerOfChongHuaBtn = UIAlertController(title: NSLocalizedString("是否清除当前地图信息", comment: ""), message: nil, preferredStyle: UIAlertControllerStyle.alert)
                let alertOne = UIAlertAction(title: NSLocalizedString("确认", comment: ""), style: UIAlertActionStyle.default) { (UIAlertAction) in
                    self.chongHuaYesAction()
                }
                
                let alertcancel = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: UIAlertActionStyle.cancel) { (UIAlertAction) in
                    
                }
                alertControllerOfChongHuaBtn?.addAction(alertOne)
                alertControllerOfChongHuaBtn?.addAction(alertcancel)
                
                
            }
            alertControllerOfChongHuaBtn?.view.tintColor = DataManager.shareDataManager.colorOfMainType
            self.present(alertControllerOfChongHuaBtn!, animated: true, completion: nil)
        }
    }
    
    func chongHuaYesAction()  {//重绘
        
        XmppManager.shareXmppManager.sendMessageToRobot(message: "reset_map")
       
        //map重新请求 及时得到新的 地图数据+虚拟墙数据
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sendrequestMap), userInfo: nil, repeats: false)
        
        self.deletAllXnq() //发送清空指令=====虚拟墙清空

        //清空成 自动|规划 + //显示UI更新 0115
//        arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[0], liduStr: "")
        /**modelTransferProtocolArr
         - 0 : "auto_clean" 自动
         - 1 : "appoint_clean"定点
         - 2 : "map_zone_clean"区域
         - 3 : "followall_clean" 边角
         - 4 : "auto_4_4_clean" 44
         - 5 : "area_allow"定专扫区
         */
        //   20190604
        let nowModelProtocol:String = arrOfSaveModelAndLiDu?[0] as! String
        
        if ( nowModelProtocol.contains( modelTransferProtocolArr[0] ) || nowModelProtocol.contains( modelTransferProtocolArr[3] ) || nowModelProtocol.contains( modelTransferProtocolArr[4] ) ) {
            
            arrOfSaveModelAndLiDuChange(moshiStr: arrOfSaveModelAndLiDu?[0] as! String, liduStr: "")//待发协议和UI文本修改为当前显示的模式
        }else{
           
            self.dingDianCleanImgView.isHidden = true //定点隐藏
            //专扫去掉
            strOfWallAllowQuInfoSave = "area_allow 0 0 0 0 0" //清除专扫
            self.saveZhuanSaoAndNoRouViewTOUPdateXuNiQiangUi(strOfZhuanSaoXmpp: strOfWallAllowQuInfoSave! as String)
            vWallQu?.getQuyuXmppStr(strOfWallAllowQuInfoSave as! String)
            
            arrOfSaveModelAndLiDuChange(moshiStr: modelTransferProtocolArr[4], liduStr: "")//待发协议和as!文本修改为4*4 arr[5]20190604
        }

     
        
        
    }
    
    //MARK:_____虚拟墙清空按钮Action
    func deletAllXnq() {
        //发送清空指令=====虚拟墙清空
        let xmppNilXnqstr = "line 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";
        XmppManager.shareXmppManager.sendMessageToRobot(message: xmppNilXnqstr)
        self.removeThisRobotWallLine()
        
        //QU
        self.remoeThisRobotQuWall()
        
    }
   
    //MARK:_____请求地图信息
    func sendrequestMap()  {
        
        DataManager.shareDataManager.mapImgBeforeData = nil
        DataManager.shareDataManager.mapLeftEnd = 0
        DataManager.shareDataManager.mapTopEnd = 0
        DataManager.shareDataManager.mapRightEnd = 0
        DataManager.shareDataManager.mapBottomEnd = 0
        
        DataManager.shareDataManager.mapLeftBefore = 0
        DataManager.shareDataManager.mapTopBefore = 0
        DataManager.shareDataManager.mapRightBefore = 0
        DataManager.shareDataManager.mapBottomBefore = 0
        mapImageView.image = nil
        XmppManager.shareXmppManager.sendMessageToRobot(message: "request_map")
        print("重新请求地图数据一次")
        
        
        self.removeTrajInfo() //清空轨迹信息
        
    }
    //MARK:___清空轨迹信息
    func removeTrajInfo() {
        DataManager.shareDataManager.trajectorySourceArr = [];
        DataManager.shareDataManager.trajectoryNum = 0;
    }
    //MARK:_____虚拟墙禁扫区按钮Action
    func btnOfXnqJinSaoQuAction() {
        print("虚拟墙 禁扫区按钮")
        //        self.view.makeToast("敬请期待", duration: 1, position: "center");
        
        //做新增操作
        if (vWallQu?.forbiddenDataArr.count)!<3 {
            //        if (vWallQu?.forbiddenDataArr.count)!<5 {
            vWallQu?.addNewForbiddenQu()//添加
        }else{
            self.view.makeToast(NSLocalizedString("禁扫区已达上限", comment: "") , duration: 1, position: "center");
        }
        
    }
    //MARK:______虚拟墙专扫区按钮Action
    func btnOfXnqZhuanSaoQuAction() {
        print("虚拟墙 专扫区按钮")
        self.view.makeToast("敬请期待", duration: 1, position: "center");
    }
    //MARK:---定位按钮
    func dingWeiBtnAction(sender:UIButton)  {
//        定位
        XmppManager.shareXmppManager.sendMessageToRobot(message: "order_where")
        //并且让地图回到中心位置=偏移量到中心位置
        self.mapScrollView.contentOffset = CGPoint(x: self.mapScrollView.contentSize.width*0.5 - SCREEN_WIDTH*0.5, y: self.mapScrollView.contentSize.height*0.5 - SCREEN_HEIGHT*0.5+topView.height())//size0.5会到滚动视图的右上角
        
 

    }
    
    //MARK:___漂浮按钮初始化后arrOfSaveModelAndLiDu初始化 clearnBtn点击后要发的指令存储
    func arrOfSaveModelAndLiDuInit() {

        arrOfModelStr = DataManager.shareDataManager.mapModeArrMain
        arrOfModelBtnTitleStr = DataManager.shareDataManager.mapModeBtnTitleStrMain

        /**命令部分*/
        //模式力度总命令初始化
        var haveNewDataArr = true
        if modelTransferProtocolArr[1].count>13 {
            haveNewDataArr = false
        }else if(modelTransferProtocolArr[2].count>14){
            haveNewDataArr = false
        }else{
            
        }
        if haveNewDataArr {
          modelTransferProtocolArr = ["auto_clean","appoint_clean","map_zone_clean","followall_clean","auto_4_4_clean","area_allow"] ;//1区域和2定点 -->如果有数据则不更新没数据才更新 0 3 4 自动／边角／4*4 //20190313 新增专扫区s协议待更改
        }
        
        liduTransferprotocolArr = ["clean_level 1","clean_level 2","clean_level 3"]
        
        //clearnBtn的点击后传输的命令Arr
        arrOfSaveModelAndLiDu = NSMutableArray.init()
        //初始为自动清扫和标准力度
//        arrOfSaveModelAndLiDu?.add(modelTransferProtocolArr[0]);
//        arrOfSaveModelAndLiDu?.add(liduTransferprotocolArr[0])
        ////////20190229 初始化的状态显示数据和初始化将要发送的的数据 4*4q清扫
        arrOfSaveModelAndLiDu?.add(modelTransferProtocolArr[4])
        arrOfSaveModelAndLiDu?.add(liduTransferprotocolArr[0])
    }
    //MARK:___clearnBtn点击后要发的指令存储

    func arrOfSaveModelAndLiDuChange(moshiStr:String,liduStr:String) {
        //模式
        if(moshiStr.count>0  ){
            //1.以前的模式前缀 == 新的模式前缀 都有同样的前缀时（新的大于旧的才更新，否不更新）
            //2.没有相同的前缀，则不比较直接更新
            
            if ((moshiStr.contains(modelTransferProtocolArr[1]))){//0114 定点区域会被相互替换掉
                //定点
                if(moshiStr.contains(modelTransferProtocolArr[1]) && (arrOfSaveModelAndLiDu![0] as! String).contains(modelTransferProtocolArr[1]) ){
                    if((arrOfSaveModelAndLiDu![0] as! String).count > modelTransferProtocolArr[1].count){
                        if(moshiStr.count>modelTransferProtocolArr[1].count){
                             //原定点 新定点长数据 新传入的定点数据 大于协议头的数据 更新
                              arrOfSaveModelAndLiDu?.replaceObject(at: 0, with: moshiStr)
                        }else{
                             //moshistr非新数据 已有数据 比较 协议头 不更新
                        }
                       
                    }else{
                        arrOfSaveModelAndLiDu?.replaceObject(at: 0, with: moshiStr)
                    }
                    
                }else{//得到定点 原本非定点数据时
                    arrOfSaveModelAndLiDu?.replaceObject(at: 0, with: moshiStr)
                }
                
            }else if ((moshiStr.contains(modelTransferProtocolArr[5]))){//20190313新增专扫区数据
                //专扫
                if(moshiStr.contains(modelTransferProtocolArr[5]) && (arrOfSaveModelAndLiDu![0] as! String).contains(modelTransferProtocolArr[5]) ){
                    if((arrOfSaveModelAndLiDu![0] as! String).count > modelTransferProtocolArr[5].count){
                        if(moshiStr.count>modelTransferProtocolArr[5].count){
                            //原定点 新定点长数据 新传入的专扫数据 大于协议头的数据 更新
                            arrOfSaveModelAndLiDu?.replaceObject(at: 0, with: moshiStr)
                        }else{
                            //moshistr非新数据 已有数据 比较 协议头 不更新
                        }
                        
                    }else{
                        arrOfSaveModelAndLiDu?.replaceObject(at: 0, with: moshiStr)
                    }
                    
                }else{//得到专扫 原本非专扫数据时 直接更新
                    arrOfSaveModelAndLiDu?.replaceObject(at: 0, with: moshiStr)
                }
                
                
            }else if ((moshiStr.contains(modelTransferProtocolArr[2]))){
                //区域模式格式  非协议开头  协议开头
                //1.以前的模式前缀 == 新的模式前缀 都有同样的前缀时（新的大于旧的才更新，否不更新）
                //2.没有相同的前缀，则不比较直接更新
                if(moshiStr.contains(modelTransferProtocolArr[2]) && (arrOfSaveModelAndLiDu![0] as! String).contains(modelTransferProtocolArr[2])){
                    if((arrOfSaveModelAndLiDu![0] as! String).count>modelTransferProtocolArr[2].count){
                        //
                        if(moshiStr.count>modelTransferProtocolArr[2].count){
                            //原区域后区域长数据 新传入的区域数据 大于协议头的数据 更新
                              arrOfSaveModelAndLiDu?.replaceObject(at: 0, with: moshiStr)
                        }else{
                            //moshistr非新数据 已有数据 比较 协议头 不更新
                        }
                        
                    }else{
                        arrOfSaveModelAndLiDu?.replaceObject(at: 0, with: moshiStr)
                    }
                    
                }else{
                    arrOfSaveModelAndLiDu?.replaceObject(at: 0, with: moshiStr)
                }
            }else{//___非定点非区域
                //自动清扫和边角清扫44 直接赋值
                if(moshiStr.contains(modelTransferProtocolArr[0])){
                    arrOfSaveModelAndLiDu?.replaceObject(at: 0, with: moshiStr)//将要发送的数据
                    //刷新UI 0
                    moShiBtn?.setTitle(arrOfModelBtnTitleStr[0], for: UIControlState.normal)
                }
                if(moshiStr.contains(modelTransferProtocolArr[3])){
                    arrOfSaveModelAndLiDu?.replaceObject(at: 0, with: moshiStr)//将要发送的数据
                    //刷新UI 3
                   moShiBtn?.setTitle(arrOfModelBtnTitleStr[3], for: UIControlState.normal)
                }
                if(moshiStr.contains(modelTransferProtocolArr[4])){
                    arrOfSaveModelAndLiDu?.replaceObject(at: 0, with: moshiStr)//将要发送的数据
                    //刷新UI 4
                    moShiBtn?.setTitle(arrOfModelBtnTitleStr[4], for: UIControlState.normal)
                }
            }
        }
        if(liduStr.count>0) {
             arrOfSaveModelAndLiDu?.replaceObject(at: 1, with: liduStr)
        }

    }
    //MARK:____clearnBtn点击后 模式指令不符合时 （区域／定点）提示框
    func showThisModeNeedRequestAlertView(strOfMode:String) {
        var strOfShowNeewRequestModeInfo:String = ""
        if strOfMode=="定点" {
            strOfShowNeewRequestModeInfo = NSLocalizedString("请选择模式", comment: "")
        }
        if strOfMode == "区域" {
            strOfShowNeewRequestModeInfo = NSLocalizedString("请选择模式", comment: "")
        }
        if strOfMode == "专扫" {
            strOfShowNeewRequestModeInfo = NSLocalizedString("请选择模式", comment: "")
        }
        
        strOfShowNeewRequestModeInfo = NSLocalizedString("请选择模式", comment: "")
        let alertOfShowNeewRequestModeInfo:UIAlertController = UIAlertController(title: NSLocalizedString("提示", comment: "") , message:strOfShowNeewRequestModeInfo , preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("知道了",comment: ""), style: UIAlertActionStyle.cancel) { (action) in
        }
        alertOfShowNeewRequestModeInfo .addAction(cancelAction)
        alertOfShowNeewRequestModeInfo.view.tintColor = DataManager.shareDataManager.colorOfMainType
        self.present(alertOfShowNeewRequestModeInfo, animated: true, completion: nil)

    }
    
    
    //MARK:___mm底部label点击事件
    func bottommLabelAction(ges:UITapGestureRecognizer) {
        
        let tagN:Int = (ges.view?.tag)!-200
        print("bottommLabelAction \(tagN)")
        switch tagN {
        case 0:
            self.bottommBtnAction(sender: bottomView.clearnBtn)
            break
        case 1:
             self.bottommBtnAction(sender: bottomView.chargeBtn)
            break
        case 2:
             self.bottommBtnAction(sender: bottomView.yuYueBtn)
            break
        case 3:
             self.bottommBtnAction(sender: bottomView.xuNiQiangBtn)
            break
        case 4:
             self.bottommBtnAction(sender: bottomView.jiankongBtn)
            break
        default:
            break
        }
    }
    //MARK:___mm底部按钮点击事件
    func bottommBtnAction(sender:UIButton) {
        
        if isHaveErrorCodeFromRobot() {
            //存在codeerr信息不执行点击按钮事件
            self.codeErrOfAddAllErrorWithMostBtnTap()
        }else{
            
            switch sender.tag-200 {
            case  0://清扫停止
                
                if sender.isSelected{//点击了暂停
                    bottommBtnOfGoClearnOrChargeAlert(sendxmppstr: "order_pause")
                   
//                    MapBottomViewChangeTool.showAllBottomV(bottomView)//在弹出框里确认按钮后置showall
                }else{//点击了清扫按钮
                    if (self.arrOfSaveModelAndLiDu?.count)!<2{
                        print("扫地机的模式力度数组数据error");
                        return;
                    }
                    let clearnModel :String = self.arrOfSaveModelAndLiDu![0] as! String
                    let clearnLidu :String = self.arrOfSaveModelAndLiDu![1] as! String
                    //判断是否为合法有效的清扫模式指令，若为定点／区域的协议开头则提示框
                    //定点
                    if(clearnModel.contains(modelTransferProtocolArr[1]) && clearnModel == modelTransferProtocolArr[1]){
                        self.showThisModeNeedRequestAlertView(strOfMode: "定点")
                        //弹出框
                        return;
                    }
                    //专扫
                    if(clearnModel.contains(modelTransferProtocolArr[5]) && clearnModel == modelTransferProtocolArr[5]){
                        self.showThisModeNeedRequestAlertView(strOfMode: "专扫")
                        //弹出框
                        return;
                    }
                    //区域
                    if(clearnModel.contains(modelTransferProtocolArr[2]) && clearnModel == modelTransferProtocolArr[2]){
                         self.showThisModeNeedRequestAlertView(strOfMode: "区域")
                        //弹出框
                        return;
                    }

                    if( clearnModel=="area_allow 0 0 0 0 0" || clearnModel=="area_allow"){
                         self.showThisModeNeedRequestAlertView(strOfMode: "专扫")
                        return
                    }
                   
                    XmppManager.shareXmppManager.sendMessageToRobot(message: clearnModel);
                    XmppManager.shareXmppManager.sendMessageToRobot(message: clearnLidu);
//                    bottommBtnOfGoClearnOrChargeAlert(sendxmppstr: clearnModel) //清扫按钮不用弹出框
                    bottomView.clearnL.text = NSLocalizedString("暂停", comment: "")//当前按钮设为已点击
                    self.isCleaningType()
                    
                    //重绘按钮的不可点击状态
                    self.chongHuiBtnContTapAction()
                    
                    //定点显示隐藏
                    if(clearnModel.contains("appoint_clean")){
                        dingDianCleanImgView.isHidden = false
                    }else{
                       dingDianCleanImgView.isHidden = true
                    }
                    
                    
                    sender.isSelected = !sender.isSelected
                    bottomView.chargeBtn.isSelected = false
                    //这两个数据会屏蔽掉按钮状态的更新
                    huichongInfoTimerNum = 2
                    clearnInfoTimerNum = 6

                    /////*******设置力度可以在清扫时点击
                    self.liduBtnWillSetHidenOrNorNot()
                    if (huichongStatyThereHaveBeen==true){
                        huichongStatyThereHaveBeen = false
                        DataManager.shareDataManager.mapImgBeforeData = nil//0103 只要回充过,本地存储的地图数据在下次点击清扫按钮时就清空
                        initSendXmppOfCAndMAndInfo()
                    }
                    
                  self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: true) //20190524 监控漂浮按钮显示
                }
                
                break
            case  1://回充
                if sender.isSelected{
                    XmppManager.shareXmppManager.sendMessageToRobot(message: "order_pause");//暂停指令
//                     bottommBtnOfGoClearnOrChargeAlert(sendxmppstr: "order_pause")
//
                    self.chongHuiBtnCanTapAction()  //__重绘按钮可点击状态设置
                    sender.isSelected = !sender.isSelected
                    clearnInfoTimerNum = 2
                    huichongInfoTimerNum = 3
                    MapBottomViewChangeTool.showAllBottomV(bottomView)
                     self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: false) //20190524 监控漂浮按钮显示
                }else{
    
                    if(sweeperStatusLabel.text == NSLocalizedString("充电中", comment: "") ){
                        self.view.makeToast(NSLocalizedString("当前已经是充电状态", comment: "") , duration: 1.0, position: "center") //不可点击
                        return
                        
                    }
                    if(bottomView.clearnBtn.isSelected){//提示框
                        bottommBtnOfGoClearnOrChargeAlert(sendxmppstr: "charge")
                        return
                    }else{//直接发
                       //非清扫模式则
                        XmppManager.shareXmppManager.sendMessageToRobot(message: "charge");
                        self.chongHuiBtnContTapAction()
                        sender.isSelected = !sender.isSelected
                        bottomView.clearnBtn.isSelected = false
                        bottomView.clearnL.text = NSLocalizedString("清扫", comment: "")
                        clearnInfoTimerNum = 2
                        huichongInfoTimerNum = 3
                        self.bottomViewChangeOfShowWith(showView: bottomView.chargeBtn)
                        self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: true) //20190524 监控漂浮按钮显示
                    }
                     
                }
                break
            case  2://预约
                self.pushYuYueVc()
                break
            case  3://虚拟墙
                if sender.isSelected {
                    print("虚拟墙隐藏")
                     sender.isSelected = !sender.isSelected//此为了点击事件后的漂浮按钮显示隐藏问题得先置状态
                    self.virtualWallHidden()
                    MapBottomViewChangeTool.showAllBottomV(bottomView)
                }else{
                    print("虚拟墙显示")
                     sender.isSelected = !sender.isSelected
                    self.virtualWallShow()
                    self.bottomViewChangeOfShowWith(showView: bottomView.xuNiQiangBtn)
                }
               
                break
            case  4://监控或者遥控
                if(DataManager.shareDataManager.appNowProductTypeNumStr.isEqual(to: "01") || MapVcGetUpXml.getDeviceEqSerial() == "310") {//晶果 + 310 监控 + 其他遥控
                    
                }else{
                    sender.isSelected = !sender.isSelected  //遥控不跳转了所以当前的按钮状态要切掉 当前按钮状态会影响接收msg更新UI
                }
                self.pushJiankongVc()
                break
            default:
                break
            }

        }
        
    }
    //MARKL:---------底部按钮按下后出现的弹出框
    func bottommBtnOfGoClearnOrChargeAlert(sendxmppstr:String){
        var titleMsg = NSLocalizedString("是否停止清扫去充电", comment: "")
        if(sendxmppstr == "charge"){//回充
            titleMsg = NSLocalizedString("是否停止清扫去充电", comment: "")
        }else if(sendxmppstr == "order_pause"){//停止清扫"order_pause");回充按钮停止直接发送不做弹出框
            titleMsg = NSLocalizedString("是否暂停清扫", comment: "")
        }else{
            titleMsg = NSLocalizedString("是否开始清扫", comment: "")
        }
        let alertVcGoClearnOrCharge = UIAlertController(title:titleMsg , message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let alertOne = UIAlertAction(title: NSLocalizedString("确认", comment: ""), style: UIAlertActionStyle.default) { (UIAlertAction) in
            XmppManager.shareXmppManager.sendMessageToRobot(message: sendxmppstr)
            if(sendxmppstr == "charge"){//回充
                self.setClearingUi(isclarning: false)
                self.setChargeUi(isCharge: true)
                self.chongHuiBtnContTapAction() //回充按钮状态
              //回充按钮单个显示20190325
                self.bottomViewChangeOfShowWith(showView: self.bottomView.chargeBtn)
            }else if(sendxmppstr == "order_pause"){//停止清扫  停止回充
                self.setClearingUi(isclarning: false)
                self.setChargeUi(isCharge: false)
                self.chongHuiBtnCanTapAction() //回充按钮
            //显示全部底部按钮
                MapBottomViewChangeTool.showAllBottomV(self.bottomView)
            }else{//清扫
                self.setClearingUi(isclarning:true)
                self.setChargeUi(isCharge:false)
                self.chongHuiBtnContTapAction() //回充按钮
                let clearnLidu :String = self.arrOfSaveModelAndLiDu![1] as! String
                XmppManager.shareXmppManager.sendMessageToRobot(message: clearnLidu);
                //定点显示隐藏
                if(sendxmppstr.contains("appoint_clean")){
                    self.dingDianCleanImgView.isHidden = false
                }else{
                    self.dingDianCleanImgView.isHidden = true
                }
               //显示清扫单个按钮
                self.isCleaningType()
            }
        }
        
        let alertcancel = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: UIAlertActionStyle.cancel) { (UIAlertAction) in
            //UI状态保持原样
        }
        alertVcGoClearnOrCharge.addAction(alertOne)
        alertVcGoClearnOrCharge.addAction(alertcancel)
        alertVcGoClearnOrCharge.view.tintColor = DataManager.shareDataManager.colorOfMainType
        self.present(alertVcGoClearnOrCharge, animated: true, completion: nil)
    
    }
    func setClearingUi(isclarning:Bool) {
        if(isclarning){
            bottomView.clearnBtn.isSelected = true
            bottomView.clearnL.text = NSLocalizedString("暂停", comment: "")
          
        }else{
            bottomView.clearnBtn.isSelected = false
            bottomView.clearnL.text = NSLocalizedString("清扫", comment: "")
            self.showOrHidenJiankongPiaofuBtn(whenCleanOrHuiChongisShow: false) //20190524 监控漂浮按钮隐藏
            
        }
        huichongInfoTimerNum = 2
        clearnInfoTimerNum = 6
    }
    func setChargeUi(isCharge:Bool) {
        if(isCharge){
            bottomView.chargeBtn.isSelected = true;
        }else{
            bottomView.chargeBtn.isSelected = false;
        }
        clearnInfoTimerNum = 2
        huichongInfoTimerNum = 3
    }
    //预约
    func pushYuYueVc() {
        
       let appointmentListViewController =  AppointmentListViewController()
        
       self.delegatesJkYk = appointmentListViewController as? JkYkNeedMessageAndUserStatusDelegate //协议换掉
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
     self.navigationController?.pushViewController(appointmentListViewController, animated: true)

    }
    //MARK:_____________________监控遥控界面跳转
    func pushJiankongVc() {
        
        if(DataManager.shareDataManager.appNowProductTypeNumStr.isEqual(to: "01") || MapVcGetUpXml.getDeviceEqSerial() == "310") {//晶果 + 310 监控 + 其他遥控
//        if(!DataManager.shareDataManager.appNowProductTypeNumStr.isEqual(to: "01")) {//用于测试
        
           XmppManager.shareXmppManager.sendMessageToRobot(message: "response_monitor")//视频监控地址的请求 监控开启命令
            
            let remoteMonitorVc = RemoteMonitorViewController()//监控

            if(bottomView.clearnBtn.isSelected){//1210 在清扫状态弹出框的初始值
                remoteMonitorVc.isCanClick = false
            }else{
                remoteMonitorVc.isCanClick = true
            }
             if((areaTimeCharge != "") && (areaTimeCharge != nil)){
                remoteMonitorVc.strOfShowAreaTimeCharge = areaTimeCharge! as String
            }
            //errorcode
            remoteMonitorVc.errDeletbloc = { valeOfdeletAr in ()
                
                self.jiankongyaokongData(valeOfdeletArr:valeOfdeletAr!)
            }
            
            self.delegatesJkYk = remoteMonitorVc as? JkYkNeedMessageAndUserStatusDelegate;
            self.navigationController?.pushViewController(remoteMonitorVc, animated: true);
       
        }else{
            //20190318遥控不跳转，在mapvc弹出遥控v;
            //view
            if(remoteControlPopView == nil){
                remoteControlPopView = Bundle.main.loadNibNamed("RemoteControlPopView", owner: self, options: nil)!.first as? RemoteControlPopView
                remoteControlPopView!.frame = CGRect.init(x: SCREEN_WIDTH*0.5, y: SCREEN_HEIGHT-bottomView.height()-SCREEN_WIDTH*0.55, width: SCREEN_WIDTH*0.44, height: SCREEN_WIDTH*0.55);
                self.view.addSubview(remoteControlPopView!)
                remoteControlPopView?.initData()
                remoteControlPopView?.initView()
                
                self.bottomViewChangeOfShowWith(showView: bottomView.jiankongBtn)
                
               
            }else{
                //存在
                remoteControlPopView?.isHidden = !(remoteControlPopView?.isHidden)!
                if ((remoteControlPopView?.isHidden)!){
                     //   ORDER_brushback = "order_brush 1";//退出遥控
                    XmppManager.shareXmppManager.sendMessageToRobot(message: "order_brush 1") //风机自动
                    MapBottomViewChangeTool.showAllBottomV(self.bottomView)
                }else{
//                    let vOfBtn:UIButton = bottomView.jiankongBtn
//                    let tagOfbtn:Int = Int(vOfBtn.tag)
//                    MapBottomViewChangeTool.hidenOtherAndMoveOneBtnLable(withBtnTag:Int32(tagOfbtn) ,bottomV: self.bottomView)
                     self.bottomViewChangeOfShowWith(showView: bottomView.jiankongBtn)
                }
            }
        }
    }
    
    //MARK:_______20190325得到xmpp某状态，设置底部按钮单个view显示/隐藏的方法
    func getxmmppOfShowBottomOneVorShowBottomAllView(xmppmessage:String) {
        /**
         待机中-----不需要显示单个view 以用户手机端当前操作为准
         回充----不需要显示单个view-已做按钮设置
         充电中---不需要显示单个view
         关机充电中 charging+isopen=0+不是某品牌---不需要显示单个view
         清扫中f-cleaninfo>0和xxcleaning
         虚拟墙禁扫区编辑中---不用接收xmpp
         遥控中-不用接收xmpp
         */
        //显示全部底部按钮
        if(bottomView.xuNiQiangBtn.isSelected || bottomView.jiankongBtn.isSelected){
            //虚拟墙禁扫区和监控按钮在已点击时不做全显
            return;
        }
        
        if (xmppmessage.contains("clean_info")){
            //不做显示
            if !(xmppmessage.contains("clean_info 0")){
                //显示清扫的单个view
                if(clearnInfoTimerNum<=0&&huichongInfoTimerNum<=0){ //接收方要在info=0时才处理界面 此时非清扫非回充 防止点击后被旧数据置回旧状态
                    if(bottomView.xuNiQiangBtn.isSelected || bottomView.jiankongBtn.isSelected){
                        // //虚拟墙禁扫区和监控按钮在已点击时不处理
                    }else{
                        self.isCleaningType()
                    }
                    
                }
            }
        }
        if (xmppmessage.contains("_cleaning")) {//处于某种清扫状态 nav_cleaning followall_cleaning zone_cleaning emphases_cleaning nav_cleaning_4_4
            //接收方要在info=0时才处理界面 此时非清扫非回充 防止点击后被旧数据置回旧状态
            if(clearnInfoTimerNum<=0&&huichongInfoTimerNum<=0){ //接收方要在info=0时才处理界面 此时非清扫非回充 防止点击后被旧数据置回旧状态
                if(bottomView.xuNiQiangBtn.isSelected || bottomView.jiankongBtn.isSelected){
                    // //虚拟墙禁扫区和监控按钮在已点击时不处理
                }else{
                    self.isCleaningType()
                }
            }
            
            if(!xmppmessage.contains("area_allow")){//非专扫的其他清扫状态
                strOfWallAllowQuInfoSave = "area_allow 0 0 0 0 0" //清除专扫
                self.saveZhuanSaoAndNoRouViewTOUPdateXuNiQiangUi(strOfZhuanSaoXmpp: strOfWallAllowQuInfoSave as! String)
            }
        }
        
        if (xmppmessage.contains("start_home")){//处于正在回充状态
            if(clearnInfoTimerNum<=0&&huichongInfoTimerNum<=0){ //接收方要在info=0时才处理界面 此时非清扫非回充 防止点击后被旧数据置回旧状态
                if(bottomView.xuNiQiangBtn.isSelected || bottomView.jiankongBtn.isSelected){
                    // //虚拟墙禁扫区和监控按钮在已点击时不处理
                }else{
                   self.bottomViewChangeOfShowWith(showView: bottomView.chargeBtn)
                    
                }
            }
           
        }
        if (xmppmessage.contains("sleep") || xmppmessage.contains("standby") || xmppmessage.contains("stop_chare") || xmppmessage.contains("stop_clean") || xmppmessage.contains("stop_home") || xmppmessage.contains("stop_charge") || xmppmessage.contains("charging_faild") || xmppmessage.contains("charing") || xmppmessage.contains("charging") ) {
//            //显示全部底部按钮
            if(bottomView.xuNiQiangBtn.isSelected || bottomView.jiankongBtn.isSelected){
                //虚拟墙禁扫区和监控按钮在已点击时不做全显
            }else{
                if(clearnInfoTimerNum<=0&&huichongInfoTimerNum<=0){//接收方要在info=0时才处理界面 此时非清扫非回充 防止点击后被旧数据置回旧状态
                     MapBottomViewChangeTool.showAllBottomV(bottomView)
                }
               
            }
            
//
        }
    }
    
    func isCleaningType(){
        //显示清扫的单个view
        self.bottomViewChangeOfShowWith(showView: bottomView.clearnBtn)
        piaofuBtnShow()
        if(self.remoteControlPopView != nil)&&(self.remoteControlPopView?.isHidden==false){
            self.remoteControlPopView?.isHidden = true;
        }
    }
    

    //MARK:_____________20190320————————————————————————————————_底部显示单个按钮View的方法
    func bottomViewChangeOfShowWith(showView :UIView){
        let vOfBtn:UIView = showView
        let tagOfbtn:Int = Int(vOfBtn.tag)
        MapBottomViewChangeTool.hidenOtherAndMoveOneBtnLable(withBtnTag:Int32(tagOfbtn) ,bottomV: self.bottomView)
    }
    
    func jiankongyaokongData(valeOfdeletArr:String) {
        if(valeOfdeletArr.contains("code")){
            self.TwoCodeEMsgChangeArr = []
            return
        }
        self.chongHuiBtnContTapAction() //重绘按钮的不可点击状态
        self.dingDianCleanImgView.isHidden = false//定点显示隐藏
        self.huichongInfoTimerNum = 2//这两个数据会屏蔽掉按钮状态的更新
        self.clearnInfoTimerNum = 6
        if(valeOfdeletArr=="auto_clean"){
            self.bottomView.clearnBtn.isSelected = true
            self.bottomView.chargeBtn.isSelected = false
        }else{
            self.bottomView.clearnBtn.isSelected = false
            self.bottomView.chargeBtn.isSelected = true
        }
    }
    
    //MARK:____国际化数据转化
    func msgToolOfGjh(msgTxt:String) -> String {
        var returnStr = ""
        if ( msgTxt == nil || msgTxt == ""){
             return ""
        }else{//非空
           
            if (ToolOfBasic.haveChinese(msgTxt)){//有中文 直接国际化 数据字母转换后国际化返回
                returnStr =  NSLocalizedString(msgTxt, comment: "")
            }else{
                let msgOfnewTxt :String =  MapMsgLocalizeStrChangeTool.localizeCodeMsg(withIntStr: msgTxt)
                returnStr =  msgOfnewTxt
            }
            return returnStr
        }
    }
    
    //MARK:___________________
    

}

