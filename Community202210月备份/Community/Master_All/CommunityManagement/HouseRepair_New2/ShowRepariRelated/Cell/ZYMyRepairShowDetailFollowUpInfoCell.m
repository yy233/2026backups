//
//  ZYMyRepairShowDetailFollowUpInfoCell.m
//  Community
//
//  Created by ZY on 2022/4/13.
//

#import "ZYMyRepairShowDetailFollowUpInfoCell.h"
#import "ZYMyRepairShowDetailFollowUpInfoTextCollectionViewCell.h"
#import "ZYMyRepairShowDetailFollowUpInfoCollectionViewCell.h"

static NSString * const ZYMyRepairShowDetailFollowUpInfoTextCollectionViewCellID = @"ZYMyRepairShowDetailFollowUpInfoTextCollectionViewCell";
static NSString * const ZYMyRepairShowDetailFollowUpInfoCollectionViewCellID = @"ZYMyRepairShowDetailFollowUpInfoCollectionViewCell";

@interface ZYMyRepairShowDetailFollowUpInfoCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textCollectionViewConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *textCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;

@property (nonatomic, strong) NSArray *contentsArray;

@property (nonatomic, strong) NSArray *imagesArray;

@property (weak, nonatomic) IBOutlet UIView *voiceView;

@property (weak, nonatomic) IBOutlet UIImageView *voiceImageView;

@property (nonatomic, strong) NSMutableArray *voiceImageArray;

@property (nonatomic, strong) GKPhotoBrowser *photoBrowser;

@end

@implementation ZYMyRepairShowDetailFollowUpInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.lineView.backgroundColor = [UIColor zy_colorWithHexString:@"#B9D2FF"];
    }else {
        self.lineView.backgroundColor = [UIColor zy_colorWithHexString:@"#436298"];
    }
    self.playButton.hitTestEdgeInsets = UIEdgeInsetsMake(-8, -8, -8, -8);
    [self.playButton addTarget:self action:@selector(playButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self customCollectionView];
    
    // kvo监听
    [self.textCollectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"STOP_VOICE_ANIMATION_BACK", stopVoiceAnimationBack);
}

// 通知回调
- (void)stopVoiceAnimationBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        [self stopImageAnimation];
    });
}

