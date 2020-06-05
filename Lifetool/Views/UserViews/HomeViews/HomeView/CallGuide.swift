//
//  CallGuide.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/3/17.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

struct CallGuide: View {
    let callguideData:[Instruction] = load("CallGuide.json")
    
    var body: some View{
        ZStack{
            Color("Background").edgesIgnoringSafeArea(.all)
            InstructionContainer(instructions: callguideData)
        }
    }
}

struct CallGuide_Previews: PreviewProvider {
    static var previews: some View {
        CallGuide()
    }
}
