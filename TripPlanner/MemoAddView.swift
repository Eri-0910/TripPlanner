//
//  MemoAddView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/07.
//

import SwiftUI
import RealmSwift

struct MemoAddView: View {
    var trip = Trip()
    @State dynamic var title = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            TextField("メモを入力", text:$title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {addMemoToTrip(trip:trip, title: title)
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("登録")
            })
        }
    }
}

func addMemoToTrip(trip: Trip, title: String) -> Void {
    let realm = try! Realm()
    let memo = Memo()
    if(!title.isEmpty){
        memo.title = title
        memo.save()
        try! realm.write {
            trip.memo.append(memo)
        }
        print("added")
    }else{
        print("added failed")
    }
}
