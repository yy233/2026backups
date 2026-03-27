//
//  LifeWillToPayOrderDetailModel.h
//  Community
//
//  Created by 余莹 on 2022/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeWillToPayOrderDetailModel : NSObject
@property (nonatomic,copy) NSString *billKey;
@property (nonatomic,copy) NSString *contactNo;
@property (nonatomic,copy) NSString *customerName;
@property (nonatomic,copy) NSString *typePicUrl;
@property (nonatomic,copy) NSString *typeId;
@property (nonatomic,copy) NSString *rangLimit;
@property (nonatomic,copy) NSString *queryAcqSsn;
@property (nonatomic,copy) NSString *itemId;
@property (nonatomic,copy) NSString *itemCode;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *fieldA;
@property (nonatomic,copy) NSString *fieldB;
@property (nonatomic,copy) NSString *fieldC;
@property (nonatomic,copy) NSString *fieldD;
@property (nonatomic,copy) NSString *fieldE;

@property (nonatomic,copy) NSString *balance;
@property (nonatomic,copy) NSString *beginDate;
@property (nonatomic,copy) NSString *endDate;
@property (nonatomic,copy) NSString *billAmount;
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,assign) NSInteger billStatus;
@property (nonatomic,assign) NSInteger deleted;


 
/**
 
 lOfNetWork.m:330      YrequestPostURLNoMainQueueWithBodyNotParms url=proprietor/livingExpensesBill/v2/queryBillInfo Reply JSON: {
     code = 0;
     data =     {
         balance = 0;
         beginDate = "2012/11/26";
         billAmount = 1;
         billKey = 97145061000;
         billStatus = 0;
         contactNo = 2021112501;
         createTime = "2022-01-04 16:48:30";
         customerName = "郭丽";
         deleted = 0;
         endDate = "2012/11/26";
         fieldA = "";
         fieldB = "";
         fieldC = "";
         fieldD = "";
         fieldE = "";
         id = 141689417323646976;
         idStr = 141689417323646976;
         itemCode = 238556890;
         itemId = 254706;
         queryAcqSsn = "n20220104165130-g8lId9";
         rangLimit = "-10";
         typeId = 1;
         typePicUrl = "http://222.178.212.29:9000/cost-icon/dianfei@3x.png";
         uid = 56738;
     };
     message = "<null>";
 }
 */
@end

NS_ASSUME_NONNULL_END
