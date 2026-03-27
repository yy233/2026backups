//
//  TimerListViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/4/16.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "AppointmentListViewController.h"

#import "AppointmentListTableViewCell.h"
#import "SetTimerViewController.h"
#import "TimmerModel.h"
#import "ListManager.h"

@interface AppointmentListViewController ()<UITableViewDelegate,UITableViewDataSource,XmppManagerDelegate>//JkYkNeedMessageAndUserStatusDelegate
@property (nonatomic,strong) UITableView *timerListTableView;
@property (nonatomic,strong) UILabel *labelOfNoListShow;

@property (nonatomic,strong) NSMutableArray *allListModel;//model
@property (nonatomic,strong) NSMutableArray *arrOfThisRobotTimer;//jstr
@property (nonatomic,assign) int offOrNoListNum;//闹钟开关变化的行
@property (nonatomic,assign) int deletListNum;//闹钟删除掉行

@property (nonatomic,assign) BOOL offOrNoSucceed;//闹钟开关变化成功
@property (nonatomic,assign) BOOL deletSucceed;//闹钟删除成功

@property (nonatomic,assign) BOOL offOrNoSendXmppSucceed;//闹钟开关变化成功
@property (nonatomic,assign) BOOL deletSendXmppSucceed;//闹钟删除成功


@property (nonatomic,assign) BOOL robotIsOnLine;//扫地机在线状态
@property (nonatomic,assign) BOOL userIsOnLine;//扫地机在线状态

//以上bool暂不用 仅使用typebool
@property (nonatomic,assign) BOOL isDeletType;
@property (nonatomic,assign) BOOL isOffOrNoType;

//未收到返回数据时的定时
@property (nonatomic,assign) int timerNum;
@property (nonatomic,strong) NSTimer *timerOfGetMessage;
//请求列表
@property (nonatomic,assign) int timerOfGetListNum;
@property (nonatomic,strong) NSTimer *timerOfGetGetListMessage;
@end

@implementation AppointmentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"AppointmentListViewController_viewDidLoad");
    self.title = NSLocalizedString(@"预约", nil) ;
    [self rightItemInit];
    self.view.backgroundColor = [DataManager shareDataManager].colorOfGroupGrayBack;
//    self.view.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:self.timerListTableView];
    [self.view addSubview:self.labelOfNoListShow];
    
    //
    NSString *statusS = @"unavailable";
   
    NSArray *arrF = [UserTool sharedUserTool].friendsArr;
    for (int i = 0; i < arrF.count; i++) {
        if ([[arrF[i] objectForKey:kFriendNameKey] isEqualToString:[ShareUser sharedUserInfo].userMode.nowRobotJid]) {
            statusS = [arrF[i] objectForKey:kFriendStatusObj];
        }
    }
    if ([statusS isEqualToString:@"unavailable"]) {
          _robotIsOnLine = NO;
    }else{
          _robotIsOnLine = YES;
    }
//       _robotIsOnLine = NO; 去掉这个不明的数据
    //扫地机在线查询
    
    [self initView];
    [self initData];
  
