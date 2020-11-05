//
//  ScheduleListView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/05.
//

import SwiftUI
import RealmSwift

struct ScheduleListView: View {
    var trip = Trip()
    var body: some View {
            List {
                ForEach(trip.schedule, id: \.id) { schedule in
                    Text("\(schedule.title)")
                }
            }
    }
}

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView()
    }
}
