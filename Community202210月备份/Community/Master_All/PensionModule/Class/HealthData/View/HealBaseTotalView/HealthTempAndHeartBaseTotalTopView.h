//
//  HealthTempTotalTopView.h
//  Community
//
//  Created by 余莹 on 2021/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

 

typedef enum : NSUInteger {
    TempAndHeartTotalTopView_SubBtn_Choose_Type_ThisDay,//某天
    TempAndHeartTotalTopView_SubBtn_Choose_Type_ThisWeak,//某周
    TempAndHeartTotalTopView_SubBtn_Choose_Type_ThisMonth,//某月份
} TempAndHeartTotalTopView_SubBtn_Choose_Type;

typedef void(^TempAndHeartTotalTopViewSubBtnChooseTypeBlock)(TempAndHeartTotalTopView_SubBtn_Choose_Type);

@interface HealthTempAndHeartBaseTotalTopView : UIView

@property (nonatomic,strong) UIView *backConnectView;
@property (nonatomic,strong) UIButton *oneBtn;
@property (nonatomic,strong) UIButton *twoBtn;
@property (nonatomic,strong) UIButton *thrBtn;

@property (nonatomic,copy) TempAndHeartTotalTopViewSubBtnChooseTypeBlock chooseTypeBlock;

@end

NS_ASSUME_NONNULL_END
