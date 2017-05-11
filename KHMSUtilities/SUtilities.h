//
//  Utils.h
//  Synchora
//
//  Created by iMac on 9/10/15.
//  Copyright (c) 2015 macbook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Photos/Photos.h"


@interface SUtilities : NSObject


// Alert utils

+(void)showLoading:(UIView*)view;
+(void)dismissLoading;
+(void)showAlert:(NSString*)msg;
+(BOOL) isInternetReachable ;
+(NSString *)getUDID;
+(UIColor *)colorFromHexString:(NSString *)hexString;
+(BOOL)stringIsNilOrEmpty:(NSString*)aString;
+(NSString *)imageToNSString:(UIImage *)image;
+(UIImage *)stringToUIImage:(NSString *)string;
+(BOOL)validateEmailWithString:(NSString*)email;
+(NSString *)relativeDateStringForDate:(NSDate *)date;
+(UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize;
+(UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize image:(UIImage *)sourceImage;
+(void)displayAlertWithWithTitle:(NSString*)title andMessage:(NSString*)message;
+(void)downloadImageFromUrl:(NSString*)urlImage andName:(NSString*)imagName;
+(UIImage*)getImageWithname :(NSString*)imageName;
+(BOOL)checkIfFileExistWithName:(NSString*)fileName;
+(void)downloadImageGettingByLibrairy:(UIImage*)image withName:(NSString*)name;
+(UIImage*)getImage :(NSString*)imageName;
+(NSString*)checkIfStringNotNull:(NSString*)aString;
+ (NSString *)getPrefixFromMobile:(NSString *)fullPhone;
+(NSData*)getDataOfImageWithName:(NSString*)imageName;
+(void)saveDataImageProfile:(UIImage*)image;
+(void)saveDataImageProfileAndUpload:(UIImage*)image;
+ (void)obtainPermissionForMediaSourceType:(UIImagePickerControllerSourceType)sourceType withSuccessHandler:(void (^) ())successHandler andFailure:(void (^) ())failureHandler ;
@end
