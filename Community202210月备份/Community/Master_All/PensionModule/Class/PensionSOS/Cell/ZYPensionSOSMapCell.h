//
//  ZYPensionSOSMapCell.h
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYPensionSOSMapCellDelegate <NSObject>

- (void)voiceButtonEvent;

@end

@interface ZYPensionSOSMapCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (nonatomic, weak) id<ZYPensionSOSMapCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
