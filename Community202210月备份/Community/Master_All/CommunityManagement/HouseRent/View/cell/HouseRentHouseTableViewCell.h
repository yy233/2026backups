//
//  HouseRentHouseTableViewCell.h
//  Community
//
//  Created by 余莹 on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentHouseTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *backGroundV;
@property (nonatomic,strong) UIImageView *headImgv;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailtitleLabel;
@property (nonatomic,strong) UILabel *coseL;//费用
@property (nonatomic,strong) UIView *typeBackView;//类型的backv

@property (nonatomic,strong) UILabel *typeModelLabel;//整租合租

@property (nonatomic,strong) HouseRentListVcHouseCellModel *houseCellmodel;
@end

NS_ASSUME_NONNULL_END
 
