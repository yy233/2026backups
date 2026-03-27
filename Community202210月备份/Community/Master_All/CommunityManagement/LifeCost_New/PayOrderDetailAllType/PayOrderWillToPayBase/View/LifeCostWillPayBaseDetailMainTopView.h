//
//  LifeCostWillPayBaseDetailHeaderView.h
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostWillPayBaseDetailMainTopView : UIView
@property (nonatomic,strong) UIImageView *bgImgV;
@property (nonatomic,strong) UIView *contentSubVBackView;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UIView *shadowView;
@property (nonatomic,strong) UILabel *moneySignL;
@property (nonatomic,strong) UILabel *moneyNumL;
@property (nonatomic,strong) UILabel *bottomL;
@property (nonatomic,strong) UILabel *lineV;
- (void)fillTopViewDataWithImgUrlStr:(NSString *)imgUrlStr withMoneyNumStr:(NSString *)moneyNumStr;
@end

NS_ASSUME_NONNULL_END