//    self.timerListTableView.estimatedRowHeight = 100;
    self.timerListTableView.rowHeight = UITableViewAutomaticDimension;
    if (_robotIsOnLine) {
        //在线时 获取当前扫地机的最新闹钟
        if (_arrOfThisRobotTimer.count==0) {

            [self noOneListSendXmpp];
        }else{

            TimmerModel *deletModel = _allListModel[_deletListNum];
            BOOL isDelet = [ListManager deleteTimerWithModel:deletModel];
            NSLog(@"isDelet %id",isDelet);
            [self noOneListSendXmpp];//若其他app更新了闹钟，那么该app也要有最新数据
        }

    }else{
        if (_arrOfThisRobotTimer.count==0) {
            
            [self noOneListSendXmpp];
        }else{
            
            TimmerModel *deletModel = _allListModel[_deletListNum];
            BOOL isDelet = [ListManager deleteTimerWithModel:deletModel];
            NSLog(@"isDelet %id",isDelet);
            [self noOneListSendXmpp];//若其他app更新了闹钟，那么该app也要有最新数据
        }
    }
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [XmppManager shareXmppManager].delegates = self;//1225改回xmpp协议 因为在预约相关界面跳转后会出现数据没有了的情况 协议delegates对应1个
    
       NSLog(@"AppointmentListViewController_viewWillAppear");
    //检测在线状态
    NSString *statusS = @"unavailable";
    NSArray *arrF = [UserTool sharedUserTool].friendsArr;
    for (int i = 0; i < arrF.count; i++) {
        if ([[arrF[i] objectForKey:kFriendNameKey] isEqualToString:[ShareUser sharedUserInfo].userMode.nowRobotJid]) {
            statusS = [arrF[i] objectForKey:kFriendStatusObj];
        }
    }
    if ([statusS isEqualToString:@"unavailable"]) {
        _robotIsOnLine = NO;
    }else{
        _robotIsOnLine = YES;
    }
    //刷新列表
    [self initData];

   
}
- (void)initData{
    [self getListData];
}
- (void)initView{
    
  
}
- (void)rightItemInit{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTimerOfThisRobot:)];
    //    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tianjia"] style:UIBarButtonItemStylePlain target:self action:@selector(addTimerOfThisRobot:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)addTimerOfThisRobot:(UIBarButtonItem *)sender{
    if (_allListModel.count==0) {
        if(_robotIsOnLine == YES){
            SetTimerViewController *setVc = [[SetTimerViewController alloc]init];
            setVc.isAddType = YES;
            [self.navigationController pushViewController:setVc animated:YES];
        }else{
            [self.view makeToast:NSLocalizedString(@"离线状态，暂不可预约", nil)  duration:1.5 position:@"center"];
        }
    }else{
        [self.view makeToast:NSLocalizedString(@"暂可添加一个预约" , nil) duration:1.5 position:@"center"];
    }
  
}

#pragma mark -- initData 获取本地存的数据

- (void)getListData{
//     [TimmerModel getUsingLKDBHelper];//初始化表
//    _arrOfThisRobotTimer = [NSMutableArray array];
    _arrOfThisRobotTimer = [[NSMutableArray alloc]init];
   _allListModel = [NSMutableArray arrayWithArray: [ListManager searchTimerWithRobot:[ShareUser sharedUserInfo].userMode.nowRobotJid]];//model
    NSLog(@"allList %@",_allListModel);
    for (int i = 0; i<_allListModel.count; i++) {
       TimmerModel *model = _allListModel[i];
        if (model.timerJsonStr.length>0||(model.timerJsonStr!=nil)) {
             [_arrOfThisRobotTimer addObject: model.timerJsonStr];
        }

    }
    NSLog(@"_arrOfThisRobotTimer 刷新 %@",_arrOfThisRobotTimer);
    [self.timerListTableView reloadData];//刷新
}

#pragma mark -- 存储的list没有数据时，请求是否有timer

