//
//  ZYAddMedicalCustomVC.m
//  Community
//
//  Created by ZY on 2021/11/19.
//

#import "ZYAddMedicalCustomVC.h"
#import "ZYAddMedicalCustomBottomView.h"
#import "ZYAddMedicalCustomCell.h"

static NSString * const addMedicalCustomCellID = @"ZYAddMedicalCustomCell";
#define kAddMedicalCustomBottomViewHeight button_bottom_height+85
#define kAddMedicalCustomCellHeight 300

@interface ZYAddMedicalCustomVC () <UITableViewDataSource, UITableViewDelegate, ZYAddMedicalCustomBottomViewDelegate, ZYAddMedicalCustomCellDelegate>

@property (nonatomic, strong) ZYAddMedicalCustomBottomView *bottomView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray <NSNumber *> *linkage2SelectIndexs;

@end

@implementation ZYAddMedicalCustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"社区医疗需求定制";
    [self setUI];
    [self customTableView];
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
        make.height.offset(kAddMedicalCustomBottomViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (ZYAddMedicalCustomBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYAddMedicalCustomBottomView" owner:nil options:nil].lastObject;
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

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:addMedicalCustomCellID bundle:nil] forCellReuseIdentifier:addMedicalCustomCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYAddMedicalCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:addMedicalCustomCellID forIndexPath:indexPath];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kAddMedicalCustomCellHeight;
}

#pragma mark - ZYAddMedicalCustomCellDelegate
// 社区医疗
- (void)medicalViewEvent {
    
    NSLog(@"社区医疗");
    [self.view endEditing:YES];
    
    // 二级联动选择
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc] init];
    stringPickerView.pickerMode = BRStringPickerComponentLinkage;
    stringPickerView.title = @"";
    stringPickerView.dataSourceArr = [self createDataSource];
    stringPickerView.selectIndexs = self.linkage2SelectIndexs;
    stringPickerView.numberOfComponents = 2;
    __weak typeof(self) weakSelf = self;
    stringPickerView.resultModelArrayBlock = ^(NSArray<BRResultModel *> * _Nullable resultModelArr) {
        // 1.选择的索引
        NSMutableArray *selectIndexs = [[NSMutableArray alloc] init];
        // 2.选择的值
        NSString *selectValue = @"";
        for (BRResultModel *model in resultModelArr) {
            [selectIndexs addObject:@(model.index)];
            selectValue = [NSString stringWithFormat:@"%@-%@", selectValue, model.value];
        }
        if ([selectValue hasPrefix:@"-"]) {
            selectValue = [selectValue substringFromIndex:1];
        }
        weakSelf.linkage2SelectIndexs = selectIndexs;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        ZYAddMedicalCustomCell *cell = (ZYAddMedicalCustomCell *)[weakSelf.tableView cellForRowAtIndexPath:indexPath];
        cell.medicalTypeLabel.text = selectValue;
    };
    [stringPickerView show];
}

// 构建数据源
- (NSArray <BRResultModel *>*)createDataSource {
    NSArray *level1Array = @[@"内科", @"中医", @"儿科"];
    NSArray *level2Array = @[@[@"呼吸科", @"消化科", @"内分泌科"], @[@"按摩", @"火罐", @"推拿", @"食疗"], @[@"儿保门诊", @"小儿科门诊"]];
    NSMutableArray *dataSourceArray = [NSMutableArray array];
    for (int i = 0; i < level1Array.count; i++) {
        BRResultModel *model = [[BRResultModel alloc] init];
        model.parentKey = @"-1";
        model.parentValue = @"";
        model.key = [NSString stringWithFormat:@"id_%d", i];
        [dataSourceArray addObject:model];
        model.value = level1Array[i];
        
        NSArray *tempArray = level2Array[i];
        for (int j = 0; j < tempArray.count; j++) {
            BRResultModel *model1 = [[BRResultModel alloc] init];
            model1.parentKey = [NSString stringWithFormat:@"id_%d", i];
            model1.parentValue = level1Array[i];
            model1.key = [NSString stringWithFormat:@"id1_%d", j];
            model1.value = tempArray[j];
            [dataSourceArray addObject:model1];
        }
    }
    
    return [dataSourceArray copy];
}

#pragma mark - ZYAddMedicalCustomBottomViewDelegate
// 保存定制
- (void)saveButtonEvent {
    
    NSLog(@"保存定制");
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"是否根据您的需求定制推送相关内容" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"谢谢,不用" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的,需要" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"好的,需要");
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
