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
                    List{
                        ForEach(trip.member, id:\.id){ member in
                            NavigationLink(destination:MemberView(trip:trip, member:member)){
                                HStack{
                                    Text(member.nickname)
                                    Spacer()
                                    Text(String(toPay(member:member)))
                                        .foregroundColor(toPay(member: member)<0 ? Color.red : Color.green)
                                    
                                }
                            }
                        }
                    }
                }
                NavigationLink(destination:MemberAddView(trip:trip)){Text("+")}
                
            }
            Section(header: Text("会計")) {
                if (trip.reimbursement.count == 0) {
                    Text("会計情報がありません")
                } else {
                    List{
                        ForEach(trip.reimbursement, id:\.id){ (reimbursement: Reimbursement) in
                            NavigationLink(destination:ReimbursementView(reimbursement:reimbursement)){
                                Text(String(reimbursement.amount) + "円" + " " + String(reimbursement.title))
                            }
                        }
                    }
                }
                NavigationLink(destination:ReimbursementAddView(trip:trip)){Text("+")}
            }
            Section(header: Text("精算済")) {
                if (trip.payOff.count == 0) {
                    Text("精算情報がありません")
                } else {
                    List{
                        ForEach(trip.payOff, id:\.id){ (payOff: PayOff) in
                            Group{
                                if(payOff.payer != nil && payOff.recipient != nil){
                                    Text(String(payOff.amount) + "円 " + payOff.payer!.nickname + "から" + payOff.recipient!.nickname )
                                }else{
                                    Text(String(payOff.amount) + "円")
                                }
                            }
                        }
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

