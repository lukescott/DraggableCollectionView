//
//  ViewController.m
//  test
//
//  Created by Luke Scott on 9/14/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import "ViewController.h"
#import "DraggableCollectionViewFlowLayout.h"

#import "DraggableCollectionViewPlaceholder.h"

#import "DraggableCollectionView.h"

#define NUMBER 100

@interface ViewController ()
{
    NSMutableArray *data;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    DraggableCollectionViewFlowLayout *layout = [[DraggableCollectionViewFlowLayout alloc] init];

    layout.footerReferenceSize = flowLayout.footerReferenceSize;
    layout.headerReferenceSize = flowLayout.headerReferenceSize;
    layout.itemSize = flowLayout.itemSize;
    layout.minimumInteritemSpacing = flowLayout.minimumInteritemSpacing;
    layout.minimumLineSpacing = flowLayout.minimumLineSpacing;
    layout.scrollDirection = flowLayout.scrollDirection;
    layout.sectionInset = flowLayout.sectionInset;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.draggable = YES;
//
//    NSLog(@"%@", [flowLayout performSelector:@selector(_rowAlignmentOptions) withObject:flowLayout]);
//    
    
//    0 = Left
//    1 = Center
//    2 = Right
//    3 = Justify
    
    //    0 = Top
    //    1 = Middle
    //    2 = Bottom
    
//    [flowLayout performSelector:@selector(_setRowAlignmentsOptions:)
//                     withObject:@{@"UIFlowLayoutCommonRowHorizontalAlignmentKey": @(0),
//                                  @"UIFlowLayoutLastRowHorizontalAlignmentKey": @(0),
//                                  @"UIFlowLayoutRowVerticalAlignmentKey": @(4)}];
    
    data = [[NSMutableArray alloc] initWithCapacity:NUMBER];
    for (int i = 0; i < NUMBER; ++i) {
        switch (i % 10) {
            case 0:
                [data addObject:@(1)];
                break;
            case 1:
                [data addObject:@(2)];
                break;
            default:
                [data addObject:@(0)];
                break;
        }
    }
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"%d", [self.collectionView indexPathForItemAtPoint:<#(CGPoint)#>])
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return NUMBER;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if ([[data objectAtIndex:indexPath.item] integerValue] == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoteCell" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ElementCell" forIndexPath:indexPath];
    }
    return cell;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"%@ %@", NSStringFromCGRect(self.collectionView.frame), NSStringFromCGRect(self.collectionView.bounds));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(DraggableCollectionViewFlowLayout *)flowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = flowLayout.itemSize;
    switch ([[data objectAtIndex:indexPath.item] integerValue]) {
        case 1:
            //size.width = collectionView.bounds.size.width;
            break;
        case 2:
            size.width *= 1.5;
            break;
        default:
            size.height += 20;
    }
    return size;
}

@end
