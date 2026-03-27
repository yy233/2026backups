//
//  SetTimerViewController.m
//  扫地机闹钟多表联查
//
//  Created by Joey on 2018/4/16.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "SetTimerViewController.h"

#import "AppointmentWeekViewController.h"
#import "ListManager.h"
#import "TimmerModel.h"

#import "AppointmentChooseStrength.h"//view
#import "AppointmentChooseMode.h"//view
@interface SetTimerViewController ()<UITableViewDelegate,UITableViewDataSource,XmppManagerDelegate>

@property (nonatomic,strong) UIDatePicker *timerdatePicker;
@property (nonatomic,strong) UITableView *tableV;
@property (nonatomic,strong) UILabel *hourLabel;
@property (nonatomic,strong) UILabel *minuteLabel;

@property (nonatomic,strong) AppointmentChooseStrength *strengthChooseView;
@property (nonatomic,strong) AppointmentChooseMode *modeChooseView;

@property (nonatomic,strong) NSArray *arrOfSetTitleSource;

@property (nonatomic,strong) NSString *strOfMode;
@property (nonatomic,assign) int intOfModeNumInfo;
@property (nonatomic,strong) NSString *strOfStrong;
@property (nonatomic,assign) int intOfStrongNumInfo;
@property (nonatomic,strong) NSString *strOfWeekNumInfo;//8位
@property (nonatomic,strong) NSString *strOfWeek;//汉字

@property (nonatomic,strong) NSMutableArray *arrOfListSource;

@property (nonatomic,strong) NSString *strOfallSendStr;

@property (nonatomic,assign) BOOL robotIsOnLine;

//未收到返回数据时的定时
@property (nonatomic,assign) int timerGetMessageNum;
@property (nonatomic,strong) NSTimer *timerOfGetOKOrFailMessage;
@end

@implementation SetTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _strOfallSendStr = @"";
  
    _robotIsOnLine = YES;
    [self initData];
    [self initView];
    [self noticeAdd];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [XmppManager shareXmppManager].delegates = self;
}


- (void)initData{
    _arrOfSetTitleSource = [[NSArray alloc]initWithObjects:NSLocalizedString(@"清扫模式", nil) ,NSLocalizedString(@"清扫力度", nil) ,NSLocalizedString(@"重复规则", nil), nil];
    
    
    if (_isAddType) { //初始 赋值
       
        _strOfWeek = NSLocalizedString(@"单次",nil);
        _strOfWeekNumInfo = @"0 0 0 0 0 0 0 1";
//        _strOfMode = @"自动清扫";
        _strOfMode = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain.firstObject];
        
        _intOfModeNumInfo = 1;
        _strOfStrong=  NSLocalizedString(@"标准",nil);
        _intOfStrongNumInfo = 1;
    }else{
        _strOfWeek =  NSLocalizedString(@"单次",nil);//27-2  27后15 -2
        _strOfWeekNumInfo = @"0 0 0 0 0 0 0 1";
//        _strOfMode = @"自动清扫";
        _strOfMode = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain.firstObject];
        _intOfModeNumInfo = 1;
        _strOfStrong=  NSLocalizedString(@"标准",nil);
        _intOfStrongNumInfo = 1;
       
        [self getModel];
        [self getStrong];
        [self getWeek];

        //strOfTimerInfo 截取 赋值
    }
    [self getNewarrOfListSource];
    
}

- (void)getModel{
    NSString *strModleSub = [_strOfTimerInfo substringWithRange:NSMakeRange(6, 1)];
    switch ([strModleSub intValue]) {
        case 1:
//            _strOfMode = @"自动清扫";
            _strOfMode = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain.firstObject];
            _intOfModeNumInfo = 1;
            break;
        case 2:
//            _strOfMode = @"边角清扫";
            _strOfMode = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain[1]];
            _intOfModeNumInfo = 2;
            break;
        case 5:
            //4*4清扫 文本arr只有三个 用【2x】
            _strOfMode = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain[2]];
            _intOfModeNumInfo = 5;// int 5 模式
            break;
        default:
            
            break;
    }
}

