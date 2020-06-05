//
//  HelpMap.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/5/6.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI
import MapKit

struct HelpMap: UIViewRepresentable {
    @State var title:String
    @State var subtitle:String
    @State var user:User
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
        if user.userLocation?.latitude != nil && user.userLocation?.longitude != nil{
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: Double(Double(user.userLocation!.latitude!)!))!, longitude: CLLocationDegrees(exactly: Double(Double(user.userLocation!.longitude!)!))!)
            view.addAnnotation(annotation)
            view.setCenter(annotation.coordinate, animated: true)
            view.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: HelpMap

        init(_ parent: HelpMap) {
            self.parent = parent
        }
    }
}
