//
//  FirmwareUpdateDetailViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/5/10.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "FirmwareUpdateDetailViewController.h"
#import "DeBugViewController.h"
#import "SAndCLogListViewController.h"
//saml-导航板-软件
//Fireware-控制板-软件
@interface FirmwareUpdateDetailViewController ()<UITableViewDelegate,UITableViewDataSource,XmppManagerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITableView *firmwareUpdateTableV;
@property (nonatomic,strong) UIButton *footerBtn;
//导航版控制板
@property (nonatomic,strong) NSString *sendNumStrOfLastSlam;//发送用到的，空格分开的 最新版数字Str
@property (nonatomic,strong) NSString *sendNumStrOfLastFireware;

@property (nonatomic,strong) NSMutableArray *firmwareUpdateDataSourceOne;//软件smal 展示UI的数据
@property (nonatomic,strong) NSMutableArray *firmwareUpdateDataSourceTwo;//硬件F

//0111新增str串用于cell显示 不再分行。  [DataManager shareDataManager].fileMsgOfSmal|C
@property (nonatomic,strong) NSString *strOfSlamOfCellShow;//导航版
@property (nonatomic,strong) NSString *strOfFirewareOfCellShow;//控制板
@end

@implementation FirmwareUpdateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"固件更新",nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [XmppManager shareXmppManager].delegates = self;
    [self initWithLastVStr];
    [self initRightItem];//历史版本记录列表
    [self initData];
    [self initView];
}

