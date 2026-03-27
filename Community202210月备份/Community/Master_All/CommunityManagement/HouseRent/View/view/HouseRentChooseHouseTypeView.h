//
//  HouseRentChooseHouseTypeView.h
//  Community
//
//  Created by 余莹 on 2021/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HouseRentChooseHouseTypeViewOkBtnDelegate <NSObject>
- (void)houseTypeIsChooseWithShiNum:(NSInteger)s withTingNum:(NSInteger)t withWeiNum:(NSInteger)w;
- (void)houseChooseBuXianBtnActionWithZeroNum;
@end

@interface HouseRentChooseHouseTypeView : UIView
@property (nonatomic,weak) id <HouseRentChooseHouseTypeViewOkBtnDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
