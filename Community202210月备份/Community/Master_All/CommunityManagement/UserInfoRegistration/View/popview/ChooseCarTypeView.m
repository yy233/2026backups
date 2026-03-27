//
//  ChooseCarTypeView.m
//  Community
//
//  Created by 余莹 on 2020/12/1.
//

#import "ChooseCarTypeView.h"
#import "CarTypeChooseBtn.h"

#define CarTypeChooseBtn_OneSction_Tag 300
#define CarTypeChooseBtn_TwoSction_Tag 320
#define W_SubBtn 70
#define H_SubBtn 30
#define SubViewMaxW Screen_W/4
#define TAG_OneScrollView 400
#define TAG_TwoScrollView 401
#define H_lazyScrollViewSectionOne Screen_H*0.45*0.5
#define H_lazyScrollViewSectionTwo Screen_H*0.45*0.5


@interface ChooseCarTypeView () <TMMuiLazyScrollViewDelegate,TMMuiLazyScrollViewDataSource>
@property (nonatomic,strong) UIView *backV;
@property (nonatomic,strong) TMMuiLazyScrollView *lazyScrollViewSectionOne;
@property (nonatomic,strong) TMMuiLazyScrollView *lazyScrollViewSectionTwo;
@property (nonatomic,strong) UILabel *labelSectionOne;
@property (nonatomic,strong) UILabel *labelSectionTwo;
@property (nonatomic,strong) NSMutableArray *lazyScrollViewOneArr; //sub fram arr
@property (nonatomic,strong) NSMutableArray *lazyScrollViewTwoArr;
@property (nonatomic,strong) NSMutableArray *lazyScrollDataSourceOneArr;
@property (nonatomic,strong) NSMutableArray *lazyScrollDataSourceTwoArr;
@end
@implementation ChooseCarTypeView

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
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        [self addSubview:self.backV];
        [self.backV addSubview:self.labelSectionOne];
        [self.backV addSubview:self.lazyScrollViewSectionOne];
        [self.backV addSubview:self.labelSectionTwo];
        [self.backV addSubview:self.lazyScrollViewSectionTwo];
        [self initViewFramData];
        [self setUI];
        
        self.lazyScrollViewSectionOne.backgroundColor = [UIColor redColor];
        self.lazyScrollViewSectionTwo.backgroundColor = [UIColor blueColor];
        [self.lazyScrollViewSectionOne reloadData];
        [self.lazyScrollViewSectionTwo reloadData];

    }
    return self;
}
- (void)initViewFramData{
//    NSInteger carTypeNum = 6+6+2;//2组
    NSInteger carTypeNum = 10;//2组
    for (int i = 1; i < carTypeNum+1 ; i++) {//第一组 i=1
        [self.lazyScrollViewOneArr addObject:[NSValue valueWithCGRect:CGRectMake(((i-1)%4)*SubViewMaxW+10 ,(i-1)/4*(H_SubBtn+10), W_SubBtn,H_SubBtn)]];
        _lazyScrollViewSectionOne.contentSize = CGSizeMake(Screen_W,H_lazyScrollViewSectionOne);
    }
    
    
    NSInteger carTwoTypeNum = _lazyScrollDataSourceTwoArr.count;//2组
    for (int i = 1; i < carTwoTypeNum+1 ; i++) {//第一组 i=1
        [self.lazyScrollViewTwoArr addObject:[NSValue valueWithCGRect:CGRectMake(((i-1)%4)*SubViewMaxW+10 ,(i-1)/4*(H_SubBtn+10), W_SubBtn,H_SubBtn)]];
        _lazyScrollViewSectionTwo.contentSize = CGSizeMake(Screen_W,H_lazyScrollViewSectionTwo);
    }
    NSLog(@"lazyScrollViewArr ==== %@",self.lazyScrollViewOneArr);
   
}
#pragma mark === TMMuiLazyScrollView delegate
- (NSUInteger)numberOfItemInScrollView:(TMMuiLazyScrollView *)scrollView
{
    return _lazyScrollViewOneArr.count;
}

