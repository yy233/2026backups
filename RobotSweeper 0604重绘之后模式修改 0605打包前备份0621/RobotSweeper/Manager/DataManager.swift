//
//  DataManager.swift
//  RobotSweeper
//
//  Created by 美超刘 on 2017/5/22.
//  Copyright © 2017年 美超刘. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    
    
    class var shareDataManager : DataManager {
        struct Static {
            static var predicate:Int = 0
            static let instance : DataManager = DataManager()
        }
        return Static.instance
    }
    
    //201902284*4清扫状态的颜色彩色显隐属性
    var colorShowOrNotShowOfCleanFourFourMode:Bool = false
    
    //0128新增在每一个新版本时上传该用户登录信息的识别num  “equipmentUpdateLogController/insert”
    var isAnNewApp:Int = 0
    
    
/*升级使用的xml地址*/
    var xmlOfMainSlam:NSString = ""
    var xmlOfMainCtrl:NSString = ""
//    var xmlOfJgSlam:NSString = ""
//    var xmlOfJgCtrl:NSString = ""
//    var xmlOfGwSlam:NSString = ""
//    var xmlOfGwCtrl:NSString = ""
//    var xmlOfBlemSlam:NSString = ""
//    var xmlOfBlemCtrl:NSString = ""
    
    
    
/*适配不同app用到的str 和数组*/
    var homeCellImgNameStr:NSString = ""
    var wifiMatchStr:NSString = ""
    var appNameStr:NSString = ""
    var appCanAddRobotTypeArr:NSMutableArray = ["01","02","03"]
//    var appCanAddRobotTypeArr:NSMutableArray = ["1","2","3"] //1212更改成了三位的型号码 暂用一位判断当前品牌 1213还原
    var appRobotTypeStr:NSString = "" //img前缀 颜色前缀 color
    var appNowProductTypeNumStr:NSString = "" //区分模式和监控遥控等字段 00 01 02 03 现在变成 1／2／3了 1213还原成2位
    
    //tableViewGroupbackcolor灰色
    var colorOfGroupGrayBack:UIColor = UIColor(red: 235.0/255, green: 235.0/255, blue: 240.0/255, alpha: 1)
    //color灰色
//    var colorOfGrayBack:UIColor = UIColor(red: 240.0/255, green: 240.0/255, blue: 240.0/255, alpha: 1)
     var colorOfGrayBack:UIColor = UIColor(red: 235.0/255, green: 235.0/255, blue: 240.0/255, alpha: 1)
  //当前主题色
    var colorOfMainType:UIColor = UIColor(red: 18.0/255, green: 148.0/255, blue: 216.0/255, alpha: 1)
    //蓝色主题
    var colorOfBlueT:UIColor = UIColor(red: 18.0/255, green: 148.0/255, blue: 216.0/255, alpha: 1)
    //橘色主题
    var colorOfOrangeT:UIColor = UIColor(red:   250.0/255, green: 62.0/255, blue: 29.0/255, alpha: 1)
    //绿色主题
    var colorOfGreenT:UIColor = UIColor(red:   73.0/255, green: 166.0/255, blue: 107.0/255, alpha: 1)
   
    //预约所用的两种模式数组 2个模式 变3个 新增的4*4清扫使用【2】
    var yuyueModeArrMain:NSMutableArray = [NSLocalizedString( "自动清扫", comment: ""),NSLocalizedString( "边角清扫", comment: ""),NSLocalizedString("4*4清扫", comment: "")];
    var yuyueModeArrO:NSMutableArray = [NSLocalizedString( "自动清扫", comment: ""),NSLocalizedString( "边角清扫", comment: ""),NSLocalizedString("4*4清扫", comment: "")];//自动
    var yuyueModeArrT:NSMutableArray = [NSLocalizedString( "规划清扫", comment: ""),NSLocalizedString( "沿边清扫", comment: ""),NSLocalizedString("4*4清扫", comment: "")];//规划
    
    //地图所用的两种模式数组 4个模式  是用于弹出view的label 4->5 新增的取【4】 （专扫不在弹出的模式里它在定点里切换而来不需要xx清扫文本）|20190527 打扫记录里有用到的地方遂加上
    var mapModeArrMain = [NSLocalizedString("自动清扫", comment: ""),NSLocalizedString("定点清扫", comment: ""),NSLocalizedString("区域清扫", comment: ""),NSLocalizedString("边角清扫", comment: ""),NSLocalizedString("4*4清扫", comment: ""),NSLocalizedString("专扫", comment: "")] //4*4清扫模式 1212新增 专扫20190527新增

    var mapModeArrO = [NSLocalizedString( "自动清扫",comment: ""),NSLocalizedString( "定点清扫",comment: ""),NSLocalizedString( "区域清扫", comment: ""),NSLocalizedString("边角清扫", comment: ""),NSLocalizedString("4*4清扫", comment: "")]
    var mapModeArrT = [NSLocalizedString( "规划清扫",comment: ""),NSLocalizedString( "重点清扫", comment: ""),NSLocalizedString( "区域清扫", comment: ""),NSLocalizedString("沿边清扫", comment: ""),NSLocalizedString("4*4清扫", comment: "")]//规划
    //btn
