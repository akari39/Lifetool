//
//  MapView.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/2/26.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation
import UIKit

class MedicalAnnotation:NSObject,MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title:String?
    var subtitle:String?
    var icon:String?
    var color:UIColor?
    var distance:String?
    var type:String?
    
    override init(){
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.subtitle = nil
        self.icon = nil
        self.color = UIColor.white
        self.distance = nil
        self.type = nil
    }
}

let medicallist = ["AED","医院"]

let locationManager:CLLocationManager = {
    let manager = CLLocationManager()
    manager.requestAlwaysAuthorization()
    manager.requestWhenInUseAuthorization()
    manager.startUpdatingLocation()
    return manager
}()

struct MapView: UIViewRepresentable {
    @Binding var distance:[String:MedicalAnnotation]
    
    @Binding var userTrackingMode:MKUserTrackingMode
    
    static var allowUpdate = true
    static var firstUpdated = false
    
    @Binding var refreshed:Bool
    
    func makeUIView(context:Context) -> MKMapView {
        let mapView = MKMapView(frame:.zero)
        mapView.delegate = context.coordinator
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {_ in
            MapView.allowUpdate.toggle()
        })
        timer.fire()
        
        if CLLocationManager.locationServicesEnabled(){
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
            mapView.centerCoordinate = mapView.userLocation.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView,context:Context){
        mapView.setUserTrackingMode(userTrackingMode, animated: true)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        if refreshed{
            context.coordinator.searchForHealthPlaces(mapView, mapView.userLocation.coordinate, medicallist)
            self.refreshed = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate,MKLocalSearchCompleterDelegate{
        var parent: MapView

        var isUpdateLocation = false
        var isSelected = false
        
        var latestNearestLocation = [String:MedicalAnnotation]()
        var routeColor = UIColor()
    
        private var mapChangedFromUserInteraction = false

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = routeColor
            renderer.lineWidth = 4.0
            return renderer
        }

        func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
                        -> Void ) {
            if let lastLocation = locationManager.location {
                let geocoder = CLGeocoder()
                    
                // Look up the location and pass it to the completion handler
                geocoder.reverseGeocodeLocation(lastLocation,
                            completionHandler: { (placemarks, error) in
                    if error == nil {
                        let firstLocation = placemarks?[0]
                        completionHandler(firstLocation)
                    }
                    else {
                     // An error occurred during geocoding.
                        completionHandler(nil)
                    }
                })
            }
            else {
                // No location was available.
                completionHandler(nil)
            }
        }
        
        func searchForHealthPlaces(_ mapView:MKMapView,_ coordinate:CLLocationCoordinate2D,_ searchLists:[String]){
            MapView.firstUpdated = true
            for n in mapView.annotations{
                if !n.isEqual(mapView.userLocation) {
                    if CLCircularRegion(center: mapView.centerCoordinate, radius: CLLocationDistance(exactly: 500)!, identifier: "reachableRegion").contains(n.coordinate){
                        return
                    }
                }
            }
            
            let searchRequest = MKLocalSearch.Request()
            searchRequest.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
            for keyword in searchLists{
                searchRequest.naturalLanguageQuery = keyword
                if keyword=="医院"{
                    searchRequest.resultTypes = .pointOfInterest
                    searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [.hospital])
                }
                let search = MKLocalSearch(request: searchRequest)
                search.start { response, error in
                    guard let response = response else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error").")
                        return
                    }
                    
                    for item in response.mapItems {
                        var isbreak = false
                        for n in mapView.annotations{
                            if !n.isEqual(mapView.userLocation){
                                if (item.placemark.coordinate.latitude==n.coordinate.latitude)&&(item.placemark.coordinate.longitude==n.coordinate.longitude){
                                    isbreak = true
                                    break
                                }
                            }
                        }
                        if isbreak{
                            break
                        }
                        
                        let annotation = MedicalAnnotation()
                        annotation.title = item.placemark.name
                        if mapView.userLocation.location != nil {
                            annotation.subtitle = String(Int(CLLocation(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude).distance(from: mapView.userLocation.location!))) + "m"
                        }
                        
                        annotation.distance = annotation.subtitle
                        annotation.icon = keyword + "_white"
                        annotation.coordinate = item.placemark.coordinate
                        annotation.type = keyword
                        mapView.addAnnotation(annotation)
                        
                        if !self.isSelected{
                            if self.parent.distance[keyword] == nil{
                                self.parent.distance[keyword] = annotation
                            }else{
                                if Int((annotation.distance?.replacingOccurrences(of: "m", with: ""))!)! < Int((self.parent.distance[keyword]?.distance?.replacingOccurrences(of: "m", with: ""))!)!{
                                    self.parent.distance[keyword] = annotation
                                }
                            }
                        }
                    }
                    
                    if self.parent.distance[keyword] != nil && !self.isSelected{
                        let directionRequest = MKDirections.Request()
                        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
                        
                        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: self.parent.distance[keyword]!.coordinate))
                        directionRequest.transportType = .walking
                        
