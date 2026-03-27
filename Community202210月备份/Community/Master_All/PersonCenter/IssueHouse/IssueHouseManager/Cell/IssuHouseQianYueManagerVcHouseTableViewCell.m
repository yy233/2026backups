//
//  IssuHouseQianYueManagerVcHouseTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/9/1.
//

#import "IssuHouseQianYueManagerVcHouseTableViewCell.h"

@implementation IssuHouseQianYueManagerVcHouseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.imgV.image = nil;
    [self.blueSubsBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
    float  subLabY = 0;//整租合租有30w 初5间隔 //此处无整租合租
    for (int i=0; i<count; i++) {
        NSString *textStr = [NSString stringWithFormat:@"%@",typeKeysArr[i]];
        //基础
        UILabel *lab = [self subBaseLab];
        //文本+fram
        lab.text = [NSString stringWithFormat:@"%@",textStr];
        CGSize labSize = [[NSString stringWithFormat:@"%@",textStr] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}]; //文本尺寸
        CGRect fram = CGRectMake(subLabY,2, labSize.width+4, 20);//+2y +4w
        lab.frame = fram;
        //下次的fram 用到的y 更新
        subLabY = subLabY + labSize.width + 5+4;//5间隔 4w
        [self.blueSubsBackView addSubview:lab];
    }
}
- (UILabel *)subBaseLab{//基础
    UILabel *lab = [[UILabel alloc]init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:11];
    lab.layer.cornerRadius = 2;
    lab.textColor = Y_RGBA(38, 114, 249, 1);
    lab.layer.borderColor = Y_RGBA(38, 114, 249, 1).CGColor;
    lab.layer.borderWidth = 1;
    return lab;
}

#pragma mark =====
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.editBtn.hidden = YES;
        [self.backView addSubview:self.redNumL];
        [self.backView addSubview:self.redShowPoint];
        [self setRedLabelUI];
        [self changeCenterBackVAndBlueTagBackV];
    }
    return self;
}
- (void)setRedLabelUI{
    WEAKSELF
    [_redNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(14);
        make.top.equalTo(weakSelf.titleL);
        make.right.equalTo(weakSelf.redNumL.superview).offset(-7);
        make.width.greaterThanOrEqualTo(_redNumL.mas_height);
    }];
    [_redShowPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(7);
        make.bottom.equalTo(weakSelf.imgV);
        make.right.equalTo(weakSelf.redShowPoint.superview).offset(-7);
    }];
    _redShowPoint.layer.cornerRadius = 3.5;
    _redNumL.layer.cornerRadius = 7.0;
}
- (void)changeCenterBackVAndBlueTagBackV{
    WEAKSELF
    [self.typeL mas_updateConstraints:^(MASConstraintMaker *make) {//左边间隔和typeL都要隐去
        make.width.offset(1);
    }];
    [self.detailTipL mas_updateConstraints:^(MASConstraintMaker *make) {//左边间隔和typeL都要隐去
        make.left.equalTo(weakSelf.typeL.mas_right).offset(0);
    }];
    self.typeL.hidden = YES;
    //
    [self.centerSubsBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.titleL);
        make.top.equalTo(weakSelf.titleL.mas_bottom).offset(5);
        make.height.offset(20);
    }];
    [self.blueSubsBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.centerSubsBackView);
        make.top.equalTo(weakSelf.centerSubsBackView.mas_bottom).offset(5);
        make.height.offset(20);
    }];
    
}
- (UILabel *)redNumL{
    if (!_redNumL) {
        _redNumL = [[UILabel alloc]init];
        _redNumL.textColor = [UIColor whiteColor];
        _redNumL.backgroundColor = COlor_Red255;
        _redNumL.textAlignment = NSTextAlignmentCenter;
        _redNumL.font = [UIFont systemFontOfSize:11.0];
        _redNumL.layer.masksToBounds = YES;
        _redNumL.hidden = YES;//初始化隐藏
    }
    return _redNumL;
}
- (UILabel *)redShowPoint{
    if (!_redShowPoint) {
        _redShowPoint = [[UILabel alloc]init];
        _redShowPoint.backgroundColor = COlor_Red255;
        _redShowPoint.layer.masksToBounds = YES;
        _redShowPoint.hidden = YES;//初始化隐藏
    }
    return _redShowPoint;
}
@end
