//
//  ScheduleAddView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/05.
//

import SwiftUI
import RealmSwift

struct ScheduleAddView: View {
    var trip = Trip()
    
    @State dynamic var title = ""
    @State dynamic var memo = ""
    @State dynamic var day = ""
    @State dynamic var start = Date()
    @State dynamic var end = Date()
    @State dynamic var tell = ""
    @State dynamic var address = ""
    @State private var isShowingStartPicker = false
    @State private var isShowingEndPicker = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView{
        VStack{
            Group{
                Text("タイトル")
                TextField("", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            Group{
                Text("日付")
                TextField("", text: $day)
                    .keyboardType(UIKeyboardType.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            HStack{
                VStack{
                    Text("開始")
                    Button(action: {
                        self.isShowingStartPicker.toggle()
                        self.isShowingEndPicker = false
                               }) {
                        Text("\(timeToString(time:self.start))")
                                       .padding()
                               }
                }
                Text("〜")
                VStack{
                    Text("終了")
                    Button(action: {
                                   self.isShowingEndPicker.toggle()
                        self.isShowingStartPicker = false
                               }) {
                                   Text("\(timeToString(time:self.end))")
                                       .padding()
                               }
                }
            }
            Group{
                Text("メモ")
                TextField("", text: $memo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            Group{
                Text("TEL")
                TextField("", text: $tell)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            Group{
                Text("住所")
                TextField("", text: $address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            Button(action: {addScheduleToTrip(trip:trip, title: title, start: start, end: end, memo: memo, tell: tell, address: address, day:day)
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("登録")
            })
            .padding(.bottom, 10.0)
        }.overlay(
            UnderTimePicker(selection: self.$start, isShowing: self.$isShowingStartPicker)
        .overlay( UnderTimePicker(selection: self.$end, isShowing: self.$isShowingEndPicker)))
        }
        
    }
}

struct UnderTimePicker: View {
    @Binding var selection: Date
    @Binding var isShowing: Bool
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                self.isShowing = false
            }) {
                HStack {
                    Spacer()
                    Text("閉じる")
                        .padding(.horizontal, 16)
                }
            }.background(Color.white)
            DatePicker("", selection: $selection, displayedComponents: .hourAndMinute)
                .background(Color.white)
        }
        .animation(.linear)
        .offset(y: self.isShowing ? 0 : UIScreen.main.bounds.height)
    }
}

struct ScheduleAddView_Previews: PreviewProvider {
    static var previews: some View {
        TripAddView()
    }
}

func timeToString(time : Date) -> String {
    let formatter: DateFormatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    let formattedTime = formatter.string(from: time)
    return formattedTime
}

func addScheduleToTrip(trip: Trip, title: String, start: Date, end: Date, memo: String, tell: String, address: String, day:String) -> Void {
    let realm = try! Realm()
    let schedule = Schedule()
    if(!title.isEmpty){
        schedule.title = title
        schedule.start = start
        schedule.end = end
        schedule.memo = memo
        schedule.tell = tell
        schedule.address = address
        schedule.day = day
        schedule.save()
        try! realm.write {
            trip.schedule.append(schedule)
        }
        print("added")
    }else{
        print("added failed")
    }
}
