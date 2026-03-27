//
//  ListSubChooseItemViewTableViewCell.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/24.
//

#import <UIKit/UIKit.h>
#import "ImExOrderOtherTool.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^CellHeightChangeBlock)(CGFloat h);
typedef void(^CellTouchBranDataBlock)(CigarBrandsUseModel* bModel);
typedef void(^CellTouchPlaceDataBlock)(PlaceModel *placeModel);
typedef void(^CellTouchCibDataBlock)(CabinetModel *cibModel);

static NSString *ListSubChooseItemViewTableViewCell_I = @"ListSubChooseItemViewTableViewCell";

@interface ListSubChooseItemViewTableViewCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) CGFloat h_save;
@property (nonatomic,copy) CellHeightChangeBlock h_block;
@property (nonatomic,copy) CellTouchBranDataBlock branBlcok;
@property (nonatomic,copy) CellTouchPlaceDataBlock placeBlcok;
@property (nonatomic,copy) CellTouchCibDataBlock cabBlcok;




@property (nonatomic,assign) ImorExOrder_SubType type;
- (void)fillDataWithArr:(NSMutableArray *)showArr WithType:(ImorExOrder_SubType)type;
- (void)fillDataWithCabArr:(NSMutableArray *)cabArr;
- (void)showChooseCvUseSectionHeaderTitleStr:(NSString *)sectionTitleStr;

@end

NS_ASSUME_NONNULL_END
