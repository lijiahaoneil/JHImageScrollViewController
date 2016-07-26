//
//  JHImageScrollViewController.m
//  dajietiao
//
//  Created by 李嘉豪 on 16/7/14.
//  Copyright © 2016年 firstlink. All rights reserved.
//

#import "JHImageScrollViewController.h"

#import <UIImageView+WebCache.h>

#define ImageWidth self.view.frame.size.width
#define ImageHeight self.view.frame.size.height

@interface JHImageScrollViewController ()
<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL isStart;

@end

@implementation JHImageScrollViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (instancetype)initWithCurrentController:(UIViewController *)viewcontroller viewFrame:(CGRect)frame {
    if (self = [super init]) {
        [viewcontroller addChildViewController:self];
        self.timeInterval = 1.0;
        self.view.frame = frame;
        self.isStart = NO;
        
        [self.view addSubview:self.scrollView];
        [self.view addSubview:self.pageControl];
    }
    return self;
}

#pragma mark - Properties

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(ImageWidth * 2 / 3, ImageHeight - 30, ImageWidth / 3, 30)];
        _pageControl.numberOfPages = 0;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

#pragma mark - Timer

- (void)start {
    self.isStart = YES;
    [self startTimer];
}

- (void)stop {
    self.isStart = NO;
    [self stopTimer];
}

- (void)startTimer {
    if (self.isStart && self.timer == nil) {
        self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageIndex = scrollView.contentOffset.x / ImageWidth;
    
    // Trans to Index = 1 when Index = 0;
    if (scrollView.contentOffset.x > ImageWidth*(self.imageArray.count+1)) {
        [scrollView setContentOffset:CGPointMake(ImageWidth+scrollView.contentOffset.x-ImageWidth*(self.imageArray.count+1), 0) animated:NO];
        if (self.timer) {
            [self nextPage];
        }
    }
    // Trans to Index = all-1 when Index = all;
    if (scrollView.contentOffset.x < ImageWidth) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x+ImageWidth*self.imageArray.count, 0) animated:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = self.pageIndex;
    if (self.pageIndex == self.imageArray.count + 1) {
        index = 1;
    }
    self.pageControl.currentPage = index-1;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger index = self.pageIndex;
    if (self.pageIndex == self.imageArray.count + 1) {
        index = 1;
    }
    self.pageControl.currentPage = index-1;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

#pragma mark - Method

- (void)setImageScollArray:(NSArray *)imageArray {
    self.imageArray = imageArray;
    self.scrollView.contentSize = CGSizeMake(ImageWidth*(imageArray.count+2), 0);
    self.scrollView.contentOffset = CGPointMake(ImageWidth, 0);
    self.pageControl.numberOfPages = imageArray.count;
    self.pageIndex = 1;
    // Add ImageView to ScrollView
    for (NSInteger index = 0 ; index < imageArray.count + 2; ++index ) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * ImageWidth, 0, ImageWidth, ImageHeight)];
        imageView.userInteractionEnabled = YES;
        // Index for obj
        NSInteger arrayIndex = 0;
        if (index == 0) {
            arrayIndex = imageArray.count - 1;
            imageView.tag = 0;
        } else if (index == imageArray.count + 1) {
            arrayIndex = 0;
            imageView.tag = imageArray.count - 1;
        } else {
            arrayIndex = index - 1;
            imageView.tag = index - 1;
        }
        // URL or Image
        if ([imageArray[arrayIndex] isKindOfClass:[NSString class]]) {
            NSString *urlString = [imageArray objectAtIndex:arrayIndex];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:self.placeholderImage];
        } else if ([imageArray[arrayIndex] isKindOfClass:[NSURL class]]) {
            [imageView sd_setImageWithURL:imageArray[arrayIndex] placeholderImage:self.placeholderImage];
        } else if ([imageArray[arrayIndex] isKindOfClass:[UIImage class]]) {
            UIImage *image = [imageArray objectAtIndex:arrayIndex];
            imageView.image = image;
        }
        
        [self.scrollView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
        [imageView addGestureRecognizer:tap];
    }
}

- (void)nextPage {
    [self.scrollView setContentOffset:CGPointMake((self.pageIndex+1) * ImageWidth, 0) animated:YES];
}

- (void)clickImage:(UITapGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(imageScroll:ClickEdAtIndex:)]) {
        UIImageView *imageView = (UIImageView *)recognizer.view;
        [self.delegate imageScroll:imageView.image ClickEdAtIndex:[recognizer view].tag];
    }
}

@end
