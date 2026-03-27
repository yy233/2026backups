//
//  MainTableViewTopBannerCell.m
//  Community
//
//  Created by 余莹 on 2020/11/16.
//

#import "MainTableViewTopBannerCell.h"
@interface MainTableViewTopBannerCell ()
@property (nonatomic,strong)UIView *backView;
@end
@implementation MainTableViewTopBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setDataSource:(NSMutableArray<TableViewTopAndCenterBannerCellModel *> *)dataSource{
    _dataSource = dataSource;
    if (_dataSource.count==0) {
        return;
    }
    NSMutableArray *arrOfTitle = @[].mutableCopy;
    NSMutableArray *arrOfImgUrl = @[].mutableCopy;
    for (int i = 0; i<_dataSource.count; i++) {
       TableViewTopAndCenterBannerCellModel *bannerModel = dataSource[i];
        [arrOfTitle addObject:[TextShowWithModelStr textShowWithModelStr:bannerModel.desc]];
        [arrOfImgUrl addObject:[TextShowWithModelStr textShowWithModelStr:bannerModel.url]];
    }
    _cycleScrollView.titlesGroup = arrOfTitle;
    _cycleScrollView.imageURLStringsGroup = arrOfImgUrl;
}
 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.cycleScrollView];
        [self setUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (void)setUI{
  
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(10, 0, 10, 0));
    }];
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView);
    }];
}

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc]init];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = Y_RGBA(37, 95, 255, 1);
        _cycleScrollView.pageDotColor = [UIColor lightGrayColor];
        _cycleScrollView.tag = MainTopCycleScrollView_TAG;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"cc_placeholder_big_banner"];
        
    }
    return _cycleScrollView;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
@end
