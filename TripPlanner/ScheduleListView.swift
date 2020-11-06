//
//  ScheduleListView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/05.
//

import SwiftUI
import RealmSwift

struct ScheduleListView: View {
    @ObservedObject var trip = Trip()
    @State var deleteSchedule: Schedule?
    
    func indexSave(offsets: IndexSet) {
        self.deleteSchedule = trip.schedule[offsets.first!]
    }
    
    var body: some View {
            List {
                ForEach(0..<trip.schedule.count, id:\.self) { index in
                    NavigationLink(destination:ScheduleView(schedule:trip.schedule[index])){
                        HStack{
                            VStack{
                                Text("\(timeToString(time:trip.schedule[index].start))")
                                Text("\(timeToString(time:trip.schedule[index].end))")
                            }
                            Text("\(trip.schedule[index].title)")
                        }
                    }
                }.onDelete(perform: indexSave)
                .alert(item: self.$deleteSchedule) { schedule in
                                Alert(title: Text(schedule.title + "を削除しますか？"),
                                      primaryButton: .destructive(Text("削除")) {
                                        let realm = try! Realm()
                                        try! realm.write {
                                            realm.delete(schedule)
                                        }
                                        self.deleteSchedule = nil
                                        print(trip.schedule)
                                    },
                                      secondaryButton: .cancel(Text("キャンセル")) {
                                    }
                                )
                            }
            }.overlay(
                NavigationLink(destination:ScheduleAddView(trip:trip)){
                    VStack {
                        Text("+")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                    }
                    .frame(minWidth: 70.0, minHeight: 70.0)
                    .background(Color.green)}
                    .cornerRadius(35.0)
                    .padding()
                    ,alignment: .bottomTrailing)
    }
}

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView()
    }
}
