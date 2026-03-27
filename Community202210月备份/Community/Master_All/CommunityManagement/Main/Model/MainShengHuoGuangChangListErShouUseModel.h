//
//  MainShengHuoGuangChangListErShouUseModel.h
//  Community
//
//  Created by 余莹 on 2021/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainShengHuoGuangChangListErShouUseModel : NSObject

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger negotiable;
@property (nonatomic,assign) NSInteger state;
@property (nonatomic,strong) NSString *idStr;
@property (nonatomic,strong) NSString *goodsName;//
@property (nonatomic,strong) NSString *goodsExplain;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *labelName;
@property (nonatomic,strong) NSString *categoryName;
@property (nonatomic,assign) double price;
@property (nonatomic,strong) NSString *images;




//
- (CGFloat)getHeightUseMainVcShow;

/**
 
        "id": 92379957350764544,
                 "goodsName": "小米8",
                 "price": 6000.00,
                 "goodsExplain": "刚买的，没怎么用  便宜卖4",
                 "negotiable": 0,//是否面议  没有价格 默认面议
                 "state": 0,
                 "phone": "13132314900",
                 "labelName": "全新",
                 "categoryName": "电脑数码",
                 "idStr": "92379957350764544"
             }
 
 categoryId = "dd46d19a-38ee-4c8b-aa48-657a386c9dcf";
 categoryName = "电脑数码";
 communityId = 1;
 goodsExplain = "刚买的，没怎么用  便宜卖4";
 goodsName = "小米8";
 id = 92379957350764544;
 images = "skfiwu erbx";
 labelId = "06289b0a-b11f-4172-86a9-7ebcbf1c32a5";
 labelName = "全新";
 negotiable = 0;
 phone = 13132314900;
 price = 6000;
 uid = test123;
 */
  
@end

NS_ASSUME_NONNULL_END
