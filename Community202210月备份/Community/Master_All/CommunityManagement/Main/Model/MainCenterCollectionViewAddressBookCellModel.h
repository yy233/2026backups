//
//  MainCenterCollectionViewAddressBookCellModel.h
//  Community
//
//  Created by 余莹 on 2020/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainCenterCollectionViewAddressBookCellModel : NSObject

//部门list
@property (nonatomic,assign)NSInteger communityId;
@property (nonatomic,strong)NSString *department;
@property (nonatomic,assign)NSInteger deleted;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *updateTime;
//@property (nonatomic,assign)NSInteger id;
@property (nonatomic,assign)NSInteger ID;
//phonelist

@property (nonatomic,assign)NSInteger departmentId;
@property (nonatomic,strong)NSString *person;
@property (nonatomic,strong)NSString *phone;
//@property (nonatomic,assign)NSInteger deleted;
//@property (nonatomic,strong)NSString *createTime;
//@property (nonatomic,strong)NSString *updateTime;



@end
/**
 "id": 1,
 "communityId": 1,
 "department": "物业部",
 "deleted": 0,
 "createTime": "2020-11-24 16:50:33",
 "updateTime": "2020-11-24 16:50:33"
 
 ///////
 {
 "id": 1,
 "departmentId": 1,
 "person": "物业小强",
 "phone": "110",
 "deleted": 0,
 "createTime": "2020-11-24 16:50:33",
 "updateTime": "2020-11-24 16:50:33"
 },
 {
 "id": 2,
 "departmentId": 1,
 "person": "物业小王",
 "phone": "112",
 "deleted": 0,
 "createTime": "2020-11-24 16:50:33",
 "updateTime": "2020-11-24 16:50:33"
 }
 
 */
NS_ASSUME_NONNULL_END
