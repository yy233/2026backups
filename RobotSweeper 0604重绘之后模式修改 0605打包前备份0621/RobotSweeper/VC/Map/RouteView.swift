//
//  RouteView.swift
//  RobotSweeper
//
//  Created by 美超刘 on 2017/6/14.
//  Copyright © 2017年 美超刘. All rights reserved.
//

import UIKit

class RouteView: UIView {

    
    var drawLayer : CALayer?
    var targetBtn : UIButton?
//    var switchOfDingDianView : UISwitch? //20190304新增专扫区(可拖动可缩放等操作的一个UI)
    var switchOfDingDianView : XYSwitch? //20190304新增专扫区(可拖动可缩放等操作的一个UI)
    
    var wallV:WallQuyuView?//2019新增专扫 此处用于坐标传输
    
    var strOfRouteSaveAllowWall:String? = "area_allow 1 0 0 0 0" //用来存起来做图像处理的数据+接受xmpp所得到的数据（定点专扫状态下出现）
    var saveMapScale:CGFloat? //每次新的定点打开时会传入地图当前缩放的MapScale
    var thisStateOfPanOrZoom:Int = 10;//初始化(第一个拖动手指点击处)的状态，非拖动，非缩放。
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.autoresizesSubviews = true
        self.isUserInteractionEnabled = true
//        self.backgroundColor = .red
          self.backgroundColor = .clear
        initCommon()
    }
    func initCommon(){
        drawLayer = CALayer()
        drawLayer?.frame = CGRect(x: 0, y: 0, width: self.layer.frame.size.width, height: self.layer.frame.size.height)
        self.layer.addSublayer(drawLayer!)
        //点（定点使用手势）
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapAction(ges:)))
        self.addGestureRecognizer(tapGes)
        //拖动（专扫使用手势）
        let panGes = UIPanGestureRecognizer(target: self
            , action: #selector(panAction(ges:)))
        self.addGestureRecognizer(panGes)
        
        //20190304新增专扫区
        //定点和专扫的转化开关
// NSLocalizedString("", comment: "")
        switchOfDingDianView = XYSwitch.init(textFont:UIFont.systemFont(ofSize: 12), onText: NSLocalizedString("专扫", comment: ""), offText: NSLocalizedString("定点", comment: ""), onBackGroundColor: DataManager.shareDataManager.colorOfMainType, offBackGroundColor: DataManager.shareDataManager.colorOfMainType, onButtonColor: UIColor.white, offButtonColor: UIColor.white, onTextColor: UIColor.black, andOffTextColor: UIColor.black)
        switchOfDingDianView?.frame = CGRect(x: 20, y: self.layer.frame.size.height-150, width: 80, height: 35)
        self.addSubview(switchOfDingDianView!)
//        switchOfDingDianView?.isHidden = true
        
        switchOfDingDianView?.changeStateBlock = {(isOn:Bool)->Void in
            if(isOn){
                //关闭状态（定点）->转为开启状态（专扫）
                //隐藏定点
                 self.showOrHiddenDiandian(isHiden: true)
                //显示专扫
                self.showZhuanSao() //新建
              
            }else{
                //开启状态(专扫)->转为关闭状态（定点）
                self.showOrHiddenDiandian(isHiden: false) //显示定点
                self.hidenZhuanSao()//隐藏专扫
            }
            
        };
        
    }
    //定点的点击手势
    func tapAction(ges:UITapGestureRecognizer){
        print("点击开始")
        if switchOfDingDianView?.isOn == true{
            //已点击 这是专扫区的手势执行条件
            return;
        }else{
            //未点击 定点区的手势执行条件
            
        }
        if targetBtn == nil{
            targetBtn = UIButton(type: .custom)
            targetBtn?.frame = CGRect(x: 0, y: 0, width: _width(10), height: _height(12))
            //            targetBtn?.setBackgroundImage(SkinManager.skin_imageWithName(imageName: "target"), for: .normal)
            targetBtn?.setBackgroundImage(UIImage(named: "dingdiandasao"), for: UIControlState.normal) //dingdiandasao  z_dingdiandasao
        }
        targetBtn?.center = ges.location(in: self)
        self.addSubview(targetBtn!)
        
    }
   
    
    
    func showOrHiddenDiandian(isHiden:Bool) {
        //显示定点或隐藏定点
        if(self.targetBtn == nil){
            for sv in ((self.superview?.subviews)!) {
                if sv.isKind(of: UIScrollView.self){
                    for dingdianImgV in ((sv.subviews)) {
                        if (dingdianImgV.tag == 888 ){
                            dingdianImgV.isHidden = isHiden
                        }
                    }
                }
                
            }
            
        }else{
            self.targetBtn?.isHidden = isHiden
        }
    }
   
    
    //MARK:____——————————————专扫的显隐
     //显示专扫
    func showZhuanSao() {

//        print("area_allow 专扫数据刷新虚拟墙UI")
//        for sv in ((self.superview?.subviews)!) {
//            if sv.isKind(of: UIScrollView.self){
//                for dingdianImgV in ((sv.subviews)) {
//                    if (dingdianImgV.tag == 888 ){//隐藏定点|| dingdianImgV.tag == 888
//                        dingdianImgV.isHidden = false
//                    }
//                }
//            }
//
//        }
//
//
        
        if wallV != nil {
            //给予专扫数据 新初始化的专扫区区域数据
            let messageAllowWallView = RotueViewZhuanSaoDataDeal.newZhuanSaoShow()
            strOfRouteSaveAllowWall = messageAllowWallView
            wallV?.allowedXmppStr = messageAllowWallView
            wallV?.getQuyuXmppStr(messageAllowWallView)
            wallV?.setNeedsDisplay()
        }
    }
    func sendXuNiQiangOKXmppStr(strOfOKXmpp:String)  {//非初始数据
        if wallV != nil {
            strOfRouteSaveAllowWall = strOfOKXmpp
            wallV?.allowedXmppStr = strOfOKXmpp
            wallV?.getQuyuXmppStr(strOfOKXmpp)
            wallV?.setNeedsDisplay()
        }
    }
    
    //隐藏专扫
    func hidenZhuanSao() {
        
        //隐藏专扫
        let strOfAreaZhuanSao = "area_allow 1 0 0 0 0"
        self.saveNewStrOfAreaZhuanSaoAction(strOfAreaAllow: strOfAreaZhuanSao)
    }

    //MARK:-----------用于存储指令，更新UI
    func saveNewStrOfAreaZhuanSaoAction(strOfAreaAllow:String) {
        strOfRouteSaveAllowWall = strOfAreaAllow
        if wallV != nil {
            //给予专扫数据 新初始化的专扫区区域数据
            wallV?.allowedXmppStr = strOfAreaAllow
            wallV?.getQuyuXmppStr(strOfAreaAllow)
        }
       
    }
    
    
    //MARK:—————— //专扫的拖动手势
    func panAction(ges:UIPanGestureRecognizer)  {//传入虚拟墙禁扫区一个数据，用于画专扫区
        print("平移手势识")
        if switchOfDingDianView?.isOn == true{
            //已点击 专扫功能开启状态 处理手势和对应数据
            let pointOfPanGesOne:CGPoint = ges.translation(in: self) ///////相对于定点背景v的移动point
            let pointOfPanGesTwo:CGPoint =  ges.location(in: self) ///////相对于定点背景v的新point
            let wallVOfPoint:CGPoint  =  ges.location(in: wallV) ///////相对于专扫区的新point
        
           
          print("pointOfPanGes坐标变化带方向\(pointOfPanGesOne)  pointOfPanGes2b总坐标\(pointOfPanGesTwo)")
          print("99999当前手势d相对于虚拟墙的point ges.location(in: wallV)\(wallVOfPoint)")

//            var thisStateOfPanOrZoom = 10;//初始化(第一个拖动手指点击处)的状态，非拖动，非缩放。
            if(ges.state == UIGestureRecognizerState.began){
                
                var wallSubVOfPoint:CGPoint = CGPoint.init(x: 0, y: 0);
                for wallSubv in (wallV?.subviews)! {
                    if (wallSubv.tag == 300) {
                        wallSubVOfPoint =  ges.location(in: wallSubv)
                    }
                }
                
                //确定手指位置（计算得出第一点是不在300允许区btn的坐标内 拖整体 还是缩放） 拖动或缩放用300的宽高来定下，只处理4个方向
                thisStateOfPanOrZoom = Int(RotueViewZhuanSaoDataDeal.thisOneIsStatuReques(withAreaAllowStr: strOfRouteSaveAllowWall!, pointOfWallV: wallVOfPoint,pointOfWallSubV:wallSubVOfPoint, pointOfOneP: pointOfPanGesOne, pointOfTwoP: pointOfPanGesTwo,saveMapScale: saveMapScale!))
//            }else if(ges.state == UIGestureRecognizerState.changed){
                print("a专扫区协议：\(thisStateOfPanOrZoom)")
            }else{
                print("b新的专扫区协议：\(thisStateOfPanOrZoom)")
                if (thisStateOfPanOrZoom != 10){ //用第一点确定的拖动或缩放来计算接下来的数据 并时时更新
                    let strOfNewAreaAllowStr:String = RotueViewZhuanSaoDataDeal.getRouteViewZhuanSaoStr(withAreaAllowStr: strOfRouteSaveAllowWall!, intOfStatus: Int32(thisStateOfPanOrZoom), pointOfOneP: pointOfPanGesOne, pointOfTwoP: pointOfPanGesTwo,saveMapScale: saveMapScale!)
                    if strOfNewAreaAllowStr.count>0{
                        strOfRouteSaveAllowWall = strOfNewAreaAllowStr
                        print("新的专扫区协议：\(strOfNewAreaAllowStr)")
                    }
                }
                 print("专扫区协议：\(strOfRouteSaveAllowWall)")
                
                self.saveNewStrOfAreaZhuanSaoAction(strOfAreaAllow: strOfRouteSaveAllowWall!)
            }
            
            
      
//            self.saveNewStrOfAreaZhuanSaoAction(strOfAreaAllow: <#T##String#>)
            
        }else{
            //未点击 专扫功能未开启
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