//    var mapModeBtnTitleStrMain = [NSLocalizedString( "模式：自动", comment: ""),NSLocalizedString( "模式：定点", comment: ""),NSLocalizedString( "模式：区域", comment: ""),NSLocalizedString( "模式：边角", comment: ""),NSLocalizedString( "模式：4*4", comment: "")]
//    var mapModeBtnTitleStrO = [NSLocalizedString( "模式：自动", comment: ""),NSLocalizedString( "模式：定点", comment: ""),NSLocalizedString("模式：区域", comment: ""),NSLocalizedString("模式：边角", comment: ""),NSLocalizedString( "模式：4*4", comment: "")]
//    var mapModeBtnTitleStrT = [NSLocalizedString( "模式：规划", comment: ""),NSLocalizedString( "模式：重点", comment: ""),NSLocalizedString( "模式：区域", comment: ""),NSLocalizedString("模式：沿边", comment: ""),NSLocalizedString( "模式：4*4", comment: "")]//规划
    //btn的文本//20190312新增专扫
    var mapModeBtnTitleStrMain = [NSLocalizedString( "模式：自动", comment: ""),NSLocalizedString( "模式：定点", comment: ""),NSLocalizedString( "模式：区域", comment: ""),NSLocalizedString( "模式：边角", comment: ""),NSLocalizedString( "模式：4*4", comment: ""),NSLocalizedString("模式：专扫", comment: "")]
    var mapModeBtnTitleStrO = [NSLocalizedString( "模式：自动", comment: ""),NSLocalizedString( "模式：定点", comment: ""),NSLocalizedString("模式：区域", comment: ""),NSLocalizedString("模式：边角", comment: ""),NSLocalizedString( "模式：4*4", comment: ""),NSLocalizedString("模式：专扫", comment: "")]
    var mapModeBtnTitleStrT = [NSLocalizedString( "模式：规划", comment: ""),NSLocalizedString( "模式：重点", comment: ""),NSLocalizedString( "模式：区域", comment: ""),NSLocalizedString("模式：沿边", comment: ""),NSLocalizedString( "模式：4*4", comment: ""),NSLocalizedString("模式：专扫", comment: "")]//规划
    //地图数据相关新图坐标
    var mapLeft : Int = 0
    var mapRight : Int = 0
    var mapTop : Int = 0
    var mapBottom : Int = 0
   
//    //合并后存下来的坐标系 可用于下次拼图
    var mapLeftBefore : Int = 0
    var mapRightBefore : Int = 0
    var mapTopBefore : Int = 0
    var mapBottomBefore : Int = 0
    
    //    //计算后的大图坐标系 用于画图
    var mapLeftEnd : Int = 0
    var mapRightEnd : Int = 0
    var mapTopEnd : Int = 0
    var mapBottomEnd : Int = 0
    
    //轨迹序号 轨迹数据
    var trajectoryNum:Int = 0
    var trajectorySourceArr:NSMutableArray = []
    
    
    //地图序号
//    var mapOfNum : Int = 0
    //地图序号管理 judgeMapNum
    var mapNum : Int = 0
    
    //地铁arr[6] 累加 addMapDataArr
//    var mapDataArr: NSMutableArray = []
    
    //存上次的img数据
    var mapImgBeforeData : Data? = nil
//    //存新的mapImg的xy坐标起始点 (left top )=(x y)
//    var mapImgXnew = 0
//    var mapImgYnew = 0
////
////    //存上次合成的mapImg的xy坐标起始点 (left top )=(x y)
//    var mapImgXBefore = 0
//    var mapImgYBefore = 0
////
////    //存这次合成的xy
//    var mapImgXEnd = 0
//    var mapImgYEnd = 0
    
    //Rightmax bottomMin用来做w h
