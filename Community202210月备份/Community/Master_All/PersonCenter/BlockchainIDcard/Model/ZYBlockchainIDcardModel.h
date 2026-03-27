//
//  ZYBlockchainIDcardModel.h
//  Community
//
//  Created by ZY on 2021/10/28.
//

#import <Foundation/Foundation.h>

@class ZYBlockchainIDcardDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYBlockchainIDcardModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, assign) BOOL success;

@property (nonatomic, assign) BOOL fail;

@property (nonatomic, strong) ZYBlockchainIDcardDataModel *data;

@end


@interface ZYBlockchainIDcardDataModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *idCardName;

@property (nonatomic, copy) NSString *idCardNo;

@property (nonatomic, copy) NSString *blockAddress;

@property (nonatomic, copy) NSString *hashStr;

@property (nonatomic, copy) NSString *timeStamp;

@end

NS_ASSUME_NONNULL_END
