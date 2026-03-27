//
//  SAndCLogListViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/12/26.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "SAndCLogListViewController.h"
#import "AppVersionDetailsTableViewController.h"

#define S_getNavigationList   @"navigationLogController/getNavigationList"
#define S_getControlList      @"controlLogController/getControlList"
@interface SAndCLogListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *arrOfSMessage;
@property (nonatomic,strong)NSMutableArray *arrOfCMessage;
@property (nonatomic,strong)UITableView *tableViewOfLog;

@property (nonatomic,strong) UIView *topBackView;
@property (nonatomic,strong) UIButton *topOneBtn;
@property (nonatomic,strong) UIButton *topTwoBtn;
@end

@implementation SAndCLogListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"机器人更新日志", nil);
    [self initView];
    
}
- (void)initView{
    [self.view addSubview:self.topBackView];
    [self.topBackView addSubview:self.topOneBtn];
    [self.topBackView addSubview:self.topTwoBtn];
    [self.view addSubview:self.tableViewOfLog];
    [self ysOfLogListVc];
    self.topOneBtn.selected = YES;
    self.topTwoBtn.selected = NO;
    
    _arrOfSMessage = [NSMutableArray array];
    _arrOfCMessage = [NSMutableArray array];
    [self initDataSorC:YES];
    [self initDataSorC:NO];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)initDataSorC:(BOOL)isgetS{
 
    NSString *strOfeqserizal = [MapVcGetUpXml getDeviceEqSerial];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"page",@"9999",@"limit",strOfeqserizal,@"eqSerial",nil];
    if (isgetS) {
        [[ToolOfNetWork sharedTools]YrequestGetURL:S_getNavigationList withParams:parm finished:^(id responsObject, NSError *error) {
            NSLog(@"%@",responsObject);
            _arrOfSMessage  = [NSMutableArray arrayWithArray:responsObject[@"list"]];
            [self getShowSArr:_arrOfSMessage];
            [_tableViewOfLog reloadData];
        }];
    } else {
        [[ToolOfNetWork sharedTools]YrequestGetURL:S_getControlList withParams:parm finished:^(id responsObject, NSError *error) {
            NSLog(@"%@",responsObject);
            _arrOfCMessage  = [NSMutableArray arrayWithArray:responsObject[@"list"]];
              [self getShowCArr:_arrOfCMessage];
             [_tableViewOfLog reloadData];
        }];
    }

}
// ctVersion ngVersion
- (void)getShowSArr:(NSMutableArray *)sarr{
    NSMutableArray *arrOfSList = [NSMutableArray arrayWithArray:sarr];
    
    //循环比较
    for ( int i= 0; i< sarr.count; i++) {
        //当前扫地机版本
        NSString *strOfCurMsgNav = [NSString stringWithFormat:@"Nav %@",[DataManager shareDataManager].currentNavigationVersion];
        NSMutableArray *arrOfmsgSlam = [NSMutableArray arrayWithArray:[strOfCurMsgNav componentsSeparatedByString:@" "]];//放在循环内是因为在toolbasic里数据会被删
          NSLog(@"%d arrOfmsgs=%@",i,arrOfmsgSlam);
        
        NSString *ngVersion  = [sarr[i] objectForKey:@"ngVersion"];
        BOOL isMoreMaxS = [ToolOfBasic lastxmlVersionBigThanCurrentRobotVersionWithMsgArr:arrOfmsgSlam saveXmlVersionStr:[NSString stringWithFormat:@"navxml %@",ngVersion]];//导航版 软件的版本比较
        if (isMoreMaxS) {//大于当前版 该信息删除
            [arrOfSList removeObjectAtIndex:i];
             NSLog(@"removeObjectAtIndex:i=%d  arrOfmsgs=%@",i,arrOfmsgSlam);
        }
         NSLog(@"%d  arrOfmsgs=%@",i,arrOfmsgSlam);
    }
    
    _arrOfSMessage = [NSMutableArray arrayWithArray:arrOfSList];
    
}
- (void)getShowCArr:(NSMutableArray *)carr{
    NSMutableArray *arrOfCList = [NSMutableArray arrayWithArray:carr];
   
    //循环比较
    for ( int j= 0; j< carr.count; j++) {
        //当前扫地机版本
        NSString *strOfCurMsgF= [NSString stringWithFormat:@"F %@",[DataManager shareDataManager].currentFriewareVersion];
        NSMutableArray *arrOfmsgC = [NSMutableArray arrayWithArray:[strOfCurMsgF componentsSeparatedByString:@" "]];
        
         NSLog(@"j=%d  arrOfmsgC=%@",j,arrOfmsgC);
        NSString *ctVersion  = [carr[j] objectForKey:@"ctVersion"];
        BOOL isMoreMaxC = [ToolOfBasic lastxmlKZVersionBigThanCurrentRobotKZVersionWithMsgArr:arrOfmsgC saveXmlKZVersionStr:[NSString stringWithFormat:@"fxml %@",ctVersion]];//控制板 硬件的版本比较
        if(isMoreMaxC){
            NSLog(@"removeObjectAtIndex:j=%d  arrOfmsgC=%@",j,arrOfmsgC);
            [arrOfCList removeObjectAtIndex:j];
        }
         NSLog(@":j=%d  arrOfmsgC=%@",j,arrOfmsgC);
    }
    _arrOfCMessage = [NSMutableArray arrayWithArray:arrOfCList];
}


