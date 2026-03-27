//
//  RecommendDetailPinLunModel.h
//  Socialize
//
//  Created by 余莹 on 2023/5/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecommendDetailPinLunModel : NSObject
@property(nonatomic, strong) NSString *headImage;     //头像
@property(nonatomic, strong) NSString *nickName;      //昵称
@property(nonatomic, strong) NSString *textMessage;   //文本消息
@property(nonatomic, strong) NSString *oterInfo;  //消息
@end

NS_ASSUME_NONNULL_END
