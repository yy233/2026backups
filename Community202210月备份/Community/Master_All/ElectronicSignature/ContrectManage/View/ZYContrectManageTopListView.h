//
//  ZYContrectManageTopListView.h
//  Community
//
//  Created by ZY on 2021/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYContrectManageTopListViewDelegate <NSObject>

- (void)contrectManageTopListViewTapEvent;

- (void)contentViewTapWithIndex:(NSInteger)index;

@end


@interface ZYContrectManageTopListView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) id<ZYContrectManageTopListViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@end

NS_ASSUME_NONNULL_END
