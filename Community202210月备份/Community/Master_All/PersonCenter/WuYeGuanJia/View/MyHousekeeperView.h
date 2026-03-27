//
//  MyHousekeeperView.h
//  Community
//
//  Created by 余莹 on 2021/7/28.
// 物业管家view 0409弃用 换版

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol  MyHousekeeperViewDelegate <NSObject>

- (void)myHousekeeperViewTouchTopSdcyclviewWithIndex:(NSInteger)index;
- (void)myHousekeeperViewTouchBottomCellWithIndex:(NSInteger)index;
- (void)touchFooterBtnActionWithCallPhone;
@end


@interface MyHousekeeperView : UIView
@property (nonatomic,weak) id <MyHousekeeperViewDelegate> delegate;
- (void)fillBText:(NSString *)showtext;
- (void)fillBannerData:(NSMutableArray *)bannerArr;
- (void)fillCellData:(NSMutableArray *)dataSourceArr;
- (void)fillOnlyPhoneStr:(NSString *)onlyPhoneStr;
@end

NS_ASSUME_NONNULL_END
