//
//  ZYIssueActivityFileModel.h
//  Community
//
//  Created by ZY on 2021/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYIssueActivityFileModel : NSObject

// 文件下载url
@property (nonatomic, copy) NSString *url;

// 文件id
@property (nonatomic, copy) NSString *fuuid;

// 文件大小
@property (nonatomic, assign) NSInteger fsize;

// 文件名
@property (nonatomic, copy) NSString *fname;

// 文件类型
@property (nonatomic, copy) NSString *ftype;

// 文件md5
@property (nonatomic, copy) NSString *fmd5;

// 描述
@property (nonatomic, copy) NSString *remark;

@end

NS_ASSUME_NONNULL_END
