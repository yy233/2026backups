//
//  AddInvoiceNormalCell.h
//  Community
//
//  Created by 刘久炼 on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AddInvoiceNormalCellDelegate <NSObject>

@optional - (void)subChangedWithTitle: (NSString *)title Sub: (NSString *)sub;

@end

@interface AddInvoiceNormalCell : UITableViewCell

@property(nonatomic, strong) NSString *title;

@property(nonatomic, strong) NSString *sub;

@property(nonatomic, strong) NSString *pliceholder;

@property (nonatomic, weak) id<AddInvoiceNormalCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