- (TMMuiRectModel *)scrollView:(TMMuiLazyScrollView *)scrollView rectModelAtIndex:(NSUInteger)index
{
    CGRect rect = [(NSValue *)[self.lazyScrollViewOneArr objectAtIndex:index]CGRectValue];
    TMMuiRectModel *rectModel = [[TMMuiRectModel alloc]init];
    rectModel.absoluteRect = rect;
    rectModel.muiID = [NSString stringWithFormat:@"%ld",index];
    
    return rectModel;
}
#pragma mark ===
#pragma mark —————— sub 显示
- (UIView *)scrollView:(TMMuiLazyScrollView *)scrollView itemByMuiID:(NSString *)muiID
{
    NSInteger index = [muiID integerValue];
    CarTypeChooseBtn *subBtn= (CarTypeChooseBtn *)[scrollView dequeueReusableItemWithIdentifier:@"CarTypeChooseBtn"];
    if (!subBtn) {
        subBtn = [[CarTypeChooseBtn alloc]initWithFrame:[(NSValue *)[_lazyScrollViewOneArr objectAtIndex:index]CGRectValue]];
        subBtn.reuseIdentifier = @"CarTypeChooseBtn";
    }
    [subBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:subBtn];
    if (scrollView.tag == TAG_OneScrollView) {
        [subBtn setTitle:self.lazyScrollDataSourceOneArr[index] forState:UIControlStateNormal];
        subBtn.tag = CarTypeChooseBtn_OneSction_Tag + index;
    }else{
        [subBtn setTitle:self.lazyScrollDataSourceTwoArr[index] forState:UIControlStateNormal];
        subBtn.tag = CarTypeChooseBtn_TwoSction_Tag + index;
    }
    return subBtn;
}
#pragma mark ——————
- (void)subBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self newSelecdUI:sender];//两组互斥的点击状态更新
    [self newSelfSuperVNewSelecdUI:sender];//本btn同父视图的同级别点击状态更新
  //点击数据
    if (sender.tag<CarTypeChooseBtn_TwoSction_Tag) {//第一组 小车
        NSLog(@"  subBtnAction 小车 === %d",(sender.tag-CarTypeChooseBtn_OneSction_Tag));
    }else{
        NSLog(@"  subBtnAction 机车 === %d",(sender.tag-CarTypeChooseBtn_TwoSction_Tag));
    }
    if (_delegate &&[_delegate respondsToSelector:@selector(chooseCarType:)]) {
        [_delegate chooseCarType:@"subBtnAction_delegate"];
    }
    
}
- (void)newSelecdUI:(UIButton *)sender{
    if (sender.selected==YES) {
        if (sender.tag<CarTypeChooseBtn_TwoSction_Tag) {//小车 sub 点击
            for (int i = 0; i<self.lazyScrollViewSectionTwo.subviews.count; i++) {
                CarTypeChooseBtn *subV = (CarTypeChooseBtn*)self.lazyScrollViewSectionTwo.subviews[i];//机车点击取消
                subV.selected = NO;
                subV.layer.borderColor = [UIColor grayColor].CGColor;
            }
        }else{//机车
            for (int i = 0; i<self.lazyScrollViewSectionOne.subviews.count; i++) {
                CarTypeChooseBtn *subV = (CarTypeChooseBtn*)self.lazyScrollViewSectionOne.subviews[i];//机车点击取消
                subV.selected = NO;
                subV.layer.borderColor = [UIColor grayColor].CGColor;
            }
        }
    }
}

