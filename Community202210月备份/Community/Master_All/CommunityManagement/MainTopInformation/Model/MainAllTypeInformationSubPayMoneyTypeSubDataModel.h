//
//  MainAllTypeInformationSubPayMoneyTypeSubDataModel.h
//  Community
//
//  Created by 余莹 on 2021/9/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    subDataModel_ShowType_No = 0,
    subDataModel_ShowType_OnlyText = 1,
    subDataModel_ShowType_Money = 2,
    subDataModel_ShowType_TextAndUrl = 3,//当前为自定义的
//    subDataModel_ShowType_TextAndWillPushInfomationWebViewToShow = 4,//物业通知 自定义的
} subDataModel_ShowType;

@interface MainAllTypeInformationSubPayMoneyTypeSubDataModel : NSObject
@property (nonatomic,strong) NSString *sub_name;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *sub_head_img_url;
@property (nonatomic,strong) NSString *sub_im_id; //monthlyRentPayment
@property (nonatomic,strong) NSString *currency;//RMB
@property (nonatomic,strong) NSString *pay_type;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *links;//jsonStr {\"url\":\"www.baidu.com\""desc\":\"\U67e5\U770b\U8d26\U5355\U8be6\U60c5\"}]
@property (nonatomic,strong) NSString *appinfo;//jsonStr
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger template_id;
@property (nonatomic,assign) double pay_amount;
//0401付款币种

 
/**
 data = "{\"sub_name\":\"\U6708\U79df\U7f34\U8d39\",\"pay_amount\":\"200\",\"title\":\"\U652f\U4ed8\U901a\U77e5\",\"type\":2,\"content\":\"\",\"url\":\"www.baidu.com\",\"sub_head_img_url\":\"www.baidu.com\",\"sub_im_id\":\"monthlyRentPayment\",\"appinfo\":{\"version\":\"1\"},\"currency\":\"RMB\",\"links\":[{\"url\":\"www.baidu.com\",\"desc\":\"\U67e5\U770b\U8d26\U5355\U8be6\U60c5\"}],\"pay_type\":\"\U5fae\U4fe1\U652f\U4ed8\",\"template_id\":\"\",\"desc\":\"\U623f\U5c4b\U7f34\U8d39\"}";
 "encrypt_flag" = 0;
 */
@end

NS_ASSUME_NONNULL_END
