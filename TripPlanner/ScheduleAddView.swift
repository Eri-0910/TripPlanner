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
        let id = schedule.save()
        try! realm.write {
            trip.schedule.append(schedule)
        }
        print("added")
        
        //　通知設定に必要なクラスをインスタンス化
        let trigger: UNNotificationTrigger
        let content = UNMutableNotificationContent()
        var notificationTime = DateComponents()
        
        let calendar = Calendar.current
        // トリガー設定
        notificationTime.year =
            calendar.component(.year, from: trip.start)
        notificationTime.month =
            calendar.component(.month, from: trip.start)
        notificationTime.day =
            calendar.component(.day, from: trip.start) + Int(day)! - 1
        notificationTime.hour =
            calendar.component(.hour, from: start)
        notificationTime.minute =
            calendar.component(.minute, from: start)
        trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)

        // 通知内容の設定
        content.title = title + "の時間です"
        content.body = memo
        content.sound = UNNotificationSound.default

        // 通知スタイルを指定
        let request = UNNotificationRequest(identifier: "\(id)", content: content, trigger: trigger)
        // 通知をセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        //　通知設定に必要なクラスをインスタンス化
        let trigger2: UNNotificationTrigger
        let content2 = UNMutableNotificationContent()
        var notificationTime2 = DateComponents(timeZone:TimeZone(identifier: "Asia/Tokyo"))
        
        let calendar2 = Calendar.current
        let before = calendar2.date(byAdding:.minute, value: -30, to:start)
        print(calendar2.component(.minute, from: before!))
        // トリガー設定
        notificationTime2.year =
            calendar2.component(.year, from: trip.start)
        notificationTime2.month =
            calendar2.component(.month, from: trip.start)
        notificationTime2.day =
            calendar2.component(.day, from: trip.start) + Int(day)! - 1
        notificationTime2.hour =
            calendar2.component(.hour, from: before!)
        notificationTime2.minute =
            calendar2.component(.minute, from: before!)
        trigger2 = UNCalendarNotificationTrigger(dateMatching: notificationTime2, repeats: false)

        // 通知内容の設定
        content2.title = title + "まで30分です"
        content2.body = memo
        content2.sound = UNNotificationSound.default

        // 通知スタイルを指定
        let request2 = UNNotificationRequest(identifier: "\(id)before30", content: content2, trigger: trigger2)
        // 通知をセット
        UNUserNotificationCenter.current().add(request2, withCompletionHandler: nil)
        
        //　通知設定に必要なクラスをインスタンス化
        let trigger3: UNNotificationTrigger
        let content3 = UNMutableNotificationContent()
        var notificationTime3 = DateComponents(timeZone:TimeZone(identifier: "Asia/Tokyo"))
        
        let calendar3 = Calendar.current
        let before3 = calendar3.date(byAdding:.minute, value: -10, to:start)
        // トリガー設定
        notificationTime3.year =
            calendar3.component(.year, from: trip.start)
        notificationTime3.month =
            calendar3.component(.month, from: trip.start)
        notificationTime3.day =
            calendar3.component(.day, from: trip.start) + Int(day)! - 1
        notificationTime3.hour =
            calendar3.component(.hour, from: before3!)
        notificationTime3.minute =
            calendar3.component(.minute, from: before3!)
        trigger3 = UNCalendarNotificationTrigger(dateMatching: notificationTime3, repeats: false)

        // 通知内容の設定
        content3.title = title + "まで10分です"
        content3.body = memo
        content3.sound = UNNotificationSound.default

        // 通知スタイルを指定
        let request3 = UNNotificationRequest(identifier: "\(id)before10", content: content3, trigger: trigger3)
        // 通知をセット
        UNUserNotificationCenter.current().add(request3, withCompletionHandler: nil)
        
        print("<Pending request identifiers>")
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("identifier:\(request.identifier)")
                print("  title:\(request.content.title)")

                if request.trigger is UNCalendarNotificationTrigger {
                    let trigger = request.trigger as! UNCalendarNotificationTrigger
                    print("  <CalendarNotification>")
                    let components = DateComponents(calendar: Calendar.current, year: trigger.dateComponents.year, month: trigger.dateComponents.month, day: trigger.dateComponents.day, hour: trigger.dateComponents.hour, minute: trigger.dateComponents.minute)
                    print("    Scheduled Date:\(components.date!)")
                    print("    Reperts:\(trigger.repeats)")
                    
                } else if request.trigger is UNTimeIntervalNotificationTrigger {
                    let trigger = request.trigger as! UNTimeIntervalNotificationTrigger
                    print("  <TimeIntervalNotification>")
                    print("    TimeInterval:\(trigger.timeInterval)")
                    print("    Reperts:\(trigger.repeats)")
                }
                print("----------------")
            }
        }
    }else{
        print("added failed")
    }
}
