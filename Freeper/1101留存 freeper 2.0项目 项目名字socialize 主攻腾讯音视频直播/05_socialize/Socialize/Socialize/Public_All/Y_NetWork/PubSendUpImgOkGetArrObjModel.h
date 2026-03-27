//
//  PubSendUpImgModel.h
//  Socialize
//
//  Created by 余莹 on 2023/5/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PubSendUpImgOkGetArrObjModel : NSObject

//@property (nonatomic,strong) NSString *expire_ts;
//@property (nonatomic,strong) NSString *md5_hash;
//@property (nonatomic,strong) NSString *original_name;
//@property (nonatomic,strong) NSString *re_name;
//@property (nonatomic,strong) NSString *thumbnail_url;
//@property (nonatomic,strong) NSString *url;

@property (nonatomic,copy) NSString *expire_ts;
@property (nonatomic,copy) NSString *md5_hash;
@property (nonatomic,copy) NSString *original_name;
@property (nonatomic,copy) NSString *re_name;
@property (nonatomic,copy) NSString *thumbnail_url;
@property (nonatomic,copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
