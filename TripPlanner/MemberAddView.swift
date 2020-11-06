//
//  MemberAddView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/06.
//

import SwiftUI
import RealmSwift

struct MemberAddView: View {
    var trip = Trip()
    @State dynamic var nickname = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            TextField("メンバー名を入力", text:$nickname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {addMemberToTrip(trip:trip, nickname: nickname)
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("登録")
            })
        }
    }
}

func addMemberToTrip(trip: Trip, nickname: String) -> Void {
    let realm = try! Realm()
    let member = Member()
    if(!nickname.isEmpty){
        member.nickname = nickname
        member.save()
        try! realm.write {
            trip.member.append(member)
        }
        print("added")
    }else{
        print("added failed")
    }
}

struct MemberAddView_Previews: PreviewProvider {
    static var previews: some View {
        MemberAddView(trip: (try? Realm().objects(Trip.self).map { $0 }[0] )!)
    }
}
