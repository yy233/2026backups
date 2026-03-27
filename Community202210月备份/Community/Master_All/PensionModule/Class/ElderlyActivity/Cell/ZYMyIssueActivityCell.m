//
//  ZYMyIssueActivityCell.m
//  Community
//
//  Created by ZY on 2021/11/13.
//

#import "ZYMyIssueActivityCell.h"
#import "ZYPensionMainActivityImageCollectionViewCell.h"

static NSString * const pensionMainActivityImageCollectionViewCellID = @"ZYPensionMainActivityImageCollectionViewCell";
#define kRecordVCellHeight 63
#define kDeleteVCellHeight 40

@interface ZYMyIssueActivityCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageVHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordVHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteVHeightConstraint;

// 顶部视图
@property (weak, nonatomic) IBOutlet UIView *topV;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *activityTypeLabel;


// 文本视图
@property (weak, nonatomic) IBOutlet UIView *textV;


// 图片视图
@property (weak, nonatomic) IBOutlet UIView *imageV;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *imageArray;


// 语音视图
@property (weak, nonatomic) IBOutlet UIView *recordV;

@property (weak, nonatomic) IBOutlet UIImageView *voiceImageView;

@property (nonatomic, strong) NSMutableArray *voiceImageArray;


// 删除视图
@property (weak, nonatomic) IBOutlet UIView *deleteV;


@property (nonatomic, strong) GKPhotoBrowser *photoBrowser;

@end

@implementation ZYMyIssueActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.playButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -8, -10, -8);
    [self.deleteButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:6];
    self.deleteButton.hitTestEdgeInsets = UIEdgeInsetsMake(-6, -10, -10, -10);
    
    self.imageVHeightConstraint.constant = kActivityCollectionViewCell_H + 15;
    [self customCollectionView];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"STOP_VOICE_ANIMATION_BACK", stopVoiceAnimationBack)
}

// 通知回调
- (void)stopVoiceAnimationBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        [self stopImageAnimation];
    });
}

// 移除通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"STOP_VOICE_ANIMATION_BACK");
}

// 设置数据model
- (void)setModel:(ZYPensionMainActivityDataModel *)model {
    _model = model;
    
    self.dateLabel.text = _model.publishTime.xh_format_yyyy_MM_dd_HH_mm;
    self.activityTypeLabel.text = _model.activityTypeName;
    self.distanceLabel.text = [NSString stringWithFormat:@"距离%@", [ZYFormatStringTool formatStringWithDistance:[_model.distance integerValue]]];
    if (_model.activityDesc.length > 0) {
        self.contentLabel.text = _model.activityDesc;
        self.textV.hidden = NO;
        self.contentLabelBottomConstraint.constant = 15;
    }else {
        self.contentLabel.text = @"";
        self.textV.hidden = YES;
        self.contentLabelBottomConstraint.constant = 0;
    }

    if (_model.picUrl.length > 0) {
        self.imageV.hidden = NO;
        self.imageVHeightConstraint.constant = kActivityCollectionViewCell_H + 15;
        if (self.imageArray.count > 0) {
            [self.imageArray removeAllObjects];
        }
        NSArray *array = [_model.picUrl componentsSeparatedByString:@","];
        [self.imageArray addObjectsFromArray:array];
        [self.collectionView reloadData];
    }else {
        self.imageV.hidden = YES;
        self.imageVHeightConstraint.constant = 0;
    }

    if (_model.voiceUrl.length > 0) {
        self.recordV.hidden = NO;
        self.recordVHeightConstraint.constant = kRecordVCellHeight;
        self.voiceTimeLabel.text = [NSString stringWithFormat:@"%ld″", _model.voiceTime];
        if (_model.isPlay) {
            [self.playButton setImage:[UIImage imageNamed:@"yl_stop"] forState:UIControlStateNormal];
            [self stopImageAnimation];
            [self playImageAnimationWithRepeatCount:_model.voiceTime];
        }else {
            [self.playButton setImage:[UIImage imageNamed:@"yl_play"] forState:UIControlStateNormal];
            [self stopImageAnimation];
        }
    }else {
        self.recordV.hidden = YES;
        self.recordVHeightConstraint.constant = 0;
    }

    if ([[ShareUserInfo sharedUserInfo].userInfo.uid isEqual:_model.userUuid] && !_model.isMain) {
        self.deleteV.hidden = NO;
        self.deleteVHeightConstraint.constant = kDeleteVCellHeight;
    }else {
        self.deleteV.hidden = YES;
        self.deleteVHeightConstraint.constant = 0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    
    return _imageArray;
}

- (NSMutableArray *)voiceImageArray {
    if (!_voiceImageArray) {
        _voiceImageArray = [NSMutableArray array];
        for (int i = 1; i <= 30; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"yl_record_item%d", i]];
            [_voiceImageArray addObject:image];
        }
    }
    
    return _voiceImageArray;
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:pensionMainActivityImageCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:pensionMainActivityImageCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYPensionMainActivityImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pensionMainActivityImageCollectionViewCellID forIndexPath:indexPath];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"yl_placeholder_picture"]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"图片%ld", indexPath.row);
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < self.imageArray.count; i++) {
        GKPhoto *photoModel = [[GKPhoto alloc] init];
        photoModel.url = [NSURL URLWithString:self.imageArray[i]];
        photoModel.originUrl = [NSURL URLWithString:self.imageArray[i]];
        [photos addObject:photoModel];
    }
    self.photoBrowser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:indexPath.row];
    self.photoBrowser.showStyle = GKPhotoBrowserShowStyleNone;
    [self.photoBrowser showFromVC:[self viewContainingController]];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kActivityCollectionViewCell_W, kActivityCollectionViewCell_H);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 16, 15, 16);
}

// item之间的左右间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 6;
}

// item之间的上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 6;
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
    if (self.voiceImageView.isAnimating) {
        [self.voiceImageView stopAnimating];
        // 清空动画数组
        self.voiceImageView.animationImages = nil;
    }
}

@end
