//
//  ZYHouseRepairIssueEditCell.m
//  Community
//
//  Created by ZY on 2022/4/11.
//

#import "ZYHouseRepairIssueEditCell.h"
#import "ZYHouseRepairIssueImageCollectionViewCell.h"
#import "UITextView+YLTextView.h"

static NSString * const ZYHouseRepairIssueImageCollectionViewCelllID = @"ZYHouseRepairIssueImageCollectionViewCell";

@interface ZYHouseRepairIssueEditCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *contentV;

// 报事业主
@property (weak, nonatomic) IBOutlet UIView *ownerView;

@property (weak, nonatomic) IBOutlet UIImageView *ownerImageView;

@property (weak, nonatomic) IBOutlet UILabel *ownerTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *ownerContentLabel;

@property (weak, nonatomic) IBOutlet UIView *ownerLineView;

// 工单类型
@property (weak, nonatomic) IBOutlet UIView *orderView;

@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;

@property (weak, nonatomic) IBOutlet UILabel *orderTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderContentLabel;

@property (weak, nonatomic) IBOutlet UIView *orderLineView;

// 报事位置
@property (weak, nonatomic) IBOutlet UIView *addressView;

@property (weak, nonatomic) IBOutlet UIImageView *addressImageView;

@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressContentLabel;

@property (weak, nonatomic) IBOutlet UIView *addressLineView;

@property (weak, nonatomic) IBOutlet UIImageView *remarkImageView;

@property (weak, nonatomic) IBOutlet UILabel *remarkTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@property (weak, nonatomic) IBOutlet UIView *textContentV;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *imageDataArray;

@end

@implementation ZYHouseRepairIssueEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    [self.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW - 32, 500) radius:10 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
    
    [self.ownerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerViewTap)]];
    self.ownerImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"hr_yezhu_icon"];
    self.ownerTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.ownerContentLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.ownerLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    
    [self.orderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderViewTap)]];
    self.orderImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"hr_gongdan_icon"];
    self.orderTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.orderContentLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.orderLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    
    [self.addressView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressViewTap)]];
    self.addressImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"hr_bswz_icon"];
    self.addressTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.addressContentLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.addressLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    
    self.remarkImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"hr_bsms_icon"];
    self.remarkTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.recordButton.hitTestEdgeInsets = UIEdgeInsetsMake(0, -15, 0, -15);
    [self.recordButton addTarget:self action:@selector(recordButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.textContentV.layer.borderWidth = 0.5;
    self.textContentV.layer.borderColor = [ZYThemeManager shareManager].borderLineBackgroundThemeColor.CGColor;
    self.textContentV.layer.cornerRadius = 5;
    self.textContentV.layer.masksToBounds = YES;
    self.textView.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.textView.limitLength = @300;
    self.textView.placeholder = @"请描述您遇到的问题...";
    self.textView.placeholdColor = [ZYThemeManager shareManager].placeholderThemeColor;
    self.textView.placeholdFont = [UIFont systemFontOfSize:12];
    self.textView.wordCountLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
    
    [self customCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据model
- (void)setModel:(ZYHouseRepairIssueUploadModel *)model {
    _model = model;
    
    self.ownerContentLabel.text = [NSString stringWithFormat:@"%@  %@  %@", _model.name, _model.phone, _model.communityName];
    if (_model.typeName.length > 0) {
        self.orderContentLabel.text = _model.typeName;
    }
    if (_model.address.length > 0) {
        self.addressContentLabel.text = _model.address;
    }
    self.textView.placeholder = @"请描述您遇到的问题...";
}

// 设置数据
- (void)setImagesArray:(NSArray *)imagesArray {
    _imagesArray = imagesArray;
    
    if (self.imageDataArray.count > 0) {
        [self.imageDataArray removeAllObjects];
    }
    [self.imageDataArray addObjectsFromArray:_imagesArray];
    [self.imageDataArray addObject:@"add"];
    [self.collectionView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray *)imageDataArray {
    if (!_imageDataArray) {
        _imageDataArray = [NSMutableArray array];
    }
    
    return _imageDataArray;
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:ZYHouseRepairIssueImageCollectionViewCelllID bundle:nil] forCellWithReuseIdentifier:ZYHouseRepairIssueImageCollectionViewCelllID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imageDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYHouseRepairIssueImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYHouseRepairIssueImageCollectionViewCelllID forIndexPath:indexPath];
    if ([self.imageDataArray.lastObject isEqual:@"add"] && indexPath.row == self.imageDataArray.count - 1) {
        cell.addView.hidden = NO;
        cell.editView.hidden = YES;
        [cell.addView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addViewTap)]];
    }else {
        cell.addView.hidden = YES;
        cell.editView.hidden = NO;
        NSString *urlStr = [[self.imageDataArray[indexPath.row] componentsSeparatedByString:@";"] firstObject];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"yl_placeholder_picture"]];
        cell.editView.tag = 200 + indexPath.row;
        [cell.editView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentImgViewTap:)]];
        cell.deleteButton.tag = 300 + indexPath.row;
        [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(65, 65);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

#pragma mark - 处理点击事件
// 业主报事
- (void)ownerViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ownerViewEvent)]) {
        [self.delegate ownerViewEvent];
    }
}

// 工单类型
- (void)orderViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderViewEvent)]) {
        [self.delegate orderViewEvent];
    }
}

// 报事位置
- (void)addressViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressViewEvent)]) {
        [self.delegate addressViewEvent];
    }
}

// 语音
- (void)recordButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordButtonEvent)]) {
        [self.delegate recordButtonEvent];
    }
}

// 添加照片
- (void)addViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addPhotos)]) {
        [self.delegate addPhotos];
    }
}

// 选择照片
- (void)contentImgViewTap:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewTapWithIndex:)]) {
        [self.delegate imageViewTapWithIndex:tap.view.tag - 200];
    }
}

// 删除照片
- (void)deleteButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deletePhotoWithIndex:)]) {
        [self.delegate deletePhotoWithIndex:sender.tag - 300];
    }
}

@end