- (void)getStrong{
    NSString *strStrongSub = [_strOfTimerInfo substringWithRange:NSMakeRange(8, 1)];
    switch ([strStrongSub intValue]) {
        case 1:
            _strOfStrong= NSLocalizedString(@"标准",nil);
            _intOfStrongNumInfo = 1;
            break;
        case 2:
            _strOfStrong= NSLocalizedString(@"静音",nil);
            _intOfStrongNumInfo = 2;
            break;
        case 3:
            _strOfStrong= NSLocalizedString(@"强力",nil);
            _intOfStrongNumInfo = 3;
            break;
            
        default:
            break;
            
    }

    
}
- (void)getWeek{
     _strOfWeekNumInfo = [_strOfTimerInfo substringWithRange:NSMakeRange(12, 15)];//8位可读位
    [self strOfweekInfo:_strOfWeekNumInfo];
 
}
#pragma mark -- initView
- (void)initView{
//    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItemAction:)];
//    self.navigationItem.rightBarButtonItem = saveItem;
    
    self.view.backgroundColor = [DataManager shareDataManager].colorOfGroupGrayBack;
    
    [self.view addSubview:self.timerdatePicker];//时间选择
    [self.view addSubview:self.tableV];
    [self.view addSubview:self.hourLabel];//时
    [self.view addSubview:self.minuteLabel];//分
    [_hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(15);
        make.height.offset(15);
        make.centerY.equalTo(self.timerdatePicker).offset(-5);
        make.centerX.equalTo(self.timerdatePicker).offset(-20);
    }];
    [_minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(15);
        make.height.offset(15);
        make.centerY.equalTo(self.hourLabel);
        make.centerX.equalTo(self.timerdatePicker).offset(+55);
    }];
    
    
}
#pragma mark -- noticeofWeek
//0-7改变
- (void)noticeAdd{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeOfWeekChangeAction:) name:@"noticeOfWeekChange" object:nil];//week
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeOfStrengthChangeAction:) name:@"noticeOfStrengthChange" object:nil];//力度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeOfModeChangeAction:) name:@"noticeOfModeChange" object:nil];//模式
    

}
#pragma mark -- noticeOfModeChangeAction
- (void)noticeOfModeChangeAction:(NSNotification *)notification{
    
    NSString*strOfnoticeMode = notification.object;
    if ([strOfnoticeMode isEqualToString:@"1"]) {
//        _strOfMode = @"规划清扫";//自动清扫
      _strOfMode = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain.firstObject];//展示的label变化
       _intOfModeNumInfo = 1;//存储的int值也要进行变化
    }
    if ([strOfnoticeMode isEqualToString:@"2"]) {
//        _strOfMode = @"沿边清扫";
        _strOfMode = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain[1]];
        _intOfModeNumInfo = 2;//存储的int值也要进行变化
    }
    
    if ([strOfnoticeMode isEqualToString:@"5"]) {
        // 4*4清扫
        _strOfMode = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain[2]];
        _intOfModeNumInfo = 5;//存储的int值也要进行变化
    }
    
    [self getNewarrOfListSource];
}
#pragma mark -- strength Change
- (void)noticeOfStrengthChangeAction:(NSNotification *)notification{
    _strOfStrong = notification.object;
    
    if ([_strOfStrong isEqualToString:NSLocalizedString(@"标准", nil) ]) {
        _intOfStrongNumInfo = 1;
    } else if ([_strOfStrong isEqualToString:NSLocalizedString(@"静音",nil)]) {
        _intOfStrongNumInfo = 2;
        
    }else if([_strOfStrong isEqualToString:NSLocalizedString(@"强力",nil)]){
        _intOfStrongNumInfo = 3;
    }else{
        _intOfStrongNumInfo = 1;
    }
    [self getNewarrOfListSource];
}

#pragma mark -- week change
- (void)noticeOfWeekChangeAction:(NSNotification *)notification{
    NSLog(@"%@",notification.object);
    NSString *strOfweekNum = notification.object;
    _strOfWeekNumInfo = notification.object;
   
    [self strOfweekInfo:strOfweekNum];
    
}


