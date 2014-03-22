//
//  ZELEarthquakeTableViewController.h
//
//
//  Created by Ayberk Tosun on 6/2/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ZELEarthquakeTableViewController : UITableViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) NSDictionary *earthquakesDict;

@end