- (void)newSelfSuperVNewSelecdUI:(UIButton *)sender{
    if (sender.selected==YES) {
        sender.layer.borderColor = Y_RGBA(15, 100, 253, 1).CGColor;
        for (int i = 0; i<sender.superview.subviews.count; i++) {
            CarTypeChooseBtn *subV = sender.superview.subviews[i];
            if (sender.tag!=subV.tag) {
                subV.selected = NO;
                subV.layer.borderColor = [UIColor grayColor].CGColor;
            }
        }
    }else{
        sender.layer.borderColor = [UIColor grayColor].CGColor;
    }
}
#pragma mark ===
- (void)setUI{
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backV.superview.mas_left);
        make.right.equalTo(_backV.superview.mas_right);
        make.height.equalTo(_backV.superview.mas_height).multipliedBy(0.45);//总高度
        make.bottom.equalTo(_backV.superview.mas_bottom).offset(10);
    }];
    [_labelSectionOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_labelSectionOne.superview.mas_left).offset(10);
        make.top.equalTo(_labelSectionOne.superview.mas_top).offset(10);
        make.width.offset(40);
        make.height.offset(20);
        
    }];
    [_lazyScrollViewSectionOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lazyScrollViewSectionOne.superview.mas_left);
        make.right.equalTo(_lazyScrollViewSectionOne.superview.mas_right);
        make.top.equalTo(_labelSectionOne.mas_bottom).offset(10);
        make.height.equalTo(_backV.mas_height).multipliedBy(0.4);//总高度的
    }];
    [_labelSectionTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_labelSectionTwo.superview.mas_left).offset(10);
        make.top.equalTo(_lazyScrollViewSectionOne.mas_bottom).offset(10);
        make.width.offset(40);
        make.height.offset(20);
    }];
    [_lazyScrollViewSectionTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lazyScrollViewSectionTwo.superview.mas_left);
        make.right.equalTo(_lazyScrollViewSectionTwo.superview.mas_right);
        make.top.equalTo(_labelSectionTwo.mas_bottom).offset(10);
        make.bottom.equalTo(_lazyScrollViewSectionTwo.superview.mas_bottom).offset(-10);//总高度的
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
// section  ____one
- (TMMuiLazyScrollView *)lazyScrollViewSectionOne{
    if (!_lazyScrollViewSectionOne) {
        _lazyScrollViewSectionOne = [[TMMuiLazyScrollView alloc]init];
        _lazyScrollViewSectionOne.delegate = self;
        _lazyScrollViewSectionOne.dataSource = self;
        _lazyScrollViewSectionOne.tag = TAG_OneScrollView;
    }
    return _lazyScrollViewSectionOne;

}
- (UILabel *)labelSectionOne{
    if (!_labelSectionOne) {
        _labelSectionOne = [[UILabel alloc]init];
        _labelSectionOne.text = @"小车";
        _labelSectionOne.font = [UIFont boldSystemFontOfSize:15];
    }
    return _labelSectionOne;
}
//
- (NSMutableArray *)lazyScrollViewOneArr{
    if (!_lazyScrollViewOneArr) {
        _lazyScrollViewOneArr = [NSMutableArray array];
    }
    return _lazyScrollViewOneArr;
}
- (NSMutableArray *)lazyScrollDataSourceOneArr{
    if (!_lazyScrollDataSourceOneArr) {
        _lazyScrollDataSourceOneArr = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15", nil];
    }
    return _lazyScrollDataSourceOneArr;
}
// section  ____Two

- (TMMuiLazyScrollView *)lazyScrollViewSectionTwo{
    if (!_lazyScrollViewSectionTwo) {
        _lazyScrollViewSectionTwo = [[TMMuiLazyScrollView alloc]init];
        _lazyScrollViewSectionTwo.delegate = self;
        _lazyScrollViewSectionTwo.dataSource = self;
        _lazyScrollViewSectionTwo.tag = TAG_TwoScrollView;
    }
    return _lazyScrollViewSectionTwo;

}
- (UILabel *)labelSectionTwo{
    if (!_labelSectionTwo) {
        _labelSectionTwo = [[UILabel alloc]init];
        _labelSectionTwo.text = @"机车";
        _labelSectionTwo.font = [UIFont boldSystemFontOfSize:15];
    }
    return _labelSectionTwo;
}
 
- (NSMutableArray *)lazyScrollViewTwoArr{
    if (!_lazyScrollViewTwoArr) {
        _lazyScrollViewTwoArr = [NSMutableArray array];
    }
    return _lazyScrollViewTwoArr;
}
- (NSMutableArray *)lazyScrollDataSourceTwoArr{
    if (!_lazyScrollDataSourceTwoArr) {
        _lazyScrollDataSourceTwoArr = [[NSMutableArray alloc]initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"010",@"011",@"012",@"13",@"14",@"15", nil];
    }
    return _lazyScrollDataSourceTwoArr;
}
#pragma mark ==
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.hidden = YES;
}
@end
