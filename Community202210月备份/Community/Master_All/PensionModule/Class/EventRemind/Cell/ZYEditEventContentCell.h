//
//  ZYEditEventContentCell.h
//  Community
//
//  Created by ZY on 2021/11/12.
//

#import <UIKit/UIKit.h>
#import "ZYEventRemindModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYEditEventContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) ZYEventRemindModel *model;

@end

NS_ASSUME_NONNULL_END
