//
//  LoginView.h
//  test
//
//  Created by 余莹 on 2020/11/9.
//

#import <UIKit/UIKit.h>
#import <AuthenticationServices/AuthenticationServices.h>
NS_ASSUME_NONNULL_BEGIN

@protocol LoginViewTouchBtnDelegate <NSObject>

- (void)loginViewbtnTouchAction:(UIButton *)sender;

@end

@interface LoginView : UIView
@property (nonatomic,strong) UIView *topBackGroundView;
@property (nonatomic,strong) UIButton *removeSelfBtn;
@property (nonatomic,strong) UILabel  *topTitleLabel;
@property (nonatomic,strong) UILabel  *topDetailTitleLabel;

@property (nonatomic,strong) UIView *centerPhoneTextBackGroundView;
@property (nonatomic,strong) UILabel *phoneBeforeLabel;
@property (nonatomic,strong) UIButton *phoneBeforeBtn;//换
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UIView *centerPhoneTextLineView;

@property (nonatomic,strong) UIView *centerPasswordTextBackGroundView;
@property (nonatomic,strong) UITextField *passWordTextField;
@property (nonatomic,strong) UIImageView *passWordBeforeImg;
@property (nonatomic,strong) UIButton *passWordAfterBtn;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIView *centerPasswordTextLineView;

@property (nonatomic,strong) UIButton *forgotPasswordBtn;
@property (nonatomic,strong) UIButton *messageAuthenticationBtn;
@property (nonatomic,strong) UIButton *registBtn;

@property (nonatomic,strong) UIView *bottomBackGroundView;
@property (nonatomic,strong) UILabel *bottomTitleLabel;
@property (nonatomic,strong) UIButton *wxLoginBtn;
@property (nonatomic,strong) UIButton *zfbLoginBtn;
@property (nonatomic,strong) UIButton *appleLoginBtn;
//@property (nonatomic,strong) ASAuthorizationAppleIDButton *appleLoginBtn;//
@property (nonatomic,strong) UILabel *privacypolicyLabel;
@property (nonatomic,strong) UIButton *privacypolicyChooseBtn;

//
@property (nonatomic,weak) id <LoginViewTouchBtnDelegate>delegate;
@property (nonatomic,assign) BOOL isLoginView;
@property (nonatomic,strong) NSString *phoneStr;
@property (nonatomic,strong) NSString *passWordStr;
- (void)cleanAccountAndPasswordTextFiled;
- (void)showOrNotShowDeal:(BOOL)isShowView;
@end

NS_ASSUME_NONNULL_END
