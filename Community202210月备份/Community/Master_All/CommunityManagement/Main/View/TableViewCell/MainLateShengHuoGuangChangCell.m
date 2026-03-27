//
//  MainLateShengHuoGuangChangCell.m
//  Community
//
//  Created by 余莹 on 2021/7/29.
//

#import "MainLateShengHuoGuangChangCell.h"
//#import "MainLateShengHuoGuangChangCellHeaderChangeTypeView.h"
//#define MainLateShengHuoGuangChangCellHeaderChangeTypeView_Identifier       @"MainLateShengHuoGuangChangCellHeaderChangeTypeView"

#import "MainLateShengHuoGuangChangSectionTopChooseView.h"
#define  MainLateShengHuoGuangChangSectionTopChooseView_Identifier       @"MainLateShengHuoGuangChangSectionTopChooseView"

#import "MainLateShengHuoGuangChangSubCollectionCell.h"
#define  MainLateShengHuoGuangChangSubCollectionCell_Identifier          @"MainLateShengHuoGuangChangSubCollectionCell"
  
#import "HouseRentListVcHouseCellModel.h"
#import "MainShengHuoGuangChangListErShouUseModel.h"
 
static NSString *kCollectionView_allViewSize = @"contentSize";

@interface MainLateShengHuoGuangChangCell ()
@property (nonatomic,strong) MainLateShengHuoGuangChangSectionTopChooseView *topChangeTypeView;
@property (nonatomic,assign) MainLateShengHuoGuangChangCell_TopHeader_Type headerType;
@property (nonatomic,strong) NSMutableArray* zuFangDataSourceArr;
@property (nonatomic,strong) NSMutableArray* erShouDataSourceArr;
@property (nonatomic, assign) CGFloat oldHeight;
@property (nonatomic, assign) MainLateShengHuoGuangChangCell_TopHeader_Type saveThisNewHeaderType;

@end


@implementation MainLateShengHuoGuangChangCell
#pragma mark ==== data
- (void)changeSelfDataWithType:(MainLateShengHuoGuangChangCell_TopHeader_Type)type{
    //切换类型
    self.headerType = type;
    //请求新类型数据
    self.touchTopHeaderBtnBlock(type);
    self.oldHeight -= 10; //这里换列表事需要清空旧数据操作,才能在新数据来后 数据刷新不复用旧的其他headerType类型的UI高度（-=10使之做superH的block）
   
}
- (NSMutableArray *)zuFangDataSourceArr{
    if (!_zuFangDataSourceArr) {
        _zuFangDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _zuFangDataSourceArr;
}
- (NSMutableArray *)erShouDataSourceArr{
    if (!_erShouDataSourceArr) {
        _erShouDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _erShouDataSourceArr;
}
- (void)fillShengHuoGuangChangWithZuFangArr:(NSMutableArray *)zuFangArr{//HouseRentListVcHouseCellModel
    self.headerType = MainLateShengHuoGuangChangCell_TopHeader_Type_ZuFang;//刷新后原本的数据空了
    [self.topChangeTypeView fillTypeWithIsZuFangOneBtnSelectedBoolShow:YES];
    self.zuFangDataSourceArr = [[NSMutableArray alloc]initWithArray:zuFangArr];
    [self.collectionView reloadData];
 }
- (void)fillShengHuoGuangChangWithErShouArr:(NSMutableArray *)erShouArr{
    self.headerType = MainLateShengHuoGuangChangCell_TopHeader_Type_ErShou;
    [self.topChangeTypeView fillTypeWithIsZuFangOneBtnSelectedBoolShow:NO];
    self.erShouDataSourceArr = [[NSMutableArray alloc]initWithArray:erShouArr];
    [self.collectionView reloadData];
 }

#pragma mark ====

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.headerType = MainLateShengHuoGuangChangCell_TopHeader_Type_ZuFang;//初始
        [self initView];
        [self addKvoOfSizeChange];
    }
    return self;
}
- (void)addKvoOfSizeChange{
    // kvo监听
    [self.collectionView addObserver:self forKeyPath:kCollectionView_allViewSize options:NSKeyValueObservingOptionNew context:nil];
}
// 移除监听
- (void)dealloc {
      [self.collectionView removeObserver:self forKeyPath:kCollectionView_allViewSize];
}
#pragma mark -  collectionView的高度变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kCollectionView_allViewSize]) {
        CGFloat height = self.collectionView.contentSize.height;
        NSLog(@"mian cell  sub collectionView的高度变化 == %@",NSStringFromCGSize(self.collectionView.contentSize));
        [self getNewAllHeightToSuperWithNowCollectionViewH:height];
    }
}

