//
//  ZYElectronicSignPasswordChangedCell.h
//  Community
//
//  Created by ZY on 2021/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYElectronicSignPasswordChangedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *oldPWTF;

@property (weak, nonatomic) IBOutlet UITextField *pwTF;

@property (weak, nonatomic) IBOutlet UITextField *verifyPWTF;

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (weak, nonatomic) IBOutlet UIButton *forgetButton;

@end

NS_ASSUME_NONNULL_END
