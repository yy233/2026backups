//
//  WeatherBottomCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/24.
//

#import "WeatherBottomCell.h"
#import "WeatherBottomSubCell.h"

@interface WeatherBottomCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UIView *lineV;

@property(nonatomic, strong) UICollectionView *collectionV;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end


static NSString *const cellID = @"WeatherBottomSubCell";

@implementation WeatherBottomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
    }
    return self;
}

- (void)initView{
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(0);
        make.height.offset(44);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.offset(0.5);
        make.top.mas_equalTo(self.titleL.mas_bottom);
    }];
    
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.lineV.mas_bottom);
        make.height.offset(190);
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"生活指数";
        _titleL.font = FontSize_Vip_Bold(15);
        _titleL.textColor = [Tool getColorWithHexString:@"#000000"];
        _titleL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleL];
    }
    return _titleL;
}

- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:_lineV];
    }
    return _lineV;
}

- (UICollectionView *)collectionV{
    if (!_collectionV) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((Screen_W - 3)/4, 94);
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.minimumLineSpacing = 1;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//top0
        _collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 190) collectionViewLayout:flowLayout];
        _collectionV.showsHorizontalScrollIndicator = NO;
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        _collectionV.bounces = NO;
        _collectionV.backgroundColor = Y_RGBA(245, 245, 245, 1);
        
        [_collectionV registerClass:[WeatherBottomSubCell class] forCellWithReuseIdentifier: cellID];
        [self.contentView addSubview:_collectionV];
    }
    return _collectionV;
}

#pragma mark - 加载数据
- (void)setLiveIndexArray:(NSArray<ZYWeatherDataLiveIndexModel *> *)liveIndexArray {
    
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:liveIndexArray];
    
    [self.collectionV reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WeatherBottomSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.liveIndexModel = self.dataArray[indexPath.row];
    return cell;
}


#pragma mark - other

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