//- (void)getNewAllHeightToSuperWithNowCollectionViewH:(CGFloat )height{//self.collectionView.contentSize.h
//
//    CGFloat mainVcCellHeight = height+20 +50 + kTabBarHeight;//（主页 底部组 留20的空隙+ TabBar H）+ header50
//
//    if (self.oldHeight != mainVcCellHeight) {
//        self.oldHeight = mainVcCellHeight;
//        [self.collectionView setHeight:self.oldHeight];
//        // 发送新高度到主页刷新
//        if (isNotNil(self.getMainSubCellShowHeightBlock)) {
//            self.getMainSubCellShowHeightBlock(mainVcCellHeight );
//        }
//    }
//
//
//}

- (void)getNewAllHeightToSuperWithNowCollectionViewH:(CGFloat )height{
    //刷新后获取当前全部的高度 返回给父试图
    CGFloat maxCellHeight = self.collectionView.contentSize.height+50+kTabBarHeight;
    CGFloat superUseHeight = self.collectionView.contentSize.height+20;
//    CGFloat maxCellHeight = self.collectionView.contentSize.height+kTabBarHeight;
//    CGFloat superUseHeight = self.collectionView.contentSize.height+20+50+kTabBarHeight;
    
    if ((self.oldHeight != maxCellHeight ) || (self.saveThisNewHeaderType != self.headerType)) {
        self.oldHeight = maxCellHeight;
        self.saveThisNewHeaderType = self.headerType;
        [self.collectionView setHeight: (maxCellHeight)];//h50
        
    }else if (self.oldHeight != maxCellHeight ){
        self.oldHeight = maxCellHeight;
        [self.collectionView setHeight: (maxCellHeight)];//h50
    }else{
      
        return;
    }
    if (isNotNil(self.getMainSubCellShowHeightBlock)) {
        self.getMainSubCellShowHeightBlock(superUseHeight );
        //[self.collectionView setHeight: (maxCellHeight)];//h50

    }
    
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.getMainSubCellShowHeightBlock(  self.collectionView.contentSize.height+20);//（主页 底部组 留20的空隙）
//        //用内容高度 更新可视高度  （给底部组的总高度 为按钮50+原本内容高度 不变）
//        [self.collectionView setHeight: (self.collectionView.contentSize.height+50+kTabBarHeight)];//h50
//
//    });
}


#pragma mark ==== view

- (void)initView{
    
    LMJVerticalFlowLayout *layout = [[LMJVerticalFlowLayout alloc] initWithDelegate:self];
    
    UICollectionView *collocetView = ({
        //创建CollectionView
         UICollectionView *collocetView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-32, 50) collectionViewLayout:layout];
        collocetView.backgroundColor= [UIColor clearColor];
        //设置数据源和代理
        collocetView.delegate = self ;
        collocetView.dataSource = self ;
        collocetView.scrollEnabled = NO;//滑动禁止
        //注册cell 一定要做
        [collocetView registerClass:[MainLateShengHuoGuangChangSubCollectionCell class] forCellWithReuseIdentifier:MainLateShengHuoGuangChangSubCollectionCell_Identifier] ;
        collocetView ;
    });
    self.collectionView = collocetView;
    self.collectionView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);//h
    [self.collectionView setContentOffset:CGPointMake(0, -50)];

    //注册头部
