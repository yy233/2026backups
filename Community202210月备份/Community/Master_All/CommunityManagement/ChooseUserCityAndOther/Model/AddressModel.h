//
//  AddressModel.h
//  Community
//
//  Created by 余莹 on 2020/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressModel : NSObject
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,strong) NSString *door; //名称
@property (nonatomic,strong) NSString *type;//下一级别名称

@end

NS_ASSUME_NONNULL_END
