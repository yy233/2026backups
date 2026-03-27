//
//  DiscoverDetailViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/13.
//

#import "DiscoverDetailViewController.h"
#import "LiveRoomBase.h"

#import "LiveVcSubOfEndSleepViewControllerViewController.h"
#import "LiveVcSubOfGuanZhuViewController.h"


#import "VoiceRoomBase.h"
#define HeaderImg_tu @"https://img2.baidu.com/it/u=2080244369,3435160753&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500"

@interface DiscoverDetailViewController ()

@end

@implementation DiscoverDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"xx直播详情页";
    self.view.backgroundColor = [[UIColor brownColor]colorWithAlphaComponent:0.3];
    [self initViews];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//     self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setupNavigationBarStyleWithColor];
}


//测试
- (void)initViews{
    
    NSArray *lis = @[@"去看某视频直播",@"主播终止后的睡眠页",@"去某主播信息页",@"去看某语音直播"];
    for ( int i = 0; i < lis.count; i++) {
        UIButton *btnn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btnn  newAnBtnWithTextStr:lis[i]];
        btnn.tag = 400+i;
        btnn.frame = CGRectMake(16, i*90+100, Screen_W-32, 80);
        [btnn addTarget:self action:@selector(bttnnnnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnn];
    }
}
- (void)bttnnnnAction:(UIButton *)sender{
    switch (sender.tag - 400) {
        case 0:
        {
            DLog(@"去看某视频直播");
            //int roomId = 10086;// int roomId = 1236666;
            int roomId = 10010;
            [LiveRoomBase liveTypeLookerGotoVcWithRoomNameStr:@"csName1" withActivityId:@"" withThisLiveRoomEnterRoomID:roomId];
//            if([TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.recode].length > 0){//私密直播
//                [LiveRoomBase liveTypeLookerGotoVcWithRoomNameStr:roomNameStr
//                                                   withActivityId:zhiBoInfoModel.activityId
//                                      withThisLiveRoomEnterRoomID: [zhiBoInfoModel.roomId intValue]
//                                               withResPasswordStr:[TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.recode]
//                                                     withOtherDic:@{}];
//            }else{
//                 [LiveRoomBase liveTypeLookerGotoVcWithRoomNameStr:roomNameStr
//                                                   withActivityId:zhiBoInfoModel.activityId
//                                      withThisLiveRoomEnterRoomID: [zhiBoInfoModel.roomId intValue] ];
//            }
        }
            break;
        case 1:
        {
            
            
            //主播终止后的睡眠页
            LiveVcSubOfEndSleepViewControllerViewController *vc = [[LiveVcSubOfEndSleepViewControllerViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            //去某主播信息页
            LiveVcSubOfGuanZhuViewController *vc = [[LiveVcSubOfGuanZhuViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 3:
        {
            
            DLog(@"去看某语音直播");
//            int roomId = 19990726;
            
//            int roomId = 19990726;  
            int roomId = 307895640;
            
            VoiceRoomChuanZhiModel *myModel = [[VoiceRoomChuanZhiModel alloc]init];
            myModel.Voice_User_HeadImg = HeaderImg_tu;
            myModel.Voice_User_NickName = @"0601_name";
            myModel.Voice_Room_ID = [NSString stringWithFormat:@"%d",roomId];
            
     
            [[VoiceRoomBase shareVoice]enterVoiceRoomWithRootVc:self withInfo:myModel
                    withVcBlock:^(BOOL succes, UIViewController * _Nonnull vc) {
                if(succes){
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    DLog(@"去看某语音直播 --- 没得到vc");
                }
            }];
        }
            break;
        default:
            break;
    }
}

 
@end
