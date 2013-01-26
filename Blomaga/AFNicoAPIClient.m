//
//  AFNicoAPIClient.m
//  Blomaga
//
//  Created by mtgto on 1/26/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import "AFNicoAPIClient.h"

@implementation AFNicoAPIClient

+ (AFNicoAPIClient*)sharedClient
{
    static AFNicoAPIClient *client;
    static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        client = [[AFNicoAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://ch.nicovideo.jp"]];
    });
    return client;
}

- (id)initWithBaseURL:(NSURL*)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self setDefaultHeader:@"User-Agent" value:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.52 Safari/537.17"];
        self.parameterEncoding = AFFormURLParameterEncoding;
    }
    return self;
}

@end
