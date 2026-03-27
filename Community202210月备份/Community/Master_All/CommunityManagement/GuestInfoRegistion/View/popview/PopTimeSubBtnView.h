//
//  PopTimeSubBtnView.h
//  Community
//
//  Created by 余莹 on 2020/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    PopTimeSubBtnView_Type_Nomal,
    PopTimeSubBtnView_Type_Seleced_Begin,
    PopTimeSubBtnView_Type_Seleced_End,
    PopTimeSubBtnView_Type_HeightLight,
} PopTimeSubBtnView_Type;
@interface PopTimeSubBtnView : UIView
@property (nonatomic,strong) UIButton *btn;
- (void)setBtnViewType:(PopTimeSubBtnView_Type)type;
@end

NS_ASSUME_NONNULL_END
