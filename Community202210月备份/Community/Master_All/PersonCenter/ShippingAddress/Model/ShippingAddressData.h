//
//  ShippingAddressData.h
//  Community
//
//  Created by 余莹 on 2021/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShippingAddressData : NSObject
//用户地址管理
+ (void)getUserAddressListWithBlock:(BaseListArrAndSuccessBoolBlock)listBlock;
+ (void)getUserAddressDetailWithUUID:(NSString *)uuid withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
+ (void)deletUserAddressWithUUID:(NSString *)uuid withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
+ (void)addUserAddressWithParms:(NSMutableDictionary *)parms withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
+ (void)editUserAddressWithParms:(NSMutableDictionary *)parms withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;

@end

@interface  ShippingAddressModel : NSObject
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *addressDescription;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *tag;
@property (nonatomic,strong) NSString *uuid;
@property (nonatomic,strong) NSString * userUuid;
//@property (nonatomic,assign) NSInteger userUuid;
@property (nonatomic,assign) NSInteger sex;
@property (nonatomic,assign) NSInteger isdefult;
@property (nonatomic,assign) NSInteger id;
/**
  {
    code = 0;
    data =     (
                {
            address = "湖北省";
            description = "天王星";
            id = 73;
            isdefult = 0;
            name = "快乐治愈";
            phone = 18627703163;
            sex = 0;
            tag = "家";
            userUuid = test123;
            uuid = f9fd58027c6141109f1d73d6c5cab0d6;
        }
    );
    message = "<null>";
}*/

@end

NS_ASSUME_NONNULL_END
