//
//  BasePopView.h
//  Community
//
//  Created by 余莹 on 2020/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BasePopViewDelegate <NSObject>

- (void)basePopViewDelegateWithDissmissEndInfo;

@end

@interface BasePopView : UIView
@property (nonatomic,assign) float subMainViewHeight;//内容高度
@property (nonatomic,strong) UIView *subMainBackView;//显示内容的背景
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
- (void)showInView:(UIView *)supview thePopViewSubViewHeight:(float)subViewHeight WithArray:(NSMutableArray *)array;//默认窗口supview 在tableview请况时不会上下滑动
- (void)showInSuperviewWithSendSuperV:(UIView *)supview thePopViewSubViewHeight:(float)subViewHeight WithArray:(NSMutableArray *)array; //自己传的supview
- (void)dismissThePopView;

@property (nonatomic,weak) id <BasePopViewDelegate> basePopViewDelegate;
@end

NS_ASSUME_NONNULL_END
