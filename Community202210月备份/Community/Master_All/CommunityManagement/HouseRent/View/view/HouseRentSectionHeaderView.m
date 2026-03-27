//
//  HouseRentSectionHeaderView.m
//  Community
//
//  Created by 余莹 on 2020/12/29.
//

#import "HouseRentSectionHeaderView.h"

#define SUB_BTN_TAG 300
#define SUB_BTN_W   (Screen_W/4)
#define SUB_BTN_H   30
#define SUB_TableView_H (Screen_H-KNavBarHeight-50-SUB_BTN_H) //50==choosetypechangeview商铺租房的切换按钮的h
#define Color_SUB_BTN_Selected_BlueColor Y_RGBA(38, 114, 249, 1)
@interface HouseRentSectionHeaderView () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *showOrHidenMainBackView;//主
@property (nonatomic,strong) UITableView *showOrHidenTableView;
@property (nonatomic,assign) Cell_type showOrHidenTableView_NowCell_type;
@property (nonatomic,strong) UITableView *showOrHidenMoreTableView;
@property (nonatomic,strong) NSArray *tableViewDataShourceArr;
@property (nonatomic,strong) NSDictionary *tableViewDataShourceDic;
@property (nonatomic,assign) NSInteger numberOfShow;//显示次数
@end

@implementation HouseRentSectionHeaderView
#pragma mark ==gesture
- (void)gestureHiddenTableView{
    if (_delegate &&[_delegate respondsToSelector:@selector(chooseNoCell)]) {
        [_delegate chooseNoCell];//取消当前筛选状态
    }
    [self hidenTableViewAnimationWithMas];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }else if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]) {
        return NO;
    }
    return YES;
}

#pragma mark ===
//tablev -- 城市区域 租金 房屋类型
- (void)showTableViewWithArr:(NSArray *)datasourceArr withType:(Cell_type)cellType{
    self.showOrHidenTableView_NowCell_type = cellType;
    self.tableViewDataShourceArr = datasourceArr;
    if (self.numberOfShow<=0) {
        [self showTableViewAnimationWithFram];
        self.numberOfShow += 1;
    }else{
        [self showTableViewAnimationWithMas];
        self.numberOfShow += 1;
    }
}
- (void)hiddenTableView{
    [self hidenTableViewAnimationWithMas];
    
}
#pragma mark==
//more
- (void)showMoreViewWithDic:(NSDictionary *)datasourceDic{
    self.showOrHidenTableView_NowCell_type = cell_type_more;
    self.tableViewDataShourceDic = datasourceDic;
    /**
     房屋来源,
     租房方式,
     出租房源类型,
     租房类型
     */
    self.showOrHidenMainBackView.backgroundColor = [UIColor cyanColor];
    self.showOrHidenMoreTableView.backgroundColor = [[UIColor purpleColor]colorWithAlphaComponent:0.2];
    if (self.numberOfShow<=0) {
        [self showMoreTableViewAnimationWithFram];
      
    }else{
        [self showMoreTableViewAnimationWithMas];
       
    }
}
- (void)hiddenMoreView{
//    [self hiddenMoreTableViewAnimationWithMas];
    [self hiddenMoreTableViewAnimationWithFram];
    
}
#pragma mark ==== Fram showOrHiden
- (void)showTableViewAnimationWithFram{
    if (self.showOrHidenTableView_NowCell_type == cell_type_more) {
        
    }else{
        self.showOrHidenMainBackView.hidden = NO;
        self.showOrHidenMoreTableView.hidden = YES;
        self.showOrHidenTableView.hidden = NO;
        [self.showOrHidenTableView reloadData];
        //
        [self.showOrHidenMainBackView setFrame:CGRectMake(0, SUB_BTN_H, Screen_W, 0)];
        [self.showOrHidenTableView setFrame:CGRectMake(0, 0, Screen_W, 0)];
        [UIView animateWithDuration:1.0 animations:^{
            [self.showOrHidenMainBackView setFrame:CGRectMake(0, SUB_BTN_H, Screen_W, SUB_TableView_H)];
            [self.showOrHidenTableView setFrame:CGRectMake(0, 0, Screen_W, SUB_TableView_H-124)];
        } completion:^(BOOL finished) {
            NSLog(@"showTableView end");
        }];
    }
}

