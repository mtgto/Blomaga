//
//  AFSecureNicoAPIClient.h
//  Blomaga
//
//  Created by mtgto on 2/2/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFSecureNicoAPIClient : AFHTTPClient

+ (AFSecureNicoAPIClient *)sharedClient;

@end
