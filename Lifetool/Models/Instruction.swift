//
//  Instruction.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/3/26.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import Foundation
import SwiftUI

struct InstructionContent:Codable,Hashable,Identifiable{
    var id:Int
    var title:String?
    var content:String
}

struct Instruction:Codable,Hashable,Identifiable{
    var id:Int
    var title:String
    var describe:String?
    var warning:String?
    var content:[InstructionContent]?
}