//暂不使用fram的hidden
- (void)hhhhhhhTableViewAnimationWithFram{
    if (self.showOrHidenTableView_NowCell_type == cell_type_more) {
        
    }else{
        self.showOrHidenMainBackView.backgroundColor = [UIColor cyanColor];
        self.showOrHidenMainBackView.hidden = NO;
        self.showOrHidenMoreTableView.hidden = YES;
        self.showOrHidenTableView.hidden = NO;
        [self.showOrHidenTableView reloadData];
        //
        [self.showOrHidenMainBackView setFrame:self.showOrHidenMainBackView.frame];
        [self.showOrHidenTableView setFrame:self.showOrHidenTableView.frame];
        [self.showOrHidenTableView reloadData];
        [UIView animateWithDuration:1.0 animations:^{
            [self.showOrHidenMainBackView setFrame:CGRectMake(0, SUB_BTN_H, Screen_W, 0)];
            [self.showOrHidenTableView setFrame:CGRectMake(0, 0, Screen_W, 0)];
        } completion:^(BOOL finished) {
            NSLog(@"hhhhhhhTableVie end");
        }];
    }
}
#pragma mark ==== Mas showOrHiden
- (void)showTableViewAnimationWithMas{
    if (self.showOrHidenTableView_NowCell_type == cell_type_more) {
        
    }else{
        self.showOrHidenMainBackView.hidden = NO;
        self.showOrHidenMoreTableView.hidden = YES;
        self.showOrHidenTableView.hidden = NO;
        [self.showOrHidenTableView reloadData];
        //
        [_showOrHidenMainBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_moreBtn.mas_bottom);
            make.centerX.equalTo(_showOrHidenMainBackView.superview.mas_centerX);
            make.width.equalTo(_showOrHidenMainBackView.superview.mas_width);
            make.height.offset(SUB_TableView_H);;
        }];
        [UIView animateWithDuration:1.0 animations:^{
            [self layoutIfNeeded];//刷新界面
        } completion:^(BOOL finished) {
            NSLog(@"masshowTableView end");
        }];
    }
   
}
- (void)hidenTableViewAnimationWithMas{
    if (self.showOrHidenTableView_NowCell_type == cell_type_more) {
        
    }else{
        [_showOrHidenMainBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);//
        }];
        [UIView animateWithDuration:1.0 animations:^{
            [self layoutIfNeeded];//刷新界面
        } completion:^(BOOL finished) {
            self.showOrHidenMainBackView.hidden = YES;
            self.showOrHidenMoreTableView.hidden = YES;
            self.showOrHidenTableView.hidden = YES;
            NSLog(@"mashidenTableView end");
        }];
    }
    [self upSelfH];
}
- (void)upSelfH{
    //    [self.sectionHeaderViewHouse mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.height.offset(Cell_sectionheaderView_H);
    //    }];

//    [self mas_updateConstraints:^(MASConstraintMaker *make) {// 当前 self.numberOfShow = 0;只用Fram的显示
//        make.height.offset(SUB_BTN_H);
//    }];
    
    self.numberOfShow = 0;//点击会有不显示的情况
    self.numberOfShow = 1;//点击会有错
}
#pragma mark ===========More TableView Fram&Mas showOrHiden //可以用移动
- (void)showMoreTableViewAnimationWithFram{
    if (self.showOrHidenTableView_NowCell_type == cell_type_more) {
        self.showOrHidenTableView.hidden = YES;
        self.showOrHidenMainBackView.hidden = NO;
        self.showOrHidenMoreTableView.hidden = NO;
        [self.showOrHidenMoreTableView reloadData];
        //
//        [self.showOrHidenMainBackView setFrame:CGRectMake(0, SUB_BTN_H, 0, SUB_TableView_H)];
//        [self.showOrHidenMoreTableView setFrame:CGRectMake(0, 0, 0, SUB_TableView_H)];
        [self.showOrHidenMainBackView setFrame:CGRectMake(Screen_W, SUB_BTN_H, 0, SUB_TableView_H)];
        [self.showOrHidenMoreTableView setFrame:CGRectMake(Screen_W, 0, 0, SUB_TableView_H)];
        [UIView animateWithDuration:1.0 animations:^{
            [self.showOrHidenMainBackView setFrame:CGRectMake(0, SUB_BTN_H, Screen_W, SUB_TableView_H)];
            [self.showOrHidenMoreTableView setFrame:CGRectMake(0, 0, Screen_W-SUB_BTN_W, SUB_TableView_H)];
        } completion:^(BOOL finished) {
            NSLog(@"more showTableViewf end");
        }];
    }
}
- (void)hiddenMoreTableViewAnimationWithFram{
    if (self.showOrHidenTableView_NowCell_type == cell_type_more) {
       
        [self.showOrHidenMoreTableView reloadData];
        //
        [self.showOrHidenMainBackView setFrame:self.showOrHidenMainBackView.frame];
        [self.showOrHidenMoreTableView setFrame:self.showOrHidenMoreTableView.frame];
        [UIView animateWithDuration:1.0 animations:^{
            [self.showOrHidenMainBackView setFrame:CGRectMake(0, SUB_BTN_H, 0, SUB_TableView_H)];
            [self.showOrHidenMoreTableView setFrame:CGRectMake(0, 0, 0, SUB_TableView_H)];
        } completion:^(BOOL finished) {
            self.showOrHidenMainBackView.hidden = YES;
            self.showOrHidenMoreTableView.hidden = YES;
            self.showOrHidenTableView.hidden = YES;
            NSLog(@"moreTableView hiden end");
        }];
    }
}
- (void)showMoreTableViewAnimationWithMas{
    if (self.showOrHidenTableView_NowCell_type == cell_type_more) {
        self.showOrHidenTableView.hidden = YES;
        self.showOrHidenMainBackView.hidden = NO;
        self.showOrHidenMoreTableView.hidden = NO;
        [self.showOrHidenMoreTableView reloadData];
        //
        [_showOrHidenMainBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_moreBtn.mas_bottom);
            make.centerX.equalTo(_showOrHidenMainBackView.superview.mas_centerX);
            make.width.equalTo(_showOrHidenMainBackView.superview.mas_width);
            make.height.offset(SUB_TableView_H);;
        }];
        [UIView animateWithDuration:1.0 animations:^{
            [self layoutIfNeeded];//刷新界面
        } completion:^(BOOL finished) {
            NSLog(@"masshowTableView end");
        }];
    }
}
- (void)hiddenMoreTableViewAnimationWithMas{
    if (self.showOrHidenTableView_NowCell_type == cell_type_more) {
        [_showOrHidenMainBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(0);//
        }];
        [UIView animateWithDuration:1.0 animations:^{
            [self layoutIfNeeded];//刷新界面
        } completion:^(BOOL finished) {
            self.showOrHidenMainBackView.hidden = YES;
            self.showOrHidenMoreTableView.hidden = YES;
            self.showOrHidenTableView.hidden = YES;
            NSLog(@"mashidenTableView end");
        }];
    }
}

