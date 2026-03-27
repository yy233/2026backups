//
//  AccompanyNavView.h
//  Community
//
//  Created by 余莹 on 2020/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    Accompany_Type_Person,
    Accompany_Type_Car,
} Accompany_Type;
@protocol AccompanyNavViewChooseDelegate <NSObject>
- (void)accompanyNavViewSubBtnTouchChooseType:(Accompany_Type)type;
@end
@interface AccompanyNavView : UIView
@property (nonatomic,strong) UIButton *choosePersonBtn;
@property (nonatomic,strong) UIButton *chooseCarBtn;
@property (nonatomic,weak) id<AccompanyNavViewChooseDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
