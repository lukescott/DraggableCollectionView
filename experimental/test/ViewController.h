//
//  ViewController.h
//  test
//
//  Created by Luke Scott on 9/14/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DraggableCollectionView;

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet DraggableCollectionView *collectionView;
@end
