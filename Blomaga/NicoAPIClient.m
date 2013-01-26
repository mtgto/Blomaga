//
//  NicoAPIClient.m
//  Blomaga
//
//  Created by mtgto on 1/26/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import "NicoAPIClient.h"
#import "AFNicoAPIClient.h"

@interface NicoAPIClient()
@property (nonatomic, strong) AFNicoAPIClient *apiClient;
@end

@implementation NicoAPIClient

- (id)init
{
    self = [super init];
    if (self) {
        self.apiClient = [AFNicoAPIClient sharedClient];
    }
    return self;
}

- (void)getNewArticleSuccess:(void (^)(NicoAPIClient *client, NSDictionary *parameters))success failure:(void (^)(NicoAPIClient *client))failure
{
    [self.apiClient getPath:@"/tool/blomaga/edit"
                 parameters:nil
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        //DDLogVerbose(@"success: %@", responseObject);
                        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                        //DDLogVerbose(@"html = %@", html);
                        NSError *error = nil;
                        NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:@"<input type=\"hidden\" name=\"([^\"]+)\"\\s+value=\"([^\"]+)\">"
                                                                                             options:NSRegularExpressionCaseInsensitive
                                                                                               error:&error];
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [exp enumerateMatchesInString:html
                                              options:0
                                                range:NSMakeRange(0, [html length])
                                           usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
                         {
                             NSString *key = [html substringWithRange:[match rangeAtIndex:1]];
                             NSString *value = [html substringWithRange:[match rangeAtIndex:2]];
                             DDLogVerbose(@"key = %@, value = %@", key, value);
                             dict[key] = value;
                        }];
                        success(self, [NSDictionary dictionaryWithDictionary:dict]);
    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        DDLogVerbose(@"failure: %@", error);
                        failure(self);
    }];
}

- (void)sendArticle:(Article *)article success:(void (^)(NicoAPIClient *client))success failure:(void (^)(NicoAPIClient *client))failure
{
    NSDictionary *parameters = @{
    @"article_id": article.articleId,
    @"blog_id": article.blogId,
    @"channel_id": article.channelId,
    @"screen_name": article.screenName,
    @"key": article.key,
    @"scp_api_token": article.apiToken,
    @"time": article.time,
    @"mode": @"new",
    @"first_flag": @"0",
    @"draft_save_flag": @"1",
    @"edit_mailmag": @"",
    @"is_draft": @"0",
    @"is_hidden": @"0",
    @"disable_mailmag_flag": @"0",
    @"subject": article.subject,
    @"publish_date[date]": @"",
    @"publish_date[time]": @"",
    @"thumbnail": @"",
    @"delete_thumbnail_flag": @"",
    @"body_html": article.body
    };
    DDLogVerbose(@"sendArticle:%@", parameters);
    [self.apiClient postPath:@"/tool/blomaga/edit?mode=save"
                  parameters:parameters
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         DDLogVerbose(@"success: %@", responseObject);
                         NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                         DDLogVerbose(@"html = %@", html);
                         success(self);
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         DDLogVerbose(@"failure: %@", error);
                         failure(self);
                     }];
}

@end
