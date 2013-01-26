//
//  AFNicoAPIClient.h
//  Blomaga
//
//  Created by mtgto on 1/26/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFNicoAPIClient : AFHTTPClient

+ (AFNicoAPIClient*)sharedClient;

@end
