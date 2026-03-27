//
//  LoginView.h
//  Socialize
//
//  Created by 余莹 on 2023/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    Login_Type_local,
    Login_Type_outside,
} Login_Type;

@protocol LoginViewDelegate <NSObject>

- (void)touchLoginWithType:(Login_Type)type;

@end


@interface LoginView : UIView
@property (nonatomic,strong) UIImageView *loginBkView;
@property (nonatomic,strong) UIImageView *headerImgv;
@property (nonatomic,strong) UILabel *logoLabel;
@property (nonatomic,strong) UIButton *oneLoginBtn;
@property (nonatomic,strong) UIButton *twoLoginBtn;
@property (nonatomic,strong) UIButton *agreeBtn;
@property (nonatomic,strong) UILabel *agreeL;


@property (nonatomic,weak) id<LoginViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