//    var mapImgXRightnNew = 0
//    var mapImgYBottomNew = 0
//    var mapImgXRightnBefore = 0
//    var mapImgYBottomBefore = 0
//    var mapImgXRightnEnd = 0
//    var mapImgYBottomEnd = 0
    /**/
    
    var pointArrOfdrawTraj : [String]  = []
    
    //虚拟墙数据
    var wallArrDataSource : [NSDictionary]  = []
    //扫地机位置信息
    var posX = 0
    var posY = 0
    var theta : CGFloat = 0
    //充电座位置信息
    var homeX = 0
    var homeY = 0
    var homeTheta : CGFloat = 0
    
    var sweeperPort = ""
    var sweeperID = ""
    var sweeperIP = ""
    var sweeperIMEI = ""
    
    
    var isAllMap = true
    
    var isConnect = false
    
    var robotWillShowId:NSString = "" //设备号 1212新增
    var robotOpenOrNo:NSString = "" // 冠维独有休眠sleep协议 即冠维的船型开关置“”   | 船形开关状态 支持晶果和贝莱恩  为空的则是冠维不弹出charge_or_shutdown不响应
    //开机时间
    var openTime = ""
    var volumeStr = "" //音 音量
    var robotLanguage = "" //语音语种字段
    var robotPreventDrop :Bool = true;//防止跌落
    
    //版本号相关信息
    //frieware-控制板-硬件 //slam-导航版-软件
    var currentFriewareVersion = "--"
    var lastFriewareVersion = "--"
    //slam-导航版-软件
    var currentNavigationVersion = "--"
    var lastNavigationVersion = "--"
    
    var currentAppVersion = "--"
    var lastAppVersion = "--"
    
    var fileMD5OfSmal = ""
    var fileMD5OfCtrl = ""
    
    var fileMuvOfSmal = "--"
    var fileMuvOfCtrl = "--"
    
    var fileMsgOfSmal = ""
    var fileMsgOfCtrl = ""
    //家庭网络名字保存下来用于添加扫地机时免输入
    var homeWifi = ""
    
    
    var robotWifiSsid = "" //时时得到的扫地机所连接的Wi-Fi名。
    var robotWifiIP = ""//192.168.1.153 ip
    var robotWifiMac = ""//mac  00:0c:43:31:ee:d5
    
    func initDataManager(){
        //        getUnreadNoticeMsgNum()
    }
    
    /// 存储地图边界信息
    ///
    /// - Parameters:
    ///   - top: 上
    ///   - bottom: 下
    ///   - left: 左
    ///   - right: 右
    func setMapRect(top:Int,bottom:Int,left:Int,right:Int){
        
        mapTop = top
        mapLeft = left
        mapRight = right
        mapBottom = bottom
        
       
    }
    
    
    /// 更新地图边界信息
    ///
    /// - Parameters:
    ///   - top: 上
    ///   - bottom: 下
    ///   - left: 左
    ///   - right: 右
    func updateMapRect(top:Int,bottom:Int,left:Int,right:Int){
        
        if isAllMap{
//            print("更新newImg的坐标")
            print(mapLeft,mapBottom,mapRight,mapTop)
            self.setMapRect(top: top, bottom: bottom, left: left, right: right)
            isAllMap = false
        }else{
//           print("比较newImg的坐标")
            print(mapLeft,mapBottom,mapRight,mapTop)
            
            mapBottom = mapBottom > bottom ? bottom : mapBottom
            mapTop = mapTop > top ? mapTop : top
            mapLeft = mapLeft > left ? left : mapLeft
            mapRight = mapRight > right ? mapRight : right
//            print("更新后newImg的坐标")
            print(mapLeft,mapBottom,mapRight,mapTop)
            
           
        }
        
    }
    //mapNum
    func judgeMapNum(tmpMapNum : Int ){
            if tmpMapNum == mapNum + 1{
                //连续 num+ dataArr+
                mapNum = tmpMapNum
                 print("序号连续map")

            }else if(tmpMapNum == 0){
                //0 num = 0 dataArr有初值
                mapNum = tmpMapNum
                  print("序号初始map")
            }else{
                //不连续发送获取全图指令
                mapNum = 0
                print("序号不连续重新请求map")
                XmppManager.shareXmppManager.sendMessageToRobot(message: "request_map");
            }
    }
    //data不会拼
//    func judgeMapNumAndMapDataArr(tmpMapNum : Int , arrOfMapData:NSArray) {
//        
//        if tmpMapNum == mapNum + 1{
//            //连续 num+ dataArr+
//            mapNum = tmpMapNum
//            self.addMapDataArr(arrOfMap: arrOfMapData)
//            
//        }else if(tmpMapNum == 0){
//            //0 num = 0 dataArr有初值
//             mapNum = tmpMapNum
//             DataManager.shareDataManager.mapDataArr = arrOfMapData.mutableCopy() as! NSMutableArray
//        }else{
//            //不连续发送获取全图指令
//
//            mapNum = 0
//            print("序号不连续重新请求map")
//            XmppManager.shareXmppManager.sendMessageToRobot(message: "request_map");
//        }
//    }
//
//    func addMapDataArr(arrOfMap:NSArray) {
//        print("addMapDataArr")
//            
//        let slamSEnd : String = arrOfMap[0] as! String//数组元素
//        let slamSBegin : String = DataManager.shareDataManager.mapDataArr[0] as! String
//        let slamAll : String = slamSEnd + slamSBegin
//        var arr : NSMutableArray = []
//        arr.add(slamAll)
//        DataManager.shareDataManager.mapDataArr = arr
//        
//    }
}
