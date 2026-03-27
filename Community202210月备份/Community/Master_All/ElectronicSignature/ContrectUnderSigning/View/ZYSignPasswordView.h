//
//  ZYSignPasswordView.h
//  Community
//
//  Created by ZY on 2021/5/31.
//

#import <UIKit/UIKit.h>

typedef void(^PWTextFieldBlock)(NSString * _Nullable pwStr);

@class ZYHideMenuTextField;

NS_ASSUME_NONNULL_BEGIN

@interface ZYSignPasswordView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (nonatomic, strong) ZYHideMenuTextField *pwTF;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *hintView;

// 输入指定位数字符后的回调
@property(nonatomic, copy) PWTextFieldBlock block;

// 清空内容
- (void)clearText;

@end


@interface ZYHideMenuTextField : UITextField

@end


NS_ASSUME_NONNULL_END
