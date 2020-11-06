//
//  ReimbursementAddView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/06.
//

import SwiftUI
import RealmSwift

struct ReimbursementAddView: View {
    var trip = Trip()
    @State dynamic var amount = ""
    @State dynamic var title = ""
    @State var debtors:Set<Int> = Set<Int>()
    @State var creditor:Int?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form{
            TextField("タイトルを入力", text:$title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("支払金額を入力", text:$amount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(UIKeyboardType.numberPad)
            Section(header: Text("立て替えた人")){
                List(selection: $creditor) {
                    ForEach(trip.member, id: \.self) { member in
                        MultipleSelectionRow(
                            title:member.nickname,
                            isSelected:(creditor==member.id),
                            action: {
                                if creditor==member.id {
                                    creditor=nil
                                }
                                else {
                                    creditor=member.id
                                }})
                    }
                }
            }
            Section(header: Text("立て替えてもらった人")){
                List{
                    ForEach(trip.member, id: \.self) { member in
                        MultipleSelectionRow(
                            title:member.nickname,
                            isSelected:debtors.contains(member.id),
                            action: {
                                if self.debtors.contains(member.id) {
                                    self.debtors.subtract( self.debtors.filter { $0 == member.id })
                                }
                                else {
                                    self.debtors.insert(member.id)
                                }})
                    }
                }
            }
            Button(action: {addReimbursementToTrip(trip:trip, title: title, amount: amount, debtors:debtors, creditor:creditor ?? 0)
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("登録")
            })
        }
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title).background(self.isSelected ? Color.gray : Color.white)
            }
        }
    }
}

struct SingleSelectionRow: View {
    var title: String
    var SelectedTitle: String
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title).background(self.title == self.SelectedTitle ? Color.gray : Color.white)
            }
        }
    }
}

func addReimbursementToTrip(trip: Trip, title: String, amount: String, debtors:Set<Int>, creditor:Int) -> Void {
    let realm = try! Realm()
    let reimbursement = Reimbursement()
    if(!title.isEmpty && (Int(amount) != nil) && !debtors.isEmpty ){
        reimbursement.title = title
        reimbursement.amount = Int(amount)!
        let debtors_member = realm.objects(Member.self).filter("id IN %@", debtors)
        reimbursement.debtor.append(objectsIn:debtors_member)
        let creditor_member = realm.objects(Member.self).filter("id == %@", creditor)
        reimbursement.creditor = creditor_member.first
        print("here")
        reimbursement.save()
        try! realm.write {
            trip.reimbursement.append(reimbursement)
        }
        print("added")
    }else{
        print("added failed")
    }
}

struct ReimbursementAddView_Previews: PreviewProvider {
    static var previews: some View {
        ReimbursementAddView(trip: (try? Realm().objects(Trip.self).map { $0 }[0] )!)
    }
}
