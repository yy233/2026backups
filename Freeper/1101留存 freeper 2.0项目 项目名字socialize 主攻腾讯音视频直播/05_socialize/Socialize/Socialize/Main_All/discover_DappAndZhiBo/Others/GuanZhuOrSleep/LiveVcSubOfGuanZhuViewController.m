//
//  LiveVcSubOfGuanZhuViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/22.
// 当前界面暂时不用  使用InfoGuanZhuview 

#import "LiveVcSubOfGuanZhuViewController.h"

//#import "ZhuBoInfoBottomItemView.h"
//#import "ZhuBoInfoView.h"

@interface LiveVcSubOfGuanZhuViewController ()
//<ZhuBoInfoBottomItemViewDelegate>
//@property (nonatomic,strong) ZhuBoInfoView *topView;
//@property (nonatomic,strong) ZhuBoInfoBottomItemView *bottomView;
@end

@implementation LiveVcSubOfGuanZhuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//
//- (ZhuBoInfoView *)topView{
//    if(!_topView){
//        _topView = [[ZhuBoInfoView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-200)];
//    }
//    return _topView;
//}
//- (ZhuBoInfoBottomItemView *)bottomView{
//    if(!_bottomView){
//        _bottomView = [[ZhuBoInfoBottomItemView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 200)];
//        _bottomView.delegate = self;
//    }
//    return _bottomView;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self initViews];
//}
//- (UIColor *)navBackColor{
//    return [UIColor clearColor];
//}
//- (void)viewWillAppear:(BOOL)animated {
//   [super viewWillAppear:animated];
//   [self setup_NavigationBar_TransparentBk_blackText];
//   if (@available(iOS 15.0, *)) {
//       UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
//       [appearance configureWithDefaultBackground];
//       appearance.shadowColor = nil;
//       appearance.backgroundEffect = nil;
//       appearance.backgroundColor =  [self navBackColor];
//       UINavigationBar *navigationBar = self.navigationController.navigationBar;
//       navigationBar.backgroundColor = [self navBackColor];
//       navigationBar.barTintColor = [self navBackColor];
//       navigationBar.shadowImage = [UIImage new];
//       NSDictionary *attDic = @{
//           NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
//           NSForegroundColorAttributeName:[UIColor whiteColor]};
//       navigationBar.titleTextAttributes = attDic;
//       navigationBar.standardAppearance = appearance;
//       navigationBar.scrollEdgeAppearance= appearance;
//
//   }
//   else {
//       UINavigationBar *navigationBar = self.navigationController.navigationBar;
//       navigationBar.backgroundColor = [self navBackColor];
//       navigationBar.barTintColor = [self navBackColor];
//       navigationBar.shadowImage = [UIImage new];
//       [[UINavigationBar appearance] setTranslucent:NO];
//   }
//
//
//}
//
//- (void)initViews{
//    [self.view addSubview:self.topView];
//    [self.view addSubview:self.bottomView];
//
//    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(_topView.superview);
//        make.bottom.equalTo(_topView.superview).offset(-200);
//    }];
//
//    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(_topView.superview);
//        make.height.offset(200);
//    }];
//}
//
//- (void)touchAtMe{
//    DLog();
//}
//- (void)touchSiXin{
//    DLog();
//}
//
//- (void)touchGuanZhu{
//    DLog();
//}

@end
