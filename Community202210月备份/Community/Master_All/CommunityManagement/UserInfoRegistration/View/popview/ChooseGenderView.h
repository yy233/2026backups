//
//  ChooseGenderView.h
//  Community
//
//  Created by 余莹 on 2020/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    Choose_Gender_unknown=0,
    Choose_Gender_man=1,
    Choose_Gender_woman=2,
} Choose_Gender_Num;

@protocol ChooseGenderViewDelegate <NSObject>
- (void)chooseGender:(Choose_Gender_Num)indexGenderNum;
@end

@interface ChooseGenderView : UIView
@property (nonatomic,weak) id <ChooseGenderViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