- (void)ysOfLogListVc{
    [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).offset(0);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(Y_getRectNavAndStatusHight);
        make.height.offset(50);
    }];
    [_topOneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_topBackView.mas_width).multipliedBy(0.5);
        make.left.equalTo(_topBackView.mas_left);
        make.centerY.equalTo(_topBackView);
        make.height.offset(50);
    }];
    [_topTwoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_topBackView.mas_width).multipliedBy(0.5);
        make.right.equalTo(_topBackView.mas_right);
        make.centerY.equalTo(_topBackView);
        make.height.offset(50);
    }];
    [_tableViewOfLog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).offset(-20);
        make.centerX.equalTo(self.view);
        make.top.equalTo(_topBackView.mas_bottom).offset(2);
        make.bottom.equalTo(self.view.mas_bottom).offset(10);
    }];
}

#pragma mark -- topBtnAction
- (void)topBtnAction:(UIButton *)sender{
    if(sender.tag-TAG_BTN_C==1){//扫地机消息
        _topOneBtn.selected = YES;
        _topTwoBtn.selected = NO;
        _topOneBtn.backgroundColor = Y_RGB(130, 130, 130);
        _topTwoBtn.backgroundColor = [UIColor clearColor];
        _tableViewOfLog.contentOffset = CGPointMake(0, 0);
        
        NSLog(@"s消息");
        if (_arrOfSMessage.count==0) {
            [self initDataSorC:YES];
            [_tableViewOfLog reloadData];
        }else{
             [_tableViewOfLog reloadData];
        }
    }else{

        _topTwoBtn.selected = YES;
        _topOneBtn.selected = NO;
        _topTwoBtn.backgroundColor = Y_RGB(130, 130, 130);
        _topOneBtn.backgroundColor = [UIColor clearColor];
       _tableViewOfLog.contentOffset = CGPointMake(0, 0);
        NSLog(@"c消息");
        if (_arrOfCMessage.count==0) {
            [self initDataSorC:NO];
            [_tableViewOfLog reloadData];
        }else{
             [_tableViewOfLog reloadData];
        }
       
    }
}


#pragma mark --
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_topOneBtn.selected) {
        return _arrOfSMessage.count;
    }else{
        return _arrOfCMessage.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(!cell){
       cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    if (_topOneBtn.isSelected) {
         cell.textLabel.text = [_arrOfSMessage[indexPath.row] objectForKey:@"ngVersion"];
        cell.detailTextLabel.text = [_arrOfSMessage[indexPath.row] objectForKey:@"ngUpTime"];
    }else{//导航版 ngUpdateLog ngVersion 控制板 ctVersion  ctUpdateLog
         cell.textLabel.text = [_arrOfCMessage[indexPath.row] objectForKey:@"ctVersion"];
        cell.detailTextLabel.text = [_arrOfCMessage[indexPath.row] objectForKey:@"ctUpTime"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppVersionDetailsTableViewController *detailVc = [[AppVersionDetailsTableViewController alloc]init];
    if (_topOneBtn.isSelected) {//导航版 ngUpdateLog ngVersion
       
        detailVc.strOfVersionNum = [_arrOfSMessage[indexPath.row] objectForKey:@"ngVersion"];
        detailVc.strOfVersionDetail = [_arrOfSMessage[indexPath.row] objectForKey:@"ngUpdateLog"];
        detailVc.strOfVersionUpTime = [_arrOfSMessage[indexPath.row] objectForKey:@"ngUpTime"];
        detailVc.oneIsSorTwoIsC = 1;
    }else{//控制板 ctVersion  ctUpdateLog
        detailVc.strOfVersionNum = [_arrOfCMessage[indexPath.row] objectForKey:@"ctVersion"];
        detailVc.strOfVersionDetail = [_arrOfCMessage[indexPath.row] objectForKey:@"ctUpdateLog"];
        detailVc.strOfVersionUpTime = [_arrOfCMessage[indexPath.row] objectForKey:@"ctUpTime"];
        detailVc.oneIsSorTwoIsC = 2;
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationController pushViewController:detailVc animated:YES];
  
    
}




#pragma mark -- getter
- (UIView *)topBackView{
    if (!_topBackView) {
        _topBackView = [[UIView alloc]init];
    }
    return _topBackView;
}

- (UIButton *)topOneBtn{
    if (!_topOneBtn) {
        
        _topOneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topOneBtn setTitle:NSLocalizedString(@"机器人软件",nil) forState:UIControlStateNormal];
        [_topOneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_topOneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _topOneBtn.backgroundColor = Y_RGB(130, 130, 130);;
        [_topOneBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _topOneBtn.tag = TAG_BTN_C+1;
    }
    return _topOneBtn;
}
- (UIButton *)topTwoBtn{
    if (!_topTwoBtn) {
        _topTwoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topTwoBtn setTitle:NSLocalizedString(@"机器人硬件",nil) forState:UIControlStateNormal];
        [_topTwoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_topTwoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_topTwoBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _topTwoBtn.tag = TAG_BTN_C+2;
    }
    return _topTwoBtn;
}

- (UITableView *)tableViewOfLog{
    if (!_tableViewOfLog) {
        _tableViewOfLog = [[UITableView alloc]init];
        _tableViewOfLog.delegate = self;
        _tableViewOfLog.dataSource  = self;
        _tableViewOfLog.tableFooterView = [UIView new];
        
    }
    return _tableViewOfLog;
}
@end
