//
//  OrderAdviceVcSubInputTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *OrderAdviceVcSubInputTableViewCell_I = @"OrderAdviceVcSubInputTableViewCell";

typedef void(^SaveSelfTextViewStrBlock)(NSString * textViewStr);

@interface OrderAdviceVcSubInputTableViewCell : UITableViewCell
@property (nonatomic,copy) SaveSelfTextViewStrBlock saveSelfTextViewStrBlock;
@end

NS_ASSUME_NONNULL_END
