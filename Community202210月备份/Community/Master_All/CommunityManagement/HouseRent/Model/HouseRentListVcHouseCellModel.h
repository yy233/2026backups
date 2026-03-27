//
//  HouseRentListVcModel.h
//  Community
//
//  Created by 余莹 on 2020/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentListVcHouseCellModel : NSObject
//0813
- (CGFloat)getHeightUseMainVcShow;
//
@property (nonatomic,assign) BOOL deleted;//0719
//20210416
@property (nonatomic,strong) NSDictionary *houseAdvantageCode;//蓝色小框使用
//
@property (nonatomic,strong) NSDictionary *houseAdvantage;//Query该键是数组 cellmodel的该键是字典且显示使用用key值
@property (nonatomic,strong) NSArray *houseFurniture;
@property (nonatomic,strong) NSArray *houseImage;
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) NSInteger houseAdvantageId;
@property (nonatomic,assign) NSInteger houseFurnitureId;
@property (nonatomic,assign) NSInteger houseImageId;
//
@property (nonatomic,strong) NSString *houseReserveTime;
@property (nonatomic,assign) double houseSquareMeter;//面积
//
@property (nonatomic,assign) double housePrice;//钱
@property (nonatomic,strong) NSString *houseUnit;//单位
//
@property (nonatomic,assign) NSInteger houseTypeId;
@property (nonatomic,strong) NSString *houseType;
//
@property (nonatomic,strong) NSString *houseAddress;
@property (nonatomic,strong) NSString *houseTitle;
//
@property (nonatomic,strong) NSString *houseLeaseMode;
@property (nonatomic,assign) NSInteger houseLeasemodeId; //1016  新的是 （1不限(默认) 2整租，4合租 8单间）
//
@property (nonatomic,assign) double houseLon;
@property (nonatomic,assign) double houseLat;
 //
@property (nonatomic,strong) NSString *houseLeaseDeposit;// "年付";
// 房屋朝向
@property (nonatomic, copy) NSString *houseDirection;

// 签约id
@property (nonatomic, copy) NSString *contractId;


//0703imid
@property (nonatomic,strong) NSDictionary *user; //key=imId
//user 内有多键值
//                @property (nonatomic,strong) NSString *nickname;
//                @property (nonatomic,strong) NSString *realName;
//                @property (nonatomic,strong) NSString *regId;
//                @property (nonatomic,strong) NSString *idCard;
//                @property (nonatomic,strong) NSString *avatarUrl
@property (nonatomic,strong) NSString *appellation;//房主发布的名字位置key 实名非昵称
//user =         {
//    imId = 0ea7b3fb119c4bb68ce351b976de5b6e;
//};

/**
 "data": [
        {
            "id": 2784213959053312,
            "houseTitle": "江北观音桥北城天街九街旁标准两房pianyi整租",
            "houseAddress": "江北-观音桥 兴隆路20号",
            "houseAdvantageId": 7,
            "houseFurnitureId": 1,
            "houseAdvantage": {
                "临街门面": 2,
                "商业街": 4,
                "面议": 1
            },
            "houseFurniture": [
                "冰箱"
            ],
            "houseReserveTime": "周一至周五",
            "housePrice": 24650,
            "houseUnit": "年",
            "houseSquareMeter": 1232,
            "houseTypeId": 1,
            "houseType": "一室一厅一卫",
            "houseImage": [
                "http://222.178.212.29:9000/car-img/63fd25b1-f8e4-4fde-b757-bf2d60983bf5-fengjing.jpg"
            ],
            "houseImageId": 2784213996802048,
            "houseLeasemodeId": 2,
            "houseLeaseMode": "整租",
            "houseLon": 764.4,
            "houseLat": 489.12
        },
        {
            "id": 2784273472032768,
            "houseTitle": "房东，直租， 观*/
@end

NS_ASSUME_NONNULL_END
