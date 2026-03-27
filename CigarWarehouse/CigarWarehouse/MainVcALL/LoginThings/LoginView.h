//
//  LoginView.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *LoginViewSubCell_I = @"LoginViewSubCell";
@interface LoginViewSubCell : UITableViewCell
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIImageView *leftIcon;
@property (nonatomic,strong) UIButton *rightBtn;
@end


@interface LoginView : UIView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *hv;
@property (nonatomic,strong) UserLoginUseModel *loginUseModel;
- (void)fillLoginInfoAccountStr:(NSString *)astr withPasswordStr:(NSString *)pstr;
@end

NS_ASSUME_NONNULL_END
