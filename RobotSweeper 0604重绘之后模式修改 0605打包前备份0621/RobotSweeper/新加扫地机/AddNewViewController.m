//
//  AddNewViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/1/29.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "AddNewViewController.h"
//#import "XMLReader.h"
#import "XMLDictionary.h"
//#import "PersonalCenterViewController.h"//
#import "PersoncenterXViewController.h"
#import "AddTwoPlanChooseViewController.h"
#import "WillSendTcpWifiDataViewController.h"

@interface AddNewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XmppManagerDelegate,NSXMLParserDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *addCollectionView;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPress;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftItem;
@property (nonatomic,strong) NSMutableArray *arrOfMachine;

@property (nonatomic,strong) NSString *versionInfoXmlStr;
@property (nonatomic,strong) NSMutableArray *versionInfoXmlArr;
@property (nonatomic, copy) NSMutableArray * arrayaaaaa;
@property (nonatomic,assign) BOOL isSuccessLoginXmpp;
@property (nonatomic,assign) BOOL isSuccessGetOK;
@property (nonatomic,strong) NSTimer *didSeltTimer;
@property (nonatomic,assign) int didSeltTimerNum;
@end

@implementation AddNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = NSLocalizedString(@"机器人", nil);


//    [ToolOfBasic appIsJgReturnOneIsLgReturnTwoIsZgReturnThrOtherReturnZone];//初始化当前app所用到的主页图标str
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.alpha = 1;
    self.navigationController.navigationBarHidden = NO;

    self.addCollectionView.showsHorizontalScrollIndicator = NO;
    self.addCollectionView.showsVerticalScrollIndicator = NO;
    
    _isSuccessLoginXmpp = NO;
    XmppManager.shareXmppManager.delegates = self;
//    NSLog(@"是否支持替换=%i",[UIApplication sharedApplication].supportsAlternateIcons);//10.1会在这里崩溃
    
    
//    
//    NSOperationQueue *que = [[NSOperationQueue alloc]init];
//    que.maxConcurrentOperationCount = 1;
//    NSBlockOperation *operetionInitData = [NSBlockOperation blockOperationWithBlock:^{
//        [self initData];
//    }];
//    
//    NSBlockOperation *operetionUpVesionInfo = [NSBlockOperation blockOperationWithBlock:^{
//        [self upVersionInfo];
//    }];
//    [operetionUpVesionInfo addDependency:operetionInitData];
//    [que addOperation:operetionUpVesionInfo];
//    [que addOperation:operetionInitData];
  
    
//    [self initData];
    
    [self initView];
    [self initLoginXmpp];
    
    [self xuniqiangdata];
    [self isNewVersionAppWillPostData];
}
#pragma mark --isNewVersionAppWillPostData
- (void)isNewVersionAppWillPostData{
    if ([DataManager shareDataManager].isAnNewApp>=1) {
        [[ToolOfNetWork sharedTools] endXml];
    
         NSString *strOfVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSMutableDictionary *parms = [NSMutableDictionary dictionary];
        [parms setValue:[ShareUser sharedUserInfo].userMode.userNameNoSuffix forKey:@"userPhone"];
        [parms setValue:@"IOS" forKey:@"type"];
        [parms setValue:strOfVersion forKey:@"version"];
        NSLog(@"parms = %@",parms);
        [[ToolOfNetWork sharedTools]YrequestURL:S_ClientUpdateLogControllerInsert withParams:parms finished:^(id responsObject, NSError *error) {
            if (_Success) {
                NSLog(@"开机状态 _Success");
                [DataManager shareDataManager].isAnNewApp = 0;//完成 之后在新版前不上传数据
            }else{
                NSLog(@"开机状态 _f");
                [DataManager shareDataManager].isAnNewApp = 1;//下次再上传数据
                
            }
        }];
    }
}

#pragma mark -- 
- (void)xuniqiangdata{
     //数据持久化取出来复制使用
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    [DataManager shareDataManager].wallArrDataSource = [NSArray arrayWithArray:[def objectForKey:K_XUNIQIANG]];
}
#pragma mark --

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /**加上这一段刷新部分也会展示出来*/
    self.extendedLayoutIncludesOpaqueBars = YES;
    /**
     if (@available(iOS 11.0, *)) {
     self.addCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
     } else {
     self.automaticallyAdjustsScrollViewInsets = NO;
     }
     ps:   if (@available(iOS 11.0, *)) ios 11才有的oc方法,且会出现下移等bug，此方法原为swift方法
    
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 11.0) {
        // 针对 11.0 以上的iOS系统进行处理
//        self.addCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//此需要匹配@available使用
    } else {
        // 针对 11以下的iOS系统进行处理
         self.automaticallyAdjustsScrollViewInsets = NO;
    }
      */
