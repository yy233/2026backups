//
//  IssueHistroyListVcHouseTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/19.
//

#import "IssueHistroyListVcHouseTableViewCell.h"

@implementation IssueHistroyListVcHouseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setHouseCellmodel:(HouseRentListVcHouseCellModel *)houseCellmodel{
}
- (void)setHistoryhouseCellmodel:(IssueHistoryModel *)historyhouseCellmodel{
    _historyhouseCellmodel = historyhouseCellmodel;
    [self allNomailShowLabel];
    [self typeAddSubLabel];
    [self imgShow];
    [self changeTextColor];
}
 
- (void)imgShow{
    if (_historyhouseCellmodel.houseImage.length>0) {
        NSURL *imgUrl = [UrlWithString getURLWithStr:[NSString stringWithFormat:@"%@",_historyhouseCellmodel.houseImage]];
        [self.headImgv sd_setImageWithURL:imgUrl];
    }
}
- (void)allNomailShowLabel{
    self.titleLabel.text = [TextShowWithModelStr textShowWithModelStr: _historyhouseCellmodel.browseTitle];
    NSString *detailOne = [TextShowWithModelStr textShowWithModelStr:_historyhouseCellmodel.leaseType];//几室
    NSString *detailPingFang = [NSString stringWithFormat:@"%0.2f ㎡",_historyhouseCellmodel.acreage];
    NSString *detailAddress = [TextShowWithModelStr textShowWithModelStr: _historyhouseCellmodel.address];
    self.detailtitleLabel.text = [NSString stringWithFormat:@"%@·%@·%@",detailOne,detailPingFang,detailAddress];
    self.coseL.text = [TextShowWithModelStr textShowWithModelStr:_historyhouseCellmodel.price]; //[NSString stringWithFormat:@"%0.2f元/%@",_historyhouseCellmodel.housePrice,[TextShowWithModelStr textShowWithModelStr:_houseCellmodel.houseUnit]];
}
- (void)typeAddSubLabel{
 
    NSString *strOfModel = [TextShowWithModelStr textShowWithModelStr:_historyhouseCellmodel.leaseType];
    if (strOfModel.length==0) {
        self.typeModelLabel.text = @"不限";
    }else{
        self.typeModelLabel.text = strOfModel;
    }
    [self setTypeBackViewSubViews:@{}];// bug
}
- (void)setTypeBackViewSubViews:(NSDictionary *)houseAdvantage{
    NSInteger count = 0;
//    NSArray *typeKeysArr = [houseAdvantage allKeys];
    NSArray *typeKeysArr = [[NSArray alloc]initWithArray:[_historyhouseCellmodel.tag componentsSeparatedByString:@","]];//————————————bug
    if (typeKeysArr.count==0) {
        return;//空数据 不做小标签图
    }
    if(typeKeysArr.count==1 && [typeKeysArr.firstObject isEqualToString:@""]){
        return;//空数据 不做小标签图
    }
    if (typeKeysArr.count>3) {
        count = 3;//列表限制最多显示3个
    }else{
        count = typeKeysArr.count;
    }
    //add labe
    float  subLabY = 35;//整租合租有30w 初5间隔
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
    lab.layer.borderWidth = 1;
    return lab;
}
- (void)changeTextColor{
    self.titleLabel.textColor = [UIColor blackColor];
//    self.
}
@end
