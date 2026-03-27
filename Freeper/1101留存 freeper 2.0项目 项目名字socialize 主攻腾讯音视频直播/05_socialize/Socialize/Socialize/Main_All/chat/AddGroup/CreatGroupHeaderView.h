//
//  CreatGroupHeaderView.h
//  Socialize
//
//  Created by 余莹 on 2023/8/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreatGroupHeaderView : UIView
@property (nonatomic,strong) UIView *titleBk;
@property (nonatomic,strong) UILabel *titleBottomL;
@property (nonatomic,strong) UITextField *textFied;
@property (nonatomic,strong) UIView *chooseVerifTypeBk;
@property (nonatomic,strong) UILabel *verifmainL;
@property (nonatomic,strong) UILabel *verifBottomL;
@property (nonatomic,strong) UISwitch *verSwitch;
 

@end

NS_ASSUME_NONNULL_END
