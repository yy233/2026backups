//
//  HouseRepairPageListUseModel.h
//  Community
//
//  Created by 余莹 on 2022/3/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyRepairPageListUseModel : NSObject
//
@property (nonatomic,copy)   NSString *workOrderTypeName;
@property (nonatomic,copy)   NSString *createByType;
@property (nonatomic,assign) NSInteger isTips;
@property (nonatomic,assign) NSInteger prescription;

//____
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,assign) NSInteger status; //状态 0  1 2已完成
@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,assign) NSInteger typeId;
@property (nonatomic,copy)   NSString *number;//编号
@property (nonatomic,copy)   NSString *statusStr;
@property (nonatomic,copy)   NSString *address;//报修地址
@property (nonatomic,copy)   NSString *name;
@property (nonatomic,copy)   NSString *assignName;
@property (nonatomic,copy)   NSString *dealName;//接单人姓名
@property (nonatomic,copy)   NSString *dealPhone;//接单人电话
@property (nonatomic,copy)   NSString *phone;//联系电话
@property (nonatomic,copy)   NSString *dealId;
@property (nonatomic,copy)   NSString *problem;//报修内容
@property (nonatomic,copy)   NSString *typeName;
@property (nonatomic,copy)   NSString *repairImg;//照片（维修前照片）
@property (nonatomic,strong)  NSArray *repairImgs;
@property (nonatomic,copy)   NSString *repairedImg; //维修后照片 str 分号分割
@property (nonatomic,assign) NSInteger repairOrReport;
@property (nonatomic,assign) NSInteger repairType;
@property (nonatomic,copy)   NSString *createTime;
@property (nonatomic,copy)   NSString *updateTime;
@property (nonatomic,copy)   NSString *serviceTime;//派单时间
@property (nonatomic,copy)   NSString *orderTime;//报修时间
@property (nonatomic,copy)   NSString *receivingTime;//接单时间
@property (nonatomic,copy)   NSString *successTime;//完成时间
@property (nonatomic,copy)   NSString *repairId;
@property (nonatomic,copy)   NSString *orderResult;//处理结果
@property (nonatomic,copy)   NSString *firstTypeName;//一级分类
@property (nonatomic,copy)   NSString *secondTypeName;//分类（二级分类）
@property (nonatomic,copy)   NSString *departmentName;//部门
@property (nonatomic,copy)   NSString *voiceUrl;//语音地址
@property (nonatomic,assign) NSInteger voiceLength;//语音时长


/**
 {
address = "A栋1单元505049";
assignId = 57522;
assignName = "代坤杉";
communityId = 1;
createTime = "2022-03-04 13:46:38";
dealId = 149570906266669056;
dealName = "杨明星1";
dealPhone = 18996226451;
deleted = 0;
id = 163024534054768640;
idStr = 163024534054768640;
name = "灰化肥挥发";
number = 63437398211474620;
orderResult = "";
orderTime = "2022-03-04 13:46:38";
phone = 13648470204;
problem = "房顶漏水";
receivingTime = "2022-03-04 14:06:54";
repairId = 163024534012825600;
repairImg = "http://222.178.212.29:9000/repair-img/1372c3b40dc5420b9157c8a9f50a93ab;";
repairImgs =                 (
"http://222.178.212.29:9000/repair-img/1372c3b40dc5420b9157c8a9f50a93ab"
);
repairOrReport = 1;
repairType = 0;
serviceTime = "2022-03-04 13:58:03";
status = 2;
statusStr = "已完成";
successTime = "2022-03-04 14:17:53";
typeId = 157642131446566912;
typeName = "家装报修1";
updateTime = "2022-03-04 14:17:53";
},
 */
@end

NS_ASSUME_NONNULL_END
