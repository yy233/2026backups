//
//  SmallShopPersonCenterMainVC.m
//  Community
//
//  Created by 余莹 on 2022/2/28.
// 0407隐藏我的货柜

#import "SmallShopPersonCenterMainVC.h"
#import "SmallShopPersonCenterMainCollectionViewCell.h"

#import "SmallShopMyBoxVC.h"
#import "SmallShppOrderVC.h"
#import "SmallShopCartListVC.h"
#import "SmallShopCartListViewModel.h"

//___________ 左右宽度数据相关
//数量 0407更改成2个item了
//#define ShowItemNum                           (3)                                                   //item总个数
#define ShowItemNum                           (2)
#define OneItemKongXi_W_Float                 (0.0)                                                //item内间距
#define ItemKongXiNum                         ( ShowItemNum - 1 )                                   //空隙数量= 例如(5 item - 1)=4个
#define AllItemKongXiBetween_W_Float          ( ItemKongXiNum * OneItemKongXi_W_Float)              //总内间距——w宽度
//宽度
#define Self_SubCollectionView_W_Float        ( Screen_W - 32.0 )                                     //CollectionView 总宽度
#define SelfAllItemCanUse_W_Float             ( Self_SubCollectionView_W_Float -  AllItemKongXiBetween_W_Float ) //本页剩余可用宽度
#define Self_SubCollectionView_OneItem_W_Float                       ( SelfAllItemCanUse_W_Float / ShowItemNum ) //单个cell宽度,（向下取整floor会有空隙 ）

//高度
#define CollectionView_All_Height               (110.0)
#define CollectionView_OneItem_Height           (110.0)


@interface SmallShopPersonCenterMainVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *sectionOneTitleArr;
@property (nonatomic,strong) NSMutableArray *sectionOneImgNameArr;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger nowCartGoodsCount;

@end

@implementation SmallShopPersonCenterMainVC

- (NSMutableArray *)sectionOneTitleArr{
    if (!_sectionOneTitleArr) {
        _sectionOneTitleArr = [[NSMutableArray alloc]initWithObjects:@"我的订单" ,@"购物车" , nil];
        //  _sectionOneTitleArr = [[NSMutableArray alloc]initWithObjects:@"我的货柜" ,@"我的订单" ,@"购物车" , nil];

    }
    return _sectionOneTitleArr;
}
- (NSMutableArray *)sectionOneImgNameArr{
    if (!_sectionOneImgNameArr) {
        _sectionOneImgNameArr = [[NSMutableArray alloc]initWithObjects:@"cc_dingdan_icon" ,@"cc_gouwuche_icon" , nil];
       // _sectionOneImgNameArr = [[NSMutableArray alloc]initWithObjects:@"cc_huogui_icon" ,@"cc_dingdan_icon" ,@"cc_gouwuche_icon" , nil];
    }
    return _sectionOneImgNameArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    self.nowCartGoodsCount = 0;
    [self initView];
    [self initData];
    [self addNoticeOfCreatOrderChangeThisCartCount];//在个人中心内 有订单生成 就需要处理刷新购物车相关数据

}
- (void)initData{
    WEAKSELF
    [SmallShopCartListViewModel getCartListNumCountWithBlock:^(NSInteger nowCartGoosNum, BOOL success) {
        if (success) {
            weakSelf.nowCartGoodsCount = nowCartGoosNum;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView reloadData];
            });
        }
      
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteStyle];
}
- (void)initView{
    self.view.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6);
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_collectionView.superview).offset(20);
        make.left.equalTo(_collectionView.superview).offset(16);
        make.right.equalTo(_collectionView.superview).offset(-16);
        make.height.offset(CollectionView_All_Height);
    }];
}

#pragma mark == UI
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(Self_SubCollectionView_OneItem_W_Float,CollectionView_OneItem_Height);
        //line 跟滚动方向相同的间距
        //item 跟滚动方向垂直的间距
        //sectionInset 是每个section内缩进 每个区内的区头和区尾到本区的Item之间的距离
        flowLayout.minimumLineSpacing = OneItemKongXi_W_Float;
        flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);//t,b.l.r
        // Vertical   上下滑条 （数据先铺 第一横行）
        // Horizontal 横轴滚动 （数据先铺 第一竖行）
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //flowLayout.headerReferenceSize
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Self_SubCollectionView_W_Float, CollectionView_All_Height) collectionViewLayout:flowLayout];
     
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SmallShopPersonCenterMainCollectionViewCell class] forCellWithReuseIdentifier:SmallShopPersonCenterMainCollectionViewCell_I];
//        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier: @"collectionView_Header"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.layer.cornerRadius = 10;
        _collectionView.clipsToBounds = YES;


    }
    return _collectionView;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sectionOneTitleArr.count;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier: @"collectionView_Header"   forIndexPath:indexPath];
//    view.frame = CGRectMake(0, 0, Screen_W, 20);
//    view.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6);
//    return view;
//}
//
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SmallShopPersonCenterMainCollectionViewCell *cell = (SmallShopPersonCenterMainCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:SmallShopPersonCenterMainCollectionViewCell_I  forIndexPath:indexPath];
  
    cell.titleLabel.text = self.sectionOneTitleArr[indexPath.item];
    cell.imgView.image = [UIImage imageNamed: self.sectionOneImgNameArr[indexPath.item]];
//    if (indexPath.item==2) {
    if (indexPath.item==1) {//隐藏了货柜
        cell.redNumL.text = [NSString stringWithFormat:@"%ld", self.nowCartGoodsCount];
        if(self.nowCartGoodsCount==0){
            cell.redNumL.hidden = YES;
        }else{
            cell.redNumL.hidden = NO;
        }
    }else{
        cell.redNumL.hidden = YES;
    }
 
    return cell;
}

#pragma mark ==== center one
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@" didSelectItem %ld",indexPath.item);
    
    switch (indexPath.item) {
        case 0://订单
        {
            
            SmallShppOrderVC *vc = [[SmallShppOrderVC alloc]init];
            [self pushVc:vc];
            
        }
            break;
        case 1://购物车
        {
            SmallShopCartListVC *vc = [[SmallShopCartListVC alloc]init];
            [self pushVc:vc];
        }
            break;
            
        default:
            break;
    }
   /**
    
    switch (indexPath.item) {
        case 0://货柜
        {
            SmallShopMyBoxVC *vc = [[SmallShopMyBoxVC alloc]init];
            [self pushVc:vc];
        }
            break;
        case 1://订单
        {
            
            SmallShppOrderVC *vc = [[SmallShppOrderVC alloc]init];
            [self pushVc:vc];
            
        }
            break;
        case 2://购物车
        {
            SmallShopCartListVC *vc = [[SmallShopCartListVC alloc]init];
            [self pushVc:vc];
        }
            break;
            
        default:
            break;
    }
    */
    
}

- (void)addNoticeOfCreatOrderChangeThisCartCount{
    Y_NSNotificationCenter_Creat_NameAction(Notice_SmallShopCarCreatOrderChangeOtherThings, initData);
    
}

- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(Notice_SmallShopCarCreatOrderChangeOtherThings)
}

@end
