//
//  TripListView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/04.
//

import SwiftUI
import RealmSwift

struct TripListView: View {
    @ObservedObject var tripsObj = Trips()
    var body: some View {
        NavigationView{
            List {
                ForEach(tripsObj.trips, id: \.name) { trip in
                    NavigationLink(destination:TripView()){
                        VStack {
                            Text("\(trip.name)")
                        }
                    }
                }
            }
        }
    }
}

class Trips: ObservableObject {
    //@Published var trips: [Trip] = (try? Realm().objects(Trip.self).map { $0 }) ?? []
    @Published var trips: Results<Trip> = try! Realm().objects(Trip.self)
}

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        TripListView()
    }
}
