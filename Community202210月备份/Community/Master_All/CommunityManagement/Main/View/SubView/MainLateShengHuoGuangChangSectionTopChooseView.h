//
//  MainLateShengHuoGuangChangSectionTopChooseView.h
//  Community
//
//  Created by 余莹 on 2021/8/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

 

typedef void(^MainLateShengHuoGuangChangSectionTopChooseBtnTouchBlock)(MainLateShengHuoGuangChangCell_TopHeader_Type);

@interface MainLateShengHuoGuangChangSectionTopChooseView : UIView
@property (nonatomic,strong) UIButton *oneBtn;
@property (nonatomic,strong) UIButton *twoBtn;
@property (nonatomic,copy) MainLateShengHuoGuangChangSectionTopChooseBtnTouchBlock btnTouchBlock;

- (void)fillTypeWithIsZuFangOneBtnSelectedBoolShow:(BOOL)isZuFangBool;
- (void)setTheme;//主题色更换后调用
@end

NS_ASSUME_NONNULL_END