#pragma mark -- weekStr_str
- (void)strOfweekInfo:(NSString *)strOfweekNum{
    _strOfWeek = @"";
    NSArray *arrOfweekType = [strOfweekNum componentsSeparatedByString:@" "];
    for (int i = 0; i<arrOfweekType.count; i++) {
        int weekType = [arrOfweekType[i] intValue];
        if (weekType==1) {
            
            switch (i) {
                case 0:
                    
                    _strOfWeek = [NSString stringWithFormat:@"%@%@",_strOfWeek,NSLocalizedString(@"周一", nil)];
                    break;
                case 1:
                    
                    _strOfWeek = [NSString stringWithFormat:@"%@%@",_strOfWeek,NSLocalizedString(@"周二", nil)];
                    break;
                case 2:
                    
                    _strOfWeek = [NSString stringWithFormat:@"%@%@",_strOfWeek,NSLocalizedString(@"周三",nil)];
                    break;
                case 3:
                    
                    _strOfWeek = [NSString stringWithFormat:@"%@%@",_strOfWeek,NSLocalizedString(@"周四",nil)];
                    break;
                case 4:
                    
                    _strOfWeek = [NSString stringWithFormat:@"%@%@",_strOfWeek,NSLocalizedString(@"周五",nil)];
                    break;
                case 5:
                    
                    _strOfWeek = [NSString stringWithFormat:@"%@%@",_strOfWeek,NSLocalizedString(@"周六",nil)];
                    break;
                case 6:
                    
                    _strOfWeek = [NSString stringWithFormat:@"%@%@",_strOfWeek,NSLocalizedString(@"周日",nil)];
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    if (_strOfWeek.length<=0) {
        _strOfWeek = NSLocalizedString(@"单次", nil) ;
    }else if([_strOfWeek isEqualToString:NSLocalizedString(@"周一周二周三周四周五周六周日", nil)]){
        _strOfWeek = NSLocalizedString(@"每天", nil);
    }else if([_strOfWeek isEqualToString:NSLocalizedString(@"周一周二周三周四周五", nil)]){
        _strOfWeek = NSLocalizedString(@"工作日", nil);
    }if([_strOfWeek isEqualToString:NSLocalizedString(@"周六周日", nil)]){
        _strOfWeek = NSLocalizedString(@"周末", nil);
    }else{
    }
    //更新List
    [self getNewarrOfListSource];
}
#pragma mark -- ListSource text
- (void)getNewarrOfListSource{

    _arrOfListSource = [NSMutableArray arrayWithObjects:_strOfMode,_strOfStrong,_strOfWeek, nil];
    [self.tableV reloadData];
}

#pragma mark -- saveAction
- (void)saveItemAction:(UIBarButtonItem *)sender{
    [self doSave];

}
- (void)doSave{
    NSLog(@"保存");
    
    
    NSDate *date = _timerdatePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH mm"];
    NSString  *timeString = [dateFormatter stringFromDate:date];//time
    NSLog(@"保存timer=%@,weeknum=%@",timeString,_strOfWeekNumInfo);
    
    NSString *weekS = _strOfWeekNumInfo;//含空格有15-最后的单次状态的2位//week 存储不截取发送要截取
    NSLog(@"模式 力度 %d %d",_intOfModeNumInfo,_intOfStrongNumInfo);
    NSString *thrS = [NSString stringWithFormat:@"%d %d 1",_intOfModeNumInfo,_intOfStrongNumInfo]; //模式 力度 开关
    NSString *allStr = [NSString stringWithFormat:@"%@ %@ %@",timeString,thrS,weekS];
    _strOfallSendStr = allStr;
    NSLog(@"保存all=%@",allStr);
    [self sendXmpp];
    //sendxmpp
    
    //ok 之后 //save 本地
    
    //fail之后弹窗
}
#pragma mark -- sendXmpp
- (void)sendXmpp{
    NSString *strOfxmpp = [_strOfallSendStr substringWithRange:NSMakeRange(0, _strOfallSendStr.length-2)];//去掉后两位
    
    //xmpp
    //appointment_add  appointment_edit appointment_switch appointment_del
    //appointment_failed appointment_ok
    
    if (_isAddType) {
        strOfxmpp = [NSString stringWithFormat:@"appointment_add %@",strOfxmpp];
        [MBProgressHUD showMessage:NSLocalizedString(@"正在添加预约",nil)];
        
    }else{
        strOfxmpp = [NSString stringWithFormat:@"appointment_edit %@",strOfxmpp];
           [MBProgressHUD showMessage:NSLocalizedString(@"正在修改预约", nil) ];
    }
 
    [self addTimer];
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:strOfxmpp];
    
}

#pragma mark -- 协议

#pragma mark --  XmppMessage
//xmpp
//appointment_add  appointment_edit appointment_switch appointment_del
//appointment_failed appointment_ok
- (void)sendMessageSuccess{
//    [self.view makeToast:@"发送成功" duration:1.5 position:@"center"];
}
- (void)sendMessageFail{
  
    [MBProgressHUD hideHUD];
    [self.view makeToast:NSLocalizedString(@"发送失败", nil)  duration:1.5 position:@"center"];
    
    
}

- (void)receiveXmppMessageWithMessage:(NSString * _Nonnull)message{
  
//    if ([message isEqualToString:@"appointment_ok"]) {
    if ([message isEqualToString:@"appointment_res 1"]) {
        [MBProgressHUD hideHUD];
        [self deletTimer];
        [self isSucceedGetOk];
        
        
//    }else if ([message isEqualToString:@"appointment_failed"]){
    }else if ([message isEqualToString:@"appointment_res 0"]){
        [MBProgressHUD hideHUD];
        [self deletTimer];
        [self isGetFail];
       
    }else{
        _robotIsOnLine = YES;
    }
}
- (void)receiveXmppUserStatusWithMessage:(NSString * _Nonnull)message{
    if ([message isEqualToString:@"扫地机离线"]) {
        [MBProgressHUD hideHUD];
        _robotIsOnLine = NO;
        [self.view makeToast:NSLocalizedString(@"扫地机离线", nil)  duration:1.5 position:@"center"];
        
    }else if ([message isEqualToString:@"扫地机在线"]){
        _robotIsOnLine = YES;
    }else if ([message isEqualToString:@"用户离线"]){
        [MBProgressHUD hideHUD];
        [self.view makeToast:NSLocalizedString(@"用户离线",nil) duration:1.5 position:@"center"];
        
    }else if ([message isEqualToString:@"用户上线"]){
        [self.view makeToast:NSLocalizedString(@"用户上线",nil) duration:1.5 position:@"center"];
    }
}
#pragma mark -- xmpp协议ok success回调
- (void)isGetFail{
//    [self]//弹框
    [self.view makeToast:NSLocalizedString(@"预约失败", nil)  duration:1.5 position:@"center"];

}
- (void)isSucceedGetOk{
     [self saveOfThisRobot];
}
#pragma mark -- 本地存储
- (void)saveOfThisRobot{//一个修改一个新增
    
    TimmerModel *newTimerModel = [[TimmerModel alloc]init];
    newTimerModel.robotJid = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    newTimerModel.timerJsonStr = _strOfallSendStr;
    BOOL upBool = NO;
    if (_isAddType) {
        //添加
      upBool =  [ListManager addTimerWithModel:newTimerModel];
        
    }else{
        //替换
        TimmerModel *oldTimerModel = [[TimmerModel alloc]init];
        oldTimerModel.robotJid = [ShareUser sharedUserInfo].userMode.nowRobotJid;
        oldTimerModel.timerJsonStr = _strOfTimerInfo;   
        upBool= [ListManager changeTimerWithModel:oldTimerModel withNewModel:newTimerModel];
                 
    }
    
    if (upBool) {
        NSLog(@"up成功");
         [self.view makeToast:NSLocalizedString(@"预约成功", nil)  duration:1.5 position:@"center"];
        [self performSelector:@selector(pop) withObject:self afterDelay:1.5];
    }else{
        NSLog(@"up失败");
         [self.view makeToast:NSLocalizedString(@"预约失败", nil)  duration:1.5 position:@"center"];
    }
    
    
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrOfSetTitleSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    
//    [NSString stringWithFormat:@"%@",_arrOfSetTitleSource[indexPath.row]]
//    [NSString stringWithFormat:@"%@",_arrOfListSource[indexPath.row]]
    cell.textLabel.text = _arrOfSetTitleSource[indexPath.row];
    cell.detailTextLabel.text = _arrOfListSource[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.numberOfLines = 2;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //@"清扫模式",@"清扫力度",@"重复规则
    switch (indexPath.row) {
        case 0:
            [self showModelView];
            break;
        case 1:
            [self showStoundView];
            break;
        case 2:
            [self pushWeekVc];
            break;
            
        default:
            break;
    }
}
- (void)showModelView{
      [self.view addSubview: self.modeChooseView];
    /**
    NSLog(@"showModelView");
    UIAlertController *modeAlertController = [UIAlertController alertControllerWithTitle:@"清扫模式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *oneMode = [UIAlertAction actionWithTitle:@"自动清扫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _strOfMode = @"自动清扫";
        _intOfModeNumInfo = 1;
         [self getNewarrOfListSource];
    }];
    UIAlertAction *twoMode = [UIAlertAction actionWithTitle:@"边角清扫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _strOfMode = @"边角清扫";
        _intOfModeNumInfo = 2;
         [self getNewarrOfListSource];
    }];
 
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [modeAlertController addAction:oneMode];
    [modeAlertController addAction:twoMode];
//    [modeAlertController addAction:thrMode];
    [modeAlertController addAction:cancel];
    [self presentViewController:modeAlertController animated:YES completion:nil];
    
    */
}
- (void)showStoundView{
     NSLog(@"showStoundView");
    [self.view addSubview: self.strengthChooseView];
    
    /**
    UIAlertController *strongAlertController = [UIAlertController alertControllerWithTitle:@"清扫力度" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *oneS = [UIAlertAction actionWithTitle:@"标准" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _strOfStrong = @"标准";
        _intOfStrongNumInfo = 1;
        [self getNewarrOfListSource];
    }];
    UIAlertAction *twoS = [UIAlertAction actionWithTitle:@"静音" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _strOfStrong = @"静音";
        _intOfStrongNumInfo = 2;
        [self getNewarrOfListSource];
    }];
    UIAlertAction *thrS = [UIAlertAction actionWithTitle:@"强力" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _strOfStrong = @"强力";
        _intOfStrongNumInfo = 3;
        [self getNewarrOfListSource];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [strongAlertController addAction:oneS];
    [strongAlertController addAction:twoS];
    [strongAlertController addAction:thrS];
    [strongAlertController addAction:cancel];
    [self presentViewController:strongAlertController animated:YES completion:nil];
    
    */
}
- (void)pushWeekVc{
    
    AppointmentWeekViewController *weekVc = [[AppointmentWeekViewController alloc]init];
    weekVc.weekNumStr = _strOfWeekNumInfo;
    [self.navigationController pushViewController:weekVc animated:YES];
}
#pragma mark -- timmer定时40秒没收到就失败
- (void)addTimer{
    _timerGetMessageNum = 0;
    _timerOfGetOKOrFailMessage = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (_timerGetMessageNum==45) {
            [_timerOfGetOKOrFailMessage invalidate];
            _timerOfGetOKOrFailMessage = nil;
            _timerGetMessageNum = 0;
            //失败
            [MBProgressHUD hideHUD];
            [self isGetFail];
        }else{
            _timerGetMessageNum+=1;
        }
    }];
}

- (void)deletTimer{
    [_timerOfGetOKOrFailMessage invalidate];
    _timerOfGetOKOrFailMessage = nil;
    _timerGetMessageNum = 0;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_timerOfGetOKOrFailMessage) {
        [self deletTimer];
    }
}
#pragma mark -- getter

