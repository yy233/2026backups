//
//  ZYReportAboutRepairApplyInfoCell.m
//  Community
//
//  Created by ZY on 2022/3/7.
//

#import "ZYReportAboutRepairApplyInfoCell.h"
#import "ZYReportAboutRepairApplyInfoCollectionViewCell.h"

static NSString * const ZYReportAboutRepairApplyInfoCollectionViewCellID = @"ZYReportAboutRepairApplyInfoCollectionViewCell";

@interface ZYReportAboutRepairApplyInfoCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *addressView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *matterButton;

@property (weak, nonatomic) IBOutlet UIButton *repairButton;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel4;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel5;

@property (weak, nonatomic) IBOutlet UIView *lineView1;

@property (weak, nonatomic) IBOutlet UIView *lineView2;

@property (weak, nonatomic) IBOutlet UIView *lineView3;

@property (weak, nonatomic) IBOutlet UIView *lineView4;

@end

@implementation ZYReportAboutRepairApplyInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel1.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.titleLabel2.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.titleLabel3.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.titleLabel4.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.titleLabel5.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.lineView1.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.lineView2.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.lineView3.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.lineView4.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    
    [self.addressView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressViewTap)]];
    
    self.nameTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarN = class_getInstanceVariable([self.nameTF class], "_placeholderLabel");
    id placeholderLabelN = object_getIvar(self.nameTF, ivarN);
    [placeholderLabelN performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    
    self.telTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarT = class_getInstanceVariable([self.telTF class], "_placeholderLabel");
    id placeholderLabelT = object_getIvar(self.telTF, ivarT);
    [placeholderLabelT performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    
    [self.matterButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [self.matterButton setTitleColor:[ZYThemeManager shareManager].titleThemeColor forState:UIControlStateNormal];
    [self.matterButton addTarget:self action:@selector(matterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.repairButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [self.repairButton setTitleColor:[ZYThemeManager shareManager].titleThemeColor forState:UIControlStateNormal];
    [self.repairButton addTarget:self action:@selector(repairButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self customCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据model
- (void)setModel:(ZYReportAboutRepairApplyUploadModel *)model {
    _model = model;
    
    self.nameTF.text = _model.name;
    self.telTF.text = _model.phone;
    if (_model.address.length > 0) {
        self.addressLabel.text = _model.address;
        self.addressLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    }else {
        self.addressLabel.text = @"请选择住址";
        self.addressLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
    }
    if (_model.customRepairType == 2) {
        self.matterButton.selected = YES;
        self.repairButton.selected = NO;
    }else {
        self.matterButton.selected = NO;
        self.repairButton.selected = YES;
    }
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
}

#pragma mark - 懒加载
- (void)customCollectionView {
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:ZYReportAboutRepairApplyInfoCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:ZYReportAboutRepairApplyInfoCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYReportAboutRepairApplyInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYReportAboutRepairApplyInfoCollectionViewCellID forIndexPath:indexPath];
    ZYReportAboutRepairApplyCategoryModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewSelectItemAtIndexPath:)]) {
        [self.delegate collectionViewSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kZYReportAboutRepairApplyInfoCollectionViewCell_W, kZYReportAboutRepairApplyInfoCollectionViewCell_H);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

#pragma mark - 处理点击事件
// 住址
- (void)addressViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressViewEvent)]) {
        [self.delegate addressViewEvent];
    }
}

// 报事服务
- (void)matterButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(matterButtonEvent)]) {
        [self.delegate matterButtonEvent];
    }
}

// 报修服务
- (void)repairButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(repairButtonEvent)]) {
        [self.delegate repairButtonEvent];
    }
}

@end
