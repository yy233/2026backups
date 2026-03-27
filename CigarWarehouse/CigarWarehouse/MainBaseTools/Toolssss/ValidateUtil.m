//
//  ValidateUtil.m
//  Community
//
//  Created by 余莹 on 2020/11/11.
//

#import "ValidateUtil.h"

@implementation ValidateUtil
+ (BOOL)isMatchPhoneNumberFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string{
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return delet
        return YES;
    }
    if(![self validataByRegex:@"[0-9]+" withString:string]){
        return NO;
    }
    if (textField.text.length >=11) {
        return NO;
    }
    return YES;
}

+ (BOOL)validataByRegex:(NSString *)regex withString:(NSString *)string{
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([regextestmobile evaluateWithObject:string] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark ==
/**
 /^(([a-zA-Z]+[0-9]+)|([0-9]+[a-zA-Z]+)|([a-z]+[@#%])|([0-9]+[@#%]))([a-zA-Z0-9@#%]*)$/
 密码要求 以字母(大小写)或数字开头，至少包含字母、数字、特殊字符(上式举例“@#%”)中的两种字符
 
 //密码必须包含大小写字母/数字/符号任意两者组合
 /^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)(?!([^(0-9a-zA-Z)]|[\(\)])+$)
 
 情况一：密码的强度包含字母和数字的组合，不能使用特殊字符，长度8-10位。
 正则表达式：   ^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,10}$
  

 情况而：包含大小写字母、数字、符号任意两者组合，长度6位以上
 正则表达式：  /^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)(?!([^(0-9a-zA-Z)]|[\(\)])+$)([^(0-9a-zA-Z)]|[\(\)]|[a-z]|[A-Z]|[0-9]){6,}$/
  

 情况三：6-10位密码必须是数字和字母
 正则表达式：  '/^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,10}$/';
 
 ^[A-Za-z0-9]
 ^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$
 ^[a-zA-Z]\w
 [a-zA-Z0-9]
 由数字、26个英文字母或者下划线组成的字符串：^\w+$ 或 ^\w{3,20}$
 密码(以字母开头，长度在6~18之间，只能包含字母、数字和下划线)：^[a-zA-Z]\w{5,17}$
 //用正则表达式限制 输入必须为数字或字母，长度只能为4~6位 RegExp(/^[a-zA-Z0-9] {4,6}$/);
 匹配9-15个由字母/数字组成的字符串的正则表达式= @"^[A-Za-z0-9]{9,15}$";
 @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"不能全部是数字不能全部是字母必须是数字或字母
 */
+ (BOOL)isMatchPasswordFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string{
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {
        return YES;
    }
    //a-z 0-9判断
    NSString *regex = @"[a-zA-Z0-9]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:string]){
        return NO;
    }
    if (textField.text.length >= 30) {
        return NO;
    }
    return YES;
}


#pragma mark =====
/**
 /^(([a-zA-Z]+[0-9]+)|([0-9]+[a-zA-Z]+)|([a-z]+[@#%])|([0-9]+[@#%]))([a-zA-Z0-9@#%]*)$/
 密码要求 以字母(大小写)或数字开头，至少包含字母、数字、特殊字符(上式举例“@#%”)中的两种字符
 */
+(BOOL)isMachPasswordJudgeBeforeSendingAgainWithString:(NSString *)string{
    NSString * regex = @"^(([a-zA-Z]+[0-9]+)|([0-9]+[a-zA-Z]+)|([a-z]+[@#%])|([0-9]+[@#%]))([a-zA-Z0-9@#%]*)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:string]){
        return NO;
    }
    if (string.length > 30 || string.length < 8) {
        return NO;
    }
    return YES;
    
}
#pragma mark == 数字 字母  最大长度
+(BOOL)isMachPasswordWithTextField:(UITextField *)textF anMaxNumInt:(NSInteger)maxInt String:(NSString *)string{
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {
        return YES;
    }
    NSString * regex = @"[a-zA-Z0-9]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:string]){
        return NO;
    }
    if (textF.text.length >= maxInt) {
        return NO;
    }
    return YES;
    
}
#pragma mark ===== code
+ (BOOL)isMatchCodeFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string{
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {
        return YES;
    }
    if(![self validataByRegex:@"[0-9]+" withString:string]){
        return NO;
    }
//    if (textField.text.length >= 6) {
    if (textField.text.length >= 4) {
        return NO;
    }
    return YES;
}
#pragma mark === 数字 18位  不可用于身份证
+ (BOOL)isMatchIdCardNumberFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string{
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return delet
        return YES;
    }
    if(![self validataByRegex:@"[0-9]+" withString:string]){
        return NO;
    }
    if (textField.text.length >=18) {
        return NO;
    }
    return YES;
}
#pragma mark === 车牌
+ (BOOL)isMatchCarCodeNumberWithAllString:(NSString *)string{
    if(![self validataByRegex:@"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$" withString:string]){
        return NO;
    }
    if (string.length >7) {
        return NO;
    }
    return YES;
}

#pragma mark ===下面是网上搜集的一个很好的检测金额格式的写法，不过无意中发现它无法检测出 0. 这一金额格式

- (BOOL)priceFormat:(NSString *)price{

    if (price.length > 0) {

        //支持+ - 符号 支持的金额格式

        NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,6}(([.]\\d{0,2})?)))?";

        

        NSPredicate *pricePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];

        if ([pricePredicate evaluateWithObject:price] == NO) {// 不满足该正则，就不让用户输入，执行return NO。

            return NO;

        }

    }

    // 满足该正则，让用户输入，执行return YES

    return YES;

}


//+ (BOOL)isMatchCarCodeNumberFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string{
//    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return delet
//        return YES;
//    }
//    if(![self validataByRegex:@"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$" withString:string]){
//        return NO;
//    }
//    if (textField.text.length >=7) {
//        return NO;
//    }
//    return YES;
//}


//+ (BOOL)isMobileNumber:(NSString *)phone {
//    NSString * MOBILE = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
//
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    if ([regextestmobile evaluateWithObject:phone] == YES)
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//
//}
//
////邮箱校验
//+ (BOOL)validateEmail:(NSString *)email{
//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    return [emailTest evaluateWithObject:email];
//}
//
//
////身份证校验
//
//+ (BOOL)validateIdentityCard: (NSString *)identityCard{
//    BOOL flag;
//    if (identityCard.length <= 0) {
//        flag = NO;
//        return flag;
//
//    }
//    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
//    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
//    return [identityCardPredicate evaluateWithObject:identityCard];}
//

////银行卡校验
//+(BOOL)validateBankCardNumber:(NSString *)cardNumber{
//    if(![self validateByRegex:@"^[0-9]*$" withObject:cardNumber]){
//        return NO;
//        
//    }
//    return YES;
//    
//}
@end