// 移除监听
- (void)dealloc {
    [self.textCollectionView removeObserver:self forKeyPath:@"contentSize"];
    Y_NSNotificationCenter_RemoveNotice_Name(@"STOP_VOICE_ANIMATION_BACK");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据model
- (void)setModel:(ZYMyRepairShowDetailFollowUpInfoModel *)model {
    _model = model;
    
    self.contentsArray = _model.infoVOS;
    [self.textCollectionView reloadData];
    
    self.imagesArray = _model.imgs;
    if (_model.imgs.count > 0) {
        self.imageCollectionView.hidden = NO;
    }else {
        self.imageCollectionView.hidden = YES;
    }
    [self.imageCollectionView reloadData];
    
    if (_model.voiceUrl.length > 0) {
        self.voiceView.hidden = NO;
        self.voiceTimeLabel.text = [NSString stringWithFormat:@"%ld″", _model.voiceLength];
        if (_model.isPlay) {
            [self.playButton setImage:[UIImage imageNamed:@"hr_stop"] forState:UIControlStateNormal];
            [self stopImageAnimation];
            [self playImageAnimationWithRepeatCount:_model.voiceLength];
        }else {
            [self.playButton setImage:[UIImage imageNamed:@"hr_play"] forState:UIControlStateNormal];
            [self stopImageAnimation];
        }
    }else {
        self.voiceView.hidden = YES;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)voiceImageArray {
    if (!_voiceImageArray) {
        _voiceImageArray = [NSMutableArray array];
        for (int i = 1; i <= 25; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"vioce881_kul_0%d", i]];
            [_voiceImageArray addObject:image];
        }
    }
    
    return _voiceImageArray;
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    self.textCollectionView.tag = 200;
    self.textCollectionView.dataSource = self;
    self.textCollectionView.delegate = self;
    [self.textCollectionView registerNib:[UINib nibWithNibName:ZYMyRepairShowDetailFollowUpInfoTextCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:ZYMyRepairShowDetailFollowUpInfoTextCollectionViewCellID];
    
    self.imageCollectionView.tag = 300;
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.delegate = self;
    [self.imageCollectionView registerNib:[UINib nibWithNibName:ZYMyRepairShowDetailFollowUpInfoCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:ZYMyRepairShowDetailFollowUpInfoCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 200) {
        
        return self.contentsArray.count;
    }
    
    return self.imagesArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 200) {
        ZYMyRepairShowDetailFollowUpInfoTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYMyRepairShowDetailFollowUpInfoTextCollectionViewCellID forIndexPath:indexPath];
        ZYMyRepairShowDetailFollowUpInfoListModel *model = self.contentsArray[indexPath.row];
        cell.model = model;
        
        return cell;
    }
    
    ZYMyRepairShowDetailFollowUpInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYMyRepairShowDetailFollowUpInfoCollectionViewCellID forIndexPath:indexPath];
    [cell.iconImageView sd_setImageWithURL:self.imagesArray[indexPath.row] placeholderImage:[UIImage imageNamed:@"yl_placeholder_picture"]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 200) {
        ZYMyRepairShowDetailFollowUpInfoListModel *model = self.contentsArray[indexPath.row];
        CGSize size = [model.info boundingRectWithSize:CGSizeMake(kScreenW - 110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:12]} context:nil].size;
        
        return CGSizeMake(kScreenW - 90, size.height + 8);
    }
    
    return CGSizeMake(60, 60);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == 200) {
        return 0;
    }
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == 200) {
        return UIEdgeInsetsZero;
    }
    
    return UIEdgeInsetsMake(12, 0, 0, 0);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 300) {
        NSLog(@"图片%ld", indexPath.row);
        
        NSMutableArray *photos = [NSMutableArray array];
        for (int i = 0; i < self.imagesArray.count; i++) {
            GKPhoto *photoModel = [[GKPhoto alloc] init];
            photoModel.url = [NSURL URLWithString:self.imagesArray[indexPath.row]];
            photoModel.originUrl = [NSURL URLWithString:self.imagesArray[indexPath.row]];
            [photos addObject:photoModel];
        }
        self.photoBrowser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:indexPath.row];
        self.photoBrowser.showStyle = GKPhotoBrowserShowStyleNone;
        [self.photoBrowser showFromVC:[self viewContainingController]];
    }
}

#pragma mark - 动画相关事件
// 播放图片帧动画
- (void)playImageAnimationWithRepeatCount:(NSInteger)count {
    // 设置图片的序列帧
    self.voiceImageView.animationImages = [self.voiceImageArray copy];
    // 动画执行的时长
    self.voiceImageView.animationDuration = 1.0;
    // 动画重复次数
    self.voiceImageView.animationRepeatCount = 0;
    // 开始动画
    [self.voiceImageView startAnimating];
}

// 停止图片帧动画
- (void)stopImageAnimation {
    [self.voiceImageView stopAnimating];
    // 清空动画数组
    self.voiceImageView.animationImages = nil;
}

#pragma mark - kvo监听collectionView的高度变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat height = self.textCollectionView.contentSize.height;
        self.textCollectionViewConstraint.constant = height;
        NSLog(@"%lf", height);
        if (self.model.contentCollectionViewHeight != height || self.model.isRefreshing) {
            self.model.contentCollectionViewHeight = height;
            NSDictionary *dict = @{@"height" : @(height), @"indexPath" : self.model.indexPath};
            // 发送通知
            Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(@"COLLECTIONVIEW_HEIGHT_COMPLETE_BACK", dict);
        }
    }
}

#pragma mark - 处理点击事件
- (void)playButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playButtonEventWithIndexPath:)]) {
        [self.delegate playButtonEventWithIndexPath:self.model.indexPath];
    }
}

@end
