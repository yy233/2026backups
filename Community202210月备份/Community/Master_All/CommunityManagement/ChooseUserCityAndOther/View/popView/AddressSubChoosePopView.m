//
//  AddressSubBounceView.m
//  Community
//
//  Created by 余莹 on 2020/12/3.
//

#import "AddressSubChoosePopView.h"
#define TableView_Hight 280
#define TableViewCel_H 50
@interface SelfPopViewSubTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *label;
@property(nonatomic,readwrite) UIImageView *imageView;

@end

@implementation SelfPopViewSubTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        imageView
        //        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_H-20, Screen_H * (40.0/736.0))];
        //        self.label.font = [UIFont systemFontOfSize:13];
        //        self.label.textAlignment = NSTextAlignmentCenter;
        //        [self addSubview:self.label];
        //        self.label.backgroundColor = [UIColor blueColor];
        //        UIView *view = [UIView new];
        //        [self addSubview:view];
    }
    return self;
}


@end

@interface AddressSubChoosePopView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *backcontentView;//主大背景
@property (nonatomic,strong) UIView *tableViewbackView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,assign) float animationTime;
@end
@implementation AddressSubChoosePopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //        self.frame = frame;//00范围，点击事件不可响应，会点到父视图
        self.frame = CGRectMake(0, 0, Screen_W, Screen_H);
        [self initAttribute];
        [self addSubview:self.backcontentView];
        [self.backcontentView addSubview:self.tableViewbackView];
        [self.tableViewbackView addSubview:self.tableViewbackViewTopLabel];
        [self.tableViewbackView addSubview:self.tableView];
        [self.tableViewbackView addSubview:self.closeBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backcontentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backcontentView.superview);
    }];
    [_tableViewbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_tableViewbackView.superview.mas_width);
        make.top.equalTo(_tableViewbackView.superview.mas_centerY);
        make.bottom.equalTo(_tableViewbackView.superview.mas_bottom).offset(10);//下10 遮住圆角?数据
        make.centerX.equalTo(_tableViewbackView.superview.mas_centerX);
    }];
    [_tableViewbackViewTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableViewbackViewTopLabel.superview.mas_top).offset(10);
        make.width.equalTo(_tableViewbackViewTopLabel.superview.mas_width).multipliedBy(0.6);
        make.centerX.equalTo(_tableViewbackViewTopLabel.superview.mas_centerX);
        make.height.offset(20);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_tableView.superview.mas_width);
        make.top.equalTo(_tableViewbackViewTopLabel.mas_bottom).offset(5);
        make.bottom.equalTo(_tableView.superview.mas_bottom).offset(-100);//?
        make.centerX.equalTo(_tableView.superview.mas_centerX);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_closeBtn.superview.mas_top).offset(10);
        make.width.offset(30);
        make.height.offset(20);
        make.right.equalTo(_closeBtn.superview.mas_right).offset(-16);
    }];
}
#pragma mark ===========
/**
 *  展示pop视图 和 数据
 */
- (void)showInView:(UIView *)supview thePopViewWithArray:(NSMutableArray *)array{
    if (!supview) {
        return;
    }
    [supview addSubview:self];
    
    self.tableViewbackViewTopLabel.hidden = NO;
    self.closeBtn.hidden = NO;
    [self.backcontentView setFrame:CGRectMake(0, Screen_H, Screen_W, 0)];
    [UIView animateWithDuration:self.animationTime animations:^{
        self.alpha = 1.0;
        self.backcontentView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
    } completion:nil];
    self.dataSource = array;
    [self.tableView reloadData];
    [self setTopText:@""];
}
- (void)setTopText:(NSString *)titleStr{
    _tableViewbackViewTopLabel.text = @"";
}

/**
 *  消失pop视图
 */
- (void)dismissThePopView{
    self.tableViewbackViewTopLabel.hidden = YES;
    self.closeBtn.hidden = YES;
    CGPoint center = self.backcontentView.center;
    [self.backcontentView setFrame:self.backcontentView.frame];
    [UIView animateWithDuration:self.animationTime
                     animations:^{
        self.alpha = 0.0;
        self.backcontentView.center  = CGPointMake(center.x, center.y+Screen_H);
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [self.backcontentView removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    NSString *str= self.dataSource[indexPath.row];
    cell.textLabel.text = str;
    return cell;
}
#pragma mark - UITableViewDelagate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TableViewCel_H;
}
#pragma mark == 点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(popViewTag:OfSubTableViewTouchWithIndexPath:)]) {
        [self dismissThePopView];
        [self.delegate popViewTag:0 OfSubTableViewTouchWithIndexPath:indexPath];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{\
    DLog(@"touchesBegan");
    [self dismissThePopView];
}
- (void)closeBtnAction:(UIButton *)sender{
    DLog(@"closeBtnAction");
    [self dismissThePopView];
}
#pragma mark == getter

- (void)initAttribute{
    self.animationTime = 0.3;
}
- (UIView *)backcontentView{
    if (!_backcontentView) {
        _backcontentView = [[UIView alloc]init];
        _backcontentView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
        _backcontentView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
        _backcontentView.layer.cornerRadius = 10;
    }
    return _backcontentView;
}

- (UIView *)tableViewbackView{
    if (!_tableViewbackView) {
        _tableViewbackView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_H-KNavBarHeight-TableView_Hight, Screen_W,TableView_Hight)];
        _tableViewbackView.backgroundColor = [UIColor whiteColor];
        _tableViewbackView.layer.cornerRadius = 10;
        _tableViewbackView.layer.masksToBounds = YES;
    }
    return _tableViewbackView;
}
- (UILabel *)tableViewbackViewTopLabel{
    if (!_tableViewbackViewTopLabel) {
        _tableViewbackViewTopLabel = [[UILabel alloc]init];
        _tableViewbackViewTopLabel.frame = CGRectMake(Screen_W*0.2, Screen_H-KNavBarHeight-TableView_Hight+10,Screen_W*0.6, 20);
        _tableViewbackViewTopLabel.textAlignment = NSTextAlignmentCenter;
        _tableViewbackViewTopLabel.font = [UIFont boldSystemFontOfSize:15];
        _tableViewbackViewTopLabel.backgroundColor = [UIColor clearColor];
    }
    return _tableViewbackViewTopLabel;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,10, Screen_W,TableView_Hight-60) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(Screen_W - 20 - 20, Screen_H-KNavBarHeight-TableView_Hight+10, 20, 50);
        [_closeBtn setImage:[UIImage imageNamed:@"close_round_gray"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];//dismissThePopView
    }
    return _closeBtn;
}

@end
