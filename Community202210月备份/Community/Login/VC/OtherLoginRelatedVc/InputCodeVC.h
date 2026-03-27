//
//  CodeViewController.h
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    BindThrid_Type_WX,
    BindThrid_Type_ZFB,
    BindThrid_Type_Apple,
} BindThrid_Type;
@interface InputCodeVC : BaseHiddenNavViewController
@property (nonatomic,strong) NSString *phoneStr;
@property (nonatomic,strong) WeChatLoginUserModel *wxUserModel;
@property (nonatomic,strong) ZFBLoginModel *zfbUserModel;
@property (nonatomic,strong) AppleLoginModel *appleUserModel;
@end

NS_ASSUME_NONNULL_END