//      NSString *version = [UIDevice currentDevice].systemVersion;
    if (@available(iOS 11.0, *)) {
        self.addCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        NSLog(@"@available version a=%@",version);
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
//         NSLog(@"@available version b=%@",version);
    }
    
    _addCollectionView.scrollIndicatorInsets = _addCollectionView.contentInset;
    
    //可用，手指范围合适
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self initData];

    [ShareUser sharedUserInfo].userMode.nowRobotJid = nil;
    [XmppManager shareXmppManager].delegates = self;
   _isSuccessGetOK = NO;
    
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- view
- (void)initView{
 
    
//    _addCollectionView.contentInset = UIEdgeInsetsMake(-Y_getRectNavAndStatusHight, 0, 49, 0);
    
    
    self.addCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.didSeltTimer invalidate];
        [self.didSeltTimer setFireDate:[NSDate distantFuture]];
        self.didSeltTimer = nil;
        [self initData];
        [self initLoginXmpp];
        //刷新时的加载弹出框hide掉
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something..
            dispatch_async(dispatch_get_main_queue(),^{
                [MBProgressHUD hideHUD];
            });
        });
    }];
    
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    [self.addCollectionView addGestureRecognizer:_longPress];

//个人中心
    [self initItemBtn:NO];
    
}

- (void)initItemBtn:(BOOL)haveInformation{//去掉左侧登出
    UIView *itemBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 24, 24)];
    
    if (haveInformation) {
         [itemBtn setImage:[UIImage imageNamed:@"gerenzhongxin_hongdian"] forState:UIControlStateNormal];
    }else{
        [itemBtn setImage:[UIImage imageNamed:@"gerenzhongxin"] forState:UIControlStateNormal];
    }
    [itemBtn addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [itemBackV addSubview:itemBtn];
    UIBarButtonItem *lefB = [[UIBarButtonItem alloc]initWithCustomView:itemBackV];
    
    self.navigationItem.rightBarButtonItem = lefB;
//   _leftItem = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
//    [_leftItem initWithCustomView:itemBackV];
  
//    _leftItem.image = [UIImage imageNamed:@"gerenzhongxin"];
//    _leftItem
    
  
//    UIBarButtonItem *leftBtn =[[UIBarButtonItem alloc]initWithTitle:@"登出" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction:)];
   
    
}
- (void)rightItemAction:(UIButton *)sender{
 
    
    //防止mbp还在转的情况
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something..
        dispatch_async(dispatch_get_main_queue(),^{
            [MBProgressHUD hideHUD];
        });
    });
////    //跳转个人中心
    PersoncenterXViewController *personCenterVc = [[PersoncenterXViewController alloc]init];
    [[ToolOfNetWork sharedTools]endXml];//防止xml格式
    [self.navigationController pushViewController:personCenterVc animated:YES];
    
//    WillSendTcpWifiDataViewController *v = [[WillSendTcpWifiDataViewController alloc]init];
//[self.navigationController pushViewController:v animated:YES];
   
    //遥控
//    RemoteMonitorTwoNoMonitorViewController*remoteMonitorTvc = [[RemoteMonitorTwoNoMonitorViewController alloc]init];
//   [self.navigationController pushViewController:remoteMonitorTvc animated:YES];
    //监控

//    [ShareUser sharedUserInfo].userMode.nowRobotJid = @"020101001000c4331edb3";//333 020101001000c4331edb3
//    RemoteMonitorViewController*remoteMonitorTvc = [[RemoteMonitorViewController alloc]init];
//    remoteMonitorTvc.strOfShowAreaTimeCharge = @"1|2|90";
//   [self.navigationController pushViewController:remoteMonitorTvc animated:YES];
   
    //升级测试
//    UpViewController*upvc = [[UpViewController alloc]init];
//    upvc.isSlamUp = YES;
//    upvc.isCtrlUp = NO;
//    [self.navigationController pushViewController:upvc animated:YES];
//
}

- (void)leftBtnAction:(UIBarButtonItem *)sender{
    
    //初始化
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出" message:@"是否退出当前账户" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self logoutAction];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:noAction];
    
    alert.view.layer.cornerRadius = 8;
    alert.view.backgroundColor = [UIColor whiteColor];
    alert.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:alert animated:YES completion:nil];

}
- (void)logoutAction{
    [[XmppManager shareXmppManager]logoutWithCompletion:^(BOOL finish) {
       
        if (finish) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            self.view.window.rootViewController = appDelegate.nav;
        } else {
            [self.view makeToast:NSLocalizedString(@"登出失败", nil)  duration:2 position:@"center"];
            
        }
    }];
    

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//     [[ToolOfNetWork sharedTools]endXml];//防止xml格式
}
#pragma mark -- data

