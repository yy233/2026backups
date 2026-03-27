//
//  HouseRentDetailVcBuniessShopModelUserModel.h
//  Community
//
//  Created by 余莹 on 2021/1/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentDetailVcBuniessShopModelUserModel : NSObject
@property (nonatomic,strong) NSString *avatarUrl;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic,strong) NSString *detailAddress;
@property (nonatomic,strong) NSString *idCard;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *realName;
@property (nonatomic,strong) NSString *uid;
//
@property (nonatomic,assign) NSInteger sex;
@property (nonatomic,assign) NSInteger isRealAuth;//实名状态 （0 没实名 1身份证和姓名 2身份证和姓名和真人 ）
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) NSInteger householderId;
@property (nonatomic,assign) NSInteger deleted;
//0703imid
@property (nonatomic,strong) NSString  *imId;
/**
 };
 user =         {
     avatarUrl = "https://dss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=393696030,2511566262&fm=26&gp=0.jpg";
     createTime = "2020-12-04 13:56:55";
     deleted = 0;
     detailAddress = "北京海淀区星光广场79号";
     householderId = 0;
     id = 822;
     idCard = 513029198610053056;
     isRealAuth = 0;
     mobile = 15182846302;
     realName = "张三锤";
     sex = 1;
     uid = d09bb8bac4fe442f8826a8c329c9cf2a;
     updateTime = "2020-12-29 10:50:46";
 };
};
 */
@end

NS_ASSUME_NONNULL_END
