//
//  ContentView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/04.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack{
                TripListView().overlay(
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
