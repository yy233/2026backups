//
//  ZFBUserModel.h
//  Community
//
//  Created by 余莹 on 2020/11/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFBLoginModel : WeChatLoginUserModel


//改成微信的流程结构
//@property (nonatomic,assign)NSInteger thirdPlatformType;
//@property (nonatomic,strong)NSString *authCode;
//@property (nonatomic,strong)NSString *data;

/**
 
 data = 35525631173332992;
 exists = 0;
 绑定用的数据
 "thirdPlatformType":1,
 "authCode":前台获取,
 "mobile":15900000001,
 "code":"1111"
}
 */
@end

NS_ASSUME_NONNULL_END
