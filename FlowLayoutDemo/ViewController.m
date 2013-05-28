//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import "ViewController.h"
#import "Cell.h"

@interface ViewController ()
{
    NSMutableArray *data;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    data = [[NSMutableArray alloc] initWithCapacity:100];
    for(int i = 0; i < 100; i++) {
        [data addObject:@(i)];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = (Cell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSNumber *index = [data objectAtIndex:indexPath.item];
    cell.label.text = [NSString stringWithFormat:@"%d", index.integerValue];
    
    return cell;
}

- (BOOL)collectionView:(LSCollectionViewHelper *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(LSCollectionViewHelper *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSNumber *index = [data objectAtIndex:fromIndexPath.item];
    [data removeObjectAtIndex:fromIndexPath.item];
    [data insertObject:index atIndex:toIndexPath.item];
}

@end
