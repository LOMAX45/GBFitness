//
//  RoutePathRealm.swift
//  GBFitness
//
//  Created by Максим Лосев on 02.12.2022.
//

import Foundation
import RealmSwift
import GoogleMaps

class Coordinate2D: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
}

class RoutePathRealm: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name = Date()
    let coordinates = List<Coordinate2D>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
