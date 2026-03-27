//
//  ZYChatFunctionView.m
//  Community
//
//  Created by ZY on 2021/4/21.
//

#import "ZYChatFunctionView.h"
#import "ZYChatFunctionCell.h"

static NSString * const chatFunctionCellID = @"ZYChatFunctionCell";
#define kChatFunctionCellWidth (kScreenW - 32) / 4
#define kChatFunctionCellHeight 90

@interface ZYChatFunctionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *iconImgArray;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation ZYChatFunctionView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self customUICollectionView];
}

#pragma mark - 懒加载
- (NSArray *)iconImgArray {
    if (!_iconImgArray) {
       // _iconImgArray = @[@"fun_photo", @"fun_camera", @"fun_videocall", @"fun_location", @"fun_voice", @"fun_favorite", @"fun_redbao", @"fun_zz"];
//        _iconImgArray = @[@"fun_photo", @"fun_camera", @"fun_videocall", @"fun_location", @"fun_voice"];
        _iconImgArray = @[@"fun_photo_black", @"fun_camera_black", @"position_icon_black", @"heimingdan_icon_black"];
    }
    
    return _iconImgArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
       // _titleArray = @[@"相册", @"拍照", @"视频", @"位置", @"语音输入", @"我的收藏", @"红包", @"转账"];//1026视频通话改成视频发送类型
//        _titleArray = @[@"相册", @"拍照", @"视频", @"位置", @"语音输入"];//1026视频通话改成视频发送类型
        _titleArray = @[@"相册", @"拍照", @"位置", @"黑名单"];//1026视频通话改成视频发送类型

    }
    
    return _titleArray;
}

#pragma mark - 定制collectionView
- (void)customUICollectionView {
    
    // 设置代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // 注册单元格
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZYChatFunctionCell" bundle:nil] forCellWithReuseIdentifier:chatFunctionCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.iconImgArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYChatFunctionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:chatFunctionCellID forIndexPath:indexPath];
    [cell.iconButton setImage:[UIImage imageNamed:self.iconImgArray[indexPath.row]] forState:UIControlStateNormal];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(collectionViewCellSelectItemAtIndexPath:)]) {
        [self.delegate collectionViewCellSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kChatFunctionCellWidth, kChatFunctionCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

@end
