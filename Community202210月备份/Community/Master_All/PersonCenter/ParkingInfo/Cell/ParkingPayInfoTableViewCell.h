//
//  ParkingPayInfoTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/8/7.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ParkingPayInfo_Type_Temporary, //临时
    ParkingPayInfo_Type_Monthly, //月租
} ParkingPayInfo_Type;

NS_ASSUME_NONNULL_BEGIN

@interface ParkingPayInfoTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UIButton *typeInfoBtn;
- (void)setTypeTemporary;
- (void)setTypeMonth;
@end
@interface ParkingPayInfoOnlyTextTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *textAllShowL;
@end
@interface ParkingPayInfoOnlyTextColorRedTableViewCell : ParkingPayInfoOnlyTextTableViewCell
@end
NS_ASSUME_NONNULL_END
