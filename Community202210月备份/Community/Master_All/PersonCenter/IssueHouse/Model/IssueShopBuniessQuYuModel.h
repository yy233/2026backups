//
//  QuYuModel.h
//  Community
//
//  Created by 余莹 on 2021/1/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueShopBuniessQuYuModel : NSObject

@property (nonatomic,strong) NSString *initials;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *pinyin;
 
//
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger level;
@property (nonatomic,assign) NSInteger pid;
//
@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lng;

/**
 {
id = 110114;
initials = C;
lat = "40.2208";
level = 3;
lng = "116.231";
name = "昌平区";
pid = 110100;
pinyin = changping;
},
 {
id = 110115;
initials = D;
lat = "39.7268";
level = 3;
lng = "116.342";
name = "大兴区";
pid = 110100;
pinyin = daxing;
},

 */
@end

NS_ASSUME_NONNULL_END
