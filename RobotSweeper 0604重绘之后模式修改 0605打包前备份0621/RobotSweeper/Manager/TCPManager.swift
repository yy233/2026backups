//
//  TCPManager.swift
//  RobotSweeper
//
//  Created by 美超刘 on 2017/5/22.
//  Copyright © 2017年 美超刘. All rights reserved.
//

import UIKit

@objc enum TcpStatus:Int{
    
    case isTCPConnect,isTCPFail,isServiceConnect,isServiceFail
}

@objc protocol TCPDelegate : class  {
    
    
    func socketDidReceiveData(msg:String, withData data:Data?,tag:Int)
//    func socketDidReceiveData(msg:String, withData data:Data?,tag:Int)
    func socketDidReceiveData( msg:String, withData data:Data?)
    func socketDidConnectSuccess(tcpStatus:TcpStatus)
    func reloadProgress(pro:CGFloat)
}

class TCPManager: NSObject,GCDAsyncSocketDelegate {
    
    var tcpSocket : GCDAsyncSocket?
    
    var servicePort = 14000
    var selfPort = 14001
//    var host = "255.255.255.255"
    
    var hostArr : Array<String>! = Array()
    
    weak var tcpDelegate : TCPDelegate?
    
    var allData : NSMutableData = NSMutableData()
    
    var receiveData : Data = Data()
    
    var isNum = false
    var dataNum = 0
    
    var totalLength : UInt32 = 0
    var sendLength : UInt32 = 0
    
    static var shareTCPManager = { () -> TCPManager in
        
        let instance = TCPManager()
        instance.initTCP()
        return instance
        
    }()
    
    func initTCP(){
        
        

    }
    //断开操作
    func doDuankaiTcp()  {
        tcpSocket?.disconnect()
    }
    func doConnect(){
        
        if tcpSocket == nil{
            
            tcpSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        }
//        
//        let isConnect  =  try? tcpSocket!.connect(toHost: DataManager.shareDataManager.sweeperIP, onPort: UInt16(DataManager.shareDataManager.sweeperPort)!)
//        let isConnect  =  try? tcpSocket!.connect(toHost: "127.0.0.1", onPort: 12020)
      
      
        
      let isConnect = try?tcpSocket?.connect(toHost:  DataManager.shareDataManager.sweeperIP,  onPort: UInt16(DataManager.shareDataManager.sweeperPort)!)
          print("isConnect==\(String(describing: isConnect))" )
        
//          tcpSocket?.readData(withTimeout: -1, tag: 0)
    }

    func sendMsg(msg:String){
        print("tcp sendMsg:\(msg)")
        let data = DataHelper.changeString(toData: msg)
        tcpSocket?.write(data!, withTimeout: -1, tag: 0)
        isNum = true
        
    }
    
    func sendMsg(msg:String, tag:Int){
        print("tcp sendMsg:\(msg) tag:\(tag)")
        let data = DataHelper.changeString(toData: msg)

        tcpSocket?.write(data!, withTimeout: -1, tag: tag)
        isNum = true
        
    }
    
        func sendSSID(array:Array<String>){
        
        let data = DataHelper.changeSsidAndPwd(toData: array)
        
        tcpSocket?.write(data!, withTimeout: -1, tag: 0)
        isNum = true
    }
    
    func sendFile(data:Data){
        
        let finData = DataHelper.appendLength(data, length: UInt32(data.count))
        totalLength = UInt32(data.count)
        tcpSocket?.write(finData, withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int) {
        print("发送-didWriteData")
        
        tcpDelegate?.reloadProgress(pro: 10000)//上传完成
    }
    
    func socket(_ sock: GCDAsyncSocket!, didWritePartialDataOfLength partialLength: UInt, tag: Int) {
        
        sendLength = sendLength + UInt32(partialLength)
        print(sendLength)
        let pro = CGFloat(sendLength)/CGFloat(totalLength)
         print("发送-didWriteDataLength:\(pro)")
        tcpDelegate?.reloadProgress(pro: pro)
        
    }
    
    func socket(_ : GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("connect")
        hostArr.append(host)
        tcpSocket?.readData(withTimeout: -1, tag: 0)
        tcpDelegate?.socketDidConnectSuccess(tcpStatus: .isTCPConnect)
        DataManager.shareDataManager.isConnect = true
        
    }
    func socket(_ sock: GCDAsyncSocket!, didReceive trust: SecTrust!, completionHandler: ((Bool) -> Void)!) {
        
        
    }
    func socketDidDisconnect(_ sock: GCDAsyncSocket!, withError err: Error!) {
         print(err)
        tcpDelegate?.socketDidConnectSuccess(tcpStatus: .isTCPFail)
    }
    func socketDidCloseReadStream(_ sock: GCDAsyncSocket!) {
        print("关闭")
        DataManager.shareDataManager.isConnect = false
        tcpDelegate?.socketDidConnectSuccess(tcpStatus: .isTCPFail)
    }
    func socket(_ sock: GCDAsyncSocket!, didRead data: Data!, withTag tag: Int) {
        print("收到数据")
//        print(data)
        allData.append(data)
        
        while allData.length > 3 {
            
            if allData.length < 4{
                break
            }
            
            let msgLen = Int(DataHelper.getDataLenght(allData as Data!))
            
            if allData.length < 4 + msgLen {
                break
            }
            
            receiveData = allData.subdata(with: NSMakeRange(4, msgLen))

            
            let msg = DataHelper.changeData(toString: receiveData)
            if(msg==nil){//tcp的msgnil
                return
            }
           let message = String(describing: msg)
            print("tcp的msg\(message)")
            
//            allData.replaceBytes(in: NSMakeRange(4, msgLen), withBytes: <#T##UnsafeRawPointer#>)
            allData.replaceBytes(in: NSMakeRange(0,4 + msgLen), withBytes: nil, length: 0)
            
            if msg == "ok"{
                tcpDelegate?.socketDidConnectSuccess(tcpStatus: .isServiceConnect)
            }else if (msg?.hasPrefix("version"))!{
 
            }else if (msg?.hasPrefix("robot"))!{
                   tcpDelegate?.socketDidReceiveData(msg: msg!, withData: receiveData)
            }else{
 
               
//                tcpDelegate?.socketDidReceiveData(msg: msg!, withData: receiveData)//会崩
//                tcpDelegate?.socketDidReceiveData(msg: msg!, withData: receiveData, tag: tag)
//                
            }
              tcpDelegate?.socketDidConnectSuccess(tcpStatus: .isServiceConnect)
            
        }
        

        tcpSocket?.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket!, didReadPartialDataOfLength partialLength: UInt, tag: Int) {
        
    }
    
    
    func socket(_ sock: GCDAsyncSocket!, shouldTimeoutReadWithTag tag: Int, elapsed: TimeInterval, bytesDone length: UInt) -> TimeInterval {
      return 10
    }
    
    func socketDidSecure(_ sock: GCDAsyncSocket!) {
        
    }
    
    

}
