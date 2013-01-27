//
//  Article.h
//  Blomaga
//
//  Created by mtgto on 1/26/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic, copy, readonly) NSString *articleId;

@property (nonatomic, copy, readonly) NSString *subject;

@property (nonatomic, copy, readonly) NSString *body;

@property (nonatomic, strong, readonly) NSString *image;

@property (nonatomic, copy, readonly) NSString *blogId;

@property (nonatomic, copy, readonly) NSString *channelId;

@property (nonatomic, copy, readonly) NSString *screenName;

@property (nonatomic, copy, readonly) NSString *key;

@property (nonatomic, copy, readonly) NSString *apiToken;

@property (nonatomic, copy, readonly) NSString *time;

/**
 * Init an article which has subject, body and it's params.
 */
- (id)initWithId:(NSString *)articleId
         subject:(NSString *)subject
            body:(NSString *)body
          blogId:(NSString *)blogId
       channelId:(NSString *)channelId
      screenName:(NSString *)screenName
             key:(NSString *)key
        apiToken:(NSString *)apiToken
            time:(NSString *)time;

@end
