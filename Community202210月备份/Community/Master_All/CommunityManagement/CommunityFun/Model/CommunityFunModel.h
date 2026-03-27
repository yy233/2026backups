//
//  CommunityFunModel.h
//  Community
//
//  Created by 余莹 on 2020/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommunityFunModel : NSObject
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger outTime;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *coverImageUrl;
@property (nonatomic,strong) NSString *smallImageUrl;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *titleName;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,assign) NSInteger viewCount;//

- (NSInteger)gettitleLabelShowHeight; 

/**
 
 total": 5,
     "list": [
       {
         "id": 2,
         "deleted": 0,
         "createTime": "2020-12-19 14:46:32",
         "updateTime": "2020-12-09 17:15:51",
         "titleName": "222",
         "content": "sdghnlsdhglsdjglskndhl",
         "smallImageUrl": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1608370427657&di=10aa8aee6fc8b45884997e1138cbabb9&imgtype=0&src=http%3A%2F%2Fimg2.biaoqingjia.com%2Fbiaoqing%2F201808%2F614d5fdb25e18ba7812b944c5da3a012_thumb.gif",
         "coverImageUrl": "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3064262594,4279381141&fm=26&gp=0.jpg",
         "status": 2,
         "startTime": "2020-12-09 17:15:51",
         "outTime": null
       },
 content
 coverImageUrl = "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3064262594,4279381141&fm=26&gp=0.jpg";
 createTime = "2020-12-19 14:46:32";
 deleted = 0;
 id = 2;
 outTime = "<null>";
 smallImageUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1608370427657&di=10aa8aee6fc8b45884997e1138cbabb9&imgtype=0&src=http%3A%2F%2Fimg2.biaoqingjia.com%2Fbiaoqing%2F201808%2F614d5fdb25e18ba7812b944c5da3a012_thumb.gif";
 startTime = "2020-12-09 17:15:51";
 status = 2;
 titleName = "史上最全的整合第三方登录的工具,目前已支持Github、Gitee、微博、钉钉、百度、Coding、腾讯云开发者平台、OSChina、支付宝、QQ、微信、淘宝、Google、Facebook、抖音、领英、小米、微软和今日头条等第三方平台的授权登录。 Login, so easy!JustAuth，如你所见，它仅仅是一个第三方授权登录的工具类库，它可以让我们脱离繁琐的第三方登录SDK，让登录变得So easy!项目开源地址：gitee | github特点废话不多说，就俩字：全：已集成十多家第三方平台（";
 updateTime = "2020-12-09 17:15:51";
};
 */
@end

NS_ASSUME_NONNULL_END
