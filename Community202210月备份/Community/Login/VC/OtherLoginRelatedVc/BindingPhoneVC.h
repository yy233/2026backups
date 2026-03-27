//
//  BindingPhoneVC.h
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BindingPhoneVC : BaseHiddenNavViewController
@property (nonatomic,strong) WeChatLoginUserModel *wxUsermodel;
@property (nonatomic,strong) ZFBLoginModel *zfbUserModel;
@property (nonatomic,strong) AppleLoginModel *appleUserModel;
@end

NS_ASSUME_NONNULL_END
