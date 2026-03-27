//
//  MyCarWithParkingSpotListVcCarPalteShowTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/5/6.
//

#import <UIKit/UIKit.h>
#import "BezierPathTool.h"
NS_ASSUME_NONNULL_BEGIN

static NSString *MyCarWithParkingSpotListVcCarPalteShowTableViewCell_I = @"MyCarWithParkingSpotListVcCarPalteShowTableViewCell";
static NSString *MyCarWithParkingSpotListVcCarPalteNilShowCanAddActionTableViewCell_I = @"MyCarWithParkingSpotListVcCarPalteNilShowCanAddActionTableViewCell";
static NSString *MyCarWithParkingSpotListVcCarPalteCanDeleteTableViewCell_I = @"MyCarWithParkingSpotListVcCarPalteCanDeleteTableViewCell";
static NSString *MyCarWithParkingSpotListVcBottomTableViewCell_I = @"MyCarWithParkingSpotListVcBottomTableViewCell";


@interface MyCarWithParkingSpotListVcCarPalteShowTableViewCell : BaseTableViewCell
@property (nonatomic,strong) LabelYu *carPlateL;
- (void)fillCarPlateStr:(NSString *)carPstr;
@end


typedef void(^TouchAddBtnBlock)(void);
@interface MyCarWithParkingSpotListVcCarPalteNilShowCanAddActionTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UIButton *topBtn;
@property (nonatomic,copy) TouchAddBtnBlock touchAddBtnBlock;
@end

typedef void(^TouchDeletBtnBlock)(void);
@interface MyCarWithParkingSpotListVcCarPalteCanDeleteTableViewCell : MyCarWithParkingSpotListVcCarPalteShowTableViewCell
@property (nonatomic,copy) TouchDeletBtnBlock touchDeletBtnBlock;
@end


@interface MyCarWithParkingSpotListVcBottomTableViewCell : UITableViewCell
@end

NS_ASSUME_NONNULL_END
