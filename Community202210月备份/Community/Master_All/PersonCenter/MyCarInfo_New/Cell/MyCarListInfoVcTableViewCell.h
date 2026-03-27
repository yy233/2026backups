//
//  MyCarListInfoVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/5/9.
//

#import <UIKit/UIKit.h>
#import "MyCarWithParkingSpotListVcCarPalteShowTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *MyCarListInfoVcTableViewCell_I = @"MyCarListInfoVcTableViewCell";

typedef void(^TouchDelActionBlock)(void);

@interface MyCarListInfoVcTableViewCell : MyCarWithParkingSpotListVcCarPalteShowTableViewCell

@property (nonatomic,strong) UIButton *deletBtn;
@property (nonatomic,copy) TouchDelActionBlock touchDelActionBlock;

@end


NS_ASSUME_NONNULL_END
