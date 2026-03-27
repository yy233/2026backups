//
//  ActivityInputInfoVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/6/7.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *ActivityInputInfoVcTableViewCell_I = @"ActivityInputInfoVcTableViewCell";
static NSString *ActivityInputInfoVcTextFieldTableViewCell_I = @"ActivityInputInfoVcTextFieldTableViewCell";


@interface ActivityInputInfoVcTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *titleL;
@end

@interface ActivityInputInfoVcTextFieldTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UITextField *textF;
@property (nonatomic,strong) UIView *lineV;
- (void)changePlaceholderStrInfoWithStr:(NSString *)pstr;
@end


NS_ASSUME_NONNULL_END
