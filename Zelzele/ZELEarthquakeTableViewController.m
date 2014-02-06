//
//  ZELEarthquakeTableViewController.m
//
//
//  Created by Ayberk Tosun on 6/2/14.
//
//

#import <MapKit/MapKit.h>
#import "ZELEarthquakeTableViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "ZELEarthquakeViewCell.h"

#define API_URL @"http://www.kimonolabs.com/api/de82dvke?apikey=***REMOVED***"

@interface ZELEarthquakeTableViewController ()

@end

@implementation ZELEarthquakeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UINib *nib = [UINib nibWithNibName:@"ZELEarthquakeViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    [self setTitle:@"Earthquakes"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_URL]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        self.earthquakesDict = responseObject;
        NSLog(@"Count: %d", [responseObject[@"results"][@"collection1"] count]);
        [self.tableView reloadData];
    } failure:nil];
    
    NSLog(@"Operation started.");
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_earthquakesDict[@"results"][@"collection1"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ZELEarthquakeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ZELEarthquakeViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    NSString *provinceName = [_earthquakesDict[@"results"]
                              [@"collection1"]
                              [indexPath.row][@"province"] description];
    if ([provinceName isEqualToString:@"-"]) {
        provinceName = @"Unkown Province";
    }
    
    NSString *dateString = [_earthquakesDict[@"results"][@"collection1"]
                            [indexPath.row][@"date"][@"text"] description];
    
    [[cell titleLabel] setText:provinceName];
    
    NSString *magnitudeString = _earthquakesDict[@"results"][@"collection1"]
     [indexPath.row][@"magnitude"];
    
    float magnitude = [magnitudeString floatValue];
    float colorRatio = magnitude/4.5;
    // An earthquake greater than 4.5 is a rare ocurrence
    // so whenever that happens set the color to red.
    // Otherwise 4.5 is a fine limit to have varying color spectrum.
    if (magnitude > 4.5) {
        colorRatio = 1.0;
    }
    
    UIColor *customColor = [UIColor
                            colorWithHue:colorRatio
                            saturation:1.0
                            brightness:1.0
                            alpha:1.0];
    
    if (magnitude <= 3.0) {
        [cell.magnitudeLabel setBackgroundColor:customColor];
    } else if (magnitude <= 5.0) {
        [cell.magnitudeLabel setBackgroundColor:[UIColor yellowColor]];
    } else {
        [cell.magnitudeLabel setBackgroundColor:[UIColor redColor]];
    }
    [cell.magnitudeLabel setText:magnitudeString];
    
//    [[cell detailTextLabel] setText:dateString];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
     NSString *latStr = self.earthquakesDict[@"results"][@"collection1"]
     [indexPath.row][@"lat"];
     
     NSString *longStr = self.earthquakesDict[@"results"][@"collection1"]
     [indexPath.row][@"long"];
     
     CLLocationDegrees latitude = [latStr doubleValue];
     CLLocationDegrees longitude = [longStr doubleValue];
     
     CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
     
     MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
     MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center,
                                                                    150000,
                                                                    150000);
     
     MKPointAnnotation *epicenter = [[MKPointAnnotation alloc] init];
     [epicenter setCoordinate:center];
     [mapView addAnnotation:epicenter];
     [mapView setMapType:MKMapTypeHybrid];
     [mapView setRegion:region animated:YES];
     
     UIViewController *mapVC = [[UIViewController alloc] init];
     [mapVC setView:mapView];
     
     [[self navigationController] pushViewController:mapVC animated:YES];
     // Do fancy stuff.
 }

@end
