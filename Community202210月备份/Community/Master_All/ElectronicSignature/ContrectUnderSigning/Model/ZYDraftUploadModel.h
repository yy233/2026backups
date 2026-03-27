//
//  ZYDraftUploadModel.h
//  Community
//
//  Created by ZY on 2021/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYDraftUploadModel : NSObject

// 用户id
@property (nonatomic, copy) NSString *userId;

// 模板id
@property (nonatomic, copy) NSString *tempId;

// 参数id
@property (nonatomic, copy) NSString *paramId;

// 参数值
@property (nonatomic, copy) NSString *value;

// 可编辑方（默认0，无限制；1、甲方可编辑；2、乙方可编辑）
@property (nonatomic, assign) NSInteger editableParty;

@end

NS_ASSUME_NONNULL_END
