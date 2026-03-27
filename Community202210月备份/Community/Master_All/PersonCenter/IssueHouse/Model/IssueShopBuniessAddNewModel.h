//
//  IssueShopBuniessAddNewModel.h
//  Community
//
//  Created by 余莹 on 2021/3/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueShopBuniessAddNewModel : NSObject
//
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *summarize;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *floor;
@property (nonatomic,strong) NSString *defrayType; //押赴
@property (nonatomic,strong) NSString *monthMoney;
@property (nonatomic,strong) NSString *transferMoney;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *city; //城市
@property (nonatomic,strong) NSString *area; //地区
//
//@property (nonatomic,assign) NSInteger transferMoney;
@property (nonatomic,assign) NSInteger status;    //空置在营业？0713
@property (nonatomic,assign) NSInteger startLease;//起租
@property (nonatomic,assign) NSInteger shopTypeId;//类型 ？ 0713
@property (nonatomic,assign) NSInteger shopBusinessId; //行业？0713
//@property (nonatomic,assign) NSInteger mobile;
@property (nonatomic,assign) NSInteger freeLease; //免租
@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,assign) NSInteger cityId;
@property (nonatomic,assign) NSInteger areaId; 
//
@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lon;
//@property (nonatomic,assign) double monthMoney;
@property (nonatomic,assign) double shopAcreage;
@property (nonatomic,assign) double shopDepth;
@property (nonatomic,assign) double shopHeight;
@property (nonatomic,assign) double shopWidth;
//
@property (nonatomic,strong) NSArray *imgPath;
@property (nonatomic,strong) NSArray *shopFacilityList;
@property (nonatomic,strong) NSArray *shopPeoples;
@property (nonatomic,strong) NSArray *shopTypeArr;
@property (nonatomic,strong) NSArray *shopInArr;
//
@property (nonatomic,assign) NSInteger shopId; //修改时使用

/**
 {
   "areaId": 500103,
   "cityId": 500000,
   "communityId": 1,
   "defrayType": "押1付1",
   "floor": "36层/共48层",
   "freeLease": 0,
   "imgPath": [
         "http://222.178.212.29:9000/shop-head-img/18d3fb15-056c-4ade-9a75-66bcd0992dfb",
         "http://222.178.212.29:9000/shop-head-img/7b1739db-9b84-4dcf-b5cc-ec73e5087fd4",
         "http://222.178.212.29:9000/shop-head-img/14be455d-9d12-43e0-b7da-8aade1c333eb",
         "http://222.178.212.29:9000/shop-middle-img/0ecb9dfc-4b10-498d-a9ad-a8321b1d0859",
         "http://222.178.212.29:9000/shop-middle-img/64d6136c-c1c7-4fad-9a10-4fa3fd4ad76d",
         "http://222.178.212.29:9000/shop-other-img/09759fb1-b5b5-478e-8ce5-2a6b682f2e69",
         "http://222.178.212.29:9000/shop-other-img/ffceaebe-1577-4be1-98ef-062cb2f63c53"


 ],
   "lat": 29.592132,
   "lon": 105.729482,
   "mobile": "18580865040",
   "monthMoney": 4500,
   "nickname": "林俊杰",
   "shopAcreage": 999,
   "shopBusinessId": 10,
   "shopDepth": 288,
   "shopFacilityList": [
      1,4,16,32,64
   ],
   "shopHeight": 37,
   "shopPeoples": [
      2,4
   ],
   "shopTypeId": 2,
   "shopWidth": 10,
   "startLease": 99,
   "status": 0,
   "summarize": "观音桥没有观音",
   "title": "观音桥111",
   "transferMoney": -1
 }*/
@end

NS_ASSUME_NONNULL_END
