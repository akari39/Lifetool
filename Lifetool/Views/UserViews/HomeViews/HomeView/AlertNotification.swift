//
//  AlertNotification.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/4/2.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

struct AlertNotification: View {
    var body: some View {
        ZStack(alignment:.center){
            RoundedRectangle(cornerRadius: 16).fill(Color("ThemeColor")).frame(width: 162, height: 32)
            HStack{
                Spacer()
                Image(systemName: "bell.fill")
                    .resizable()
                    .foregroundColor(Color.white)
                Spacer()
                Text("您的附近有求助")
                Spacer()
            }
        }.frame(width: 162, height: 32, alignment: .center)
    }
}

struct AlertNotification_Previews: PreviewProvider {
    static var previews: some View {
        AlertNotification()
    }
}
