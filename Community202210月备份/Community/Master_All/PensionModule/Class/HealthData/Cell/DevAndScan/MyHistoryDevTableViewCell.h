//
//  MyHistoryDevTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/12/6.
//

#import <UIKit/UIKit.h>
#import "DevGetNowUsersDevInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
 

@interface MyHistoryDevTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *statusShowBtn;
@property (nonatomic,strong) UIButton *rightClickBtn;

@property (nonatomic,copy) void(^historyDevDeletBlock)(void);

- (void)fillDataWithModel:(DevGetNowUsersDevInfoModel *)model;
@end

NS_ASSUME_NONNULL_END
