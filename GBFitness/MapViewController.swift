//
//  MapViewController.swift
//  GBFitness
//
//  Created by Максим Лосев on 30.11.2022.
//

import UIKit
import GoogleMaps
import CoreLocation
import RealmSwift

class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var stopUpdateLocationButton: UIButton!
    @IBOutlet weak var trackLocationButton: UIButton!
    
    // MARK: - Properties
    let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    var manualMarker: GMSMarker?
    var startMarker: GMSMarker?
    var finishMarker: GMSMarker?
    var locationManager: CLLocationManager?
    var route: GMSPolyline?
    var routeLast: GMSPolyline?
    var routePath: GMSMutablePath?
    var geocoder: CLGeocoder?
    var dataService = DataService()
    var isLocationUpdating = false
    
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
        isLocationUpdating = true
        trackLocationButton.isHidden = true
        stopUpdateLocationButton.isHidden = false
    }
    
    @IBAction func showPreviousRoute(_ sender: Any) {
        if isLocationUpdating == true {
            let alert = UIAlertController(title: "СООБЩЕНИЕ",
                                          message: "Отслеживание местоположения будет остановлено",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.stopUpdateLocation()
            }))
            self.present(alert, animated: true)
        } else {
            addRouteToMap()
        }
    }
    
    @IBAction func stopUpdateLocation(_ sender: Any) {
        stopUpdateLocation()
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
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
//        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.requestAlwaysAuthorization()
    }
    
    private func stopUpdateLocation() {
        locationManager?.stopUpdatingLocation()
        isLocationUpdating = false
        stopUpdateLocationButton.isHidden = true
        trackLocationButton.isHidden = false
        guard let routePath = routePath else { return }
        
        let routePathRealm = RoutePathRealm()
        routePathRealm.id = 1
        routePathRealm.name = Date()
        for item in 0 ..< routePath.count() {
            let coordinate2D = Coordinate2D()
            coordinate2D.latitude = routePath.coordinate(at: item).latitude
            coordinate2D.longitude = routePath.coordinate(at: item).longitude
            routePathRealm.coordinates.append(coordinate2D)
        }
        dataService.saveRouteData(routePathRealm)
        route?.map = nil
        addRouteToMap()
    }
    
    private func addMarker(_ position: CLLocationCoordinate2D, _ icon: UIImage?) {
        let marker = GMSMarker(position: position)
        marker.icon = icon
        marker.map = mapView
    }
    
    private func configureMarker(_ marker: GMSMarker) {
        marker.icon = UIImage(named: "finish-flag")
    }
    
    private func changeZoom(_ value: Float) {
        mapView.animate(toZoom: mapView.camera.zoom + value)
    }
    
    private func addRouteToMap() {
        
        routeLast?.map = nil
        startMarker?.map = nil
        finishMarker?.map = nil
        let routePreviousPath = GMSMutablePath()
        
        do {
            let realm = try Realm()
            guard let routePathRealm = realm.objects(RoutePathRealm.self).first else { return }
            for item in routePathRealm.coordinates {
                routePreviousPath.add(CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))
            }
        } catch {
            print(error)
        }
        
        routeLast = GMSPolyline()
        routeLast?.strokeColor = .systemGreen
        routeLast?.strokeWidth = 8
        let startPoint = routePreviousPath.coordinate(at: 0)
        let finishPoint = routePreviousPath.coordinate(at: routePreviousPath.count() - 1)
        startMarker = GMSMarker(position: startPoint)
        startMarker?.icon = UIImage(named: "finish-flag")
        startMarker?.map = mapView
        finishMarker = GMSMarker(position: finishPoint)
        finishMarker?.icon = UIImage(named: "finish-flag")
        finishMarker?.map = mapView
        routeLast?.path = routePreviousPath
        routeLast?.map = mapView
        
        guard let pathForBounds = routeLast?.path else { return }
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
