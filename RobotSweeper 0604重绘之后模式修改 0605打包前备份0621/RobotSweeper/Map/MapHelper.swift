//
//  MapHelper.swift
//  RobotLeo
//
//  Created by 美超刘 on 2017/4/11.
//  Copyright © 2017年 eric. All rights reserved.
//

import UIKit

class MapHelper: NSObject {

    var w = SCREEN_HEIGHT

    override init(){
        super.init()
 
    }
    
    
    /// 解析地图数据
    func dealWithMapData(array:Array<String>) -> UIImage?{
        
        let strOfsmalStr : NSString = array[6] as NSString
 
        let bottomI = Int(array[3])!
        let topI = Int(array[5])!
        let rightI = Int(array[4])!
        let leftI = Int(array[2])!
        let numOfMap:Int = Int(array[1])!
        
        let height =  topI - bottomI + 1
        let width = rightI - leftI + 1
        
       
       
//        //处理单个像素的
        if height>=0 && width>=0 {
            if( (height<=1)||(width<=1) ) {
                let strOfmapStrc : NSString = array[6] as NSString
                if(strOfmapStrc.length>16){
                }
                return nil
            }else{
 
            }
        }else{
       
        }
        //像素过小去掉
        let strOfmapStr : NSString = array[6] as NSString
        if strOfmapStr.length<=10{
            if(DataManager.shareDataManager.mapImgBeforeData != nil){
                let dat:Data! = DataManager.shareDataManager.mapImgBeforeData
                let imageOfSavedata = UIImage(data: dat)

                return imageOfSavedata
            }else{
              
                return nil
            }
           
        }
        
        if numOfMap==0 {
            DataManager.shareDataManager.mapImgBeforeData = nil
            DataManager.shareDataManager.mapNum = 0
           
            DataManager.shareDataManager.mapBottom = 0
            DataManager.shareDataManager.mapBottomBefore = 0
            DataManager.shareDataManager.mapBottomEnd = 0
            
            DataManager.shareDataManager.mapTop = 0
            DataManager.shareDataManager.mapTopBefore = 0
            DataManager.shareDataManager.mapTopEnd = 0
            
            DataManager.shareDataManager.mapLeft = 0
            DataManager.shareDataManager.mapLeftBefore = 0
            DataManager.shareDataManager.mapLeftEnd = 0
            
            DataManager.shareDataManager.mapRight = 0
            DataManager.shareDataManager.mapRightBefore = 0
            DataManager.shareDataManager.mapRightEnd = 0
        }
        
        //更新mapNum
         if numOfMap == DataManager.shareDataManager.mapNum + 1{

            DataManager.shareDataManager.mapNum = numOfMap
            
        }else if(numOfMap == 0){
          
            DataManager.shareDataManager.mapNum = numOfMap
            DataManager.shareDataManager.mapImgBeforeData = nil
            
            DataManager.shareDataManager.mapBottom = bottomI
            DataManager.shareDataManager.mapTop = topI
            DataManager.shareDataManager.mapLeft = leftI
            DataManager.shareDataManager.mapRight = rightI
            
            DataManager.shareDataManager.mapBottomEnd = bottomI
            DataManager.shareDataManager.mapTopEnd = topI
            DataManager.shareDataManager.mapLeftEnd = leftI
            DataManager.shareDataManager.mapRightEnd = rightI
            
        }else{
            //不连续发送获取全图指令
            DataManager.shareDataManager.mapNum = 0
            DataManager.shareDataManager.mapImgBeforeData = nil
            XmppManager.shareXmppManager.sendMessageToRobot(message: "request_map");
            
            return nil
        }
         //更新地图边界信息
        DataManager.shareDataManager.updateMapRect(top: topI, bottom: bottomI, left: leftI, right: rightI)

        //        let bitsPerComponent = 8 as Int                        // 一个颜色通道所占位数
        //        let bitsPerPixel = bitsPerComponent*4 as Int         // 一个颜色所占位数
        let bytesPerRow = 4*width as Int

        var colors : UnsafeMutablePointer<CUnsignedChar>? = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: bytesPerRow*height)

        
        //数据解析
        let slamS  = array[6]
        let data1 = NSData(base64Encoded: slamS, options: NSData.Base64DecodingOptions.init(rawValue: 0))
         let data = data1 as Data?
        
