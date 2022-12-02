//
//  MapViewController.swift
//  GBFitness
//
//  Created by Максим Лосев on 30.11.2022.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var stopUpdateLocationButton: UIButton!
    
    // MARK: - Properties
    let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    var manualMarker: GMSMarker?
    var locationManager: CLLocationManager?
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var geocoder: CLGeocoder?
    
    //MARK: - Defaults methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureLocationManager()
    }
    
    //MARK: - IBActions
    @IBAction func goToLocation(_ sender: Any) {
        locationManager?.requestLocation()
    }
    
    @IBAction func trackLocation(_ sender: Any) {
        route?.map = nil
        route = GMSPolyline()
        route?.strokeColor = .systemBlue
        route?.strokeWidth = 5
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager?.startUpdatingLocation()
        stopUpdateLocationButton.isHidden = false
    }
    
    @IBAction func stopUpdateLocation(_ sender: Any) {
        locationManager?.stopUpdatingLocation()
        stopUpdateLocationButton.isHidden = true
        guard let routePath = routePath else { return }
        addRouteToMap(routePath)
        route?.map = nil
    }
    
    @IBAction func zoomPlus(_ sender: Any) {
        changeZoom(0.5)
    }
    
    @IBAction func zoomMinus(_ sender: Any) {
        changeZoom(-0.5)
    }
    
    //MARK: - Private methods
    private func configureMap() {
        let camera = GMSCameraPosition()
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.requestAlwaysAuthorization()
    }
    
    private func addMarker(_ position: CLLocationCoordinate2D, _ icon: UIImage?) {
        let marker = GMSMarker(position: position)
        marker.icon = icon
        marker.map = mapView
    }
    
    private func changeZoom(_ value: Float) {
        mapView.animate(toZoom: mapView.camera.zoom + value)
    }
    
    private func addRouteToMap(_ routePath: GMSMutablePath) {
        let route = GMSPolyline()
        route.strokeColor = .systemGreen
        route.strokeWidth = 8
        let startPoint = routePath.coordinate(at: 0)
        let finishPoint = routePath.coordinate(at: routePath.count() - 1)
        addMarker(startPoint, UIImage(named: "finish-flag"))
        addMarker(finishPoint, UIImage(named: "finish-flag"))
        route.path = routePath
        route.map = mapView
        
        guard let pathForBounds = route.path else { return }
        let routeBounds = GMSCoordinateBounds(path: pathForBounds)
        let cameraUpdate = GMSCameraUpdate.fit(routeBounds)
        mapView.animate(with: cameraUpdate)
    }
    
}

//MARK: - Extensions
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        if let manualMarker = manualMarker {
            manualMarker.position = coordinate
        } else {
//            addMarker(coordinate, nil)
            let marker = GMSMarker(position: coordinate)
            marker.icon = UIImage(named: "pin")
            marker.map = mapView
            self.manualMarker = marker
        }
        print(coordinate)
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        routePath?.add(location.coordinate)
        route?.path = routePath
        
        let position = GMSCameraPosition(target: location.coordinate, zoom: 17)
        mapView.animate(to: position)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
