//
//  ZYPensionEmptyTableView.h
//  Community
//
//  Created by ZY on 2021/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYPensionEmptyTableView : UITableView

@property (nonatomic, copy) NSString *emptyTitle;

@property (nonatomic, copy) NSString *emptyImageName;

- (void)emptyDataDelegate;

@end

NS_ASSUME_NONNULL_END
