//
//  RegistViewLast.h
//  Community
//
//  Created by 余莹 on 2021/11/30.
//

#import <UIKit/UIKit.h>

#import "RegistViewLastSubNomalTableViewCell.h"

#define  RegistViewLastSubNomalTableViewCell_Identifier                      @"RegistViewLastSubNomalTableViewCell"
#define  RegistViewLastSubHaveSendCodeBtnTableViewCell_Identifier            @"RegistViewLastSubHaveSendCodeBtnTableViewCell"
#define  RegistViewLastSubLeftIsPhoneTextBeginTableViewCell_Identifier       @"RegistViewLastSubLeftIsPhoneTextBeginTableViewCell"


#define Height_Row  (70)
#define Height_FooterViewRegistOkBtnView  (60) //20+50+20

#define Tag_TextFiled_Base  (500)

#define Row_Num_Phone       (0)
#define Row_Num_Code        (1)
#define Row_Num_PasswordOne (2)
#define Row_Num_PasswordTwo (3)

NS_ASSUME_NONNULL_BEGIN

@protocol RegistViewLastDelegate   <NSObject>
- (void)registViewViewSubBtnAction:(UIButton *)sender;
@end
@interface RegistViewLast : UIView
@property (nonatomic,weak)id <RegistViewLastDelegate> delegate;
@property (nonatomic,strong) NSString *phoneStr;
@property (nonatomic,strong) NSString *codeStr;
@property (nonatomic,strong) NSString *passWordOneStr;
@property (nonatomic,strong) NSString *passWordTwoStr;


#pragma mark ===== UI
//
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *tableViewRegistOkFooterView;
@property (nonatomic,strong) UIButton *registOkBtn;


//
@property (nonatomic,strong) UIView *topBackGroundView;
@property (nonatomic,strong) UIButton *returnBtn;
@property (nonatomic,strong) UILabel  *topTitleLabel;
@property (nonatomic,strong) UILabel  *topDetailTitleLabel;
//
@property (nonatomic,strong) UIView *bottomBackView;
@property (nonatomic,strong) UIButton *loginGoVcBtn;
@property (nonatomic,strong) UILabel *parvacyLabel;
@property (nonatomic,strong) UIButton *parvacyBtn;

//
@property (nonatomic,strong) NSMutableArray *textFiledPStrArr;

//隐私 0427
@property (nonatomic,strong) UIButton *agreeBtn;
@property (nonatomic,strong) UITextView *privacypolicyTextView;
@property (nonatomic,copy) GotoPrivacyAgreementVcBlock gotoPrivacyAgreementVcBlock;


@end

NS_ASSUME_NONNULL_END
