//
//  Member.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/06.
//
//

import Foundation
import RealmSwift

class Member: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var nickname = ""
    let trip = LinkingObjects(fromType: Trip.self, property: "member")
    
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
