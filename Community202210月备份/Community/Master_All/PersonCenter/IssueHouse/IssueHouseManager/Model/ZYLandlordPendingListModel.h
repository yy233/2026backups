//
//  ZYLandlordPendingListModel.h
//  Community
//
//  Created by ZY on 2021/9/10.
//

#import <Foundation/Foundation.h>

@class ZYLandlordPendingListDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYLandlordPendingListModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSArray<ZYLandlordPendingListDataModel *> *data;

@end


@interface ZYLandlordPendingListDataModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *idStr;

// 签约操作状态 0:发起签约 1:已发起签约 2:已接受申请 4:等待支付房租 5:已支付完成 6:已完成签约 7:已取消签约 8:已拒绝申请 9:重新发起
@property (nonatomic, assign) NSInteger operation;

// 图片路径
@property (nonatomic, copy) NSString *imageUrl;

// 标题
@property (nonatomic, copy) NSString *title;

// (商铺)概述
@property (nonatomic, copy) NSString *summarize;

// 优势标签
@property (nonatomic, copy) NSString *advantageId;

// 房型code：四室一厅、二室一厅...别墅000000 如040202代表着4室2厅2卫
@property (nonatomic, copy) NSString *typeCode;

// 房屋朝向、不常改，对应的数值，1.东.2.西 3.南 4.北. 5.东南 6. 东北 7.西北 8.西南
@property (nonatomic, copy) NSString *directionId;

// 房屋价格/元
@property (nonatomic, assign) double price;

// 房屋租售优势标签
@property (nonatomic, strong) NSDictionary *houseAdvantageCode;

// 房屋户型文本：1.四室一厅、2.二室一厅...
@property (nonatomic, copy) NSString *houseType;

//  租客姓名
@property (nonatomic, copy) NSString *realName;

//  租客头像
@property (nonatomic, copy) NSString *avatarUrl;

@end

NS_ASSUME_NONNULL_END
