//
//  ZYSmallShopGoodsDetailImageCell.m
//  Community
//
//  Created by ZY on 2022/3/2.
//

#import "ZYSmallShopGoodsDetailImageCell.h"

@interface ZYSmallShopGoodsDetailImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic, strong) GKPhotoBrowser *photoBrowser;

@end

@implementation ZYSmallShopGoodsDetailImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.userInteractionEnabled = YES;
    [self.iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewTap)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据
- (void)setImageUrlStr:(NSString *)imageUrlStr {
    _imageUrlStr = imageUrlStr;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrlStr] placeholderImage:[UIImage imageNamed:@"cc_placeholder_big_banner"]];
}

#pragma mark - 处理点击事件
- (void)iconImageViewTap {
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < 1; i++) {
        GKPhoto *photoModel = [[GKPhoto alloc] init];
        photoModel.url = [NSURL URLWithString:self.imageUrlStr];
        photoModel.originUrl = [NSURL URLWithString:self.imageUrlStr];
        [photos addObject:photoModel];
    }
    self.photoBrowser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:0];
    self.photoBrowser.showStyle = GKPhotoBrowserShowStyleNone;
    [self.photoBrowser showFromVC:[self viewContainingController]];
}

@end
