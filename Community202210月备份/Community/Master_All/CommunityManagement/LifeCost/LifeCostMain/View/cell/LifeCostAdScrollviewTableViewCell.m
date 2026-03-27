//
//  LifeCostAdScrollviewTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/9.
//

#import "LifeCostAdScrollviewTableViewCell.h"

@interface LifeCostAdScrollviewTableViewCell ()
@property (nonatomic,strong)UIView *backView;
@end

@implementation LifeCostAdScrollviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark == 
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
       make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
   }];
   [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(_backView);
   }];
   _cycleScrollView.backgroundColor = [UIColor grayColor];
//    _backView.backgroundColor = [UIColor bm_colorGradientChangeWithSize:CGSizeMake(Screen_W, 200) direction:IHGradientChangeDirectionVertical startColor:[UIColor whiteColor] endColor:Color_MainVC_BackGround];
}

- (SDCycleScrollView *)cycleScrollView{
   if (!_cycleScrollView) {
       _cycleScrollView = [[SDCycleScrollView alloc]init];
       _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
       _cycleScrollView.currentPageDotColor = Y_RGBA(37, 95, 255, 1);
       _cycleScrollView.pageDotColor = [UIColor lightGrayColor];
       _cycleScrollView.tag = MainTopCycleScrollView_TAG;
       _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
       
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
