//
//  Utils.m
//  Synchora
//
//  Created by iMac on 9/10/15.
//  Copyright (c) 2015 macbook. All rights reserved.
//

#import "SUtilities.h"
#import "Reachability.h"

UIActivityIndicatorView *indicator;
@implementation SUtilities


+(void)showLoading:(UIView *)view{
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 100, 100);
    indicator.center = view.center;
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:175.0/255.0 blue:228.0/255.0 alpha:0.5];
    indicator.layer.cornerRadius = 10.0;
    [view addSubview:indicator];
    [indicator bringSubviewToFront:view];
    [indicator startAnimating];
}
+(void)dismissLoading{
    [indicator stopAnimating];
}
//  UDID utils
+ (NSString *)getUDID {
#if TARGET_IPHONE_SIMULATOR
    return @"33";
#else
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
#endif
}
// Alert utils
+(void)showAlert:(NSString*)msg{
    UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Heyy App" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [notPermitted show];
}
+ (BOOL) isInternetReachable {
    Reachability *hostReach = [Reachability reachabilityWithHostname:@"google.com"];
    return [hostReach isReachableViaWiFi] || [hostReach isReachableViaWWAN];
}
+ (void)obtainPermissionForMediaSourceType:(UIImagePickerControllerSourceType)sourceType withSuccessHandler:(void (^) ())successHandler andFailure:(void (^) ())failureHandler {
    
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary || sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum){
        // Denied when photo disabled, authorized when photos is enabled. Not affected by camera
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusAuthorized: {
                    if (successHandler)
                        dispatch_async (dispatch_get_main_queue (), ^{ successHandler (); });
                }; break;
                    
                case PHAuthorizationStatusRestricted:
                case PHAuthorizationStatusDenied:{
                    if (failureHandler)
                        dispatch_async (dispatch_get_main_queue (), ^{ failureHandler (); });
                }; break;
                    
                default:
                    break;
            }
        }];
    }
    else if (sourceType == UIImagePickerControllerSourceTypeCamera){
        // Checks for Camera access:
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (status){
                
            case AVAuthorizationStatusAuthorized:{
                if (successHandler)
                    dispatch_async (dispatch_get_main_queue (), ^{ successHandler (); });
            }; break;
                
            case AVAuthorizationStatusNotDetermined:{
                // seek access first:
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if(granted){
                        if (successHandler)
                            dispatch_async (dispatch_get_main_queue (), ^{ successHandler (); });
                    } else {
                        if (failureHandler)
                            dispatch_async (dispatch_get_main_queue (), ^{ failureHandler (); });
                    }
                }];
            }; break;
                
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
            default:{
                if (failureHandler)
                    dispatch_async (dispatch_get_main_queue (), ^{ failureHandler (); });
            }; break;
        }
    }
    else{
        NSAssert(NO, @"Permission type not found");
    }
}


// UI utils
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


// Alert utils

+(void)displayAlertWithWithTitle:(NSString*)title andMessage:(NSString*)message {
    UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [notPermitted show];
}

// String utils
+(BOOL)stringIsNilOrEmpty:(NSString*)aString {
    if (aString == nil || aString == NULL || [aString isEqual: [NSNull null]]) {
        return true;
    }
    return !(aString && aString.length);
}
+(NSString*)checkIfStringNotNull:(NSString*)aString{
    return aString == nil?@"":aString;
}


