//
//  MapAddressVC.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 08/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
class MapAddressVC: UIViewController ,MKMapViewDelegate,GMSMapViewDelegate{
    var geocoder = CLGeocoder()
    @IBOutlet weak var searchTF :UITextField!
    let annotiation = GMSMarker()
    @IBOutlet weak var mapView: GMSMapView!
    
    
    
    var manager = CLLocationManager()
    
    var changeMapDelegate :ChangeMapDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLocation()
        //               self.edgesForExtendedLayout = UIRectEdge()
        //               self.extendedLayoutIncludesOpaqueBars = false
        
        mapView.delegate = self
        searchTF.delegate = self
        
 
        
        
        //        mapView
        //        self.navigationController?.navigationBar.backItem?.title = "إضافة عنوان توصيل"
        
        // Do any additional setup after loading the view.
        setBackTitle(title: "delivary_address".localized)
        
    }
    
    
    func initLocation(){
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.navigationController?.navigationBar.backItem?.title = "إضافة عنوان توصيل"
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        let latitude = mapView.region.center.latitude
//        let longitude = mapView.region.center.longitude
//
//        annotiation.title = "current_location".localized
//        //mapView.addAnnotation(annotiation)
//        //willMove(toParent: )
//        annotiation.map = mapView
//
//        UIView.animate(withDuration: 1, animations: {
//            self.annotiation.position = mapView.region.center
//        }, completion:  { success in
//            if success {
//                // handle a successfully ended animation
//            } else {
//                // handle a canceled animation, i.e move to destination immediately
//                self.annotiation.position = mapView.region.center
//            }
//        })
//
        
        // work perfect
        // getAddress(location: getCenterLocation())
        
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
         let latitude = mapView.camera.target.latitude
               let longitude = mapView.camera.target.longitude
               
               annotiation.title = "current_location".localized
               //mapView.addAnnotation(annotiation)
               //willMove(toParent: )
               annotiation.map = mapView

               
               UIView.animate(withDuration: 1, animations: {
                self.annotiation.position = mapView.camera.target
               }, completion:  { success in
                   if success {
                       // handle a successfully ended animation
                   } else {
                       // handle a canceled animation, i.e move to destination immediately
                       self.annotiation.position = mapView.camera.target
                   }
               })
    }
    
    
    func getCenterLocation() -> CLLocation{
        let latitude = mapView.camera.target.latitude//mapView.region.center.latitude
        let longitude = mapView.camera.target.longitude //mapView.region.center.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func getAddress(location center: CLLocation){
        //self.showIndicator()
           let address = Address(id: 0, title: "", region: "", addressDetails: "", latitude: Double(center.coordinate.latitude), longitude: Double(center.coordinate.longitude), phone: "", isdefult: 0)
        if (self.changeMapDelegate != nil){
            self.changeMapDelegate?.mapChanged(address: address)
            self.pop()
        }else{
            self.performSegue(withIdentifier: "AddAddressVC", sender: address)
        }
        
       
        
        
    }
    
    
    
    
    
    func getAddressBySearching(address :String){
        self.showIndicator()
       
        
        
        // Geocode Address String
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        self.hideIndicator()
        
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
 
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                let locationText = "\(coordinate.latitude), \(coordinate.longitude)"
                
                 let cordicator = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)

                
                mapView.moveCamera(GMSCameraUpdate.setCamera(GMSCameraPosition(latitude: cordicator.latitude, longitude: cordicator.longitude, zoom: 17)))
                
            } else {
                print("Matching Location Found")

            }
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAddressVC" {
            let vc = segue.destination as! AddAddressVC
            if sender != nil{
                vc.address = sender as! Address
            }
        }
    }
    
    
    
    
    @IBAction func addAddress(_ sender :UIButton){
        
        getAddress(location: getCenterLocation())
    }
    
}



extension MapAddressVC{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        getAddressBySearching(address: textField.text!)
        return true
    }
}



extension MapAddressVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        var location = locations.last
        setCurrentPostion(location: location!)
    }
    
    
    
    func setCurrentPostion(location :CLLocation){
        let cordicator = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        //mapView.setCamera(MKMapCamera(lookingAtCenter: cordicator, fromDistance: 55000, pitch: 0, heading: 0), animated: true)
        
        
        
        mapView.moveCamera(GMSCameraUpdate.setCamera(GMSCameraPosition(latitude: cordicator.latitude, longitude: cordicator.longitude, zoom: 17)))
                       
        
    }
}
