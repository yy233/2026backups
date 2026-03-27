//
//  MyOrderEvaluateMessageModel.h
//  Community
//
//  Created by 余莹 on 2021/5/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderEvaluateMessageModel : NSObject
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *evaluateMessage;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *list;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *orderUuid;
@property (nonatomic,strong) NSString *shopUuid;
@property (nonatomic,strong) NSString *uuid;
@property (nonatomic,assign) NSInteger evaluateLevel;//等级0-5
/**
 code = 0;
 data =     {
     createTime = "2021-05-29T17:24:40";
     evaluateLevel = "<null>";
     evaluateMessage = "1234568\U8bc4\U8bba";
     id = 30;
     image = "<null>";
     list = "<null>";
     name = "<null>";
     orderUuid = a675750fa74feb884a9bdbdbcbb401;
     shopUuid = 0c9b7441285b41fbb48f6f51be2df002;
     userUuid = "<null>";
     uuid = "<null>";
 };
 message = "<nul
 */
@end

NS_ASSUME_NONNULL_END
