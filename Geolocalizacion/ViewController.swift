//
//  ViewController.swift
//  Geolocalizacion
//
//  Created by usuario on 1/9/19.
//  Copyright © 2019 wenceslao. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
   
    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
        //        MARK: DIBUJAR MAPA
        // Do any additional setup after loading the view, typically from a nib.
        let latitude: CLLocationDegrees = 19.4336523
        let longitude: CLLocationDegrees = -99.1454316
        let latDelta: CLLocationDegrees = 0.5
        let lonDelta: CLLocationDegrees = 0.5
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        map.setRegion(region, animated: true)
        
        //        MARK : ANOTACIONES
        
        let annotation = MKPointAnnotation()
        annotation.title = "Ciudad de México"
        annotation.subtitle = "Me encuentro aqui."
        annotation.coordinate = coordinates
        map.addAnnotation(annotation)
        map.selectAnnotation(annotation, animated: true)
        
        // 19.3948,-99.1736
       let coordinates2 = CLLocationCoordinate2D(latitude:19.3948, longitude:-99.1736)
        //        MARK: RUTA
        
        let sourcePlacemark = MKPlacemark.init(coordinate: coordinates)
        let sourceMapItem = MKMapItem.init(placemark: sourcePlacemark)
        
        let destinationPlacemark = MKPlacemark.init(coordinate: coordinates2)
        let destinationMapItem = MKMapItem.init(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate {
            (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.map.addOverlay(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.map.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        

    }


}
extension UIViewController : MKMapViewDelegate{
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineDashPattern = [4,2];
        renderer.lineWidth = 4.0
        renderer.alpha = 1
        return renderer
    }

}
