//
//  AllStockRoomThingsShowCollectionViewCell.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/18.
//

#import <UIKit/UIKit.h>
//首页Collv tag
#define  ThisVcMainCollectionView_Tag    (1000)
//首页宽度高度
#define  ShowList_NumOfHorz               (1)
#define  ShowList_All_W                   (Screen_W-32)
#define  MainVc_CellItem_W                (ShowList_All_W/ShowList_NumOfHorz)
#define  MainVc_CellItem_H                (MainVc_CellItem_W*0.5)

static NSString * _Nullable AllStockRoomThingsShowCollectionViewCell_I = @"AllStockRoomThingsShowCollectionViewCell";
static NSString * _Nullable AllStockRoomThingsShowCollectionViewCell_subHaveTabv_I = @"AllStockRoomThingsShowCollectionViewCell_subHaveTabv";


NS_ASSUME_NONNULL_BEGIN

@interface AllStockRoomThingsShowCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIView *backView;

//@property (nonatomic,strong)UILabel *t_BNameL;
//@property (nonatomic,strong)UILabel *t_PosL;//位置
//@property (nonatomic,strong)UILabel *t_PackL;//盒/支单位
//@property (nonatomic,strong)UILabel *t_PiecesL;//数量
//@property (nonatomic,strong)UILabel *t_BuyPirceL;//购买价格
//@property (nonatomic,strong)UILabel *t_BuyFromL;
//@property (nonatomic,strong)UILabel *t_ProduceFromL;
//@property (nonatomic,strong)UILabel *t_Date_DoneL;
//@property (nonatomic,strong)UILabel *t_Date_UnPackL;
//@property (nonatomic,strong)UILabel *t_OwenrL;
//
//@property (nonatomic,strong)UILabel *BNameL;
//@property (nonatomic,strong)UILabel *PosL;
//@property (nonatomic,strong)UILabel *PackL;
//@property (nonatomic,strong)UILabel *PiecesL;
//@property (nonatomic,strong)UILabel *BuyPirceL;
//@property (nonatomic,strong)UILabel *BuyFromL;
//@property (nonatomic,strong)UILabel *ProduceFromL;
//@property (nonatomic,strong)UILabel *Date_DoneL;
//@property (nonatomic,strong)UILabel *Date_UnPackL;
//@property (nonatomic,strong)UILabel *OwenrL;

//@property (nonatomic,strong)UILabel *typeLabel;


@property (nonatomic,strong)UIImageView *imgView;


- (void)fillDataModel:(BrandStockInFoModel *)model;
- (void)fillDataModel:(BrandStockInFoModel *)model haveAddBtnShow:(BOOL)isShow;

@end

#pragma mark ===

@interface SubBaseTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *titL;
@property (nonatomic,strong) UILabel *contL;
@end

#define buyAddBtn_baseTag  (2000)
@interface AllStockRoomThingsShowCollectionViewCell_subHaveTabv : UICollectionViewCell
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIButton *buyAddBtn;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *sourceTextArr;
- (void)fillDataModel:(BrandStockInFoModel *)model;
- (void)fillDataModel:(BrandStockInFoModel *)model haveAddBtnShow:(BOOL)isShow;
@end
NS_ASSUME_NONNULL_END
