//
//  AddInvoiceTypeCell.h
//  Community
//
//  Created by 刘久炼 on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AddInvoiceTypeCellDelegate <NSObject>

- (void)typeSelectedWithType: (NSInteger )type;

@end

@interface AddInvoiceTypeCell : UITableViewCell

@property (nonatomic, weak) id<AddInvoiceTypeCellDelegate> delegate;

@property(nonatomic, assign) NSInteger type;


@end

NS_ASSUME_NONNULL_END
