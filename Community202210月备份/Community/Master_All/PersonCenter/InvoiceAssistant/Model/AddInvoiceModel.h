//
//  AddInvoiceModel.h
//  Community
//
//  Created by 刘久炼 on 2021/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddInvoiceModel : NSObject
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) NSString *companyName;
@property(nonatomic, strong) NSString *accont;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *tel;
@property(nonatomic, strong) NSString *bank;
@property(nonatomic, strong) NSString *bankAccont;
@property(nonatomic, assign) NSInteger isdefault;

@property(nonatomic, strong) NSString *personName;
@end

NS_ASSUME_NONNULL_END