- (void)initData{
     
    [[ToolOfNetWork sharedTools]endXml];//防止xml格式
    NSMutableArray *arrOfSaveMachineIfIsXmlDateArr = [NSMutableArray arrayWithArray:  _arrOfMachine];//存下原arr防止xml格式后arr被清空的情况
//    _arrOfMachine = [[NSMutableArray alloc]init];
    
     NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[ShareUser sharedUserInfo].accountNum,@"userPhone",nil];
     [[ToolOfNetWork sharedTools]YrequestGetURL:S_equipmentQuery withParams:parms finished:^(NSMutableDictionary* responsObject, NSError *error) {
       NSLog(@"allrobot-----%@ err=%@",responsObject,error.debugDescription);
         ///队列
         NSOperationQueue *que = [[NSOperationQueue alloc]init];
         que.maxConcurrentOperationCount = 1;//同时执行的最大操作数量
         
         //扫地机列表数据
         NSBlockOperation *operetionInitDataParsing = [NSBlockOperation blockOperationWithBlock:^{
  
            _arrOfMachine = [[NSMutableArray alloc]init];//0122刷新延时界面空了的情况
             if(self.addCollectionView.mj_header!=nil){
                     [self.addCollectionView.mj_header endRefreshing];
             }
             
             if ([responsObject isKindOfClass: [NSDictionary class]] || [responsObject isKindOfClass: [NSMutableDictionary class]]) {
                 //非xml数据则可用
             }else{
                 //否则返回 且把存下的arr返回给
                 _arrOfMachine = [NSMutableArray arrayWithArray: arrOfSaveMachineIfIsXmlDateArr];
                 return ;
             }
             if (_Success) {
                 
                 
                 NSMutableDictionary *responsDic = [NSMutableDictionary dictionaryWithDictionary:responsObject];
                 _arrOfMachine = [NSMutableArray arrayWithArray:responsDic[@"list"]];
                 [UserTool sharedUserTool].listOfRobotsArr = [NSMutableArray arrayWithArray:responsDic[@"list"]];
                 //空|有机器人
//                 没有发现机器人 服务器的msg。。
                 
                 
                 NSDictionary *dicOfFirst = [NSDictionary dictionaryWithDictionary: [UserTool sharedUserTool].listOfRobotsArr.lastObject];//后加的品牌为主题颜色切换标准
                 NSString *strOfFirstRobotJid = [NSString stringWithFormat:@"%@",[dicOfFirst objectForKey:@"eqOpfJid"]];//eqHardwareSerial
                 //根据品牌设置界面等数据 这是以jid的来配 服务器提供eqType也是一种方法
                 [ToolOfBasic appIsJgReturnOneIsLgReturnTwoIsZgReturnThrOtherReturnZoneWithFirstRobotId:strOfFirstRobotJid];//更改主题 
                 //保存主题 在登录时调用本颜色
                 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                 [def setObject:[DataManager shareDataManager].appNowProductTypeNumStr forKey:MainTypeNumStr];
                 [def synchronize];
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                    [_addCollectionView reloadData];
//                     NSString *msg = responsDic[@"msg"];
                     NSString *msg  = NSLocalizedString(@"获取绑定列表成功", nil);
                     
                    [self.view makeToast:msg];
                 });
               
                 
             }else{
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSString *msg = NSLocalizedString(@"获取绑定列表失败", nil);
                     if (_SuccessOrErrCode==400) {
                         msg  = NSLocalizedString(@"用户名不能为空", nil);
                     }else if (_SuccessOrErrCode==401){
                         msg  = NSLocalizedString(@"用户不存在，请重新注册或者联系客服", nil);
                     }else if (_SuccessOrErrCode==402){
                         msg  = NSLocalizedString(@"暂未绑定机器人", nil);
                         [UserTool sharedUserTool].listOfRobotsArr = [NSMutableArray array];
                         [self.addCollectionView reloadData];//0108解绑后数据OK但是没有刷新造成的数据没变
                     }else{
                         
                     }
                     
                     [self.view makeToast:msg duration:1.5 position:@"center"];
                     
                     
                 });
                 
             }
         }];
     
         //版本号xml文件
         NSBlockOperation *operetionUpVesionInfo = [NSBlockOperation blockOperationWithBlock:^{
 
             //延时一秒防治数据类型处理bug
          dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
             dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                 [self upVersionInfo];
             });
         }];
         [operetionUpVesionInfo addDependency:operetionInitDataParsing];//依赖关系
         [que addOperation:operetionInitDataParsing];//列表数据
         [que addOperation:operetionUpVesionInfo];//版本XML
   
     
     }];
    
}
#pragma mark -- upVersion
- (void)upVersionInfo{
    //导航版
    NSString *slamStr = [DataManager shareDataManager].xmlOfMainSlam;
    //控制板
    NSString *ctrlStr = [DataManager shareDataManager].xmlOfMainCtrl;

    if(slamStr.length>0&&ctrlStr>0){
        //地址空时不做操作
        return;
    }else{//现在不做xml请求，在map页时做请求 本方法仅留下用于备份
        return;
    }
    //算了都不做这一步 在map页再做更具当前typeID进行xml版本获取
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSInteger sizeInteger = [[NSURLCache sharedURLCache] currentDiskUsage];
    float sizeInMB = sizeInteger / (1024.0f * 1024.0f);
     NSLog(@"--upVersionInfo---%f",sizeInMB);
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    
    //
//    [[ToolOfNetWork sharedTools]YrequestXmlURL:slamStr withParams:parm finished:^(NSXMLParser *responsObject, NSError *error) {
//     NSLog(@"upppps-----%@ err=%@",responsObject,error.debugDescription);
//        NSXMLParser *parserOfversion = responsObject;
//        parserOfversion.delegate = self;
//        [parserOfversion parse];
//    }];
//    //
//    [[ToolOfNetWork sharedTools]YrequestXmlURL:ctrlStr withParams:parm finished:^(NSXMLParser *responsObject, NSError *error) {
//
//        NSLog(@"uppppc-----%@ err=%@",responsObject,error.debugDescription);
//        NSXMLParser *parserOfversion = responsObject;
//        parserOfversion.delegate = self;
//        [parserOfversion parse];
//    }];
    
        [[ToolOfNetWork sharedTools]YrequestXmlURL:slamStr withParams:parm finished:^(NSXMLParser *responsObject, NSError *error) {
            NSXMLParser *parserOfversions = responsObject;
            NSError *err = nil;
            NSDictionary *dicOfSlam = [[XMLDictionaryParser sharedInstance]dictionaryWithParser:parserOfversions];
//           NSLog(@"uppppss-----%@ err=%@",dicOfSlam,err.debugDescription);
            if (err==nil) {
                [DataManager shareDataManager].lastNavigationVersion = [NSString stringWithFormat:@"%@",[dicOfSlam objectForKey:@"version"]];
                [DataManager shareDataManager].fileMD5OfSmal = [NSString stringWithFormat:@"%@",[dicOfSlam objectForKey:@"md5"]];
                [DataManager shareDataManager].fileMuvOfSmal = [NSString stringWithFormat:@"%@",[dicOfSlam objectForKey:@"muv"]];
                [DataManager shareDataManager].fileMsgOfSmal = [NSString stringWithFormat:@"%@",[dicOfSlam objectForKey:@"msg"]];
      
            }
           
        }];
        [[ToolOfNetWork sharedTools]YrequestXmlURL:ctrlStr withParams:parm finished:^(NSXMLParser *responsObject, NSError *error) {
            NSXMLParser *parserOfversionc = responsObject;
            NSError *err = nil;
            NSDictionary *dicOfCtrl = [[XMLDictionaryParser sharedInstance]dictionaryWithParser:parserOfversionc];
//            NSLog(@"uppppsc-----%@ err=%@",dicOfCtrl,err.debugDescription);
            if (err==nil) {
                DataManager.shareDataManager.lastFriewareVersion = [NSString stringWithFormat:@"%@",[dicOfCtrl objectForKey:@"version"]];
               [DataManager shareDataManager].fileMD5OfCtrl = [NSString stringWithFormat:@"%@",[dicOfCtrl objectForKey:@"md5"]];
               [DataManager shareDataManager].fileMuvOfCtrl = [NSString stringWithFormat:@"%@",[dicOfCtrl objectForKey:@"muv"]];
               [DataManager shareDataManager].fileMsgOfCtrl = [NSString stringWithFormat:@"%@",[dicOfCtrl objectForKey:@"msg"]];
               
            }
        }];
 
}

