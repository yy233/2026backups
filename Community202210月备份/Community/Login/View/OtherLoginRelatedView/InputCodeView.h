//
//  InputCodeView.h
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputCodeView : UIView
@property (nonatomic,strong) UILabel  *topDetailTitleLabel;
@property (nonatomic,strong) UIButton *removeSelfBtn;
@property (nonatomic,strong) UIButton *okBtn;
@property (nonatomic,strong) UIButton *onceCgainGetCodeBtn;

@property (nonatomic,strong) SMSCodeInputView *codeView;
- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
