//
//  ZYDisclaimerVC.m
//  Community
//
//  Created by ZY on 2021/9/29.
//

#import "ZYDisclaimerVC.h"
#import "ZYDisclaimerCell.h"

static NSString * const disclaimerCellID = @"ZYDisclaimerCell";
#define kDisclaimerCellHeight 500

@interface ZYDisclaimerVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZYDisclaimerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"免责声明";
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)setUI {
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"ZYDisclaimerCell" bundle:nil] forCellReuseIdentifier:disclaimerCellID];
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYDisclaimerCell *cell = [tableView dequeueReusableCellWithIdentifier:disclaimerCellID forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kDisclaimerCellHeight;
}

@end
