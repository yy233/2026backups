//
//  HouseRepairListModel.h
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRepairListModel : NSObject
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,assign) NSInteger status;//报修状态 0 待处理 1 处理中 2 已处理
@property (nonatomic,assign) NSInteger type;//发起保修的类别
@property (nonatomic,strong) NSString *typeName;//发起保修的类别
@property (nonatomic,strong) NSString *repairImg;
@property (nonatomic,strong) NSString *problem;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic,strong) NSString *createTime;
//
@property (nonatomic,strong) NSString *detailAddress; //公共报修情况下的详细地址

/**
 "id": 5690662972428288,
            "deleted": 0,
            "createTime": "2020-12-25 09:58:00",
            "updateTime": "2020-12-25 09:58:15",
            "userId": "d09bb8bac4fe442f8826a8c329c9cf2a",
            "communityId": 1,
            "address": "地门小区5栋2单元3-2",
            "status": 2,
            "type": 0,
            "name": "李大娘",
            "phone": "987564321",
            "problem": "测试堵了",
            "repairImg": "123.png,456.png,789.png"*/

@end

NS_ASSUME_NONNULL_END
