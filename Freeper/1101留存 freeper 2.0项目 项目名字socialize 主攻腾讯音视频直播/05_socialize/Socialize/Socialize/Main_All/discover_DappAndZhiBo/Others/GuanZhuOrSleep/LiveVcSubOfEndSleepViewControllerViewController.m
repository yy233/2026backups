//
//  LiveVcSubOfEndSleepViewControllerViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/22.
//

#import "LiveVcSubOfEndSleepViewControllerViewController.h"
#import "ZhuBoSleepTopBaseDeletBtnView.h"
#import "ZhuBoSleepBottomBtnsView.h"


@interface LiveVcSubOfEndSleepViewControllerViewController () <ZhuBoSleepTopBaseDeletBtnViewDelegate,ZhuBoSleepBottomBtnsViewDelegate>
@property (nonatomic,strong) ZhuBoSleepTopBaseDeletBtnView *topView;
@property (nonatomic,strong) ZhuBoSleepBottomBtnsView *bottomView;

@end

@implementation LiveVcSubOfEndSleepViewControllerViewController

- (ZhuBoSleepTopBaseDeletBtnView *)topView{
    if(!_topView){
        _topView = [[ZhuBoSleepTopBaseDeletBtnView alloc]initWithFrame:self.view.frame];
        _topView.delegate = self;
    }
    return _topView;
}

- (ZhuBoSleepBottomBtnsView *)bottomView{
    if(!_bottomView){
        _bottomView = [[ZhuBoSleepBottomBtnsView alloc]initWithFrame:self.view.frame];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
- (UIColor *)navBackColor{
    return [UIColor clearColor];
}
- (void)viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];
   [self setup_NavigationBar_TransparentBk_blackText];
    
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor whiteColor]};
   if (@available(iOS 15.0, *)) {
       UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
       [appearance configureWithDefaultBackground];
       appearance.shadowColor = nil;
       appearance.backgroundEffect = nil;
       appearance.backgroundColor =  [self navBackColor];
       UINavigationBar *navigationBar = self.navigationController.navigationBar;
       navigationBar.backgroundColor = [self navBackColor];
       navigationBar.barTintColor = [self navBackColor];
       navigationBar.shadowImage = [UIImage new];
       navigationBar.titleTextAttributes = attDic;
       navigationBar.standardAppearance = appearance;
       navigationBar.scrollEdgeAppearance= appearance;
       
   }
   else {
       UINavigationBar *navigationBar = self.navigationController.navigationBar;
       navigationBar.backgroundColor = [self navBackColor];
       navigationBar.barTintColor = [self navBackColor];
       navigationBar.shadowImage = [UIImage new];
       navigationBar.titleTextAttributes = attDic;
       [[UINavigationBar appearance] setTranslucent:NO];
   }
 

}

- (void)initViews{
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(_bottomView.superview);
        make.width.equalTo(_bottomView.superview).offset(-20);
        make.height.equalTo(_bottomView.superview).multipliedBy(0.5);
    }];
    self.bottomView.layer.mask = [BezierPathTool bezierPathToolWithThisViewBounds:CGRectMake(0, 0, Screen_W-20, Screen_H/2) withCornerRadi:CGSizeMake(10, 10) withRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight]; 
    
    
}


#pragma mark ==
- (void)touchDeletBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchGoMainVc{
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)touchKaiBoTiXing{
    DLog(@"");
}
- (void)touchOtherZhuBoRoom{
    DLog(@"");
}
#pragma mark ==

@end
