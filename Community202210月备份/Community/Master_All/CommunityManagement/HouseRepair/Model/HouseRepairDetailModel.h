//
//  HouseRepairDetailModel.h
//  Community
//
//  Created by 余莹 on 2020/12/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRepairDetailModel : HouseRepairListModel

@property (nonatomic,strong) NSString *number;
@property (nonatomic,strong) NSString *orderTime;
/**
 status": 0,
         "repairImg": "123.png,456.png,789.png",
         "type": 2,
         "name": "李大eeeee娘",
         "phone": "987564321",
         "address": "地门小区5栋2单元3-2",
         "number": "76fdd155936b47cd9e1f4958cb8fd8ab",
         "orderTime": "2020-12-25 14:50:50",
         "problem": "测试堵fereerer了"*/
@end

NS_ASSUME_NONNULL_END
