//
//  MoneyOfThridJieBangEditVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/10/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoneyOfThridJieBangEditVcTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UITextField *textFiled;
- (void)setPlaceholderString:(NSString *)str;
@end


typedef void(^CodeRqBtnActionBlock)(void);
@interface MoneyOfThridJieBangEditVcTableViewCellHaveCodeRqBtn : MoneyOfThridJieBangEditVcTableViewCell
@property (nonatomic,strong) UIButton *codeRqBtn;
@property (nonatomic,copy) CodeRqBtnActionBlock touchCodeActionBlock;
@end
NS_ASSUME_NONNULL_END
