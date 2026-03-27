//
//  AddInvoiceDefaultCell.h
//  Community
//
//  Created by 刘久炼 on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AddInvoiceDefaultCellDelegate <NSObject>

@optional - (void)isdefaultChagedWithsIsdefalut: (NSInteger )isdefalut;

@end

@interface AddInvoiceDefaultCell : UITableViewCell

@property(nonatomic, assign) NSInteger isdefault;

@property (nonatomic, weak) id<AddInvoiceDefaultCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