                        let directions = MKDirections(request: directionRequest)
                        directions.calculate { response, error in
                            if self.parent.distance[keyword]!.type == "AED"{
                                self.routeColor = UIColor(displayP3Red: 188/255, green: 27/255, blue: 27/255, alpha: 1)
                            } else {
                                self.routeColor = UIColor(named: "ThemeColor")!
                            }
                            guard let response = response else { return }
                            let route = response.routes[0]
                            mapView.addOverlay(route.polyline, level: .aboveRoads)
                        }
                    }
                }
            }
        }
        
        func annotationChange(_ mapView:MKMapView){
            
            lookUpCurrentLocation(completionHandler: {(firstLocation) in
                var addressString : String = ""
                
                if firstLocation?.thoroughfare != nil {
                    addressString = addressString + (firstLocation?.thoroughfare!)!
                }
                if firstLocation?.subThoroughfare != nil {
                    addressString = addressString + (firstLocation?.subThoroughfare!)!
                }
                if firstLocation?.locality != nil {
                    addressString = addressString + "，" + (firstLocation?.locality!)!
                }

                if firstLocation?.subAdministrativeArea != nil {
                    addressString = addressString + "，" + (firstLocation?.subAdministrativeArea!)!
                }
                mapView.userLocation.title = (firstLocation?.name) ?? "我的位置"
                mapView.userLocation.subtitle = addressString

            })
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            if parent.userTrackingMode != .none {
                parent.userTrackingMode = .none
            }
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            if (((mapView.centerCoordinate.latitude) == mapView.userLocation.coordinate.latitude) && ((mapView.centerCoordinate.longitude == mapView.centerCoordinate.longitude))) {
                mapView.selectAnnotation(mapView.userLocation, animated: true)
                searchForHealthPlaces(mapView,mapView.userLocation.coordinate,medicallist)
            }
            
            if MapView.allowUpdate{
                MapView.allowUpdate=false
                if !isSelected{
                    mapView.removeOverlays(mapView.overlays)
                }
                searchForHealthPlaces(mapView,mapView.userLocation.coordinate,medicallist)
            }
            annotationChange(mapView)
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if (view.annotation?.isEqual(mapView.userLocation))!{
                return
            } else {
                isSelected = true
                mapView.userTrackingMode = .none
                mapView.removeOverlays(mapView.overlays)
                if let medicalannotation = view.annotation as? MedicalAnnotation{
                    latestNearestLocation[medicalannotation.type!] = parent.distance[medicalannotation.type!]
                    parent.distance[medicalannotation.type!] = medicalannotation
                    
                    let directionRequest = MKDirections.Request()
                    directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
                    directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: medicalannotation.coordinate))
                    directionRequest.transportType = .walking

                    let directions = MKDirections(request: directionRequest)
                    directions.calculate { response, error in
                        if medicalannotation.type == "AED"{
                            self.routeColor = UIColor(displayP3Red: 188/255, green: 27/255, blue: 27/255, alpha: 1)
                        } else {
                            self.routeColor = UIColor(named: "ThemeColor")!
                        }
                        guard let response = response else { return }
                        let route = response.routes[0]
                        mapView.addOverlay(route.polyline, level: .aboveRoads)
                    }
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            if (view.annotation?.isEqual(mapView.userLocation))!{
                return
             } else {
                if let medicalannotation = view.annotation as? MedicalAnnotation{
                    isSelected = false
                    mapView.removeOverlays(mapView.overlays)
                    parent.distance[medicalannotation.type!] = latestNearestLocation[medicalannotation.type!]
                    searchForHealthPlaces(mapView,mapView.userLocation.coordinate,medicallist)
                    MapView.allowUpdate = false
                }
             }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation{
                return nil
            }
            if let customannotation = annotation as? MedicalAnnotation {
                
                var view = mapView.dequeueReusableAnnotationView(withIdentifier: "customView") as? MKMarkerAnnotationView
                if view == nil{
                    view = MKMarkerAnnotationView(annotation: customannotation, reuseIdentifier: "customView")
                }
                
                view?.annotation = customannotation
                if customannotation.type == "医院"{
                    view?.markerTintColor = UIColor(named: "ThemeColor")
                }else if customannotation.type == "AED"{
                    view?.markerTintColor = UIColor(displayP3Red: 188/255, green: 27/255, blue: 27/255, alpha: 1)
                }
                view?.clusteringIdentifier = "cluster"
                view?.glyphImage = UIImage(named:customannotation.icon!)
                view?.displayPriority = .required
                return view
            } else {
                return nil
            }
        }
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(userTrackingMode: MKUserTrackingMode.follow)
//    }
//}
