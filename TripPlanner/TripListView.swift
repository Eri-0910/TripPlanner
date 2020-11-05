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
                ForEach(tripsObj.trips, id: \.id) { trip in
                    NavigationLink(destination:TripView(trip:trip)){
                        VStack {
                            Text("\(trip.name)")
                        }
                    }
                }
            }.overlay(
                NavigationLink(destination:TripAddView()){
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
}

class Trips: ObservableObject {
    @Published var trips: [Trip] = (try? Realm().objects(Trip.self).map { $0 }) ?? []
}

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        TripListView()
    }
}