#pragma mark -- xml解析部分协议 暂时未使用
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    _versionInfoXmlStr = string;
  
    NSLog(@"_versionInfoXmlStr=%@=%@",parser,_versionInfoXmlStr);

}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    
    NSString *trimmedString = [_versionInfoXmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //将字符串置空
    _versionInfoXmlStr = @"";
    if ([elementName isEqualToString:@"version"]) {
        
        DataManager.shareDataManager.lastNavigationVersion = trimmedString;
        NSLog(@"版本=%@",DataManager.shareDataManager.lastNavigationVersion);
        
        }else if ([elementName isEqualToString:@"code"]){
 
        }else if ([elementName isEqualToString:@"muv"]){
 
        }else if ([elementName isEqualToString:@"name"]){
 
        }else if ([elementName isEqualToString:@"url"]){
             
        }else if ([elementName isEqualToString:@"md5"]){
            DataManager.shareDataManager.fileMD5OfSmal = trimmedString;
            
        }else{
 
        }
    
    NSLog(@"_________________________________elementName=%@ trimmedString==%@",elementName,trimmedString);
    if (DataManager.shareDataManager.fileMD5OfSmal.length>0&&DataManager.shareDataManager.fileMD5OfCtrl.length>0) {
         [[ToolOfNetWork sharedTools]endXml];
    }

}


