//
//  LoginAndRegiestViewSubLoginBtnAndOtherBtnView.h
//  Community
//
//  Created by 余莹 on 2022/5/13.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegiestViewUseTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginAndRegiestViewSubLoginBtnAndOtherBtnView : UIView
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *changeLoginTypeBtn;
@property (nonatomic,strong) UIButton *forgotPasswordBtn;
- (void)setThisViewShowType:(LoginAndRegiestVC_Show_Type)type;

@end

NS_ASSUME_NONNULL_END
