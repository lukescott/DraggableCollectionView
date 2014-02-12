//
//  FlowLayout.h
//  test
//
//  Created by Luke Scott on 9/21/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DraggableCollectionViewLayout.h"

@class DraggableCollectionViewPlaceholder;

@interface DraggableCollectionViewFlowLayout : UICollectionViewLayout <DraggableCollectionViewLayout>

- (NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point;

// UICollectionViewFlowLayout
@property (nonatomic) CGSize footerReferenceSize;
@property (nonatomic) CGSize headerReferenceSize;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic) UIEdgeInsets sectionInset;

// DraggableCollectionViewLayout
@property (nonatomic) NSArray *hiddenItems;
@property (nonatomic) DraggableCollectionViewPlaceholder *placeholder;
@end
