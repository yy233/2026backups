//
//  ZYSigningDetailModel.h
//  Community
//
//  Created by ZY on 2021/9/7.
//

#import <Foundation/Foundation.h>

@class ZYSigningDetailDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYSigningDetailModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ZYSigningDetailDataModel *data;

@end


@interface ZYSigningDetailDataModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, assign) NSInteger deleted;

@property (nonatomic, copy) NSString *createTime;

// 资产ID
@property (nonatomic, copy) NSString *assetId;

// 资产类型 1:商铺 2:房屋
@property (nonatomic, assign) NSInteger assetType;

// 业主uid
@property (nonatomic, copy) NSString *homeOwnerUid;

// 租客uid
@property (nonatomic, copy) NSString *tenantUid;

// 签约操作状态 0:发起签约 1:已发起签约 2:已接受申请 4:等待支付房租 5:已支付完成 6:已完成签约 7:已取消签约 8:已拒绝申请 9:重新发起 10:已过期 31:房东已重新发起 32:房东已取消发起
@property (nonatomic, assign) NSInteger operation;

// (商铺)概述
@property (nonatomic, copy) NSString *summarize;

// 优势标签
@property (nonatomic, copy) NSString *advantageId;

// 社区id
@property (nonatomic, copy) NSString *communityId;

// 房型code：四室一厅、二室一厅...别墅000000 如040202代表着4室2厅2卫
@property (nonatomic, copy) NSString *typeCode;

// 楼层(共有)
@property (nonatomic, copy) NSString *floor;

// 省份id(房屋)
@property (nonatomic, copy) NSString *provinceId;

// 市id(共有)
@property (nonatomic, copy) NSString *cityId;

// 区域id(共有)
@property (nonatomic, copy) NSString *areaId;

// 详细地址(房屋)
@property (nonatomic, copy) NSString *address;

// 合同编号
@property (nonatomic, copy) NSString *conId;

// 合同名字
@property (nonatomic, copy) NSString *conName;

// 合同开始时间
@property (nonatomic, copy) NSString *startDate;

// 合同结束时间
@property (nonatomic, copy) NSString *endDate;

// 发起方(甲方)
@property (nonatomic, copy) NSString *initiator;

// 签约方(乙方)
@property (nonatomic, copy) NSString *signatory;

// 房东姓名
@property (nonatomic, copy) NSString *landlordName;

// 房东电话
@property (nonatomic, copy) NSString *landlordPhone;

// 房屋完整地址
@property (nonatomic, copy) NSString *fullAddress;

// 租客姓名
@property (nonatomic, copy) NSString *realName;

// 租客电话
@property (nonatomic, copy) NSString *tenantPhone;

// 租客身份证号码
@property (nonatomic, copy) NSString *tenantIdCard;

// 进度数 1:发起签约 2:签约合同 3:租客支付房租 4:完成签约
@property (nonatomic, assign) NSInteger progressNumber;

// 房屋租售优势标签
@property (nonatomic, strong) NSDictionary *houseAdvantageCode;

// 倒计时终点
@property (nonatomic, strong) NSString *countdownFinish;

// 区块链上链状态
@property (nonatomic, assign) NSInteger blockStatus;


// 自传字段
// 身份类型 1:房东 2:租客
@property (nonatomic, assign) NSInteger identityType;

// 是否实名
@property (nonatomic, assign) BOOL isRealName;

// 是否租赁详情入口
@property (nonatomic, assign) BOOL isRentDetail;


// 房屋
// 房屋title
@property (nonatomic, copy) NSString *title;

// 房屋户型文本：1.四室一厅、2.二室一厅...
@property (nonatomic, copy) NSString *houseType;

// 房屋朝向
@property (nonatomic, copy) NSString *directionId;

// 房屋价格/元
@property (nonatomic, assign) double price;

// 图片路径
@property (nonatomic, copy) NSString *imageUrl;

@end

NS_ASSUME_NONNULL_END
