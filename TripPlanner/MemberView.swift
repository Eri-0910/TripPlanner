//
//  MemberView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/06.
//

import SwiftUI
import RealmSwift

struct MemberView: View {
    var trip = Trip()
    var member = Member()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Form{
            Section(header: Text("名前")){
                Text(String(member.nickname))
            }
            Section(header: Text("総立替金額")){
                Text(String(getReimbursement(member:member)))
            }
            Section(header: Text("総受領金額")){
                Text(String(getRecipied(member:member)))
            }
            Section(header: Text("総支払金額")){
                Text(String(getPayed(member:member)))
            }
            Section(header: Text("総使用額")){
                Text(String(getUsed(member:member)))
            }
            Section(header: Text("現状")){
                Text(String(toPay(member: member)))
                    .foregroundColor(toPay(member: member)<0 ? Color.red : Color.green)
            }
            Button(action: {
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(member)
                }
                self.presentationMode.wrappedValue.dismiss()
            }){Text("削除")}
        }
    }
}

func getReimbursement(member:Member) -> Int {
    let realm = try! Realm()
    let reimbursements = realm.objects(Reimbursement.self).filter("creditor == %@ AND ANY trip == %@", member, member.trip.first!)
    var sum = 0
    for r in reimbursements {
        sum += r.amount
    }
    return sum
}

func getPayed(member:Member) -> Int {
    let realm = try! Realm()
    let payoffs = realm.objects(PayOff.self).filter("payer == %@ AND ANY trip == %@", member, member.trip.first!)
    var sum = 0
    for p in payoffs {
        sum += p.amount
    }
    return sum
}

func getRecipied(member:Member) -> Int {
    let realm = try! Realm()
    let payoffs = realm.objects(PayOff.self).filter("recipient == %@ AND ANY trip == %@", member, member.trip.first!)
    var sum = 0
    for p in payoffs {
        sum += p.amount
    }
    return sum
}

func getUsed(member:Member) -> Int {
    let realm = try! Realm()
    let reimbursements = realm.objects(Reimbursement.self).filter("ANY debtor == %@ AND ANY trip == %@", member, member.trip.first!)
    var sum = 0
    for r in reimbursements {
        sum += r.amount/r.debtor.count
    }
    return sum
}

func toPay(member:Member) -> Int {
    let reimbursement = getReimbursement(member:member)
    let payed = getPayed(member:member)
    let recipied = getRecipied(member:member)
    let used = getUsed(member:member)
    return used - (reimbursement + payed - recipied)
}
