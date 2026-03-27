//
//  MyOrderDetailVcBaseTopTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import "MyOrderDetailVcBaseTextTableViewCell.h"

@implementation MyOrderDetailVcBaseTextTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
        [self.backView addSubview:self.topTitleL];
        [self.backView addSubview:self.detailL];
        [self.backView addSubview:self.lineV];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_topTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topTitleL.superview.mas_top).offset(10);
        make.left.equalTo(_topTitleL.superview.mas_left).offset(10);
        make.height.offset(20);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topTitleL);
        make.top.equalTo(_topTitleL.mas_bottom);
        make.height.offset(20);
    }];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lineV.superview).offset(10);
        make.right.equalTo(_lineV.superview).offset(-10);
        make.height.offset(1);
        make.top.equalTo(_detailL.mas_bottom);
    }];
    
}
- (UILabel *)topTitleL{
    if (!_topTitleL) {
        _topTitleL  = [[UILabel alloc]init];
        _topTitleL.textColor = [UIColor blackColor];
        _topTitleL.font = FontSize_Orders_Bold(18);
    }
    return _topTitleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.text = @"由商家提供配送服务";
        _detailL.textColor  = Color_153GrayColor;
        _detailL.font = FontSize_Orders_Nomail(12);
        _detailL.numberOfLines = 2;
    }
    return _detailL;
}
- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = Color_245Gray;
    }
    return _lineV;
}
@end
