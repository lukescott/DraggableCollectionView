//
//  DraggableCollectionView.m
//  test
//
//  Created by Luke Scott on 9/29/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import "DraggableCollectionView.h"
#import "DraggableCollectionViewHelper.h"
#import <objc/runtime.h>

@implementation DraggableCollectionView

- (DraggableCollectionViewHelper *)getHelper
{
    DraggableCollectionViewHelper *helper = objc_getAssociatedObject(self, "DraggableCollectionViewHelper");
    if(helper == nil) {
        helper = [[DraggableCollectionViewHelper alloc] initWithCollectionView:self];
        objc_setAssociatedObject(self, "DraggableCollectionViewHelper", helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return helper;
}

- (BOOL)draggable
{
    return [self getHelper].enabled;
}

- (void)setDraggable:(BOOL)draggable
{
    [self getHelper].enabled = draggable;
}

- (UIEdgeInsets)scrollingEdgeInsets
{
    return [self getHelper].scrollingEdgeInsets;
}

- (void)setScrollingEdgeInsets:(UIEdgeInsets)scrollingEdgeInsets
{
    [self getHelper].scrollingEdgeInsets = scrollingEdgeInsets;
}

- (CGFloat)scrollingSpeed
{
    return [self getHelper].scrollingSpeed;
}

- (void)setScrollingSpeed:(CGFloat)scrollingSpeed
{
    [self getHelper].scrollingSpeed = scrollingSpeed;
}

@end