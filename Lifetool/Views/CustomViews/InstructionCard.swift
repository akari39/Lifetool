//
//  InstructionCard.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/3/28.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

struct InstructionCardContentView: View {
    var content:InstructionContent
    var body: some View {
        VStack{
            VStack(alignment:.leading){
                if content.title != nil{
                    Text(content.title!).font(.title).fontWeight(.bold).foregroundColor(Color("ThemeColor"))
                    Spacer().frame(height: 5)
                }
                Text(content.content).font(.body).lineSpacing(3)
            }.padding()
        }.frame(width:4/5*UIScreen.main.bounds.width,alignment: .leading)
    }
}

struct InstructionCardView: View {
    
    var instruction:Instruction
    
    init(instruction:Instruction){
        UITableView.appearance().separatorColor = .clear
        UITableViewCell.appearance().backgroundColor = .none
        UITableView.appearance().backgroundColor = .none
        self.instruction=instruction
    }
    
    var body: some View {
        VStack(alignment:.leading){
            Text(instruction.title).font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(Color("ThemeColor"))
                .padding()
//            Spacer().frame(height: 10)
            if instruction.describe != nil{
                Text(instruction.describe!)
                    .font(.headline)
                    .padding([.top, .leading, .trailing])
            }
            if instruction.warning != nil{
                Text(instruction.warning!)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color("ThemeColor"))
            }
            if instruction.content != nil{
                List{
                    ForEach(instruction.content!) {content in
                        InstructionCardContentView(content: content)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("HighlightWhite")))
                    }
                }.listRowBackground(Color("Background"))
                .background(Color("Background"))
            }
        }.background(Color("Background"))
    }
}

struct ButtonContent: View {
    var body: some View {
        Image(systemName: "arrow.right")
            .resizable()
            .foregroundColor(Color.white)
            .frame(width: 20, height: 20)
            .padding()
            .background(Color("ThemeColor"))
            .cornerRadius(30)
    }
}

struct InstructionContainer: View {
    var instructions:[Instruction]
    var subviews=[UIHostingController<InstructionCardView>]()
    @State var currentPageIndex = 0
    
    init(instructions:[Instruction]){
        self.instructions = instructions
        for eachinstruction in self.instructions{
            self.subviews.append(UIHostingController(rootView: InstructionCardView(instruction: eachinstruction)))
        }
    }
    
    var body: some View {
        VStack(alignment:.leading){
            Text(String(currentPageIndex+1)+"/"+String(instructions.count))
                .foregroundColor(Color("ThemeColor"))
                .font(.title)
                .padding()
            if !subviews.isEmpty{
                InstructionPageViewController(currentPageIndex: $currentPageIndex, viewControllers: subviews)
                HStack{
                    PageControl(numberOFPages: subviews.count, currentPageIndex: $currentPageIndex).padding()
                    Spacer()
                    Button(action: {
                        if self.currentPageIndex+1 == self.subviews.count{
                            self.currentPageIndex = 0
                        } else {
                            self.currentPageIndex += 1
                        }
                    }) {
                        ButtonContent()
                        .padding()
                    }
                }
            }
        }
    }
}
