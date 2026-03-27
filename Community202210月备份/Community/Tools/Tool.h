//
//  Tool.h
//  Community
//
//  Created by 余莹 on 2020/11/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,CodeRequestType){
    CodeRequestType_Regist=1,
    CodeRequestType_Login=2,
    CodeRequestType_ForgetPassword=3,
    CodeRequestType_ChangePhoneNum=4,
    CodeRequestType_ThirdRegistBangDingPhone = 5,
    CodeRequestType_ChangePassword=6,
    CodeRequestType_MoneyJieBangWx=8,
};
@interface Tool : NSObject

//随机颜色
+ (UIColor *)getAnRandomColor;

/**
 获取一个随机整数，范围在[from,to]，包括from，包括to
 */
//+  (NSInteger)getRandomNumberFrom:(NSInteger)fromIntV withTo:(NSInteger)toIntV;
+(int)getRandomNumber:(int)from to:(int)to;
/**
 生成32为无序标示
 */
+ (NSString *)toolCreateRandomUuid;
+ (NSString *)toolCreateRandomUuidSmall;
 

//验证码类型，1注册，2登录，3忘记密码，4更换手机号 5三方登录绑定手机 6.修改密码
+ (UIColor *)getColorWithHexString:(NSString *)hex;
/**
 单行
 输入：文本 文本font
 得到：文字宽度 */
+ (float)getTextWidthWhenOneLineWithTextStr:(NSString *)string withFont:(UIFont *)font;
/**
 多行
 输入：最大宽度 文本 font
 得到： 文字高度
 */
+ (float)getTextHeightWhenHaveWidthFloatNum:(float)width withTextStr:(NSString *)string withFont:(UIFont *)font;

+ (NSInteger)getIndexWithObj:(id)obj withArr:(NSMutableArray *)sourceArr;
//
 

/** 将二进制数据转换成字典*/

+ (NSDictionary *)dictionaryForJsonData:(NSData *)jsonData;
 
/** 将字典转换成json格式字符串,不含\n这些符号*/

+ (NSData *)compactFormatDataForDictionary:(NSDictionary *)dicJson;


+ (NSString*)jsonWithArr:(NSArray *)arr;
+ (NSArray *)arrWithJson:(NSString *)jsonString;
/** json 转dic*/
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/**  dic 转 json */
+ (NSString *)jsonStrWithDic:(NSDictionary *)dict;


//
/**
 *  URLEncode
 */
+ (NSString *)URLEncodedString:(NSString *)str;

/**
 *  URLDecode
 */
+(NSString *)URLDecodedString:(NSString *)str;

+ (UIWindow *)toolGetKeyWindow;
 
#pragma mark ==
#pragma mark ----两个数相加-----------

+(NSString *)calculateByadding:(NSString *)number1 secondNumber:(NSString *)number2;

#pragma mark ----两个数相减------------ number1 - number2
+(NSString *)calculateBySubtractingMinuend:(NSString *)number1 subtractorNumber:(NSString *)number2;
#pragma mark ----两个数相乘------------
+(NSString *)calculateByMultiplying:(NSString *)number1 secondNumber:(NSString *)number2;

#pragma mark ----两个数相除------------
+ (NSString *)calculateByDividingNumber:(NSString *)number1 secondNumber:(NSString *)number2;
// webView 因URL中含有中文加载网页白屏显示的解决方法
#pragma mark == 中文转符号
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;

#pragma mark == url dic  之间的转换
//字典转链接（参数）
+ (NSString *)keyValueStringWithDict:(NSDictionary *)dict;
//链接转字典  （参数）
+ (NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr;

//**特殊链接解析不了 。  'https://wwww.baidu.com/#/sdffff?name=sdfff&pass=dddff'å
+ (NSDictionary *) parameterWithURL:(NSURL *) url;
@end

NS_ASSUME_NONNULL_END
