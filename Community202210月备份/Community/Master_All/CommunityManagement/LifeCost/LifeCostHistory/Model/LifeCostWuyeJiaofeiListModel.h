//
//  LifeCostWuyeJiaofeiListModel.h
//  Community
//
//  Created by 余莹 on 2021/7/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostWuyeJiaofeiListModel : NSObject
@property (nonatomic,strong) NSString *roomName;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSArray *list;
@property (nonatomic,assign) double totalAmount;


/*
 
 id = 153123123124314;
 list =             (
                     {
         houseId = 153123123124314;
         id = 50476268268949504;
         idStr = 50476268268949504;
         orderTime = "2021-04-28";
         totalMoney = "307.5";
     },
                     {
         houseId = 153123123124314;
         id = 65696555713302528;
         idStr = 65696555713302528;
         orderTime = "2021-06-09";
         totalMoney = "307.5";
     }
 );
 roomName = "御景庭1单元2层御景庭-1-2-2-15";
 totalAmount = 3690;
 ///
 
 ToolOfNetWork.m:222      ___
 url=http://192.168.12.60:9527/api/v1/proprietor/FinanceOrder/list?communityId=1&status=0____{
    code = 0;
    data =     (
                {
            id = 153123123124314;
            list =             (
                                {
                    houseId = 153123123124314;
                    id = 50476268268949504;
                    idStr = 50476268268949504;
                    orderTime = "2021-04-28";
                    totalMoney = "307.5";
                },
                                {
                    houseId = 153123123124314;
                    id = 65696555713302528;
                    idStr = 65696555713302528;
                    orderTime = "2021-06-09";
                    totalMoney = "307.5";
                }
            );
            roomName = "御景庭1单元2层御景庭-1-2-2-15";
            totalAmount = 3690;
        },
                {
            id = 1243123411;
            list =             (
                                {
                    houseId = 1243123411;
                    id = 48866107276267520;
                    idStr = 48866107276267520;
                    orderTime = "2021-02-23";
                    totalMoney = "58.9";
                },
                                {
                    houseId = 1243123411;
                    id = 65696555432284160;
                    idStr = 65696555432284160;
                    orderTime = "2021-06-09";
                    totalMoney = "58.9";
                }
            );
            roomName = "E栋3层e-3-3-1";
            totalAmount = "1472.5";
        }
    );
    message = "查询成功";
}

*/
@end

NS_ASSUME_NONNULL_END
