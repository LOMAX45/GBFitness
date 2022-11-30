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
        guard let location = locationManager?.location else { return }
        mapView.animate(toLocation: location.coordinate)
    }
    
    @IBAction func trackLocation(_ sender: Any) {
        route?.map = nil
        route = GMSPolyline()
        route?.strokeColor = .systemBlue
        route?.strokeWidth = 5
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager?.requestLocation()
        if let startPoint = locationManager?.location?.coordinate {
            addMarker(startPoint)
        }
        locationManager?.startUpdatingLocation()
        stopUpdateLocationButton.isHidden = false
    }
    
    @IBAction func stopUpdateLocation(_ sender: Any) {
        locationManager?.stopUpdatingLocation()
        stopUpdateLocationButton.isHidden = true
        locationManager?.requestLocation()
        if let startPoint = locationManager?.location?.coordinate {
            addMarker(startPoint)
        }
    }
    
    @IBAction func zoomPlus(_ sender: Any) {
        changeZoom(0.5)
    }
    
    @IBAction func zoomMinus(_ sender: Any) {
        changeZoom(-0.5)
    }
    
    //MARK: - Private methods
    private func configureMap() {
        let camera = GMSCameraPosition(target: coordinate, zoom: 13)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    private func addMarker(_ position: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: position)
        marker.icon = UIImage(named: "pin")
        marker.map = mapView
    }
    
    private func changeZoom(_ value: Float) {
        mapView.animate(toZoom: mapView.camera.zoom + value)
    }
}

//MARK: - Extensions
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        if let manualMarker = manualMarker {
            manualMarker.position = coordinate
        } else {
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
        
        let position = GMSCameraPosition(target: location.coordinate, zoom: 15)
        mapView.animate(to: position)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
