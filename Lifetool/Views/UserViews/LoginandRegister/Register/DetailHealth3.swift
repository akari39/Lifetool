//
//  DetailHealth3.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/4/14.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

struct DetailHealth3: View {
    @Binding var isDoctor:Bool
    @Binding var isTrained:Bool
    
    init(isDoctor:Binding<Bool>,isTrained:Binding<Bool>){
        UITableView.appearance().separatorColor = .clear
        UITableViewCell.appearance().backgroundColor = .none
        UITableView.appearance().backgroundColor = .none
        self._isDoctor = isDoctor
        self._isTrained = isTrained
    }
    
    var body: some View {
        ZStack{
            Color("Background")
            VStack{
                Toggle(isOn: $isDoctor) {
                    Text("我是医护工作者")
                }

                Toggle(isOn: $isTrained) {
                    Text("我接受过急救培训")
                }
                Spacer()
            }.padding()
        }
    }
}

//struct DetailHealth3_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailHealth3()
//    }
//}