#pragma mark -- timerdatePicker

- (UIDatePicker *)timerdatePicker{
    if (!_timerdatePicker) {
        _timerdatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 84, Y_mainW, 200)];
        _timerdatePicker.backgroundColor = [UIColor whiteColor];
        _timerdatePicker.datePickerMode  = UIDatePickerModeTime;
        _timerdatePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        _timerdatePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];//24小时制;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat=@"HH:mm";
        if (_strOfTimerInfo.length>0) {
            NSString *thisTime = [_strOfTimerInfo substringToIndex:5];
            NSDate *date = [dateFormatter dateFromString:thisTime];//设置
            if (!thisTime) {
                date = [NSDate date];
            }
            [_timerdatePicker setDate:date];
        }else{
            [_timerdatePicker setDate:[NSDate date]];
        }
    }
    return _timerdatePicker;
}

#pragma mark --
#pragma mark -- footer
- (UIView *)footerViewOfTableV{
    UIView *footerBackv = [[UIView alloc]init];
    footerBackv.frame = CGRectMake(0, 0, Y_mainW, 200);
    UIButton *footerB = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerB addTarget:self action:@selector(footerBtnActionOfSave:) forControlEvents:UIControlEventTouchUpInside];
    footerB.backgroundColor = [DataManager shareDataManager].colorOfMainType;
    [footerB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerB setTitle:NSLocalizedString(@"确认", nil)  forState:UIControlStateNormal];
    footerB.layer.cornerRadius = 5;
    footerB.frame = CGRectMake(0, 0, Y_mainW*0.7, 40);
    footerB.center = footerBackv.center;
    [footerBackv addSubview:footerB];
    return footerBackv;
}
#pragma mark -- actionsave
- (void)footerBtnActionOfSave:(UIButton*)sender{
    //
    [self doSave];
}
#pragma mark -- tabv
- (UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc]init];
        _tableV.frame = CGRectMake(0, 285, Y_mainW, Y_mainH-200-64);
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.tableFooterView = [self footerViewOfTableV];
        _tableV.backgroundColor = [UIColor clearColor];
        
    }
    return _tableV;
}

