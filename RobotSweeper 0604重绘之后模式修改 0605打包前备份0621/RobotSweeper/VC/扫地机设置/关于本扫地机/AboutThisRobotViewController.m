//
//  AboutThisRobotViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/6/13.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "AboutThisRobotViewController.h"

@interface AboutThisRobotViewController ()<UITableViewDelegate,UITableViewDataSource,XmppManagerDelegate>
@property (nonatomic,strong) UITableView *tableViewOfAboutRobot;
@property (nonatomic,strong) NSMutableArray *arrOfTitle;
@property (nonatomic,strong) NSMutableArray *arrOfdata;
//sreOftype strofElect wifiMac wifiIp openTime

@property (nonatomic,assign) int idIndex;//显示的ID号位置

@property (nonatomic,assign) int sreTypeIndex;
@property (nonatomic,assign) int electIndex;
@property (nonatomic,assign) int wifiNameIndex;
@property (nonatomic,assign) int wifiMacIndex;
@property (nonatomic,assign) int wifiIpIndex;
@property (nonatomic,assign) int openTimeIndex;



@end

@implementation AboutThisRobotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"关于本机",nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self initView];
    
}
- (void)initData{
//    关于扫地机
     [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_robot_info"];
 
    _arrOfTitle = [NSMutableArray arrayWithObjects:NSLocalizedString(@"设备名称", nil),NSLocalizedString(@"机器人编号", nil),NSLocalizedString(@"电池状态", nil),NSLocalizedString(@"电池电量", nil),NSLocalizedString(@"Wi-Fi SSID", nil),NSLocalizedString(@"WLAN MAC", nil),NSLocalizedString(@"IP Address", nil),NSLocalizedString(@"已开机时间", nil), nil];//机器人编号 设备识别码
    _idIndex = 1;//1212新增ID号位置
    _sreTypeIndex = 2;
    _electIndex = 3;
    _wifiNameIndex = 4;
    _wifiMacIndex = 5;
    _wifiIpIndex  = 6;
    _openTimeIndex = 7;
    
    /** 
    _arrOfTitle = [NSMutableArray arrayWithObjects:@"设备名称：",@"设备识别码：",@"IMEI：",@"设备型号：",@"电池状态：",@"电池电量：",@"Wi-Fi SSID：",@"WLAN MAC：",@"IP Address：",@"已开机时间：", nil];
    _sreTypeIndex = 4;
    _electIndex = 5;
    _wifiNameIndex = 6;
    _wifiMacIndex = 7;
    _wifiIpIndex  = 8;
    _openTimeIndex = 9;
    */
    _arrOfdata = [NSMutableArray array];
    
    NSString * jidStrOfThisRobot = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    NSString * nameStrOfThisRobot = @"";
    
    NSMutableArray *arrOflist = [NSMutableArray arrayWithArray: [UserTool sharedUserTool].listOfRobotsArr];
    
    for ( NSDictionary *dicOfRobot in arrOflist) {
        if ([[dicOfRobot objectForKey:@"eqOpfJid"]  isEqualToString: jidStrOfThisRobot]) {
            
            nameStrOfThisRobot = [dicOfRobot objectForKey:@"nickName"];
        }
    }
    if([nameStrOfThisRobot isEqualToString: @""]||nameStrOfThisRobot==nil){
        nameStrOfThisRobot = NSLocalizedString(@"暂无昵称",nil);
    }
    
    //
    [_arrOfdata addObject:nameStrOfThisRobot];//昵称
    
//    [_arrOfdata addObject:jidStrOfThisRobot];//jid 1212更换成得到的ID 1213+判断
    if (![[DataManager shareDataManager].robotWillShowId isEqualToString:@""] && ![[DataManager shareDataManager].robotWillShowId isEqualToString:@"00000000"]) {//wifi名
        [_arrOfdata addObject:[DataManager shareDataManager].robotWillShowId];
    }else{
         [_arrOfdata addObject:jidStrOfThisRobot];//没有showid时显示jid
    }
    
    
    if (_arrOfTitle.count==10) {//目前隐藏这两个 不使用
        [_arrOfdata addObject:@"IMEI"];//IMEI
        [_arrOfdata addObject:NSLocalizedString(@"设备型号",nil)];//设备型号
    }

    [_arrOfdata addObject:NSLocalizedString(@"放电中",nil)];// @"放电中"；
    

    if (_areaTimeCharges.length>0) {
          [_arrOfdata addObject:[NSString stringWithFormat:@"%@%%",[_areaTimeCharges componentsSeparatedByString:@"|"].lastObject]];//电量
    }else{
        [_arrOfdata addObject:NSLocalizedString(@"暂无电量信息",nil)];
    }
   
    
    if (![[DataManager shareDataManager].robotWifiSsid isEqualToString:@""]) {//wifi名
        [_arrOfdata addObject:[DataManager shareDataManager].robotWifiSsid];
        
    }else{
        [_arrOfdata addObject:@"Wi-Fi SSID"];//暂时的ssid未有数据
    }
    
    if (![[DataManager shareDataManager].robotWifiMac isEqualToString:@""]) {//wifi名
        [_arrOfdata addObject:[DataManager shareDataManager].robotWifiMac];
        
    }else{
        [_arrOfdata addObject:@"WLAN MAC"];//WLAN MAC
    }
    
    if (![[DataManager shareDataManager].robotWifiIP isEqualToString:@""]) {//wifi名
        [_arrOfdata addObject:[DataManager shareDataManager].robotWifiIP];
        
    }else{
        
         [_arrOfdata addObject:@"IP "];//ip
    }

    if ([DataManager shareDataManager].openTime.length>0) {
         NSString *strOfOpenT = [ToolOfBasic timeDayFormatted:[[DataManager shareDataManager].openTime intValue]];
        if (self.title.length>6) {
            strOfOpenT = [ToolOfBasic timeDayFormattedOfEnglish:[[DataManager shareDataManager].openTime intValue]];
        }
       
       [_arrOfdata addObject:strOfOpenT];//开机时间
    }else{
        [_arrOfdata addObject:NSLocalizedString(@"已开机时间",nil)];//开机时间
    }
    
    
}
- (void)initView{
    [self.view addSubview:self.tableViewOfAboutRobot];
    [XmppManager shareXmppManager].delegates = self;
}
#pragma mark --
- (void)receiveXmppMessageWithMessage:(NSString *)message{
    NSMutableArray *arrOfmsg = [NSMutableArray arrayWithArray:[message componentsSeparatedByString:@" "]];
    NSString *type = arrOfmsg.firstObject;
    NSLog(@"关于界面 type=%@,messg=%@",type,arrOfmsg);
    
//    if ([type isEqualToString:@"connect_wifi_info"]) {//connect_wifi_info ssid level ip mac //20190417Wi-Fi命名有空格时的情况，从后往前取值。
//
//        NSString *strOfWifiName = arrOfmsg[1];
//        //存
//        [DataManager shareDataManager].robotWifiSsid = strOfWifiName;
//        //当前页
//        [_arrOfdata replaceObjectAtIndex:_wifiNameIndex withObject:strOfWifiName];
//
//        if (arrOfmsg.count>=5) {
//            NSString *strOfWifiIp = arrOfmsg[3];
//            NSString *strOfWifiMac = arrOfmsg[4];
//            //存
//            [DataManager shareDataManager].robotWifiIP = strOfWifiIp;
//            [DataManager shareDataManager].robotWifiMac = strOfWifiMac;
//            //当前页更新
//
//            [_arrOfdata replaceObjectAtIndex:_wifiMacIndex withObject:strOfWifiMac];
//            [_arrOfdata replaceObjectAtIndex:_wifiIpIndex withObject:strOfWifiIp];
//
//        }
//        [_tableViewOfAboutRobot reloadData];
//    }
    
    if ([type isEqualToString:@"connect_wifi_info"]) {//connect_wifi_info ssid level ip mac //20190417Wi-Fi命名有空格时的情况，从后往前取值。

        [arrOfmsg removeObjectAtIndex:0];//协议头
        if (arrOfmsg.count<4) {
            return;
        }
       //macIP
        NSString *strOfWifiMac = arrOfmsg.lastObject;
        [arrOfmsg removeLastObject];//mac
        NSString *strOfWifiIp = arrOfmsg.lastObject;
        [arrOfmsg removeLastObject];//ip
        [arrOfmsg removeLastObject];//wifi等级
        
        //存
        [DataManager shareDataManager].robotWifiIP = strOfWifiIp;
        [DataManager shareDataManager].robotWifiMac = strOfWifiMac;
        //当前页更新
        [_arrOfdata replaceObjectAtIndex:_wifiMacIndex withObject:strOfWifiMac];
        [_arrOfdata replaceObjectAtIndex:_wifiIpIndex withObject:strOfWifiIp];
        
        //ssid
        NSString *strOfWifiName = [arrOfmsg componentsJoinedByString:@" "];
        //存
        [DataManager shareDataManager].robotWifiSsid = strOfWifiName;
        //当前页
        [_arrOfdata replaceObjectAtIndex:_wifiNameIndex withObject:strOfWifiName];

        [_tableViewOfAboutRobot reloadData];
    }
    if ([type isEqualToString:@"clearn_info"] && arrOfmsg.count>=6) {
        /*
         //时间
         topView.setTimeLabel(timeNum: array[3])
         //面积
         topView.setAreaLabel(areaNum: array[4])
         //电量
         topView.setChargeLabel(chargeNum: array[5])
         
         areaTimeCharge  = array[4]+"|"+array[3]+"|"+array[5] as NSString
         */
        
        
        NSString *strOfElectricity = [NSString stringWithFormat:@"%@%%",arrOfmsg.lastObject];//电量
        [_arrOfdata replaceObjectAtIndex:_electIndex withObject:strOfElectricity];
        [_tableViewOfAboutRobot reloadData];
        
       
    }
    
    /**
     charging_faild
     charing_full
     charing
     stop_home
     start_home//开始回充
     stop_clean
     stop_charge:停止充电
     out_charge_line
     standby 待机中
     //nav_cleaning followall_cleaning zone_cleaning emphases_cleaning
     sleep 休眠
     */
    if ([type isEqualToString:@"code_i_005"]||[[message componentsSeparatedByString:@":"].firstObject isEqualToString:@"charing"]||[[message componentsSeparatedByString:@":"].firstObject isEqualToString:@"charing_full"]) {//得到充电相关的协议
        NSString*  sreOfType = NSLocalizedString(@"充电中", nil) ;
        [_arrOfdata replaceObjectAtIndex:_sreTypeIndex withObject:sreOfType];
        [_tableViewOfAboutRobot reloadData];
        
    }else  if([[message componentsSeparatedByString:@":"].firstObject containsString:@"cleaning"]||[[message componentsSeparatedByString:@":"].firstObject containsString:@"start_home"]){//得到清扫相关的协议 回充相关协议
        NSString*  sreOfType = NSLocalizedString(@"放电中",nil);
        [_arrOfdata replaceObjectAtIndex:_sreTypeIndex withObject:sreOfType];
        [_tableViewOfAboutRobot reloadData];
    }else{
        //其余情况的协议则不更新文本
    }
    
    if([type isEqualToString:@"about_device"]&&(arrOfmsg.count>=11)){
        
        //robotWillShowId 不再使用唯一编码显示，使用返回的设备号 1212新增
        if (arrOfmsg.count>12) {
             NSString *strOfshowId = arrOfmsg[12];
            if([strOfshowId isEqualToString:@"00000000"]){
                //全0用jid唯一编码显示1213
                [DataManager shareDataManager].robotWillShowId = [ShareUser sharedUserInfo].userMode.nowRobotJid;
                [_arrOfdata replaceObjectAtIndex:_idIndex withObject:[ShareUser sharedUserInfo].userMode.nowRobotJid];
                [_tableViewOfAboutRobot reloadData];
            }else{
                [DataManager shareDataManager].robotWillShowId = strOfshowId;
                [_arrOfdata replaceObjectAtIndex:_idIndex withObject:strOfshowId];
                [_tableViewOfAboutRobot reloadData];
            }
            
            
        }
        if(arrOfmsg.count>11){
            [DataManager shareDataManager].robotOpenOrNo = arrOfmsg[11];
            //1.冠维不支持这个信号  冠维独有休眠sleep协议
            if(DataManager.shareDataManager.appRobotTypeStr.intValue==2){//冠维的不支持船型开关状态位它会一直为0
                DataManager.shareDataManager.robotOpenOrNo = @""; //清空
            }
        }
    
        //开机时长
        // about_device slam版本/控制板版本/小鸟版本信息/开机时间/语音音量/船型开关状态
//        NSString *strOfTimeSecond = [NSString stringWithFormat:@"%@",arrOfmsg[10]];
         NSString *strOfTimeSecond = [NSString stringWithFormat:@"%@",arrOfmsg[9]];
        NSString *strOfOpenT = [ToolOfBasic timeDayFormatted:[strOfTimeSecond intValue]];
        
        if (self.title.length>6) {
            strOfOpenT = [ToolOfBasic timeDayFormattedOfEnglish:[strOfTimeSecond intValue]];
        }
        [_arrOfdata replaceObjectAtIndex:_openTimeIndex withObject:strOfOpenT];
        [_tableViewOfAboutRobot reloadData];
    }
    NSLog(@"%@",message);
    
    

}
- (void)receiveXmppUserStatusWithMessage:(NSString *)message{
    
}
#pragma mark --

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrOfTitle.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.numberOfLines = 1;
//    if (indexPath.row<2) {
//         cell.textLabel.text = [NSString stringWithFormat:@"%@%@",_arrOfTitle[indexPath.row], _arrOfdata[indexPath.row]];
//    }else{
//         cell.textLabel.text = [NSString stringWithFormat:@"%@",_arrOfTitle[indexPath.row]];
//    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",_arrOfTitle[indexPath.row], _arrOfdata[indexPath.row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@：",_arrOfTitle[indexPath.row]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_arrOfdata[indexPath.row]];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark --
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UITableView *)tableViewOfAboutRobot{
    if (!_tableViewOfAboutRobot) {
        _tableViewOfAboutRobot = [[UITableView alloc]init];
        _tableViewOfAboutRobot.frame = self.view.frame;
        _tableViewOfAboutRobot.tableHeaderView = [UIView new];
        _tableViewOfAboutRobot.tableFooterView = [UIView new];
        _tableViewOfAboutRobot.dataSource = self;
        _tableViewOfAboutRobot.delegate = self;
        
    }
    return _tableViewOfAboutRobot;
}

@end