#pragma mark -- loginXmpp

- (void)initLoginXmpp{
    
    XmppManager.shareXmppManager.delegates = self;
    /* */
    NSString *userName = [ShareUser sharedUserInfo].userMode.userName;
    NSString *passWord = [ShareUser sharedUserInfo].userMode.passWord;
    NSLog(@"initLoginXmpp %@%@",[ShareUser sharedUserInfo].userMode.userName,passWord);
    
    [[XmppManager shareXmppManager]loginXmpp:userName password:passWord pre:^(BOOL finish) {
        
        [self.addCollectionView.mj_header endRefreshing];
        if (finish) {
            NSLog(@"xmpp登录成功");
            _isSuccessLoginXmpp = YES;
           
        }else{
            NSLog(@"xmpp登录失败");
            [self.view makeToast:NSLocalizedString(@"xmpp登录失败", nil)  duration:2 position:@"center"];
            _isSuccessLoginXmpp = NO;
        }
    }];
    
    
    
}

#pragma mark -- receiveXmppMessageWithMessage

- (void)receiveXmppUserStatusWithMessage:(NSString *)message{
 
    if ([message isEqualToString:@"用户登录成功"]) {
        _isSuccessLoginXmpp = YES;
    }
}

- (void)receiveXmppMessageWithMessage:(NSString *)message{
    if ([message isEqualToString:@"request_connect ok"]) {
        
//        _isSuccessGetOK = YES;//0110
    }
    _isSuccessGetOK = YES;//只要得到数据就判断为yes
    NSLog(@"跳转时接收到的数据===%@",message);
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_arrOfMachine.count==0) {
        return 1;
    }else{
        return _arrOfMachine.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddNewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddNewCollectionViewCell" forIndexPath:indexPath];
    
    cell.nameL.text = @"";
    if (_arrOfMachine.count==0) {
        if (indexPath.row==0) {
           
            cell.nameL.text = NSLocalizedString(@"您目前没有可供使用的机器人", nil) ;
            cell.deletBtn.hidden = YES;
            cell.img.hidden = NO;
            cell.img.image = [UIImage imageNamed:[DataManager shareDataManager].homeCellImgNameStr];//更新cell图标
        }else{
            //arr数据为0 但是index.row非0的cell显示问题 这是个显示问题 （有可能是在请求过程中刷新）
            cell.nameL.text = @"";
            cell.deletBtn.hidden = YES;
            cell.img.hidden = YES;
        }

        
    }else{
        MachineModel *model = [MachineModel objectWithKeyValues:_arrOfMachine[indexPath.row]];
        
        cell.nameL.text = model.nickName;
        cell.deletBtn.hidden = YES;
        cell.img.hidden = NO;
        cell.img.image = [UIImage imageNamed:[DataManager shareDataManager].homeCellImgNameStr];
        
        
    }
    cell.nameL.lineBreakMode = NSLineBreakByCharWrapping; //中英文不换行

   //初始化时调用过tool使其初始化
 
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_arrOfMachine.count == 1) {
//        return CGSizeMake(Y_mainW/2, 160);
         return CGSizeMake(Y_mainW*0.6, Y_mainW*0.6);
    }else if(_arrOfMachine.count == 0){
//         return CGSizeMake(Y_mainW/2, 160);
           return CGSizeMake(Y_mainW*0.6, Y_mainW*0.6);
    }else {
        if (Y_mainW<=375) {
          return CGSizeMake(110, 150);
        }else{
          return CGSizeMake(120, 160);
        }
    }
     
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

