//
//  UrgentInfoOrTopInfoDetailVC.m
//  Community
//
//  Created by 余莹 on 2020/12/21.
//

#import "UrgentInfoOrTopInfoDetailVC.h"
#import "TopOrUregentInfoDetailModel.h"
#import "InfoDetailViewModel.h"
#import "InfoDetailView.h"
@interface UrgentInfoOrTopInfoDetailVC ()
@property (nonatomic,strong) TopOrUregentInfoDetailModel *infoModel;
@property (nonatomic,strong) InfoDetailView *detailView;
@end

@implementation UrgentInfoOrTopInfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
    self.detailView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;//重蓝色纯白色
}
- (void)initView{
    self.title = @"通知详情";
    [self.view addSubview: self.detailView];
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_detailView.superview);
    }];
}
- (void)initData{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
//    [parm setValue:@(self.communityId) forKey:@"communityId"];
    [parm setValue:@(self.communityId) forKey:@"acctId"];
    [parm setValue:@(self.infoId) forKey:@"informId"];
    [InfoDetailViewModel getTopOrUrgentInfoDetailWithParms:parm WithModelBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            self.infoModel = [TopOrUregentInfoDetailModel mj_objectWithKeyValues:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.detailView.model = self.infoModel;
            });
        }else{
            Y_SVP_SHOW_ERR_MES(@"加载失败");
        }
    }];
}
#pragma mark ==
- (TopOrUregentInfoDetailModel *)infoModel{
    if (!_infoModel) {
        _infoModel = [[TopOrUregentInfoDetailModel alloc]init];
    }
    return _infoModel;
}
- (InfoDetailView *)detailView{
    if (!_detailView) {
        _detailView = [[InfoDetailView alloc]initWithFrame:self.view.frame];
    }
    return _detailView;
}
@end
