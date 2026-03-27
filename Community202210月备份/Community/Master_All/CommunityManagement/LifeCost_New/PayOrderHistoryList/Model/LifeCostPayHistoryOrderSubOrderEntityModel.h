//
//  LifeCostPayHistoryOrderSubOrderEntityModel.h
//  Community
//
//  Created by 余莹 on 2022/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPayHistoryOrderSubOrderEntityModel : NSObject
@property (nonatomic,copy) NSString *typePicUrl;
@property (nonatomic,copy) NSString *repoPayAmount;
@property (nonatomic,copy) NSString *payAmount;
@property (nonatomic,copy) NSString *account;
@property (nonatomic,copy) NSString *billId;
@property (nonatomic,copy) NSString *billKey;
@property (nonatomic,copy) NSString *contactNo;
@property (nonatomic,copy) NSString *transacNo;
@property (nonatomic,copy) NSString *typeId;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *typeName;
@property (nonatomic,copy) NSString *orderDate;
@property (nonatomic,copy) NSString *monthTime;
@property (nonatomic,copy) NSString *itemId;
@property (nonatomic,copy) NSString *itemCode;
@property (nonatomic,copy) NSString *householder;
@property (nonatomic,copy) NSString *customerName;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *updateTime;
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger orderStatus; //         "orderStatus": 0,                                                    --0:订单创建成功;1:支付成功;2:支付失败;3:销账成功;4:销账失败;5:未知状态;8:实时退款
@property (nonatomic,assign) NSInteger payType;
@property (nonatomic,assign) NSInteger billAmount;

/**
 
 orderEntityList =             (
                     {
         account = 97145061000;
         billAmount = 1;
         billId = 141689417323646976;
         billKey = 97145061000;
         contactNo = 2021112501;
         createTime = "2022-01-04 18:09:14";
         customerName = "郭丽";
         deleted = 0;
         householder = "郭丽";
         id = 141709735035539456;
         idStr = 141709735035539456;
         itemCode = 238556890;
         itemId = 254706;
         monthTime = "2022-01";
         orderDate = 20220104;
         orderStatus = 4;
         payAmount = 1;
         payType = 3;
         repoPayAmount = 1;
         transacNo = 1202201043538433;
         typeId = 3;
         typeName = "燃气费";
         uid = 56738;
         updateTime = "2022-01-04 18:09:39";
     },
                     
 */
@end

NS_ASSUME_NONNULL_END
