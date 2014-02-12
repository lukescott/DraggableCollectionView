//
//  FlowLayoutRow.h
//  test
//
//  Created by Luke Scott on 9/21/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import "DraggableCollectionViewFlowLayout_Private.h"

@class DraggableFlowLayoutItem;

@interface DraggableFlowLayoutRow : NSObject

+ (id)rowInDirection:(FlowLayoutDirection)direction withDimension:(CGFloat)dimension itemSpacing:(CGFloat)spacing;

- (BOOL)canAddItem:(DraggableFlowLayoutItem *)item;
- (void)addItem:(DraggableFlowLayoutItem *)item;
- (void)computeLayout;

@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, assign) CGRect frame;
@end
