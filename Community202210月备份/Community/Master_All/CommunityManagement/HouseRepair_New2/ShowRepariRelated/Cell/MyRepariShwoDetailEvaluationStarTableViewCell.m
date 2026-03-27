//
//  MyRepariShwoDetailEvaluationStarTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/4/12.
//评价星星

#import "MyRepariShwoDetailEvaluationStarTableViewCell.h"
#import "CDZStarsControl.h"

#define H_TitleLabelUseEnd (50)//星星从labelBottom开始
#define H_starsControl (30.0)
#define W_starsControl (200.0)//固定长度
#define W_Add_OneTextLabelUseShow (6.0)//单个文本的固定增加长度

@interface MyRepariShwoDetailEvaluationStarTableViewCell ()
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) CDZStarsControl *starsControl;//星星
@property (nonatomic,strong) UIView *statrBottomTextBackView;

@end

@implementation MyRepariShwoDetailEvaluationStarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillStarNum:(NSInteger)starNum{
    self.starsControl.score = starNum;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        //self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        WEAKSELF 
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.starsControl];
        [self.backView addSubview:self.statrBottomTextBackView];
        [self startsOtherUI];
  
    }
    return  self;
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

#pragma mark ==

//星星
 - (CDZStarsControl *)starsControl{
    if (!_starsControl) {
        CGRect statrFram = CGRectMake((Screen_W-32-W_starsControl)*0.5, H_TitleLabelUseEnd, W_starsControl, H_starsControl);//上距离H_TitleLabelUseEnd h30 文字需要在50+y开始
        _starsControl = [CDZStarsControl.alloc initWithFrame:statrFram
                                                       stars:5
                                                    starSize:CGSizeMake(17.5, 16.5)
                                             noramlStarImage:[UIImage imageNamed:@"pingjia_start_gray"]
                                        highlightedStarImage:[UIImage imageNamed:@"pingjia_start_yeollow"]];
        _starsControl.userInteractionEnabled = NO;//这里只用于展示不做点击
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
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, H_TitleLabelUseEnd)];
        _titleL.font = [UIFont systemFontOfSize:12];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.text = @"我的评价";
        _titleL.numberOfLines = 1;
    }
    return _titleL;
}

@end
