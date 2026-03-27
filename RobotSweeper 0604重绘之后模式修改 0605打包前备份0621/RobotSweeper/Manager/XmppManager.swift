
//
//  XmppManager.swift
//  Swift_Test
//
//  Created by lmc on 15/7/3.
//  Copyright (c) 2015年 Liu. All rights reserved.
//

import Foundation

@objc protocol XmppManagerDelegate{
    
    
    @objc optional func sendMessageSuccess()
    @objc optional func sendMessageFail()
    @objc optional func receiveXmppMessage(message:String)
    @objc optional func receiveXmppUserStatus(message:String)

}


//typealias loginClosure = (_ pra : Bool)->Void


class XmppManager :NSObject,XMPPStreamDelegate,XMPPAutoPingDelegate,XMPPReconnectDelegate,XMPPRosterDelegate {
  //新增加密后 增加的队列，发送密文时使用
//    let sendMsgSerialqueue = OperationQueue()

    
    var timeOutCount = 0
    
    static var shareXmppManager = { () -> XmppManager in
        let instance = XmppManager()
        
        instance.initXmpp()
        
        return instance
        
    }()
    //typealias 是用来为已经存在的类型重新定义名字的，
    var saveLoginCompletionBlock : myClosure?
    var saveLogoutCompletionBlock : myClosure?
    
//    weak var delegates: XmppManagerDelegate!
    weak var delegates: XmppManagerDelegate?
    
    
    var isRobotOnline : Bool? = false
    var isConnect : Bool?
    var isLogout : Bool? = false
    
    //用于存储登录信息
    var passwordStr : String? = ""
    
    var xmppStream : XMPPStream?
    var xmppAutoPing : XMPPAutoPing?
    var xmppReconnect : XMPPReconnect?
    var xmppRosterCoreDataStorage : XMPPRosterCoreDataStorage?
    var xmppRoster : XMPPRoster?
    var xmppMessageDeliveryReceipts : XMPPMessageDeliveryReceipts?
    var pingTimeout : Bool! =  false
    
    var xmppTimer : Timer?
    
