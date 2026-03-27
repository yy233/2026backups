//
//  ZYAccessRecordModel.h
//  Community
//
//  Created by ZY on 2022/4/27.
//

#import <Foundation/Foundation.h>

@class ZYAccessRecordDataModel, ZYAccessRecordDataListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYAccessRecordModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) NSInteger current;

@property (nonatomic, strong) NSArray<ZYAccessRecordDataModel *> *records;

@end


@interface ZYAccessRecordDataModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *time;

@property (nonatomic, strong) NSArray<ZYAccessRecordDataListModel *> *entityList;

@end


@interface ZYAccessRecordDataListModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 时间
@property (nonatomic, copy) NSString *createTime;

// 设备名称
@property (nonatomic, copy) NSString *facesluiceName;

// 名称
@property (nonatomic, copy) NSString *name;

// 号码
@property (nonatomic, copy) NSString *mobile;

// 进口或出口
@property (nonatomic, copy) NSString *direction;

// 抓拍人脸照片
@property (nonatomic, copy) NSString *snapFaceUrl;

@end

NS_ASSUME_NONNULL_END
