//
//  VipHuiYuanView.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import "VipMemberHeaderView.h"
#import "VipHeaderViewSubOneCollectionViewCell.h"
#import "VipHeaderViewSubTwoCollectionViewCell.h"
//
#define  VipHeaderViewSubOneCollectionViewCell_Identifier                           @"VipHeaderViewSubOneCollectionViewCell"
#define  VipHeaderViewSubTwoCollectionViewCell_Identifier                           @"VipHeaderViewSubTwoCollectionViewCell"
//
#define  VipHeaderViewSubCollectionViewSectionReusableView_Identifier            @"VipHeaderViewSubCollectionViewSectionReusableView"

//
#define All_Height   362
#define Collor_VipBackView                  Y_RGBA(254, 225, 173, 1)
//subcell
#define CollectionV_ALL_W                   (Screen_W-32)
#define CollectionV_OneSection_W            ((CollectionV_ALL_W-50)/4)
#define CollectionV_TwoSection_W            ((CollectionV_ALL_W-40)/3)

@interface VipMemberHeaderView () <UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation VipMemberHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, All_Height);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backView];
        [self.backView addSubview:self.backImgV];
        [self.backView addSubview:self.titileBackImgV];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.bottomBtn];
        [self.backView addSubview:self.collectionView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    [_backImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backImgV.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    //___
    [_titileBackImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(_titileBackImgV.superview);
        make.height.offset(45);
        make.width.offset(260);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_titileBackImgV);
    }];
    //___
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomBtn.superview.mas_bottom).offset(-20);
        make.left.equalTo(_bottomBtn.superview.mas_left).offset(26);
        make.right.equalTo(_bottomBtn.superview.mas_right).offset(-26);
        make.height.offset(50);
    }];

    //___
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(10);
        make.left.right.equalTo(_backImgV);
        make.bottom.equalTo(_bottomBtn.mas_top).offset(-10);
    }];
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        UIColor *beginColor = Collor_VipBackView;
        UIColor *endColor = Y_RGBA(245, 245, 245, 1);
        CGSize size = CGSizeMake(Screen_W, All_Height);
        _backView.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:endColor];
    }
    return _backView;
}

- (UIImageView *)backImgV{
    if (!_backImgV) {
        _backImgV = [[UIImageView alloc]init];
        _backImgV.image = [UIImage imageNamed:@"Members_hairpin"];
    }
    return _backImgV;
}
//
- (UIImageView *)titileBackImgV{
    if (!_titileBackImgV) {
        _titileBackImgV = [[UIImageView alloc]init];
        _titileBackImgV.image = [UIImage imageNamed:@"Members_Title_bottom"];
    }
    return _titileBackImgV;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = Y_RGBA(114, 56, 0, 1);
        _titleL.text = @"开通会员每月享超20元优惠";
        _titleL.font = FontSize_Vip_Bold(17);
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}
//
- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIColor *beginColor = Y_RGBA(255, 114, 126, 1);
        UIColor *endColor = Y_RGBA(255, 71, 77, 1);
        CGSize size = CGSizeMake(Screen_W, All_Height);
        _bottomBtn.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionDownDiagonalLine startColor:beginColor endColor:endColor];
        [_bottomBtn newAnBtnWithTextStr:@"立即开通会员"];
        [_bottomBtn newAnBtnWithFont:FontSize_Vip_Bold(20)];
        [_bottomBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_bottomBtn newAnBtnWithLayerCorNerNum:25 withLayerLineWidth:0 withLayerLineColor:[UIColor clearColor]];
        [_bottomBtn addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

#pragma mark ==
- (void)bottomBtnAction{
    DLog(@"");
}
#pragma mark ==
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        flowLayout.itemSize = CGSizeMake((Screen_W-32-50)/3, 110);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
//        flowLayout.headerReferenceSize = CGSizeMake(Screen_W-32, 1);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CollectionV_ALL_W, 10) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[VipHeaderViewSubOneCollectionViewCell class] forCellWithReuseIdentifier: VipHeaderViewSubOneCollectionViewCell_Identifier];
        [_collectionView registerClass:[VipHeaderViewSubTwoCollectionViewCell class] forCellWithReuseIdentifier: VipHeaderViewSubTwoCollectionViewCell_Identifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:VipHeaderViewSubCollectionViewSectionReusableView_Identifier];
    }
    return _collectionView;
}

#pragma mark -------------
#pragma mark==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
        return 4;
    }else{
        return 3;
    }

}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        VipHeaderViewSubOneCollectionViewCell *cell = (VipHeaderViewSubOneCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:VipHeaderViewSubOneCollectionViewCell_Identifier  forIndexPath:indexPath];
            cell.centerL.text = @"¥5";
            cell.titleL.text = @"无门槛";
            cell.bottomL.text = @"专属红包";
       
         return cell;
    }else{
        VipHeaderViewSubTwoCollectionViewCell *cell = (VipHeaderViewSubTwoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:VipHeaderViewSubTwoCollectionViewCell_Identifier  forIndexPath:indexPath];
        if (indexPath.row==0) {
            cell.centerL.text = @"";
            cell.titleL.text = @"大额红包";
            cell.bottomL.text = @"会员红包可升级";
        }else if(indexPath.row==1){
            cell.centerL.text = @"";
            cell.titleL.text = @"低至5折起";
            cell.bottomL.text = @"特价加量红包";
        }else{
            cell.centerL.text = @"";
            cell.titleL.text = @"特价1折起";
            cell.bottomL.text = @"专享特价商品";
        }
      
         return cell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size =  CGSizeMake(10, 10);
    if (indexPath.section==0) {
        size =  CGSizeMake(CollectionV_OneSection_W, 87);
    }else{
        size =  CGSizeMake(CollectionV_TwoSection_W, 60);
    }
//    NSLog(@" _____%lf___%lf__%lf %lf",CollectionV_TwoSection_W,((CollectionV_ALL_W-50-20)/4),CollectionV_ALL_W,CollectionV_ALL_W-70);
    return size;
   
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //___
    if (indexPath.section==0) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:VipHeaderViewSubCollectionViewSectionReusableView_Identifier   forIndexPath:indexPath];
        return view;
    }else{
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:VipHeaderViewSubCollectionViewSectionReusableView_Identifier   forIndexPath:indexPath];
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
           
            UILabel *sectionTextL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 40)];
            sectionTextL.textAlignment = NSTextAlignmentCenter;
            sectionTextL.textColor = Y_RGBA(114, 56, 0, 1);
            sectionTextL.font = FontSize_Vip_Bold(15);
            sectionTextL.text = @"会员专属特权";
            [view addSubview:sectionTextL];
        }
        return view;
    }
   
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGSizeMake(Screen_W-32, 10);
    }else{
        return CGSizeMake(Screen_W-32, 40);
    }
  
}
//#pragma mark==
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==0) {
//        DLog(@"红包 %ld",(long)indexPath.item);
//    }else{
//        DLog(@"特权 %ld",(long)indexPath.item);
//    }
//}
#pragma mark -------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.headerViewDelegate && [self.headerViewDelegate respondsToSelector:@selector(baseTouchUpCollectionCellSection:andIndex:withSelfTableViewCellType:)]) {
        [self.headerViewDelegate baseTouchUpCollectionCellSection:indexPath.section andIndex:indexPath.item withSelfTableViewCellType:VipMamberTableViewCell_Type_NotCell_IsHeaderView];
    }
}
#pragma mark -------------
@end
