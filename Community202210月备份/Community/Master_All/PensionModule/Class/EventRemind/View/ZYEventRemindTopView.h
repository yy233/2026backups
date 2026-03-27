//
//  ZYEventRemindTopView.h
//  Community
//
//  Created by ZY on 2021/11/10.
//

#import <UIKit/UIKit.h>
#import "ZYEventRemindTopModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYEventRemindTopViewDelegate <NSObject>

- (void)collectionViewSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZYEventRemindTopView : UIView

@property (nonatomic, strong) NSArray<ZYEventRemindTopModel *> *dataArray;

@property (nonatomic, weak) id<ZYEventRemindTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
