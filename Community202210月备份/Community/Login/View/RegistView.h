//
//  RegistView.h
//  Community
//
//  Created by 余莹 on 2020/11/13.
// 用作验证码登录 没用注册 有做新注册页

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RegistViewDelegate   <NSObject>
- (void)registViewViewSubBtnAction:(UIButton *)sender;
@end
@interface RegistView : UIView
@property (nonatomic,weak)id <RegistViewDelegate> delegate;
@property (nonatomic,strong) NSString *phoneStr;
@property (nonatomic,strong) NSString *codeStr;
- (void)countdown;
@end

NS_ASSUME_NONNULL_END