#pragma mark -- didSelect 点击扫地机
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelect=%ld",(long)indexPath.row);
    if (_arrOfMachine.count==0) {
//空数据时，点击无效
        return;
    }
    if (_isSuccessLoginXmpp == NO) {
        [self.view makeToast:NSLocalizedString(@"用户连接失败", nil)  duration:1 position:@"center"];
        [self initLoginXmpp];
        return;
    }
    
    if (_arrOfMachine.count<=indexPath.row) {
        //数据错误，不可获取点击数据
         [self.view makeToast:NSLocalizedString(@"请刷新后再试", nil)  duration:1 position:@"center"];
        return;
    }
    MachineModel *model = [MachineModel objectWithKeyValues:_arrOfMachine[indexPath.row]];
    
    [self goMapWithChangeJid:model.eqOpfJid];
}

#pragma mark --  goMap
- (void)goMapWithChangeJid:(NSString *)robotJid{
    
    if (robotJid.length==0) {
        return;
    }
    [ShareUser sharedUserInfo].userMode.nowRobotJid = robotJid;
    if( [_didSeltTimer isValid] )
    {
        [_didSeltTimer invalidate];
        _didSeltTimer = nil;
    }
 
    _isSuccessGetOK = NO;

    MBProgressHUD *hud = [MBProgressHUD showMessage:NSLocalizedString(@"等待机器人连接", nil) ];
    hud.userInteractionEnabled = NO;
    
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_connect"];
    [self searchOK];
    _didSeltTimerNum = 0;
    if(_didSeltTimer == nil){
        _didSeltTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0f target:self selector: @selector(didSeltTimerMethod:) userInfo: nil repeats: YES];
    }
 
}
- (void)didSeltTimerMethod:(NSTimer *)timer{
    
//    if (_didSeltTimerNum >= 10) {//超时停掉
     if (_didSeltTimerNum >= 6) {//超时停掉 0213改
        [MBProgressHUD hideHUD];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something..
            dispatch_async(dispatch_get_main_queue(),^{
                [MBProgressHUD hideHUD];
            });
        });
        [_didSeltTimer invalidate];
        _didSeltTimer = nil;
        [self.view makeToast:NSLocalizedString(@"连接机器人失败,请稍后重试", nil)  duration:1.0 position:@"bottom"];//弹出超时相关提醒
    }else{
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_connect"];
        //                [self.view makeToast:@"等待通信连接" duration:1.0 position:@"center"];
        _didSeltTimerNum+=1;
        [self searchOK];
    }
}
- (void)searchOK{
    
    if (!_isSuccessLoginXmpp) {
         [self.view makeToast:NSLocalizedString(@"用户离线", nil) duration:2 position:@"center"];
        [self initLoginXmpp];
//        [self.didSeltTimer invalidate];
//        [self.didSeltTimer setFireDate:[NSDate distantFuture]];
//        self.didSeltTimer = nil;
    }
    NSString *statusS = @"unavailable";
    NSArray *arrF = [UserTool sharedUserTool].friendsArr;
    for (int i = 0; i < arrF.count; i++) {
        if ([[arrF[i] objectForKey:kFriendNameKey] isEqualToString:[ShareUser sharedUserInfo].userMode.nowRobotJid]) {
            statusS = [arrF[i] objectForKey:kFriendStatusObj];
        }
    }
    if ([statusS isEqualToString:@"unavailable"]) {
 //非在线状态 有可能是非好友以至于没有该状态的返回 做添加好友操作
        [[XmppManager shareXmppManager]addFriendActionWithFriendName:[ShareUser sharedUserInfo].userMode.nowRobotJid];
//        [self.didSeltTimer invalidate];
//        [self.didSeltTimer setFireDate:[NSDate distantFuture]];
//        self.didSeltTimer = nil;
    }
    
    if (_isSuccessGetOK) {
        _isSuccessGetOK = NO;
        MapVC *mapVC = [[MapVC alloc]init];
        mapVC.statuStr = statusS;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something..
            dispatch_async(dispatch_get_main_queue(),^{
                [MBProgressHUD hideHUD];
            });
        });
        
        //用于扫地机设备设置页的数据
        DataManager.shareDataManager.robotWifiSsid = @"";
        DataManager.shareDataManager.robotWifiMac = @"";
        DataManager.shareDataManager.robotWifiIP = @"";
        DataManager.shareDataManager.robotLanguage = @"";
        DataManager.shareDataManager.mapImgBeforeData = nil;
        //升级相关版本数据清空
        DataManager.shareDataManager.lastNavigationVersion = @"--";
        DataManager.shareDataManager.fileMD5OfSmal = @"";
        DataManager.shareDataManager.fileMuvOfSmal = @"--";
        DataManager.shareDataManager.fileMsgOfSmal = @"";
        DataManager.shareDataManager.lastFriewareVersion = @"--";
        DataManager.shareDataManager.fileMD5OfCtrl = @"";
        DataManager.shareDataManager.fileMuvOfCtrl = @"--";
        DataManager.shareDataManager.fileMsgOfCtrl = @"";
        //清空以前的img原始数据
        DataManager.shareDataManager.trajectorySourceArr = @[].mutableCopy;
        DataManager.shareDataManager.trajectoryNum = 0;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.didSeltTimer invalidate];
    [self.didSeltTimer setFireDate:[NSDate distantFuture]];
    self.didSeltTimer = nil;
    
}



