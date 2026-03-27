//
//  MyCollectionView.h
//  Community
//
//  Created by 刘久炼 on 2021/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MyCollectionViewStatus) {
    MyCollectionViewNormal = 0,
    MyCollectionViewEdit = 1
};

@interface MyCollectionView : UIView

@property(nonatomic, assign) MyCollectionViewStatus status;

@property(nonatomic, strong) NSMutableArray *dataArray;

- (void)editClickedWithStatus: (MyCollectionViewStatus ) status;


- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
