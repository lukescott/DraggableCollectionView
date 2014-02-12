//
//  FlowLayoutInfo.m
//  test
//
//  Created by Luke Scott on 9/22/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import "DraggableFlowLayoutInfo.h"
#import "DraggableFlowLayoutSection.h"

@interface DraggableFlowLayoutInfo ()
{
    NSMutableArray *_sections;
}
@property (nonatomic) NSMutableArray *sections;
@property (nonatomic, assign) CGSize contentSize;
@end

@implementation DraggableFlowLayoutInfo

- (id)init
{
    self = [super init];
    if (self) {
        _sections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addSection:(DraggableFlowLayoutSection *)section
{
    [_sections addObject:section];
}

- (void)computeLayout
{
    FlowLayoutDirection direction = self.direction;
    CGFloat dimension = self.dimension;
    CGFloat offset = 0;
    NSUInteger sectionIndex = 0;
    for (DraggableFlowLayoutSection *section in _sections) {
        section.direction = direction;
        section.dimension = dimension;
        [section computeLayout];
        CGRect sectionFrame = section.frame;
        if (direction == FlowLayoutDirectionVertical) {
            sectionFrame.origin.y += offset;
            offset += sectionFrame.size.height;
        } else {
            sectionFrame.origin.x += offset;
            offset += sectionFrame.size.width;
        }
        section.frame = sectionFrame;
        section.index = sectionIndex;
        ++sectionIndex;
    }
    if (direction == FlowLayoutDirectionVertical) {
        self.contentSize = (CGSize){dimension, offset};
    } else {
        self.contentSize = (CGSize){offset, dimension};
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    DraggableFlowLayoutInfo *layoutInfo = [[[self class] allocWithZone:zone] init];
    layoutInfo.dimension = self.dimension;
    layoutInfo.direction = self.direction;
    layoutInfo.contentSize = self.contentSize;
    layoutInfo.sections = [[NSMutableArray alloc] initWithArray:_sections copyItems:YES];
    return layoutInfo;
}

@end
