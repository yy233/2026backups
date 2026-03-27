//
//  PersonCenterNomalSubCollectionviewTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/18.
//

#import "PersonCenterNomalSubCollectionviewTableViewCell.h"
#import "PersonCenterNomalCollectionViewCell.h"
#import "PersonCenterMoneyCollectionViewCell.h"
#define  PersonCenterNomalCollectionViewCell_Identifier    @"PersonCenterNomalCollectionViewCell"
#define  PersonCenterMoneyCollectionViewCell_Identifier    @"PersonCenterMoneyCollectionViewCell"

#import "PersonCenterUseShowModel.h"


//(kMYAPP_Now_IS_HIDDEN_MORE_INDEX == 1)
 #if 1

 //三个/行 钱包一直都是3行
 #define BackView_width   (Screen_W-32)
 #define Cell_Width       (BackView_width-50)/3
 #define Cell_Width_TopCell       (BackView_width-60)/4
 #define Cell_Width_MoneyCell       (BackView_width-40-10)/3
 #define Cell_Height       ((Screen_W -32 -40)/4 +30)

// #elif
#else

 //4个/行
 #define BackView_width   (Screen_W-32)
 #define Cell_Width       (BackView_width-50)/4
 #define Cell_Width_TopCell       (BackView_width-60)/5
 #define Cell_Width_MoneyCell       (BackView_width-40-10)/3
 //#define Cell_Height      60
 #define Cell_Height       ((Screen_W -32 -40)/4 +30)


 #endif


////三个/行 钱包一直都是3行
//#define BackView_width   (Screen_W-32)
//#define Cell_Width       (BackView_width-50)/3
//#define Cell_Width_TopCell       (BackView_width-60)/4
//#define Cell_Width_MoneyCell       (BackView_width-40-10)/3
//#define Cell_Height       ((Screen_W -32 -40)/4 +30)



@interface PersonCenterNomalSubCollectionviewTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *moneyTopTitleArr;
@property (nonatomic,strong) NSMutableArray *moneyBottomTitleArr;
@property (nonatomic,strong) NSMutableArray *moneyCenterNumArr;
@end

@implementation PersonCenterNomalSubCollectionviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showInitWithMoneyType:(PersoncenterSubCollectionviewCell_Type)type andTopTitleArr:(NSMutableArray *)topTitleArr andBottomTitleArr:(NSMutableArray *)bottomTitleArr  andMoneyCenterNumArr:(NSMutableArray *)centerNumArr{//钱包cell的
    self.selfSubCellType = type;
    self.moneyTopTitleArr = topTitleArr;
    self.moneyBottomTitleArr = bottomTitleArr;
    self.moneyCenterNumArr = @[@(0),@(0),@(0)].mutableCopy;
    self.moneyCenterNumArr = centerNumArr;
    [self.collectionView reloadData];
}
- (void)showInitWithType:(PersoncenterSubCollectionviewCell_Type)type andTitleArr:(NSMutableArray *)dataSourceArr imgArr:(NSMutableArray *)imgNameDataSourceArr{
//- (void)showInitWithType:(PersoncenterSubCollectionviewCell_Type)type andArr:(NSMutableArray *)dataSourceArr{
    self.selfSubCellType = type;
    self.dataSourceArr = dataSourceArr;
    self.imgNameDataSourceArr = imgNameDataSourceArr;
    [self.collectionView reloadData];
}

