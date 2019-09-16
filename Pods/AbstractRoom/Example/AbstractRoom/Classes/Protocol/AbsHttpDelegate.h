//
//  AbsHttpDelegate.h
//  AbstractRoom
//
//  Created by David on 2019/9/11.
//  Copyright © 2019年 351723770@qq.com. All rights reserved.
//

#ifndef AbsHttpDelegate_h
#define AbsHttpDelegate_h

@protocol AbsHttpDelegate <NSObject>

- (void)httpGet:(NSString *)urlString params:(NSDictionary *)params completionHandler:(void(^)(BOOL success, NSDictionary *respInfo, NSDictionary *errorInfo))completionHandler;
- (void)httpPost:(NSString *)urlString params:(NSDictionary *)params completionHandler:(void(^)(BOOL success, NSDictionary *respInfo, NSDictionary *errorInfo))completionHandler;
- (void)httDownload:(NSString *)urlString params:(NSDictionary *)params progressHandler:(void(^)(float progress))progressHandler completionHandler:(void(^)(BOOL success, NSDictionary *respInfo, id respData, NSDictionary *errorInfo))completionHandler;

@optional
- (void)httpSetBaseUrlString:(NSString *)key;
- (void)httpAddCachePolicyFilterKey:(NSString *)key;

@end



#endif /* AbsHttpDelegate_h */
