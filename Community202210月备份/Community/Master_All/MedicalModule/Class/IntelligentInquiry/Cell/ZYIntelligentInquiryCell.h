//
//  ZYIntelligentInquiryCell.h
//  Community
//
//  Created by ZY on 2021/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYIntelligentInquiryCellDelegate <NSObject>

- (void)pfViewEvent;

- (void)kfViewEvent;

- (void)kqViewEvent;

- (void)tjViewEvent;

- (void)rtViewEvent;

- (void)zyViewEvent;

- (void)recordButtonEvent;

@end

@interface ZYIntelligentInquiryCell : UITableViewCell

@property (nonatomic, weak) id<ZYIntelligentInquiryCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
