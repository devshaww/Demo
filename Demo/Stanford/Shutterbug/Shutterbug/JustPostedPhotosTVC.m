//
//  JustPostedPhotosTVC.m
//  Shutterbug
//
//  Created by Shaw on 16/5/28.
//  Copyright © 2016年 XiaoLinyun. All rights reserved.
//

#import "JustPostedPhotosTVC.h"
#import "AFNetworking.h"

@interface JustPostedPhotosTVC ()

@end

@implementation JustPostedPhotosTVC

- (void)viewDidLoad {
    NSLog(@"JustPostedPhotosTVC viewDidLoad");
    [super viewDidLoad];
    [self fetchPhotos];
}

- (void)fetchPhotos {
    NSLog(@"fetchPhotos");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://api.500px.com/v1/photos?feature=popular" parameters:@{@"consumer_key":@"5lLqID5z9HMvwoOKMZapeKzS7ZyBUkdsIWrD6hJ6"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonResults = (NSDictionary *)responseObject;
        if (jsonResults != nil) {
            self.photos = (NSArray *)[jsonResults valueForKey:@"photos"];
            NSMutableArray *temp = [[NSMutableArray alloc]init];
            for (NSDictionary *photo in self.photos) {
                NSLog(@"%@",[photo valueForKey:@"nsfw"] ? @"true" : @"false");
                if ([photo valueForKey:@"nsfw"]) {
                    [temp addObject:photo];
                }
            }
            NSLog(@"%lu",temp.count);
            self.afterFilteringPhotos = [[NSMutableArray alloc]initWithArray:temp];
            NSLog(@"afterFiltering : %lu",(unsigned long)self.afterFilteringPhotos.count);
            NSLog(@"fetchPhotos : %lu",(unsigned long)self.photos.count);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"ERROR");
    }];
        
}


@end
