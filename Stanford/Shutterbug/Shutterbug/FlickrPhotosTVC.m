//
//  FlickrPickerTVC.m
//  Shutterbug
//
//  Created by Shaw on 16/5/28.
//  Copyright © 2016年 XiaoLinyun. All rights reserved.
//

#import "FlickrPhotosTVC.h"
#import "ImageViewController.h"

@interface FlickrPhotosTVC ()

@end

@implementation FlickrPhotosTVC


- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
}

- (void)setAfterFilteringPhotos:(NSMutableArray *)afterFilteringPhotos {
    _afterFilteringPhotos = afterFilteringPhotos;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.afterFilteringPhotos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath:");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *photo = self.afterFilteringPhotos[indexPath.row];
    cell.textLabel.text = [photo valueForKey:@"name"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    cell.detailTextLabel.text = [formatter stringFromNumber:[photo valueForKey:@"user_id"]];
//    cell.detailTextLabel.text = [photo valueForKey:@"created_at"];
    return cell;
}


//    code right down here only called on iPad.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id detail = self.splitViewController.viewControllers[1];
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
        if ([detail isKindOfClass:[ImageViewController class]]) {
            [self prepareForImageViewController:detail toDisplayPhoto:self.afterFilteringPhotos[indexPath.row]];
        }
    }

}

- (void)prepareForImageViewController:(ImageViewController *)ivc toDisplayPhoto:(NSDictionary *)photo {
    NSLog(@"prepareForImageViewController");
    ivc.imageURL = [NSURL URLWithString:[photo valueForKey:@"image_url"]];
    NSLog(@"%@",ivc.imageURL);
    ivc.title = [photo valueForKey:@"name"];
    NSLog(@"%@",ivc.title);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue");
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSLog(@"indexPath = %ld",(long)indexPath.row);
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"display photo"] ) {
                if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *destination = (UINavigationController *)(segue.destinationViewController);
                    if ([[destination.viewControllers firstObject] isKindOfClass:[ImageViewController class]]) {
                        [self prepareForImageViewController:(ImageViewController *)[destination.viewControllers firstObject] toDisplayPhoto:self.afterFilteringPhotos[indexPath.row]];
                    }

                }
            }
        }
    }
    NSLog(@"end of prepareForSegue");
    
}


@end
