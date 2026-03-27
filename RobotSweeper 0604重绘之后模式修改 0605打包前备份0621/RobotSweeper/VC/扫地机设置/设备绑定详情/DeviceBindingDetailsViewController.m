//
//  DeviceBindingDetailsViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/5/10.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "DeviceBindingDetailsViewController.h"

@interface DeviceBindingDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSString *nickNmaeStr;

@property (nonatomic,strong) UILabel *headerL;
@property (nonatomic,strong) UITableView *tableViewOfDeviceBindingUserList;
@property (nonatomic,strong) NSMutableArray *arrOfUserList;

@end

@implementation DeviceBindingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"设备绑定详情", nil);
    self.view.backgroundColor = [DataManager shareDataManager].colorOfGrayBack;
    [self initData];
    [self initView];
}
- (void)initData{

    NSString *strOfRobotJid = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    NSString *nickNmae = @"";
    NSMutableArray *arrOflist = [NSMutableArray arrayWithArray: [UserTool sharedUserTool].listOfRobotsArr];
    for ( NSDictionary *dicOfRobot in arrOflist) {
        if ([[dicOfRobot objectForKey:@"eqOpfJid"]  isEqualToString:strOfRobotJid]) {
            nickNmae = [dicOfRobot objectForKey:@"nickName"];
        }
    }
    
    if([nickNmae isEqualToString: @""]||nickNmae==nil){
        nickNmae = NSLocalizedString(@"暂无昵称",nil);
    }
    _nickNmaeStr = nickNmae;
    _arrOfUserList = [NSMutableArray array];
    //
    [self getListOfService];
}
- (void)getListOfService{
    [MBProgressHUD showMessage:NSLocalizedString(@"正在请求绑定列表",nil)];
    //服务器
    NSString *eqh = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithObjectsAndKeys:eqh,@"eqHardwareSerial",nil];
    
    [[ToolOfNetWork sharedTools]YrequestGetURL:S_equipmentselectSweepUser withParams:parm finished:^(id responsObject, NSError *error) {
        [MBProgressHUD hideHUD];
//        NSString *msg = [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"msg"]];
       
//        if (msg.length>0) {
//            [self.view makeToast:msg duration:1 position:@"center"];
//        }
        if (_Success) {
            NSString *msg = NSLocalizedString(@"获取绑定列表成功",nil);
            _arrOfUserList = [NSMutableArray arrayWithArray: responsObject[@"list"]];
            [self.view makeToast:msg duration:3 position:@"center"];
            if (_tableViewOfDeviceBindingUserList) {
              [_tableViewOfDeviceBindingUserList reloadData];
            }
        }else{
            //失败
             NSString *msg = NSLocalizedString(@"获取绑定列表失败",nil);
        
            if (error.code == -1009) {
                msg = NSLocalizedString(@"网络请求失败，请查看网络是否可用", nil);
                
            }else{
                msg = NSLocalizedString(@"网络请求失败，请稍后再试", nil);
            }
            if(_SuccessOrErrCode==400){
                msg =  NSLocalizedString(@"机器人不存在",nil);
            }else if(_SuccessOrErrCode==401){
                msg = NSLocalizedString(@"没有绑定用户",nil);
            }
            [self.view makeToast:msg duration:2 position:@"bottom"];
            
//            _arrOfUserList = [NSMutableArray arrayWithObject:@{[ShareUser sharedUserInfo].userMode.userNameNoSuffix:@"userName"},@"ueCreateTime":@"201801010101cs"];
        }
        
    }];
    
}
- (void)initView{
    [self.view addSubview:self.headerL];
    [self.view addSubview:self.tableViewOfDeviceBindingUserList];
    [self getNewYuesu];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrOfUserList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[_arrOfUserList[indexPath.row] objectForKey:@"userName"]];
    
    if ([cell.textLabel.text isEqualToString:[ShareUser sharedUserInfo].userMode.userNameNoSuffix]) {
        cell.imageView.image = [[UIImage imageNamed:@"xuanzhong_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.imageView.tintColor = [DataManager shareDataManager].colorOfMainType;
    }else{
        cell.imageView.image = [[UIImage imageNamed:@"xuanzhong_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.imageView.tintColor = cell.textLabel.backgroundColor;//非绑定cell
    }
    NSString *strOfT = @"";
    NSDictionary*dic = [NSDictionary dictionaryWithDictionary:_arrOfUserList[indexPath.row]];
    if (![dic objectForKey:@"ueCreateTime"]) {//字段没加就原有的创建时间字段 和create被删
        //createTime
        strOfT = [[[NSString stringWithFormat:@"%@",[dic objectForKey:@"createTime"]] substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    }else{//ueCreateTime绑定时间字段
        strOfT = [[[NSString stringWithFormat:@"%@",[dic objectForKey:@"ueCreateTime"]] substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    }
    cell.detailTextLabel.text = strOfT;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -- getter
- (UILabel *)headerL{
    if (!_headerL) {
        _headerL = [[UILabel alloc]init];
       
        _headerL.text = [NSString stringWithFormat:  NSLocalizedString(@"此台设备：%@\n已绑定手机号",nil),_nickNmaeStr];
        _headerL.numberOfLines = 3;
        
        //设置字间距
        NSDictionary *dic = @{NSKernAttributeName:@0.8f};
        
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString: _headerL.text attributes:dic];
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //行间距
        [paragraphStyle setLineSpacing:10];
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [ _headerL.text length])];
        [_headerL setAttributedText:attributedString];
        [_headerL sizeToFit];
        
        
    }
    return _headerL;
}
- (UITableView *)tableViewOfDeviceBindingUserList{
    if (!_tableViewOfDeviceBindingUserList) {
        _tableViewOfDeviceBindingUserList = [[UITableView alloc]init];
        _tableViewOfDeviceBindingUserList.tableFooterView = [UIView new];
        _tableViewOfDeviceBindingUserList.tableHeaderView = [UIView new];
        _tableViewOfDeviceBindingUserList.delegate = self;
        _tableViewOfDeviceBindingUserList.dataSource = self;
        _tableViewOfDeviceBindingUserList.backgroundColor = [DataManager shareDataManager].colorOfGrayBack;
    }
    return _tableViewOfDeviceBindingUserList;
}
- (void)getNewYuesu{
    [_headerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.width.equalTo(self.view).offset(-40);
        make.height.offset(60);
    }];
    [_tableViewOfDeviceBindingUserList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_headerL.mas_bottom);
        make.bottom.equalTo(self.view).offset(-10);
        make.width.equalTo(self.view);
        
    }];
}
@end
