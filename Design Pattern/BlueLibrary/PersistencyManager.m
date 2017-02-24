//
//  PersistencyManager.m
//  BlueLibrary
//
//  Created by Shaw on 16/12/23.
//  Copyright © 2016年 Eli Ganem. All rights reserved.
//

#import "PersistencyManager.h"

@implementation PersistencyManager {
    NSMutableArray *albums;
}

- (id)init
{
    self = [super init];
    if (self) {
        // a dummy list of albums
        albums = [NSMutableArray arrayWithArray:
                  @[[[Album alloc] initWithTitle:@"I" artist:@"Kim Taeyeon" coverUrl:@"http://i0.hdslb.com/video/7e/7e67ffd1204f15243070247d9b70e2fa.jpg" year:@"2015"],
                    [[Album alloc] initWithTitle:@"Mr.Mr" artist:@"Girls' Generation" coverUrl:@"http://imgx.xiawu.com/xzimg/i4/i1/T1LBPfFtFcXXXXXXXX_!!0-item_pic.jpg" year:@"2013"],
                    [[Album alloc] initWithTitle:@"Jay" artist:@"Jay Chou" coverUrl:@"http://static.statickksmg.com/image/2012/12/05/c8821b0c6e8eb603f9b49ad31347f280.jpg" year:@"2005"],
                    [[Album alloc] initWithTitle:@"Why" artist:@"Kim Taeyeon" coverUrl:@"http://imgs.aixifan.com/content/2016_07_04/1467652957.jpg" year:@"2016"],
                    [[Album alloc] initWithTitle:@"Jay Chou" artist:@"November's Chopin" coverUrl:@"http://image2.sina.com.cn/IT/cr/2005/1102/3639823433.jpg" year:@"2000"]]];
    }
    return self;
}

- (NSArray *)getAlbums {
    return albums;
}

- (void)addAlbum:(Album *)album atIndex:(int)index {
    if (index < albums.count) {
        [albums insertObject:album atIndex:index];
    } else {
        [albums addObject:album];
    }
}

- (void)deleteAlbumAtIndex:(int)index {
    [albums removeObjectAtIndex:index];
}

- (void)saveImage:(UIImage*)image filename:(NSString*)filename {
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:filename atomically:YES];
}

- (UIImage*)getImage:(NSString*)filename {
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSData *data = [NSData dataWithContentsOfFile:filename];
    return [UIImage imageWithData:data];
}




@end