//    [self.collectionView registerClass:[MainLateShengHuoGuangChangSectionTopChooseView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MainLateShengHuoGuangChangSectionTopChooseView_Identifier];
    [self.contentView addSubview:self.collectionView];
    [self initSubView];
}
#pragma mark ======
/**
 
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(LMJVerticalFlowLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
     return CGSizeMake(Screen_W, 50.0f);
 }

 - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
     if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {//这是头部视图
         UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:MainLateShengHuoGuangChangSectionTopChooseView_Identifier   forIndexPath:indexPath];
         MainLateShengHuoGuangChangSectionTopChooseView *topChooseView = [[MainLateShengHuoGuangChangSectionTopChooseView alloc]initWithFrame:CGRectZero];
         [view addSubview:topChooseView];
         topChooseView.btnTouchBlock = ^(MainLateShengHuoGuangChangCell_TopHeader_Type btnChooseType) {
             if (self.headerType != btnChooseType) {
                 [self changeSelfDataWithType:btnChooseType];
             }
         };
          return view;
     }else{
         return nil;
     }
 }
 
 */

- (MainLateShengHuoGuangChangSectionTopChooseView *)topChangeTypeView{
    if (!_topChangeTypeView) {
        _topChangeTypeView = [[MainLateShengHuoGuangChangSectionTopChooseView alloc]initWithFrame:CGRectMake(0, -50, Screen_W*0.5, 50)];

    }
    [_topChangeTypeView setTheme];//主题色
    return _topChangeTypeView;
}
- (void)initSubView{
    [self.collectionView addSubview:self.topChangeTypeView];
    WEAKSELF
    self.topChangeTypeView.btnTouchBlock = ^(MainLateShengHuoGuangChangCell_TopHeader_Type btnChooseType) {
        if (weakSelf.headerType != btnChooseType) {//不一样时 才做切换和数据更新请求
          [weakSelf changeSelfDataWithType:btnChooseType];
        }else{
            
        }
    };
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.headerType == MainLateShengHuoGuangChangCell_TopHeader_Type_ZuFang) {
        return self.zuFangDataSourceArr.count ;
    }else{
        return self.erShouDataSourceArr.count ;
    }
    NSLog(@"numberOfItemsInSection =| zf= %ld  |js =%ld  ",self.zuFangDataSourceArr.count,self.erShouDataSourceArr.count);
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MainLateShengHuoGuangChangSubCollectionCell *cell = (MainLateShengHuoGuangChangSubCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MainLateShengHuoGuangChangSubCollectionCell_Identifier forIndexPath:indexPath];
    
    if (self.headerType == MainLateShengHuoGuangChangCell_TopHeader_Type_ZuFang) {
        HouseRentListVcHouseCellModel *model = self.zuFangDataSourceArr[indexPath.row];
        [cell fillZuFangCellDataModel:model];
    }else{
        MainShengHuoGuangChangListErShouUseModel *model = self.erShouDataSourceArr[indexPath.row];
        [cell fillErShouShopCellDataModel :model];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    self.touchSubCellBlock(indexPath.row,self.headerType);
}

#pragma mark ==

#pragma mark - <LMJVerticalFlowLayoutDelegate>
- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
 
    
    if (self.headerType == MainLateShengHuoGuangChangCell_TopHeader_Type_ZuFang) {
        HouseRentListVcHouseCellModel *model = self.zuFangDataSourceArr[indexPath.row];
        return [model getHeightUseMainVcShow];
    }else{
        MainShengHuoGuangChangListErShouUseModel *model = self.erShouDataSourceArr[indexPath.row];
        return [model getHeightUseMainVcShow];
    }
}

/**
 *  需要显示的列数, 默认3
 */
- (NSInteger)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
 
///**
// *  行间距, 默认10
// */
//- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.item % 5) {
//        return 10;
//    }else
//    {
//        return 30;
//    }
//}

 
//  列间距, 默认10
 
- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView{
    return 10;
}
 
- (UIEdgeInsets)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}
@end
