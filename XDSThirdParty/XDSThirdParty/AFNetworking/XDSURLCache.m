//
//  XDSURLCache.m
//  XDSThirdParty
//
//  Created by Hmily on 2017/3/2.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "XDSURLCache.h"

@implementation XDSURLCache

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request{
    NSLog(@"%@", request.URL.absoluteString);
    NSLog(@"======== %@", [[NSString alloc] initWithData:cachedResponse.data encoding:NSUTF8StringEncoding]);

}

@end
