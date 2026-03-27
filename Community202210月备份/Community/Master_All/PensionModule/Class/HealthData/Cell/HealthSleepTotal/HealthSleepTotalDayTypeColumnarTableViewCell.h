//
//  HealthSleepTotalDayTypeColumnarTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/11/18.
//

#import <UIKit/UIKit.h>
#import "HealthSleepTotalTableViewCellSubColorAndTextBtnTool.h"
#import "BaseHealthHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface HealthSleepTotalDayTypeColumnarTableViewCell : HealthBaseTotalDataContTouchTableViewCell
@property (nonatomic,strong) UIButton *oneSingBtn;
@property (nonatomic,strong) UIButton *twoSingBtn;
@property (nonatomic,strong) UIButton *thrSingBtn;
@property (nonatomic,strong) UIView *oneView;
@property (nonatomic,strong) UIView *twoView;
@property (nonatomic,strong) UIView *thrView;

- (void)fillDataWithAllTimeNum:(NSInteger)allT withDeepSleepTime:(NSInteger)deepT withLightSleepTime:(NSInteger)lightT withAwakeSleepTime:(NSInteger)awakeT;
/**
 /// 入睡
   ZHJSleepTypeBegin = 0x01,
 /// 浅睡
   ZHJSleepTypeLight = 0x02,
 /// 深睡
   ZHJSleepTypeDeep = 0x03,
 /// 清醒
   ZHJSleepTypeAwake = 0x04,
 /// 快速眼动睡眠
   ZHJSleepTypeREM = 0x05,
 */

@end

NS_ASSUME_NONNULL_END
