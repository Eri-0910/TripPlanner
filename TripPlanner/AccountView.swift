//
//  AccountView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/05.
//

import SwiftUI
import RealmSwift

struct AccountView: View {
    var trip = Trip()
    var body: some View {
        Form{
            Section(header: Text("メンバー")) {
                if (trip.member.count == 0) {
                    Text("メンバーがいません")
                } else {
                    ForEach(trip.member, id:\.id){ member in
                        Text(member.nickname)
                    }
                }
                NavigationLink(destination:MemberAddView(trip:trip)){Text("+")}
                
            }
            Section(header: Text("会計")) {
                if (trip.reimbursement.count == 0) {
                    Text("会計情報がありません")
                } else {
                    ForEach(trip.reimbursement, id:\.id){ (reimbursement: Reimbursement) in
                        Text(String(reimbursement.amount))
                    }
                }
                NavigationLink(destination:ReimbursementAddView(trip:trip)){Text("+")}
            }
            Section(header: Text("精算済")) {
                if (trip.payOff.count == 0) {
                    Text("精算情報がありません")
                } else {
                    ForEach(trip.payOff, id:\.id){ (payOff: PayOff) in
                        Text(String(payOff.amount))
                    }
                }
                NavigationLink(destination:PayOffAddView(trip:trip)){Text("+")}
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}

