//
//  Trip.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/04.
//

import Foundation
import RealmSwift

class Trip: Object, Identifiable{
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var start = Date()
    @objc dynamic var end = Date()
    let schedule = List<Schedule>()
    let member = List<Member>()
    let reimbursement = List<Reimbursement>()
    let payOff = List<PayOff>()
    let memo = List<Memo>()
    
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