#pragma mark ===
 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.showOrHidenTableView_NowCell_type == cell_type_more) {
        NSArray *allKey = [self.tableViewDataShourceDic allKeys];
        return allKey.count;//房屋 more
    }else{
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.showOrHidenTableView_NowCell_type == cell_type_more) {
       NSArray *allKey = [self.tableViewDataShourceDic allKeys];
        NSArray *dataS = [NSArray arrayWithArray:self.tableViewDataShourceDic[allKey[section]]];
        return dataS.count;
    }else{
        return self.tableViewDataShourceArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: self.tableViewDataShourceArr[indexPath.row]];
    if (self.showOrHidenTableView_NowCell_type == cell_type_city) {
        cell.textLabel.text = dic[@"name"];
        //color
        if ([cell.textLabel.text isEqualToString:self.cityQuBtn.titleLabel.text]) {
            cell.textLabel.textColor = Color_SUB_BTN_Selected_BlueColor;
        }else{
            cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;//
        }
    }else if(self.showOrHidenTableView_NowCell_type == cell_type_money){
        cell.textLabel.text = dic[@"houseConstName"];
        //color
        if ([cell.textLabel.text isEqualToString:self.moneyBtn.titleLabel.text]) {
            cell.textLabel.textColor = Color_SUB_BTN_Selected_BlueColor;
        }else{
            cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;//
        }
    }else if(self.showOrHidenTableView_NowCell_type == cell_type_houseType){
        cell.textLabel.text = dic[@"houseConstName"];
        //color
        if ([cell.textLabel.text isEqualToString:self.houseTypeBtn.titleLabel.text]) {
            cell.textLabel.textColor = Color_SUB_BTN_Selected_BlueColor;
        }else{
            cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;//
        }
    }else{
        cell.textLabel.text = @"test";//
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showOrHidenTableView_NowCell_type ==  cell_type_more) {
        //more 多选
//        [self hiddenMoreTableViewAnimationWithMas];
        [self hiddenMoreTableViewAnimationWithFram];
    }else{
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: self.tableViewDataShourceArr[indexPath.row]];
        if (self.showOrHidenTableView_NowCell_type ==  cell_type_city && _delegate && [_delegate respondsToSelector:@selector(chooseCellWithCityDic:)]){
            [_delegate chooseCellWithCityDic:dic];
        }else if(self.showOrHidenTableView_NowCell_type == cell_type_money && _delegate && [_delegate respondsToSelector:@selector(chooseCellWithMoneyDic:)]){
            [_delegate chooseCellWithMoneyDic:dic];
        }else if(self.showOrHidenTableView_NowCell_type == cell_type_houseType && _delegate && [_delegate respondsToSelector:@selector(chooseCellWithHouseTypeDic:)]){
            [_delegate chooseCellWithHouseTypeDic:dic];
        }
        [self hidenTableViewAnimationWithMas];
        
    }

}
#pragma mark ===
- (instancetype)initWithFrame:(CGRect)frame
{
    frame =  CGRectMake(0, 0, Screen_W, Screen_H-KNavBarHeight-50);//50 choose切换btn
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.cityQuBtn];
        [self.backView addSubview:self.moneyBtn];
        [self.backView addSubview:self.houseTypeBtn];
        [self.backView addSubview:self.moreBtn];
        //
        [self.backView addSubview:self.showOrHidenMainBackView];
        [self.showOrHidenMainBackView addSubview:self.showOrHidenTableView];
        [self.showOrHidenMainBackView addSubview:self.showOrHidenMoreTableView];
        [self setUI];
    }
    return self;
}
- (void)subBtnAction:(UIButton *)sender{
   NSInteger index = sender.tag-SUB_BTN_TAG;
    switch (index) {
        case 1:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(touchUpHouseCityQuBtn)]) {
                [_delegate touchUpHouseCityQuBtn];
            }
        }
            break;
        case 2:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(touchUpHouseMoneyBtn)]) {
                [_delegate touchUpHouseMoneyBtn];
            }
        }
            break;
        case 3:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(touchUpHouseHouseTypeBtn)]) {
                [_delegate touchUpHouseHouseTypeBtn];
            }
        }
            break;
        case 4:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(touchUpHouseMoreBtn)]) {
                [_delegate touchUpHouseMoreBtn];
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview);
    }];
    [_cityQuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cityQuBtn.superview.mas_left);
        make.top.equalTo(_cityQuBtn.superview.mas_top);
        make.width.offset(SUB_BTN_W);
        make.height.offset(SUB_BTN_H);
    }];
    [_moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cityQuBtn.mas_right);
        make.top.equalTo(_moneyBtn.superview.mas_top);
        make.width.offset(SUB_BTN_W);
        make.height.offset(SUB_BTN_H);
    }];
    [_houseTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_moneyBtn.mas_right);
        make.top.equalTo(_houseTypeBtn.superview.mas_top);
        make.width.offset(SUB_BTN_W);
        make.height.offset(SUB_BTN_H);
    }];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_houseTypeBtn.mas_right);
        make.top.equalTo(_houseTypeBtn.superview.mas_top);
        make.width.offset(SUB_BTN_W);
        make.height.offset(SUB_BTN_H);
    }];
    [self setBottomShowOrHiddenViewAndSubView];
}
- (void)setBottomShowOrHiddenViewAndSubView{
    //fram  （fram 暂不用）
//    self.showOrHidenMainBackView.hidden = YES;
//    self.showOrHidenTableView.hidden = YES;
//    self.showOrHidenMoreTableView.hidden = YES;
//    _showOrHidenMainBackView.frame = CGRectMake(0, SUB_BTN_H, Screen_W, SUB_TableView_H);
//    _showOrHidenTableView.frame = CGRectMake(0, SUB_BTN_H, Screen_W, SUB_TableView_H-124);
    
    //mas
    self.numberOfShow = 0;// bug 会从底部显示上去 (第一次刷新显示更新约束时不用mas 用frame)
    self.showOrHidenMainBackView.hidden = YES;
    self.showOrHidenTableView.hidden = YES;
    self.showOrHidenMoreTableView.hidden = YES;
    [_showOrHidenMainBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moreBtn.mas_bottom);
        make.centerX.equalTo(_showOrHidenMainBackView.superview.mas_centerX);
        make.width.equalTo(_showOrHidenMainBackView.superview.mas_width);
        make.height.offset(SUB_TableView_H);
    }];
    [_showOrHidenTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_showOrHidenTableView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.edges.equalTo(_showOrHidenTableView.superview).insets(UIEdgeInsetsMake(0, 0, 125, 0));//bottom 留125的h做btn?
    }];
    [_showOrHidenMoreTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_showOrHidenTableView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));//left 50?
    }];
    
}
#pragma mark ==
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.masksToBounds = YES;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}
- (UIButton *)cityQuBtn{
    if (!_cityQuBtn) {
        _cityQuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cityQuBtn setTitle:@"区域" forState:UIControlStateNormal];
        [_cityQuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cityQuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cityQuBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _cityQuBtn.tag = 1+SUB_BTN_TAG;
    }
    return _cityQuBtn;
}
- (UIButton *)moneyBtn{
    if (!_moneyBtn) {
        _moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moneyBtn setTitle:@"租金" forState:UIControlStateNormal];
        [_moneyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _moneyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_moneyBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _moneyBtn.tag = 2+SUB_BTN_TAG;
    }
    return _moneyBtn;
 
}
- (UIButton *)houseTypeBtn{
    if (!_houseTypeBtn) {
        _houseTypeBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_houseTypeBtn setTitle:@"户型" forState:UIControlStateNormal];
        [_houseTypeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _houseTypeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_houseTypeBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _houseTypeBtn.tag = 3+SUB_BTN_TAG;
    }
    return _houseTypeBtn;
}
- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn  = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_moreBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.tag = 4+SUB_BTN_TAG;
    }
    return _moreBtn;
}
#pragma mark ===
- (UIView *)showOrHidenMainBackView{
    if (!_showOrHidenMainBackView) {
        _showOrHidenMainBackView = [[UIView alloc]init];
        _showOrHidenMainBackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureHiddenTableView)];
        tap.delegate = self;
        [_showOrHidenMainBackView addGestureRecognizer:tap];
        _showOrHidenTableView.layer.masksToBounds = YES;
        _showOrHidenTableView.clipsToBounds = YES;
    }
    return _showOrHidenMainBackView;
}
- (UITableView *)showOrHidenTableView{
    if (!_showOrHidenTableView) {
        _showOrHidenTableView  = [[UITableView alloc]init];
        _showOrHidenTableView.delegate = self;
        _showOrHidenTableView.dataSource = self;
        _showOrHidenTableView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        _showOrHidenTableView.tableFooterView = [UIView new];
        _showOrHidenTableView.layer.masksToBounds = YES;
        _showOrHidenTableView.clipsToBounds = YES;
    }
    return _showOrHidenTableView;
}
- (UITableView *)showOrHidenMoreTableView{
    if (!_showOrHidenMoreTableView) {
        _showOrHidenMoreTableView  = [[UITableView alloc]init];
        _showOrHidenMoreTableView.delegate = self;
        _showOrHidenMoreTableView.dataSource = self;
        _showOrHidenMoreTableView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        _showOrHidenMoreTableView.tableFooterView = [UIView new];
    }
    return _showOrHidenMoreTableView;
}
@end
