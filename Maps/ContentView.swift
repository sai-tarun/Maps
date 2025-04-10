//
//  ContentView.swift
//  Maps
//
//  Created by Majji  Sai Tarun on 11/04/25.
//

import SwiftUI
import GoogleMaps
import CoreLocation

struct MapView : UIViewRepresentable {
    
    //Binding TotalDistance
    @Binding var totalDistance : CLLocationDistance
    
//    func makeCoordinator() -> Coordinator {
//        return Coordinatior(totalDistance: $totalDistance)
//    }
    
    
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        context.coordinator
        
        //Request Location Authorization
       // context.coordinator.locationManager
        //False
        return mapView
    }
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        
    }
    
    //Coordinator to Handle Events
    class Coordinatior : NSObject,CLLocationManagerDelegate{
        var mapView : GMSMapView?
        var locationManager = CLLocationManager()
        var previousLocation : CLLocation?
        var polyline : GMSPolyline?
        @Binding var totalDistance : CLLocationDistance
        
        init(totalDistance : Binding<CLLocationDistance>){
            self._totalDistance = totalDistance
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else {return }
            
            //Calculate Location and Update total Distance
            if let previousLocation = self.previousLocation {
                let distance = location.distance(from: previousLocation)
                self.totalDistance += distance
            }
            
            //Update Polyline to Draw the route
            if let path = polyline?.path {
                let path = GMSMutablePath(path: path)
                path.add(location.coordinate)
                polyline?.path = path
            }else {
                let path = GMSMutablePath()
                path.add(location.coordinate)
                let newPolyline = GMSPolyline(path: path)
                newPolyline.strokeColor = .red
                newPolyline.strokeWidth = 5.0
                newPolyline.map = mapView
                polyline = newPolyline
            }
            
            
            //set camera position to the Current Location
            let zoom : Float = 18.0
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoom)
            mapView?.animate(to: camera)
            self.previousLocation = location
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
                mapView?.isMyLocationEnabled = true
                mapView?.settings.myLocationButton = true
            }
        }
        
        
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
