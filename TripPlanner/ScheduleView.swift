//
//  ScheduleView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/05.
//

import SwiftUI
import RealmSwift

struct ScheduleView: View {
    var schedule = Schedule()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Form{
            HStack{
                Text("タイトル")
                Text(schedule.title)
            }
            HStack{
                Text("日付")
                Text(schedule.day + "日目")
            }
            HStack{
                Text("時刻")
                Text(timeToString(time:schedule.start))
                Text("〜")
                Text(timeToString(time:schedule.end))
            }
            HStack{
                Text("メモ")
                Text(schedule.memo)
            }
            HStack{
                Text("TEL")
                Text(schedule.tell)
            }
            HStack{
                Text("住所")
                Text(schedule.address)
            }
        }
    }
}
struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}

