//
//  ZYQuestionnaireSurveyResultVc.m
//  Community
//
//  Created by ZY on 2022/6/8.
//

#import "ZYQuestionnaireSurveyResultVc.h"
#import "ZYQuestionnaireSurveyEditVc.h"
#import "ZYQuestionnaireSurveyStatisticalVc.h"
#import "ZYQuestionnaireSurveyResultView.h"

@interface ZYQuestionnaireSurveyResultVc () <ZYQuestionnaireSurveyResultViewDelegate>

@property (nonatomic, strong) ZYQuestionnaireSurveyResultView *resultView;

@end

@implementation ZYQuestionnaireSurveyResultVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"问卷调查";
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSMutableArray *vcsArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ZYQuestionnaireSurveyEditVc class]]) {
            [vcsArr removeObject:vc];
        }
        if ([vc isKindOfClass:[ZYQuestionnaireSurveyStatisticalVc class]]) {
            [vcsArr removeObject:vc];
        }
    }
    self.navigationController.viewControllers = [vcsArr copy];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.resultView];
    [_resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_resultView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYQuestionnaireSurveyResultView *)resultView {
    if (!_resultView) {
        _resultView = [[NSBundle mainBundle] loadNibNamed:@"ZYQuestionnaireSurveyResultView" owner:nil options:nil].lastObject;
        _resultView.delegate = self;
        if (self.type == ZYQuestionnaireSurveyResult_Type_Success) {
            _resultView.iconImageView.image = [UIImage imageNamed:@"ci_chengg_icon"];
            _resultView.titleLabel.text = @"提交成功";
        }else if (self.type == ZYQuestionnaireSurveyResult_Type_Underway) {
            _resultView.iconImageView.image = [UIImage imageNamed:@"ci_chengg_icon"];
            _resultView.titleLabel.text = @"你已完成本次投票问卷，谢谢参与！";
        }else if (self.type == ZYQuestionnaireSurveyResult_Type_Over) {
            _resultView.iconImageView.image = [UIImage imageNamed:@"wd_fail_icon"];
            _resultView.titleLabel.text = @"活动已结束";
        }
    }
    
    return _resultView;
}

#pragma mark - ZYQuestionnaireSurveyResultViewDelegate
- (void)okButtonEvent {
    [self popVC];
}

@end