    //1130新增
//    //美服
//    var openfireServiceName : String = "sweeperus"
//    var openfireHostName : String = "47.254.81.94"
//    var openfireHostPort : Int = 5222
    //国服 测试服
//    var openfireServiceName : String = "jgsweep"
//    var openfireHostName : String = "123.57.37.122"
//    var openfireHostPort : Int = 5222
    //国服 正式服
        var openfireServiceName : String = "jgsweep"
        var openfireHostName : String = "sweep.robotleo.com"
        var openfireHostPort : Int = 5222
    
    
    /**
     :初始化 xmpp 相关
     
     - returns: 无
     */
    fileprivate func initXmpp(){
        //加密后 新增的 最大数为1
//        sendMsgSerialqueue.maxConcurrentOperationCount = 1
//        //1214服务器切换 暂时用正式服不用美服
//        if(NowLanguageTool.robotAppOfGetPreferredLanguageNum()==0){//0为正式服 其他1英文
//            //国服 正式服
//            openfireServiceName = "jgsweep"
//            openfireHostName = "sweep.robotleo.com"
//            openfireHostPort = 5222
//        }else{
//            //美服
//            openfireServiceName = "sweeperus"
//            openfireHostName = "47.254.81.94"
//            openfireHostPort = 5222
//        }
        
        
        isLogout = false
        
        isConnect = false
        
        
        xmppStream = XMPPStream()
        
        
        xmppStream?.hostName =  openfireHostName
        xmppStream?.hostPort = 5222
     
 
        
        
        xmppStream?.enableBackgroundingOnSocket = true
        xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        xmppAutoPing = XMPPAutoPing()
        xmppAutoPing?.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        xmppAutoPing?.activate(xmppStream) //激活
        xmppAutoPing?.respondsToQueries = true
        xmppAutoPing?.pingInterval = 5  //心跳包间隔 客户端每隔5s发送ping包
        xmppAutoPing?.pingTimeout = 3
        xmppAutoPing?.targetJID = XMPPJID(string:"")
        xmppAutoPing?.addDelegate(self, delegateQueue: DispatchQueue.main)//20190611加
        //        xmppAutoPing?.targetJID = nil
        
        xmppReconnect = XMPPReconnect()
        xmppReconnect?.activate(xmppStream)
        xmppReconnect?.autoReconnect = true
        xmppReconnect?.reconnectDelay = 1.0  // 一旦失去连接，1s后开始自动重连
        xmppReconnect?.reconnectTimerInterval = 10 // 每隔10秒自动重连一次
        //        xmppReconnect?.usesOldSchoolSecureConnect = true
        xmppReconnect?.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        //创建花名册数据存储对象
        xmppRosterCoreDataStorage = XMPPRosterCoreDataStorage.sharedInstance()
        //创建花名册并指定了存储对象
        xmppRoster = XMPPRoster(rosterStorage: xmppRosterCoreDataStorage)
        //激活通信通道
        xmppRoster?.activate(xmppStream)
        xmppRoster?.autoAcceptKnownPresenceSubscriptionRequests = true
        //添加代理
        xmppRoster?.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        //  //收到回执，提示发送成功
        //        xmppMessageDeliveryReceipts = XMPPMessageDeliveryReceipts()
        //        xmppMessageDeliveryReceipts?.autoSendMessageDeliveryReceipts = true
        //        xmppMessageDeliveryReceipts?.autoSendMessageDeliveryRequests = true
        //        xmppMessageDeliveryReceipts?.activate(xmppStream)
        
//        xmppRoster?.fetch()
       //手动从服务器获取花名册。如果你禁用自动fetch名册，将会非常有用。它是向服务器发送了一个IQ请求
        
                
        xmppTimer =  Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(XmppManager.reconnect), userInfo: nil, repeats: true)
        print("initsharexmpp")
    }
    
    //MARK:---------登录、退出、上线、下线
    /**
     登录xmpp
     
     - parameter userName: 用户名
     - parameter password: 密码
     */
     //MARK:---------登录
    func loginXmpp(_ userName:String,password:String,pre:@escaping (Bool)->()){
        
        saveLoginCompletionBlock = pre
        
        self.passwordStr = password
//        let myJid : XMPPJID = XMPPJID(string: userName+"/Smack")
//        let myJid : XMPPJID = XMPPJID(string: userName+"/Jgsweep")
        let myJid :XMPPJID = XMPPJID(user: userName, domain: openfireServiceName, resource:"mobile")//服务器域名 客户端iphone 客户端统一后才好判断安卓同一账号时的登录情况 swift不能为空暂定resource
        xmppStream?.myJID = myJid
        if xmppStream!.isConnected() {
            xmppStream?.disconnect()
        }
        
        do {
            try xmppStream?.connect(withTimeout: -1)
        } catch _{
            dPrint("xmpp登录失败-------呵呵")
            isConnect = false
            isLogout = false
        }

    }
    
    /**
     退出登录
     */
     //MARK:--------- 退出
    func logoutWithCompletion(_ pre:@escaping (Bool)->()){
        print("退出操作\(String(describing: isLogout))")
        
        isLogout = true
        saveLogoutCompletionBlock = pre
        goOffline()
        xmppStream?.disconnect()
    }
    
    /**
     通知服务器上线
     */
     //MARK:---------上线
    func goOnline(){
        
        let presence : XMPPPresence = XMPPPresence.share(withType: "available")
        xmppStream?.send(presence)
         delegates?.receiveXmppUserStatus?(message:"用户上线")
        isConnect = true
        print("用户上线")
    }
    
    /**
     通知服务器下线
     */
     //MARK:---------下线
    func goOffline(){
        let presence : XMPPPresence = XMPPPresence.share(withType: "unavailable")
        xmppStream?.send(presence)
        delegates?.receiveXmppUserStatus?(message:"用户离线")
        isConnect = false
        print("用户离线")
    }
    
