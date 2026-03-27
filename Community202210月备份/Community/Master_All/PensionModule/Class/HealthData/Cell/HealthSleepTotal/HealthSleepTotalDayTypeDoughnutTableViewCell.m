//
//  HealthSleepTotalDayTypeDoughnutTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/11/18.
//

#import "HealthSleepTotalDayTypeDoughnutTableViewCell.h"
#import "BaseHealthHeader.h"
#define CieclwPeogressV_WH  (130)

#define Color_CirclePathFillColor_Green             Y_ColorWith16FromRGB(0x36C8C1)//绿色
#define Color_CirclePathFillColor_Orange            Y_ColorWith16FromRGB(0xFA8951)
#define Color_CirclePathFillColor_Red               Y_ColorWith16FromRGB(0xFF0033)


@implementation HealthSleepTotalDayTypeDoughnutTableViewCell
 


- (void)fillDataWithTotalMin:(NSInteger)tatalMin andWithScoreNum:(NSInteger)scoreNum{

    double progressNum = (double)scoreNum/100;
    self.circleProgressView.progress = progressNum;
    //
    NSString *showStr = [NSString stringWithFormat:@"%ld分",scoreNum];
    self.detailL.attributedText = [self getSoreTextShowWithStr:showStr];
    
    //评分登记 颜色更换处理
    [self changeColorWithTotalMinNum:tatalMin];
    

}
#pragma mark ==
- (NSMutableAttributedString *)getSoreTextShowWithStr:(NSString *)str{
    if (str.length<=1 || [str isEqualToString:@"0分"]) {
        return [[NSMutableAttributedString alloc] initWithString:@"暂无"];//空串 //空数据 显示处理
    }else{
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        NSUInteger length = [str length];
        //设置字体
        UIFont *baseFont = [UIFont boldSystemFontOfSize:40.0];
        [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, length-1)];//分数
        UIFont *smailFont = [UIFont boldSystemFontOfSize:15.0];
        [attrString addAttribute:NSFontAttributeName value:smailFont range:NSMakeRange(length-1, 1)];//单位文本
        // 设置颜色 (同色 不分)
//        UIColor *colorGreen = Color_CirclePathFillColor_Green;//绿色
//        [attrString addAttribute:NSForegroundColorAttributeName
//                           value:colorGreen
//                           range:[str rangeOfString:str]];//全str
        return attrString;
    }
  
}
//评分  yong颜色更换处理
- (void)changeColorWithTotalMinNum:(NSInteger)totalMinNum{
        //
        if (totalMinNum >= DaySleepMinutesInv_GreenColorMin) {
            _detailL.textColor = Color_CirclePathFillColor_Green;//绿色
            _circleProgressView.pathFillColor =  Color_CirclePathFillColor_Green;//绿色
    
        }else if ( (totalMinNum< DaySleepMinutesInv_GreenColorMin) && (totalMinNum > DaySleepMinutesInv_OrangeColorMin)){
            _detailL.textColor = Color_CirclePathFillColor_Orange;
            _circleProgressView.pathFillColor =  Color_CirclePathFillColor_Orange;
    
        }else if((totalMinNum > 0 )&& (totalMinNum <= DaySleepMinutesInv_OrangeColorMin )){
            _detailL.textColor = Color_CirclePathFillColor_Red;
            _circleProgressView.pathFillColor =  Color_CirclePathFillColor_Red;
    
        }else{
          //空数据 保持绿色初始色
        }

}
 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.circleProgressView];
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.detailL];
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    [_circleProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(CieclwPeogressV_WH);
        make.centerX.centerY.equalTo(_circleProgressView.superview);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.centerX.equalTo(_circleProgressView);
        make.top.equalTo(_circleProgressView).offset(35);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(35);
        make.centerX.equalTo(_circleProgressView);
        make.top.equalTo(_titleL.mas_bottom).offset(10);
    }];
}
#pragma mark ===
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [PensionThemeManager shareManager].Pension_TextFont_13;
        _titleL.textColor = Y_ColorWith16FromRGB(0x6E727D);
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.text = @"睡眠评分";
        _titleL.backgroundColor = [UIColor clearColor];
    }
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.font = [UIFont boldSystemFontOfSize:38.0];
        _detailL.textColor = Color_CirclePathFillColor_Green;//绿色
        _detailL.textAlignment = NSTextAlignmentCenter;
        _detailL.text = @"";
        _detailL.backgroundColor = [UIColor clearColor];
    }
    return _detailL;
}
- (ZZCircleProgress *)circleProgressView{
    
    if (!_circleProgressView) {
        _circleProgressView = [[ZZCircleProgress alloc]init];
        _circleProgressView.frame = CGRectMake(0, 0, CieclwPeogressV_WH, CieclwPeogressV_WH);
        _circleProgressView.center = self.contentView.center;
        //_circleProgressView.increaseFromLast = YES;
        _circleProgressView.strokeWidth = 8;
        _circleProgressView.progress = 0.0;
        _circleProgressView.pathBackColor = Y_ColorWith16FromRGB(0xDDDDDD);//灰色
        _circleProgressView.pathFillColor =  Color_CirclePathFillColor_Green;//绿色
        //_circleProgressView.showProgressText = YES;
        _circleProgressView.showProgressText = NO;//%xxx
        _circleProgressView.animationModel = CircleIncreaseByProgress;//CircleIncreaseSameTime
   
    }
    return _circleProgressView;
}

@end
