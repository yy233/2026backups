//
//  DeBugViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/5/14.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "DeBugViewController.h"

@interface DeBugViewController ()<XmppManagerDelegate>
@property (nonatomic,strong) UIButton *uploadLogBtn;
@property (nonatomic,strong) UIButton *TwoTwoCleanBtn;//用于商城2*2清扫的按钮;
@property (nonatomic,strong) UILabel *fourfourColorShowOrNotLabel;
@property (nonatomic,strong) UISwitch *fourfourColorShowOrNotShowSlider;


@end

@implementation DeBugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"后台测试界面";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.uploadLogBtn];
    [self.view addSubview:self.TwoTwoCleanBtn];
    [self.view addSubview:self.fourfourColorShowOrNotLabel];
    [self.view addSubview:self.fourfourColorShowOrNotShowSlider];
    
    [self yuesuofSwitchAndLable];
    
    if (DataManager.shareDataManager.colorShowOrNotShowOfCleanFourFourMode==YES) {
        _fourfourColorShowOrNotShowSlider.on = YES;
    }else{
        _fourfourColorShowOrNotShowSlider.on = NO;
    }
    
    [XmppManager shareXmppManager].delegates  = self;
    // Do any additional setup after loading the view.
}

-(void)receiveXmppMessageWithMessage:(NSString *)message{
    
    if ([[message componentsSeparatedByString:@" "].firstObject isEqualToString:@"upload_log_filename"]) {
        NSString *msg = [NSString stringWithFormat:@"%@", [message componentsSeparatedByString:@" "].lastObject];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"bug提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        
        
        [alertVc addAction:cancelAc];
        
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}
-(void)receiveXmppUserStatusWithMessage:(NSString *)message{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIButton *)uploadLogBtn{
    if (!_uploadLogBtn) {
        _uploadLogBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _uploadLogBtn.backgroundColor = DataManager.shareDataManager.colorOfMainType;
        _uploadLogBtn.frame = CGRectMake(0, 0, 150, 40);
        _uploadLogBtn.center = CGPointMake(self.view.center.x, self.view.center.y-100);
        [_uploadLogBtn setTitle:@"日志上传" forState:UIControlStateNormal];
        [_uploadLogBtn addTarget:self action:@selector(uploadLogBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadLogBtn;
}
- (void)uploadLogBtnAction:(UIButton *)sender{
    //    通知机器上传日志
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"upload_log"];
    [self.view makeToast:@"已发送上传日志请求" duration:0.5 position:@"bottom"];
}
#pragma mark:_____

- (UIButton *)TwoTwoCleanBtn{
    if (!_TwoTwoCleanBtn) {
        _TwoTwoCleanBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _TwoTwoCleanBtn.backgroundColor = DataManager.shareDataManager.colorOfMainType;
        _TwoTwoCleanBtn.frame = CGRectMake(0, 0, 150, 40);
        _TwoTwoCleanBtn.center = CGPointMake(self.view.center.x, self.view.center.y-50);
        [_TwoTwoCleanBtn setTitle:@"循环区域清扫" forState:UIControlStateNormal];//2*2清扫模式
        [_TwoTwoCleanBtn addTarget:self action:@selector(TwoTwoCleanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _TwoTwoCleanBtn;
}
- (void)TwoTwoCleanBtnAction:(UIButton*)sender{
    //    通知机器上传日志
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"clean_loop"];
    [self.view makeToast:@"已发送循环区域清扫指令" duration:0.5 position:@"center"];
}
#pragma mark:___
- (UISwitch *)fourfourColorShowOrNotShowSlider{
    if (!_fourfourColorShowOrNotShowSlider) {
        _fourfourColorShowOrNotShowSlider = [[UISwitch alloc]init];
        _fourfourColorShowOrNotShowSlider.frame = CGRectMake(150,self.view.center.y+50, 100, 50);
//         _fourfourColorShowOrNotShowSlider.center = CGPointMake(self.view.center.x+100, self.view.center.y+50);
//        [_fourfourColorShowOrNotShowSlider setTintColor:[UIColor lightGrayColor]];
        //        [_fourfourColorShowOrNotShowSlider setThumbTintColor:[UIColor whiteColor]];
//         [_fourfourColorShowOrNotShowSlider setThumbTintColor:[UIColor whiteColor]];
        [_fourfourColorShowOrNotShowSlider setOnTintColor:DataManager.shareDataManager.colorOfMainType];
         [_fourfourColorShowOrNotShowSlider addTarget:self action:@selector(showOrNotShowAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _fourfourColorShowOrNotShowSlider;
}
//DataManager.shareDataManager.colorShowOrNotShowOfCleanFourFourMode
- (void)showOrNotShowAction:(UISwitch*)ffSwitch{
    ffSwitch.selected = !ffSwitch.selected;//更换状态
    if (ffSwitch.on==NO) {
         _fourfourColorShowOrNotShowSlider.on = NO;
        DataManager.shareDataManager.colorShowOrNotShowOfCleanFourFourMode = NO;
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_map"];
        //        _fourfourColorShowOrNotLabel.text = @"4*4模式里的部分绘图彩色";
//        _fourfourColorShowOrNotLabel.text = @"4*4模式状态下的部分绘图彩色开关";
      
    }else{
         _fourfourColorShowOrNotShowSlider.on = YES;
        DataManager.shareDataManager.colorShowOrNotShowOfCleanFourFourMode = YES;
         [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_map"];
//                _fourfourColorShowOrNotLabel.text = @"4*4模式状态下的部分绘图彩色开关";
//        _fourfourColorShowOrNotLabel.text = @"4*4模式里的部分绘图彩色开启";
    }
    
}


- (UILabel *)fourfourColorShowOrNotLabel{
    if (!_fourfourColorShowOrNotLabel) {
        _fourfourColorShowOrNotLabel = [[UILabel alloc]init];
        _fourfourColorShowOrNotLabel.frame = CGRectMake(20, self.view.center.y+50, 100, 50);
        _fourfourColorShowOrNotLabel.numberOfLines =0;
//        _fourfourColorShowOrNotLabel.text = @"4*4模式里的部分绘图彩色关闭";
//        _fourfourColorShowOrNotLabel.text = @"4*4模式状态下的部分绘图彩色开关";
        _fourfourColorShowOrNotLabel.text = @"导航点设置";
        _fourfourColorShowOrNotLabel.textColor = [UIColor grayColor];
    }
    return _fourfourColorShowOrNotLabel;
}

- (void)yuesuofSwitchAndLable{
//    [_fourfourColorShowOrNotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.
//        make.centerY.equalTo(_fourfourColorShowOrNotShowSlider);
//    }];
}
@end
