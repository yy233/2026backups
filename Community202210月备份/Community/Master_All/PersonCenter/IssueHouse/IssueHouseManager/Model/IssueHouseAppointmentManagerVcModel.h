//
//  IssueHouseAppointmentManagerVcModel.h
//  Community
//
//  Created by 余莹 on 2021/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueHouseAppointmentManagerVcModel : NSObject //HouseRentListVcHouseCellModel
@property (nonatomic,strong) NSString *checkingTime;
@property (nonatomic,strong) NSString *contactName;
@property (nonatomic,strong) NSString *houseCommunityName;
@property (nonatomic,strong) NSString *houseDirection;
@property (nonatomic,strong) NSString *houseLeaseDeposit;
@property (nonatomic,strong) NSString *houseLeaseMode;
@property (nonatomic,strong) NSString *houseType;
@property (nonatomic,strong) NSString *houseUnit;
@property (nonatomic,strong) NSString *houseSquareMeter;
@property (nonatomic,strong) NSString *houseTitle;
@property (nonatomic,strong) NSString *reserveStatusText;
//
@property (nonatomic,assign) NSInteger reserveStatus;
@property (nonatomic,assign) NSInteger houseCommunityId;
@property (nonatomic,assign) NSInteger houseDirectionId;
@property (nonatomic,assign) NSInteger houseImageId;
@property (nonatomic,assign) NSInteger houseLeaseId;
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) NSInteger proprietor;
//
@property (nonatomic,strong) NSArray *houseImageUrl;
@property (nonatomic,assign) double housePrice;

 


/**
 checkingTime = "04-03 11:00";
 contactName = "余莹";
 houseCommunityId = 27839755849728;
 houseCommunityName = "测试小区";
 houseDirection = "东";
 houseDirectionId = 1;
 houseImageId = 40545009652600832;
 houseImageUrl =             (
     "http://222.178.212.29:9000/house-img/ec28558ee4fc4031906bbb4732cfe7ae"
 );
 houseLeaseDeposit = "押1付1";
 houseLeaseId = 40545009577103360;
 houseLeaseMode = "合租";
 housePrice = 1499;
 houseSquareMeter = "30m²";
 houseTitle = "合租房";
 houseType = "其他类型";
 houseUnit = "月";
 id = 40590046256041984;
 proprietor = 0;
 reserveStatusText = "正在预约中";
 */
@end

NS_ASSUME_NONNULL_END
