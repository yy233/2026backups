//
//  AllRoomThingVC.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
//

#import <UIKit/UIKit.h>

#import "TopSearchView.h"
#import "TopTypesChooseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AllStockRoomThingsShowVC : UIViewController

@property (nonatomic,assign) BOOL subCellIsShowAddBtn;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) TopSearchView *searchView;
@property (nonatomic,strong) TopTypesChooseView *topTypesChooseView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,strong) NSMutableArray *dataSourceArr_S;
@end

NS_ASSUME_NONNULL_END
