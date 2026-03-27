//
//  TopOrUregentInfoDetailModel.h
//  Community
//
//  Created by 余莹 on 2020/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopOrUregentInfoDetailModel : NSObject
@property (nonatomic,assign) NSInteger browseCount;
@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger enabled;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger initialQuery;
@property (nonatomic,assign) NSInteger read;
@property (nonatomic,assign) NSInteger state;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *updateTime;
//@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *subTitle;
@property (nonatomic,strong) NSString *createTime;
//@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *pushMsg;
@property (nonatomic,strong) NSString *pushTitle;

/** 2021 0114
 code = 0;
 data =     {
     browseCount = 0;
     createTime = "2021-01-08 10:34:23";
     pushMsg = "刚刚，美国有线电视新闻网（CNN）、美国全国广播公司(NBC)、英国广播公司（BBC）等多家外媒先后发布预测，民主党总统候选人拜登当选。";
     pushTitle = "美国国会确认拜登赢得美国大选";
 };
 message = "<null>";
}
 */

//
- (NSInteger)gettitleLabelShowHeight;
/**
 "data": {
       "id": null,
       "deleted": null,
       "createTime": "2020-11-18 09:41:04",
       "updateTime": null,
       "uid": null,
       "communityId": null,
       "state": 1,
       "title": "美国总统第三顺位继任者感染新冠",
       "subTitle": null,
       "content": "尊敬的社区居民，你们好！当地时间17日，美国参议院临时议长、87岁的格拉斯利宣布自己的新冠检测结果呈阳性",
       "enabled": null,
       "browseCount": 27,
       "initialQuery": false,
       "read": false
   }
 a =     {
     browseCount = 14;
     communityId = "<null>";
     content = "在上海闵行区颛桥 ";
     createTime = "2020-11-19 14:35:18";
     deleted = "<null>";
     enabled = "<null>";
     id = "<null>";
     initialQuery = 0;
     read = 0;
     state = 2;
     subTitle = "<null>";
     title = "上海一 ";
     uid = "<null>";
     updateTime = "<null>";*/
@end

NS_ASSUME_NONNULL_END
