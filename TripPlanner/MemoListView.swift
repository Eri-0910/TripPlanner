//
//  MemoListView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/07.
//

import SwiftUI
import RealmSwift

struct MemoListView: View {
    @ObservedObject var trip = Trip()
    @State var deleteMemo: Memo?
    
    func indexSave(offsets: IndexSet) {
        self.deleteMemo = trip.memo[offsets.first!]
    }
    
    var body: some View {
            List {
                ForEach(0..<trip.memo.count, id:\.self) { index in
                    Button(action: {
                        let realm = try! Realm()
                        print(trip.memo[index].done)
                        try! realm.write {
                            trip.memo[index].setValue(!trip.memo[index].done, forKeyPath: "done")
                        }
                    }) {
                        Text(trip.memo[index].title)
                            .foregroundColor(trip.memo[index].done ? Color.gray : Color.black)
                    }
                }.onDelete(perform: indexSave)
                .alert(item: self.$deleteMemo) { memo in
                                Alert(title: Text(memo.title + "を削除しますか？"),
                                      primaryButton: .destructive(Text("削除")) {
                                        let realm = try! Realm()
                                        try! realm.write {
                                            realm.delete(memo)
                                        }
                                        self.deleteMemo = nil
                                    },
                                      secondaryButton: .cancel(Text("キャンセル")) {
                                    }
                                )
                            }
            }.overlay(
                NavigationLink(destination:MemoAddView(trip:trip)){
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