- (void)noOneListSendXmpp{
//    if (!_robotIsOnLine) {
//        [self.view makeToast:@"扫地机不在线" duration:1.5 position:@"center"];
//        return;
//    }
    [MBProgressHUD showMessage:NSLocalizedString(@"正在请求预约信息", nil) ];
    [[XmppManager shareXmppManager] sendMessageToRobotWithMessage:@"appointment_list"];
    _timerOfGetListNum = 0;
    
    _timerOfGetGetListMessage = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(listTimerAction:) userInfo:nil repeats:YES];
    
}
- (void)listTimerAction:(NSTimer *)listTimer{
    if (_timerOfGetListNum==30) {
    
        [_timerOfGetGetListMessage invalidate];
        _timerOfGetGetListMessage = nil;
        [MBProgressHUD hideHUD];
        [self.view makeToast:NSLocalizedString(@"扫地机未回复预约信息", nil)  duration:1.5 position:@"center"];
    }else{
        _timerOfGetListNum+=1;
    }
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arrOfThisRobotTimer.count==0) {//空时的中心显示label
        _labelOfNoListShow.hidden = NO;
    }else{
        _labelOfNoListShow.hidden = YES;
    }
    return _arrOfThisRobotTimer.count;
 
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppointmentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointmentListTableViewCell"];
    if (!cell) {
        cell = [[AppointmentListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppointmentListTableViewCell"];
         cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }

    [cell.offAndOnSwitch addTarget:self action:@selector(switchOfIndex:) forControlEvents:UIControlEventTouchUpInside];
    cell.offAndOnSwitch.tag = indexPath.row+TAG_BTN_C;
    cell.strOfcell = _arrOfThisRobotTimer[indexPath.row];
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
//    }
//
//    cell.textLabel.text  = @"yy测试";
                                    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewH = [[UIView alloc]init];
    viewH.frame = CGRectMake(0, 0, Y_mainW, 20);
    viewH.backgroundColor = [UIColor clearColor];
    return viewH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_robotIsOnLine == YES) {
        SetTimerViewController *setVc = [[SetTimerViewController alloc]init];
        setVc.isAddType = NO;
        setVc.strOfTimerInfo = _arrOfThisRobotTimer[indexPath.row];//查找
        [self.navigationController pushViewController:setVc animated:YES];
    }else{
        [self.view makeToast:NSLocalizedString(@"扫地机离线，暂不可修改预约", nil)  duration:1.5 position:@"center"];
    }
    

    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;//删除闹钟 开关闹钟
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:NSLocalizedString(@"删除",nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        [self deletActionWithIndex:indexPath];
        
        
    }];
    
    return @[deleteAction];
    
}
#pragma mark -- 闹钟开关 xmpp
- (void)switchOfIndex:(UISwitch *)sender{
    int index = sender.tag-TAG_BTN_C;
    
    
    //判断在线否
    _offOrNoSucceed = NO;
    _offOrNoSendXmppSucceed = NO;
    if (!_robotIsOnLine || !_userIsOnLine) {
        [self showFailView];
        return;
    }
    
    _isOffOrNoType = YES;
    
    NSLog(@"switch index=%d",index);
    sender.selected = !sender.selected;
    //改变当前robot当前index所在的闹钟的开关量
    NSString *strOfOld = _arrOfThisRobotTimer[index];
    NSArray *arrOfOld = [strOfOld componentsSeparatedByString:@" "];
    
    NSMutableArray *arrOfNew = [NSMutableArray arrayWithArray:arrOfOld];
    NSString *switchStr = arrOfNew[4];
    [arrOfNew removeObjectAtIndex:4];
    if ([switchStr intValue]==1) {
        [arrOfNew insertObject:@"0" atIndex:4];//
    }else{
        [arrOfNew insertObject:@"1" atIndex:4];
    }
    //xmpp
    NSString *strOfsendXmpp = [NSString stringWithFormat:@"appointment_switch %@",arrOfNew[4]];
    [self sendxmppp:strOfsendXmpp];
 
    
}
#pragma mark -- 删除 xmpp
- (void)deletActionWithIndex:(NSIndexPath *)indexPath{
    
    //初始化
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"删除定时", nil)  message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deletSendxmlWithIndex:indexPath];//发送xmppdeletinfo
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:noAction];
    alert.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)deletSendxmlWithIndex:(NSIndexPath *)indexPath{
   
    //    NSString *strOfxmppSendDelet = [NSString stringWithFormat:@"appointment_del %@",_arrOfThisRobotTimer[indexPath.row]];
    NSString *strOfxmppSendDelet = [NSString stringWithFormat:@"appointment_del"];
    
    _deletSucceed = NO;
    _deletSendXmppSucceed = NO;
    _deletListNum = indexPath.row;
    if (!_robotIsOnLine || !_userIsOnLine) {
        [self showFailView];
        return;
    }
    _isDeletType = YES;
    _deletListNum = indexPath.row;
    [self sendxmppp:strOfxmppSendDelet];//发xmpp
    
}

#pragma mark --  [self sendxmppp];
- (void)sendxmppp:(NSString*)str{
    if (_isDeletType) {
        [MBProgressHUD showMessage:NSLocalizedString(@"正在删除预约", nil)];
    }
    
    if(_isOffOrNoType){
        [MBProgressHUD showMessage:NSLocalizedString(@"正在修改预约", nil)];
    }
    [self addTimerOfGetOkOrFail];
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:str];
    
}

