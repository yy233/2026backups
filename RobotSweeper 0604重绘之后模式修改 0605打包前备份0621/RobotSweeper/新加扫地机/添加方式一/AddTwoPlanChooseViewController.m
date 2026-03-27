//
//  AddTwoPlanChooseViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/12/5.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "AddTwoPlanChooseViewController.h"
#import "SetHomeWifiViewController.h"


#import<AVFoundation/AVCaptureDevice.h>

#import <AVFoundation/AVMediaFormat.h>

#import<AssetsLibrary/AssetsLibrary.h>

#import<CoreLocation/CoreLocation.h>

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
@interface AddTwoPlanChooseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableVieOfTwoPlanChoose;
@property (nonatomic,strong) NSArray *arrOfTextMessage;//展示文本
@property (nonatomic,strong) NSArray *arrOfTextMessageTwo;//展示文本

@property (nonatomic,assign) int rightNum;//权限数据
@end

@implementation AddTwoPlanChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"搜索机器人", nil);
    [self initData];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"搜索机器人", nil);
    [self initView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- init

- (void)initData{
   
    _arrOfTextMessage = @[NSLocalizedString(@"1.请打开机器人的电源开关，并等待启动完成的语音提示", nil),NSLocalizedString(@"2.请把手机靠近要添加的机器人", nil),NSLocalizedString(@"3.请注意：每一次添加机器人操作，只支持一部手机", nil),NSLocalizedString(@"4.请长按机器人上的Wi-Fi重置按钮3秒以上，直到听到提示音为止 (Wi-Fi重置按钮见说明书)", nil),NSLocalizedString(@"开始添加", nil)];
    _arrOfTextMessageTwo = @[ NSLocalizedString(@"1.其他客户端已绑定机器人",nil), NSLocalizedString(@"2.该客户端通过‘设备二维码分享’进行了设备分享",nil), NSLocalizedString(@"3.你可以，通过",nil)];
 
    //；若扫地机已经配好家庭网络，手机可在家庭网络状态下直接点击搜索
    
}
- (void)initView{
    [self.view addSubview:self.tableVieOfTwoPlanChoose];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableVieOfTwoPlanChoose.estimatedRowHeight = 40;//估算高度
    self.tableVieOfTwoPlanChoose.rowHeight = UITableViewAutomaticDimension;
    
    //    _textTableView.showsHorizontalScrollIndicator = NO;
    //    _textTableView.showsVerticalScrollIndicator = NO;
    
}
    
#pragma mark -- tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return _arrOfTextMessage.count;
    }else{
        return _arrOfTextMessageTwo.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    
//    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:12.5];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.section==0) {
        
        if (indexPath.row==4) {//方法一
            //            cell.textLabel.attributedText = [self getStrOfQHCell:_arrOfTextMessage[indexPath.row]];
//            cell.textLabel.textAlignment = NSTextAlignmentCenter;
//            cell.textLabel.textColor = [DataManager shareDataManager].colorOfMainType;
//            cell.textLabel.text = _arrOfTextMessage[indexPath.row]!=nil?_arrOfTextMessage[indexPath.row] : @"注意事项";
            cell.textLabel.attributedText = [self getStrOfFirstCell];
            
        }else{
            cell.textLabel.textColor = [UIColor darkTextColor];
            cell.textLabel.text = _arrOfTextMessage[indexPath.row]!=nil?_arrOfTextMessage[indexPath.row] : @"注意事项";
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
        
    }else{//方法二
        
        if (indexPath.row==2) {
            
            cell.textLabel.attributedText = [self getStrOfLastCell];
        }else{
            cell.textLabel.text = _arrOfTextMessageTwo[indexPath.row]!=nil?_arrOfTextMessageTwo[indexPath.row] : @"注意事项";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *sectionHeaderL = [[UILabel alloc]init];
    sectionHeaderL.backgroundColor = Y_RGBA(245, 245, 245, 1);
    sectionHeaderL.font = [UIFont systemFontOfSize:14];
    sectionHeaderL.frame = CGRectMake(10, 0, _tableVieOfTwoPlanChoose.width-20, 30);
    if (section==0) {
        sectionHeaderL.text = NSLocalizedString(@"添加方式一", nil) ;
        
    }else{
        sectionHeaderL.text = NSLocalizedString(@"添加方式二",nil);
    }
    return sectionHeaderL;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1 && indexPath.row==2) {
        
        [self goTwoPlanAction];
    }
    if (indexPath.section == 0) {
        if (indexPath.row==4) {
            //方式一跳转
            //            [self changeWifiVc];
            //跳转到存储家庭Wi-Fiye
            SetHomeWifiViewController *homeWifiVc = Y_storyBoard_id(@"SetHomeWifiViewController");
            self.title = @"";
            [self.navigationController pushViewController:homeWifiVc animated:YES];
            
        }
  
    }
}


- (void)goTwoPlanAction{

         _rightNum = 0;
        // 1、 获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (device) {
            // 判断授权状态
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusNotDetermined) {//尚未对此应用程序做出选择
               
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) { // 用户第一次同意了访问相册权限  == AVAuthorizationStatusAuthorized
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            _rightNum+=1;
                        });
