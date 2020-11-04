//
//  Schedule.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/04.
//
//

import Foundation
import RealmSwift

class Schedule: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var memo = ""
    @objc dynamic var start = Date()
    @objc dynamic var end = Date()
}
