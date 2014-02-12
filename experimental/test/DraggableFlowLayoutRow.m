//
//  FlowLayoutRow.m
//  test
//
//  Created by Luke Scott on 9/21/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import "DraggableFlowLayoutRow.h"
#import "DraggableFlowLayoutItem.h"

@interface DraggableFlowLayoutRow ()
{
    NSMutableArray *_items;
    FlowLayoutDirection _direction;
    CGFloat _dimension;
    CGFloat _remaining;
    CGFloat _space;
    CGFloat _spacing;
    CGFloat _size;
}
@end

@implementation DraggableFlowLayoutRow

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Do not use -init, use +rowInDirection:withDimension:itemSpacing:"
                                 userInfo:nil];
}

+ (id)rowInDirection:(FlowLayoutDirection)direction withDimension:(CGFloat)dimension itemSpacing:(CGFloat)spacing
{
    return [[self alloc] initInDirection:direction withDimension:dimension itemSpacing:spacing];
}

- (id)initInDirection:(FlowLayoutDirection)direction withDimension:(CGFloat)dimension itemSpacing:(CGFloat)spacing
{
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
        _direction = direction;
        _dimension = dimension;
        _remaining = dimension;
        _space = dimension;
        _spacing = spacing;
    }
    return self;
}

- (BOOL)canAddItem:(DraggableFlowLayoutItem *)item
{
    CGFloat remaining = _remaining;
    if (_direction == FlowLayoutDirectionVertical) {
        remaining -= item.size.width;
    } else {
        remaining -= item.size.height;
    }
    return remaining >= 0;
}

- (void)addItem:(DraggableFlowLayoutItem *)item
{
    CGFloat width;
    CGFloat height;
    if (_direction == FlowLayoutDirectionVertical) {
        width = item.size.width;
        height = item.size.height;
    } else {
        width = item.size.height;
        height = item.size.width;
    }
    _remaining -= (width + _spacing);
    _space -= width;
    _size = MAX(_size, height);
    [_items addObject:item];
}

- (void)computeLayout
{
    NSInteger count = _items.count;
    if (count < 1) {
        return;
    }
    CGFloat offset = 0;
    CGFloat spacing = _spacing;
    
    spacing = MAX(spacing, _space / (count - 1)); // Equal spacing
    
    for (DraggableFlowLayoutItem *item in _items) {
        CGRect itemFrame = (CGRect){CGPointZero, item.frame.size};
        if (_direction == FlowLayoutDirectionVertical) {
            itemFrame.origin.x = offset;
            offset += itemFrame.size.width;
        } else {
            itemFrame.origin.y = offset;
            offset += itemFrame.size.height;
        }
        //NSLog(@"a: %@", NSStringFromCGRect(itemFrame));
        //itemFrame = CGRectIntegral(itemFrame);
        //NSLog(@"b: %@", NSStringFromCGRect(itemFrame));
        offset += spacing;
        item.frame = itemFrame;
    }
    if (_direction == FlowLayoutDirectionVertical) {
        self.frame = (CGRect){CGPointZero, _dimension, _size};
    } else {
        self.frame = (CGRect){CGPointZero, _size, _dimension};
    }
}

@end