#pragma mark --  XmppMessage 协议 换掉
//xmpp
//appointment_add  appointment_edit appointment_switch appointment_del
//appointment_failed appointment_ok
- (void)sendMessageSuccess{
 
}
- (void)sendMessageFail{
     [MBProgressHUD hideHUD];
    if (_isDeletType) {
         [self isGetFail];
        
    }
    if (_isOffOrNoType) {
        [self isGetFail];
        
    }
    
}
//- (void)receiveXmppJkYkMessageWithMessage:(NSString *)message{
- (void)receiveXmppMessageWithMessage:(NSString * _Nonnull)message{
    
//    if ([message isEqualToString:@"appointment_ok"]) {
    if ([message isEqualToString:@"appointment_res 1"]) {
        [MBProgressHUD hideHUD];
        _deletSendXmppSucceed = YES;
        _offOrNoSendXmppSucceed = YES;
        
        [self deletTimerOfGetOkOrFail];
        [self isGetOk];
//    }else if ([message isEqualToString:@"appointment_failed"]){
    }else if ([message isEqualToString:@"appointment_res 0"]){
         [MBProgressHUD hideHUD];
        _deletSendXmppSucceed = NO;
        _offOrNoSendXmppSucceed = NO;
        
        [self deletTimerOfGetOkOrFail];
        [self isGetFail];
    }else if ([[message componentsSeparatedByString:@" "].firstObject isEqualToString:@"appointment_info"]){
        [MBProgressHUD hideHUD];
        [_timerOfGetGetListMessage invalidate];
        _timerOfGetGetListMessage = nil;
        _timerOfGetListNum = 0;
        NSMutableArray *arrOflist = [NSMutableArray arrayWithArray: [message componentsSeparatedByString:@" "]];
        [arrOflist removeObjectAtIndex:0];
        NSString *listOfStr = [arrOflist componentsJoinedByString:@" "];
        if (listOfStr.length==25) {
            [self haveList:listOfStr];
        } else {
        
            if (listOfStr.length ==24&&[NSString stringWithFormat:@"%@",arrOflist.firstObject].length==1) {//时间格式问题
                NSMutableString *strInfo = [NSMutableString stringWithString:listOfStr];
                [strInfo insertString:@"0"atIndex:0];
                [self haveList:strInfo];
                
            }else if (listOfStr.length ==24&&[NSString stringWithFormat:@"%@",arrOflist[1]].length==1){
                NSMutableString *strInfo = [NSMutableString stringWithString:listOfStr];
                [strInfo insertString:@"0"atIndex:3];
                [self haveList:strInfo];
                
                
            }else if (listOfStr.length==23&&[NSString stringWithFormat:@"%@",arrOflist.firstObject].length==1&&[NSString stringWithFormat:@"%@",arrOflist[1]].length==1){
                NSMutableString *strInfo = [NSMutableString stringWithString:listOfStr];
                [strInfo insertString:@"0"atIndex:0];
                [strInfo insertString:@"0"atIndex:3];
                [self haveList:strInfo];
                
            }else{
                [MBProgressHUD hideHUD];
                
                [_timerOfGetGetListMessage invalidate];
                _timerOfGetGetListMessage = nil;
                _timerOfGetListNum = 0;
                //            [self notHaveList];
                [self.view makeToast:NSLocalizedString(@"预约数据有误，可添加", nil)  duration:1.5 position:@"center"];
                //时间格式问题
            }
            
           
        }
        
    }else if ([message isEqualToString:@"appointment_null"]){
        [MBProgressHUD hideHUD];
        [_timerOfGetGetListMessage invalidate];
        _timerOfGetGetListMessage = nil;
        _timerOfGetListNum = 0;
        [self notHaveList];
        
        
    }else{
        _robotIsOnLine = YES;
        _userIsOnLine = YES;
    }
}
//- (void)receiveXmppJkYkUserStatusWithMessage:(NSString *)message{
- (void)receiveXmppUserStatusWithMessage:(NSString * _Nonnull)message{
    if ([message isEqualToString:@"扫地机离线"]) {
         _robotIsOnLine = NO;
        [MBProgressHUD hideHUD];
        [self.view makeToast:NSLocalizedString(@"扫地机离线", nil)  duration:1.5 position:@"center"];
    }else if ([message isEqualToString:@"扫地机在线"]){
         _robotIsOnLine = YES;
    }else if([message isEqualToString:@"用户离线"]){
        [MBProgressHUD hideHUD];
        [self.view makeToast:NSLocalizedString(@"用户离线",nil) duration:1.5 position:@"center"];
         _userIsOnLine = NO;
    }else if([message isEqualToString:@"用户上线"]){
         _userIsOnLine = YES;
    }
}

