//
//  ZYCommunityFairDetailCarouselCell.m
//  Community
//
//  Created by ZY on 2021/8/7.
//

#import "ZYCommunityFairDetailCarouselCell.h"

#define kCycleScrollViewHeight 200.0/375.0*kScreenW

@interface ZYCommunityFairDetailCarouselCell () <SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *carouselView;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@end

@implementation ZYCommunityFairDetailCarouselCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.carouselView addSubview:self.cycleScrollView];
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_cycleScrollView.superview);
    }];
}

// 设置数据model
- (void)setModel:(ZYCommunityFairDetailDataModel *)model {
    _model = model;
    
    NSArray *array = [_model.images componentsSeparatedByString:@","];
    if (self.imagesArray.count > 0) {
        [self.imagesArray removeAllObjects];
    }
    for (NSString *str in array) {
        if (str.length > 0) {
            [self.imagesArray addObject:str];
        }
    }
    self.cycleScrollView.imageURLStringsGroup = self.imagesArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW, kCycleScrollViewHeight) delegate:self placeholderImage:[UIImage imageNamed:@"banner_default"]];
        _cycleScrollView.currentPageDotColor = Y_RGBA(36, 124, 250, 1);
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _cycleScrollView;
}

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    
    return _imagesArray;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    NSLog(@"%ld", index);
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleScrollViewSelectItemAtIndex:)]) {
        [self.delegate cycleScrollViewSelectItemAtIndex:index];
    }
}

@end
