//
//  MyHousekeeperPicModel.h
//  Community
//
//  Created by 余莹 on 2021/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHousekeeperPicModel : NSObject

@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,copy) NSString *picture;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *profile;//1016更改
//@property (nonatomic,copy) NSString *describe;//profile
@property (nonatomic,copy) NSString *contactsMobile;//电话

/**
 
      "id": 1,
        "idStr": "1",
        "deleted": 0,
        "createTime": "2021-07-20 17:59:48",
        "name": "物业公司名称",
        "describe": "描述",
        "picture": "图片  以逗号分割"
    }
 */
@end

NS_ASSUME_NONNULL_END
