//
//  TripAddView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/04.
//

import SwiftUI
import RealmSwift

struct TripAddView: View {
    @State private var name = ""
    @State private var start = Date()
    @State private var end = Date()
    @State private var isShowingStartPicker = false
    @State private var isShowingEndPicker = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            Text("タイトル")
            TextField("", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text("開始")
            Button(action: {
                self.isShowingStartPicker.toggle()
                self.isShowingEndPicker = false
                       }) {
                Text("\(dateToString(date:self.start))")
                               .padding()
                       }
            Text("終了")
            Button(action: {
                           self.isShowingEndPicker.toggle()
                self.isShowingStartPicker = false
                       }) {
                           Text("\(dateToString(date:self.end))")
                               .padding()
                       }
            Button(action: {addCharactorToDB(name: name, start: start, end: end)
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("登録")
            })
            .padding(.bottom, 10.0)
            UnderPicker(selection: self.$start, isShowing: self.$isShowingStartPicker)
                            .animation(.linear)
                            .offset(y: self.isShowingStartPicker ? 0 : UIScreen.main.bounds.height)
                .overlay( UnderPicker(selection: self.$end, isShowing: self.$isShowingEndPicker)
                            .animation(.linear)
                            .offset(y: self.isShowingEndPicker ? 0 : UIScreen.main.bounds.height))
           
        }
        
    }
}

struct UnderPicker: View {
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
            }
            DatePicker("", selection: $selection, displayedComponents: .date)
            .frame(width: 200)
        }
    }
}

struct TripAddView_Previews: PreviewProvider {
    static var previews: some View {
        TripAddView()
    }
}

func dateToString(date : Date) -> String {
    let formatter: DateFormatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    let formattedDate = formatter.string(from: date)
    return formattedDate
}

func addCharactorToDB(name: String, start: Date, end: Date) -> Void {
    let trip = Trip()
    print(name)
    if(!name.isEmpty){
        trip.name = name
        trip.start = start
        trip.end = end
        trip.save()
        print("added")
    }else{
        print("added failed")
    }
}
