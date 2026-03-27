//
//  NetRequestService.swift
//  RobotLeo
//
//  Created by Eric on 15/5/14.
//  Copyright (c) 2015年 eric. All rights reserved.
//

import UIKit




class NetRequestService: NSObject,ASIProgressDelegate {
    
    var requestPoolDic=[Int:Any]()//管理请求对象  及时持有 及时释放
    var index:Int=0 //请求对象的唯一标示
    
    
    
    
    
    class var shareNetWork : NetRequestService {
        
        struct Static {
            
            static let instance: NetRequestService = NetRequestService()
        }
        
        return Static.instance
    }
    
    
    
    /**
     获得单例
     
     - returns: return value description
     */
    fileprivate override init(){}//私有化构造
    
    
    
    /**
     新post请求
     
     - parameter str:             请求url
     - parameter andParameterDic: 参数
     - parameter andTarget:       代理对象
     - parameter andSeletor:      代理方法
     */
    func formRequest(_ urlStr:String, paraDic: Dictionary<String,String>, target: AnyObject?, seletor:Selector,method:String)
    {
        index += 1
        
        let url=URL(string:(HOSTLOCATION+urlStr))
        
        dPrint("请求的url是-->\(url)")
        let request=ASIFormDataRequest(url: url)
        
        request?.shouldAttemptPersistentConnection=false
        request?.timeOutSeconds=10
        
        
        for parameter in paraDic.keys
        {
            
            request?.setPostValue(paraDic[parameter] as NSObjectProtocol!,forKey: parameter)
        }
        
        let bean = NetResultBean()
        bean.target=target
        bean.seletor=seletor
        request?.delegate=self
        request?.requestMethod = method
        request?.userInfo=[TYRESULTSELETOR:bean,TYREQUESTINDEX:index]
        requestPoolDic[index]=request
        
        startAsynchronousHttpRequest(request!)
        
    }
    
    
    func formRequest(_ urlStr:String,paraDic:Dictionary<String,String>,fileDic:Dictionary<String,String>,target:AnyObject?,selector:Selector,method:String){
        
        index += 1
        
        let url=URL(string:(HOSTLOCATION+urlStr).addingPercentEscapes(using: String.Encoding.utf8)!)
        
        let request=ASIFormDataRequest(url: url)
        
        dPrint("请求的url是-->\(url)")
        
        request?.shouldAttemptPersistentConnection=false
        request?.timeOutSeconds=10
        
        for parameter in paraDic.keys
        {
            request?.setPostValue(paraDic[parameter] as NSObjectProtocol!,forKey: parameter)
        }
        for fileString in fileDic.keys{
            request?.setFile(fileDic[fileString], forKey: fileString)
        }
        
        let bean = NetResultBean()
        bean.target = target
        bean.seletor = selector
        request?.delegate = self
        request?.requestMethod = method
        request?.userInfo = [TYRESULTSELETOR:bean,TYREQUESTINDEX:index]
        requestPoolDic[index] = request
        
        startAsynchronousHttpRequest(request!)
    }
    /**
     新请求-- get delete
     
     - parameter urlStr:  请求url
     - parameter target:  代理对象
     - parameter seletor: 代理方法
     */
    func request(_ urlStr:String, target:AnyObject? , seletor: Selector,method:String)
    {
        index += 1
        var url:URL!
        
        
        url = URL(string:(HOSTLOCATION+urlStr).addingPercentEscapes(using: String.Encoding.utf8)!)
        
        
        if urlStr.hasPrefix("http://") {
            url = URL(string:urlStr.addingPercentEscapes(using: String.Encoding.utf8)!)
        }
        
        
        dPrint("请求的url是-->\(url)")
        
        let request=ASIHTTPRequest(url: url)
        
        
        request?.shouldAttemptPersistentConnection=false
        request?.timeOutSeconds=10
        
        let bean=NetResultBean()
        bean.target=target
        bean.seletor=seletor
        request?.delegate=self
        
        
        //        request?.authenticationScheme = "https" // 设置验证方式
        //        request?.validatesSecureCertificate = false // 设置验证证书
        
        request?.requestMethod = method
        request?.userInfo=[TYRESULTSELETOR:bean,TYREQUESTINDEX:index]
        requestPoolDic[index]=request
        
        startAsynchronousHttpRequest(request!)
    }
    
    
    
