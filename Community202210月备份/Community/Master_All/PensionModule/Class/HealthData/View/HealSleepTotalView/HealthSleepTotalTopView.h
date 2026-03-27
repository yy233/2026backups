//
//  HealthSleepTotalTopView.h
//  Community
//
//  Created by 余莹 on 2021/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    SleepTotalTopView_SubBtn_Choose_Type_OneDay,//某天
    SleepTotalTopView_SubBtn_Choose_Type_OneWeak,//某周
} SleepTotalTopView_SubBtn_Choose_Type;
typedef void(^SleepTotalTopViewSubBtnChooseTypeBlock)(SleepTotalTopView_SubBtn_Choose_Type);
@interface HealthSleepTotalTopView : UIView

@property (nonatomic,strong) UIView *backConnectView;
@property (nonatomic,strong) UIButton *oneBtn;
@property (nonatomic,strong) UIButton *twoBtn;

@property (nonatomic,copy) SleepTotalTopViewSubBtnChooseTypeBlock chooseTypeBlock;


@end

NS_ASSUME_NONNULL_END
