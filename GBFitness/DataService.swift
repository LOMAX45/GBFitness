//
//  DataService.swift
//  GBFitness
//
//  Created by Максим Лосев on 02.12.2022.
//

import Foundation
import RealmSwift

class DataService {
    
    func saveRouteData (_ coordinates: RoutePathRealm) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(coordinates, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
}
