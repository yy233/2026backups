//
//  LifeCostHistoryCostModel.h
//  Community
//
//  Created by 余莹 on 2021/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostHistoryCostModel : NSObject
//@property (nonatomic,strong) NSString *icon;
//@property (nonatomic,strong) NSString *typeName;
//@property (nonatomic,strong) NSString *unitName;
//@property (nonatomic,strong) NSString *orderTime;
//@property (nonatomic,assign) double paySum;

@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *timeGroup;
@property (nonatomic,strong) NSString *orderTime;
@property (nonatomic,strong) NSString *typeName;
 
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *mediumIcon;
@property (nonatomic,strong) NSString *largeSizeIcon;

@property (nonatomic,assign) NSInteger typeId;
@property (nonatomic,assign) NSInteger familyId;
@property (nonatomic,assign) NSInteger orderId; //订单号
@property (nonatomic,assign) NSInteger orderNum;//支付生成的流水号
@property (nonatomic,assign) NSInteger payMonth;
@property (nonatomic,assign) NSInteger payYear;

@property (nonatomic,assign) double paymentBalance;

/**
 "2021年3月" =             (
                     {
         companyName = "重庆燃气集团公司";
         familyId = 154613516;
         icon = "https://i.postimg.cc/HsS1xc91/3.png";
         largeSizeIcon = "https://i.postimg.cc/25wggjd2/a3.png";
         mediumIcon = "https://i.postimg.cc/bYSK8ym3/q3.png";
         orderId = 32987826903715840;
         orderNum = 202103041417427655596934;
         orderTime = "2021-03-10 17:47:11";
         payMonth = 3;
         payYear = 2021;
         paymentBalance = 57;
         timeGroup = "2021年3月";
         typeId = 3;
         typeName = "燃气费";
     },
                     {
         companyName = "国家电网重庆市电力公司";
         familyId = 105613516;
         icon = "https://i.postimg.cc/4xSG87YQ/2.png";
         largeSizeIcon = "https://i.postimg.cc/VkyyCVLB/a2.png";
         mediumIcon = "https://i.postimg.cc/vTnjvh4p/q2.png";
         orderId = 32987673404772352;
         orderNum = 202103041417427655596934;
         orderTime = "2021-03-10 17:46:35";
         payMonth = 3;
         payYear = 2021;
         paymentBalance = 57;
         timeGroup = "2021年3月";
         typeId = 2;
         typeName = "电费";
     },
                     {
         companyName = "重庆江南水务公司";
         familyId = 1056134646;
         icon = "https://i.postimg.cc/XYQqnYpr/1.png";
         largeSizeIcon = "https://i.postimg.cc/s2rRt0kD/a1.png";
         mediumIcon = "https://i.postimg.cc/zGFsMxxN/q1.png";
         orderId = 32987447646359552;
         orderNum = 202103041417427655596934;
         orderTime = "2021-03-10 17:45:41";
         payMonth = 3;
         payYear = 2021;
         paymentBalance = 57;
         timeGroup = "2021年3月";
         typeId = 1;
         typeName = "水费";
     }
 );
};
 );*/
@end

NS_ASSUME_NONNULL_END
