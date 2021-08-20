//
//  ImageViewController.m
//  Imaginarium-OC
//
//  Created by Shaw on 16/6/4.
//  Copyright © 2016年 XiaoLinyun. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIImage *image;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ImageViewController


- (void)setScrollView:(UIScrollView *)scrollView {
    NSLog(@"setScrollView");
    _scrollView = scrollView;
    // When prepareForSegue is called,with setImageURL called,and we go to setImage: and the scrollView outlet has not been set,then this line of code down here will do nothing to set contentSize,so we have to make sure we set it.
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.minimumZoomScale = 0.2;
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    NSLog(@"viewForZoomingInScrollView:");
    return self.imageView;
}

- (void)setImageURL:(NSURL *)imageURL {
    NSLog(@"setImageURL");
    _imageURL = imageURL;
    //    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
    [self startDownloadingImage];
}

- (void)startDownloadingImage {
    NSLog(@"start downloading Image");
    self.image = nil;
    NSURL *url = self.imageURL;
    if (url) {
        [self.spinner startAnimating];
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (url == self.imageURL) {
                    if (imageData != nil) {
                        self.image = [UIImage imageWithData:imageData];
                    } else {
                        self.image = nil;
                    }
                }
            });
        });
        
    }
    
}


- (UIImageView *)imageView {
    NSLog(@"getImageView");
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

// never use the instance variable of property image
// so there's no _image and we don't need @synthesize
- (UIImage *)image {
    NSLog(@"getImage");
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    NSLog(@"setImage");
    self.scrollView.zoomScale = 1.0;
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    // Anytime we change image we want to set contentSize
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    [self.spinner stopAnimating];
}

- (void)viewDidLoad {
    NSLog(@"ImageViewController viewDidLoad");
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}



@end
