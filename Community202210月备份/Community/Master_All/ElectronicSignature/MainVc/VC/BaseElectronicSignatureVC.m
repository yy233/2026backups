//
//  BaseElectronicSignatureVC.m
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import "BaseElectronicSignatureVC.h"

@interface BaseElectronicSignatureVC () <ElectronicSignatureHeaderSearchViewDelegate,UINavigationControllerDelegate>

@end

@implementation BaseElectronicSignatureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hiddenNavigationBar];
    [self.view.layer setOpaque:NO];
    self.view.opaque = NO;
    [self initView];
    
    // 注册主题色通知
    Y_NSNotificationCenter_Creat_NameAction(NOTICE_NAME_ThemeISChanged, themeChanged)
}

// 通知回调
- (void)themeChanged {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hiddenNavigationBar];
        self.tableView.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor;
        [self.tableView reloadData];
    });
}

// 销毁通知
- (void)dealloc {
    
    Y_NSNotificationCenter_RemoveNotice_Name(NOTICE_NAME_ThemeISChanged)
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hiddenNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD resetDefaultHUD];
    [self setupNavigationBarClearTransparentStyle];
}

#pragma mark == 协议
- (void)touchSacnBtnAction{}
- (void)touchUpItemWithIndex:(NSInteger)index{}


#pragma mark == UI
- (void)initView{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self.headerView showViewWithDataTitleArr:@[].mutableCopy withDetailTitleArr:@[].mutableCopy withImgArr:@[].mutableCopy];
}
#pragma mark ==
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 245 + status_height, Screen_W, Screen_H - 245 - status_height - bar_bottom_height) style:UITableViewStylePlain];
        _tableView.sectionFooterHeight = 0.1;
        _tableView.sectionFooterHeight = 0.1;
        _tableView.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (ElectronicSignatureHeaderSearchView *)headerView{
    if (!_headerView) {
        _headerView = [[ElectronicSignatureHeaderSearchView alloc] initWithFrame:CGRectZero];
    }
    return _headerView;
}

@end
