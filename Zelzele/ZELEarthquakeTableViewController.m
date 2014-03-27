//
//  ZELEarthquakeTableViewController.m
//
//
//  Created by Ayberk Tosun on 6/2/14.
//
//

#import "ZELEarthquakeTableViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "ZELEarthquakeViewCell.h"

#include "API_KEY.h"

#define API_URL @"http://www.kimonolabs.com/api/de82dvke?apikey="

@interface ZELEarthquakeTableViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ZELEarthquakeTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy =  kCLLocationAccuracyHundredMeters;
        
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"ZELEarthquakeViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    self.title = @"Earthquakes";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[API_URL stringByAppendingString:API_KEY]]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        self.earthquakesDict = responseObject;
        NSLog(@"Count: %lu", (unsigned long)[responseObject[@"results"][@"collection1"] count]);
        [self.tableView reloadData];
    } failure:nil];
    
    NSLog(@"Operation started.");
    [operation start];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_earthquakesDict[@"results"][@"collection1"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    ZELEarthquakeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ZELEarthquakeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
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
    float colorRatio = magnitude/6;
    UIColor *customColor = [UIColor
                            colorWithRed:colorRatio + 0.5
                            green:1 - colorRatio + 0.5
                            blue:0.0
                            alpha:1.0];
    
    [[cell magnitudeLabel] setBackgroundColor:customColor];
    
    [cell.magnitudeLabel setText:magnitudeString];
    
    [[cell dateLabel] setText:dateString];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *latStr = self.earthquakesDict[@"results"][@"collection1"]
    [indexPath.row][@"lat"];
    
    NSString *longStr = self.earthquakesDict[@"results"][@"collection1"]
    [indexPath.row][@"long"];
    
    CLLocationDegrees latitude = [latStr doubleValue];
    CLLocationDegrees longitude = [longStr doubleValue];
    
    CLLocationCoordinate2D epicenter = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocation *epicenterLoc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    CLLocationDistance distance = [[self.locationManager location]
                                   distanceFromLocation:epicenterLoc];
    NSString *distanceString = [NSString stringWithFormat:@"Distance to you: %0.1f km", distance/1000];
    NSLog(@"%@", distanceString);
    
    MKPointAnnotation *epicenterPin = [[MKPointAnnotation alloc] init];
    [epicenterPin setCoordinate:epicenter];
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(epicenter,
                                                                   300000,
                                                                   300000);
    
    [mapView addAnnotation:epicenterPin];
    [mapView setMapType:MKMapTypeHybrid];
    [mapView setRegion:region animated:YES];
    
    UIViewController *mapVC = [[UIViewController alloc] init];
    [mapVC setView:mapView];
    
    [[self navigationController] pushViewController:mapVC animated:YES];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"Locations number: %lu", (unsigned long)[locations count]);
}

@end
