//
//  DraggableCollectionViewPlaceholder.h
//  test
//
//  Created by Luke Scott on 9/29/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DraggableCollectionViewPlaceholder : NSObject

+ (id)placeholderWithIndexPath:(NSIndexPath *)indexPath size:(CGSize)size;

@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) CGSize size;
@end
