//
//  MyRepairEvaluationView.h
//  Community
//
//  Created by 余莹 on 2022/4/12.
//

#import <UIKit/UIKit.h>
#import "CDZStarsControl.h"

NS_ASSUME_NONNULL_BEGIN


@interface MyRepairEvaluationView : UIView
@property (nonatomic,strong) CDZStarsControl *starsControl;//星星
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;

@end

NS_ASSUME_NONNULL_END
