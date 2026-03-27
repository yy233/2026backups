//
//  ElectronicSignatureHeaderSearchView.m
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import "ElectronicSignatureHeaderSearchView.h"
#import "ElectronicSignatureTopMainCollectionViewCell.h"
#define  ElectronicSignatureTopMainCollectionViewCell_Identifier    @"ElectronicSignatureTopMainCollectionViewCell"
@interface ElectronicSignatureHeaderSearchView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIImageView *titleImageV;
@property (nonatomic,strong) UIImageView *backImgv;
@property (nonatomic,strong) UIView *itemBackView;
@property (nonatomic,strong) UICollectionView *collectionView;
//
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *detailTitleArr;
@property (nonatomic,strong) NSMutableArray *imgNameArr;

@end

@implementation ElectronicSignatureHeaderSearchView

#pragma mark ==
- (void)showViewWithDataTitleArr:(NSMutableArray *)titleArr
              withDetailTitleArr:(NSMutableArray *)detailTitleArr
                      withImgArr:(NSMutableArray *)imgNameArr{
    [self.collectionView reloadData];
}

#pragma mark ==
-(instancetype)initWithFrame:(CGRect)frame {
    frame = CGRectMake(0, 0, Screen_W, 245 + status_height);
   self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor;
        [self addSubview:self.backImgv];
        [self addSubview:self.itemBackView];
        [self addSubview:self.titleImageV];
        [self addSubview:self.collectionView];
        [self setUI];
        // 注册主题色通知
        Y_NSNotificationCenter_Creat_NameAction(NOTICE_NAME_ThemeISChanged, themeChanged)
    }
    return self;
}

// 通知回调
- (void)themeChanged {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor;
        self.backImgv.image = [[ZYThemeManager shareManager] themeImageNamed:@"tbg"];
        self.titleImageV.image = [[ZYThemeManager shareManager] themeImageNamed:@"title_tbg"];
        self.collectionView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
        [self.collectionView reloadData];
        [self reloadInputViews];
    });
}

// 销毁通知
- (void)dealloc {

Y_NSNotificationCenter_RemoveNotice_Name(NOTICE_NAME_ThemeISChanged)
}

#pragma mark==
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(touchUpItemWithIndex:)]) {
        [_delegate touchUpItemWithIndex:indexPath.item];
    }
}
#pragma mark==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.titleArr.count;
}
 
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.titleArr.count == 0) {
        UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
        return cell;
    }
    ElectronicSignatureTopMainCollectionViewCell *cell = (ElectronicSignatureTopMainCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ElectronicSignatureTopMainCollectionViewCell_Identifier  forIndexPath:indexPath];
    //
    if (indexPath.item <= self.titleArr.count-1) {
        cell.titleL.textColor = [ZYThemeManager shareManager].titleThemeColor;
        cell.titleL.text = self.titleArr[indexPath.row];
        cell.detailL.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
        cell.detailL.text = self.detailTitleArr[indexPath.row];
        cell.imgV.image = [UIImage imageNamed:self.imgNameArr[indexPath.row]];
    }
     return cell;
}
#pragma mark===
- (void)setUI{
    [_backImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_backImgv.superview);
        make.height.offset(170 + status_height);
    }];
    [_itemBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_itemBackView.superview.mas_bottom).offset(-10);
        make.left.equalTo(_itemBackView.superview.mas_left).offset(16);
        make.right.equalTo(_itemBackView.superview.mas_right).offset(-16);
        make.height.offset(124);
    }];
    [_titleImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_titleImageV.superview);
        make.left.equalTo(_titleImageV.superview).offset(22);
        make.right.equalTo(_titleImageV.superview).offset(-22);
        make.bottom.equalTo(_itemBackView.mas_top);
    }];
  
    [self addSubItems];
}
- (void)addSubItems{
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_itemBackView.superview.mas_bottom).offset(-10);
        make.left.equalTo(_itemBackView.superview.mas_left).offset(16);
        make.right.equalTo(_itemBackView.superview.mas_right).offset(-16);
        make.height.offset(124);
    }];
    [self addShadow];
}
- (void)addShadow{
    _itemBackView.layer.cornerRadius = 5;
    _itemBackView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.1];
    _itemBackView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _itemBackView.layer.shadowOffset = CGSizeMake(2,6);
    _itemBackView.layer.shadowOpacity = 1;//阴影
  
}
#pragma mark ==
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((Screen_W-32-50)/3, 100);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);//top0
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 125) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
        _collectionView.layer.cornerRadius = 5;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ElectronicSignatureTopMainCollectionViewCell class] forCellWithReuseIdentifier:ElectronicSignatureTopMainCollectionViewCell_Identifier];
        if (@available(iOS 13.0, *)) {
            _collectionView.automaticallyAdjustsScrollIndicatorInsets = NO;
        } else {
            // Fallback on earlier versions
        }
    }
    
    return _collectionView;
}
#pragma mark ===
- (UIImageView *)titleImageV {
    if (!_titleImageV) {
        _titleImageV = [[UIImageView alloc] init];
        _titleImageV.image = [[ZYThemeManager shareManager] themeImageNamed:@"title_tbg"];
        _titleImageV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _titleImageV;
}
- (UIImageView *)backImgv{
    if (!_backImgv) {
        _backImgv = [[UIImageView alloc]init];
        _backImgv.image = [[ZYThemeManager shareManager] themeImageNamed:@"tbg"];
        _backImgv.contentMode = UIViewContentModeScaleToFill;
    }
    return _backImgv;
}
- (UIView *)itemBackView{
    if (!_itemBackView) {
        _itemBackView = [[UIView alloc] init];
    }
    return _itemBackView;
}
#pragma mark ===
 
#pragma mark ==
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]initWithObjects:@"实名认证", @"合同合规", @"区块链存证", nil];
    }
    return _titleArr;
}
- (NSMutableArray *)detailTitleArr{
    if (!_detailTitleArr) {
        _detailTitleArr = [[NSMutableArray alloc]initWithObjects:@"身份证+人脸识别", @"同等法律效力", @"去中心无法篡改", nil];
    }
    return _detailTitleArr;
}
- (NSMutableArray *)imgNameArr{
    if (!_imgNameArr) {
        _imgNameArr = [[NSMutableArray alloc]initWithObjects:@"sm", @"hg", @"qk", nil];
    }
    return _imgNameArr;
}
@end
