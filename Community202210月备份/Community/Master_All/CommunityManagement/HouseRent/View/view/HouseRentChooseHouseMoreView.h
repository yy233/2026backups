//
//  HouseRentChooseHouseMoreView.h
//  Community
//
//  Created by 余莹 on 2021/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HouseRentChooseHouseMoreViewOkBtnDelegate <NSObject>
- (void)houseMoreChooseWithArr:(NSMutableArray *)arr;
@end

@interface HouseRentChooseHouseMoreView : UIView
- (void)showHouseMoreChooseViewWithAnimationWithDic:(NSDictionary *)dic withSelectModelArr:(NSMutableArray *)selectedModelArr;
- (void)hidenHouseMoreChooseViewWithAnimation;
@property (nonatomic,weak)id <HouseRentChooseHouseMoreViewOkBtnDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
