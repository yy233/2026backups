//
//  DappUsePopView.m
//  Socialize
//
//  Created by 余莹 on 2023/6/8.
//

#import "DappUsePopView.h"

#define  itemW  ((Screen_W-55)/4)
#define  itemH  (90)
#define ksectionTitileHeaderView_I   @"sectionTitileHeaderView_I"

@interface DappUsePopView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSArray *imgNameArr;
@end

@implementation DappUsePopView
- (NSArray *)dataArr{
    if(!_dataArr){
        _dataArr = @[Y_LocaleTypeFile_NSLocalString(@"刷新") ,
                     Y_LocaleTypeFile_NSLocalString(@"收藏") ,
                     Y_LocaleTypeFile_NSLocalString(@"复制链接"),
                     Y_LocaleTypeFile_NSLocalString(@"分享"),
                     Y_LocaleTypeFile_NSLocalString(@"浏览器打开")
        ];
    }
    return _dataArr;
}

- (NSArray *)imgNameArr{
    if(!_imgNameArr){//收藏_black
        _imgNameArr = @[@"刷新",
                     @"收藏",
                     @"复制",
                     @"分享",
                     @"浏览器",
        ];
    }
    return _imgNameArr;
}
#pragma mark == 重写
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
}
- (void)changMainBackViewBackColor{
    self.subMainBackView.backgroundColor = [UIColor whiteColor]; //Color_238GrayColor;//半截背景颜色配置
}
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.45;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubAllView];
        [self setUI];
    }
    return self;
}
- (void)addSubAllView{
    [self.subMainBackView  addSubview:self.cancelBtn];
    [self.subMainBackView  addSubview:self.collectionView];
}
- (void)setUI{
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_cancelBtn.superview);
        make.bottom.equalTo(_cancelBtn.superview).offset(-10);
        make.height.offset(70);
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_collectionView.superview);
        make.top.equalTo(_collectionView.superview);
        make.bottom.equalTo(_cancelBtn.mas_top);
    }];
    
}

- (UIButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn addTarget:self action:@selector(dismissThePopView) forControlEvents:UIControlEventTouchUpInside];
//        [_cancelBtn newAnBtnWithTextColor:Color_102Gray withBackColor: [UIColor whiteColor] withFont:[UIFont systemFontOfSize:16.0] withLayerCorNerNum:0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_cancelBtn newAnBtnWithTextColor:Color_51BlackColor withBackColor: [UIColor whiteColor] withFont:[UIFont systemFontOfSize:16.0] withLayerCorNerNum:0.0 withLayerLineWidth:1.0 withLayerLineColor: [UIColor lightGrayColor]];
        [_cancelBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"取消")];
    }
    return _cancelBtn;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, Screen_W, Screen_H-KNavBarHeight-60) collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PopsubCollectionViewCell class] forCellWithReuseIdentifier:@"PopsubCollectionViewCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ksectionTitileHeaderView_I];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ksectionTitileHeaderView_I];
        _collectionView.scrollEnabled = YES;
         
    }
    return _collectionView;
}



#pragma mark ===

#pragma mark - UICollectionViewDelegateFlowLayout
//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(itemW, itemH);
   
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 0, 10);//某Section总的上下左右
}

//动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}
//动态设置每行的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 20;
}

//动态设置某个分区头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 40);
}
//动态设置某个分区尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 1);
}
#pragma mark ==

//代理相应方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PopsubCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"PopsubCollectionViewCell" forIndexPath:indexPath];
    cell.titL.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row]];
    //图片
    if(indexPath.row == 1){//收藏是第二个
        if(self.isShouCangTypeBool){
            [cell.wightBtn newAnBtnWithImg: [UIImage imageNamed:@"收藏_black"]];
        }else{
            [cell.wightBtn newAnBtnWithImg: [UIImage imageNamed:@"收藏_wStar"]];

        }
    }else{
        [cell.wightBtn newAnBtnWithImg: [UIImage imageNamed:self.imgNameArr[indexPath.row]]];
    }
    //[cell.wightBtn newAnBtnWithImg:[UIImage imageNamed:@"更多"]];

   
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {//这是头部视图
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:ksectionTitileHeaderView_I   forIndexPath:indexPath];
        //[view addSubview:[self collectionHeader_sectionTitileHeaderView]];
        return view;
        
    }else{//15后foot复用UICollectionElementKindSectionHeader闪退。都得注册
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:ksectionTitileHeaderView_I   forIndexPath:indexPath];
        return view;
    }

}
- (UIView *)collectionHeader_sectionTitileHeaderView{
    UIView *sectionTitileHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 40)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, Screen_W-32, 40)];
    //titleLabel.text = @"页面管理";
    titleLabel.textColor = Color_51BlackColor;//Color_102Gray;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [sectionTitileHeaderView addSubview:titleLabel];
    return sectionTitileHeaderView;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"%s %ld",__func__,(long)indexPath.row);
    if(_popViewTouchDelegate && [_popViewTouchDelegate respondsToSelector:@selector(touchIndexType:)]){
        [_popViewTouchDelegate touchIndexType:indexPath.row];
    }
    [self dismissThePopView];
}
 

@end



@implementation PopsubCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titL];
        [self.contentView addSubview:self.wightBtn];
        self.wightBtn.userInteractionEnabled = NO;
        [_titL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_titL.superview);
            make.height.offset(30);
            make.bottom.equalTo(_titL.superview);
        }];
        [_wightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.offset(60);
            make.centerX.equalTo(_wightBtn.superview);
            make.bottom.equalTo(_titL.mas_top);
        }];
    }
    return self;
}

- (UILabel *)titL{
    if (!_titL)
    {
        _titL = [[UILabel alloc]init];
        _titL.backgroundColor = [UIColor clearColor];
        _titL.font = [UIFont systemFontOfSize:15.0];
        _titL.textColor = Color_51BlackColor;//Color_102Gray;
        _titL.textAlignment = NSTextAlignmentCenter;
        _titL.lineBreakMode = NSLineBreakByWordWrapping;
        _titL.numberOfLines = 0;
//        _titL.accessibilityIdentifier = @"empty set title";
    }
    return _titL;
}

- (UIButton *)wightBtn{
    if (!_wightBtn) {
        _wightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wightBtn newAnBtnWithTextColor:[UIColor whiteColor]
                            withBackColor:[UIColor whiteColor]
                                 withFont:[UIFont systemFontOfSize:15]
                       withLayerCorNerNum:6.0
                       withLayerLineWidth:1.0
                       withLayerLineColor:[UIColor whiteColor]];
        
     }
    return _wightBtn;
}

@end
