//
//  ZhuBoInfoBottomItemView.h
//  Socialize
//
//  Created by 余莹 on 2023/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol ZhuBoInfoBottomItemViewDelegate <NSObject>

- (void)touchAtMe;
- (void)touchSiXin;
- (void)touchGuanZhu;

@end

@interface ZhuBoInfoBottomItemView : UIView
@property (nonatomic,strong) UIButton *callATMeBtn;
@property (nonatomic,strong) UIButton *siXinBtn;
@property (nonatomic,strong) UIButton *guanZhuBtn;

@property (nonatomic,weak) id <ZhuBoInfoBottomItemViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
