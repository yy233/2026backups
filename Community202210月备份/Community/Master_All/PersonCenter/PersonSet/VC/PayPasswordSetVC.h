//
//  PayPasswordSetVC.h
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#import "BaseViewControllerNotNoticeWithUI.h"

typedef enum : NSUInteger {
    Set_Password_Type_Login, //登录密码设置
    Set_Password_Type_Pay, //支付密码设置
} Set_Password_Type;

NS_ASSUME_NONNULL_BEGIN

@interface PayPasswordSetVC : BaseViewController //NotNoticeWithUI

@property (nonatomic, assign) Set_Password_Type type;

@end

NS_ASSUME_NONNULL_END
