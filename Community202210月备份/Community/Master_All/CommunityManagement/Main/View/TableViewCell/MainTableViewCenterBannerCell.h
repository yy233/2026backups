//
//  MainTableViewCenterBannerCell.h
//  Community
//   紧急消息
//  Created by 余莹 on 2020/11/16.
//

#import <UIKit/UIKit.h>
#import "SGAdvertScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@interface MainTableViewCenterBannerCell : UITableViewCell
@property (nonatomic,strong) NSMutableArray <TableViewTopAndCenterBannerCellModel *>*dataSource;
@property (nonatomic,strong) SGAdvertScrollView *advertScrollView;
@property (nonatomic,strong) UIButton *rightMoreBtn;
@end

NS_ASSUME_NONNULL_END
