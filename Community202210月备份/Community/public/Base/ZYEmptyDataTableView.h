//
//  ZYEmptyDataTableView.h
//  Community
//
//  Created by ZY on 2021/10/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYEmptyDataTableView : UITableView

@property (nonatomic, copy) NSString *emptyTitle;

@property (nonatomic, copy) NSString *emptyImageName;

- (void)emptyDataDelegate;

@end

NS_ASSUME_NONNULL_END