#pragma mark --lonePressMoving
- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            {
                if (_arrOfMachine.count == 0) {
                    NSLog(@"长按了0");//数据空时
                    return;
                }
                //去掉浮动的弹出框
                //防止mbp还在转的情况
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    // Do something..
                    dispatch_async(dispatch_get_main_queue(),^{
                        [MBProgressHUD hideHUD];
                    });
                });
                
                //
                NSIndexPath *selectIndexPath = [self.addCollectionView indexPathForItemAtPoint:[longPress locationInView:self.addCollectionView]];
                // 找到当前的cell
                AddNewCollectionViewCell *cell = (AddNewCollectionViewCell *)[self.addCollectionView cellForItemAtIndexPath:selectIndexPath];
                cell.deletBtn.tag = TAG_BTN + selectIndexPath.item;
                NSLog(@"cell = i~%d",selectIndexPath.item);
                cell.deletBtn.hidden = NO;
               
                //减少性能损耗
                cell.img.layer.shouldRasterize = YES;
                cell.img.layer.rasterizationScale = [UIScreen mainScreen].scale;
                //添加删除的点击事件
                [cell.deletBtn addTarget:self action:@selector(btnDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
                
                NSLog(@"长按了%@----%ld",selectIndexPath,(long)selectIndexPath.item);

                //其他按钮
                for(int i = 0; i < _arrOfMachine.count;i++){
                     AddNewCollectionViewCell *cell2 = (AddNewCollectionViewCell *)[self.addCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];//只有0组 irow
                    cell2.deletBtn.tag = TAG_BTN + i;
                   
                    if (cell2.deletBtn.tag != cell.deletBtn.tag) {
                        cell2.deletBtn.hidden = YES;
                     }else{
                         cell2.deletBtn.hidden = NO;
                     }
                }
                
            }
            break;

            
        default:
            break;
            }
    }

}

#pragma mark -- DeleteAction
- (void)btnDeleteAction:(UIButton*)sender{
    NSLog(@"删除一个");
    NSInteger item = sender.tag-TAG_BTN;
    NSLog(@"删除%ld",(long)item);
    Y_WEAKSELF
    if(_arrOfMachine.count<=item){
        [self.view makeToast: NSLocalizedString(@"解绑失败,请刷新后再试", nil)  duration:2 position:@"center"];
        return;
        
    }
    MachineModel *model = [MachineModel objectWithKeyValues:_arrOfMachine[item]];
    NSString *messageStr = [NSString stringWithFormat:@"%@ %@",model.nickName,NSLocalizedString(@"将会解除绑定", nil)];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",nil) message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [_addCollectionView reloadData];
    }];

    UIAlertAction *yesAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"解绑",nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deletOneRobot:sender];
    }];
    
    [alertVc addAction:cancelAc];
    [alertVc addAction:yesAc];
    alertVc.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)deletOneRobot:(UIButton *)sender{
    [MBProgressHUD hideHUD];//清除弹出框
    
    NSInteger item = sender.tag-TAG_BTN;
    NSLog(@"删除%ld",(long)item);
    [[ToolOfNetWork sharedTools]endXml];//endxml
  
    if (_arrOfMachine.count<=item) {
        [self.view makeToast:NSLocalizedString(@"解绑失败,请刷新后再试", nil)  duration:2 position:@"center"];
        return;
    }
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithObjectsAndKeys:[ShareUser sharedUserInfo].accountNum,@"userPhone", nil];
    MachineModel *machineModel = [MachineModel objectWithKeyValues:_arrOfMachine[item]];
    [parms setObject:[NSString stringWithFormat:@"%@",machineModel.eqHardwareSerial] forKey:@"eqHardwareSerial"];
    Y_WEAKSELF
    [[ToolOfNetWork sharedTools]YrequestDeleteURL:S_equipmentRemove withParams:parms    finished:^(id responsObject, NSError *error) {
        if (_Success) {
            //     [_addCollectionView.refreshControl beginRefreshing];
            //删除xmpp好友关系
            [[XmppManager shareXmppManager]deletFriendActionWithFriendName:machineModel.eqHardwareSerial];
            [weakSelf initData];
//            [weakSelf.addCollectionView reloadData];
        }else{
            NSString *msg = @"";
            if(msg.length==0){
                if (error.code == -1009) {
                    msg = NSLocalizedString(@"解绑失败,请查看网络是否可用", nil);
                }else{
                    msg = NSLocalizedString(@"解绑失败,请稍后再试", nil);
                }
                
            }
            if (msg.length==0) {
                msg = NSLocalizedString(@"解绑失败", nil);
            }
            if (_SuccessOrErrCode==400) {
                msg =  NSLocalizedString(@"用户名不能为空", nil);
            }else if (_SuccessOrErrCode==401){
                msg =  NSLocalizedString(@"扫地机编号不能为空", nil);
            }else if (_SuccessOrErrCode==402){
                msg =  NSLocalizedString(@"该编号扫地机不存在", nil);
            }else if (_SuccessOrErrCode==403){
                msg =  NSLocalizedString(@"用户不存在", nil);
            }else if (_SuccessOrErrCode==404){
                msg =  NSLocalizedString(@"解绑失败，请稍后重试", nil);
            }else{
                if (msg.length==0) {
                    msg =  NSLocalizedString(@"解绑失败，请稍后重试", nil);
                }
            }
            
            [weakSelf.view makeToast:msg duration:2 position:@"bottom"];
        }
    }];
}
#pragma mark -- leftItemAction

