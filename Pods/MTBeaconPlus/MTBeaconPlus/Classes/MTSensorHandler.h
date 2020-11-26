//
//  MTSensorHandler.h
//  MTBeaconPlus
//
//  Created by Minewtech on 2018/12/24.
//  Copyright © 2018 MinewTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MTSensorData, MTConnectionHandler;

@protocol ConnectionDelegate;

typedef void(^MTSensorOperatBlock)( MTSensorData *sd);

@interface MTSensorHandler : NSObject

@property (nonatomic, copy) MTSensorOperatBlock operatSensor;

@property (nonatomic, strong) NSMutableDictionary *sensorDataDic;

@property (nonatomic,weak) id<ConnectionDelegate> delegate;

/**gi
 read HTSensor data from device
 
 @param completionHandler call back sensordata when data synced.
 */

- (void)readSensorHistory:(MTSensorOperatBlock)completionHandler;
/**
 set PIRSensor data to device
 
 @param completionHandler call back sensordata when data saved.
 */

- (void)pirSet:(BOOL)isRepeat andDelayTime:(uint16_t)time completion:(MTSensorOperatBlock)completionHandler;

/**
 read MTLineBeacon HWID And VendorKey data from device
 
 @param completionHandler call back linebeacondata when data synced.
 */



@end

NS_ASSUME_NONNULL_END
