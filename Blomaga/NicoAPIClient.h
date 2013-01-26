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

- (void)getNewArticleSuccess:(void (^)(NicoAPIClient *client, NSDictionary *parameters))success failure:(void (^)(NicoAPIClient *client))failure;

- (void)sendArticle:(Article *)article success:(void (^)(NicoAPIClient *client))success failure:(void (^)(NicoAPIClient *client))failure;

@end
