//
//  FlowLayoutItem.m
//  test
//
//  Created by Luke Scott on 9/21/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import "DraggableFlowLayoutItem.h"

@implementation DraggableFlowLayoutItem

+ (id)itemWithIndex:(NSUInteger)index size:(CGSize)size
{
    DraggableFlowLayoutItem *item = [self new];
    item.index = index;
    item.size = size;
    return item;
}

- (CGSize)size
{
    return _frame.size;
}

- (void)setSize:(CGSize)size
{
    _frame.size = size;
}

- (id)copyWithZone:(NSZone *)zone
{
    DraggableFlowLayoutItem *item = [[[self class] allocWithZone:zone] init];
    item.index = self.index;
    item.size = self.size;
    return item;
}

@end
