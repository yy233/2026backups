//
//  WeChatLoginUserModel.h
//  Community
//
//  Created by 余莹 on 2020/11/12.
// userinfo的数据两种

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeChatLoginUserModel : NSObject
@property (nonatomic,assign)NSInteger isBindMobile;
//绑定用的
@property (nonatomic,strong)NSString *thirdPlatformId;
//登录用的
@property (nonatomic,strong)NSString *token;
@property (nonatomic,strong)NSString *expiredTime;//token过期时间

//其他
@property (nonatomic ,strong) NSString *uid;
//UserModel
@property (nonatomic ,strong) NSString *area;
@property (nonatomic ,strong) NSString *avatarUrl;
@property (nonatomic ,strong) NSString *city;
@property (nonatomic ,strong) NSString *detailAddress;
@property (nonatomic ,strong) NSString *idCard;
@property (nonatomic ,assign) NSInteger isRealAuth;
@property (nonatomic ,strong) NSString *nickname;
@property (nonatomic ,strong) NSString *realName;
@property (nonatomic ,strong) NSString *province;
@property (nonatomic ,assign) NSInteger sex;
@property (nonatomic, strong) UserModel *userInfo;//用户模型 


 

 

 
/**
 绑定用的
 userInfo =     {
     isBindMobile = 0;
     weChatId = 32951751850201088;
 };
 
 登录用的
 token = aaaea41dff5f422e8aa4bb8d9b023db7;
 userInfo =     {
     avatarUrl = "https://dss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=393696030,2511566262&fm=26&gp=0.jpg";
     detailAddress = "\U91cd\U5e86\U5e02\U957f\U5bff\U533a\U957f\U5bff\U6e56\U9547\U957f\U72ee\U8def25\U53f71-6";
     idCard = 500221199403290922;
     isBindMobile = 1;
     isRealAuth = 2;
     nickname = "\U95fe\U4e18\U957f\U5f81";
     realName = "\U4f59\U83b9";
     sex = 2;
     uid = test123;
 };
 
 
 
 }*/
@end

NS_ASSUME_NONNULL_END
