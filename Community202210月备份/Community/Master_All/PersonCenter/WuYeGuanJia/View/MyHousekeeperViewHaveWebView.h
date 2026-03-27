//
//  MyHousekeeperViewHaveWebView.h
//  Community
//
//  Created by 余莹 on 2022/4/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
 
@protocol  MyHousekeeperViewHaveWebViewDelegate <NSObject>

- (void)myHousekeeperViewTouchTopSdcyclviewWithIndex:(NSInteger)index;
- (void)myHousekeeperViewTouchBottomCellWithIndex:(NSInteger)index;
- (void)touchFooterBtnActionWithCallPhone;

@end


@interface MyHousekeeperViewHaveWebView : UIView

@property (nonatomic,weak) id <MyHousekeeperViewHaveWebViewDelegate> delegate; 

- (void)fillShowWebViewStr:(NSString *)showtext;
- (void)fillBannerData:(NSMutableArray *)bannerArr;
- (void)fillOnlyPhoneStr:(NSString *)onlyPhoneStr;

@end
NS_ASSUME_NONNULL_END
