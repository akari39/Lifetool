//
//  RegisterPassword.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/4/2.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

struct RegisterPassword: View {
    
    @Binding var name:String
    @Binding var password:String
    @Binding var password_confirm:String
    
    @State var userAccountTypeLabelText:String = ""
    @Binding var pickerSelection:Int
    @State var showAccountTypePicker:Bool = false
    @State var userAccountTypes = ["用户名","邮箱","手机号"]
    @State var date:String = ""
    
    var body: some View {
        ZStack{
            Color("Background").edgesIgnoringSafeArea(.all)
            List{
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        Text("帐户类型")
                            .font(.headline)
                        Button(action:{
                            self.showAccountTypePicker = true
                        }){
                                ZStack{
                                    RoundedRectangle(cornerRadius:20).fill(Color.black.opacity(5/100)).frame(height:45)
                                    Text(userAccountTypes[pickerSelection])
                                    TextFieldWithPickerAsInputView(data: userAccountTypes, placeholder: "", selectionIndex: $pickerSelection, isFirstResponder: $showAccountTypePicker, date: $date, pickerType: .defaultpicker)
                                }
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                    
                    VStack(alignment: .leading){
                        Text(userAccountTypes[pickerSelection])
                            .font(.headline)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(5/100))
                            .frame(height: 45)
                            if userAccountTypes[pickerSelection] == "邮箱"{
                                CustomTextField(keyboardType: .emailAddress, text: $name,placeholder: "输入注册帐号", isSafeText: false, textAlignment: .left)
                                .frame(height: 40, alignment: .leading).padding(.horizontal, 10.0)
                            } else {
                                CustomTextField(keyboardType: .asciiCapable, text: $name,placeholder: "输入注册帐号", isSafeText: false, textAlignment: .left)
                                .frame(height: 40, alignment: .leading).padding(.horizontal, 10.0)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading){
                        Text("密码")
                            .font(.headline)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(5/100)).frame(height: 45)
                            CustomTextField(keyboardType: .asciiCapable, text: $password, placeholder: "输入密码", isSafeText: true, textAlignment: .left)
                            .frame(height: 40, alignment: .leading).padding(.horizontal, 10.0)
                        }
                    }
                    
                    VStack(alignment: .leading){
                        Text("确认密码")
                            .font(.headline)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(5/100)).frame(height: 45)
                            CustomTextField(keyboardType: .asciiCapable, text: $password_confirm, placeholder: "再次输入密码", isSafeText: true, textAlignment: .left)
                            .frame(height: 40, alignment: .leading).padding(.horizontal, 10.0)
                        }
                    }
                }
            }.listRowBackground(Color("Background"))
        }
    }
}

//struct RegisterPassword_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterPassword()
//    }
//}
