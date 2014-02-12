//
//  DraggableCollectionViewPlaceholder.m
//  test
//
//  Created by Luke Scott on 9/29/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import "DraggableCollectionViewPlaceholder.h"

@implementation DraggableCollectionViewPlaceholder

+ (id)placeholderWithIndexPath:(NSIndexPath *)indexPath size:(CGSize)size
{
    return [[self alloc] initWithIndexPath:indexPath size:size];
}

- (id)initWithIndexPath:(NSIndexPath *)indexPath size:(CGSize)size
{
    self = [super init];
    if (self) {
        _indexPath = indexPath;
        _size = size;
    }
    return self;
}

@end
