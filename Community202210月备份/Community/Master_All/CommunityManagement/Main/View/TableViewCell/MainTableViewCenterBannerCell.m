//
//  MainTableViewCenterBannerCell.m
//  Community
// 向上的轮播图
//  Created by 余莹 on 2020/11/16.
//

#import "MainTableViewCenterBannerCell.h"
@interface MainTableViewCenterBannerCell ()
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *imgView;
@end

@implementation MainTableViewCenterBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataSource:(NSMutableArray<TableViewTopAndCenterBannerCellModel *> *)dataSource{
    [self setTheme];
    _dataSource = dataSource;
    NSMutableArray *arrOfTitle = @[].mutableCopy;
    NSMutableArray *arrOfImgUrl = @[].mutableCopy;
    for (int i = 0; i<_dataSource.count; i++) {
       TableViewTopAndCenterBannerCellModel *bannerModel = dataSource[i];
        [arrOfTitle addObject:[TextShowWithModelStr textShowWithModelStr:bannerModel.pushTitle]];
    }
    _advertScrollView.titles = arrOfTitle;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.imgView];
        [self.backView addSubview:self.rightMoreBtn];
        [self.backView addSubview:self.advertScrollView];
        [self setUI];
        [self setTheme];
    }
    return self;
}
- (void)prepareForReuse{
    [super prepareForReuse];
    [self setTheme];
}
- (void)setTheme{
    _backView.backgroundColor = [ThemeManager shareManager].mainUrgentCellBackGroundColor;
    _advertScrollView.titleColor = [ThemeManager shareManager].mainUrgentCellTextColor;
    
//    _backView.backgroundColor = Y_ColorWith16FromRGB(0xF7F7F9);
//    _advertScrollView.titleColor = Y_ColorWith16FromRGB(0x6E727D);

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (void)setUI{
 
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_backView.superview);
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(5, 0, 10, 0));
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.superview.mas_left).offset(10);
        make.centerY.equalTo(_imgView.superview.mas_centerY);
        make.width.offset(30);
        make.height.offset(30);
    }];
    [_rightMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightMoreBtn.superview.mas_right).offset(-5);
        make.centerY.equalTo(_rightMoreBtn.superview.mas_centerY);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_advertScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_advertScrollView.superview.mas_centerY);
        make.left.equalTo(_imgView.mas_right).offset(10);
        make.right.equalTo(_rightMoreBtn.mas_left);
        make.height.equalTo(_advertScrollView.superview.mas_height).offset(10);
    }];
}
 
-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeCenter;//UIViewContentModeScaleAspectFit
        _imgView.image = [UIImage imageNamed:@"Notice"];
    }
    return _imgView;
}
- (SGAdvertScrollView*)advertScrollView{
    if (!_advertScrollView) {
        _advertScrollView = [[SGAdvertScrollView alloc]init];
        _advertScrollView.tag = MainCenterAdvertScrollView_TAG;
        _advertScrollView.titleFont = [UIFont systemFontOfSize:12];
        _advertScrollView.backgroundColor = [UIColor clearColor];
    }
    return _advertScrollView;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}
-(UIButton *)rightMoreBtn{
    if (!_rightMoreBtn) {
        _rightMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightMoreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _rightMoreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    if ([ThemeManager shareManager].type==ThemeType_White) {
        [_rightMoreBtn setImage:[UIImage imageNamed:@"rightSkip"] forState:UIControlStateNormal];
    }else{
        [_rightMoreBtn setImage:[UIImage imageNamed:@"rightSkip_white"] forState:UIControlStateNormal];
    }
    return _rightMoreBtn;
}
@end