#pragma mark -- xmpp获取list的数据有无
- (void)haveList:(NSString *)listStr{
    NSString *weekStr = [listStr substringFromIndex:listStr.length-13];
    NSLog(@"substringFromIndex==%@",weekStr);
    NSArray *arrOfweek = [weekStr componentsSeparatedByString:@" "];
    if ([arrOfweek containsObject:@"1"]) {
        listStr = [NSString stringWithFormat:@"%@ 0",listStr];
    }else{
        listStr = [NSString stringWithFormat:@"%@ 1",listStr];
    }
   //如果原本有数据则抹去
    if (_allListModel.count>0) {
        TimmerModel *deletModel = _allListModel.firstObject;
        BOOL isDelet = [ListManager deleteTimerWithModel:deletModel];
        NSLog(@"删除原有的预约数据");
    }

    //添加
    TimmerModel *model = [[TimmerModel alloc]init];
    model.robotJid = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    model.timerJsonStr = listStr;
    
    [ListManager addTimerWithModel:model];
    [self getListData];
    [self.timerListTableView reloadData];
    
//    [self.view makeToast:@"预约数据刷新成功" duration:1.5 position:@"center"];

}
- (void)notHaveList{
    [self.view makeToast:NSLocalizedString(@"暂无预约数据，可添加", nil)  duration:1.5 position:@"center"];
    UILabel *labelOfNodata = [[UILabel alloc]init];
    labelOfNodata.frame = CGRectMake(0, 0, Y_mainW, 40);
    labelOfNodata.center = self.view.center;
    labelOfNodata.tag = TAG_BTN_C;
    [self.view addSubview: labelOfNodata];
}

#pragma mark -- 开关与删除
#pragma mark --成功 save
- (void)isGetOk{

    if (_isDeletType) {
        [self doDeletSave];
        _isDeletType = NO;
    }
    if (_isOffOrNoType) {
            [self doOffOrNoSave];
        _isOffOrNoType = NO;
    }
    
    
}
- (void)doDeletSave{
    //save本地
    TimmerModel *deletModel = _allListModel[_deletListNum];
    BOOL isDelet = [ListManager deleteTimerWithModel:deletModel];
    if (isDelet) {
        NSLog(@"删除成功");
        _deletSucceed = YES;
        [self.view makeToast:NSLocalizedString(@"删除预约成功", nil)  duration:1.5 position:@"center"];
    }else{
        NSLog(@"删除失败");
        _deletSucceed = NO;
        [self.view makeToast:NSLocalizedString( @"删除预约失败", nil) duration:1.5 position:@"center"];
    }
    
    
    [self getListData];
    [self.timerListTableView reloadData];
}
- (void)doOffOrNoSave{
    
    NSLog(@"switch index=%d",_offOrNoListNum);
    
    //改变当前robot当前index所在的闹钟的开关量
    NSString *strOfOld = _arrOfThisRobotTimer[_offOrNoListNum];
    NSArray *arrOfOld = [strOfOld componentsSeparatedByString:@" "];
    
    NSString *strOfNew = @"";
    NSMutableArray *arrOfNew = [NSMutableArray arrayWithArray:arrOfOld];
    NSString *switchStr = arrOfNew[4];
    [arrOfNew removeObjectAtIndex:4];
    if ([switchStr intValue]==1) {
        [arrOfNew insertObject:@"0" atIndex:4];//
    }else{
        [arrOfNew insertObject:@"1" atIndex:4];
    }
    strOfNew = [arrOfNew componentsJoinedByString:@" "];
    NSLog(@"%@  ,%@",strOfOld,strOfNew);
    
    TimmerModel *newTimerModel = [[TimmerModel alloc]init];
    newTimerModel.robotJid = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    newTimerModel.timerJsonStr = strOfNew;
    
    
    TimmerModel *oldTimerModel = [[TimmerModel alloc]init];
    oldTimerModel.robotJid = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    oldTimerModel.timerJsonStr = strOfOld;
    
    
    BOOL upBool= [ListManager changeTimerWithModel:oldTimerModel withNewModel:newTimerModel];
    
    if (upBool) {
        NSLog(@"up成功");
        _offOrNoSucceed = YES;
        [self.view makeToast:NSLocalizedString(@"修改预约成功", nil)  duration:1.5 position:@"center"];
    }else{
        NSLog(@"up失败");
        _offOrNoSucceed = NO;
        [self.view makeToast:NSLocalizedString(@"修改预约失败", nil) duration:1.5 position:@"center"];
    }
    
    [self getListData];
    [self.timerListTableView reloadData];
}


