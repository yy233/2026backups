//
//  ToolOfBasic.h
//  shusheng
//
//  Created by rimi on 16/7/9.
//  Copyright © 2016年 yuying. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSInteger{
    AFHttpNotReachable = 0,
    AFHttpReachableViaWiFi,
    AFHttpReachableViaWWAN
}AFHttpNetworkStatus;

@interface ToolOfBasic : NSObject


//wifi
+ (AFHttpNetworkStatus)currentNetworkStatus;

//时间
+(NSString *)nowTime;
+(NSDate *)nowTimeOfDate;
+(NSString *)nowTimeOfLong;
#pragma mark -- 时间str转date转某格式str
+ (NSString *)timeStrChangeNewTimeStrWithOldStr:(NSString *)oldStr;
//上月下月
+ (NSDate *)dayInThePreviousMonth:(NSDate*)date;
+ (NSDate *)dayInTheFollowingMonth:(NSDate*)date;

+ (NSString *)dayInTheFollowingMonthStr:(NSString*)dateS;
+ (NSString *)dayInThePreviousMonthStr:(NSString *)dateS;

#pragma mark —————— 上下几天
+ (NSDate *)dayInThePreviousDayNum:(NSInteger)dayNum  beginDate:(NSDate*)date;
+ (NSDate *)dayInTheFollowingDayNum:(NSInteger)dayNum  beginDate:(NSDate*)date;
//int转小时分钟秒
+ (NSString *)timeStr:(int)totalSeconds;
//秒转小时分钟
+ (NSString *)timeFormatted:(int)totalSeconds;//
#pragma mark —————— 秒转天小时分钟 小于1分钟记一分钟
+ (NSString *)timeDayFormatted:(int)totalSeconds;
+ (NSString *)timeDayFormattedOfEnglish:(int)totalSeconds;
#pragma mark —————— 秒转分钟小于一分钟记一分钟
+ (NSString *)timeForMinuteswithTalSseconds:(int)totalSeconds;

//nsstring与date互转
#pragma mark —————— NSString 转换为 NSDate
+(NSDate *)strLongBecomeDate:(NSString *)longDateStr;
+(NSDate *)strShortBecomeDate:(NSString *)shortDateStr;
#pragma mark —————— NSDate 转换为 NSString
+ (NSString *)dateBecomeLongStr:(NSDate *)date;
+ (NSString *)dateBecomeShortStr:(NSDate *)date;

#pragma mark —————— 前后时间串进行比较
+ (int)compareOneDay:(NSString *)oneDayStr withAnotherDay:(NSString *)anotherDayStr;

//表情过滤
+(BOOL)stringContainsEmoji:(NSString *)string;

//加密解密
+ (NSString*)encodeBase64String:(NSString*)input;
+ (NSString*)decodeBase64String:(NSString*)input;
+ (NSString*)encodeBase64Data:(NSData*)data;
+ (NSString*)decodeBase64Data:(NSData*)data;

//+ (CLLocation *)AMapLocationFromBaiduLocation:(CLLocation *)BaiduLocation;

//图片拼接
+ (UIImage *)combineleftI:(UIImage*)leftImage
                    rightI:(UIImage*)rightImage ;

//+ (UIImage *)combineTwoImgWithX:(int)mapImgX
//                              y:(int)mapImgY
//                              w:(int)w
//                              h:(int)h
//                       NewImage:(UIImage*)newImage
//                        newPosx:(int)newPosx
//                        newPosy:(int)newPosy
//                    beforeImage:(UIImage*)beforeImage
//                     beforePosx:(int)beforePosx
//                     beforePosy:(int)beforePosy;
+ (UIImage *)combineTwoImgWithX:(int)mapImgX
                              y:(int)mapImgY
                              w:(int)w
                              h:(int)h
                       NewImage:(UIImage*)newImage
                        newPosx:(int)newPosx
                        newPosy:(int)newPosy
                           newW:(int)newW
                           newH:(int)newH
                    beforeImage:(UIImage*)beforeImage
                     beforePosx:(int)beforePosx
                     beforePosy:(int)beforePosy
                        beforeW:(int)beforeW
                        beforeH:(int)beforeH;


//排序

#pragma mark - 冒泡降序排序
+ (NSMutableArray *)bubbleDescendingOrderSortWithArray:(NSMutableArray *)descendingArr;

#pragma mark - 冒泡升序排序
+ (NSMutableArray *)bubbleAscendingOrderSortWithArray:(NSMutableArray *)ascendingArr;
+ (UIImage *)getImgWithRect:(CGRect)rect
             charPointRgba:(unsigned char*)rgba;//colors: 转换后Img

