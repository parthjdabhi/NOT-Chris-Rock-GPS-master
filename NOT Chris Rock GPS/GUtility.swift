//
//  GUtility.swift
//  NOT Chris Rock GPS
//
//  Created by iParth on 9/27/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit

class GUtility: NSObject {

}

//public PlacesList search(double latitude, double longitude, double radius, String types)
//throws Exception {
//    
//    try {
//        
//        HttpRequestFactory httpRequestFactory = createRequestFactory(HTTP_TRANSPORT);
//        HttpRequest request = httpRequestFactory
//            .buildGetRequest(new GenericUrl("https://maps.googleapis.com/maps/api/place/search/json?"));
//        request.getUrl().put("key", YOUR_API_KEY);
//        request.getUrl().put("location", latitude + "," + longitude);
//        request.getUrl().put("radius", radius);
//        request.getUrl().put("sensor", "false");
//        request.getUrl().put("types", types);
//        
//        PlacesList list = request.execute().parseAs(PlacesList.class);
//        
//        if(list.next_page_token!=null || list.next_page_token!=""){
//            Thread.sleep(4000);
//            /*Since the token can be used after a short time it has been  generated*/
//            request.getUrl().put("pagetoken",list.next_page_token);
//            PlacesList temp = request.execute().parseAs(PlacesList.class);
//            list.results.addAll(temp.results);
//            
//            if(temp.next_page_token!=null||temp.next_page_token!=""){
//                Thread.sleep(4000);
//                request.getUrl().put("pagetoken",temp.next_page_token);
//                PlacesList tempList =  request.execute().parseAs(PlacesList.class);
//                list.results.addAll(tempList.results);
//            }
//            
//        }
//        return list;
//        
//    } catch (HttpResponseException e) {
//        return null;
//    }
//    
//}


//- (void)drawRoute
//    {
//        [self fetchPolylineWithOrigin:myOrigin destination:myDestination completionHandler:^(GMSPolyline *polyline)
//            {
//            if(polyline)
//            polyline.map = self.myMap;
//            }];
//    }
//    
//- (void)fetchPolylineWithOrigin:(CLLocation *)origin destination:(CLLocation *)destination completionHandler:(void (^)(GMSPolyline *))completionHandler
//{
//    NSString *originString = [NSString stringWithFormat:@"%f,%f", origin.coordinate.latitude, origin.coordinate.longitude];
//    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", destination.coordinate.latitude, destination.coordinate.longitude];
//    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
//    NSString *directionsUrlString = [NSString stringWithFormat:@"%@&origin=%@&destination=%@&mode=driving", directionsAPI, originString, destinationString];
//    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
//    
//    
//    NSURLSessionDataTask *fetchDirectionsTask = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler:
//    ^(NSData *data, NSURLResponse *response, NSError *error)
//    {
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    if(error)
//    {
//    if(completionHandler)
//    completionHandler(nil);
//    return;
//    }
//    
//    NSArray *routesArray = [json objectForKey:@"routes"];
//    
//    GMSPolyline *polyline = nil;
//    if ([routesArray count] > 0)
//    {
//    NSDictionary *routeDict = [routesArray objectAtIndex:0];
//    NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
//    NSString *points = [routeOverviewPolyline objectForKey:@"points"];
//    GMSPath *path = [GMSPath pathFromEncodedPath:points];
//    polyline = [GMSPolyline polylineWithPath:path];
//    }
//    
//    if(completionHandler)
//    completionHandler(polyline);
//    }];
//    [fetchDirectionsTask resume];
//}