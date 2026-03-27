//
//  WaitForKaiBoViewController.h
//  Socialize
//
//  Created by 余莹 on 2023/7/4.
//

#import <UIKit/UIKit.h>
#import "ZhiBoListViewModel.h"
#import "ZhiBoBaseNetTools.h"
NS_ASSUME_NONNULL_BEGIN

@interface WaitForKaiBoSubView : UIView
@property (nonatomic,strong) UIView *bakView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *typeL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UIButton *shareBtn;
@end


@interface WaitForKaiBoViewController : Y_BaseViewController
@property (nonatomic,strong) ZhiBoShowInfoModel *showMode;
@end

NS_ASSUME_NONNULL_END
