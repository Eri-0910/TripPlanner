//
//  PayOffAddView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/06.
//

import SwiftUI
import RealmSwift

struct PayOffAddView: View {
    var trip = Trip()
    @State dynamic var amount = ""
    @State var payer:Int?
    @State var recipient:Int?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            TextField("立替金額を入力", text:$amount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Section{
                Text("払った人")
                List(selection: $payer) {
                    ForEach(trip.member, id: \.self) { member in
                        MultipleSelectionRow(
                            title:member.nickname,
                            isSelected:(payer==member.id),
                            action: {
                                if payer==member.id {
                                    payer=nil
                                }
                                else {
                                    payer=member.id
                                }})
                    }
                }
            }
            Section{
                Text("もらった人")
                List(selection: $recipient) {
                    ForEach(trip.member, id: \.self) { member in
                        MultipleSelectionRow(
                            title:member.nickname,
                            isSelected:(recipient==member.id),
                            action: {
                                if recipient==member.id {
                                    recipient=nil
                                }
                                else {
                                    recipient=member.id
                                }})
                    }
                }
            }
            Button(action: {addPayOffToTrip(trip:trip, amount: amount, payer:payer ?? 0, recipient:recipient ?? 0)
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("登録")
            })
        }
    }
}

func addPayOffToTrip(trip: Trip, amount: String, payer:Int, recipient:Int) -> Void {
    let realm = try! Realm()
    let payOff = PayOff()
    if(Int(amount) != nil ){
        payOff.amount = Int(amount)!
        let payer_member = realm.objects(Member.self).filter("id == %@", payer)
        payOff.payer = payer_member.first
        let recipient_member = realm.objects(Member.self).filter("id == %@", recipient)
        payOff.recipient = recipient_member.first
        print("here")
        payOff.save()
        try! realm.write {
            trip.payOff.append(payOff)
        }
        print("added")
    }else{
        print("added failed")
    }
}
struct PayOffAddView_Previews: PreviewProvider {
    static var previews: some View {
        PayOffAddView(trip: (try? Realm().objects(Trip.self).map { $0 }[0] )!)
    }
}
