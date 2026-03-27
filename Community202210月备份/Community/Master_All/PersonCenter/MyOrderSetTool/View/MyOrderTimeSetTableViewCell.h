//
//  MyOrderTimeSetTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderTimeSetTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *detailTextL;
@property (nonatomic,strong) UIButton *editBtn;
@property (nonatomic,strong) UISwitch *openSwith;
@end

NS_ASSUME_NONNULL_END
