//
//  ParkingTemporaryTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/8/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^editBtnActionBlock)();
@interface ParkingTemporaryTableViewCell : BaseTableViewCell

@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UIButton *editBtn;
@property (nonatomic,strong) UIButton *typeInfoBtn;

@property (nonatomic,copy) editBtnActionBlock eBlock;
@end

NS_ASSUME_NONNULL_END
