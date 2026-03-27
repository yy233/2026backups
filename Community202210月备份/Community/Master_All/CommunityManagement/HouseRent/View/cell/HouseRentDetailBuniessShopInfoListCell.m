//
//  HouseRentDetailHouseInfoListCell.m
//  Community
//
//  Created by 余莹 on 2021/1/6.
//

#import "HouseRentDetailBuniessShopInfoListCell.h"
#define W_subLabel ((Screen_W-32)/2)
#define H_subLabel (20)
@interface HouseRentDetailBuniessShopInfoListCell ()
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) UIView *backView;

@end

@implementation HouseRentDetailBuniessShopInfoListCell //区别于house listcell 商铺的这个sublabel固定8个

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HouseRentDetailVcBuniessShopModelShopModel *)model{
    _model = model;
    NSInteger count = self.titleArr.count;
    [self.backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//旧数据去掉
    for (int i = 0; i < count; i ++) {
        UILabel *subLabel = [self getBaseSubLabel];
        NSInteger isOneHang = (i%2==0)? 0 : 1;//0行还是第1行
        NSInteger paiNum = i/2;//第几排
        if (paiNum>=2) {// titarr[i=45]----只做第一竖行 且二label宽度处理
            if (i%2==0) {//第三
                subLabel.frame = CGRectMake(0, paiNum*(H_subLabel+10), Screen_W-32, H_subLabel);
            }else{//第四排
                subLabel.frame = CGRectMake(0, (paiNum+1)*(H_subLabel+10), Screen_W-32, H_subLabel);//10间隔//宽度
            }
        }else{
            subLabel.frame = CGRectMake(isOneHang*W_subLabel, paiNum*(H_subLabel+10), W_subLabel, H_subLabel);//10间隔
        }
        switch (i) {
            case 0:
                subLabel.text = [NSString stringWithFormat:@"%@：%@",self.titleArr[i],[TextShowWithModelStr textShowWithModelStr:_model.shopTypeString]];
                break;
            case 1:
                subLabel.text = [NSString stringWithFormat:@"%@：%@",self.titleArr[i],[TextShowWithModelStr textShowWithModelStr:_model.floor]];
                break;
            case 2:
                subLabel.text = [NSString stringWithFormat:@"%@：%@",self.titleArr[i],[TextShowWithModelStr textShowWithModelStr:_model.shopBusinessString].length>0?[TextShowWithModelStr textShowWithModelStr:_model.shopBusinessString]:@"其他"];
                break;
            case 3:
                subLabel.text = [NSString stringWithFormat:@"%@：%@",self.titleArr[i], [TextShowWithModelStr textShowWithModelStr:_model.statusString]];
                break;
            case 4:
                subLabel.text = [NSString stringWithFormat:@"%@：面宽%0.1f米,进深%0.1f米,层高%0.1f米",self.titleArr[i],_model.shopWidth,_model.shopDepth,_model.shopHeight];
                break;
            case 5:
                subLabel.text = [NSString stringWithFormat:@"%@：起租期%ld月,免租期%ld月",self.titleArr[i],(long)_model.startLease,(long)_model.freeLease];
                break;
            default:
                break;
        }
        [self.backView addSubview:subLabel];
    }
}
- (UILabel *)getBaseSubLabel{
    UILabel *lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = [ThemeManager shareManager].mainTextColor;
    return lab;
}
#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor =  [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.contentView addSubview:self.backView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(10, 16, 10, 16));
    }];
}
#pragma mark= ====
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
    }
    return _backView;
}
- (NSArray *)titleArr{
    if (!_titleArr) {
//        _titleArr = @[@"房型",@"楼层",@"朝向",@"电梯",@"装修",@"年代",@"用途",@"权属"];//8个人
        _titleArr = @[@"类型",@"楼层",@"行业",@"状态",@"规格",@"租期"];//6个 且最后2个格式不一样
    }
    return _titleArr;
}

@end
