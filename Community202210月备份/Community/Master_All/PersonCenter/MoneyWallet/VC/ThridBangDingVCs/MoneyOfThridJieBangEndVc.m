//
//  MoneyOfThridJieBangEndVc.m
//  Community
//
//  Created by 余莹 on 2021/10/14.
//

#import "MoneyOfThridJieBangEndVc.h"
#import "MoneyOfThridJieBangEditVc.h"
#import "MoneyOfThridBangDingListVc.h"

@interface MoneyOfThridJieBangEndVc ()

@end

@implementation MoneyOfThridJieBangEndVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"解绑成功";
    [self changeNavBackColorWithDDAndWW];
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor;
    [self initView];
    [self setUISuccess];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self popToBangDingListVc];
}

- (void)setUISuccess{
    self.centerL.text = @"解除绑定成功";
    self.centerImgV.image = [UIImage imageNamed:@"success_Face"];
}
 /**
  - (void)viewWillDisappear:(BOOL)animated{
      [super viewWillDisappear:animated];
      NSMutableArray *vcArr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
      for (UIViewController *vc in vcArr) {
          if ([vc isKindOfClass:[MoneyOfThridJieBangEditVc class]]) {
              [vcArr removeObject:vc];
              break;
          }
      }
      self.navigationController.viewControllers = vcArr;
  }
  */
- (void)popToBangDingListVc{
    NSMutableArray *vcArr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[MoneyOfThridJieBangEditVc class]]) {
            [vcArr removeObject:vc];
        }
    }
    self.navigationController.viewControllers = [vcArr copy];
}
#pragma mark=
- (void)initView{
    [self.view addSubview:self.centerImgV];
    [self.view addSubview:self.centerL];
    [self.view addSubview:self.footerView];
    [self setUI];
}
- (void)setUI{
    [_centerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(120);
        make.centerX.equalTo(_centerImgV.superview);
        make.centerY.equalTo(_centerImgV.superview).multipliedBy(0.7);
    }];
    [_centerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centerL.superview);
        make.height.offset(20);
        make.top.equalTo(_centerImgV.mas_bottom).offset(20);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_footerView.superview);
        make.bottom.equalTo(_footerView.superview).offset(-80);
        make.width.equalTo(_footerView.superview).offset(-120);
        make.height.offset(90);
    }];
}
 
- (UIImageView *)centerImgV{
    if (!_centerImgV) {
        _centerImgV = [[UIImageView alloc]init];
        _centerImgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _centerImgV;
}
- (UILabel *)centerL{
    if (!_centerL) {
        _centerL = [[UILabel alloc]init];
        _centerL.textAlignment = NSTextAlignmentCenter;
        _centerL.textColor = [ThemeManager shareManager].mainTextColor;
        _centerL.font = [UIFont systemFontOfSize:15];
    }
    return _centerL;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 90)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"确定"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W-120, 50)];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:8 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];

    }
    return _footerView;
}
- (void)footerBtnAction{

    [self popVC];
}
@end
