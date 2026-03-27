//
//  NetWorkSwiftTool.swift
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
//

import UIKit
import Alamofire
import SVProgressHUD

@objc public
class NetWorkSwiftTool: NSObject {
    
    @objc static let share = NetWorkSwiftTool()
    let mainSession = URLSession.shared   // 创建URLSession
    @objc fileprivate override init() {
        headerInfoDics.add(name: "Content-Type", value: "application/json")
        
        //        DispatchQueue.global(qos: .default).async {
        //        }
        //        DispatchQueue.main.async {
        //        }
        //acceptableContentTypes  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"multipart/form-data",@"image/jpeg", @"image/png", @"application/problem+json", @"application/x-www-form-urlencoded",nil]
    }
    var headerInfoDics = AF.sessionConfiguration.headers
    
    
    @objc public func managerNetGetMethod(  url:String,
                                            parm:[String:Any]?,
                                            header:[String:String]?,
                                            succ:@escaping(_ succ:NSDictionary) -> Void,
                                            fail:@escaping(_ err:Error)-> Void){
        
        print(" \n get NetWorkSwiftTool  -- parm \(String(describing: parm))  url \(String(describing: url)) \n")
        DispatchQueue.global(qos: .default).async {
//            AF.request().responseDecodable(decoder: DataDecoder.Type.self) { DataResponse<Decodable, AFError> in
//            }
            AF.request(url,method:.get,parameters: parm,encoding: URLEncoding.default,headers: self.headerInfoDics).responseData {
                (responseDat)in
                switch responseDat.result{
                    
                case .success(_):
                  
                    
                    /** let okDic11 = try? JSONSerialization.jsonObject(with: responseDat.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
                     */
                    if responseDat.response?.statusCode == 200 {
                        //test
                        if url.contains("/admin/getAllPermission") {
                            print("权限数据测试系统转型")
                            let responseDataInfo = try? JSONDecoder().decode(ResponseModel.self, from:  responseDat.data!)
                            print("权限数据测试系统转型 responseDataInfo == \(String(describing: responseDataInfo)) \n  data1 = \(String(describing: responseDataInfo?.data.first))  \n s= \(String(describing: responseDataInfo?.status))")
                            
                        }
                        
                        
                        
                        
                        
                        //
                        let dataString =  String(data: responseDat.data!, encoding: String.Encoding.utf8)
                        let okDic = self.getDictionaryFromJSONString(jsonString: dataString!)
                        print("get NetWorkSwiftTool  url 200code  === \(String(describing: url)) \n okdic \(String(describing: okDic).utf8)")
                        
                        DispatchQueue.main.async {
                            succ(okDic)
                            return
                        }
                    }else  if responseDat.response?.statusCode == 404 {
                        let errcode = responseDat.response?.statusCode ?? 0;
                        let errWilluse = NSError(domain: "404 请求失败", code: errcode)
                        DispatchQueue.main.async {
                            fail(errWilluse)
                        }
                    }else{
                        let errcode = responseDat.response?.statusCode ?? 0;
                        let errWilluse = NSError(domain: "请求失败", code: errcode)
                        DispatchQueue.main.async {
                            fail(errWilluse)
                        }
                        print("get NetWorkSwiftTool  -- r  serv response  \(String(describing: responseDat.response))")
                    }
                    
                case .failure(_):
                    DispatchQueue.main.async {
                        fail(responseDat.error!)
                    }
                  
                    print("get NetWorkSwiftTool  -- fail  url \(String(describing: url))  code\(String(describing: responseDat.response?.statusCode)) error  \(String(describing: responseDat.error))")
                }
            }
        }
        
        
        
    }
    
    
    @objc public func baseNetPostMethod(  url:String,
                                          parm:[String:Any]?,
                                          header:[String:String]?,
                                          succ:@escaping(_ succ:NSDictionary) -> Void,
                                          fail:@escaping(_ err:Error)-> Void){
        print(" \n post NetWorkSwiftTool  -- r  url \(String(describing: url)) \n")
        DispatchQueue.global(qos: .default).async {
            print("post NetWorkSwiftTool  -- parm == \(String(describing: parm)))")
            // 创建URL对象
            guard let thisAllUrl = URL(string: url) else {
                fatalError("post NetWorkSwiftTool   URL \(url)")
            }
            
            // 创建URLRequest对象
            var request = URLRequest(url: thisAllUrl)
            request.httpMethod = "POST"
            
            // 设置请求头部，指定内容类型为JSON
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // 准备要发送的数据
            let parameters = parm
            
            do {
                // 将字典转换为JSON数据
                let jsonData = try JSONSerialization.data(withJSONObject: parameters ?? [:], options: .prettyPrinted)
                
                // 设置请求体
                request.httpBody = jsonData
                
                // 创建Data Task
                let task = self.mainSession.dataTask(with: request) { (data, response, error) in
                    print("Task 得到数据post NetWorkSwiftTool  data: \(String(describing: data?.count)) response \(String(describing: response)) error \(String(describing: error))")
                    if response == nil {
                        DispatchQueue.main.async {
                            fail( NSError(domain: "请求失败 \(String(describing: error?.localizedDescription))", code: 1))
                        }
                        return
                    }
                    let responseM = response as! HTTPURLResponse
                    if  responseM.statusCode == 200 {
                        print("post  statusCode == 20 : \(responseM)")
                    }else{
                        print("post statusCode!200  Error: \(responseM)")
                        DispatchQueue.main.async {
                           let err = NSError(domain: "请求失败", code: responseM.statusCode)
                            fail(err)
                            let statusCodeErr = "请求失败 statusCode=\(responseM.statusCode)"
                            SVProgressHUD.showError(withStatus: statusCodeErr)
                            SVProgressHUD.dismiss(withDelay: 2.0)
                        }
                        return
                    }
                    
                    if let error = error {
                        print("post NetWorkSwiftTool  Error: \(error)")
                        DispatchQueue.main.async {
                            fail(error)
                        }
                        return
                    }
                    guard let data = data else {
                        print("post NetWorkSwiftTool Data is empty")
                        DispatchQueue.main.async {
                            succ([:])
                        }
                        return
                    }
                    
                    do {
                        // 解析服务器返回的JSON数据
                        //                    if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        //                        print(jsonObject)
                        //                    }
                        let dataString =  String(data: data, encoding: String.Encoding.utf8)
                        let okDic = self.getDictionaryFromJSONString(jsonString: dataString!)
                        print("post NetWorkSwiftTool  -- r  okdic \(String(describing: okDic))")
                        if okDic.count == 0 {//做一个状态成功的数据
                            DispatchQueue.main.async {
                                succ(["status":"ok"])
                            }
                        }else{
                            let keysArr:NSArray = okDic.allKeys as NSArray
                            let valuesArr:NSArray = okDic.allValues as NSArray
                            
                            if (keysArr.contains("status")){
                                let statusStr:NSString = okDic["status"] as! NSString;
                                if statusStr.isEqual(to: "ok") {
                                    DispatchQueue.main.async {
                                        succ(okDic)
                                    }
                                }else{
                                    let err = NSError(domain: "请求失败 \(statusStr)", code: 1)
                                    DispatchQueue.main.async {
                                        fail(err)
                                    }
                                }
                                return
                            }else if(valuesArr.contains("data")){
                                let dataStr:NSString = okDic["data"] as! NSString;
                                if dataStr.isEqual(to: "ok") {
                                    DispatchQueue.main.async {
                                        succ(okDic)
                                    }
                                }else{
                                    let err = NSError(domain: "请求失败 \(dataStr)", code: 1)
                                    
                                    DispatchQueue.main.async {
                                        fail(err)
                                    }
                                }
                                return
                            }else{
                                //没有status 且 没有data
                                succ(okDic)
                                return
                            }
                           
                        }
                        
                    } catch {
                        DispatchQueue.main.async {
                            fail(error)
                        }
                        print("post NetWorkSwiftTool  -- r    error  \(String(describing: error))")
                    }
                }
                // 启动Task
                task.resume()
            } catch {
                print("post NetWorkSwiftTool JSON Serialization error: \(error)")
                DispatchQueue.main.async {
                    fail(error)
                }
            }
        }
        
        
        
        
    }
    //
    
    
    @objc public func baseNetPostBodyMethod(  url:String,
                                          parm:Any?,
                                          header:[String:String]?,
                                          succ:@escaping(_ succ:NSDictionary) -> Void,
                                          fail:@escaping(_ err:Error)-> Void){
        print(" \n post NetWorkSwiftTool  -- r  url \(String(describing: url)) \n")
        DispatchQueue.global(qos: .default).async {
            print("post NetWorkSwiftTool  -- parm == \(String(describing: parm)))")
            // 创建URL对象
            guard let thisAllUrl = URL(string: url) else {
                fatalError("post NetWorkSwiftTool   URL \(url)")
            }
            
            // 创建URLRequest对象
            var request = URLRequest(url: thisAllUrl)
            request.httpMethod = "POST"
            
            // 设置请求头部，指定内容类型为JSON
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // 准备要发送的数据
            let parameters = parm
            
            do {
                // 将字典转换为JSON数据
                let jsonData = try JSONSerialization.data(withJSONObject: parameters ?? [:], options: .prettyPrinted)
                
                // 设置请求体
                request.httpBody = jsonData
                
                // 创建Data Task
                let task = self.mainSession.dataTask(with: request) { (data, response, error) in
                    print("Task 得到数据post NetWorkSwiftTool  data: \(String(describing: data?.count)) response \(String(describing: response)) error \(String(describing: error))")
                    if response == nil {
                        DispatchQueue.main.async {
                            fail( NSError(domain: "请求失败 \(String(describing: error?.localizedDescription))", code: 1))
                        }
                        return
                    }
                    let responseM = response as! HTTPURLResponse
                    if  responseM.statusCode == 200 {
                        print("post  statusCode == 20 : \(responseM)")
                    }else{
                        print("post statusCode!200  Error: \(responseM)")
                        DispatchQueue.main.async {
                           let err = NSError(domain: "请求失败", code: responseM.statusCode)
                            fail(err)
                            let statusCodeErr = "请求失败 statusCode=\(responseM.statusCode)"
                            SVProgressHUD.showError(withStatus: statusCodeErr)
                            SVProgressHUD.dismiss(withDelay: 2.0)
                        }
                        return
                    }
                    
                    if let error = error {
                        print("post NetWorkSwiftTool  Error: \(error)")
                        DispatchQueue.main.async {
                            fail(error)
                        }
                        return
                    }
                    guard let data = data else {
                        print("post NetWorkSwiftTool Data is empty")
                        DispatchQueue.main.async {
                            succ([:])
                        }
                        return
                    }
                    
                    do {
                        // 解析服务器返回的JSON数据
                        //                    if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        //                        print(jsonObject)
                        //                    }
                        let dataString =  String(data: data, encoding: String.Encoding.utf8)
                        let okDic = self.getDictionaryFromJSONString(jsonString: dataString!)
                        print("post NetWorkSwiftTool  -- r  okdic \(String(describing: okDic))")
                        if okDic.count == 0 {//做一个状态成功的数据
                            DispatchQueue.main.async {
                                succ(["status":"ok"])
                            }
                        }else{
                            let keysArr:NSArray = okDic.allKeys as NSArray
                            let valuesArr:NSArray = okDic.allValues as NSArray
                            
                            if (keysArr.contains("status")){
                                let statusStr:NSString = okDic["status"] as! NSString;
                                if statusStr.isEqual(to: "ok") {
                                    DispatchQueue.main.async {
                                        succ(okDic)
                                    }
                                }else{
                                    let err = NSError(domain: "请求失败 \(statusStr)", code: 1)
                                    DispatchQueue.main.async {
                                        fail(err)
                                    }
                                }
                                return
                            }else if(valuesArr.contains("data")){
                                let dataStr:NSString = okDic["data"] as! NSString;
                                if dataStr.isEqual(to: "ok") {
                                    DispatchQueue.main.async {
                                        succ(okDic)
                                    }
                                }else{
                                    let err = NSError(domain: "请求失败 \(dataStr)", code: 1)
                                    
                                    DispatchQueue.main.async {
                                        fail(err)
                                    }
                                }
                                return
                            }else{
                                //没有status 且 没有data
                                succ(okDic)
                                return
                            }
                           
                        }
                        
                    } catch {
                        DispatchQueue.main.async {
                            fail(error)
                        }
                        print("post NetWorkSwiftTool  -- r    error  \(String(describing: error))")
                    }
                }
                // 启动Task
                task.resume()
            } catch {
                print("post NetWorkSwiftTool JSON Serialization error: \(error)")
                DispatchQueue.main.async {
                    fail(error)
                }
            }
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    //MARK: ========================================================================================================
    //json转dic
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        if jsonString == "" {
            return [:]
        }
        //        let newJsonStr : String = self.unicodeZhuanYiActionWithId(oldThing: jsonString) as! String;
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    //unicode转译
    func unicodeZhuanYiActionWithId(oldThing:Any)->(Any){
        let unicodeEscape = oldThing
        if (unicodeEscape as AnyObject).hasPrefix("\\u"),
           let scalarCodePoint = Int((unicodeEscape as! String).dropFirst(2), radix: 16),
           scalarCodePoint >= 0, scalarCodePoint <= 0x10FFFF {
            let scalar = UnicodeScalar(scalarCodePoint)!
            let character = Character(scalar)
            print("unicodeZhuanYiActionWithId character == \(character)") // 输出相应的字符
            return character
        }
        return oldThing
        
    }
}




