//
//  ZYUploadFaceModel.h
//  Community
//
//  Created by ZY on 2021/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYUploadFaceModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 图片
@property (nonatomic, copy) NSString *faceUrl;

// 人脸审核状态 0.审核中 1.已通过 2.审核失败
@property (nonatomic, assign) NSInteger examineStatus;

// 信息
@property (nonatomic, copy) NSString *errorMessage;

@end

NS_ASSUME_NONNULL_END