    /**
     下载文件请求
     
     - parameter dic:      用来存数标志
     - parameter fileUrl:  文件地址
     - parameter target:   代理对象
     - parameter selector: 代理方法
     */
    
    func downLoadFile(_ dic :Dictionary<String,String>,fileUrl:String,savePath:String,target:AnyObject,selector:Selector){
        index += 1
        
        //清空文件
        let path = savePath
        try? FileManager.default.removeItem(atPath: path)
        try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        
        let bean=NetResultBean()
        bean.target=target
        bean.seletor=selector
        bean.isDownloadRequest = true
        bean.symbolObject = dic as AnyObject?
        
        
        let url = URL(string: HOSTLOCATION + fileUrl)
        let request = ASIHTTPRequest(url: url)
        request?.delegate=self
        request?.downloadDestinationPath = path
        request?.shouldAttemptPersistentConnection = false
        request?.downloadProgressDelegate = self
        request?.userInfo=[TYRESULTSELETOR:bean,TYREQUESTINDEX:index]
        
        requestPoolDic[index]=request
        
        startAsynchronousHttpRequest(request!)
    }
    /**
     开始异步请求
     
     - parameter request: ASIHTTPRequest
     */
    fileprivate func startAsynchronousHttpRequest(_ request:ASIHTTPRequest)
    {
        
        
        let infoDictionary = Bundle.main.infoDictionary
        let majorVersion : AnyObject? = infoDictionary! ["CFBundleShortVersionString"] as AnyObject?
        let appversion = majorVersion as! String
        request.requestHeaders=["type":"iosMobile","version":appversion]
        request.startAsynchronous()
    }
    
    
    /**
     请求成功回调
     
     - parameter request: requestFinished
     */
    func requestFinished(_ request:ASIHTTPRequest)
    {
        dPrint("http请求返回的原始数据>>>>\(request.url)==\(request.responseString()))")
        
        if   let bean:NetResultBean = request.userInfo[TYRESULTSELETOR] as? NetResultBean {
            
            if bean.isDownloadRequest{
                
                if(bean.target!.responds(to: bean.seletor!))
                {
                    Thread.detachNewThreadSelector(bean.seletor!, toTarget: bean.target!, with: "success")
                    
                    
                }
            }else{
                
                
                let responseData  = request.responseData()
                
                let jsonData = JSON(data: responseData!)
                
                let dic  = jsonData.dictionaryObject
                
                if(bean.target!.responds(to: bean.seletor!) && responseData != nil)
                {
                    Thread.detachNewThreadSelector(bean.seletor!, toTarget: bean.target!, with: dic)
                }
                
                
            }
        }
        
        let index:Int = request.userInfo[TYREQUESTINDEX]! as! Int
        requestPoolDic.removeValue(forKey: index)
    }
    
    
    
    /*
     请求失败回调
     
     */
    func requestFailed(_ request:ASIHTTPRequest)
    {
        
        dPrint(request.responseStatusCode)
        if   let bean:NetResultBean=request.userInfo[TYRESULTSELETOR] as? NetResultBean{
            
            if bean.isDownloadRequest{
                
                if(bean.target!.responds(to: bean.seletor!))
                {
                    Thread.detachNewThreadSelector(bean.seletor!, toTarget: bean.target!, with: nil)
                    
                    
                }
            }
            else{
                
                
                if(bean.target!.responds(to: bean.seletor!))
                {
                    Thread.detachNewThreadSelector(bean.seletor!, toTarget: bean.target!, with: nil)
                }
            }
            
        }
        
        let index:Int=request.userInfo[TYREQUESTINDEX]! as! Int
        requestPoolDic.removeValue(forKey: index)
        
    }
    func request(_ request: ASIHTTPRequest!, didReceiveBytes bytes: Int64) {
        print(bytes)
    }
    
    func request(_ request: ASIHTTPRequest!, incrementDownloadSizeBy newLength: Int64) {
        print(newLength)
    }
    
    
    
    func getCurrentTime()->(String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let currentStr = dateFormatter.string(from: Date())
        let date = dateFormatter.date(from: currentStr)!
        return String(stringInterpolationSegment:date.timeIntervalSince1970)
    }
    
}
