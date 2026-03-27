//
//  HouseRentOfAppointmentVC.m
//  Community
//
//  Created by 余莹 on 2021/3/30.
//

#import "HouseRentOfHouseAppointmentVC.h"
#import "HouseRentOfAppointmentVCSubView.h"
//
#import "HouseRentOfHouseAppointmentViewModel.h"
//
#import "HouseRentOfAppointmentTimesPopView.h"
#import <Foundation/Foundation.h>

@interface HouseRentOfHouseAppointmentVC () <HouseRentOfAppointmentVCSubViewDelegate,HouseRentOfAppointmentTimesPopViewDelegate>
@property (nonatomic,strong) HouseRentOfAppointmentVCSubView *subView;
@property (nonatomic,strong) HouseRentOfAppointmentTimesPopView *timeChoosePopView;
//
@property (nonatomic,strong) NSString *lookDayStr;
@property (nonatomic,strong) NSString *lookTimeStr;
@property (nonatomic,assign) NSInteger stayInTimeIndex;

@end

@implementation HouseRentOfHouseAppointmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约看房";
    self.lookDayStr = @"";
    self.lookTimeStr = @"";
    self.stayInTimeIndex = 0;
    [self initView];
    [self initData];
    
    NSLog(@"---预约----%@",[ToolOfTimeChangeFormat currentTimeStr]);
 
}
- (void)initData{
    
    WEAKSELF
    [HouseRentOfHouseAppointmentViewModel houseRentGetHouseInfoOfAppointmentWithParms:@{@"houseId":@(self.houseRentId)} withDicBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            NSLog(@"appointMentWithParms ---%@",dic);
            HouseRentListVcHouseCellModel *model = [HouseRentListVcHouseCellModel mj_objectWithKeyValues:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.subView fillDataWithIsHouseModel:model];
            });
        }
    }];
   
}
- (void)timesListData{
    /**
     旧数据弃用
     改本地数据
     */
    /**
     WEAKSELF
     [HouseRentOfHouseAppointmentViewModel houseRentGetHouseInfoOfAppointmentDaysListAndTimesListWithDicBlock:^(NSDictionary * dic, BOOL success) {
         if (success) {
             NSMutableArray *daysArr = [[dic allKeys] containsObject:@"reserveDate"]?[dic objectForKey:@"reserveDate"]:[NSMutableArray array];
             NSMutableArray *timesArr = [[dic allKeys] containsObject:@"reserveTime"]?[dic objectForKey:@"reserveTime"]:[NSMutableArray array];
             NSLog(@"appointMentWith times ---%@",dic);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf.timeChoosePopView showViewfillDataWithTimeArr:daysArr withTimeArr:timesArr];
             });
         }
     }];
     */
    NSMutableArray *daysArr = [[NSMutableArray alloc]initWithArray:[ToolOfTimeChangeFormat getCurrentDayToLastServeDay]];
    NSMutableArray *timesArr = [[NSMutableArray alloc]initWithObjects:@"8:00",@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",nil];
    
    [self.timeChoosePopView showViewfillDataWithTimeArr:daysArr withTimeArr:timesArr];
}
#pragma mark == delegate
- (void)footerViewOkAction{
    if (self.lookTimeStr.length==0 || self.lookDayStr.length==0 || self.stayInTimeIndex==0) {
        Y_SVP_SHOW_ERR_MES(@"请选择时间");
        return;
    }
    //处理时间戳
    NSString *strOfTime = [NSString stringWithFormat:@"%@ %@:00",self.lookDayStr,self.lookTimeStr];
    NSString *t = [ToolOfTimeChangeFormat getTimeStrWithString:strOfTime];//@"YYYY-MM-dd HH:mm:ss"格式需求
    //
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID)  forKey:@"communityId"]; 
    [parms setValue:@(self.houseRentId) forKey:@"houseLeaseId"];
    [parms setValue:@(self.stayInTimeIndex) forKey:@"checkInTime"];//入住index
    [parms setValue:@([t doubleValue]) forKey:@"checkingTime"]; //看房时间
//    [parms setValue:self.lookDayStr forKey:@"reserveDate"];
//    [parms setValue:self.lookTimeStr forKey:@"reserveTime"];
    WEAKSELF
    [HouseRentOfHouseAppointmentViewModel houseRentSendAppointmentInfoWithParms:parms withDicBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"成功预约!");
                [weakSelf popVC];
            });
          
        }
    }];
    
}
- (void)touchTimesChooseBtnAction{
    [self timesListData];
}
- (void)chooseYuyueTimeStrWithReserveDate:(NSString *)reserveDate withReserveTime:(NSString *)reserveTime{
 
    self.lookDayStr = reserveDate;
    self.lookTimeStr = reserveTime;
    NSString *yuyueTimeStr = [NSString stringWithFormat:@"%@ %@",reserveDate,reserveTime];//展示用
    [self.subView changYuyueTimeWithStr:yuyueTimeStr];
}
- (void)chooseStayInTimeIndex:(NSInteger)index{
    self.stayInTimeIndex = index;
}
#pragma mark ==
- (void)initView{
    [self.view addSubview:self.subView];
    [_subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_subView.superview);
    }];
}
#pragma mark ==
- (HouseRentOfAppointmentVCSubView *)subView{
    if (!_subView) {
        _subView = [[HouseRentOfAppointmentVCSubView alloc]initWithFrame:self.view.frame];
        _subView.delegate = self;
    }
    return _subView;
}
- (HouseRentOfAppointmentTimesPopView *)timeChoosePopView{
    _timeChoosePopView = [[HouseRentOfAppointmentTimesPopView alloc]init];
    _timeChoosePopView.delegate = self;
    return _timeChoosePopView;
}
@end
