//
//  UserFamilyWillSendModel.h
//  Community
//
//  Created by 余莹 on 2020/12/18.
//  家属信息 添加 修改 时

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserFamilyWillSendModel : NSObject
@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,assign) NSInteger concern;//与业主关系
@property (nonatomic,assign) NSInteger houseId;
@property (nonatomic,assign) NSInteger sex;
@property (nonatomic,strong) NSString *idNumber;//身份证
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phoneTel;
@property (nonatomic,strong) NSMutableArray *cars;

//0301 增
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,strong) NSString *idCard;
@property (nonatomic,assign) NSInteger identificationType;
@property (nonatomic,strong) NSString *mobile;

/*
 url=http://smart.free.vipnps.vip/api/v1/proprietor/relation/selectUserRelationDetails____{
    code = 0;
    data =     {
        cars =         (
                        {
                carPlate = "渝A77767";
                carType = 2;
                carTypeName = "小型车";
                drivingLicenseUrl = "http://222.178.212.29:9000/wocao/1e1abbce-cc04-4cf8-a509-158182b0aa6a";
                id = 29626556179681280;
            }
        );
        communityId = 2;
        houseId = 115;
        id = 19;
        idCard = 516498199108138777;
        identificationType = 1;
        mobile = 15087487146;
        name = "余识";
        relation = 2;
        sex = 0;
    };
    message = "<null>";
}*/

@end
/**
 {
   "cars": [
     {
       "carId": "",
       "carImgURL": "",
       "carPosition": 0,
       "carType": 0,
       "checkStatus": 0,
       "createTime": "",
       "deleted": 0,
       "id": 0,
       "updateTime": ""
     }
   ],
   "communityId": 0,
   "concern": 0,
   "houseId": 0,
   "idNumber": "",
   "name": "",
   "phoneTel": "",
   "sex": 0
 }
 
 cars =     (
             {
         carId = "\U4eacA81825";
         carImgURL = "https://dss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1131980658&fm=26&gp=1.jpg";
         carPosition = 57;
         carType = 5;
         checkStatus = 1;
         communityId = "<null>";
         createTime = "<null>";
         deleted = "<null>";
         id = 1;
         owner = "\U5f20\U5434";
         phoneTel = 15914158052;
         uid = "<null>";
         updateTime = "<null>";
     },
             {
         carId = "\U4eacA85620";
         carImgURL = "http://www.baidu.com/dsadsadadsa.jpg";
         carPosition = "<null>";
         carType = 2;
         checkStatus = 0;
         communityId = "<null>";
         createTime = "<null>";
         deleted = "<null>";
         id = 91;
         owner = "\U4f59\U67d0";
         phoneTel = 15914158051;
         uid = "<null>";
         updateTime = "<null>";
     },
             {
         carId = "\U4eacA8A619";
         carImgURL = "http://www.baidu.com/dsadsadadsa.jpg";
         carPosition = "<null>";
         carType = 4;
         checkStatus = 0;
         communityId = "<null>";
         createTime = "<null>";
         deleted = "<null>";
         id = 92;
         owner = "\U5f20\U6657";
         phoneTel = 15914158051;
         uid = "<null>";
         updateTime = "<null>";
     },
             {
         carId = "\U6e1db250";
         carImgURL = "http://localhost:8080";
         carPosition = 0;
         carType = 1;
         checkStatus = 0;
         communityId = "<null>";
         createTime = "<null>";
         deleted = "<null>";
         id = 99;
         owner = "\U5df4\U5494\U5df4\U5494";
         phoneTel = 12345678910;
         uid = "<null>";
         updateTime = "<null>";
     }
 );
 communityId = 1;
 concern = 2;
 houseId = "<null>";
 idNumber = 500243199457489641;
 name = "\U82bd\U513f\U54df";
 phoneTel = 1502364365;
 sex = 1;
 userId = "<null>";
}
 */
NS_ASSUME_NONNULL_END
