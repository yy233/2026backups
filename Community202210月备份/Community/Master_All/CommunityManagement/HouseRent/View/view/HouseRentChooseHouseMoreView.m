//
//  HouseRentChooseHouseMoreView.m
//  Community
//
//  Created by 余莹 on 2021/1/15.
//

#import "HouseRentChooseHouseMoreView.h"
#import "HouseRentChooseHouseMoreSubViewTableViewCell.h"
#define HouseRentChooseHouseMoreSubViewTableViewCell_Identifier @"HouseRentChooseHouseMoreSubViewTableViewCell"
#define Color_lightBlue    Y_RGBA(38, 114, 249, 1)
#define Width_leftKong      50
#define Height_BottomBtn    44
#define Width_cellSubBtn       (Screen_W-Width_leftKong-40)/3
#define Height_cellSubBtn    50
//
#define Height_Cell_SectionHeaderView 60
#define Height_Cell_OneHang 60
#define Width_Cell_OneHang   (Screen_W-Width_leftKong-20)/3


@interface HouseRentChooseHouseMoreView () <UITableViewDelegate,UITableViewDataSource,HouseRentChooseHouseMoreSubViewTableViewCellDelegate>
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *okBtn;
//
@property (nonatomic,strong) NSArray *keyArr;
@property (nonatomic,strong) NSDictionary *allDataSourceDic;
@property (nonatomic,strong) NSMutableArray *chooseShaixuanModelArr;//已选的model
@end

@implementation HouseRentChooseHouseMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.allDataSourceDic = [[NSDictionary alloc]init];
        self.keyArr = [NSArray array];
        self.chooseShaixuanModelArr = [[NSMutableArray alloc]init];
        [self addSubview:self.backView];
        [self.backView addSubview:self.tableView];
        [self.backView addSubview:self.cancelBtn];
        [self.backView addSubview:self.okBtn];
        [self setUI];
    }
    return self;
}
#pragma mark ==
- (void)showHouseMoreChooseViewWithAnimationWithDic:(NSDictionary *)dic withSelectModelArr:(NSMutableArray *)selectedModelArr{
    self.hidden = NO;
    self.allDataSourceDic = dic;
    self.keyArr = [dic allKeys];
    
    //已选过的
    self.chooseShaixuanModelArr = selectedModelArr;
    //UI
    [self.tableView reloadData];
    
}
- (void)hidenHouseMoreChooseViewWithAnimation{
    self.hidden = YES;
}
#pragma mark ==
- (void)cancelHouseMoreShaiXuanItemWithShaiXuanModel:(HouseRentMoreShaixuanModel *)model{
    self.chooseShaixuanModelArr = [[NSMutableArray alloc]init];
}
- (void)chooseHouseMoreShaiXuanItemWithShaiXuanModel:(HouseRentMoreShaixuanModel *)model{
    NSLog(@"点击选择了一个 model  %@",model);
    [self.chooseShaixuanModelArr addObject:model];
}
#pragma mark ==
- (void)okBtnAction{
    NSLog(@"okBtnAction");
    if (_delegate && [_delegate respondsToSelector:@selector(houseMoreChooseWithArr:)]) {
        [_delegate houseMoreChooseWithArr:self.chooseShaixuanModelArr];
        [self hidenHouseMoreChooseViewWithAnimation];
    }
}
- (void)cancelBtnAction{
    NSLog(@"cancelBtnAction");
    self.chooseShaixuanModelArr = [[NSMutableArray alloc]init];
    if (_delegate && [_delegate respondsToSelector:@selector(houseMoreChooseWithArr:)]) {
        [_delegate houseMoreChooseWithArr:@[].mutableCopy];
        [self hidenHouseMoreChooseViewWithAnimation];
    }
    
}
#pragma mark ==
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(_tableView.superview).insets(UIEdgeInsetsMake(0, Width_leftKong, -(Height_BottomBtn+KNavBarHeight), 0));//高度问题
        make.top.equalTo(_tableView.superview);
        make.left.equalTo(_tableView.superview).offset(Width_leftKong);
        make.right.equalTo(_tableView.superview);
        make.height.offset(Screen_H-KNavBarHeight-Height_BottomBtn);
    }];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_backView.mas_bottom);
        make.height.offset(Height_BottomBtn-0.2);
        make.right.equalTo(_backView.mas_right);
        make.width.offset(Screen_W*0.6);
    }];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_backView.mas_bottom);
        make.height.offset(Height_BottomBtn-0.2);
        make.right.equalTo(_okBtn.mas_left);
        make.left.equalTo(_tableView.mas_left);
    }];
}
#pragma mark ==
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.keyArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-Width_leftKong, Height_Cell_SectionHeaderView)];
    UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(10,0, Screen_W-Width_leftKong-20, Height_Cell_SectionHeaderView)];
    [v addSubview:textL];
    textL.font = [UIFont boldSystemFontOfSize:15];
    textL.textColor = [ThemeManager shareManager].mainTextColor;
    textL.text = [NSString stringWithFormat:@"%@",self.keyArr[section]];
    return v;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Height_Cell_OneHang;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *cellArr = [NSArray arrayWithArray:self.allDataSourceDic[self.keyArr[indexPath.section]]];
    NSInteger hangNum = (cellArr.count/3) + (cellArr.count%3==0?0:1);
    return Height_Cell_SectionHeaderView*hangNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HouseRentChooseHouseMoreSubViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentChooseHouseMoreSubViewTableViewCell_Identifier];
    if (!cell) {
        cell = [[HouseRentChooseHouseMoreSubViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentChooseHouseMoreSubViewTableViewCell_Identifier];
    }
    NSArray *cellArr = [NSArray arrayWithArray:self.allDataSourceDic[self.keyArr[indexPath.section]]];
    [cell sendAllDataSource:cellArr andSelectedModelArr:self.chooseShaixuanModelArr];//init
    cell.delegate = self;
    return cell;
    
}
- (UIButton *)baseBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"btnt" forState:UIControlStateNormal];
    [btn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
    btn.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3];
    //    [btn setImage:[UIImage imageWithColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3]] forState:UIControlStateNormal];
    //    [btn setImage:[UIImage imageWithColor:Color_lightBlue] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    return btn;
}
#pragma mark ===
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    }
    return _backView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-50-20, Screen_H-KNavBarHeight-50) style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.delaysContentTouches=NO;
    }
    return _tableView;
}
- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn setTitle:@"查看" forState:UIControlStateNormal];
        [_okBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _okBtn.backgroundColor = Color_lightBlue;
        [_okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelBtn.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancelBtn;
}

@end
