//
//  ZhiBoTopTypeChooseView.m
//  Socialize
//
//  Created by 余莹 on 2023/8/10.
//

#import "ZhiBoTopTypeChooseView.h"
static CGFloat selfHeight =  80.0;
static NSString *subCollectionCell_I = @"subCollectionCell";
//#define Items_all_w  (Screen_W*3/4)
//#define Item_w       (Screen_W/4-15)
#define Item_w       (Screen_W/3-15) //0921宽度增加
#define Item_h       40

@interface ZhiBoTopTypeChooseView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *titilArr;
@end

@implementation ZhiBoTopTypeChooseView

- (NSArray *)titilArr{
    if(!_titilArr){
        //_titilArr = @[Y_LocaleTypeFile_NSLocalString(@"推荐"),Y_LocaleTypeFile_NSLocalString(@"语音直播"),Y_LocaleTypeFile_NSLocalString(@"视频直播")];
        _titilArr = @[Y_LocaleTypeFile_NSLocalString(@"正在直播"),Y_LocaleTypeFile_NSLocalString(@"预约直播")];

    }
    return _titilArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor * beginColor = JianBian_Blue_Color;// rgba(215, 250, 252, 1);//渐变色top顶的浅蓝色
//        UIColor * beginColor =  rgba(215, 250, 252, 1);//渐变色top顶的色 gba(218, 253, 211, 1) 中间色
//        UIColor * beginColor =  rgba(216, 251, 235, 1);//取中间值
        if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
            self.backgroundColor = beginColor;
        }else{
            self.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Drak_Str];;
        }
        self.nowZhiBoListTopSelectedType = ZhiBoListTopType_LiveIng;//初始时推荐类型
        [self addSubview:self.collectionView];
        self.collectionView.frame = frame;
  
    }
    return self;
}
 

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W*0.9, KNavBarHeight) collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SubCollectionCell class] forCellWithReuseIdentifier:subCollectionCell_I];
        _collectionView.scrollEnabled = YES;
         
    }
    return _collectionView;
 
}
#pragma mark - UICollectionViewDelegateFlowLayout
//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Item_w, Item_h);
   
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
//    return UIEdgeInsetsMake(10, 10, 0, 10);//某Section总的上下左右
    return UIEdgeInsetsMake(0,0,0,0);
}

//动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}
//动态设置每行的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

//动态设置某个分区头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 0.01);
}
//动态设置某个分区尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 0.01);
}
 
#pragma mark ==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titilArr.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SubCollectionCell*cell = (SubCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:subCollectionCell_I  forIndexPath:indexPath];
    if (!cell) {
         cell = [[SubCollectionCell alloc]initWithFrame:CGRectMake(0, 0, Item_w, Item_h)];
    }
    
    [cell.showBtn setTitle:self.titilArr[indexPath.row]  forState:UIControlStateNormal];
    if(indexPath.row ==  self.nowZhiBoListTopSelectedType){
        cell.showBtn.selected = YES;
        cell.showBtn.backgroundColor = Y_RGB(102, 208, 209);
        if(isIPhoneXSeries){
            cell.showBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        }else{
            cell.showBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];//w小的 不能17font

        }

    }else{
        cell.showBtn.selected = NO;
        cell.showBtn.backgroundColor = [UIColor clearColor];
        if(isIPhoneXSeries){
            cell.showBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        }else{
            cell.showBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            
        }
    }
    
 
        
  
        
 
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.nowZhiBoListTopSelectedType = indexPath.row;
    [collectionView reloadData];
    if (_delegate && [_delegate respondsToSelector:@selector(nowSelectedType: )]) {
        [_delegate nowSelectedType:indexPath.row];
    }
 
}

@end
#pragma mark ===

@implementation SubCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.showBtn];
        [self setsubUI];
   
    }
    return self;
}
- (void)setsubUI{
    
    [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_showBtn.superview);
        make.bottom.equalTo(_showBtn.superview);
        make.height.offset(30.0);
        make.width.offset(Item_w-4);
    }];
    self.showBtn.titleLabel.numberOfLines = 2;//多语言显示不完
    
}
 

- (UIButton *)showBtn{
    if(!_showBtn){
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
            
            [_showBtn setTitleColor:rgba(51, 51, 51,1) forState:UIControlStateNormal];
            [_showBtn setTitleColor:rgba(51, 51, 51,1) forState:UIControlStateSelected];
        }else{
            
            [_showBtn setTitleColor:rgba(238, 238, 238,1) forState:UIControlStateNormal];
            [_showBtn setTitleColor:rgba(238, 238, 238,1) forState:UIControlStateSelected];
        }
      
        _showBtn.userInteractionEnabled = NO;
        _showBtn.layer.cornerRadius = 15;
    }
    return _showBtn;
}

@end
