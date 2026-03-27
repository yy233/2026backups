//
//  VoiceBasePopView.h
//  TUIVoiceRoom-TUIVoiceRoomKitBundle
//
//  Created by 余莹 on 2023/5/31.
//

#import <UIKit/UIKit.h>
#import "VoiceOcFileUse_Header.h"
NS_ASSUME_NONNULL_BEGIN

@protocol VoiceBasePopViewDelegate <NSObject>

- (void)basePopViewDelegateWithDissmissEndInfo;

@end

@interface VoiceBasePopView : UIView
@property (nonatomic,assign) float subMainViewHeight;//内容高度
@property (nonatomic,strong) UIView *subMainBackView;//显示内容的背景
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
- (void)showInView:(UIView *)supview thePopViewSubViewHeight:(float)subViewHeight WithArray:(NSMutableArray *)array;//默认窗口supview 在tableview请况时不会上下滑动
- (void)showInSuperviewWithSendSuperV:(UIView *)supview thePopViewSubViewHeight:(float)subViewHeight WithArray:(NSMutableArray *)array; //自己传的supview
- (void)dismissThePopView;

@property (nonatomic,weak) id <VoiceBasePopViewDelegate> basePopViewDelegate;

@end

NS_ASSUME_NONNULL_END
