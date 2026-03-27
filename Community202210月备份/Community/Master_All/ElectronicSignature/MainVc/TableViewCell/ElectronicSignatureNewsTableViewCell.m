//
//  ElectronicSignatureNewsTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/26.
//

#import "ElectronicSignatureNewsTableViewCell.h"
@interface ElectronicSignatureNewsTableViewCell ()
@property (nonatomic,strong) UIView *backV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *detailtitleL;
@property (nonatomic,strong) UIImageView *rightImgV;
//
//@property (nonatomic

@end
@implementation ElectronicSignatureNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据model
- (void)setModel:(ZYContractKnowledgeListDataListModel *)model {
    _model = model;
    
    _titleL.text = _model.title;
    _detailtitleL.text =  [NSString stringWithFormat:@"%@   %ld评论", _model.createTime, _model.commentNumber];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kElectronicSignatureImageBaseUrl, _model.image]];
    [_rightImgV sd_setImageWithURL:url placeholderImage: [UIImage imageNamed:@"p3"]];
}

//
- (void)showCellWithDic:(NSMutableDictionary *)dataSourceDic{
    _titleL.text = @"电子合同，又称电子商务合同根据联合国国际贸易";
    _detailtitleL.text = @"2021-01-13   15评论";
    _rightImgV.image = [UIImage imageNamed:@"p3"];
}
//

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.backV];
        [self.backV addSubview:self.titleL];
        [self.backV addSubview:self.detailtitleL];
        [self.backV addSubview:self.rightImgV];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backV.superview).insets(UIEdgeInsetsMake(10, 16, 0, 16));
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_titleL.superview);
        make.right.equalTo(_titleL.superview).offset(-130);
    }];
    [_detailtitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.bottom.equalTo(_detailtitleL.superview);
        make.right.equalTo(_titleL.mas_right);
    }];
    [_rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(_rightImgV.superview);
        make.width.offset(125);
    }];
}
//
- (UIView *)backV{
    if (!_backV) {
        _backV = [[UIView alloc]init];
    }
    return _backV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ZYThemeManager shareManager].titleThemeColor;
        _titleL.font = [UIFont systemFontOfSize:15];
        _titleL.numberOfLines = 2;
    }
    return _titleL;
}
- (UILabel *)detailtitleL{
    if (!_detailtitleL) {
        _detailtitleL = [[UILabel alloc]init];
        _detailtitleL.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
        _detailtitleL.font = [UIFont systemFontOfSize:12];
        _detailtitleL.numberOfLines = 1;
    }
    return _detailtitleL;
}
- (UIImageView *)rightImgV{
    if (!_rightImgV) {
        _rightImgV = [[UIImageView alloc] init];
        _rightImgV.contentMode =  UIViewContentModeScaleAspectFill;
        [_rightImgV zy_cornerRadiusAdvance:2 rectCornerType:UIRectCornerAllCorners];
    }
    return _rightImgV;
}
@end
