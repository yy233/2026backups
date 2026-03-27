//
//  ElectronicSignatureTipBaseVc.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import "ElectronicSignatureTipBaseVc.h"

@interface ElectronicSignatureTipBaseVc () <UITableViewDelegate,UITableViewDataSource>
@end

@implementation ElectronicSignatureTipBaseVc

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor;
    [self initBaseView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavigationBarTransparentStyle];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)initBaseView{
    [self.view addSubview:self.backImgV];
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.topTitleImgV];
    [self.view addSubview:self.tableView];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_footerView.superview);
        if (isIphoneX) {
            make.height.offset(90 + bottom_height - 10);
        }else {
            make.height.offset(90);
        }
    }];
    [_topTitleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topTitleImgV.superview.mas_centerX);
        make.height.offset(55);
        make.width.offset(215);
        make.top.equalTo(_topTitleImgV.superview.mas_top).offset(status_height + 10);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topTitleImgV.mas_bottom).offset(20);
        make.left.equalTo(_tableView.superview.mas_left);
        make.right.equalTo(_tableView.superview.mas_right);
        make.bottom.equalTo(_footerView.mas_top).offset(20);
    }];
}
//
- (void)knowAction{
    [self popVC];
}
//
- (UIImageView *)backImgV{
    if (!_backImgV) {
        _backImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
        _backImgV.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor;
    }
    return _backImgV;
}
- (ElectronicSignatureBaseFooterView *)footerView{
    if (!_footerView) {
        _footerView  = [[ElectronicSignatureBaseFooterView alloc]initWithFrame:CGRectZero];
        [_footerView.footerBtn setTitle:@"我已了解" forState:UIControlStateNormal];
        [_footerView.footerBtn addTarget:self action:@selector(knowAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
//
- (UIImageView *)topTitleImgV{
    if (!_topTitleImgV) {
        _topTitleImgV = [[UIImageView alloc] init];
        _topTitleImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _topTitleImgV;
}
//
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellContentTextArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}
//
- (NSMutableArray *)cellTitleTextArr{
    if (!_cellTitleTextArr) {
        _cellTitleTextArr = [[NSMutableArray alloc]init];
    }
    return _cellTitleTextArr;
}
- (NSMutableArray *)cellContentTextArr{
    if (!_cellContentTextArr) {
        _cellContentTextArr = [[NSMutableArray alloc]init];
    }
    return _cellContentTextArr;
}
@end
