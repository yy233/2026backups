//
//  RegistViewLastSubTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegistViewLastSubNomalTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *bottomLineView;
@property (nonatomic,strong) UIButton *leftShowBtn;
@property (nonatomic,strong) UITextField *textF;
- (void)setTextPStr:(NSString *)pStr;
@end

//typedef void(^TouchCodeBtnActionBlock)(UIButton *);
@interface RegistViewLastSubHaveSendCodeBtnTableViewCell : RegistViewLastSubNomalTableViewCell
@property (nonatomic,strong) UIButton *rightSendCodeBtn;
//@property (nonatomic,copy) TouchCodeBtnActionBlock touchCodeBtnActionBlock;
//MARK: 倒计时
- (void)countdown;

@end
@interface RegistViewLastSubLeftIsPhoneTextBeginTableViewCell : RegistViewLastSubNomalTableViewCell 
@end

@interface RegistViewLastSubPasswordTextLeftIsSuoBtnAndRightIsEyeBtnTableViewCell : RegistViewLastSubNomalTableViewCell
@end
NS_ASSUME_NONNULL_END