- (IBAction)leftItemAction:(UIBarButtonItem *)sender {
    //防止mbp还在转的情况
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        // Do something..
//        dispatch_async(dispatch_get_main_queue(),^{
//            [MBProgressHUD hideHUD];
//        });
//    });
//    //跳转
//    PersoncenterXViewController *personCenterVc = [[PersoncenterXViewController alloc]init];
//    [self.navigationController pushViewController:personCenterVc animated:YES];
    
    
   /*
    NSLog(@"删除全部");
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"您将删除全部扫地机" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"取消本次操作" style:UIAlertActionStyleCancel handler:nil];
     UIAlertAction *yesAc = [UIAlertAction actionWithTitle:@"删除全部" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         [self deletAllAction];
     }];
    
    [alertVc addAction:cancelAc];
    [alertVc addAction:yesAc];
 
    [self presentViewController:alertVc animated:YES completion:nil];
*/
    
}


- (void)deletAllAction{

    //    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithObjectsAndKeys:[ShareUser sharedUserInfo].accountNum,@"userPhone", nil];
    
    [[ToolOfNetWork sharedTools]YrequestDeleteURL:S_equipmentRemoveAll withParams:parms    finished:^(id responsObject, NSError *error) {
        NSString *msg = [responsObject objectForKey:@"msg"];
        if (msg.length==0) {
            msg = @"连接失败";
        }
        if (_Success) {
            
            NSArray *arrF = [UserTool sharedUserTool].friendsArr;
            for (int i = 0; i < arrF.count; i++) {
                NSString *jid =  [arrF[i] objectForKey:kFriendNameKey];
                [[XmppManager shareXmppManager]deletFriendActionWithFriendName:jid];
            }
            [self.view makeToast:@"删除成功" duration:2 position:@"center"];
            [self initData];

        }else{
            
            [self.view makeToast:msg duration:3 position:@"center"];
        }
    }];
}

#pragma mark -- FooterView

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
 
    if (kind == UICollectionElementKindSectionFooter)
    {
    
        AddNewFooterView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"AddNewFooterView" forIndexPath:indexPath];
        footerview.addFooterBtn.layer.cornerRadius = 5;
        footerview.addFooterBtn.layer.borderWidth = 2;
        footerview.addFooterBtn.layer.borderColor = [DataManager shareDataManager].colorOfMainType.CGColor;
        [footerview.addFooterBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        
        reusableView = footerview;
        
    }else{
        reusableView  = [UICollectionReusableView new];
    }
    
    return reusableView;
}
- (void)addAction:(UIButton *)sender{
 
       NSLog(@"添加按钮");
//    防止mbp还在转的情况
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something..
        dispatch_async(dispatch_get_main_queue(),^{
            [MBProgressHUD hideHUD];
        });
    });
////////    跳转搜索页
    //新1205ing
    AddTwoPlanChooseViewController *addTwoPalnChooseVc = [[AddTwoPlanChooseViewController alloc]init];
    [self.navigationController pushViewController:addTwoPalnChooseVc animated:YES];
    

   
}

#pragma mark -- 
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    _didSeltTimerNum = 10;//停止连接
  
}



@end
