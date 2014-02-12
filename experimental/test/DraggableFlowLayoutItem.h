//
//  FlowLayoutItem.h
//  test
//
//  Created by Luke Scott on 9/21/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DraggableFlowLayoutRow;

@interface DraggableFlowLayoutItem : NSObject  <NSCopying>

+ (id)itemWithIndex:(NSUInteger)index size:(CGSize)size;

@property (nonatomic) NSUInteger index;
@property (nonatomic) NSUInteger vindex;
@property (nonatomic) CGSize size;
@property (nonatomic) CGRect frame;
@property (nonatomic) DraggableFlowLayoutRow *row;
@end
