//
//  ViewController.m
//  CoreDataPersistentStoreMergeTest
//
//  Created by Daniel Tull on 28/03/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import <DCTDataSource/DCTDataSource.h>
#import "CDPSMTViewController.h"
#import "Event.h"

@interface CDPSMTViewController ()
@property (nonatomic) DCTTableViewDataSource *dataSource;
@end

@implementation CDPSMTViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[Event entityName]];
	fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:EventAttributes.date ascending:NO]];

	NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		  managedObjectContext:self.managedObjectContext
																			sectionNameKeyPath:nil
																					 cacheName:nil];

	DCTFetchedResultsDataSource *dataSource = [[DCTFetchedResultsDataSource alloc] initWithFetchedResultsController:frc];
	self.dataSource = [[DCTTableViewDataSource alloc] initWithTableView:self.tableView dataSource:dataSource];
	self.dataSource.cellReuseIdentifier = @"cell";
}

#pragma - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	Event *event = [self.dataSource objectAtIndexPath:indexPath];
	cell.textLabel.text = [event.date description];
}

@end
