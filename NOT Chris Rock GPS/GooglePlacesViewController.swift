//
//  GooglePlacesViewController.swift
//  NOT Chris Rock GPS
//
//  Created by Dustin Allen on 9/14/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

import Alamofire
import SwiftyJSON

class GooglePlacesViewController: UIViewController, UISearchBarDelegate, LocateOnTheMap, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var googleMapsContainer: UIView!
    @IBOutlet weak var googleMapsView: GMSMapView!
    
    //var googleMapsView: GMSMapView!
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBarHidden = false
        // Do any additional setup after loading the view, typically from a nib.
        
        //googleMapsView = GMSMapView(frame: UIScreen.mainScreen().bounds)
        //self.view.addSubview(self.googleMapsView)
        
        GMSServices.provideAPIKey(googleMapsApiKey)
        //self.googleMapsView.addObserver(self, forKeyPath: "myLocation", options: .New, context: nil)
        
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
        
        self.googleMapsView.myLocationEnabled = true
        self.googleMapsView.settings.myLocationButton = true
        
        initLocationManager()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        
        //self.googleMapsView.removeObserver(self, forKeyPath: "myLocation")
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
    }
    
    @IBAction func searchWithAddress(sender: AnyObject)
    {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
    }

    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String)
    {
        CLocationSelected =  CLLocation(latitude: lat, longitude: lon)
        addOverlayToMapView()
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.googleMapsView.clear()
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            
            
            let marker = GMSMarker(position: position)
            let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 10)
            self.googleMapsView.camera = camera
            
            marker.title = "\(title)"
            //marker.snippet = "NOT chris rock"
            marker.map = self.googleMapsView
            marker.icon = GMSMarker.markerImageWithColor(clrGreen)
            
        }
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let placeClient = GMSPlacesClient()
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error: NSError?) -> Void in
            
            self.resultsArray.removeAll()
            if results == nil {
                return
            }
            
            for result in results! {
                if let result = result as? GMSAutocompletePrediction {
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }
            self.searchResultController.reloadDataWithArray(self.resultsArray)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLocationManager()
    {
        if !CLLocationManager.locationServicesEnabled() {
            print("Location service not enabled")
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        locationManager.stopUpdatingLocation()
        print("Location Update Fails with errors : \(error)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        CLocation = locations.last! as CLLocation
        self.googleMapsView.camera = GMSCameraPosition(target: CLocation!.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        CLGeocoder().reverseGeocodeLocation(CLocation!, completionHandler: {(placemarks, error)->Void in
            let pm = placemarks![0]
            if let place = pm.LocationString()
            {
                CLocationPlace = place
            }
        })
        locationManager.stopUpdatingLocation()
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "myLocation" {
            print("myLocation",object)
//            if let l:CLLocation = object?.location {
//                print("Location : ",l)
//            }
        }
    }
    
    func addOverlayToMapView()
    {
        let directionURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(CLocation!.coordinate.latitude),\(CLocation!.coordinate.longitude)&destination=\(CLocationSelected.coordinate.latitude),\(CLocationSelected.coordinate.longitude)&key=\(googleMapsApiKey)&mode=walking"
        //mode:driving,walking,bicycling,transit
        print(directionURL)
        
        Alamofire.request(.GET, directionURL, parameters: nil).responseJSON { response in
            
            switch response.result {
                
            case .Success(let data):
                
                let json = JSON(data)
                let errornum = json["error"]
                print(json)
                
                if (errornum == true) {
                    print("Error",errornum)
                } else {
                    let routes = json["routes"].array
                    if routes != nil {
                        let overViewPolyLine = routes![0]["overview_polyline"]["points"].string
                        print(overViewPolyLine)
                        if overViewPolyLine != nil{
                            self.addPolyLineWithEncodedStringInMap(overViewPolyLine!)
                        }
                    }
                }
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func addPolyLineWithEncodedStringInMap(encodedString: String) {
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 5
        polyLine.strokeColor = clrGreen
        polyLine.map = self.googleMapsView
        
    }
}
