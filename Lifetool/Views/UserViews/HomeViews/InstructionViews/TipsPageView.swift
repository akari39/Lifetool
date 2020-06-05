//
//  TipsPageView.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/4/14.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

struct AEDPageView: View {
    let aedguideData:[Instruction] = load("AED.json")
    var body: some View {
        ZStack{
            Color("Background").edgesIgnoringSafeArea(.all)
            InstructionContainer(instructions: aedguideData)
        }
    }
}

struct CPRPageView: View {
    let cprguideData:[Instruction] = load("CPR.json")
    var body: some View {
        ZStack{
            Color("Background").edgesIgnoringSafeArea(.all)
            InstructionContainer(instructions: cprguideData)
        }
    }
}

struct TipsPageView_Previews: PreviewProvider {
    static var previews: some View {
        AEDPageView()
    }
}