- (void)showInitWithType:(PersoncenterSubCollectionviewCell_Type)type andShowUseModeArr:(NSMutableArray *)shwoUseModeArr{
    self.selfSubCellType = type;
    self.showUseModelArr = shwoUseModeArr;
    [self.collectionView reloadData];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selfSubCellType = PersoncenterSubCollectionviewCell_Type_Nomal;
        self.dataSourceArr = [[NSMutableArray alloc]init];
        self.showUseModelArr = [NSMutableArray arrayWithCapacity:0];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.collectionView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(5, 16, 5, 16));
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView.superview);
    }];
}
#pragma mark ===
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    if (self.selfSubCellType == PersoncenterSubCollectionviewCell_Type_Money) {
//        return self.moneyTopTitleArr.count;
////        return 3;
//
//    }else{
//        if (self.showUseModelArr.count>0) {
//            return self.showUseModelArr.count;
//        }else{
//            return self.dataSourceArr.count;
//        }
//
//    }
    
    return self.showUseModelArr.count;
   
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selfSubCellType == PersoncenterSubCollectionviewCell_Type_Money){
        return  CGSizeMake(Cell_Width_MoneyCell, Cell_Height);
//        return  CGSizeMake(100, 80);
    }else if(self.selfSubCellType == PersoncenterSubCollectionviewCell_Type_TopCell){
        return  CGSizeMake(Cell_Width_TopCell, Cell_Height);
    }else{ //非money 非顶部视图cell 则都是这个高度宽度
           
        if (self.selfSubCellType == PersoncenterSubCollectionviewCell_Type_House) {
            return  CGSizeMake(Cell_Width, Cell_Height);  //3个
        }else{
            return  CGSizeMake(Cell_Width, Cell_Height);//非money 非顶部视图cell 则都是这个高度宽度
        }
//        if (kMYAPP_Now_IS_HIDDEN_CAR == 1) {//隐藏车辆
//
//            if (self.selfSubCellType == PersoncenterSubCollectionviewCell_Type_House) { //item在同一行
//                return  CGSizeMake((Screen_W-32-3*10.0)/2, Cell_Height);//2个
//            }else{
//                return  CGSizeMake(Cell_Width, Cell_Height);  //3个
//            }
//        }else{
//            return  CGSizeMake(Cell_Width, Cell_Height);//非money 非顶部视图cell 则都是这个高度宽度
//
//        }
    }
   
}
// - (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PersonCenterNomalCollectionViewCell *cell = (PersonCenterNomalCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:PersonCenterNomalCollectionViewCell_Identifier  forIndexPath:indexPath];
    PersonCenterUseShowModel *useShowModel = self.showUseModelArr[indexPath.row];
    cell.bottomTextLabel.text = useShowModel.titleStr;
    if ([ThemeManager shareManager].type == ThemeType_White) {
        cell.topImgV.image = [UIImage imageNamed:[TextShowWithModelStr textShowWithModelStr:useShowModel.imgNameStr_W]];
    }else{
        cell.topImgV.image = [UIImage imageNamed:[TextShowWithModelStr textShowWithModelStr:useShowModel.imgNameStr_D]];
        
    }
    return cell;

    
        
