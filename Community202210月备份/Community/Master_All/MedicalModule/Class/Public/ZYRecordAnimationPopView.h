//
//  ZYRecordAnimationPopView.h
//  Community
//
//  Created by ZY on 2021/12/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYRecordAnimationPopViewDelegate <NSObject>

- (void)popViewEvent;

- (void)closeButtonEvent;

@end

@interface ZYRecordAnimationPopView : UIView

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, weak) id<ZYRecordAnimationPopViewDelegate> delegate;

// 显示视图
- (void)showRecordAnimationPopView;

// 隐藏视图
- (void)hiddenRecordAnimationPopView;

@end

NS_ASSUME_NONNULL_END
