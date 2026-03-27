//
//  ZYMessageCell.h
//  Community
//
//  Created by ZY on 2021/4/20.
// 未读列表数据cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYMessageCell : UITableViewCell
- (void)fillDataWithDic:(NSMutableDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
