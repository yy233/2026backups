//
//  AddInvoiceView.h
//  Community
//
//  Created by 刘久炼 on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddInvoiceView : UIView

@property(nonatomic, strong) NSArray *companyTitleArray;
@property(nonatomic, strong) NSArray *companypliceholderArray;

@property(nonatomic, strong) NSArray *personTitleArray;
@property(nonatomic, strong) NSArray *personpliceholderArray;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
