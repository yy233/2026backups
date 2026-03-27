//
//  AccessModel.h
//  Community
//  门禁
//  Created by 余莹 on 2020/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccessModel : NSObject
@property (nonatomic,strong) NSString *name;//类型名称
@property (nonatomic,assign) NSInteger code;//类型号
@end

NS_ASSUME_NONNULL_END
