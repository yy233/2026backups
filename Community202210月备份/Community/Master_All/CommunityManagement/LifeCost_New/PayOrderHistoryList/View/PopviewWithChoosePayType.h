//
//  PopviewWIthChoosePayType.h
//  Community
//
//  Created by 余莹 on 2022/1/5.
//

#import <UIKit/UIKit.h>
#import "PopviewWithBaseChoose.h"
#import "LifeCostPayTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PopviewWithChoosePayTypeDelegate <NSObject>

- (void)popViewChooseALlPayType;
- (void)popViewChoosePayTypeWithModel:(LifeCostPayTypeModel *)model;

@end

@interface PopviewWithChoosePayType : PopviewWithBaseChoose <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,weak) id <PopviewWithChoosePayTypeDelegate> delegagtePayType;
@property (nonatomic, strong) UIPickerView *typePickV;
@end

NS_ASSUME_NONNULL_END
