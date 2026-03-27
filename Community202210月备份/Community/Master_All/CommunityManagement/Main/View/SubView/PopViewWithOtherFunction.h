//
//  PopViewWithOtherFunction.h
//  Community
//
//  Created by 余莹 on 2021/3/22.
//

#import <UIKit/UIKit.h>
#import "BasePopView.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    PopViewWithOtherFunction_Type_forum=0,
    PopViewWithOtherFunction_Type_shortvideo=1,
    PopViewWithOtherFunction_Type_chat=2,
    PopViewWithOtherFunction_Type_fleaMarket=3,
    PopViewWithOtherFunction_Type_DisMissPopView=10,//单个的取消 用于按钮状态的ui更改
} PopViewWithOtherFunction_Type;

@protocol PopViewWithOtherFunctionDelegate <NSObject>

- (void)popViewOtherFunctionSubTouchPopViewWithOtherFunction:(PopViewWithOtherFunction_Type)type;

@end

@interface PopViewWithOtherFunction : BasePopView
@property (nonatomic,weak) id <PopViewWithOtherFunctionDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
