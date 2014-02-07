//
//  ZELEarthquakeTableViewController.h
//
//
//  Created by Ayberk Tosun on 6/2/14.
//
//

#import <UIKit/UIKit.h>

@class CLLocationManager;

@interface ZELEarthquakeTableViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *earthquakesDict;

@property (nonatomic) CLLocationManager *locationManager;

@end
