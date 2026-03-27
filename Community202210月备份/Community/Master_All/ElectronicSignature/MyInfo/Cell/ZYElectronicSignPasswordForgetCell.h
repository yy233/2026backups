//
//  ZYElectronicSignPasswordForgetCell.h
//  Community
//
//  Created by ZY on 2021/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYElectronicSignPasswordForgetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *pwTF;

@property (weak, nonatomic) IBOutlet UITextField *verifyPWTF;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property (weak, nonatomic) IBOutlet UIButton *okButton;

// 验证码倒计时
- (void)countdown;

@end

NS_ASSUME_NONNULL_END