//Image utils
+ (NSString *)imageToNSString:(UIImage *)image {
    NSData *dataImage = UIImagePNGRepresentation(image);
    NSString *stringImage = [dataImage base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return stringImage;
}

+ (UIImage *)stringToUIImage:(NSString *)string {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

//  Textfield utils
+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


+ (NSString *)relativeDateStringForDate:(NSDate *)date {
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    if (components.year > 0) {
        return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    } else if (components.weekOfYear > 0) {
        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    } else if (components.day > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en"];
        [dateFormatter setLocale:locale];
        [dateFormatter setDateFormat:@"EEEE"];
        NSString *formattedDate = [dateFormatter stringFromDate:date];
        if (components.day > 1) {
            return formattedDate;
        } else {
            return @"Yesterday";
        }
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en"];
        [dateFormatter setLocale:locale];
        [dateFormatter setDateFormat:@"hh:mma"];
        NSString *formattedDate = [dateFormatter stringFromDate:date];
        return formattedDate;
    }
}


// return square Image
+ (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    
    [image drawAtPoint:origin];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

// scale image
+ (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize image:(UIImage *)sourceImage{
    
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }else return sourceImage;
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage ;
}


+(void)downloadImageGettingByLibrairy:(UIImage*)image withName:(NSString*)name{
    if (image != nil) {
        NSData *data = UIImageJPEGRepresentation(image,1.0);
        if(data.length>0){
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *ContentOfFile = [documentsDirectory stringByAppendingPathComponent:name];
            [data writeToFile:ContentOfFile atomically:YES];
        }
        }
}


+(void)downloadImageFromUrl:(NSString*)urlImage andName:(NSString*)imagName{
    //Spinner de telechargement ios
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(urlImage.length >0 && imagName.length>0)
    {
        //Creation de l'url
        NSURL*url=[[NSURL alloc]initWithString:[urlImage  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //Lancement de telechargement
        NSError *error;
        NSData *data=[NSData dataWithContentsOfURL:url options:0 error:&error];
        
        if (!error){
            if(data.length>0)
            {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *ContentOfFile = [documentsDirectory stringByAppendingPathComponent:imagName];
                [data writeToFile:ContentOfFile atomically:YES];
        }
        
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
}

+(UIImage*)getImage :(NSString*)imageName
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat: @"/%@/%@", documentsDirectory,imageName];
    UIImage* image = [[UIImage alloc] initWithContentsOfFile:filePath];
    return image;
}

//+(UIImage*)getImageWithname :(NSString*)imageName
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *filePath = [NSString stringWithFormat: @"/%@/%@", documentsDirectory,imageName];
//    UIImage* image = [[UIImage alloc] initWithContentsOfFile:filePath];
//    if(image==Nil)
//    {
//        
//        return   [UIImage imageNamed:defaultImage];
//    }
//    return image;
//}
//+(void)saveDataImageProfileAndUpload:(UIImage*)image{
//    [self saveDataImageProfile:image];
//    NSData *imageData1 = [SUtilities getDataOfImageWithName:DATA_IMAGE_PROFILE_CROPPED];
//    [UserParser uploadImageProfile:imageData1 didFinish:^(bool succes, NSDictionary *result, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"resultresult %@ ",result);
//            if (succes) {
//                
//            }
//            else{
//            }
//            
//        });
//    }];
//    
//}
//+(void)saveDataImageProfile:(UIImage*)image{
//    CGRect rect ;
//    CGSize size = CGSizeMake(IMAGE_UPLOADED_WIDTH, IMAGE_UPLOADED_HEIGTH);
//    if (image.size.width > size.width && image.size.height > size.height) {
//        if (image.size.width < image.size.height)
//            rect =  CGRectMake(0,0,image.size.width*size.height/image.size.height,size.height);
//        else
//            rect =  CGRectMake(0,0,size.width,image.size.height*size.width/image.size.width);
//    }
//    else if (image.size.width > size.width)
//        rect =  CGRectMake(0,0,size.width,image.size.height*size.width/image.size.width);
//    else if (image.size.height > size.height)
//        rect =  CGRectMake(0,0,image.size.width*size.height/image.size.height,size.height);
//    else
//        rect =  CGRectMake(0,0,image.size.width,image.size.height);
//    UIGraphicsBeginImageContext( rect.size );
//    [image drawInRect:rect];
//    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    CGFloat compression = 0.95;
//    CGFloat maxCompression = 0.75f;
//    
//    NSData *imageData = UIImageJPEGRepresentation(picture1, 1.0);
//    if ([imageData length]>MAX_SIZE_IMAGE_DATA)  {
//        compression=ceilf(MAX_SIZE_IMAGE_DATA*0.95/[imageData length]*10)/10;
//        if (compression < maxCompression)compression=maxCompression;
//        imageData = UIImageJPEGRepresentation(picture1, compression);
//    }
//    if(imageData.length>0){
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *ContentOfFile = [documentsDirectory stringByAppendingPathComponent:DATA_IMAGE_PROFILE_CROPPED];
//        [imageData writeToFile:ContentOfFile options:NSDataWritingFileProtectionComplete error:nil];
//    }
//    
//}

+(NSData*)getDataOfImageWithName:(NSString*)imageName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat: @"/%@/%@", documentsDirectory,imageName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

+(BOOL)checkIfFileExistWithName:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *File = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileName length]>0)
    {
        
        if(![fileManager fileExistsAtPath:File])
            return false;
    }
    
    else
        return false;
    return TRUE;
}
@end
