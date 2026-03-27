//
//  MyCarWithParkingSpotListFooterView.h
//  Community
//
//  Created by 余莹 on 2022/5/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCarWithParkingSpotListFooterView : UIView
@property (nonatomic,strong) BaseTableViewFooterView *footerBtnV;
@property (nonatomic,strong) UILabel *showTextL;

- (void)fillTypeWithWhetherMoreCarBool:(BOOL)whetherMoreCarBool; 
@end

NS_ASSUME_NONNULL_END
