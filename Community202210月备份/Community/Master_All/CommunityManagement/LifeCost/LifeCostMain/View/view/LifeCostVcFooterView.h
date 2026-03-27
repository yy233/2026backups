//
//  LifeCostVcFooterView.h
//  Community
//
//  Created by 余莹 on 2021/1/9.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LifeCostVcFooter_Btn_Type_CostList,
    LifeCostVcFooter_Btn_Type_CostSet,
    LifeCostVcFooter_Btn_Type_CostCardIdManager,
    LifeCostVcFooter_Btn_Type_Help,
} LifeCostVcFooter_Btn_Type;

@protocol  LifeCostVcFooterViewDelegate <NSObject>
- (void)footerViewChooseBtnWith:(LifeCostVcFooter_Btn_Type)btnType;
@end
@interface LifeCostVcFooterView : UIView
@property (nonatomic,weak) id<LifeCostVcFooterViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
