//
//  RealNameAuthenticationCardModel.h
//  Community
//
//  Created by 余莹 on 2021/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYRealNameAuthenticationCardModel : NSObject
@property (nonatomic,strong) NSString  *name;
@property (nonatomic,strong) NSString  *address;
@property (nonatomic,strong) NSString  *num;
@property (nonatomic,strong) NSString  *sex;
/**
 code = 0;
 data =     {
     address = "武汉市武昌区粮道街2-2-1805号";
     name = "宋凯";
     num = 420106198106254411;
     sex = "男";
 };
 message = "<null>";
}*/
/**
 //背面
 
 code = 0;
 data =     {
     angle = 180;
     "card_region" =         (
                     {
             x = 781;
             y = 758;
         },
                     {
             x = 4005;
             y = 767;
         },
                     {
             x = 3787;
             y = 2819;
         },
                     {
             x = 870;
             y = 2657;
         }
     );
     "config_str" = "{\"side\":\"back\"}";
     "end_date" = 20360808;
     "is_fake" = 0;
     issue = "\U6b66\U6c49\U5e02\U516c\U5b89\U5c40\U6b66\U660c\U5206\U5c40";
     "request_id" = "BB23A4E9-5022-48F0-B889-9559A685EEF2";
     "start_date" = 20160808;
     succes
 */
@end

NS_ASSUME_NONNULL_END
