//
//  MyRepairEvaluationView.m
//  Community
//
//  Created by 余莹 on 2022/4/12.
//

#import "MyRepairEvaluationView.h"
#import "UITextView+YLTextView.h"//限制字数等

#define H_starsControl (30.0)
#define W_starsControl (200.0)//固定长度
#define W_Add_OneTextLabelUseShow (6.0)//单个文本的固定增加长度

@interface MyRepairEvaluationView ()

@property (nonatomic,strong) UIView *topBackView;
@property (nonatomic,strong) UIView *centerBackView;
@property (nonatomic,strong) UIView *statrBottomTextBackView;

@end

@implementation MyRepairEvaluationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topBackView];
        [self addSubview:self.centerBackView];
        [self addSubview:self.footerView];
        [self.topBackView addSubview:self.starsControl];
        [self.topBackView addSubview:self.statrBottomTextBackView];
        [self.centerBackView addSubview:self.textView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackView.superview).offset(15);
        make.centerX.equalTo(_topBackView.superview);
        make.width.equalTo(_topBackView.superview).offset(-32);
        make.height.offset(85.0);
    }];
    
    [_centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackView.mas_bottom).offset(10);
        make.centerX.equalTo(_centerBackView.superview);
        make.width.equalTo(_centerBackView.superview).offset(-32);
        make.height.offset(288.0);
    }];
    
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_footerView.superview).offset(-KIndicatorHeight-20-kNavBarHeight);
        make.left.right.equalTo(_footerView.superview);
        make.height.offset(90);
    }];
    //
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textView.superview).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    [self startsOtherUI];
    
    [UIView setAnimationsEnabled:NO];
}
- (void)dealloc{
    [UIView setAnimationsEnabled:YES];//自动调整TextView中输入文本时,UITableView闪烁停顿问题 UIScrollView变化
}
- (void)startsOtherUI{
    [_statrBottomTextBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_statrBottomTextBackView.superview);
        make.width.offset(W_starsControl+5*W_Add_OneTextLabelUseShow);//不够长 单个textL加等长（为了中心位置不变）总加了5W_Add_OneTextLabelUseShow
        make.height.offset(20);
        make.top.equalTo(_starsControl.mas_bottom).offset(5);
    }];
    [self statrBottomTextBackViewSubViews];

}
- (void)statrBottomTextBackViewSubViews{
    
    [self.statrBottomTextBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *stattTitleArr = @[@"非常不满意",@"不满意",@"一般",@"满意",@"非常满意"];
    CGFloat oneTitleL_W = (W_starsControl/stattTitleArr.count)+W_Add_OneTextLabelUseShow;//不够长 单个textL加W_Add_OneTextLabelUseShow等长（为了中心位置不变）总加了50
    for (int i = 0; i < stattTitleArr.count; i++) {
        UILabel *oneTitleL = [[UILabel alloc]init];
        oneTitleL.textAlignment = NSTextAlignmentCenter;
        oneTitleL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.85];
        oneTitleL.font = [UIFont systemFontOfSize:9.0];
        oneTitleL.frame = CGRectMake((0+oneTitleL_W)*i, 0, oneTitleL_W, 12.0);//0间距 12_h
        oneTitleL.text = stattTitleArr[i];
        [self.statrBottomTextBackView addSubview:oneTitleL];
    }
    
}
#pragma mark ===
- (UIView *)topBackView{
    if (!_topBackView) {
        _topBackView = [[UIView alloc]init];
        _topBackView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        _topBackView.layer.cornerRadius = 8.0;
        _topBackView.layer.masksToBounds = YES;
    }
    return _topBackView;
}
- (UIView *)centerBackView{
    if (!_centerBackView) {
        _centerBackView = [[UIView alloc]init];
        _centerBackView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        _centerBackView.layer.cornerRadius = 8.0;
        _centerBackView.layer.masksToBounds = YES;
    }
    return _centerBackView;
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.textColor = [ThemeManager shareManager].mainTextColor;
        _textView.font =  [UIFont systemFontOfSize:13.0];//12.0看起小了换成13
        _textView.limitLength = @300;
        _textView.placeholder = @"请输入您的评价";
        _textView.placeholdColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _textView.placeholdFont =   [UIFont systemFontOfSize:13.0];
        _textView.wordCountLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]; //计算字数
        _textView.layer.cornerRadius = 8.0;
        _textView.layer.masksToBounds = YES;
        _textView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;

    }
    return _textView;
}
//星星
 - (CDZStarsControl *)starsControl{
    if (!_starsControl) {
        CGRect statrFram = CGRectMake((Screen_W-32-W_starsControl)*0.5, 20.0, W_starsControl, H_starsControl);//上距离20 h30 文字需要在50+y开始
        _starsControl = [CDZStarsControl.alloc initWithFrame:statrFram
                                                       stars:5
                                                    starSize:CGSizeMake(17.5, 16.5)
                                             noramlStarImage:[UIImage imageNamed:@"pingjia_start_gray"]
                                        highlightedStarImage:[UIImage imageNamed:@"pingjia_start_yeollow"]];
     }
    return _starsControl;
 }
 
- (UIView *)statrBottomTextBackView{
    if (!_statrBottomTextBackView) {
        //不够长显示不完问题 单个textL加 W_Add_OneTextLabelUseShow等长（为了中心位置不变）总加了5*个
        _statrBottomTextBackView = [[UIView alloc]init];
        
    }
    return _statrBottomTextBackView;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[HouseRepairListVcFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView.footerBtn setTitle:@"发布评价" forState:UIControlStateNormal];
    }
    return _footerView;
}


@end
