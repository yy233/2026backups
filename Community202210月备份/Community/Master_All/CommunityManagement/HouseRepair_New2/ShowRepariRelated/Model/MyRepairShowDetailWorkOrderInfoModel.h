//
//  MyRepairShowDetailWorkOrderInfoModel.h
//  Community
//
//  Created by 余莹 on 2022/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyRepairShowDetailWorkOrderInfoModel : NSObject
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
@property (nonatomic,copy)   NSString *appointmentTime;//预约时间
@property (nonatomic,assign) NSInteger prescription;
@property (nonatomic,copy)   NSString *comment;//已经评价的文本
@property (nonatomic,copy)   NSString *commentDraft;//评价的草稿文本
@property (nonatomic,assign) NSInteger commentStatus;//评价的星星
@property (nonatomic,assign) NSInteger commentStatusDraft;//评价的草稿星星
@end

NS_ASSUME_NONNULL_END