//                        [self getNum];//20190410不调用 它在主线程掉方法报错了This application is modifying the autolayout engine from a background thread after the engine was accessed from the main thread. This can lead to engine corruption and weird crashes
                    } else { // 用户第一次拒绝了访问相机权限
                        //不跳转会崩
//                        [self getNum];
                        return ;
                    }
                    
                }];
                
           
            }else if (status == AVAuthorizationStatusRestricted){//无权访问 家长限制
                [self getNum];
                
            }else if(status == AVAuthorizationStatusDenied) {//User已明确拒绝
                [self getNum];
                
            }else if (status == AVAuthorizationStatusAuthorized){//已授权
                _rightNum += 1;
                [self getNum];
            }else{
                [self getNum];
            }
        }
}

- (void)getNum{
    NSLog(@"权限数据_rightNum=%d",_rightNum);
    //权限数据 相机1  相册在后页自行判断
    if (_rightNum>0) {//1时跳转
        [self goPushQr];
        
    }else{
        [self goSetVc];//权限设置界面
    }
}
- (void)goPushQr{
    //扫一扫
    GenerateQrCodeViewController *generateQrCodeVc = [[GenerateQrCodeViewController alloc]init];
    self.title = @"";
    [self.navigationController pushViewController:generateQrCodeVc animated:YES];
}
- (void)goSetVc{
    //没有权限
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
        if(@available(iOS 10.0 ,*)){//ios10+
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }else{
        [self.view makeToast:NSLocalizedString(@"无法跳转到设置页,请手动切换到系统设置界面,设置权限", nil) duration:3.0 position:@"center"];
    }
}
#pragma mark -- 方法一的cell

- (NSMutableAttributedString *)getStrOfFirstCell{
    UIColor *textShowColor = [DataManager shareDataManager].colorOfMainType;
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"5.你可以，点击开始添加，并按照提示操作", nil)];
//    "5.你可以，点击开始添加，并按照提示操作" = "5. You can click to add and follow the prompts";//1220修改
    //search robot
    int a = 7;
    int b = 4;
    if (self.title.length>5) {
        //前   5.Click to
        a = 18;
        b = 5;
    }else{
        //前4
        a = 7;
        b = 4;
    }
    
    //字体大小
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.5] range:NSMakeRange(0, attributedStr.length)];//a
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.5] range:NSMakeRange(a+1, b)];
//    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.5] range:NSMakeRange(a+b, attributedStr.length-a-b)];
    //字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, a)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:textShowColor range:NSMakeRange(a+1, b)];
    //下划线
    [attributedStr addAttribute:NSUnderlineColorAttributeName value:textShowColor range:NSMakeRange(a+1, b)];
    [attributedStr addAttribute:NSUnderlineStyleAttributeName value:@1 range:NSMakeRange(a+1, b)];
    return attributedStr;
}

#pragma mark -- 方法二的cell

- (NSMutableAttributedString *)getStrOfLastCell{
    UIColor *textShowColor = [DataManager shareDataManager].colorOfMainType;
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"3.你可以，通过扫描二维码添加到机器人", nil)];
    
    int indexNum = 7;
    if(self.title.length>5){
        indexNum = 32;//3.You can add it to the robot by
    }else{
        //前7个字符不是
        indexNum = 7;
    }
    
    
    //字体大小
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.5] range:NSMakeRange(0, indexNum)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.5] range:NSMakeRange(indexNum+1, attributedStr.length-indexNum-1)];
    //字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, indexNum)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:textShowColor range:NSMakeRange(indexNum+1, attributedStr.length-indexNum-1)];
    //下划线
    [attributedStr addAttribute:NSUnderlineColorAttributeName value:textShowColor range:NSMakeRange(indexNum+1, attributedStr.length-indexNum-1)];
    [attributedStr addAttribute:NSUnderlineStyleAttributeName value:@1 range:NSMakeRange(indexNum+1, attributedStr.length-indexNum-1)];
    return attributedStr;
}

#pragma mark --
#pragma mark -- tableVieOfTwoPlanChoose
- (UITableView *)tableVieOfTwoPlanChoose{
    if(!_tableVieOfTwoPlanChoose){
        _tableVieOfTwoPlanChoose = [[UITableView alloc]init];
        _tableVieOfTwoPlanChoose.frame = self.view.frame;
        _tableVieOfTwoPlanChoose.delegate = self;
        _tableVieOfTwoPlanChoose.dataSource = self;
        _tableVieOfTwoPlanChoose.tableHeaderView = [UIView new];
        _tableVieOfTwoPlanChoose.tableFooterView = [UIView new];
    }
    return _tableVieOfTwoPlanChoose;
}

@end
