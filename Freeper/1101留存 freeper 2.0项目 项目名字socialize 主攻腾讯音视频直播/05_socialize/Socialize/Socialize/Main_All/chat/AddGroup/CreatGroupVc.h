//
//  CreatGroupVc.h
//  Socialize
//
//  Created by 余莹 on 2023/8/18.
//

#import <UIKit/UIKit.h>
#import "TUICommonContactCell_Minimalist.h"
#define kScale UIScreen.mainScreen.bounds.size.width / 375.0

NS_ASSUME_NONNULL_BEGIN

@interface CreatGroupVc : Y_BaseViewController

@end

typedef void(^leftBtnActionBlock)(UIButton *sender,NSInteger index);
@interface CreatGroupVcSubCell : TUICommonContactCell_Minimalist
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,copy) leftBtnActionBlock btnActionBlock;
@end

NS_ASSUME_NONNULL_END
