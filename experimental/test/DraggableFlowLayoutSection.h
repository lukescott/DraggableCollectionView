//
//  FlowLayoutSection.h
//  test
//
//  Created by Luke Scott on 9/21/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import "DraggableCollectionViewFlowLayout_Private.h"

@class DraggableFlowLayoutRow;
@class DraggableFlowLayoutItem;

@interface DraggableFlowLayoutSection : NSObject  <NSCopying>

- (void)addItem:(DraggableFlowLayoutItem *)item;
- (void)insertItem:(DraggableFlowLayoutItem *)item atIndex:(NSUInteger)index;
- (void)computeLayout;

@property (nonatomic, readonly) NSArray *rows;
@property (nonatomic, readonly) NSArray *items;
@property (nonatomic) NSMutableIndexSet *hiddenItems;
@property (nonatomic) DraggableFlowLayoutItem *placeholderItem;
@property (nonatomic) FlowLayoutDirection direction;
@property (nonatomic) CGFloat dimension;
@property (nonatomic) NSUInteger index;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGRect frame;
@end
