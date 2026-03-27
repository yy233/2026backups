//
//  YuEMingXiHeaderView.h
//  Community
//
//  Created by 余莹 on 2021/2/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YuEMingXi_Type_ALL,
    YuEMingXi_Type_ZhiChu,
    YuEMingXi_Type_ShouRu,
} YuEMingXi_Type;

@protocol YuEMingXiHeaderViewDelegate <NSObject>
- (void)headerViewTouchSubBtnWithType:(YuEMingXi_Type)type;

@end

@interface YuEMingXiHeaderView : UIView
@property (nonatomic,weak) id <YuEMingXiHeaderViewDelegate> delegage;
@end

NS_ASSUME_NONNULL_END
