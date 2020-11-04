//
//  TripListView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/04.
//

import SwiftUI
import RealmSwift

struct TripListView: View {
    @ObservedObject var trips = Trips()
    var body: some View {
        List {
            ForEach(trips.trips, id: \.id) { trips in
                        Button(action: {
                        }) {
                            Text("\(trips.name)")
                        }
                    }
                }
    }
}

class Trips: ObservableObject {
    @Published var trips: [Trip] = (try? Realm().objects(Trip.self).map { $0 }) ?? []
}
