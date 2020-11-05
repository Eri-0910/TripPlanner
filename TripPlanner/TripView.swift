//
//  TripView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/05.
//

import SwiftUI
import RealmSwift

struct TripView: View {
    var trip = Trip()
    var body: some View {
        TabView{
            ScheduleListView(trip:trip)
                .tabItem { Text("スケジュール") }
            AccountView(trip:trip)
                .tabItem { Text("会計") }
        }.navigationBarTitle("\(trip.name)")
    }
}
struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(trip: (try? Realm().objects(Trip.self).map { $0 }[0] )!)
    }
}
