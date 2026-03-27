
//
//  HouseRentDetailTitleViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/4.
//

#import "HouseRentDetailBuniessShopTitleViewCell.h"
#define  BlueColor_TitleBottomLabel    Y_RGBA(38, 114, 249, 1)
@interface HouseRentDetailBuniessShopTitleViewCell ()
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIView *subBtnBackView;
@end

@implementation HouseRentDetailBuniessShopTitleViewCell
 
- (void)setModel:(HouseRentDetailVcBuniessShopModelShopModel *)model{
    _model = model;
    self.titleL.text = [TextShowWithModelStr textShowWithModelStr:_model.title];
    CGFloat h = [_model getBuniessCellTitleHeight];
    [_titleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(h);
    }];
    //
    NSArray *arrOfSubTags = model.tags;
    [self setTypeBackViewSubViews:arrOfSubTags];
}

- (void)setTypeBackViewSubViews:(NSArray *)houseAdvantage{
    NSInteger count = 0;
    NSArray *typeKeysArr = houseAdvantage;//
    if (typeKeysArr.count==0) {
        return;//空数据 不做小标签图
    }
    if (typeKeysArr.count>3) {
        count = houseAdvantage.count>=5 ? 5 : (houseAdvantage.count);//列表限制最多显示5个
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
        [self.subBtnBackView addSubview:lab];
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
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor =  [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.subBtnBackView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview.mas_top).offset(15);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.right.equalTo(_titleL.superview.mas_right).offset(-16);
//        make.height.equalTo(_titleL.superview.mas_height).multipliedBy(0.6);
        make.height.offset(20);
    }];
    [_subBtnBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(5);
        make.left.equalTo(_subBtnBackView.superview.mas_left).offset(16);
        make.right.equalTo(_subBtnBackView.superview.mas_right).offset(-16);
        make.bottom.equalTo(_subBtnBackView.superview.mas_bottom).offset(-5);
    }];
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont boldSystemFontOfSize:18];
        _titleL.numberOfLines = 0;
    }
    return _titleL;
}
- (UIView *)subBtnBackView{
    if (!_subBtnBackView) {
        _subBtnBackView = [[UIView alloc]init];
    }
    return _subBtnBackView;
}
@end