//
//    if (self.selfSubCellType != PersoncenterSubCollectionviewCell_Type_Money) {
//        PersonCenterNomalCollectionViewCell *cell = (PersonCenterNomalCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:PersonCenterNomalCollectionViewCell_Identifier  forIndexPath:indexPath];
//
//        if ( self.showUseModelArr.count > 0) {
//            PersonCenterUseShowModel *useShowModel = self.showUseModelArr[indexPath.row];
//            cell.bottomTextLabel.text = useShowModel.titleStr;
//            if ([ThemeManager shareManager].type == ThemeType_White) {
//                cell.topImgV.image = [UIImage imageNamed:[TextShowWithModelStr textShowWithModelStr:useShowModel.imgNameStr_W]];
//            }else{
//                cell.topImgV.image = [UIImage imageNamed:[TextShowWithModelStr textShowWithModelStr:useShowModel.imgNameStr_D]];
//
//            }
//
//            return cell;
//        }else{
//            cell.bottomTextLabel.text = self.dataSourceArr[indexPath.row];
//            if (indexPath.item <= self.imgNameDataSourceArr.count-1) {
//                NSString *imgNameStr = [NSString stringWithFormat:@"%@",self.imgNameDataSourceArr[indexPath.row]];
//                if (imgNameStr.length<=0) {
//                    return cell;
//                }else{
//                    cell.topImgV.image  = [UIImage imageNamed:self.imgNameDataSourceArr[indexPath.row]];
//                }
//            }
//            return cell;
//        }
//
//
//
//
//    }else{
//        PersonCenterMoneyCollectionViewCell *cell = (PersonCenterMoneyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:PersonCenterMoneyCollectionViewCell_Identifier  forIndexPath:indexPath];
//        cell.topL.text = self.moneyTopTitleArr[indexPath.row];
//        cell.bottomL.text = self.moneyBottomTitleArr[indexPath.row];
//
//        if (self.moneyCenterNumArr.count>=3) {
//
//            if (indexPath.row==1) {
//                cell.centerL.text = [NSString stringWithFormat:@"%0.2f",[self.moneyCenterNumArr[indexPath.row] floatValue]];
//            }else{
//                cell.centerL.text = [NSString stringWithFormat:@"%d",[self.moneyCenterNumArr[indexPath.row] intValue]];
//            }
//        }
//         return cell;
//    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{//type=top的协议在子类重写
//    NSLog(@"NomalSubCollectionviewT didSelectItemAtIndexPath    %@",self.dataSourceArr[indexPath.row]);
    if (self.selfSubCellType == PersoncenterSubCollectionviewCell_Type_Nomal) {
        if (_nomalAndMoneyCellDelegate && [_nomalAndMoneyCellDelegate respondsToSelector:@selector(personVcNomalSubCollectionViewCellTouchUpItemWithIndex:)]) {
            [_nomalAndMoneyCellDelegate personVcNomalSubCollectionViewCellTouchUpItemWithIndex:indexPath.row];
        }
    }
    
    if (self.selfSubCellType == PersoncenterSubCollectionviewCell_Type_Money) {
        if (_nomalAndMoneyCellDelegate && [_nomalAndMoneyCellDelegate respondsToSelector:@selector(personVcNomalSubCollectionViewMoneyCellTouchUpItemWithIndex:)]) {
            [_nomalAndMoneyCellDelegate personVcNomalSubCollectionViewMoneyCellTouchUpItemWithIndex:indexPath.row];
        }
    }
    if (self.selfSubCellType == PersoncenterSubCollectionviewCell_Type_House) {// 房屋 用户页主认证相关的cell
        if (_nomalAndMoneyCellDelegate && [_nomalAndMoneyCellDelegate respondsToSelector:@selector(personVcNomalSubCollectionViewHouseCellTouchUpItemWithIndex:)]) {
            [_nomalAndMoneyCellDelegate personVcNomalSubCollectionViewHouseCellTouchUpItemWithIndex:indexPath.row];
        }
    }
    if (self.selfSubCellType == PersoncenterSubCollectionviewCell_Type_MoreRrecommend) {
        if (_nomalAndMoneyCellDelegate && [_nomalAndMoneyCellDelegate respondsToSelector:@selector(personVcNomalSubCollectionViewMoreRecommendCellTouchUpItemWithIndex:)]) {
            [_nomalAndMoneyCellDelegate personVcNomalSubCollectionViewMoreRecommendCellTouchUpItemWithIndex:indexPath.row];
        }
    }
   
   
}
#pragma mark ==
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
    }
    return _backView;
}
- (UICollectionView *)collectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake(Cell_Width, Cell_Height);//3个
    flowLayout.minimumInteritemSpacing = 10.0;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);//top
    
//    if (self.selfSubCellType == PersoncenterSubCollectionviewCell_Type_House) { //item在同一行
//        if (kMYAPP_Now_IS_HIDDEN_CAR == 1) {//隐藏车辆 两个在一行 宽度改变
//            flowLayout.itemSize =   CGSizeMake((Screen_W-32-3*10.0)/2, Cell_Height);//2个
//            flowLayout.minimumInteritemSpacing = 10.0;
//            flowLayout.minimumLineSpacing = 10;
//            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//            flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);//top
//        }else{
//            flowLayout.itemSize = CGSizeMake(Cell_Width, Cell_Height);
//            flowLayout.minimumInteritemSpacing = 10;
//            flowLayout.minimumLineSpacing = 10;
//            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//            flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);//top
//        }
//    }else{
//        if (kMYAPP_Now_IS_HIDDEN_CAR == 1) {//隐藏车辆
//            flowLayout.itemSize = CGSizeMake(Cell_Width, Cell_Height);//3个
//            flowLayout.minimumInteritemSpacing = 10.0;
//            flowLayout.minimumLineSpacing = 10;
//            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//            flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);//top
//        }else{
//            flowLayout.itemSize = CGSizeMake(Cell_Width, Cell_Height);
//            flowLayout.minimumInteritemSpacing = 10;
//            flowLayout.minimumLineSpacing = 10;
//            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//            flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);//top
//        }
//    }
    if (!_collectionView) {
    
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, BackView_width) collectionViewLayout:flowLayout];//BackView_width?
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PersonCenterNomalCollectionViewCell class] forCellWithReuseIdentifier:PersonCenterNomalCollectionViewCell_Identifier];
        [_collectionView registerClass:[PersonCenterMoneyCollectionViewCell class] forCellWithReuseIdentifier:PersonCenterMoneyCollectionViewCell_Identifier];
    }else{
        _collectionView.collectionViewLayout  = flowLayout;//BackView_width?

    }
    return _collectionView;
}
@end
