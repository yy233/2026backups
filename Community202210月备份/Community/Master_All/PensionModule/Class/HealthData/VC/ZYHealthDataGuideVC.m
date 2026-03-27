//
//  ZYHealthDataGuideVC.m
//  Community
//
//  Created by ZY on 2021/12/14.
//

#import "ZYHealthDataGuideVC.h"
#import "ZYHealthDataGuideTextCell.h"
#import "ZYHealthDataGuideImageCell.h"

static NSString * const healthDataGuideTextCellID = @"ZYHealthDataGuideTextCell";
static NSString * const healthDataGuideImageCellID = @"ZYHealthDataGuideImageCell";
#define kHealthDataGuideImageCellHeight 462

@interface ZYHealthDataGuideVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation ZYHealthDataGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定帮助";
    [self setUI];
    [self customTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithColor];
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
    }
    
    return _tableView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"1.点击设置", @"2.选择蓝牙", @"3.从蓝牙列表选择对应设备", @"4.选择忽略设备"];
    }
    
    return _titleArray;
}

- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = @[@"iphone_picture1", @"iphone_picture2", @"iphone_picture3", @"iphone_picture4"];
    }
    
    return _imageArray;
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:healthDataGuideTextCellID bundle:nil] forCellReuseIdentifier:healthDataGuideTextCellID];
    [self.tableView registerNib:[UINib nibWithNibName:healthDataGuideImageCellID bundle:nil] forCellReuseIdentifier:healthDataGuideImageCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        
        return 1;
    }else {
        
        return self.titleArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYHealthDataGuideTextCell *cell = [tableView dequeueReusableCellWithIdentifier:healthDataGuideTextCellID forIndexPath:indexPath];
        
        return cell;
    }else {
        ZYHealthDataGuideImageCell *cell = [tableView dequeueReusableCellWithIdentifier:healthDataGuideImageCellID forIndexPath:indexPath];
        cell.titleL.text = self.titleArray[indexPath.row];
        cell.imageV.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return [tableView fd_heightForCellWithIdentifier:healthDataGuideTextCellID configuration:nil];
    }else {
        
        return kHealthDataGuideImageCellHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        
        return 50;
    }
    
    return 0;
}

@end
