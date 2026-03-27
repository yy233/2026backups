//
//  ZYPayPasswordInputView.h
//  Community
//
//  Created by ZY on 2021/10/16.
//

#import <UIKit/UIKit.h>

typedef void(^PWTextFieldBlock)(NSString * _Nullable pwStr);

@class ZYHideMenuPayTextField;

NS_ASSUME_NONNULL_BEGIN

@interface ZYPayPasswordInputView : UIView

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

@property (nonatomic, strong) ZYHideMenuPayTextField *pwTF;

// 输入指定位数字符后的回调
@property(nonatomic, copy) PWTextFieldBlock block;

// 清空内容
- (void)clearText;

@end


@interface ZYHideMenuPayTextField : UITextField

@end

NS_ASSUME_NONNULL_END
