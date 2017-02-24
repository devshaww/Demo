//
//  AlbumView.m
//  BlueLibrary
//
//  Created by Shaw on 16/12/23.
//  Copyright © 2016年 Eli Ganem. All rights reserved.
//

#import "AlbumView.h"

@implementation AlbumView {
    UIImageView *coverImage;
    UIActivityIndicatorView *indicator;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame albumCover:(NSString*)albumCover {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        // the coverImage has a 5 pixels margin from its frame
        coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        [coverImage addObserver:self forKeyPath:@"image" options:0 context:nil];  // KVO:观察自己的image对象是否已加载完，然后调整indicator
        coverImage.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:coverImage];
        
        indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = self.center;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator startAnimating];
        [self addSubview:indicator];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BLDownloadImageNotification"
                                                            object:self
                                                          userInfo:@{@"imageView":coverImage, @"coverUrl":albumCover}];
    }
    
    return self;
}

// KVO 必须实现的方法：才能知道一旦观察对象发生变化，要做什么事情。
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        [indicator stopAnimating];
    }
}

- (void)dealloc {
    [coverImage removeObserver:self forKeyPath:@"image"];
}

@end
