//
//  GuestInfoRegistionHaveStatusTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/5/19.
//

#import "GuestInfoRegistionTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *GuestInfoRegistionHaveStatusTableViewCell_I = @"GuestInfoRegistionHaveStatusTableViewCell";

@interface GuestInfoRegistionHaveStatusTableViewCell : GuestInfoRegistionTableViewCell
@property (nonatomic,strong) UIButton *cellInfoStatusBtn;

- (void)fillCellModel:(GuestInfoModel *)model;
@end

NS_ASSUME_NONNULL_END
