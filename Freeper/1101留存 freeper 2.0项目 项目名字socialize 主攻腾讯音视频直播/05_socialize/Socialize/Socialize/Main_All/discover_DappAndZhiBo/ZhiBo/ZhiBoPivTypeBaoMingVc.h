//
//  ZhiBoPivTypeBaoMingVc.h
//  Socialize
//
//  Created by 余莹 on 2023/7/13.
//

#import "Y_BaseViewController.h"
#import "ZhiBoListViewModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^BaoMingSuccessNeedRefActionBool)(void);

@interface ZhiBoPivTypePassWordView : UIView
@property (nonatomic,strong) UIView *topImgv;
@property (nonatomic,strong) UILabel *topLabel;
@property (nonatomic,strong) UILabel *passwordTitleL;
@property (nonatomic,strong) UIView *passwordBkView;
@property (nonatomic,strong) UITextField *passwordTF;

@end

@interface ZhiBoPivTypeBaoMingVc : Y_BaseViewController
@property (nonatomic,strong) ZhiBoShowInfoModel *zhiBoInfoModel;
@property (nonatomic,copy) BaoMingSuccessNeedRefActionBool baoMingSuccessNeedRefActionBool;
@end

NS_ASSUME_NONNULL_END
