//
//  ViewController.swift
//  Green P Parking
//
//  Created by Student on 2016-05-20.
//  Copyright © 2016 Oliver Gane. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let baseURL = "http://www1.toronto.ca/City%20Of%20Toronto/Information%20&%20Technology/Open%20Data/Data%20Sets/Assets/Files/greenPParking2015.json"

   
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJSON()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.map.showsUserLocation = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.map.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors:" + error.localizedDescription)
    }
    
    
    
    func getJSON(){
        let url = NSURL(string: baseURL)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil {
                let swiftyJSON = JSON(data: data!)
                let carPark = swiftyJSON["carparks"].arrayValue
                
                for lat in carPark {
                    let lats = lat["lat"].stringValue
                    print(lats)
                }
                for lng in carPark {
                    let lngs = lng["lng"].stringValue
                    print(lngs)
                }
                //print(parkingLat)
            } else {
                print("There was an error")
            }
            
    }
        task.resume()
}

}