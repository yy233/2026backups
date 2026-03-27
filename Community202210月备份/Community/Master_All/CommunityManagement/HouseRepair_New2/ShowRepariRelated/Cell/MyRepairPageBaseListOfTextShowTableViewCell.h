//
//  MyRepairPageBaseListOfTextShowTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/4/11.
//

#import <UIKit/UIKit.h>
#import "MyRepairPageListUseModel.h"

NS_ASSUME_NONNULL_BEGIN
static NSString *MyRepairPageBaseListOfTextShowTableViewCell_I = @"MyRepairPageBaseListOfTextShowTableViewCell";

@interface MyRepairPageBaseListOfTextShowTableViewCell : BaseTableViewCell

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *textL;

- (void)fillDataWithModel:(MyRepairPageListUseModel *)model;

@end

NS_ASSUME_NONNULL_END
