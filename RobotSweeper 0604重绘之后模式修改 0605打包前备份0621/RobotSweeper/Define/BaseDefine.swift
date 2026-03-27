//
//  RB_BaseDefine.swift
//  RobotLeo
//
//  Created by Eric on 15-4-27.
//  Copyright (c) 2015年 eric. All rights reserved.
//

import UIKit

//屏幕宽高
let SCREEN_WIDTH=MainBounds.size.width
let SCREEN_HEIGHT=MainBounds.size.height

let iphone5Height : CGFloat = 568
let iphone7Height : CGFloat = 667
let iphone7plusHeight : CGFloat = 714
// barHeight
let BARHEIGHT : CGFloat = 64.0
/**判断是否系统版本大于8.0系统  大于或等于8.0返回true 否则返回false*/
let IS_IOS8 = (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0
/**屏幕大小*/
let MainFrame=UIScreen.main.applicationFrame
let MainBounds=UIScreen.main.bounds

/**沙盒路径*/
let PATH_OF_DOCUMENT=NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)



func ResignFirstResponder()
{
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
func _width(_ width:CGFloat)->CGFloat {
    
    switch SCREEN_WIDTH
    {
      case 320:
        return width*0.77294686
      case 375:
        return width*0.9057871
      default:
           return width
    }
}
func _height(_ height:CGFloat)->CGFloat {
    
    switch SCREEN_HEIGHT
    {
      case 480:
         return height*0.65217391
      case 568:
        return height*0.77173913
      case 667:
         return height*0.90625
      default:
        return height
    }
}
func _originX(_ originX:CGFloat)->CGFloat {
    switch SCREEN_WIDTH
    {
     case 320:
        return originX*0.77294686
     case 375:
        return originX*0.9057871
     default:
        return originX
    }
}
func _originY(_ originY:CGFloat)->CGFloat {
    switch SCREEN_HEIGHT
    {
     case 480:
        return originY*0.65217391
     case 568:
        return originY*0.77173913
     case 667:
        return originY*0.90625
     default:
        return originY
    }
}
func _guidX(_ originX:CGFloat)->CGFloat {
    
    switch SCREEN_HEIGHT
    {
    case 480:
        return originX*1.11
    case 568:
        return originX
    case 667:
        return originX*0.982
    default:
        return originX*0.972
    }
}
func _guidY(_ originY:CGFloat)->CGFloat {
  
    switch SCREEN_HEIGHT
    {
     case 480:
        return originY*1.015
     case 568:
        return originY
     case 667:
        return originY*0.982
     default:
        return originY*0.972
    }
}

func HexColor( hexValue : Int, alpha:CGFloat) -> UIColor {
    
//    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
    return UIColor(red: ((CGFloat)((hexValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((hexValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(hexValue & 0xFF))/255.0, alpha: alpha)
}


func JudgeIsNotNull(_ obj:String?)->Bool
{
    if(obj==nil){
        return false
    }
    else if(obj!.isEmpty){
        return false
    }else if obj == "null"{
        return false
    }
    else{
        return true
    }
}

func CellBgView()->UIImageView{
    
    let cellView = UIImageView()
    cellView.backgroundColor = UIColor.white
    cellView.alpha = 0.05
    return cellView
}

func customBgViewColor()->UIColor{
    return UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
}

func CellSelectBgView()->UIImageView{
    
    let cellView = UIImageView()
    cellView.backgroundColor = UIColor.white
    cellView.alpha = 0.1
    return cellView
}

func NavigationPath()->String{
    
    let paths = PATH_OF_DOCUMENT as NSArray
    let documentsDirectory = paths[0] as! NSString
    let path = "\(documentsDirectory)/NavigationFile/"
    return path
}

//MARK:===存储版本信息
func setNavigationInfo(dic:Dictionary<String,String>){
    
    UserDefaults.standard.set(dic, forKey: "NavInfo")
}
func getNavigationInfo()->Dictionary<String,String>?{
    
    return UserDefaults.standard.object(forKey: "NavInfo") as? Dictionary<String,String>
}

func dPrint(_ item:Any)  {
   #if DEBUG
    print(item)
    #endif
}


func logPrint(_ item: Any,fileName:String = #file,funcName:String = #function,lineNum:Int = #line) {
        print("文件名\(fileName)\n方法名\(funcName)\n行数\(lineNum)\n打印的信息-->\(item)")
}


// 按钮黄
let btnYello = UIColor(red: 255/255.0, green: 238/255.0, blue: 107/255.0, alpha: 1.0)

func PicturePath()->String{
    
    let paths = PATH_OF_DOCUMENT as NSArray
    let documentsDirectory = paths[0] as! NSString
    let path = "\(documentsDirectory)/PictureFile/"
    return path
}


//func TableViewSeparatorColor()-
