//
//  AdviceVc.h
//  Community
//
//  Created by 余莹 on 2020/12/28.
//

#import <UIKit/UIKit.h>
#import "AdviceView.h"
NS_ASSUME_NONNULL_BEGIN

@interface AdviceVc : BaseViewController
@property (nonatomic,assign) NSInteger houseRepairId;
//
@property (nonatomic,strong) AdviceView *adviceView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *imgSaveArr;
@property (nonatomic,strong) NSMutableArray *imgUrlArr;
@end

NS_ASSUME_NONNULL_END
