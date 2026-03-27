//
//  MainImInfoSubMsgModel.h
//  Community
//
//  Created by 余莹 on 2021/9/4.
//

#import <Foundation/Foundation.h>

@class MainImInfoSubMsgExtraDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface MainImInfoSubMsgModel : NSObject

@property (nonatomic,strong) NSString *create_date;
@property (nonatomic,strong) NSString *create_time;
@property (nonatomic,strong) NSString *data;
@property (nonatomic,strong) NSString *from_user;
@property (nonatomic,strong) NSString *msg_id;
@property (nonatomic,strong) NSString *msg_type;
@property (nonatomic,strong) NSString *session_id;
@property (nonatomic,strong) NSString *to_user;

@property (nonatomic,assign) NSInteger format;
@property (nonatomic,assign) NSInteger msg_ser_id;
@property (nonatomic,assign) NSInteger sdk_ver;
@property (nonatomic,assign) NSInteger sequence_id;
@property (nonatomic,assign) NSInteger sub_type;
@property (nonatomic,assign) NSInteger total_count;
@property (nonatomic,assign) NSInteger un_read_count;
//@property (nonatomic,assign) NSInteger create_time;

@property (nonatomic,assign) BOOL encrypt_flag;

@property (nonatomic, strong) MainImInfoSubMsgExtraDataModel *extra_data;

/**
 
 "last_chat_msg" =             {
     "create_date" = "2021-09-04 14:54:20";
     "create_time" = 1630738459612;
     data = "{\"content\":\"\U98de\U98de\U98de\"}";
     "encrypt_flag" = 0;
     format = 1;
     "from_user" = "zhsj_daebe5eed88441468b4ab4ad111048bf@user";
     "msg_id" = bb4aa1da47334a528e5ad491fad909dc;
     "msg_ser_id" = 1434047150169399297;
     "msg_type" = text;
     "sdk_ver" = 0;
     "sequence_id" = 7;
     "session_id" = "s1v1_5476e0c1917f7d476c8bc914d830e8fe";
     "sub_type" = 0;
     "to_user" = "zhsj_cf70684e984e462aa98e33f546323c49@user";
     "total_count" = 0;
     "un_read_count" = 0;
 };
 */
@end


@interface MainImInfoSubMsgExtraDataModel : NSObject

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *dataId;

@property (nonatomic, copy) NSString *orderNum;

@end

NS_ASSUME_NONNULL_END
