//
//  UserModel.h
//  投票
//
//  Created by yy on 17/3/3.
//  Copyright © 2017年 yy. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UserModel : NSObject

@property (nonatomic ,strong) NSString *area;
@property (nonatomic ,strong) NSString *avatarUrl;
@property (nonatomic ,strong) NSString *city;
@property (nonatomic ,strong) NSString *detailAddress;
@property (nonatomic ,assign) NSInteger id;
@property (nonatomic ,strong) NSString *idCard;
@property (nonatomic ,assign) NSInteger isRealAuth;
@property (nonatomic ,strong) NSString *nickname;
@property (nonatomic ,strong) NSString *realName;
@property (nonatomic ,strong) NSString *province;
@property (nonatomic ,assign) NSInteger sex;
@property (nonatomic, copy) NSString *uid;

// 是否设置密码
@property (nonatomic, assign) BOOL isBindPassword;
// 是否绑定手机1已绑定，0未绑定
@property (nonatomic, assign) BOOL isBindMobile;
// 是否iOS绑定
@property (nonatomic, assign) BOOL isBindIOS;
// 是否绑定微信1已绑定，0未绑定
@property (nonatomic, assign) BOOL isBindWechat;
// 是否绑定支付宝1已绑定，0未绑定
@property (nonatomic, assign) BOOL isBindAlipay;
// 是否设置支付密码1已支付，0未支付
@property (nonatomic, assign) BOOL isBindPayPassword;
//
//@property (nonatomic ,strong) NSString *avatarUrl;
@property (nonatomic ,strong) NSString *birthdayTime;
//@property (nonatomic ,strong) NSString *nickname;
@property (nonatomic ,strong) NSString *mobile;
//聊天用的ID
@property (nonatomic, copy) NSString *imId;
//0901聊天用的password
@property (nonatomic, copy) NSString *imPassword;

//当前 位置信息
//非 小区经纬度
@property (nonatomic,assign) float nowLatitude;//纬度
@property (nonatomic,assign) float nowLongitude;//经度

@end
