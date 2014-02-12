//
//  FlowLayoutSection.m
//  test
//
//  Created by Luke Scott on 9/21/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import "DraggableFlowLayoutSection.h"
#import "DraggableFlowLayoutRow.h"
#import "DraggableFlowLayoutItem.h"


@interface DraggableFlowLayoutSection ()
{
    NSMutableArray *_rows;
    NSMutableArray *_items;
}
@property (nonatomic) NSMutableArray *rows;
@property (nonatomic) NSMutableArray *items;
@end

@implementation DraggableFlowLayoutSection

- (id)init
{
    self = [super init];
    if (self) {
        _rows = [NSMutableArray new];
        _items = [NSMutableArray new];
        _hiddenItems = [NSMutableIndexSet new];
    }
    return self;
}

- (void)addItem:(DraggableFlowLayoutItem *)item
{
    [_items addObject:item];
}

- (void)insertItem:(DraggableFlowLayoutItem *)item atIndex:(NSUInteger)index
{
    [_items insertObject:item atIndex:index];
}

- (void)computeLayout
{
    FlowLayoutDirection direction = self.direction;
    CGFloat dimension = self.dimension;
    CGFloat itemSpacing = self.minimumInteritemSpacing;
    CGFloat lineSpacing = self.minimumLineSpacing;
    CGFloat offset = 0;
    NSIndexSet *hiddenItems = [self.hiddenItems copy];
    DraggableFlowLayoutItem *placeholderItem = self.placeholderItem;
    if (placeholderItem != nil) {
        [_items insertObject:placeholderItem atIndex:placeholderItem.index];
    }
    DraggableFlowLayoutRow *row;
    for (DraggableFlowLayoutItem *item in _items) {
        BOOL isPlaceholder = (item == placeholderItem);
        if (!isPlaceholder && [hiddenItems containsIndex:item.index]) {
            continue;
        }
        if(! [row canAddItem:item]) {
            if (row != nil) {
                [row computeLayout];
                CGRect rowFrame = row.frame;
                if (direction == FlowLayoutDirectionVertical) {
                    rowFrame.origin.y += offset;
                    offset += rowFrame.size.height;
                } else {
                    rowFrame.origin.x += offset;
                    offset += rowFrame.size.width;
                }
                offset += lineSpacing;
                row.frame = rowFrame;
                [_rows addObject:row];
            }
            row = [DraggableFlowLayoutRow rowInDirection:direction withDimension:dimension itemSpacing:itemSpacing];
        }
        [row addItem:item];
        item.row = row;
    }
    if (placeholderItem != nil) {
        [_items removeObjectAtIndex:placeholderItem.index];
    }
    if (direction == FlowLayoutDirectionVertical) {
        self.frame = (CGRect){CGPointZero, dimension, offset};
    } else {
        self.frame = (CGRect){CGPointZero, offset, dimension};
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    DraggableFlowLayoutSection *section = [[[self class] allocWithZone:zone] init];
    section.dimension = self.dimension;
    section.direction = self.direction;
    section.index = self.index;
    section.minimumInteritemSpacing = self.minimumInteritemSpacing;
    section.minimumLineSpacing = self.minimumLineSpacing;
    section.frame = self.frame;
    section.items = [[NSMutableArray alloc] initWithArray:_items copyItems:YES];
    section.rows = [[NSMutableArray allocWithZone:zone] init];
    return section;
}

@end
