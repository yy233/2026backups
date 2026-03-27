//
//  ZYMedicalMainFunctionCell.m
//  Community
//
//  Created by ZY on 2021/12/1.
//

#import "ZYMedicalMainFunctionCell.h"
#import "ZYMedicalMainFunctionServiceCollectionViewCell.h"
#import "ZYMedicalMainFunctionHealthCollectionViewCell.h"

static NSString * const medicalMainFunctionServiceCollectionViewCellID = @"ZYMedicalMainFunctionServiceCollectionViewCell";
static NSString * const medicalMainFunctionHealthCollectionViewCellID = @"ZYMedicalMainFunctionHealthCollectionViewCell";

@interface ZYMedicalMainFunctionCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *serviceTitleArray;

@property (nonatomic, strong) NSArray *serviceImageArray;

@property (nonatomic, strong) NSArray *healthContentArray;

@property (nonatomic, strong) NSArray *healthImageArray;

@property (nonatomic, strong) NSArray *healthColorArray;

@end

@implementation ZYMedicalMainFunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self customCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (NSArray *)serviceTitleArray {
    if (!_serviceTitleArray) {
        _serviceTitleArray = @[@"医疗服务", @"家人档案", @"健康数据", @"推荐产品"];
    }
    
    return _serviceTitleArray;
}

- (NSArray *)serviceImageArray {
    if (!_serviceImageArray) {
        _serviceImageArray = @[@"yl_fuwu", @"yl_dangan", @"yl_shuju", @"yl_changp"];
    }
    
    return _serviceImageArray;
}

- (NSArray *)healthContentArray {
    if (!_healthContentArray) {
        _healthContentArray = @[@"关注老人健康老年社交活动", @"快速填写病症获得专家消息"];
    }
    
    return _healthContentArray;
}

- (NSArray *)healthImageArray {
    if (!_healthImageArray) {
        _healthImageArray = @[@"yl_shejiao", @"yl_hands"];
    }
    return _healthImageArray;
}

- (NSArray *)healthColorArray {
    if (!_healthColorArray) {
        _healthColorArray = @[[UIColor zy_colorWithHexString:@"#7B3836"], [UIColor zy_colorWithHexString:@"#6778A1"]];
    }
    
    return _healthColorArray;
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:medicalMainFunctionServiceCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:medicalMainFunctionServiceCollectionViewCellID];
    [self.collectionView registerNib:[UINib nibWithNibName:medicalMainFunctionHealthCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:medicalMainFunctionHealthCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        
        return self.serviceTitleArray.count;
    }else {
        
        return self.healthContentArray.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYMedicalMainFunctionServiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:medicalMainFunctionServiceCollectionViewCellID forIndexPath:indexPath];
        cell.titleLabel.text = self.serviceTitleArray[indexPath.row];
        cell.iconImageView.image = [UIImage imageNamed:self.serviceImageArray[indexPath.row]];
        
        return cell;
    }else {
        ZYMedicalMainFunctionHealthCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:medicalMainFunctionHealthCollectionViewCellID forIndexPath:indexPath];
        cell.contentLabel.text = self.healthContentArray[indexPath.row];
        cell.iconImageView.image = [UIImage imageNamed:self.healthImageArray[indexPath.row]];
        UIColor *color = self.healthColorArray[indexPath.row];
        cell.contentLabel.textColor = color;
        cell.goButton.layer.borderColor = color.CGColor;
        [cell.goButton setTitleColor:color forState:UIControlStateNormal];
        if (indexPath.row == 0) {
            [cell.goButton setTitle:@"去参加" forState:UIControlStateNormal];
            cell.contentV.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(kHealthCollectionViewCell_W, kHealthCollectionViewCell_H) direction:IHGradientChangeDirectionLevel startColor:[UIColor zy_colorWithHexString:@"#FFF9F9"] endColor:[UIColor zy_colorWithHexString:@"#FFE6E5"]];
        }else {
            [cell.goButton setTitle:@"去填写" forState:UIControlStateNormal];
            cell.contentV.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(kHealthCollectionViewCell_W, kHealthCollectionViewCell_H) direction:IHGradientChangeDirectionLevel startColor:[UIColor zy_colorWithHexString:@"#F8FAFF"] endColor:[UIColor zy_colorWithHexString:@"#DFE8FF"]];
        }
        
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewSelectItemAtIndexPath:)]) {
        [self.delegate collectionViewSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return CGSizeMake(kServiceCollectionViewCell_W, kServiceCollectionViewCell_H);
    }else {
        
        return CGSizeMake(kHealthCollectionViewCell_W, kHealthCollectionViewCell_H);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 16, 10, 16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        
        return 20;
    }else {
        
        return 10;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 16;
}

@end
