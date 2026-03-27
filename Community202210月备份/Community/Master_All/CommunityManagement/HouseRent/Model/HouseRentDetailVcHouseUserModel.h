//
//  HouseRentDetailVcHouseUserModel.h
//  Community
//
//  Created by 余莹 on 2021/8/30.
//

#import <Foundation/Foundation.h>
#import "HouseRentDetailVcBuniessShopModelUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HouseRentDetailVcHouseUserModel : HouseRentDetailVcBuniessShopModelUserModel
@property (nonatomic,strong) NSString  *nickname;
@property (nonatomic,assign) NSInteger identificationType;//身份证 护照 （类型）
/**
 uid = 6d6d2a3e42b14afa88de5e2faf6acfae;
 user =         {
     avatarUrl = "http://222.178.212.29:9000/avatar/be8896cabb944f4daacdfdd424f0bdc8";
     birthdayTime = "2021-04-28 00:00:00";
     cityId = 500100;
     createTime = "2021-03-02 15:43:16";
     deleted = 0;
     detailAddress = "\U91cd\U5e86\U5e02\U4e5d\U9f99\U5761\U533a\U897f\U5f6d\U9547\U6ce5\U58c1\U675115\U7ec431\U53f7";
     faceUrl = "http://222.178.212.29:9000/user-face/7899de768b67481da20221d35e44fcac";
     householderId = 0;
     id = 30057538477232128;
     idCard = 500107199306118933;
     idCardPicFace = "http://222.178.212.29:9000/id-card/379d9c62-10fc-46d0-ac94-d8e5738eea88";
     idStr = 30057538477232128;
     identificationType = 1;
     imId = c889034ef4d3424aa8ac9bf7cea909c1;
     isRealAuth = 2;
     mobile = 13308303354;
     nickname = "\U7b2c\U4e00\U671f";
     provinceId = 500000;
     realName = "\U97e9\U540c\U5b66";
     regId = e092f998c41646f1897d6eba9e608fc3;
     sex = 1;
     uid = 6d6d2a3e42b14afa88de5e2faf6acfae;
     updateTime = "2021-08-24 18:01:35";
 };
};
 */
@end

NS_ASSUME_NONNULL_END
