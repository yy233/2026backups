//
//  LoginViewWithTwoLoginFunction.h
//  Community
//
//  Created by 余莹 on 2021/3/24.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LoginViewWithMoreLoginFunction_ShowLoginFunction_CodeLoginShow,
    LoginViewWithMoreLoginFunction_ShowLoginFunction_AccountLoginShow,
} LoginViewWithMoreLoginFunction_ShowLoginFunction;

NS_ASSUME_NONNULL_BEGIN

typedef void(^GotoPrivacyAgreementVcBlock)(PrivacyAgreementVCLate *vc);

@interface LoginViewWithMoreLoginFunction : LoginView <UITextViewDelegate>
@property (nonatomic,assign) LoginViewWithMoreLoginFunction_ShowLoginFunction *showType;
//
@property (nonatomic,strong) UIButton *codeLoginTopTextBtn;
@property (nonatomic,strong) UIButton *accountLoginTopTextBtn;
 
@property (nonatomic,strong) UIView *centerCodeTextBackGroundView;
@property (nonatomic,strong) UITextField *codeTextField;
@property (nonatomic,strong) UIButton *codeAfterBtn;
@property (nonatomic,strong) NSString *codeStr;
- (void)countdown;

//隐私 0427
@property (nonatomic,strong) UIButton *agreeBtn;
@property (nonatomic,strong) UITextView *privacypolicyTextView;
@property (nonatomic,copy) GotoPrivacyAgreementVcBlock gotoPrivacyAgreementVcBlock;
@end

NS_ASSUME_NONNULL_END
