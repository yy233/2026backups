//
//  AppDelegate.swift
//  RobotSweeper
//
//  Created by 美超刘 on 2017/5/10.
//  Copyright © 2017年 美超刘. All rights reserved.
//

import UIKit
 
@UIApplicationMain

 

class AppDelegate: UIResponder, UIApplicationDelegate ,selectDelegate {
    

    var nav : UINavigationController?
    var window: UIWindow?
    var hostReachability : Reachability?
    
    let yindaoVc:XTGuidePagesViewController? = XTGuidePagesViewController.init()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
 
    
        var yinDaoImages:NSMutableArray = ["yindao_0","yindao_1","yindao_2","yindao_3","yindao_4","yindao_5"]
        if NowLanguageTool.robotAppOfGetPreferredLanguageNum()==0 {//中文英文
            yinDaoImages = ["yindao_0","yindao_1","yindao_2","yindao_3","yindao_4","yindao_5"]

        }else{
            yinDaoImages = ["welcome00","welcome1","welcome2","welcome3","welcome4"]
            if(SCREEN_HEIGHT>800){
               yinDaoImages.add("welcome5x")//x
            }else{
                yinDaoImages.add("welcome5")
            }
            
        }
        
        if (XTGuidePagesViewController.isShow()){
            DataManager.shareDataManager.isAnNewApp = 1;
//            print("开机状态1 \(DataManager.shareDataManager.isAnNewApp)")
            yindaoVc?.delegate = self
            yindaoVc?.guidePageController(withImages: yinDaoImages as! [Any])
            self.window?.rootViewController = yindaoVc
        }else{
            DataManager.shareDataManager.isAnNewApp = 0;
//             print("开机状态2 \(DataManager.shareDataManager.isAnNewApp)")
            self.clickEnter()
          
        }

        return true
    }
    func clickEnter() {
//        print("开机状态3 \(DataManager.shareDataManager.isAnNewApp)")
        self.setNavApp()
        let loginStoryBo = UIStoryboard(name: "LoginViewController", bundle: nil)
        let loginVc = loginStoryBo.instantiateViewController(withIdentifier: "LoginViewController")
        print(loginVc)
        
        //        let loginNav = UINavigationController(rootViewController: loginVc)
        //        self.window?.rootViewController = loginNav
        
        self.nav = UINavigationController(rootViewController: loginVc)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = self.nav
        
       
        
        hostReachability = Reachability(hostName: "www.baidu.com")
        hostReachability?.startNotifier()
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.reachabilityChanged(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
    }
    
    
    func setNavApp() {
        /**
         [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
         [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
         [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:Y_IMAGE_ORIGINAL(@"返回按钮")];
         [[UINavigationBar appearance] setBackIndicatorImage:Y_IMAGE_ORIGINAL(@"返回按钮")];
         [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100) forBarMetrics:UIBarMetricsDefault];
         [[UIImage imageNamed:_imgName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
         */
        
       
       
        UINavigationBar.appearance().backgroundColor = UIColor.white
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "返回按钮")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "返回按钮")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)


        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -64), for: .default)
        UIBarButtonItem.appearance().setBackButtonBackgroundVerticalPositionAdjustment(-32, for: .default)
 
      
    }
    
    func test(req:Dictionary<String,AnyObject>){
        
        if req["code"]?.int32Value == 200{
            
            let xmppArr = req["rows"] as! NSArray
            let xmppDic = xmppArr[0] as! Dictionary<String,String>
            
            XmppManager.shareXmppManager.loginXmpp(xmppDic["oprname"]! + "@robotleo", password: xmppDic["passed"]!, pre: {( finish:Bool) in
                
                if finish{
                    print("xmpp登录成功test")
                }else{
                    print("xmpp登录失败test")
                }
                
            } )
            
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")//回到后台
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")
        /*
         NSArray *documentArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
         NSString *DBPath = [documentArray.lastObject stringByAppendingString:@"/DB/TimmerModelDB.db"];
         NSLog(@"DB 路径%@", DBPath);
         */
        
        
        
        
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("~~~~~~~~~~~~")

    }

    func launchAnimation(){
        
        let viewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "LaunchScreen")
        
        
        let launchView : UIView? = UIView()
//        let launchView = viewController.view
        launchView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        imageView.image = SkinManager.skin_imageWithName(imageName: "ld")
        launchView?.addSubview(imageView)
        
        //动画view
        
         let sweeperView = LGifImageView(frame: CGRect(x: _originX(60), y: _originY(150), width: SCREEN_WIDTH - _width(120), height: _height(70)))
        sweeperView.isOnce = true
        launchView?.addSubview(sweeperView)
        
        let filePath = Bundle.main.path(forResource: "Sweeper", ofType: "gif")
        sweeperView.setData(try? Data(contentsOf: URL(fileURLWithPath: filePath!)), pre: {(finish:Bool) in
            
            if finish {
                //动画消失
                UIView.animate(withDuration: 1, animations: {
                    
                    launchView?.alpha = 0
                    
                }, completion: {(isFinish:Bool) in
                    
                    if isFinish{
                        launchView?.removeFromSuperview()
                    }
                    
                })
                
            }
        })
        
        let lineAniView = LGifImageView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - _height(200), width: SCREEN_WIDTH , height: _height(150)))
        launchView?.addSubview(lineAniView)
        
        let filePath1 = Bundle.main.path(forResource: "line", ofType: "gif")
        lineAniView.setData(try? Data(contentsOf: URL(fileURLWithPath: filePath1!)), pre: {(finish:Bool) in
            
           
        })
    
      
        self.window?.rootViewController?.view?.addSubview(launchView!)
        
        
    }
    
    func testUpload(){
        
        let pngImage = UIImage(named: "background_colour")
        
        let KCompressionQuality : CGFloat = 0.8
        let imageData : Data = UIImageJPEGRepresentation(pngImage!,KCompressionQuality)!
        
        
        if FileManager.default.fileExists(atPath: PicturePath()) == false{
            
            try! FileManager.default.createDirectory(atPath: PicturePath(), withIntermediateDirectories: true, attributes: nil)
            
        }
        
        let nameStr = "1111.png"
        
        let sss : Bool = (try? imageData.write(to: URL(fileURLWithPath: "\(PicturePath())\(nameStr)"), options: [])) != nil
        dPrint(sss)
        
        
        NetRequestService.shareNetWork.formRequest(UploadLog, paraDic: ["serial":"11111111"], fileDic: ["lineLogUrl":"\(PicturePath())\(nameStr)"], target: self, selector: #selector(resUpload(reqDic:)), method: "post")
    }
    
    func resUpload(reqDic:Dictionary<String,AnyObject>){
        
    }
    
    func reachabilityChanged(_ note:Notification){
        let curReachability = note.object as! Reachability
        let status : NetworkStatus = curReachability.currentReachabilityStatus()
        
        switch status{
        case NotReachable:
            dPrint("lmc_无网络")
            
            break
        case ReachableViaWWAN:
            dPrint("lmc_3G")
//            XmppManager.shareXmppManager.reconnect()
         
            break
        case ReachableViaWiFi:
            dPrint("lmc_wifi")
//            XmppManager.shareXmppManager.reconnect()
            break
        default:
            break
            
        }//NotReachable ReachableViaWiFi ReachableViaWWAN
    }
   
}

