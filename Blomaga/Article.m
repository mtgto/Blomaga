//
//  Article.m
//  Blomaga
//
//  Created by mtgto on 1/26/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import "Article.h"

@interface Article()

@property (nonatomic, copy) NSString *articleId;

@property (nonatomic, copy) NSString *subject;

@property (nonatomic, copy) NSString *body;

@property (nonatomic, copy) NSString *blogId;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, copy) NSString *screenName;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSString *apiToken;

@property (nonatomic, copy) NSString *time;

@end

@implementation Article

- (id)initWithId:(NSString *)articleId subject:(NSString *)subject body:(NSString *)body blogId:(NSString *)blogId channelId:(NSString *)channelId screenName:(NSString *)screenName key:(NSString *)key apiToken:(NSString *)apiToken time:(NSString *)time
{
    self = [super init];
    if (self) {
        self.articleId = articleId;
        self.subject = subject;
        self.body = body;
        self.blogId = blogId;
        self.channelId = channelId;
        self.screenName = screenName;
        self.key = key;
        self.apiToken = apiToken;
        self.time = time;
    }
    return self;
}

@end
