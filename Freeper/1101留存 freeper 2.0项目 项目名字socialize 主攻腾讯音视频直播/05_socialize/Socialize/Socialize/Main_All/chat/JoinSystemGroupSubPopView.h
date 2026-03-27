//
//  JoinSystemGroupSubPopView.h
//  Socialize
//
//  Created by 余莹 on 2023/7/10.
//

#import <UIKit/UIKit.h>
#import "BasePopView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JoinSystemGroupSubPopViewDelegate <NSObject>

- (void)touchOkOfJoinSystem;

@end

@interface JoinSystemGroupSubPopView : BasePopView
@property (nonatomic,strong) UIView *showUseBackView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UITextField *textF;
@property (nonatomic,strong) UILabel *showCodeInfoL;
@property (nonatomic,strong) UIButton *changeCodeBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *okBtn;

@property (nonatomic,assign) id <JoinSystemGroupSubPopViewDelegate>joinGroupDelegate;

@end

NS_ASSUME_NONNULL_END
