//
//  ZYFillSignPasswordView.h
//  Community
//
//  Created by ZY on 2021/6/2.
//

#import <UIKit/UIKit.h>

typedef void(^PWTextFieldBlock)(NSString * _Nullable pwStr);

@class ZYHideMenuFillTextField;

NS_ASSUME_NONNULL_BEGIN

@interface ZYFillSignPasswordView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

@property (nonatomic, strong) ZYHideMenuFillTextField *pwTF;

// 输入指定位数字符后的回调
@property(nonatomic, copy) PWTextFieldBlock block;

// 清空内容
- (void)clearText;

@end


@interface ZYHideMenuFillTextField : UITextField

@end

NS_ASSUME_NONNULL_END
