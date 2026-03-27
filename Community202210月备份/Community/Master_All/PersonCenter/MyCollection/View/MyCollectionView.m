//
//  MyCollectionView.m
//  Community
//
//  Created by 刘久炼 on 2021/2/24.
//

#import "MyCollectionView.h"

#import "MyCollectionCell.h"

#import "MyCollectionEditCell.h"

@interface MyCollectionView ()<UITableViewDelegate,UITableViewDataSource,MyCollectionEditCellDelegate>

@property(nonatomic, strong) UITableView *tableV;

@property(nonatomic, strong) UIButton *deleteBtn;

@property(nonatomic, strong) NSMutableArray *selectedArray;

@end

static NSString *const cellID = @"MyCollectionCell";
static NSString *const editCellID = @"MyCollectionEditCell";


@implementation MyCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.status = MyCollectionViewNormal;
        self.selectedArray = [NSMutableArray array];
        [self initView];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.left.offset(15);
        make.height.offset(44);
        make.bottom.offset(-15);
    }];
    [self.tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

}

#pragma mark - 懒加载

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除(0)" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[Tool getColorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundColor:[Tool getColorWithHexString:@"#FA4F55"]];
        [_deleteBtn addTarget:self action:@selector(deletBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.layer.cornerRadius = 2.5;
        _deleteBtn.clipsToBounds = YES;
        _deleteBtn.titleLabel.font = FontSize_Vip_Nomail(15);
        _deleteBtn.tag = 0;
        _deleteBtn.hidden = YES;
    }
    return _deleteBtn;
}

- (UITableView *)tableV{
    if (!_tableV ){
        _tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self addSubview:_tableV];
        _tableV.backgroundColor = [UIColor whiteColor];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.showsVerticalScrollIndicator = NO;
        _tableV.bounces = NO;
        if (@available(ios 11.0,*)) {
            // 针对 11.0 以上的iOS系统进行处理
            _tableV.estimatedRowHeight = 0;
            _tableV.estimatedSectionHeaderHeight = 0;
            _tableV.estimatedSectionFooterHeight = 0;
            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_tableV registerClass:[MyCollectionCell class] forCellReuseIdentifier:cellID];
        [_tableV registerClass:[MyCollectionEditCell class] forCellReuseIdentifier:editCellID];
    }
    return _tableV;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.status == MyCollectionViewNormal) {
//        普通状态
        MyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }else{
//        编辑状态
        MyCollectionEditCell *cell = [tableView dequeueReusableCellWithIdentifier:editCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return 87;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.delegate respondsToSelector:@selector(cellCliced)]) {
//        [self.delegate cellCliced];
//    }
}

#pragma mark - 按钮点击

- (void)deletBtnClicked: (UIButton *)sender{
    DLog(@"deletBtnClicked");
}


- (void)editClickedWithStatus:(MyCollectionViewStatus) status{
    self.status = status;
    self.deleteBtn.hidden = !status;
    [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",self.selectedArray.count] forState:UIControlStateNormal];
    if (self.status) {
        [self.tableV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self.deleteBtn.mas_top);
        }];
    }else{
        [self.tableV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    [self.tableV reloadData];
}

- (void)reloadData{
    [self.tableV reloadData];
}


#pragma mark - MyCollectionEditCellDelegate

- (void)cellSeletedWithModel:(MyCollectionModel *)model status:(NSInteger)status{
    if ([self.selectedArray containsObject:model]) {
        [self.selectedArray removeObject:model];
    }else{
        [self.selectedArray addObject:model];
    }
    [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",self.selectedArray.count] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
