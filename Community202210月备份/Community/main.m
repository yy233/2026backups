//
//  main.m
//  Community
//
//  Created by 余莹 on 2020/11/9.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
//    NSString * appDelegateClassName;
//    @autoreleasepool {
//        // Setup code that might create autoreleased objects goes here.
//        appDelegateClassName = NSStringFromClass([AppDelegate class]);
//    }
//    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
    @autoreleasepool
        {
            int returnValue;
            @try
            {
                returnValue = UIApplicationMain(argc, argv, nil,
                    NSStringFromClass([AppDelegate class]));
            }
            @catch (NSException* exception)
            {
                DLog(@" mian __________****__________   Uncaught exception: %@, %@", [exception description],
                    [exception callStackSymbols]);
                @throw exception;
            }
            return returnValue;
        }
 
}
