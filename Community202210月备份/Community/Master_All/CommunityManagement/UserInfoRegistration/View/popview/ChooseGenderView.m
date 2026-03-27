//
//  ChooseGenderView.m
//  Community
//
//  Created by 余莹 on 2020/12/1.
//

#import "ChooseGenderView.h"
#import "UIButton+ChangeHitInsets.h"
#import <objc/runtime.h>


@interface ChooseGenderView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *backV;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,strong) UIButton *deletBtn;//右上角
@end
@implementation ChooseGenderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
        [self addSubview:self.backV];
        [self.backV addSubview:self.tableView];
        [self.backV addSubview:self.deletBtn];
        [self setUI];
//        [self.tableView reloadData];
    }
    return self;
}
#pragma mark ==
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSourceArr[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    if (indexPath.row<self.dataSourceArr.count-1) {
//        cell.separatorInset = UIEdgeInsetsMake(0,16, 0, 16);
//    }else{
//        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
//    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Choose_Gender_Num  genderNum = Choose_Gender_unknown;//@"男",@"女",@"保密"
    switch (indexPath.row) {
        case 0:
            genderNum = Choose_Gender_man;
            break;
        case 1:
            genderNum = Choose_Gender_woman;
            break;
        case 2:
            genderNum = Choose_Gender_unknown;
            break;
            
        default:
            break;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chooseGender:)]) {
        [_delegate chooseGender:genderNum];
        self.hidden = YES;
    }
}
#pragma mark ===
- (void)setUI{
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backV.superview.mas_left);
        make.right.equalTo(_backV.superview.mas_right);
        make.height.offset(250);//150+20+10+
        make.bottom.equalTo(_backV.superview.mas_bottom).offset(10);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tableView.superview.mas_left);
        make.top.equalTo(_tableView.superview.mas_top).offset(20);
        make.bottom.equalTo(_tableView.superview.mas_bottom).offset(-10);
        make.right.equalTo(_tableView.superview.mas_right);
    }];
    [_deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_deletBtn.superview.mas_right).offset(-10);
        make.top.equalTo(_deletBtn.superview.mas_top).offset(10);
        make.width.offset(20);
        make.height.offset(50);
    }];
}

#pragma mark = =
- (UIView *)backV{
    if (!_backV) {
        _backV = [[UIView alloc]init];
        _backV.backgroundColor = [UIColor whiteColor];
        _backV.layer.cornerRadius = 10;
        _backV.layer.masksToBounds = YES;
    }
    return _backV;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (UIButton *)deletBtn{
    if (!_deletBtn) {
        _deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletBtn setImage:[UIImage imageNamed:@"close_round_gray"] forState:UIControlStateNormal];
        [_deletBtn addTarget:self action:@selector(delBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_deletBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];//扩大点击范围
    }
    return _deletBtn;
}
- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]initWithObjects:@"男",@"女",@"保密", nil];
    }
    return _dataSourceArr;
}
#pragma mark ===
- (void)delBtnAction:(UIButton *)sender{
    self.hidden = YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.hidden = YES;
}
@end