- (UILabel *)hourLabel{
    if (!_hourLabel) {
        _hourLabel = [[UILabel alloc]init];
        _hourLabel.font = [UIFont systemFontOfSize:12];
        _hourLabel.textColor = [DataManager shareDataManager].colorOfMainType;
        _hourLabel.text = NSLocalizedString(@"时", nil) ;
    }
    return _hourLabel;
}

- (UILabel *)minuteLabel{
    if (!_minuteLabel) {
        _minuteLabel = [[UILabel alloc]init];
        _minuteLabel.font = [UIFont systemFontOfSize:12];
        _minuteLabel.textColor = [DataManager shareDataManager].colorOfMainType;
        _minuteLabel.text = NSLocalizedString(@"分", nil);
    
    }
    return _minuteLabel;
}

- (AppointmentChooseStrength *)strengthChooseView{
    if (!_strengthChooseView) {
        _strengthChooseView = [[[NSBundle mainBundle]loadNibNamed:@"AppointmentChooseStrength" owner:self options:nil]objectAtIndex:0];
        _strengthChooseView.frame = self.view.frame;
    }
    //show时的动画
    [UIView animateWithDuration:0.3 animations:^{
        _strengthChooseView.bottomConstraint.constant = 0;
        _strengthChooseView.backgroundColor = Y_RGBA(0, 0, 0, 0.3);
        [_strengthChooseView layoutIfNeeded];
    }];
    
    return _strengthChooseView;
   
}

- (AppointmentChooseMode *)modeChooseView{
    if (!_modeChooseView) {
        _modeChooseView =  [[[NSBundle mainBundle]loadNibNamed:@"AppointmentChooseMode" owner:self options:nil]objectAtIndex:0];
        _modeChooseView.frame = self.view.frame;
    }
    //show时的动画
    [UIView animateWithDuration:0.3 animations:^{
        _modeChooseView.bottomConstranit.constant = 0;
        _modeChooseView.backgroundColor = Y_RGBA(0, 0, 0, 0.3);
        [_modeChooseView layoutIfNeeded];
    }];
    
    return _modeChooseView;
}
@end
