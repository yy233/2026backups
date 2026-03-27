//
//  ZYEmptyDataCollectionView.h
//  Community
//
//  Created by ZY on 2022/3/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYEmptyDataCollectionView : UICollectionView

@property (nonatomic, copy) NSString *emptyTitle;

@property (nonatomic, copy) NSString *emptyImageName;

- (void)emptyDataDelegate;

@end

NS_ASSUME_NONNULL_END
