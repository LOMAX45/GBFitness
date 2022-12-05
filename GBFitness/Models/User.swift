//
//  User.swift
//  GBFitness
//
//  Created by Максим Лосев on 03.12.2022.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""
    
    override static func primaryKey() -> String? {
        return "login"
    }
    
}
