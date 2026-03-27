//
//  ZYMedicalCustomVC.m
//  Community
//
//  Created by ZY on 2021/11/19.
//

#import "ZYMedicalCustomVC.h"
#import "ZYAddMedicalCustomVC.h"
#import "ZYMedicalCustomBottomView.h"
#import "ZYMedicalCustomCell.h"

static NSString * const medicalCustomCellID = @"ZYMedicalCustomCell";
#define kMedicalCustomBottomViewHeight button_bottom_height+85

@interface ZYMedicalCustomVC () <UITableViewDataSource, UITableViewDelegate, ZYMedicalCustomBottomViewDelegate>

@property (nonatomic, strong) ZYMedicalCustomBottomView *bottomView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZYMedicalCustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"社区医疗需求定制";
    [self setUI];
    [self customTableView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    [self setupNavigationBarStyleWithColor];
}

- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(kMedicalCustomBottomViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (ZYMedicalCustomBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYMedicalCustomBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
- (void)initData {
    [self.dataArray addObjectsFromArray:@[@"", @""]];
    [self.tableView reloadData];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:medicalCustomCellID bundle:nil] forCellReuseIdentifier:medicalCustomCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYMedicalCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:medicalCustomCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    ZYMedicalCustomCell *cell = (ZYMedicalCustomCell *)currentCell;
    cell.deleteButton.tag = 200 + indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:medicalCustomCellID configuration:^(ZYMedicalCustomCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 16;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark - ZYMedicalCustomBottomViewDelegate
// 添加需求
- (void)addButtonEvent {
    
    NSLog(@"添加需求");
    ZYAddMedicalCustomVC *vc = [[ZYAddMedicalCustomVC alloc] init];
    [self pushVc:vc];
}

#pragma mark - 处理点击事件
// 删除
- (void)deleteButtonClicked:(UIButton *)sender {
    
    NSLog(@"删除 %ld", sender.tag - 200);
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确认删除吗？" message:@"删除不可恢复哦" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除");
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
