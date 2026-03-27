//
//  sw.swift
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
//

import Foundation

 /**
  Codable要求JSON数据的键与数据模型的属性名称完全一致，且类型也要匹配
  Codable对于简单的嵌套结构可以轻松处理，但对于复杂的嵌套结构，可能需要手动
  Codable对于大多数常见的数据类型都有默认的解码实现，但对于一些特殊的数据类型，可能需要自定义解码逻辑
  Codable要求JSON数据中的所有字段都要有对应的属性，否则解码将失败
  
  if url.contains("/admin/getAllPermission") {
      print("权限数据测试系统转型")
      let responseDataInfo : ResponseModel = try!  JSONDecoder().decode(ResponseModel.self, from:  responseDat.data!) //数据的key和类型是必须对应的 model里的key只能少不能多 不然会得到nil
      print("权限数据测试系统转型 responseDataInfo == \(String(describing: responseDataInfo))")
      if responseDataInfo.data.count>0 {
          let PermissionDataInfo = try?  JSONDecoder().decode([PermissionModel].self, from:  responseDataInfo.data)
          print("权限数据测试系统转型 responseDataInfo == \(String(describing: responseDataInfo)) \n data1 = \(String(describing: PermissionDataInfo?.first))  \n s= \(String(describing: responseDataInfo.status))")
      }
  }
  
  */
//


struct ResponseModel : Codable {
    var  status :String
    var  data: [PermissionModel]
    
    enum CodingKeys:String,CodingKey {
        case status = "status"
        case data = "data"
    }
}

//
struct PermissionModel : Codable{
    var PathStr:String
    var Name:String
    let Id :NSInteger
    var duo:String
    
    enum CodingKeys:String,CodingKey {
        case  Id = "Id"
        case  Name = "Name"
        case  PathStr = "Path"
        case  duo = "duo"
    }
}




@objc
class testAAA : NSObject{
    /**
     NSString *u = Y_AllURL_Main(admin_getAllPermission);
     NSDictionary *p = @{};
     [[NetWorkSwiftTool share]managerNetGetMethodWithUrl:u
                                                    parm:p
                                                  header:nil
                                                    succ:^(NSDictionary * _Nonnull responsObject) {
         
     */
    @objc  public func testNetModel()  {
        let s = "http://113.251.68.16:8000" + "/admin/getAllPermission"
        
        NetWorkSwiftTool.share.managerNetGetMethod(url: s, parm: nil, header: nil, succ: {succeDic in
            let arr = succeDic["data"]  as?  [Any]
            print("succeDic \(succeDic) ,arr\(String(describing: arr?.count))")
            
            
        } , fail:{eerr in
            print("eerr \(eerr)")
        })
    }
    
    @objc (funcname)  public func testFuncDiaoYong(){
        print("testFuncDiaoYong")
    }
    
    @objc public static func zhijieDiaoYong(){
        
    }
    
    public static func buenngzhijieDiaoYong2(){
        
    }
  
}

 

