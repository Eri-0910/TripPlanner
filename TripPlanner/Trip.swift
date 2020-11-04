//
//  Trip.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/04.
//

import Foundation
import RealmSwift

class Trip: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var start = Date()
    @objc dynamic var end = Date()
    let schedule = List<Schedule>()
}