//    //MARK:------- willReceive presence将要接收到用户在线状态时的回调
//    func xmppStream(_ sender: XMPPStream!, willReceive presence: XMPPPresence!) -> XMPPPresence! {
//         return presence
//    }
//    //MARK:------- willSendpresence将
//    func xmppStream(_ sender: XMPPStream!, willSend presence: XMPPPresence!) -> XMPPPresence! {
//        return presence
//    }
 

    
    //MARK:------- 手动从服务器获取花名册。如果你禁用自动fetch名册 fetch 发送请求之后会执行如下的回调函数
    func xmppStream(_ sender: XMPPStream!, didReceive iq: XMPPIQ!) -> Bool {
        //(lldb) po iq!
//        <iq xmlns="jabber:client" type="result" id="CEE8C22F-2AB2-4265-97EB-9D71FA559F5E" to="18183132010@jgsweep/iphone"/>
        return true
    }
    
    /**
     发送状态成功调用此方法
     
     - parameter sender:   xmppstream
     - parameter presence: xmpppresence
     */
    func xmppStream(_ sender: XMPPStream!, didSend presence: XMPPPresence!) {
        
        if(presence.type() == "unavailable"){
            saveLogoutCompletionBlock?(true)
        }
    }
    
    /**
     发送状态失败调用此方法 -- （用于未登录成功）
     
     - parameter sender:   xmppstream
     - parameter presence: xmpppresence
     */
    func xmppStream(_ sender: XMPPStream!, didFailToSend presence: XMPPPresence!, error: Error!) {
        
        if(presence.type() == "unavailable"){
            
            saveLogoutCompletionBlock?(true)
            
        }
    }
    
    /**
     连接成功调用此方法
     
     - parameter sender: xmppstream
     */
    func xmppStreamDidConnect(_ sender: XMPPStream!) {
        
        //利用密码授权
        //连接成功。就可以进行登录操作了，验证账号和密码是否匹配
        _=try? xmppStream?.authenticate(withPassword: passwordStr)
        
        isConnect = true
        
    }
    
    /**
     授权登录成功调用此方法
     
     - parameter sender:
     */
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        
        saveLoginCompletionBlock?(true)
        goOnline()
        isConnect = true
        
        UserTool.shared().friendsArr = []
        
    }
    
    /**
     授权登录失败调用此方法
     
     - parameter sender:
     - parameter error:  错误信息
     */
    func xmppStream(_ sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        dPrint("登录失败~~\(error)")
        delegates?.receiveXmppUserStatus?(message: "用户登录失败")
        
        saveLoginCompletionBlock?(false)
        
        isConnect = false
    }
    
    
    
    //MARK:------- 用户状态
    func xmppStreamDidDisconnect(_ sender: XMPPStream!, withError error: Error!) {
        dPrint("离线~~\(error)")
        isConnect = false
        
/*      receiveXmppUserStatus   */
        delegates?.receiveXmppUserStatus?(message:"用户离线")
    }
    
    func xmppStreamConnectDidTimeout(_ sender: XMPPStream!) {
        dPrint("连接超时~~")
        isConnect = false
        delegates?.receiveXmppUserStatus?(message:"连接超时")
    }
    
    //func xmppStreamWasTold(toDisconnect sender: XMPPStream!) {
      //  dPrint("服务器通知重连~")
        //self.goOffline()
        //isConnect = false
        //self.reconnect()
        //delegates?.receiveXmppUserStatus?(message:"服务器通知重连")
    //}
    
    
    func xmppStream(_ sender: XMPPStream!, willSecureWithSettings settings: NSMutableDictionary!) {
        
        settings[kCFStreamSSLPeerName as String] = "service.lei-ren.com"
        settings[kCFStreamSSLValidatesCertificateChain as String] = NSNumber.init(value: false as Bool)
        settings["kCFStreamSSLAllowsAnyRoot"] = NSNumber.init(value: true as Bool)
        settings["kCFStreamSSLAllowsExpiredCertificates"] = NSNumber.init(value: true as Bool)
        settings["GCDAsyncSocketUseCFStreamForTLS"] = NSNumber.init(value: true as Bool)
        
    }
    //MARK:__其他手机端登录踢掉本账户
    func xmppStream(_ sender: XMPPStream!, didReceiveError error: DDXMLElement!) {
        print("xmpp账号在别的地方登录")
        delegates?.receiveXmppUserStatus?(message:NSLocalizedString("用户在别的地方登录", comment: "") ) //您的账号已经在其他手机客户端登录
//        let alertViewOfShowOtherP = UIAlertView (title: "用户提示", message: "您的账号已经在其他手机客户端登录", delegate: self, cancelButtonTitle: "知道了")<stream:error xmlns:stream="http://etherx.jabber.org/streams"><conflict xmlns="urn:ietf:params:xml:ns:xmpp-streams"></conflict></stream:error>
//         alertViewOfShowOtherP.show()
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        UIApplication.shared.keyWindow?.rootViewController = appDelegate.nav
//        NSLocalizedString("用户在别的地方登录", comment: "")
        let alertControllerOfPop = UIAlertController(title:NSLocalizedString("提示",comment:"") , message: NSLocalizedString("您的账号已经在其他手机客户端登录", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
        let alertActionOfPop = UIAlertAction(title:NSLocalizedString("知道了", comment: ""), style: UIAlertActionStyle.default) { (UIAlertAction) in
            /*
             //原跳转
             AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             self.view.window.rootViewController = appDelegate.nav;
             
             //NSObject中的跳转
             UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
             [rootViewController presentViewController:filterCourseViewController animated:NO completion:nil];
             */
            
//            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//            UIApplication.shared.keyWindow?.rootViewController = appDelegate.nav
        }
        alertControllerOfPop.addAction(alertActionOfPop)
        
    UIApplication.shared.keyWindow?.rootViewController?.present(alertControllerOfPop, animated: true, completion: nil)
        //1220更改
//        UIApplication.shared.delegate?.window??.rootViewController?.present(alertControllerOfPop, animated: true, completion: nil)
       
        dPrint(error)
        
        let errorArr : Array = error.children() as Array
        
        for  tmpNode in errorArr {
            
            let node = tmpNode as? DDXMLNode
            if node != nil{
                if node?.name() == "conflict"{
                    dPrint("xmpp检测到冲突")
                    xmppTimer?.fireDate = Date.distantFuture
          
                }
                
            }
        }
        
    }
    
    //MARK:------- 重连协议 reconnect delegate
    func xmppReconnect(_ sender: XMPPReconnect!, didDetectAccidentalDisconnect connectionFlags: SCNetworkConnectionFlags) {
        dPrint("重连协议触发\(connectionFlags)")//🍎xmpp意外断开连
        isConnect = false
        
    }
    func xmppReconnect(_ sender: XMPPReconnect!, shouldAttemptAutoReconnect connectionFlags: SCNetworkConnectionFlags) -> Bool {
        dPrint("是否重连协议触发\(connectionFlags)") //🍎xmpp自动重连
        isConnect = false
        if isLogout == false {
            return true
        }else{
            return false
        }
        
    }
    
    //MARK:---------xmppautoping #pragma mark - XMPPAutoPingDelegate /** 定时发送心跳包 */
    func xmppAutoPingDidSend(_ sender: XMPPAutoPing!) {
        dPrint("1ping超时了20190611")
    }
    func xmppAutoPingDidReceivePong(_ sender: XMPPAutoPing!) {
        if let time = pingTimeout {
            if time {
                pingTimeout = false
            }
        }
        dPrint("2ping超时了20190619")
        //20190618新增记时 在ping1 ping2来回切换 但是 未出现ping3时使用
        timeOutCount+=1;
        if timeOutCount>=10 {
            self.goOffline()
            isConnect = false
            self.reconnect()
            timeOutCount = 0;
             dPrint("2ping超时了 重连")
        }
    }
    func xmppAutoPingDidTimeout(_ sender: XMPPAutoPing!) {
         dPrint("3ping超时了20190611")
        
        timeOutCount+=1
        if timeOutCount>=5 {
            pingTimeout = true
            timeOutCount = 0;
        }
        self.goOffline()
        isConnect = false
        self.reconnect()
    }
    
    //MARK:----- 重连
    func reconnect(){
        
        //先判断是否为登陆状态
        if(isLogout == false && (isConnect == false || pingTimeout)){
            print("xmpp重连 reconnect方法调用")
    
            let username :String = ShareUser.sharedUserInfo().userMode.userName!
            let passwor :String = ShareUser.sharedUserInfo().userMode.passWord!
//            let username :String = ShareUser.sharedUserInfo().userMode.userName!+"@jgsweep"
//            let passwor :String = ShareUser.sharedUserInfo().userMode.passWord!+"@jgsweep"
//
            XmppManager.shareXmppManager.loginXmpp(username, password:passwor, pre: {( finish:Bool) in
            
                if finish{
                    print("xmpp登录成功 reconnect")
                    self.pingTimeout =  false
                    self.isConnect = true
                    self.delegates?.receiveXmppUserStatus?(message:"用户登录成功")
                }else{
                    print("xmpp登录失败 reconnect")
                    self.delegates?.receiveXmppUserStatus?(message:"用户登录失败")
                }
                
            } )
            
        }
    }
    
    
    //MARK:------- 查询好友状态
    
    func xmppStream(_ sender: XMPPStream!, didReceive presence: XMPPPresence!) {
        dPrint(presence)
        if presence.type()=="error" {
            return
        }
//        dPrint("查询好友状态--\(presence.type())--\(presence.from().user)")
        if(presence.type() == "subscribe"){//对方主动添加自己为好友 同意请求
            //            let userName = presence.from().user
            //            let userJid = XMPPJID(string:"\(userName)")
            //            let userJid = XMPPJID(string:"\(userName)@jidisec")
            dPrint("来自\(presence)的好友请求")
            xmppRoster?.acceptPresenceSubscriptionRequest(from: presence.from(), andAddToRoster: true)
        }
        else if(presence.type() == "subscribed"){//对方同意添加自己为好友 同意请求
            //            let userName = presence.from().user
            //            let userJid = XMPPJID(string:"\(userName)")
            //            let userJid = XMPPJID(string:"\(userName)@jidisec")
            dPrint("来自\(presence)的好友请求同意")
            xmppRoster?.acceptPresenceSubscriptionRequest(from: presence.from(), andAddToRoster: true)
        }

            //好友在线
        else if (presence.type() == "available"){
            
            
            //好友状态存friend Add change
//            UserTool.shared().addFriendToFriendArr(withFriendName: presence.from().user, friendStatus: presence.type())
            UserTool.shared().changeFriendsStatus(withFriendName: presence.from().user, friendStatus: presence.type())
        
            
            //
            dPrint("\(presence.from().user)在线~")
            if ShareUser .sharedUserInfo().userMode.nowRobotJid != nil {
                if presence.from().user == ShareUser .sharedUserInfo().userMode.nowRobotJid  {
                    delegates?.receiveXmppUserStatus?(message:"扫地机在线")
                }
            }
            if ShareUser .sharedUserInfo().userMode.userName != nil {
                if presence.from().user == ShareUser .sharedUserInfo().userMode.userName  {
                    //delegates?.receiveXmppUserStatus?(message:"用户在线")
                }
            }
            if ShareUser .sharedUserInfo().userMode.userName != nil {
                if presence.from().user == ShareUser .sharedUserInfo().userMode.userName  {
                    delegates?.receiveXmppUserStatus?(message:"用户在线") //20190618去掉注释允许协议通信
                }
            }
            
            
            //判断name是否与机器name一致：若无，则NO；若有，则YES
            
            
        }
            //好友不在线
        else if (presence.type() == "unavailable"){
            //好友状态存friend Add change
//            UserTool.shared().addFriendToFriendArr(withFriendName: presence.from().user, friendStatus: presence.type())
            UserTool.shared().changeFriendsStatus(withFriendName: presence.from().user, friendStatus: presence.type())
            
            
            dPrint("\(presence.from().user)不在线~~")
            
            if ShareUser .sharedUserInfo().userMode.nowRobotJid != nil {
                if presence.from().user == ShareUser .sharedUserInfo().userMode.nowRobotJid  {
                    delegates?.receiveXmppUserStatus?(message:"扫地机离线")
                }
            }
            if ShareUser .sharedUserInfo().userMode.userName != nil {
                if presence.from().user == ShareUser .sharedUserInfo().userMode.userName  {
                    delegates?.receiveXmppUserStatus?(message:"用户离线")
                }
            }
            
        }
        
    }
    func xmppRoster(_ sender: XMPPStream!, didReceive presence: XMPPPresence!) {
        dPrint(presence)
        dPrint("xmppRoster 好友 ")
        if(presence.type() == "subscribe"){//对方添加自己为好友 同意请求
            //            let userName = presence.from().user
            //            let userJid = XMPPJID(string:"\(userName)")
            //            let userJid = XMPPJID(string:"\(userName)@jidisec")
            dPrint("来自\(presence)的好友请求 对方添加自己为好友已同意请求")
            xmppRoster?.acceptPresenceSubscriptionRequest(from: presence.from(), andAddToRoster: true)
        }
        
    }

    //MARK:----------添加好友
    func addFriendAction(friendName:String)  {
      
//        let friendJid :XMPPJID = XMPPJID(user: friendName, domain: "jgsweep", resource:"")
//        xmppRoster?.addUser(friendJid, withNickname: nil);
         print("\(friendName)adding 加好友")
        let friendJid :XMPPJID = XMPPJID(string: "\(friendName)@\(openfireServiceName)")
        xmppRoster?.addUser(friendJid, withNickname: "\(friendName)的昵称")
    }
    //MARK:----------添加好友
    func addFriendAction(friendName:String,nickName:String)  {
        
        //        let friendJid :XMPPJID = XMPPJID(user: friendName, domain: "jgsweep", resource:"")
        //        xmppRoster?.addUser(friendJid, withNickname: nil);
        print("\(friendName)addingwithNick 加好友")
        let friendJid :XMPPJID = XMPPJID(string: "\(friendName)@\(openfireServiceName)")
        xmppRoster?.addUser(friendJid, withNickname: nickName)
    }
    //MARK:_________删除好友
    func deletFriendAction(friendName:String) {
         print("\(friendName)deleting")
        let friendJid :XMPPJID = XMPPJID(string: "\(friendName)@\(openfireServiceName)")
        xmppRoster?.removeUser(friendJid)
    }
    
    //MARK:---------- 好友请求回调 后同意
    func xmppRoster(_ sender: XMPPRoster!, didReceivePresenceSubscriptionRequest presence: XMPPPresence!) {
        //函数已经被我们自己重写了，所以Roster里面的这个函数是不会被调用的。
        let friendJid :XMPPJID = presence.from()
        print("来自\(presence.from())的好友请求 好友请求回调已同意");
        xmppRoster?.acceptPresenceSubscriptionRequest(from: friendJid, andAddToRoster: true)
    }
    //MARK:----------好友列表
    func xmppRosterDidBeginPopulating(_ sender: XMPPRoster!) {
        print("开始检索好友");
        ShareUser .sharedUserInfo().userMode.friendArr = NSMutableArray.init()
    }
    func xmppRoster(_ sender: XMPPRoster!, didRecieveRosterItem item: DDXMLElement!) {
        
//        print("检索到好友=item:\(item)")
        if (item != nil) {
            
            ShareUser .sharedUserInfo().userMode.friendArr.add(item)
        }else{
            return
        }
       
//         print("好友=arr:\(ShareUser .sharedUserInfo().userMode.friendArr)")
//         print("好友=item=:\(item.attributeStringValue(forName: "jid"))")
        //好友状态存friend Add change
        let friendNameStr = item.attributeStringValue(forName: "jid") .components(separatedBy: "@").first;
        
        UserTool.shared().addFriendToFriendArr(withFriendName: friendNameStr, friendStatus:"unavailable")
//        UserTool.shared().changeFriendsStatus(withFriendName: friendNameStr, friendStatus: "unavailable");
    }
    
    
    func xmppRosterDidEndPopulating(_ sender: XMPPRoster!) {
        print("结束检索好友");
        print(UserTool.shared().addFriendToFriendArr)
    }
  
    //MARK:__________
    //MARK:____________发送--------以下与发送指令相关
    func sendOrderToRobotleo(_ pramaDic : Dictionary<String ,AnyObject>, messageType:String!){
        //MARK:--信息不全
    }
    
    func sendMessageToRobot(message : String){
        if ShareUser.sharedUserInfo().userMode.nowRobotJid == nil {
            return
        }
        isLogout = false//退出后登录不进行sharexmpp isLogout=true要改
    
        //加密后新增
//        sendMsgSerialqueue.addOperation {
            self.sendmsgOfoneSq(message: message)
//        }
       
        
    }
    
    func sendmsgOfoneSq(message : String){
        
        let messageElement : DDXMLElement = DDXMLElement.element(withName: "message") as! DDXMLElement
        
        messageElement.addAttribute(withName: "type", stringValue: "chat")
        //        messageElement.addAttribute(withName: "to", stringValue: ShareUser.sharedUserInfo().userMode.nowRobotJid)
        //        messageElement.addAttribute(withName: "from", stringValue: ShareUser.sharedUserInfo().userMode.userName)
        //jgsweep
        
        messageElement.addAttribute(withName: "to", stringValue: ShareUser.sharedUserInfo().userMode.nowRobotJid+"@\(openfireServiceName)")
        //@sweep
        messageElement.addAttribute(withName: "from", stringValue: ShareUser.sharedUserInfo().userMode.userName+"@\(openfireServiceName)")
        
        
        //以下为body内容
        
        let bodyElement : DDXMLElement = DDXMLElement.element(withName: "body") as! DDXMLElement
        //加密数据添加到body
        

            let strOfEncryp = AesEDsweep.aesEorDwithTypeIsE(1, isStrOFSourceStr: message)
            bodyElement.setStringValue(strOfEncryp)
        
        
 //        if(message=="request_connect"){//测试数据没有加密的
//        }else{
//            bodyElement.setStringValue(message)
//        }
        
        //没加密数据添加到body
        
        
        messageElement.addChild(bodyElement)
        
        //以下为消息类型
        //        let propertiesEle : DDXMLElement = DDXMLElement.element(withName: "properties") as! DDXMLElement
        //        propertiesEle.addAttribute(withName: "xmlns", stringValue: "http://www.jivesoftware.com/xmlns/xmpp/properties")
        //
        //        //        let addtionPropertyEle : DDXMLElement = DDXMLElement.element(withName: "property") as! DDXMLElement//遇到崩溃qu diaoThread 1: signal SIGABRT
        //
        //        messageElement.addChild(propertiesEle)
        xmppStream?.send(messageElement)
        
        print("发送了密文")
        //         print(messageElement)
    }
    
    func sendTestRequsetconnect()  {
        isLogout = false//退出后登录不进行sharexmpp isLogout=true要改
        
        
        let messageElement : DDXMLElement = DDXMLElement.element(withName: "message") as! DDXMLElement
        
        messageElement.addAttribute(withName: "type", stringValue: "chat")
        let testjidStr = "";
        messageElement.addAttribute(withName: "to", stringValue: testjidStr+"@\(openfireServiceName)")
        //@sweep
        messageElement.addAttribute(withName: "from", stringValue: ShareUser.sharedUserInfo().userMode.userName+"@\(openfireServiceName)")
        
        //以下为body内容
        let bodyElement : DDXMLElement = DDXMLElement.element(withName: "body") as! DDXMLElement
        bodyElement.setStringValue("request_connect")
        messageElement.addChild(bodyElement)
        
        //以下为消息类型
        let propertiesEle : DDXMLElement = DDXMLElement.element(withName: "properties") as! DDXMLElement
        propertiesEle.addAttribute(withName: "xmlns", stringValue: "http://www.jivesoftware.com/xmlns/xmpp/properties")
        
        let addtionPropertyEle : DDXMLElement = DDXMLElement.element(withName: "property") as! DDXMLElement
        
        
        messageElement.addChild(propertiesEle)
    
        print(messageElement)
        xmppStream?.send(messageElement)
        print("发送testsend Test Requsetconnect")
    }

    //MARK:------信息发送成功失败相关
    func xmppStream(_ sender: XMPPStream!, didSend message: XMPPMessage!) {
        
       
        
        //<message type="chat" to="lmc1@robotleo" from="lmc@robotleo"><body>request_connect</body><properties xmlns="http://www.jivesoftware.com/xmlns/xmpp/properties"/></message>
        delegates?.sendMessageSuccess?()
        
        print("didSend\(message)")
        
    }
    
    func xmppStream(_ sender: XMPPStream!, didFailToSend message: XMPPMessage!, error: Error!) {
        print("发送失败~~~~\(error)")
//        if message.body() == "order_stop"{
//            XmppManager.shareXmppManager.sendMessageToRobot(message: "order_stop")
//        }
        print("失败~~~~\(message)")
        delegates?.sendMessageFail?()
       
    }
    
    //MARK:--- 收到消息
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!) {
        /***/
        if message.attribute(forName: "type").stringValue() == "error" {
        
            if (message.from()==nil) {
                print("error 收到的xmpp消息:空user给的数据 \(message.body())")
            }else{
                print("error 收到的xmpp消息:\(message.from().user) \(message.body())")
            }
        }else{
            if (message.from()==nil) {
                print("收到的xmpp消息:空user给的数据 \(message.body())")
            }else{
                if(message.body().count>400){
                    print("收到的xmpp消息>400长度 ");
//                      print("收到的xmpp消息>400长度  \n \(message.body())")
                }else{
//                     print("收到的xmpp消息<400:\(message.from().user) \(message.body())")
                }
              
            }
        }
 
//        print("收到的xmpp消息:\(message.from().user) \(message.body())")
        
//        let propertiesXmlDoc : DDXMLDocument? = try? DDXMLDocument(xmlString: message.forName("properties").description(), options: 0)
//        if propertiesXmlDoc != nil{
//            let propertiesArray : NSArray = try! propertiesXmlDoc!.nodes(forXPath: "/*/*") as NSArray
//            
//        }
        
       
        
        if message.attribute(forName: "type").stringValue() == "chat"{
            if ShareUser.sharedUserInfo().userMode.nowRobotJid == nil {//这种是离线消息
                
//                 print("收到的xmpp.是连接\(message.from().user)  请求后的消息离线消息.\(message.body())")
                return
            }
            
            if (ShareUser.sharedUserInfo().userMode.nowRobotJid == message.from().user) {
            
                let contentStr = message.body()
//                print("收到\(message.from().user) 的xmpp消息")
//                 print(contentStr)
//                if ( contentStr.characters.count > 50){
//                    
//                    print("收到>20的")
//                }else{
//                     print(contentStr)
//                }
               
                //解密
                let strOfD = AesEDsweep.aesEorDwithTypeNotE(0, isStrOFSourceStr: contentStr)
                if (strOfD != nil){
                    let strOfdecrypt:NSString = strOfD! as NSString
                    if(strOfdecrypt.length > 0){
                        delegates?.receiveXmppMessage?(message: strOfdecrypt as String)
                        
                    }
                }
               
                //解密
//                let strOfD2 = AesEDsweep.aesEorDwithTypeNotE(0, isStrOFSourceStr: "SYqPag9xN+QdziD6Pk9flg==")
//                if (strOfD != nil){
//                    let strOfdecrypt:NSString = strOfD! as NSString
//                    if(strOfdecrypt.length > 0){
//
//                    }else{
//
//                    }
//                    print(strOfD2)
//                }
                //没解密
//                delegates?.receiveXmppMessage?(message: contentStr)
            }

        }
    }
    func xmppStream(_ sender: XMPPStream!, didReceiveP2PFeatures streamFeatures: DDXMLElement!) {
        print("xmpp didReceiveP2PFeatures")
    }
        
    
 
}

