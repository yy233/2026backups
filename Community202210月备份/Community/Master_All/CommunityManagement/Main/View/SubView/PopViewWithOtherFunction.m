//
//  PopViewWithOtherFunction.m
//  Community
//
//  Created by 余莹 on 2021/3/22.
//

#import "PopViewWithOtherFunction.h"

@interface PopViewWithOtherFunction () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *imgNameArr;
@end

@implementation PopViewWithOtherFunction
#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.subMainBackView addSubview:self.tableView];
        [self setUI];
        self.subMainBackView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
- (void)showInViewEditCellIndex:(NSInteger)index andWithArray:(NSMutableArray *)timeArr{
    [self showInView:self.superview thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
    //up ui
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H;
}
#pragma mark ==
- (void)setUI{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_tableView.superview).offset(-10);
        make.height.offset(200);
        make.width.offset(150);
        make.bottom.equalTo(_tableView.superview.mas_bottom).offset(-KNavBarHeight-90);
    }];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.layer.cornerRadius = 7.5;
        _tableView.layer.masksToBounds = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
#pragma mark ==
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]initWithObjects:@"论坛", @"短视频",@"聊天",@"跳蚤市场",nil];
    }
    return _titleArr;
}
- (NSMutableArray *)imgNameArr{
    if (!_imgNameArr) {
        _imgNameArr = [[NSMutableArray alloc]initWithObjects:@"forum", @"Shortvideo",@"chat",@"flea_market",nil];
    }
    return _imgNameArr;
}
#pragma mark ==+++++++++
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imgNameArr[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(popViewOtherFunctionSubTouchPopViewWithOtherFunction:)]) {
        [_delegate popViewOtherFunctionSubTouchPopViewWithOtherFunction:(indexPath.row)];
    }
    [self dismissThePopView];
}
//复用父类的
- (void)dismissPopViewHaveOtherAction{
    if (_delegate && [_delegate respondsToSelector:@selector(popViewOtherFunctionSubTouchPopViewWithOtherFunction:)]) {
        [_delegate popViewOtherFunctionSubTouchPopViewWithOtherFunction:PopViewWithOtherFunction_Type_DisMissPopView];
    }
}

@end
