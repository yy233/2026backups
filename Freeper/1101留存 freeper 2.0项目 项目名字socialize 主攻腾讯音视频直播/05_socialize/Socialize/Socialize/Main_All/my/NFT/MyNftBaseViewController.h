//
//  MyNftBaseViewController.h
//  Socialize
//
//  Created by 余莹 on 2023/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyNftBaseViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

NS_ASSUME_NONNULL_END
