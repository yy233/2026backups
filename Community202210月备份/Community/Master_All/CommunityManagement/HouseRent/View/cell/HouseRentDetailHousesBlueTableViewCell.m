//
//  HouseRentDetailHousesBlueTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/6.
//

#import "HouseRentDetailHousesBlueTableViewCell.h"
@interface HouseRentDetailHousesBlueTableViewCell ()
@property (nonatomic,strong) UIView *typeBackView;
@end
@implementation HouseRentDetailHousesBlueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setModel:(HouseRentDetailVcHouseModel *)model{
    _model = model;
    
//    [self setTypeBackViewSubViews:model.houseAdvantage];
    [self setTypeBackViewSubViews:model.houseAdvantageCode];//0416改
}

- (void)setTypeBackViewSubViews:(NSDictionary *)houseAdvantage{
    NSInteger count = 0;
    NSArray *typeKeysArr = [houseAdvantage allKeys];
    if (typeKeysArr.count==0) {
        return;//空数据 不做小标签图
    }
    if (typeKeysArr.count>3) {
        count = 3;//列表限制最多显示3个
    }else{
        count = typeKeysArr.count;
    }
    //add labe
    float  subLabY = 0;//初0 初5间隔
    float textAddWidth = 5;
    float jiangeWidth = 5;
    for (int i=0; i<count; i++) {
        NSString *textStr = [NSString stringWithFormat:@"%@",typeKeysArr[i]];
        //基础
        UILabel *lab = [self subBaseLab];
        //文本+fram
        lab.text = [NSString stringWithFormat:@"%@",textStr];
        CGSize labSize = [[NSString stringWithFormat:@"%@",textStr] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}]; //文本尺寸
        CGRect fram = CGRectMake(subLabY,0, labSize.width+textAddWidth, 20);//+2y +4w
        lab.frame = fram;
        //下次的fram 用到的y 更新
        subLabY = subLabY + labSize.width + jiangeWidth+textAddWidth;//5间隔 4w
        [self.typeBackView addSubview:lab];
    }
}
- (UILabel *)subBaseLab{//基础
    UILabel *lab = [[UILabel alloc]init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:11];
    lab.layer.cornerRadius = 2;
    lab.textColor = Y_RGBA(38, 114, 249, 1);
    lab.layer.borderColor = Y_RGBA(38, 114, 249, 1).CGColor;
//    lab.layer.borderWidth = 1;
    lab.backgroundColor = [Y_RGBA(38, 114, 249, 1) colorWithAlphaComponent:0.1];
    return lab;
}

#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.contentView addSubview:self.typeBackView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_typeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_typeBackView.superview).insets(UIEdgeInsetsMake(10, 16, 10, 16));
    }];
}
- (UIView *)typeBackView{
    if (!_typeBackView) {
        _typeBackView = [[UIView alloc]init];
    }
    return _typeBackView;
}
@end
