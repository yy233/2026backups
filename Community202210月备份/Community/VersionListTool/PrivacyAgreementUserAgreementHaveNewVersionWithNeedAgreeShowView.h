//
//  PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView.h
//  Community
//
//  Created by 余莹 on 2022/4/27.
// 隐私协议 用户协议 的更新弹出框

#import <UIKit/UIKit.h>
#import "PrivacyAgreementUserAgreementTool.h"
NS_ASSUME_NONNULL_BEGIN

//ExitActionWithCleanOrChangeUserInfoTool

typedef void(^NotAgreeActionBlock)(void);
typedef void(^GotoPrivacyAgreementVcBlock)(PrivacyAgreementVCLate *vc);


@interface PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView : UIView

@property (nonatomic,copy) NotAgreeActionBlock notAgreeActionBlock;
@property (nonatomic,copy) GotoPrivacyAgreementVcBlock gotoPrivacyAgreementVcBlock;


- (void)fillNewPrivacyAgreementUserAgreementVersionInfo:(AllAgreementUseModel *)model;

@end

NS_ASSUME_NONNULL_END
