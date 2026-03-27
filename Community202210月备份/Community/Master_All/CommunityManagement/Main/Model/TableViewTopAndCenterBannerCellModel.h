//
//  TableViewTopCellModel.h
//  Community
//
//  Created by 余莹 on 2020/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewTopAndCenterBannerCellModel : NSObject
 
//顶部左右轮播图的model
@property (nonatomic,strong) NSString *url;
@property (nonatomic,assign) NSInteger position;
@property (nonatomic,assign) NSInteger sort;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,strong) NSString *idStr;
@property (nonatomic,strong) NSString *desc;


//中间上下轮播文本的model
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,strong) NSString *deleted;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,assign) NSInteger state;
//@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,assign) NSInteger enabled;
@property (nonatomic,assign) BOOL initialQuery;
@property (nonatomic,strong) NSString *reserver01;
@property (nonatomic,assign) NSInteger browseCount;//已读数量
//@property (nonatomic,strong) NSString *subTitle;//副标题

//20210114更改新的键
@property (nonatomic,strong) NSString *pushTitle;
@property (nonatomic,strong) NSString *pushSubTitle;
@property (nonatomic,assign) NSInteger acctId;


/**
 {
acctId = 1;
createTime = "2021-01-07 13:31:30";
id = 10453933646548993;
pushSubTitle = "尊敬的社区居民，你们好！11月17日，美国空军两架B-1B轰炸机被曝出从关岛安德森基地出发，飞行至东海海域上空。";
pushTitle = "美军两架轰炸机被曝现身东海上空";
},
 {
 */

/**
 "id": 1,
       "url": "http://3gimg.qq.com/map_openplat/lbs_web/custom_map_templates/custom_map_template_2.png",
       "description": "描述",//将改字段
       "sort": 1,
       "position": 1
 {
       "id": 10,
       "deleted": 0,
       "createTime": "2020-11-17 15:21:24",
       "updateTime": null,
       "communityId": 1,
       "state": 1,
       "title": "社区居民免费体检通知",
       "content": "社区居民免费体检通知尊敬的长乐社区居民您们好：为了更好的服务社区居民，我社区服务站将为本社区居民提供免费健康体检，现将体检安排如下：",
       "enabled": 1,
       "initialQuery": false,
       "reserver01": null
     },*/
/**
 browseCount = "<null>";
 communityId = 1;
 content = "<null>";
 createTime = "2020-11-19 14:22:19";
 deleted = "<null>";
 enabled = "<null>";
 id = 72;
 initialQuery = 0;
 read = 0;
 state = 0;
 subTitle = "这里会写一些副标题的内容文本，以解释上面简短的标题";
 title = "关于网传汉兴街和祥里社区发现阳性无症状感染者的紧急通告";
 uid = "<null>";
 updateTime = "<null>";*/
@end

NS_ASSUME_NONNULL_END
