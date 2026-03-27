//
//  MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/9/6.
//

#import <UIKit/UIKit.h>
#import "MainImInfoSubMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *MainAllTypeInformationSubPayMoneyTypeListVcTableViewCellLate_I = @"MainAllTypeInformationSubPayMoneyTypeListVcTableViewCellLate";
static NSString *MainAllTypeInformationSubPayMoneyTypeListVcPayTypeTableViewCell_I = @"MainAllTypeInformationSubPayMoneyTypeListVcPayTypeTableViewCell";

@interface MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell : BaseTableViewCell
- (void)fillPayMoneyTypeDataWithModel:(MainImInfoSubMsgModel *)model;

@end

@interface MainAllTypeInformationSubPayMoneyTypeListVcTableViewCellLate : MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell
@property (nonatomic,strong) UIButton *showDetailBtn;
@end

@interface MainAllTypeInformationSubPayMoneyTypeListVcPayTypeTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *lineV;
@end
NS_ASSUME_NONNULL_END
