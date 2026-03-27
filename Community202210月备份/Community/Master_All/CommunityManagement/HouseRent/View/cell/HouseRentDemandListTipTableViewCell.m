//
//  HouseRentDemandTextTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/10/16.
//

#import "HouseRentDemandListTipTableViewCell.h"
@interface HouseRentDemandListTipTableViewCell ()
//
@property (nonatomic,strong) UILabel *titleL;
 //
@property (nonatomic,strong) UIView *detailListBackView;

@end


@implementation HouseRentDemandListTipTableViewCell

- (void)setModel:(HouseRentDetailVcHouseModel *)model{
    _titleL.text = @"出租要求" ;
    _model = model;
    [self detailListBackViewAddSubBtn];
}
- (void)detailListBackViewAddSubBtn{
    CGFloat listViewH = [_model getHouseIntroduceListViewHeight];
    [_detailListBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(listViewH);//
    }];
    float btn_W = (Screen_W-32)/4;
    float btn_h = 20;
    float btn_jiancha = 10;//高度
    [self.detailListBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *arrOfObjIsShowText = [NSMutableArray arrayWithArray:[self.model.leaseRequireMap allKeys]];
    for (int i = 1; i < arrOfObjIsShowText.count+1; i ++) {
//        UIButton *btn = [self baseBtnWithText:[TextShowWithModelStr textShowWithModelStr:_model.houseFurniture[i-1]]];
        UIButton *btn = [self baseBtnWithText:arrOfObjIsShowText[i-1]];
        btn.frame = CGRectMake(((i-1)%4)*btn_W ,(i-1)/4*(btn_h+btn_jiancha), btn_W,btn_h);
        [self.detailListBackView addSubview:btn];
    }
}
- (UIButton *)baseBtnWithText:(NSString *)str{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    [btn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor];
//    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:str forState:UIControlStateNormal];
    //出租要求没有勾icon
    /**
     if ([ThemeManager shareManager].type==ThemeType_White) {
         [btn setImage:[UIImage imageNamed:@"Rentaldetails_Housing_Check_heise"] forState:UIControlStateNormal];
     }else{
         [btn setImage:[UIImage imageNamed:@"Rentaldetails_Housing_Check"] forState:UIControlStateNormal];
     }
     [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
     */
    return btn;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.detailListBackView];
       
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview.mas_top).offset(10);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.right.equalTo(_titleL.superview.mas_right).offset(-16);
        make.height.offset(20);
    }];
    [_detailListBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(5);
        make.left.equalTo(_detailListBackView.superview.mas_left).offset(16);
        make.right.equalTo(_detailListBackView.superview.mas_right).offset(-16);
        make.height.offset(20);//
    }];
}
 
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont boldSystemFontOfSize:17];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleL;
}
- (UIView *)detailListBackView{
    if (!_detailListBackView) {
        _detailListBackView = [[UIView alloc]init];
    }
    return _detailListBackView;
}

@end