#pragma mark -- barItem
- (void)initRightItem{
    UIImage *i = [[UIImage imageNamed:@"frimupgrade_menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItemOfLog = [[UIBarButtonItem alloc]initWithImage:i style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    self.navigationItem.rightBarButtonItem = rightItemOfLog;
}
- (void)rightItemAction:(UIBarButtonItem *)sender{
    SAndCLogListViewController *robotLogList = [[SAndCLogListViewController alloc]init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationController pushViewController:robotLogList animated:YES];
}
#pragma mark --

- (void)initWithLastVStr{//xml数字串 用于发送xmpp时的一截 init时就准备着
    
    
    if ((![[DataManager shareDataManager].lastNavigationVersion isEqualToString:@"--"]) || (![[DataManager shareDataManager].lastNavigationVersion isEqualToString:@""])) {
         NSString *lastS = [NSString stringWithFormat:@"%@",[[DataManager shareDataManager].lastNavigationVersion componentsSeparatedByString:@" "].lastObject];
         _sendNumStrOfLastSlam = [NSString stringWithFormat:@"%@",[lastS stringByReplacingOccurrencesOfString:@"." withString:@" "]];
        
    }
    if ((![[DataManager shareDataManager].lastFriewareVersion isEqualToString:@"--"])||(![[DataManager shareDataManager].lastFriewareVersion isEqualToString:@""])) {
        NSString *lastC = [NSString stringWithFormat:@"%@",[[DataManager shareDataManager].lastFriewareVersion componentsSeparatedByString:@" "].lastObject];
        
        _sendNumStrOfLastFireware = [NSString stringWithFormat:@"%@",[lastC stringByReplacingOccurrencesOfString:@"." withString:@" "]];
    }
   
    
    
}
- (void)initData{

//  数据界面ui
    if (_isCanUpOfSoftware) {//slam

        NSString *strOfmsgOfSlam = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].fileMsgOfSmal];
        
        if ([strOfmsgOfSlam containsString:@"\n"]) {
            strOfmsgOfSlam = [strOfmsgOfSlam stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
        
         NSArray *arrOfmsgSlam = [NSArray arrayWithArray:[strOfmsgOfSlam componentsSeparatedByString:@";"]];
        if ([strOfmsgOfSlam containsString:@";"]) {
            arrOfmsgSlam = [NSArray arrayWithArray:[strOfmsgOfSlam componentsSeparatedByString:@";"]];
        }else{
            arrOfmsgSlam = [NSArray arrayWithArray:[strOfmsgOfSlam componentsSeparatedByString:@"；"]];//中文分割符
        }
        
        //新增\n在一个cell中的换行显示
         _strOfSlamOfCellShow = @"";
        for (int i  = 0; i<arrOfmsgSlam.count; i++) {
            NSString *strOfNew = [NSString stringWithFormat:@"%@\n",arrOfmsgSlam[i]];
            if(![strOfNew isEqualToString:@" "]&&![strOfNew isEqualToString:@"\n"]){
                _strOfSlamOfCellShow = [NSString stringWithFormat:@"%@%@",_strOfSlamOfCellShow,strOfNew];
            }
        }
       //strok
        
         NSString *haveS = NSLocalizedString(@"软件系统有可更新的版本",nil);
        if (arrOfmsgSlam.count!=0) {
//            _strOfFireware = @"";
//            _strOfFireware = @"";
          _firmwareUpdateDataSourceOne = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@：%@",haveS,[DataManager shareDataManager].lastNavigationVersion ] ,nil];
        [_firmwareUpdateDataSourceOne addObjectsFromArray:arrOfmsgSlam];
            //0111
 
        }else{
          _firmwareUpdateDataSourceOne = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@：%@",haveS,[DataManager shareDataManager].lastNavigationVersion ] ,nil];
        }
        
    }else{
        NSString *nothaveS = NSLocalizedString(@"软件系统没有可更新的版本",nil);
         _firmwareUpdateDataSourceOne = [NSMutableArray arrayWithObjects:nothaveS, nil];
        NSLog(@"lastNavigationVersion=%@",[DataManager shareDataManager].lastNavigationVersion);
    }
    
    ////////////////_______________控制板
    if (_isCanUpOfhardware) {//ctrl
        NSString *strOfmsgOfCtrl = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].fileMsgOfCtrl];
        if ([strOfmsgOfCtrl containsString:@"\n"]) {
            strOfmsgOfCtrl = [strOfmsgOfCtrl stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
        NSArray *arrOfmsgCtrl = [NSArray arrayWithArray:[strOfmsgOfCtrl componentsSeparatedByString:@";"]];
        if ([strOfmsgOfCtrl containsString:@";"]) {
            arrOfmsgCtrl = [NSArray arrayWithArray:[strOfmsgOfCtrl componentsSeparatedByString:@";"]];
        }else{
            arrOfmsgCtrl = [NSArray arrayWithArray:[strOfmsgOfCtrl componentsSeparatedByString:@"；"]];//中文分割符
        }
        //新增\n在一个cell中的换行显示
        _strOfFirewareOfCellShow = @"";
        for (int i  = 0; i<arrOfmsgCtrl.count; i++) {
            NSString *strOfNew = [NSString stringWithFormat:@"%@\n",arrOfmsgCtrl[i]];
            if(![strOfNew isEqualToString:@" "]&&![strOfNew isEqualToString:@"\n"]){
                _strOfFirewareOfCellShow = [NSString stringWithFormat:@"%@%@",_strOfFirewareOfCellShow,strOfNew];
            }
            
        }
          //strok
        
         NSString *haveF = NSLocalizedString(@"硬件系统有可更新的版本", nil) ;
        if (arrOfmsgCtrl.count!=0) {
            _firmwareUpdateDataSourceTwo = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@：%@",haveF,[DataManager shareDataManager].lastFriewareVersion ] ,nil];
            [_firmwareUpdateDataSourceTwo addObjectsFromArray:arrOfmsgCtrl];
        }else{
            _firmwareUpdateDataSourceTwo = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@：%@",haveF,[DataManager shareDataManager].lastFriewareVersion ] ,nil];
        }
        
       
    }else{
        NSString *nohaveF = NSLocalizedString(@"硬件系统没有可更新的版本",nil);
        _firmwareUpdateDataSourceTwo = [NSMutableArray arrayWithObjects:nohaveF, nil];
        NSLog(@"lastFriewareVersion=%@",[DataManager shareDataManager].lastFriewareVersion);
    }
    
}
- (void)initView{
    //有则刷新无则添加
    self.firmwareUpdateTableV.estimatedRowHeight = 30;
    self.firmwareUpdateTableV.rowHeight = UITableViewAutomaticDimension;
    if ([self.view.subviews containsObject:self.firmwareUpdateTableV]) {
         //footer
        if (_isCanUpOfhardware||_isCanUpOfSoftware) {
            _footerBtn.userInteractionEnabled = YES;
            _footerBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
        }else{
            _footerBtn.userInteractionEnabled = NO;
            _footerBtn.backgroundColor = [UIColor grayColor];
        }
        [_firmwareUpdateTableV reloadData];
       
    }else{
        [self.view addSubview:self.firmwareUpdateTableV];
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receiveXmppMessageWithMessage:(NSString * _Nonnull)message{
  
    /**例如slam版本v2.0,控制本v2.0.0,小鸟版本:v2.0.0:about_device 2 0 2 0 0 2 0 0  */
    //frieware-控制板-硬件
    //slam-导航版-软件
 
    
    if ([[message componentsSeparatedByString:@" "].firstObject isEqualToString:@"about_device"]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[message componentsSeparatedByString:@" "]];
        
//        if (!(array.count==9 || array.count==6)) {
//            return;
//
//        }
        if (array.count<6) {//0107数据不更新问题
            return;
        }
        NSString *strOfcurNav = [NSString stringWithFormat:@"Nav %@ %@",array[1],array[2]];
        NSString *strOfcurFrie = [NSString stringWithFormat:@"Frie %@ %@ %@",array[3],array[4],array[5]];
        DataManager.shareDataManager.currentNavigationVersion = [NSString stringWithFormat:@"%@ %@",array[1],array[2]];
        DataManager.shareDataManager.currentFriewareVersion = [NSString stringWithFormat:@"%@ %@ %@",array[3],array[4],array[5]];
        
        
        //smal导航版
        BOOL canShengJiSlam = false;
        if([[DataManager shareDataManager].lastNavigationVersion isEqualToString: @"--"]||[[DataManager shareDataManager].lastNavigationVersion isEqualToString: @""]){
//            return;
        }else{
            NSArray *arrOfNV = [strOfcurNav componentsSeparatedByString:@" "];
            if (arrOfNV.count<=1) {
//                return;
            }else{
                NSMutableArray *arrOfmsgSlam = [NSMutableArray arrayWithArray:arrOfNV];
                canShengJiSlam = [ToolOfBasic lastxmlVersionBigThanCurrentRobotVersionWithMsgArr:arrOfmsgSlam saveXmlVersionStr:[DataManager shareDataManager].lastNavigationVersion];
                
            }
            
            
        }
       
        //控制板
        BOOL canShengJiCtrl = false;
        if([[DataManager shareDataManager].lastFriewareVersion isEqualToString: @"--"]||[[DataManager shareDataManager].lastFriewareVersion isEqualToString: @""]){
//            return;
        }else{
            NSArray *arrOfKZ = [strOfcurFrie componentsSeparatedByString:@" "];
            if (arrOfKZ.count<=1) {
//                return;
            }else{
                NSMutableArray *arrOfmsgCtrl = [NSMutableArray arrayWithArray:arrOfKZ];
                canShengJiCtrl = [ToolOfBasic lastxmlKZVersionBigThanCurrentRobotKZVersionWithMsgArr:arrOfmsgCtrl saveXmlKZVersionStr:[DataManager shareDataManager].lastFriewareVersion];
            }
            
           
        }
       
        
        //统计可升级的bool
        if((canShengJiSlam == true) && (canShengJiCtrl == true) ){//都要升级
            _isCanUpOfhardware = YES;
            _isCanUpOfSoftware = YES;
            
        }else{
            
            if(canShengJiSlam == true){
                _isCanUpOfSoftware = YES;
                _isCanUpOfhardware = NO;
            }
          
            if(canShengJiCtrl == true ){
                
                _isCanUpOfSoftware = NO;
                _isCanUpOfhardware = YES;
            }
        }
        
        //更新UI
        [self initData];
        [self initView];
    }
   
    
}

#pragma mark -- tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section==0) {
//        return _firmwareUpdateDataSourceOne.count;
//    }else{
//        return _firmwareUpdateDataSourceTwo.count;
//    }
        if (section==0) {
            if (_firmwareUpdateDataSourceOne.count>1) {
                return 2;
            }else{
                return 1;
            }
            
        }else{
            if (_firmwareUpdateDataSourceTwo.count>1) {
                return 2;
            }else{
                return 1;
            }
        }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.frame = CGRectMake(CGRectGetMinX(cell.textLabel.frame)+10, CGRectGetMinY(cell.textLabel.frame), CGRectGetWidth(cell.textLabel.frame)-20, CGRectGetHeight(cell.textLabel.frame));
  
//    if (indexPath.section==0) {
//        cell.textLabel.text = _firmwareUpdateDataSourceOne[indexPath.row];
//    }else{
//        cell.textLabel.text = _firmwareUpdateDataSourceTwo[indexPath.row];
//    }
    if (indexPath.section==0) {
        if (indexPath.row==0) {
             cell.textLabel.text = _firmwareUpdateDataSourceOne[indexPath.row];
        }else{
//             cell.textLabel.text = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].fileMsgOfSmal];
            cell.textLabel.text  = _strOfSlamOfCellShow;
        }
       
    }else{
        if (indexPath.row==0) {
            cell.textLabel.text = _firmwareUpdateDataSourceTwo[indexPath.row];
        }else{
//            cell.textLabel.text = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].fileMsgOfCtrl];
             cell.textLabel.text  = _strOfFirewareOfCellShow;
        }
    }
    //第一行为黑色
    if (indexPath.row==0) {
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }else{
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
//    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bacV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    bacV.backgroundColor = [UIColor whiteColor];
    
    UILabel *sectionHeaderL = [[UILabel alloc]init];
    sectionHeaderL.backgroundColor = [DataManager shareDataManager].colorOfGrayBack;
    sectionHeaderL.layer.cornerRadius = 5;
    sectionHeaderL.layer.masksToBounds = YES;
    sectionHeaderL.font = [UIFont systemFontOfSize:16];
    sectionHeaderL.frame = CGRectMake(20, 10, tableView.frame.size.width-40, 40);
    
    if (section==0) {
        
        NSString *strOfCurNav = [[DataManager shareDataManager].currentNavigationVersion stringByReplacingOccurrencesOfString:@" " withString:@"."];
        NSString *strIsBeta = @"";
        //
        if ([[strOfCurNav componentsSeparatedByString:@"."].firstObject isEqualToString:@"4"]) {
            strIsBeta = @" (beta)";//测试用语
        }else{
            strIsBeta = @"";
        }
       strIsBeta = @"";//正式版
        NSString *nowS = NSLocalizedString(@"当前软件系统版本", nil) ;
        sectionHeaderL.text = [NSString stringWithFormat:@"%@：%@%@",nowS,strOfCurNav,strIsBeta];
        UITapGestureRecognizer* tapGes =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesActToDeBug:)];
        //几次点击时触发事件 ,默认值为1
        tapGes.delegate = self;
        tapGes.numberOfTapsRequired = 7;
        //表示几个手指点击时 触发事件，默认值为1
        tapGes.numberOfTouchesRequired = 1;
        //将点击事件添加到视图中，视图即 响应事件
        [sectionHeaderL addGestureRecognizer:tapGes];
         NSLog(@"%@",[NSString stringWithFormat:@"当前软件系统版本：%@",[DataManager shareDataManager].currentNavigationVersion]);
        sectionHeaderL.userInteractionEnabled = YES;
        sectionHeaderL.superview.userInteractionEnabled = YES;//本视图和父视图都要可交互，手势才会响应
        
    }else{
        
        NSString *strOfCurF = [[DataManager shareDataManager].currentFriewareVersion stringByReplacingOccurrencesOfString:@" " withString:@"."];
        NSString *strIsBeta = @"";
        //这是测试版的显示
        if ([[strOfCurF componentsSeparatedByString:@"."].firstObject isEqualToString:@"2"]) {
            strIsBeta = @" (beta)";
        }else{
            strIsBeta = @"";
        }
        strIsBeta = @"";//正式版
        NSString *nowF = NSLocalizedString(@"当前硬件系统版本", nil);
        sectionHeaderL.text = [NSString stringWithFormat:@"%@：%@%@",nowF,strOfCurF,strIsBeta];
        NSLog(@"%@",[NSString stringWithFormat:@"当前硬件系统版本：%@",[DataManager shareDataManager].currentFriewareVersion]);
    }
    
    
    //可更新 不可更新的label
    UIButton *btnOfHeaderRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOfHeaderRight.backgroundColor = [UIColor clearColor];
    [btnOfHeaderRight setTitleColor:[DataManager shareDataManager].colorOfMainType forState:UIControlStateNormal];
    btnOfHeaderRight.frame = CGRectMake(tableView.frame.size.width-110, 10, 90, 40);
    btnOfHeaderRight.titleLabel.font = [UIFont systemFontOfSize:14];
    if (section==0) {
        if (_isCanUpOfSoftware) {
            [btnOfHeaderRight setTitle:NSLocalizedString(@"可更新", nil)  forState:UIControlStateNormal];
        }else{
             [btnOfHeaderRight setTitle:NSLocalizedString(@"无更新", nil)  forState:UIControlStateNormal];
        }
    }else{//==1
        if (_isCanUpOfhardware) {
            [btnOfHeaderRight setTitle:NSLocalizedString(@"可更新", nil)  forState:UIControlStateNormal];
        }else{
            [btnOfHeaderRight setTitle:NSLocalizedString(@"无更新", nil)  forState:UIControlStateNormal];
        }
    }
    
    [bacV addSubview:sectionHeaderL];
    btnOfHeaderRight.hidden = YES;
//    [bacV addSubview:btnOfHeaderRight];//隐藏掉
    
    return bacV;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (UIView *)footerV{
    UIView *backV = [[UIView alloc]init];
    backV.frame = CGRectMake(0, 0, Y_mainW, 60);
    
    _footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _footerBtn.layer.cornerRadius = 5;
    _footerBtn.backgroundColor = [UIColor grayColor];
    [_footerBtn setTintColor:[UIColor whiteColor]];
    [_footerBtn setTitle:NSLocalizedString(@"更 新", nil)  forState:UIControlStateNormal];
    _footerBtn.frame = CGRectMake(50, 10, Y_mainW-100, 40);
    
    if (_isCanUpOfhardware||_isCanUpOfSoftware) {
        [_footerBtn addTarget:self action:@selector(footerBtnUpVersionAction:) forControlEvents:UIControlEventTouchUpInside];
        _footerBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
        
    }
    [backV addSubview:_footerBtn];
    return backV;
}

#pragma mark -- tapGesActToDeBug


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"ges_v%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {

        return NO;
    }
    return  YES;
    
}

