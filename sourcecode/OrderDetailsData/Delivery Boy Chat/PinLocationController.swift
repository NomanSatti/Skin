//
/**
 LocalSho
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: PinLocationController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license   https://store.webkul.com/license.html
 */

import UIKit
import GoogleMaps
import Alamofire

class PinLocationController: UIViewController {
    
    @IBOutlet var mapView: UIView!
    @IBOutlet var estimatedTime: UILabel!
    
    var longitude:Double = 53.8478
    var latitude:Double = 23.4241
    var googleMapView: GMSMapView!
    var language = "en"
    var deliveryBoyLatLong: (lat: String, long: String) = (lat: "", long: "")
    var isDistanceSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SetUpMap()
    }
}

extension PinLocationController: GMSMapViewDelegate{
    
    func SetUpMap(){
        let lat: Double = (deliveryBoyLatLong.lat as NSString).doubleValue
        let long: Double = (deliveryBoyLatLong.long as NSString).doubleValue
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15)
        googleMapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: AppDimensions.screenWidth, height: self.mapView.frame.height), camera: camera)
        googleMapView.delegate = self
        googleMapView.isMyLocationEnabled = true
        self.mapView.addSubview(googleMapView)
        
        let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let london = GMSMarker(position: position)
        london.title = "Delivery Boy"
        london.icon = UIImage(named: "ic_dboy")
        london.map = googleMapView
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.latitude = position.target.latitude
        self.longitude = position.target.longitude
        
        if !isDistanceSet {
            self.drawPolyline()
        }
    }
    
    func drawPolyline() {
        let currlatitude = (googleMapView.myLocation?.coordinate.latitude)!
        let currlongitude = (googleMapView.myLocation?.coordinate.longitude)!
        let origin = "\(currlatitude),\(currlongitude)"
        let destination = "\(deliveryBoyLatLong.lat),\(deliveryBoyLatLong.long)"
        //transit, driving, walking, or cycling.
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDsmi-flQFJvcRT2BPSOV2M-fMk9ikf1O0&language=\(language)"
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                let responseJson = response.result.value! as! NSDictionary
                print(responseJson)
                if let results = responseJson.object(forKey: "routes")! as? [NSDictionary] {
                    if results.count > 0 {
                        self.isDistanceSet = true
                        let json = JSON(data: response.data!)
                        let routes = json["routes"].arrayValue
                        for route in routes {
                            self.isDistanceSet = true
                            let routeOverviewPolyline = route["overview_polyline"].dictionary
                            let points = routeOverviewPolyline?["points"]?.stringValue
                            let path = GMSPath.init(fromEncodedPath: points!)
                            
                            let polyline = GMSPolyline(path: path)
                            polyline.strokeColor = .black
                            polyline.strokeWidth = 5.0
                            polyline.map = self.googleMapView
                            
                            //time estimation
                            if let legsData = route["legs"].array {
                                if let durationData = legsData[0].dictionary {
                                    if let timeVal = durationData["duration"]?["text"].string {
                                        print(timeVal)
                                        self.estimatedTime.text = timeVal
                                    }
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
