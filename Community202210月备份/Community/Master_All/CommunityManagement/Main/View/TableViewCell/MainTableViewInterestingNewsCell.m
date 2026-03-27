//
//  MainTableViewInterestingNewsCell.m
//  Community
//
//  Created by 余莹 on 2020/11/17.
//

#import "MainTableViewInterestingNewsCell.h"

#define mainTableViewCell_Bottom_News_Identifier @"MainTableViewInterestingNewsCell"
@interface MainTableViewInterestingNewsCell ()

@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detailTitleLabel;
@property (nonatomic,strong)UIImageView *rightImgView;
@property (nonatomic,strong)UIImageView *topIconImgView;
@end

@implementation MainTableViewInterestingNewsCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backView];
        [self.backView addSubview:self.rightImgView];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.detailTitleLabel];
        [self.backView addSubview:self.topIconImgView];
        [self setUI];
        [self setTheme];
    }
    return self;
}
-(void)prepareForReuse{
    [super prepareForReuse];
    _rightImgView.image = nil;
    _topIconImgView.image = nil;
    _titleLabel.text = nil;
    _detailTitleLabel.text = nil;
    [self setTheme];
}
- (void)setTheme{
    _titleLabel.textColor = [ThemeManager shareManager].mainInterestingNewsTextColor;
    _detailTitleLabel.textColor = [ThemeManager shareManager].mainInterestingNewsDetailTextColor;
    _backView.backgroundColor = [ThemeManager shareManager].mainInterestingNewsBackGroundColor; //用懒加载 更新不了

}
//- (void)setModel:(CommunityFunModel *)model{
- (void)fillData:(CommunityFunModel *)model{
    [self setTheme];
//    _model = model;
    _topIconImgView.backgroundColor = [UIColor brownColor];
    _titleLabel.text =  [TextShowWithModelStr textShowWithModelStr:model.titleName];
    _detailTitleLabel.text =  [TextShowWithModelStr textShowWithModelStr:model.content];
    NSURL *imgUrl =  [UrlWithString getURLWithStr:model.coverImageUrl];
    [_rightImgView sd_setImageWithURL:imgUrl];
 
 
    
}


- (void)setUI{
    _topIconImgView.hidden = YES;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(5, 0, 5, 0));
    }];
    [_rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(84);
        make.height.equalTo(_rightImgView.mas_width);
        make.centerY.equalTo(_backView.mas_centerY);
        make.left.equalTo(_rightImgView.superview.mas_left).offset(10);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightImgView.mas_top).offset(5);
        make.left.equalTo(_rightImgView.mas_right).offset(10);
        make.right.equalTo(_titleLabel.superview.mas_right).offset(-10);
//        make.height.equalTo(_titleLabel.superview.mas_height).multipliedBy(0.5);
    }];
    [_detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_titleLabel.mas_bottom).offset(1);
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_titleLabel.mas_right);
        make.bottom.equalTo(_rightImgView.mas_bottom).offset(-5);
    }];
    [_topIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.width.offset(25);
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_titleLabel.mas_top);
    }];
}
- (void)resetUI{
    _topIconImgView.hidden = NO;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(5, 0, 5, 0));
    }];
    [_rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(84);
        make.height.equalTo(_rightImgView.mas_width);
        make.centerY.equalTo(_backView.mas_centerY);
        make.left.equalTo(_rightImgView.superview.mas_left).offset(10);
    }];
    [_topIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.width.offset(25);
        make.left.equalTo(_rightImgView.mas_right).offset(10);
        make.top.equalTo(_rightImgView.mas_top);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topIconImgView.mas_top).offset(5);
        make.left.equalTo(_topIconImgView.mas_right).offset(3);
        make.right.equalTo(_titleLabel.superview.mas_right).offset(-10);
    }];
    [_detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_titleLabel.mas_right);
        make.bottom.equalTo(_rightImgView.mas_bottom).offset(-5);
    }];
    
}
- (UIImageView *)topIconImgView{
    if (!_topIconImgView) {
        _topIconImgView = [[UIImageView alloc]init];
        _topIconImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _topIconImgView;
}
- (UIImageView *)rightImgView{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc]init];
        _rightImgView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImgView.layer.cornerRadius = 5;
        _rightImgView.layer.masksToBounds = YES;
        _rightImgView.clipsToBounds = YES;
    }
    return _rightImgView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}
- (UILabel *)detailTitleLabel{
    if (!_detailTitleLabel) {
        _detailTitleLabel = [[UILabel alloc]init];
        _detailTitleLabel.numberOfLines = 1;
        _detailTitleLabel.font = [UIFont systemFontOfSize:12];
        _detailTitleLabel.textAlignment = NSTextAlignmentLeft;
        _detailTitleLabel.backgroundColor = [UIColor clearColor];
    }
    return _detailTitleLabel;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 5;
        _backView.layer.masksToBounds = YES;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}
@end