- (void)tapGesActToDeBug:(UITapGestureRecognizer*)sendet{
     NSLog(@"tapGesActToDeBug");
    DeBugViewController *debugVc = [[DeBugViewController alloc]init];
    [self.navigationController pushViewController:debugVc animated:YES];
   
}

#pragma mark -- footerBtnAction
- (void)footerBtnUpVersionAction:(UIButton *)sender{
  
//    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"order_pause"];//升级前的停止指令
    if (_isCanUpOfSoftware==YES&&_isCanUpOfhardware==YES) {
        NSString *strOfSendSlamAndSendCtrl = [NSString stringWithFormat:@"upgrade_ctrl %@ %@ upgrade_slam %@ %@",_sendNumStrOfLastFireware ,[DataManager shareDataManager].fileMD5OfCtrl,_sendNumStrOfLastSlam,[DataManager shareDataManager].fileMD5OfSmal];
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:strOfSendSlamAndSendCtrl];
    }else{
        if (_isCanUpOfSoftware) {
             NSString *strOfSendSlam = [NSString stringWithFormat:@"upgrade_slam %@ %@",_sendNumStrOfLastSlam,[DataManager shareDataManager].fileMD5OfSmal];
            [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:strOfSendSlam];
        }
        
        if (_isCanUpOfhardware) {
             NSString *strOfSendCtrl = [NSString stringWithFormat:@"upgrade_ctrl %@ %@",_sendNumStrOfLastFireware,[DataManager shareDataManager].fileMD5OfCtrl];
            [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:strOfSendCtrl];
        }
    }
        UpViewController *upVc = [[UpViewController alloc]init];
        upVc.isCtrlUp = self.isCanUpOfhardware;//控制板
        upVc.isSlamUp = self.isCanUpOfSoftware;//导航版软件
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationController pushViewController:upVc animated:YES];
    

}
#pragma mark -- get

- (UITableView *)firmwareUpdateTableV{
    if (!_firmwareUpdateTableV) {
        
        _firmwareUpdateTableV = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _firmwareUpdateTableV.delegate = self;
        _firmwareUpdateTableV.dataSource = self;
        _firmwareUpdateTableV.backgroundColor = [UIColor whiteColor];
        _firmwareUpdateTableV.estimatedRowHeight = 30;
        _firmwareUpdateTableV.tableFooterView = [self footerV];
        _firmwareUpdateTableV.tableHeaderView = [UIView new];
        //11和10不适配的崩溃 去掉该代码
//        _firmwareUpdateTableV.estimatedRowHeight = 0.1;
//        _firmwareUpdateTableV.estimatedSectionHeaderHeight = 0.1;
//        _firmwareUpdateTableV.estimatedSectionFooterHeight = 0.1;
//        _firmwareUpdateTableV.sectionHeaderHeight = 0.01;
//        _firmwareUpdateTableV.sectionFooterHeight = 0.01;
        
        _firmwareUpdateTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _firmwareUpdateTableV;
}

@end
