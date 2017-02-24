//
//  HorizontalScrollerDelegate.m
//  BlueLibrary
//
//  Created by Shaw on 16/12/23.
//  Copyright © 2016年 Eli Ganem. All rights reserved.
//

#import "HorizontalScroller.h"

static const int VIEW_PADDING = 10;
static const int VIEW_DIMENSIONS = 100;
static const int VIEWS_OFFSET = 10;

@interface HorizontalScroller () <UIScrollViewDelegate>

@end

@implementation HorizontalScroller {
    UIScrollView *scroller;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroller.delegate = self;
        [self addSubview:scroller];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapped:)];
        [scroller addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)reload {
    // 1 - nothing to load if there's no delegate
    if (self.delegate == nil) return;
    
    // 2 - remove all subviews
    [scroller.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    // 3 - xValue is the starting point of the views inside the scroller
    CGFloat xValue = VIEWS_OFFSET;
    for (int i=0; i<[self.delegate numberOfViewsForHorizontalScroller:self]; i++) {
        // 4 - add a view at the right position
        xValue += VIEW_PADDING;
        UIView *view = [self.delegate horizontalScroller:self viewAtIndex:i];
        view.frame = CGRectMake(xValue, VIEW_PADDING, VIEW_DIMENSIONS, VIEW_DIMENSIONS);
        [scroller addSubview:view];
        xValue += VIEW_DIMENSIONS + VIEW_PADDING;
    }
    
    // 5
    [scroller setContentSize:CGSizeMake(xValue + VIEWS_OFFSET, self.frame.size.height)];
    
    // 6 - if an initial view is defined, center the scroller on it
    if ([self.delegate respondsToSelector:@selector(initialViewIndexForHorizontalScroller:)]) {
        int initialView = [self.delegate initialViewIndexForHorizontalScroller:self];
        [scroller setContentOffset:CGPointMake(initialView * (VIEW_DIMENSIONS + (2 * VIEW_PADDING)), 0) animated:YES];
    }
    
}

- (void)scrollerTapped:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:recognizer.view];
    // we can't use an enumerator here, because we don't want to enumerate over ALL of the UIScrollView subviews.
    // we want to enumerate only the subviews that we added
    for (int index=0; index<[self.delegate numberOfViewsForHorizontalScroller:self]; index++) {
        UIView *view = scroller.subviews[index];
        if (CGRectContainsPoint(view.frame, location)) {
            [self.delegate horizontalScroller:self clickedViewAtIndex:index];
            [scroller setContentOffset:CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0) animated:YES];
            break;
        }
    }
}

- (void)centerAView: (UIView *)view {
    [scroller setContentOffset:CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0) animated:YES];
}

- (void)didMoveToSuperview {
    [self reload];
}

/* 根据当前要居中的view的index来设置contentOffset
    int xFinal = scroller.contentOffset.x + (VIEW_DIMENSIONS + VIEW_PADDING) / 2;
    int viewIndexToBeCentered = xFinal / (VIEW_DIMENSIONS + VIEW_PADDING);
    // 后面加的这个1跟滚动屏最多能看到的view的个数相关，如果此数为偶数，是不可能有某个view可以居中的
    // 假设为5时，后面这个数应该变为2；为7，应变为3...
    UIView *view = scroller.subviews[index];
    [scroller setContentOffset: CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0) animated: YES];
 */
- (void)centerCurrentView {
    int xFinal = scroller.contentOffset.x + (VIEW_DIMENSIONS + VIEW_PADDING) / 2;
    int viewIndexToBeCentered = xFinal / (VIEW_DIMENSIONS + VIEW_PADDING);
    UIView *view = scroller.subviews[viewIndexToBeCentered];
    [self centerAView:view];
    // int xFinal = scroller.contentOffset.x + (VIEWS_OFFSET/2) + VIEW_PADDING;
    // int viewIndex = xFinal / (VIEW_DIMENSIONS+(2*VIEW_PADDING));
    // xFinal = viewIndex * (VIEW_DIMENSIONS+(2*VIEW_PADDING));
    // [scroller setContentOffset:CGPointMake(xFinal,0) animated:YES];
    [self.delegate horizontalScroller:self clickedViewAtIndex:viewIndexToBeCentered];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self centerCurrentView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self centerCurrentView];
}

@end
