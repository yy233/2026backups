//
//  LifeCostPayTypeModel.h
//  Community
//
//  Created by 余莹 on 2022/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPayTypeModel : NSObject

@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *citycode;
@property (nonatomic,copy) NSString *picUrlClient;
@property (nonatomic,assign) NSInteger paymentType;
@property (nonatomic,assign) NSInteger sort;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,copy) NSString *typeName;

@property (nonatomic,assign) BOOL isPropertyFee;//  物业费的入口bool

//
/**
 {
cityName = "北京市";
citycode = 010;
paymentType = 1;
picUrlClient = "https://yaoyaotest.cebbank.com/yaoyao-images/9j4RY1604567764132.png";
sort = 4;
type = 3;
typeName = "燃气费";
},
 {
cityName = "北京市";
citycode = 010;
paymentType = 1;
picUrlClient = "https://yaoyao.cebbank.com/yaoyao-images/294291555481166327.jpg";
sort = 5;
type = 5;
typeName = "有线电视费";
},
 
 */
@end

NS_ASSUME_NONNULL_END
