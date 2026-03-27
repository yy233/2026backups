//
//  SosAddressBookFamilyModel.h
//  Community
//
//  Created by 余莹 on 2021/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SosAddressBookFamilyModel : NSObject
 
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *familyId;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *updateTime;
@property (nonatomic,assign) NSInteger deleted;


/**
 familyList =         (
                 {
         createTime = "2021-11-27 17:52:41";
         deleted = 0;
         familyId = 126826967298347008;
         id = 127934829068161024;
         mobile = ;
         name = "于";
         uid = 55262;
         updateTime = "<null>";
     }
 );
};
 */
@end

NS_ASSUME_NONNULL_END
