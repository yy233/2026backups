//
//  NftModels.h
//  Socialize
//
//  Created by 余莹 on 2023/8/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NftModelsSubUser : NSObject

@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *nickname;
@end


@interface NftModels : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *describe;
@property (nonatomic,strong) NftModelsSubUser *user;

@end

NS_ASSUME_NONNULL_END
