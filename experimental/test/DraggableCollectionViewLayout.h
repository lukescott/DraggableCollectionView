//
//  DraggableCollectionViewLayout.h
//  test
//
//  Created by Luke Scott on 9/29/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DraggableCollectionViewPlaceholder;

@protocol DraggableCollectionViewLayout <NSObject>
@required

- (NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point;

@property (nonatomic) NSArray *hiddenItems;
@property (nonatomic) DraggableCollectionViewPlaceholder *placeholder;
@end
