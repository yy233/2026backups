//
//  ImportOrderFillSubChooseTableViewCell.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/25.
//

#import <UIKit/UIKit.h>

#import "TopTypesChooseView.h"

static NSString * _Nullable ImportOrderFillSubChooseTableViewCell_I = @"ImportOrderFillSubChooseTableViewCell";
static NSString * _Nullable ShowCollectionViewTableViewCell_I = @"ShowCollectionViewTableViewCell";
NS_ASSUME_NONNULL_BEGIN



//单行显示collv
@interface ShowCollectionViewTableViewCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *mainSectionHeaderUseShowArr;//主要类型HeaderTitle
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,copy) NewHeightChangeBlock h_block;
@property (nonatomic,copy) HomeVcShowChangeBlock_anBansBlcok anBansBlcok;
@property (nonatomic,copy) HomeVcShowChangeBlock_oneBrandAnTypeBlcok oneBrandAnTypeBlcok;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
- (void)isBands;
- (void)isBandTypes;
- (void)fillDataSourceModel:(NSMutableArray *)sourceArr;
@end

@interface ImportOrderFillSubChooseTableViewCell : ShowCollectionViewTableViewCell
@end

NS_ASSUME_NONNULL_END
