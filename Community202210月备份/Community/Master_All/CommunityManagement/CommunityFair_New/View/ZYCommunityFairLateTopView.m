//
//  ZYCommunityFairLateTopView.m
//  Community
//
//  Created by ZY on 2022/6/6.
//

#import "ZYCommunityFairLateTopView.h"

#define kCycleScrollViewHeight 120.0/343.0*(kScreenW-32)

@interface ZYCommunityFairLateTopView () <SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UIView *carouselView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation ZYCommunityFairLateTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.searchViewTopConstraint.constant = status_height;
    [self.searchView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewTap)]];
    [self.carouselView addSubview:self.cycleScrollView];
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_cycleScrollView.superview);
    }];
//    self.cycleScrollView.imageURLStringsGroup = self.imagesArray;
    self.cycleScrollView.localizationImageNamesGroup = @[@"sj_hengfutu", @"sj_hengfutu"];
    self.bgImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"sj_ditu_yb"];
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.chatButton addTarget:self action:@selector(chatButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 懒加载
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW - 32, kCycleScrollViewHeight) delegate:self placeholderImage:[UIImage imageNamed:@"banner_default"]];
        _cycleScrollView.currentPageDotColor = Y_RGBA(36, 124, 250, 1);
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _cycleScrollView;
}

#pragma mark - 处理点击事件
- (void)searchViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchViewEvent)]) {
        [self.delegate searchViewEvent];
    }
}

- (void)backButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonEvent)]) {
        [self.delegate backButtonEvent];
    }
}

- (void)chatButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatButtonEvent)]) {
        [self.delegate chatButtonEvent];
    }
}

@end
