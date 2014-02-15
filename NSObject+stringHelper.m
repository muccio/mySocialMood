//
//  NSObject+stringHelper.m
//  mySocialMood
//
//  Created by muccio on 10/02/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import "NSObject+stringHelper.h"

@implementation NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding)));
}
@end
