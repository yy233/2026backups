//
//  LoginAndRegiestMianView.h
//  Community
//
//  Created by 余莹 on 2022/5/13.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegiestNewHeader.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LoginAndRegiestMianViewDelegate <NSObject>

- (void)thisViewTouchSubViewItemWithTag:(NSInteger)tag;

@end


@interface LoginAndRegiestMianView : UIView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UIImageView *mainBkImgView;
//
@property (nonatomic,strong) LoginAndRegiestViewSubTopView *topView;
@property (nonatomic,strong) LoginAndRegiestViewSubBottomView *bottomView;
@property (nonatomic,strong) LoginAndRegiestViewSubThirdLoginView *thirdLoginView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) LoginAndRegiestViewSubLoginBtnAndOtherBtnView *loginCenterBtnsView;
//
@property (nonatomic,strong) NSString *phoneStr;
@property (nonatomic,strong) NSString *codeStr;
@property (nonatomic,strong) NSString *passWordOneStr;
//
@property (nonatomic,assign) LoginAndRegiestVC_Show_Type mainShowType;
@property (nonatomic,weak) id <LoginAndRegiestMianViewDelegate> delegate;
@property (nonatomic,copy) GotoPrivacyAgreementVcBlock gotoPrivacyAgreementVcBlock;
- (void)setThisViewShowType:(LoginAndRegiestVC_Show_Type)type;//验证码或密码 展示类型
- (void)setThirdLoginViewIsShow:(BOOL)isShowThirdLoginView;

#pragma mark === textField数据
- (void)cleanAccountAndPasswordTextFiled;
@end

NS_ASSUME_NONNULL_END