         if data1==nil {
            print("mapImg--空的data")
            return nil
        }
        
    
//        ToolOfBasic.useDataPMalloc(with: data, charPointMalloc: colors!)//20190506
        MapInfoColorCaseHelperAndOtherTool.useDataPMalloc(with: data!, charPointMalloc: colors!)
        let mapRect = CGRect(x: leftI, y: -topI, width: width, height: height)
 //      let image = ToolOfBasic.getImgWith(mapRect, charPointRgba: colors)//colors: 转换img //20190506
        let image = MapInfoColorCaseHelperAndOtherTool.getImgWith(mapRect, charPointRgba: colors!)//colors: 转换img //20190506
        
     
 
        var image2 : UIImage? = nil
        
        if (data1 != nil) {
             image2  =  UIImage(data: data1! as Data)
         }else{
         }
        if image == nil{
             return nil
        }
        
        ////UIImage转换为NSData
        var imageData = UIImagePNGRepresentation(image)
        if imageData == nil{
            return nil
        }
        let mapImage = UIImage(data: imageData!)
        
        //释放内存
//        free(colors)
        
        
        if mapImage == nil {
            return nil
        }
        
        var okImg : UIImage? = nil
        
        if numOfMap  == 0 {
            DataManager.shareDataManager.mapImgBeforeData = nil;//20190510置空
            DataManager.shareDataManager.mapBottomBefore =  DataManager.shareDataManager.mapBottom
            DataManager.shareDataManager.mapTopBefore =  DataManager.shareDataManager.mapTop
            DataManager.shareDataManager.mapLeftBefore =  DataManager.shareDataManager.mapLeft
            DataManager.shareDataManager.mapRightBefore =  DataManager.shareDataManager.mapRight
            
            DataManager.shareDataManager.mapBottomEnd =  DataManager.shareDataManager.mapBottom
            DataManager.shareDataManager.mapTopEnd =  DataManager.shareDataManager.mapTop
            DataManager.shareDataManager.mapLeftEnd =  DataManager.shareDataManager.mapLeft
            DataManager.shareDataManager.mapRightEnd =  DataManager.shareDataManager.mapRight
            
             okImg = mapImage
            
        }else{
            //如果没有得到过0 直接得到1，判断是否有旧数据 1.没有旧数据-那么重新请求-得到1为止 2.有旧数据-不一定是顺序的有可能是扫地机发送错了d其他次数的更新数据。==》无法f判断是否该请求map

            
            let newT = topI
            let newB = bottomI
            let beforeT = DataManager.shareDataManager.mapTopBefore
            let beforeB = DataManager.shareDataManager.mapBottomBefore
            var arrOfTopAndBottomArr : NSMutableArray = MapInfoColorCaseHelperAndOtherTool.bubbleAscendingOrderSort(with: [newT,newB,beforeT,beforeB])
            DataManager.shareDataManager.mapBottomEnd = arrOfTopAndBottomArr[0] as! Int
            DataManager.shareDataManager.mapTopEnd  = arrOfTopAndBottomArr[3] as! Int
            
            
            let newR = rightI
            let newL = leftI
            let beforeR = DataManager.shareDataManager.mapRightBefore
            let beforeL = DataManager.shareDataManager.mapLeftBefore
            var arrOfRightAndLeftArr : NSMutableArray = MapInfoColorCaseHelperAndOtherTool.bubbleAscendingOrderSort(with: [newR,newL,beforeR,beforeL])
            DataManager.shareDataManager.mapLeftEnd = arrOfRightAndLeftArr[0] as! Int
            DataManager.shareDataManager.mapRightEnd = arrOfRightAndLeftArr[3] as! Int
         
        }
 