#pragma mark - 开辟内存放颜色数据
//+ (NSMutableArray*)twoUseDataPMallocWithData:(NSData *)data
//                             charPointMalloc:(unsigned char*)mallocPoint
//                                arrOfChangeColor:(NSMutableArray*)arrOfChangeColor;
//+ (NSMutableArray*)twoUseDataPMallocWithData:(NSData *)data
//                             charPointMalloc:(unsigned char*)mallocPoint
//                            arrOfChangeColor:(NSMutableArray*)arrOfChangeColor
//                                           w:(int)w;//增加宽度
//colors: 转换后的RGB数据
+ (void)useDataPMallocWithData:(NSData *)data
               charPointMalloc:(unsigned char*)mallocPoint;

//镜像
+ (UIImage *)getYMirrorWIthImg:(UIImage *)img;
+ (UIImage *)getYMirrorFlipWithImg:(UIImage *)img;
+ (UIImage *)getXMirrorFlipWithImg:(UIImage *)img;

//两点距
+ (CGFloat)getLineDustanceApToBpWithPa:(CGPoint)pa
                                    pb:(CGPoint)pb;

//点到线的距离
+ (double)calDisWithBeginPointX:(double)xB
                    BeginPointY:(double)yB
                      EndPointX:(double)xE
                      EndPointY:(double)yE
                      tapPointX:(double)xp
                      tapPointY:(double)yp;
//点到线的距离
+(CGFloat)pedalWithBeginPoint:(CGPoint)pB
                     endPoint:(CGPoint )pE
                     tapPoint:(CGPoint)x0;
//以三个点A、B、C，计算ㄥABC为例，贴代码：AB为竖直方向固定
+ (CGFloat)getAnglesWithThreePoint:(CGPoint)pointA pointB:(CGPoint)pointB pointC:(CGPoint)pointC;
//一维转二维数组
+ (NSMutableArray *)oneArrToTwoArrWithOneArr:(NSMutableArray *)oneArr
                                        hang:(int)hang;

//img清晰度
//size越大清晰度越高但到原清晰度为上限，内存升的高。
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
//判断是否有中文
+ (BOOL)haveChinese:(NSString *)str;
//数字输入应该是数字
+ (BOOL)deptNumInputShouldNumber:(NSString *)str;
//app名字
+ (NSString *)appNameStr;

/**厂商品牌
 wifi
 晶果：ginkgor
 冠唯（李工）：kingwer
 公模机：bleamn
 
 厂商
 枚举列表，比如，晶果=01，李工=02，周工=03； 产品厂家占两位
 */
//+(int)appIsJgReturnOneIsLgReturnTwoIsZgReturnThrOtherReturnZone;
+(int)appIsJgReturnOneIsLgReturnTwoIsZgReturnThrOtherReturnZoneWithFirstRobotId:(NSString *)firstRobotIdStr;
//导航版2位
//存下的xml数据是否大于当前扫地机版本数据
+ (BOOL)lastxmlVersionBigThanCurrentRobotVersionWithMsgArr:(NSMutableArray *)arrOfMessage
                                         saveXmlVersionStr:(NSString *)lastVersionStr;

//控制板升级数据3位的判断
//存下的xml数据是否大于当前扫地机版本数据 是 升级  否 不升级 //两位比较
+ (BOOL)lastxmlKZVersionBigThanCurrentRobotKZVersionWithMsgArr:(NSMutableArray *)arrOfMessage
                                           saveXmlKZVersionStr:(NSString *)lastKZVersionStr;
//btn 文字图片左右
+ (UIButton *)btnTextRightAndImgLeft:(UIButton *)btn;
//btn 图片文字上下
+ (UIButton *)btnTextBottomAndImgTop:(UIButton *)btn;
//版本
+ (NSInteger)itunesVersionAndAppVersionCompareVersion:(NSString *)v1 to:(NSString *)v2;

// 判断仅输入字母或数字：
+ (BOOL)inputShouldLetterOrNum:(NSString *)inputString;

+ (NSArray *)getRGBAArrByUIColor:(UIColor *)originColor;

#pragma mark -- UIImageView虚线
+ (void)drawLineByImageView:(UIImageView *)imageView;
#pragma mark -- 将UIColor变换为UIImage
+ (UIImage *)createImageWithColor:(UIColor *)color frame:(CGRect)rect;
#pragma mark --img圆角UIIamge 的方法
//生成圆角UIIamge 的方法
+ (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius img:(UIImage*)img;
@end
