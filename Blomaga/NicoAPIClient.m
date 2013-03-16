//
//  NicoAPIClient.m
//  Blomaga
//
//  Created by mtgto on 1/26/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import "NicoAPIClient.h"
#import "AFNicoAPIClient.h"
#import "AFSecureNicoAPIClient.h"
#import <AFNetworking/AFNetworking.h>

@interface NicoAPIClient()
@property (nonatomic, strong) AFNicoAPIClient *apiClient;
@property (nonatomic, strong) AFSecureNicoAPIClient *secureApiClient;
@end

@implementation NicoAPIClient

- (id)init
{
    self = [super init];
    if (self) {
        self.apiClient = [AFNicoAPIClient sharedClient];
        self.secureApiClient = [AFSecureNicoAPIClient sharedClient];
    }
    return self;
}

- (void)loginWithMail:(NSString *)mail
             password:(NSString *)password
              success:(void (^)(NicoAPIClient *client, NSURL *nextUrl, BOOL isPremium))success
              failure:(void (^)(NicoAPIClient *client))failure
{
    NSDictionary *parameters = @{@"next_url": @"/portal/blomaga?header",
                                 @"mail": mail,
                                 @"password": password};
    [self.secureApiClient postPath:@"/secure/login?site=channel"
                        parameters:parameters
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               NSInteger statusCode = operation.response.statusCode;
                               NSURL *nextUrl = operation.response.URL;
                               BOOL isPremium = [@"3" isEqualToString:operation.response.allHeaderFields[@"x-niconico-authflag"]];
                               DDLogVerbose(@"login success code = %d, nextUrl = %@, isPremium = %d", statusCode, nextUrl, isPremium);
                               success(self, nextUrl, isPremium);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(self);
    }];
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

- (void)sendImageData:(NSData *)imageData
            channelId:(NSString *)channelId
            articleId:(NSString *)articleId
                token:(NSString *)token
                 time:(NSString *)time
              success:(void (^)(NicoAPIClient *client, NSString *imageUrl))success
             progress:(void (^)(NicoAPIClient *client, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
              failure:(void (^)(NicoAPIClient *client))failure
{
    NSMutableURLRequest *request = [self.apiClient multipartFormRequestWithMethod:@"POST"
                                                                             path:@"/api/blomaga/upload.articleimage"
                                                                       parameters:nil
                                                        constructingBodyWithBlock: ^(id<AFMultipartFormData> formData) {
                                                            [formData appendPartWithFormData:[channelId dataUsingEncoding:NSUTF8StringEncoding] name:@"channel_id"];
                                                            [formData appendPartWithFormData:[articleId dataUsingEncoding:NSUTF8StringEncoding] name:@"article_id"];
                                                            [formData appendPartWithFormData:[token dataUsingEncoding:NSUTF8StringEncoding] name:@"csrf_token"];
                                                            [formData appendPartWithFormData:[time dataUsingEncoding:NSUTF8StringEncoding] name:@"csrf_token_time"];
                                                            [formData appendPartWithFileData:[NSData dataWithData:imageData] name:@"file" fileName:@"file_name" mimeType:@"application/octet-stream"];
                                                        }];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        DDLogVerbose(@"json = %@", JSON);
        NSDictionary *parameters = (NSDictionary *)JSON;
        success(self, parameters[@"src"]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        DDLogVerbose(@"failure: %@", error);
        failure(self);
    }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        progress(self, totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation start];
}

- (void)sendArticle:(Article *)article
            success:(void (^)(NicoAPIClient *client, NSURL *nextUrl))success
            failure:(void (^)(NicoAPIClient *client))failure;
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
                         NSInteger statusCode = operation.response.statusCode;
                         NSURL *nextUrl = operation.response.URL;
                         DDLogVerbose(@"code = %d, nextUrl = %@, html = %@", statusCode, nextUrl, html);
                         success(self, nextUrl);
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         DDLogVerbose(@"failure: %@", error);
                         failure(self);
                     }];
}

@end
