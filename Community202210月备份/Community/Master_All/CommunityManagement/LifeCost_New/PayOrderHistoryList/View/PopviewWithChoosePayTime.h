//
//  PopviewWithChoosePayTime.h
//  Community
//
//  Created by 余莹 on 2022/1/5.
//

#import <UIKit/UIKit.h>
#import "PopviewWithBaseChoose.h"
NS_ASSUME_NONNULL_BEGIN

@protocol PopviewWithChoosePayTimeDelegate <NSObject>

- (void)popViewChooseALlPayTime;
- (void)popViewChoosePayTimeWitYearAndMonthStr:(NSString *)yearAndMonthStr;

@end

@interface PopviewWithChoosePayTime : PopviewWithBaseChoose <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,weak) id <PopviewWithChoosePayTimeDelegate> delegagtePayTime;
@property (nonatomic, strong) UIPickerView *timePickV;
@end 

NS_ASSUME_NONNULL_END
