//
//  JHImageScrollViewController.h
//  dajietiao
//
//  Created by 李嘉豪 on 16/7/14.
//  Copyright © 2016年 firstlink. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHImageScrollViewDelegate <NSObject>

@optional

- (void)imageScroll:(UIImage *)image ClickEdAtIndex:(NSInteger)index;

@end

@interface JHImageScrollViewController : UIViewController

@property (nonatomic, weak) id<JHImageScrollViewDelegate>delegate;

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) UIImage *placeholderImage;

- (instancetype)initWithCurrentController:(UIViewController *)viewcontroller viewFrame:(CGRect)frame;
- (void)setImageScollArray:(NSArray *)imageArray;

- (void)start;
- (void)stop;
@end
