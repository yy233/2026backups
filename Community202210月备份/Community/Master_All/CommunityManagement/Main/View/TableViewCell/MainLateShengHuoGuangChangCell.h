//
//  MainLateShengHuoGuangChangCell.h
//  Community
//
//  Created by 余莹 on 2021/7/29.
//

#import <UIKit/UIKit.h>
#import "LMJVerticalFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MainLateShengHuoGuangChangCell_TopHeader_Type_ZuFang,
    MainLateShengHuoGuangChangCell_TopHeader_Type_ErShou,
} MainLateShengHuoGuangChangCell_TopHeader_Type;

typedef void(^GetShowHeightToSuperBlock)(CGFloat);
typedef void(^TouchTopHeaderBtnBlock)(MainLateShengHuoGuangChangCell_TopHeader_Type);
typedef void(^TouchSubCellBlock)(NSInteger ,MainLateShengHuoGuangChangCell_TopHeader_Type );

@interface MainLateShengHuoGuangChangCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource,LMJVerticalFlowLayoutDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

- (void)fillShengHuoGuangChangWithZuFangArr:(NSMutableArray *)zuFangArr;
- (void)fillShengHuoGuangChangWithErShouArr:(NSMutableArray *)erShouArr;
 
@property (nonatomic,copy) GetShowHeightToSuperBlock getMainSubCellShowHeightBlock;
@property (nonatomic,copy) TouchTopHeaderBtnBlock touchTopHeaderBtnBlock;
@property (nonatomic,copy) TouchSubCellBlock touchSubCellBlock;


@end

NS_ASSUME_NONNULL_END
