//
//  FlickrPickerTVC.h
//  Shutterbug
//
//  Created by Shaw on 16/5/28.
//  Copyright © 2016年 XiaoLinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotosTVC : UITableViewController

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSMutableArray *afterFilteringPhotos;

@end
