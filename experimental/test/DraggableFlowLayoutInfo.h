//
//  FlowLayoutInfo.h
//  test
//
//  Created by Luke Scott on 9/22/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import "DraggableCollectionViewFlowLayout_Private.h"

@class DraggableFlowLayoutSection;

@interface DraggableFlowLayoutInfo : NSObject <NSCopying>

- (void)addSection:(DraggableFlowLayoutSection *)section;
- (void)computeLayout;

@property (nonatomic, readonly) NSArray *sections;
@property (nonatomic, assign) CGFloat dimension;
@property (nonatomic, assign) FlowLayoutDirection direction;
@property (nonatomic, readonly) CGSize contentSize;
@end
