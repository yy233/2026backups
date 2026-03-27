//
//  LoginAndRegiestViewSubBottomView.h
//  Community
//
//  Created by 余莹 on 2022/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginAndRegiestViewSubBottomView : UIView <UITextViewDelegate>
@property (nonatomic,strong) UIButton *agreeBtn;
@property (nonatomic,strong) UITextView *privacypolicyTextView;
@property (nonatomic,strong) UILabel *minFontLabel;
@property (nonatomic,copy) GotoPrivacyAgreementVcBlock gotoPrivacyAgreementVcBlock;

@end

NS_ASSUME_NONNULL_END
