//
//  DetailHealth2.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/4/13.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

struct DetailHealth2: View {
    @Binding var name:String
    @Binding var height:String
    @Binding var weight:String
    @Binding var diseaseHistory:String
    @Binding var anaphylaxis:String
    
    init(name:Binding<String>,height:Binding<String>,weight:Binding<String>,diseaseHistory:Binding<String>,anaphylaxis:Binding<String>){
        UITableView.appearance().separatorColor = .clear
        UITableViewCell.appearance().backgroundColor = .none
        UITableView.appearance().backgroundColor = .none
        self._name = name
        self._height = height
        self._weight = weight
        self._diseaseHistory = diseaseHistory
        self._anaphylaxis = anaphylaxis
    }
    
    var body: some View {
        ZStack{
            Color("Background").edgesIgnoringSafeArea(.all)
            List{
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        Text("姓名")
                            .font(.headline)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(5/100))
                            .frame(height: 45)
                            CustomTextField(keyboardType: .default, text: $name,placeholder: "输入姓名（可选）", isSafeText: false, textAlignment: .left)
                            .frame(height: 40, alignment: .leading).padding(.horizontal, 10.0)
                        }
                    }
                    
                    VStack(alignment: .leading){
                        Text("身高（厘米）")
                            .font(.headline)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(5/100))
                            .frame(height: 45)
                            CustomTextField(keyboardType: .decimalPad, text: $height,placeholder: "输入身高（可选）", isSafeText: false, textAlignment: .left)
                            .frame(height: 40, alignment: .leading).padding(.horizontal, 10.0)
                        }
                    }
                    
                    VStack(alignment: .leading){
                        Text("体重（千克）")
                            .font(.headline)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(5/100)).frame(height: 45)
                            CustomTextField(keyboardType: .decimalPad, text: $weight, placeholder: "输入体重（可选）", isSafeText: false, textAlignment: .left)
                            .frame(height: 40, alignment: .leading).padding(.horizontal, 10.0)
                        }
                    }
                    
                    VStack(alignment: .leading){
                        Text("病史")
                            .font(.headline)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(5/100)).frame(height: 45)
                            CustomTextField(keyboardType: .default, text: $diseaseHistory, placeholder: "输入病史（可选）", isSafeText: false, textAlignment: .left)
                            .frame(height: 40, alignment: .leading).padding(.horizontal, 10.0)
                        }
                    }
                    
                    VStack(alignment: .leading){
                        Text("过敏反应")
                            .font(.headline)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(5/100)).frame(height: 45)
                            CustomTextField(keyboardType: .default, text: $diseaseHistory, placeholder: "输入过敏反应（可选）", isSafeText: false, textAlignment: .left)
                            .frame(height: 40, alignment: .leading).padding(.horizontal, 10.0)
                        }
                    }
                }
            }
        }
    }
}

//struct DetailHealth2_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailHealth2()
//    }
//}
