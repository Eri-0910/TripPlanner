//
//  ReimbursementView.swift
//  TripPlanner
//
//  Created by 山河絵利奈 on 2020/11/06.
//

import SwiftUI
import RealmSwift

struct ReimbursementView: View {
    var reimbursement = Reimbursement()
    var body: some View {
        Form{
            Section(header: Text("タイトル")){
                Text(String(reimbursement.title))
            }
            Section(header: Text("支払金額")){
                Text(String(reimbursement.amount))
            }
            Section(header: Text("立て替えた人")){
                if(reimbursement.creditor != nil){
                    Text(reimbursement.creditor!.nickname)
                }else{
                    Text("不明")
                }
            }
            Section(header: Text("立て替てもらった人")){
                List{
                    ForEach(reimbursement.debtor, id: \.self) { member in
                        Text(member.nickname)
                    }
                }
            }
        }
    }
}
