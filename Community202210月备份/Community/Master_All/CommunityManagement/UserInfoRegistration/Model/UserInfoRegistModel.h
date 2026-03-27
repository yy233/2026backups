//
//  UserInfoRegistModel.h
//  Community
//  业主的modle
//  Created by 余莹 on 2020/11/20.
//

#import <Foundation/Foundation.h>
//与业主关系 1.夫妻 2.父子 3.母子 4.父女 5.母女 6.亲属
//性别，0未知，1男，2女

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoRegistModel : NSObject
//@property (nonatomic,strong) NSString *titleStr;
//@property (nonatomic,strong) NSString *detailTitleStr;
//@property (nonatomic,strong) NSString *imgStr;
//业主
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *avatarUrl;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *detailAddress;
@property (nonatomic,strong) NSString *idCard;
@property (nonatomic,strong) NSString *isRealAuth;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *realName;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,assign) NSInteger sex;
@property (nonatomic,strong) NSMutableArray *proprietorMembers;//家属的arr
//车辆
@property (nonatomic,strong) NSMutableArray *proprietorCars;
//房产
@property (nonatomic,strong) NSMutableArray *proprietorHouses;

/**
 "proprietorCars": [
       {
         "carImageUrl": "string",
         "carPlate": "string",
         "carPositionId": 0,
         "carType": 0,
         "checkStatus": 0,
         "checkTime": "2020-12-19T06:10:44.443Z",
         "communityId": 0,
         "contact": "string",
         "createTime": "2020-12-19T06:10:44.443Z",
         "deleted": 0,
         "id": 0,
         "owner": "string",
         "updateTime": "2020-12-19T06:10:44.443Z"
       }
     ],
     "proprietorHouses": [
       {
         "building": "string",
         "communityId": 0,
         "door": "string",
         "floor": "string",
         "houseId": 0,
         "id": 0,
         "unit": "string"
       }
     ],
 */
/**
 code = 0;
 data =     {
     area = "<null>";
     avatarUrl = "http://www.baidu.com";
     city = "<null>";
     detailAddress = "重庆天王星B座1810 5号位";
     idCard = "<null>";
     isRealAuth = "<null>";
     nickname = "<null>";
     proprietorMembers =         (
                     {
             communityId = 1;
             createTime = "<null>";
             deleted = "<null>";
             houseId = 5;
             householderId = test123;
             id = 10;
             idCard = 513029199910053056;
             mobile = 15914158052;
             name = "余易";
             relation = 2;
             sex = 1;
             updateTime = "<null>";
         },
                     {
             communityId = 1;
             createTime = "<null>";

             deleted = "<null>";
             houseId = 5;
             householderId = test123;
             id = 11;
             idCard = 513029199910053056;
             mobile = 15181846302;
             name = "余贰";
             relation = 2;
             sex = 1;
             updateTime = "<null>";
         },
                     {
             communityId = 1;
             createTime = "<null>";
             deleted = "<null>";
             houseId = 5;
             householderId = test123;
             id = 12;
             idCard = 513029199910053056;
             mobile = 14515184620;
             name = "余衫";
             relation = 1;
             sex = 1;
             updateTime = "<null>";
         },
                     {
             communityId = 1;
             createTime = "<null>";
             deleted = "<null>";
             houseId = 5;
             householderId = test123;
             id = 13;
             idCard = 513029199910053056;
             mobile = 14754586412;
             name = "余思";
             relation = 2;
             sex = 2;
             updateTime = "<null>";
         }
     );
     province = "<null>";
     realName = "余莹";
     sex = 0;
     uid = "<null>";
 };*/
@end

NS_ASSUME_NONNULL_END
