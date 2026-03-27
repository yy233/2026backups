//
//  ZYValidInputTextTool.h
//  Community
//
//  Created by ZY on 2021/10/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYValidInputTextTool : NSObject

// 输入框中只能输入数字和小数点，参数number可以设置小数的位数
+ (BOOL)isValidAboutInputText:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string decimalNumber:(NSInteger)number;

@end

NS_ASSUME_NONNULL_END
