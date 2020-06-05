//
//  DetailEdit.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/4/2.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

struct BottomSheetPicker: View {
    @Binding var selection:Int
    var options:[String]

    var body: some View {
            ZStack(alignment: .center){
                Color.gray.edgesIgnoringSafeArea(.all)
                Group {
                    Picker(selection: $selection, label: Text("Strength")) {
                        ForEach(0 ..< options.count) {
                            Text(self.options[$0])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .foregroundColor(.white)
                    .padding()

                .labelsHidden()
                }
            }
    }
}

struct DetailHealth1: View {
    
    var sex = ["(可选)","男","女"]
    @Binding var selectedSex:Int
    @State var showSexPicker = false
    
    var bloodType = ["(可选)","A+","A-","B+","B-","AB+","AB-","O+","O-"]
    @Binding var selectedBloodType:Int
    @State var showBTPicker = false
    
    @State var showDatePicker = false
    @Binding var date:String
    
    init(selectedSex:Binding<Int>,selectedBloodType:Binding<Int>,date:Binding<String>){
        UITableView.appearance().separatorColor = .clear
        UITableViewCell.appearance().backgroundColor = .none
        UITableView.appearance().backgroundColor = .none
        self._selectedSex = selectedSex
        self._selectedBloodType = selectedBloodType
        self._date = date
    }
    
    var body: some View {
        ZStack{
            Color("Background").edgesIgnoringSafeArea(.all)
            List{
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        Text("性别")
                            .font(.headline)
    //                            UIApplication.shared.windows[0].rootViewController?.present(alertHC, animated: true){
    //                            Text(sex[selectedSex]).fontWeight(.heavy)
    //                                .frame(height: 40, alignment: .leading).padding(.horizontal, 10.0).multilineTextAlignment(.leading)
                            
                        Button(action:{
                            self.showSexPicker = true
                        }){
                            ZStack{
                                RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(5/100))
                                .frame(height: 45)
                                Text(sex[selectedSex])
                                TextFieldWithPickerAsInputView(data: sex, placeholder: "请选择您的生理性别", selectionIndex: $selectedSex, isFirstResponder: $showSexPicker, date: $date, pickerType:.defaultpicker)
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                    
                    VStack(alignment: .leading){
                        Text("血型")
                            .font(.headline)
                        Button(action:{
                            self.showBTPicker = true
                        }){
                            ZStack{
                                RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(5/100))
                                .frame(height: 45)
                                Text(bloodType[selectedBloodType])
                                TextFieldWithPickerAsInputView(data: bloodType, placeholder: "请选择您的血型", selectionIndex: $selectedBloodType, isFirstResponder: $showBTPicker, date: $date, pickerType: .defaultpicker)
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                    
                    VStack(alignment: .leading){
                        Text("出生年月")
                            .font(.headline)
                        Button(action:{
                            self.showDatePicker = true
                        }){
                            ZStack{
                                RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(5/100))
                                .frame(height: 45)
                                Text(date)
                                TextFieldWithPickerAsInputView(data: bloodType, placeholder: "请选择您的出生年月", selectionIndex: $selectedBloodType, isFirstResponder: $showDatePicker, date: $date, pickerType: .date)
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
        }
    }
}

//struct DetailEdit_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailHealth1()
//    }
//}
