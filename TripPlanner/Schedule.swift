//
//  Schedule.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/04.
//
//

import Foundation
import RealmSwift

class Schedule: Object, Identifiable {
    
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var memo = ""
    @objc dynamic var day = ""
    @objc dynamic var start = Date()
    @objc dynamic var end = Date()
    @objc dynamic var tell = ""
    @objc dynamic var address = ""
    let trip = LinkingObjects(fromType: Trip.self, property: "schedule")
    
    func save() {
           let realm = try! Realm()
           if realm.isInWriteTransaction {
               if self.id == 0 { self.id = self.createNewId() }
               realm.add(self)
           } else {
               try! realm.write {
                   if self.id == 0 { self.id = self.createNewId() }
                   realm.add(self)
               }
           }
       }

   private func createNewId() -> Int {
       let realm = try! Realm()
       return (realm.objects(type(of: self).self).sorted(byKeyPath: "id").last?.id ?? 0) + 1
   }
    
    override static func primaryKey() -> String? {
           return "id"
       }
}
