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

extension Double {
    var degreesToRadians: Double { return self * M_PI / 180 }
    var radiansToDegrees: Double { return self * 180 / M_PI }
}



class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let baseURL = "http://www1.toronto.ca/City%20Of%20Toronto/Information%20&%20Technology/Open%20Data/Data%20Sets/Assets/Files/greenPParking2015.json"

    var latitude : String = ""
    var longitude : String = ""
    var latitudeAsDouble : Double = 0.0
    var longitudeAsDouble : Double = 0.0
    let averageEarthRadius : Double = 6373
    var shortestParkingDistance : Double = Double.infinity
    var closestParking : [String : String] = [:]
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBAction func button(sender: AnyObject) {
        getJSON()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.map.showsUserLocation = true
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        getJSON()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.map.showsUserLocation = true
        // Do any additional setup after loading the view, typically from a nib.
         */
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
        let latestLocation = locations.last
       let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(finalLat), longitude: Double(finalLong))
        self.map.addAnnotation(annotation)
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors:" + error.localizedDescription)
    }
    
    //func currentLocationDistanceTo()
    var finalLat : Float = 0
    var finalDist : Float = 100
    var finalLong : Float = 0
    var finalAddr = ""
    
    func getJSON(){
        let url = NSURL(string: baseURL)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil {
                let swiftyJSON = JSON(data: data!)
                let carPark = swiftyJSON["carparks"].arrayValue
                /*
                var i = 0
                for lat in carPark {
                    i++
                }
                */
                //var distances : [Float] = []
                
                for lat in carPark {
                    let lats = lat["lat"].stringValue
                    let lngs = lat["lng"].stringValue
                    let addr = lat["address"].stringValue
                    print(addr)
                    
                    guard let latAsFloat = Float(lats) else {
                        print("Cannot convert")
                        return
                    }
                    guard let lngAsFloat = Float(lngs) else {
                        print("Cannot convert")
                        return
                    }
                    //distances.append(sqrt((latAsFloat-43.669395)*(latAsFloat-43.669395) + (lngAsFloat+79.410188)*(lngAsFloat+79.410188)))
                    let currentDist = sqrt((latAsFloat-43.669395)*(latAsFloat-43.669395) + (lngAsFloat+79.410188)*(lngAsFloat+79.410188))
                    if currentDist < self.finalDist {
                        self.finalDist = currentDist
                        self.finalLat = latAsFloat
                        self.finalLong = lngAsFloat
                        self.finalAddr = addr
                        self.addressLabel.text = addr

                    }
                }
            } else {
                print("There was an error")
            }
            
    }
        dispatch_async(dispatch_get_main_queue()){
            self.addressLabel.text = self.finalAddr
        }
        task.resume()
}
    
}