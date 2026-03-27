//
//  HouseRepairOldInputLookDetailShowImgsTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/7.
//

#import "HouseRepairOldInputLookDetailShowImgsTableViewCell.h"
#import "HouseRepairOldInputLookDetailShowImgsSubCollectionViewCell.h"
//___________ 左右宽度数据相关
//数量
#define ShowItemNum                           (3)                                                   //item总个数
#define OneItemKongXi_W_Float                 (5.0)                                                //item内间距
#define ItemKongXiNum                         ( ShowItemNum - 1 )                                   //空隙数量= (5-1)=4个
#define AllItemKongXiBetween_W_Float          ( ItemKongXiNum * OneItemKongXi_W_Float)              //总内间距——w宽度
//宽度
#define Self_SubCollectionView_W_Float        ( Screen_W - 26*2.0)                                     //CollectionView 总宽度
#define SelfAllItemCanUse_W_Float             ( Self_SubCollectionView_W_Float -  AllItemKongXiBetween_W_Float ) //本页剩余可用宽度
#define Self_SubCollectionView_OneItem_W_Float                       ( SelfAllItemCanUse_W_Float / ShowItemNum ) //单个cell宽度,（向下取整floor会有空隙 ）

//
#define  HomeMain_SectionNum_MenuCell_SubBgView_Height  (100.0)

@interface HouseRepairOldInputLookDetailShowImgsTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *imgsDataArr;

@end

@implementation HouseRepairOldInputLookDetailShowImgsTableViewCell
- (NSMutableArray *)imgsDataArr{
    if (!_imgsDataArr) {
        _imgsDataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _imgsDataArr;
}
- (void)fillDataWithImgsArr:(NSArray *)imgsArr{
    self.imgsDataArr = [NSMutableArray arrayWithArray:imgsArr];
    [self.collectionView reloadData];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.collectionView];
        [self setUI];
    }
    return  self;
}
- (void)setUI{
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView.superview).insets(UIEdgeInsetsMake(0, 26, 0, 26));
    }];
}

#pragma make ==
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(Self_SubCollectionView_OneItem_W_Float,HomeMain_SectionNum_MenuCell_SubBgView_Height);
        //line 跟滚动方向相同的间距
        //item 跟滚动方向垂直的间距
        //sectionInset 是每个section内缩进 每个区内的区头和区尾到本区的Item之间的距离
        flowLayout.minimumLineSpacing = OneItemKongXi_W_Float;
        flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);//t,b.l.r
        // Vertical   上下滑条 （数据先铺 第一横行）
        // Horizontal 横轴滚动 （数据先铺 第一竖行）
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Self_SubCollectionView_W_Float, HomeMain_SectionNum_MenuCell_SubBgView_Height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[HouseRepairOldInputLookDetailShowImgsSubCollectionViewCell class] forCellWithReuseIdentifier:HouseRepairOldInputLookDetailShowImgsSubCollectionViewCell_I];
        //_collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgsDataArr.count;

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HouseRepairOldInputLookDetailShowImgsSubCollectionViewCell *cell = (HouseRepairOldInputLookDetailShowImgsSubCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HouseRepairOldInputLookDetailShowImgsSubCollectionViewCell_I  forIndexPath:indexPath];
    NSString *imgS = [TextShowWithModelStr textShowWithNotNullStr:self.imgsDataArr[indexPath.item]];
    if (imgS.length>0) {
        [cell.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:imgS] placeholderImage:[UIImage imageNamed:@"Repair_picture_icon"]];
    }else{
        cell.imgV.image = [UIImage imageNamed:@"Repair_picture_icon"];
    }
    return cell;
}

#pragma mark ===

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (isNotNil(self.touchImgBlock)) {
        self.touchImgBlock(indexPath.item);
    }
}
@end
