//
//  JGSaveIdShare.m
//  Community
//
//  Created by 余莹 on 2021/9/15.
//

#import "JGSaveIdShare.h"

@implementation JGSaveIdShare
MJCodingImplementation //归档
singleton_implementation(sharedUserInfo)

//
- (NSString *)registrationID{
    if (!_registrationID) {
        _registrationID = @"xxx";
    }
    return _registrationID;
}
@end
