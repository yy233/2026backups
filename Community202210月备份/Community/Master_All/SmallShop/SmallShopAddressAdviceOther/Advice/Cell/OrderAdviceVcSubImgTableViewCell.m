//
//  OrderAdviceVcSubImgTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/3.
//

#import "OrderAdviceVcSubImgTableViewCell.h"
#import "AdviceSubImgCollectionViewCell.h"

#define Self_SubCollectionView_OneItem_W_Float (80)
#define HomeMain_SectionNum_MenuCell_SubBgView_Height (120)
#define OneItemKongXi_W_Float  (10)

@interface OrderAdviceVcSubImgTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *saveShowInfoArr;
@end

@implementation OrderAdviceVcSubImgTableViewCell
- (void)fillShowArrWith:(NSMutableArray *)showArr{
    self.saveShowInfoArr = showArr;
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
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.collectionView];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView.superview).insets(UIEdgeInsetsMake(10, 26, 10, 26));
    }];
}


#pragma mark ==== center one
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@" didSelectItem ");
    if (isNotNil(self.touchSubImgCollectionCellBlock)) {
        self.touchSubImgCollectionCellBlock(indexPath.item);
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.saveShowInfoArr.count<3) {
        return self.saveShowInfoArr.count+1;
    }else{
        return self.saveShowInfoArr.count;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AdviceSubImgCollectionViewCell *cell = (AdviceSubImgCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:AdviceSubImgCollectionViewCell_I  forIndexPath:indexPath];

    if ( (self.saveShowInfoArr.count<3) && (indexPath.item == [collectionView numberOfItemsInSection:0] -1)) {//最后一个本地cell
        cell.imgV.image = [UIImage imageNamed:@"cc_Uploadpictures_icon"];//+ 
        cell.bottomL.hidden = NO;
        return cell;
    }else{
        NSString *imgStr = self.saveShowInfoArr[indexPath.item];
        [cell.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:imgStr] placeholderImage:[UIImage imageNamed:@"morentup_icon"]];
        cell.bottomL.hidden = YES;
        return cell;
    }
    
}

#pragma mark ===
 
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
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, HomeMain_SectionNum_MenuCell_SubBgView_Height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[AdviceSubImgCollectionViewCell class] forCellWithReuseIdentifier:AdviceSubImgCollectionViewCell_I];
        //_collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}
 
@end