        if DataManager.shareDataManager.mapImgBeforeData?.count == 0 || DataManager.shareDataManager.mapImgBeforeData?.count == nil || numOfMap  == 0 {
 
            okImg = mapImage
            
        }else{
            
            //合成大的图
            //top->bottom=y
            //地图数据是从下往上的而画图是从上往下的 都是从右往左x不变 所给的坐标y为bottom
            let x : Int  = 0
            let y : Int  = 0
            let w : Int = DataManager.shareDataManager.mapRightEnd - DataManager.shareDataManager.mapLeftEnd + 1
            let h : Int = DataManager.shareDataManager.mapTopEnd - DataManager.shareDataManager.mapBottomEnd + 1
 
            
            
            //由于x=left 大图的left最min所以被减 Bottom也是大图最小
            //new
            let xNew : Int  = leftI - DataManager.shareDataManager.mapLeftEnd
            let yNew : Int  = DataManager.shareDataManager.mapTopEnd-topI
            let wNew : Int = width
            let hNew : Int = height
   
            //before
            let xBefore : Int  = DataManager.shareDataManager.mapLeftBefore - DataManager.shareDataManager.mapLeftEnd
            let yBefore : Int  = DataManager.shareDataManager.mapTopEnd-DataManager.shareDataManager.mapTopBefore
            let wBefore : Int = DataManager.shareDataManager.mapRightBefore - DataManager.shareDataManager.mapLeftBefore + 1
            let hBefore : Int = DataManager.shareDataManager.mapTopBefore - DataManager.shareDataManager.mapBottomBefore + 1
  
            
            var beforeImg : UIImage? = nil
            if DataManager.shareDataManager.mapImgBeforeData==nil  {
                beforeImg = nil
            }else{
                beforeImg = UIImage(data:DataManager.shareDataManager.mapImgBeforeData!)
            }
            
//            print("拼图ToolOfBasic")
//            okImg = ToolOfBasic.combineTwoImgWith(x: Int32(x), y: Int32(y), w: Int32(w), h: Int32(h), newImage: mapImage, newPosx: Int32(xNew), newPosy: Int32(yNew), newW: Int32(wNew), newH: Int32(hNew), before: beforeImg, beforePosx: Int32(xBefore), beforePosy: Int32(yBefore), beforeW: Int32(wBefore), beforeH: Int32(hBefore))//20190507
            okImg = MapInfoColorCaseHelperAndOtherTool.combineTwoImgWith(x: Int32(x), y: Int32(y), w: Int32(w), h: Int32(h), newImage: mapImage!, newPosx: Int32(xNew), newPosy: Int32(yNew), newW: Int32(wNew), newH: Int32(hNew), before: beforeImg!, beforePosx: Int32(xBefore), beforePosy: Int32(yBefore), beforeW: Int32(wBefore), beforeH: Int32(hBefore))
            
            //before存新的
            DataManager.shareDataManager.mapBottomBefore =  DataManager.shareDataManager.mapBottomEnd
            DataManager.shareDataManager.mapTopBefore =  DataManager.shareDataManager.mapTopEnd
            DataManager.shareDataManager.mapLeftBefore =  DataManager.shareDataManager.mapLeftEnd
            DataManager.shareDataManager.mapRightBefore =  DataManager.shareDataManager.mapRightEnd
//            print("before存新的l b r t")
            print(DataManager.shareDataManager.mapLeftBefore,DataManager.shareDataManager.mapBottomBefore,DataManager.shareDataManager.mapRightBefore,DataManager.shareDataManager.mapTopBefore)
        }
 
        //存数据
        if okImg != nil {
 
            var dataOfOkImg : Data? = nil
            dataOfOkImg = UIImagePNGRepresentation(okImg!)
            DataManager.shareDataManager.mapImgBeforeData = dataOfOkImg! as Data
 
           return okImg
            
        }else{
 
            return nil
        }
        
    }
    
    
    //MARK: 区域
    func dealWithAreaClearDataGetAreaImgAndAreaArr(strOfData:String, w:Int, h:Int ,l:Int,r:Int,t:Int,b:Int,arrOfChangeColor:NSMutableArray) -> NSArray {

        let imgData = NSData(base64Encoded: strOfData, options: NSData.Base64DecodingOptions.init(rawValue: 0))

        let data = imgData as Data?


        if data==nil {
             return []
        }

        let bytesPerRow = 4*w as Int
 
        var colors : UnsafeMutablePointer<CUnsignedChar>? = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: bytesPerRow*h)
        print(colors)
        print("COLOR地址")
        print(arrOfChangeColor)
//        let arrOfDataNum:NSMutableArray =  ToolOfBasic.twoUseDataPMalloc(with: data, charPointMalloc: colors,arrOfChangeColor:arrOfChangeColor, w: Int32(w)) //20190506
        let arrOfDataNum:NSMutableArray =  MapInfoColorCaseHelperAndOtherTool.twoUseDataPMalloc(with: data!, charPointMalloc: colors!,arrOfChangeColor:arrOfChangeColor, w: Int32(w))

        if(arrOfDataNum.contains("2")){
           print("contains 2")
        }

        let areaImgRect = CGRect(x: l, y: -t, width: w, height: h)


//        let image = ToolOfBasic.getImgWith(areaImgRect, charPointRgba: colors) //20190506
        let image = MapInfoColorCaseHelperAndOtherTool.getImgWith(areaImgRect, charPointRgba: colors!)

        return [image as Any,arrOfDataNum];

    }
    
    
 
    
}






 

 
