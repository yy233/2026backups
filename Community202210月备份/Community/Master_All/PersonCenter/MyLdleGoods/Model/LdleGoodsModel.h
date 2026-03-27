//
//  LdleGoodsModel.h
//  Community
//
//  Created by 余莹 on 2022/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LdleGoodsModel : NSObject
@property (nonatomic,strong) NSString *idStr;
@property (nonatomic,strong) NSString *categoryId;
@property (nonatomic,strong) NSString *categoryName;//类别名称
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *goodsExplain;//综合叙述
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,strong) NSString *userName;//用户昵称
@property (nonatomic,strong) NSString *avatarUrl;//头像
@property (nonatomic,strong) NSString *imagesUrl;//逗号分隔
@property (nonatomic,strong) NSString *labelId;
@property (nonatomic,strong) NSString *labelName;
@property (nonatomic,strong) NSString *mvUrl;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,assign) NSInteger state;//上下架 1上 0下
@property (nonatomic,assign) NSInteger shield;//是否被屏蔽或举报
@property (nonatomic,assign) double price;
@property (nonatomic,assign) NSInteger clickNumberSum;//浏览量总数
@property (nonatomic,assign) NSInteger clickNumber;//今日浏览量
@property (nonatomic,assign) BOOL isRealAuth;//是否实名 false没有 true实名
@property (nonatomic,assign) BOOL negotiable;//是否面议 1面议0 不



/**
 categoryId = 199585604256796672;
 categoryName = "手机";
 clickNumber = 0;
 clickNumberSum = 0;
 communityId = 1;
 consultingNumber = 0;
 createTime = "2022-06-21 14:58:10";
 goodsExplain = "刚买的新手机";
 goodsName = "oppo手机余莹4";
 id = 202542812816871424;
 idStr = 202542812816871424;
 imagesUrl = "图片地址1,图片地址2";
 labelId = 199588394148433920;
 labelName = "全新";
 mvUrl = "图片地址1";
 negotiable = 0;
 phone = 17784430795;
 price = 1999;
 shield = 0;
 state = 1;
 updateTime = "2022-06-21 14:58:09";
 userId = 57666;
 */

@end

NS_ASSUME_NONNULL_END
