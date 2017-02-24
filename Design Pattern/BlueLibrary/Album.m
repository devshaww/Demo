//
//  Album.m
//  BlueLibrary
//
//  Created by Shaw on 16/12/23.
//  Copyright © 2016年 Eli Ganem. All rights reserved.
//

#import "Album.h"

@implementation Album

- (id)initWithTitle:(NSString*)title artist:(NSString*)artist coverUrl:(NSString*)coverUrl year:(NSString*)year {
    if (self = [super init]) {
        _title = title;
        _artist = artist;
        _genre = @"Pop";
        _coverUrl = coverUrl;
        _year = year;
    }
    return self;
}

@end
