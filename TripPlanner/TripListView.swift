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
    @State var deleteTrip: Trip?
    
    func indexSave(offsets: IndexSet) {
        self.deleteTrip = tripsObj.trips![offsets.first!]
    }
    
    var body: some View {
        NavigationView{
            List {
                ForEach(0..<tripsObj.trips!.count, id: \.self) { index in
                    NavigationLink(destination:TripView(trip:tripsObj.trips![index])){
                        VStack {
                            Text("\(tripsObj.trips![index].name)")
                        }
                    }
                }.onDelete(perform: indexSave)
                .alert(item: self.$deleteTrip) { trip in
                    Alert(title: Text(trip.name + "を削除しますか？"),
                          primaryButton: .destructive(Text("削除")) {
                            let realm = try! Realm()
                            try! realm.write {
                                realm.delete(trip)
                            }
                        },
                          secondaryButton: .cancel(Text("キャンセル")) {
                        }
                    )
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
    @Published var trips = (try? Realm().objects(Trip.self))
        private var notificationTokens: [NotificationToken] = []

        init() {
            // DBに変更があったタイミングでtripsの変数に値を入れ直す
            notificationTokens.append(trips!.observe { change in
                switch change {
                case let .initial(results):
                    self.trips = results
                case let .update(results, _, _, _):
                    self.trips = results
                case let .error(error):
                    print(error.localizedDescription)
                }
            })
        }

        deinit {
            notificationTokens.forEach { $0.invalidate() }
        }
}

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        TripListView()
    }
}
