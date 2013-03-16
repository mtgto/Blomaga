//
//  NicoAPIClient.h
//  Blomaga
//
//  Created by mtgto on 1/26/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

@interface NicoAPIClient : NSObject

- (void)loginWithMail:(NSString *)mail
             password:(NSString *)password
              success:(void (^)(NicoAPIClient *client, NSURL *nextUrl, BOOL isPremium))success
              failure:(void (^)(NicoAPIClient *client))failure;

- (void)getNewArticleSuccess:(void (^)(NicoAPIClient *client, NSDictionary *parameters))success failure:(void (^)(NicoAPIClient *client))failure;

- (void)sendImageData:(NSData *)imageData
            channelId:(NSString *)channelId
            articleId:(NSString *)articleId
                token:(NSString *)token
                 time:(NSString *)time
              success:(void (^)(NicoAPIClient *client, NSString *imageUrl))success
             progress:(void (^)(NicoAPIClient *client, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
              failure:(void (^)(NicoAPIClient *client))failure;

- (void)sendArticle:(Article *)article
            success:(void (^)(NicoAPIClient *client, NSURL *nextUrl))success
            failure:(void (^)(NicoAPIClient *client))failure;

@end