#pragma mark -- 失败
- (void)isGetFail{
    if (_isDeletType) {
        _isDeletType = NO;
    }
    if (_isOffOrNoType) {
        _isOffOrNoType = NO;
    }
    [self showFailView];
}

- (void)showFailView{
    [self.view makeToast:NSLocalizedString(@"修改预约失败", nil)  duration:1.5 position:@"center"];
    [self getListData];
    [self.timerListTableView reloadData];
}

#pragma mark -- timmer定时40秒没收到就失败
- (void)addTimerOfGetOkOrFail{
    _timerNum = 0;
    _timerOfGetMessage = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getMsgTimerAction:) userInfo:nil repeats:YES];
}
    
- (void)getMsgTimerAction:(NSTimer *)getMsgTimer{
    if (_timerNum==40) {
    
        [_timerOfGetMessage invalidate];
        _timerOfGetMessage = nil;
        _timerNum = 0;
        
        //
        [MBProgressHUD hideHUD];
        [self isGetFail];
    }else{
        _timerNum+=1;
    }
}

- (void)deletTimerOfGetOkOrFail{
    [_timerOfGetMessage invalidate];
    _timerOfGetMessage = nil;
    _timerNum = 0;

}
 
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"AppointmentListViewController_viewWillAppear");
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     NSLog(@"AppointmentListViewController_viewWillAppear");
    if (_timerOfGetMessage) {
        [self deletTimerOfGetOkOrFail];
    }
    if (_timerOfGetGetListMessage) {
        [_timerOfGetGetListMessage invalidate];
        _timerOfGetGetListMessage = nil;
        _timerOfGetListNum = 0;
    }
}
#pragma mark -- getter
- (UITableView *)timerListTableView{
    if (!_timerListTableView) {
        _timerListTableView = [[UITableView alloc]init];
        _timerListTableView.frame = self.view.frame;
        _timerListTableView.delegate = self;
        _timerListTableView.dataSource = self;
        _timerListTableView.tableFooterView = [UIView new];
        _timerListTableView.backgroundColor = [UIColor clearColor];
       
    }
    return _timerListTableView;
}

- (UILabel *)labelOfNoListShow{
    if (!_labelOfNoListShow) {
        _labelOfNoListShow = [[UILabel alloc]init];
        _labelOfNoListShow.text = NSLocalizedString(@"目前没有预约\n可点击右上角添加", nil) ;
        _labelOfNoListShow.backgroundColor = [UIColor clearColor];
        _labelOfNoListShow.frame = CGRectMake(0, 0, Y_mainW, 50);
        _labelOfNoListShow.center = self.view.center;
        _labelOfNoListShow.textAlignment = NSTextAlignmentCenter;
        _labelOfNoListShow.numberOfLines = 0;
        _labelOfNoListShow.hidden = YES;
    }
    return _labelOfNoListShow;
}


@end
