//
//  UserInfoSheet.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/4/11.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI
import Combine

struct KeyboardHost<Content: View>: View {
    let view: Content

    @State private var keyboardHeight: CGFloat = 0

    private let showPublisher = NotificationCenter.Publisher.init(
        center: .default,
        name: UIResponder.keyboardWillShowNotification
    ).map { (notification) -> CGFloat in
        if let rect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            return rect.size.height
        } else {
            return 0
        }
    }

    private let hidePublisher = NotificationCenter.Publisher.init(
        center: .default,
        name: UIResponder.keyboardWillHideNotification
    ).map {_ -> CGFloat in 0}

    // Like HStack or VStack, the only parameter is the view that this view should layout.
    // (It takes one view rather than the multiple views that Stacks can take)
    init(@ViewBuilder content: () -> Content) {
        view = content()
    }

    var body: some View {
        Form {
            view
        }
        .padding(.bottom,keyboardHeight-42)
        .onReceive(showPublisher.merge(with: hidePublisher)) { (height) in
            self.keyboardHeight = height
        }
    }
}

struct UserInfoSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var user:User
    @Binding var status:String
    @Binding var isSkip:Bool
    @Binding var showSheet:Bool
    
    @State var username = ""
    @State var email = ""
    @State var phone = ""
    @State var name = ""
    @State var password = ""
    @State var sex = ""
    @State var bloodType = ""
    @State var date = ""
    @State var otherdate = ""
    @State var height = ""
    @State var weight = ""
    @State var diseaseHistory = ""
    @State var anaphylaxis = ""
    
    @State var isDoctor = false
    @State var isTrained = false
    
    @State var isDoctorText = ""
    @State var isTrainedText = ""
    
    @State var showSexPicker = false
    @State var showBloodTypePicker = false
    @State var showBornDatePicker = false
    
    @State var edit:Bool = false
    @State var editText:String = "编辑"
    
    @State var showlogoutalert = false
    @State var showdeletealert = false

    
    @State var sexSelected:Int = 0
    @State var bloodTypeSelected:Int = 0
    
    @State var isShowalert = false
    
    var sexs  = ["（可选）","男","女"]
    var bloodTypes = ["（可选）","A+","A-","B+","B-","AB+","AB-","O+","O-"]
    
    init(user:Binding<User>,status:Binding<String>,isSkip:Binding<Bool>,showSheet:Binding<Bool>){
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.label as Any]
        UINavigationBar.appearance().backgroundColor = .systemBackground
        
        UITableViewCell.appearance().backgroundColor = .systemBackground
        UITableView.appearance().backgroundColor = .systemBackground
        
        self._showSheet = showSheet
        self._user = user
        self._status = status
        self._isSkip = isSkip
        self.loadtoUI()
        
    }
    
    func loadtoUI(){
        if self.user.userSkill?.isDoctor == "1"{
            self.isDoctor = true
            self.isDoctorText = "是"
        } else {
            self.isDoctor = false
            self.isDoctorText = "否"
        }
        
        if self.user.userSkill?.isTrained == "1"{
            self.isTrained = true
            self.isTrainedText = "是"
        } else {
            self.isTrained = false
            self.isTrainedText = "否"
        }
        
        self.username = self.user.userAccount?.User_name ?? ""
        self.email = self.user.userAccount?.User_email ?? ""
        self.phone = self.user.userAccount?.User_phone ?? ""
        
        self.name = self.user.userHealth?.Name ?? ""
        self.date = self.user.userHealth?.BornYear ?? ""
        for sex in 0...sexs.count-1{
            if self.user.userHealth?.Sex == sexs[sex]{
                self.sexSelected = sex
            } else {
                self.sexSelected = 0
            }
        }

        for bloodtype in 0...bloodTypes.count-1{
            if self.user.userHealth?.BloodType == bloodTypes[bloodtype]{
                self.bloodTypeSelected = bloodtype
            } else {
                self.bloodTypeSelected = 0
            }
        }
        
        self.height = self.user.userHealth?.Height ?? ""
        self.weight = self.user.userHealth?.Weight ?? ""
        self.diseaseHistory = self.user.userHealth?.DiseaseHistory ?? ""
        self.anaphylaxis = self.user.userHealth?.Anaphylaxis ?? ""
    }
    
    var body:some View{
        NavigationView{
                KeyboardHost{
                    if !isSkip{
                    Section(header:Text("帐户信息").font(.headline)){
                        HStack{
                            Text("用户名").font(.headline)
                            Spacer()
                            if edit{
                                CustomTextField(keyboardType: .asciiCapable, text: $username, placeholder: "请输入用户名", isSafeText: false, textAlignment: .right)
                            } else {
                                Text(user.userAccount?.User_name ?? "未设定")
                            }
                        }
                        
                        HStack{
                            Text("邮箱").font(.headline)
                            Spacer()
                            if edit{
                                CustomTextField(keyboardType: .emailAddress, text: $email, placeholder: "请输入邮箱", isSafeText: false, textAlignment: .right)
                            } else {
                                Text(user.userAccount?.User_email ?? "未设定")
                            }
                        }
                        
                        HStack{
                            Text("手机号").font(.headline)
                            Spacer()
                            if edit{
                                CustomTextField(keyboardType: .emailAddress, text: $phone, placeholder: "请输入手机号", isSafeText: false, textAlignment: .right)
                            } else {
                                Text(user.userAccount?.User_phone ?? "未设定")
                            }
                        }
                    }
                    
                    Section(header:Text("健康资料").font(.headline)){
                        HStack{
                            Text("姓名").font(.headline)
                            Spacer()
                            if edit{
                                CustomTextField(keyboardType: .emailAddress, text: $name, placeholder: "请输入姓名（可选）", isSafeText: false, textAlignment: .right)
                            } else {
                                Text(user.userHealth?.Name ?? "未设定")
                            }
                        }
                        
                        HStack{
                            Text("性别").font(.headline)
                            Spacer()
                            if edit{
                                Button(action:{self.showSexPicker=true}){
                                    ZStack{
                                        TextFieldWithPickerAsInputView(data: sexs, placeholder: "", selectionIndex: $sexSelected, isFirstResponder: $showSexPicker, date: $otherdate, pickerType: .defaultpicker).frame(width: 0, height: 0)
                                        Text(sexs[sexSelected])
                                    }
                                }
                            } else {
                                Text(user.userHealth?.Sex ?? "未设定")
                            }
                        }
                        
                        HStack{
                            Text("血型").font(.headline)
                            Spacer()
                            if edit{
                                Button(action:{self.showBloodTypePicker=true}){
                                    ZStack{
                                        TextFieldWithPickerAsInputView(data: bloodTypes, placeholder: "", selectionIndex: $bloodTypeSelected, isFirstResponder: $showBloodTypePicker, date: $otherdate, pickerType: .defaultpicker).frame(width: 0, height: 0)
                                        Text(bloodTypes[bloodTypeSelected])
                                    }
                                }
                            }else{
                                Text(user.userHealth?.BloodType ?? "未设定")
                            }
                        }
                        
                        HStack{
                            Text("出生日期").font(.headline)
                            Spacer()
                            if edit{
                                Button(action:{self.showBornDatePicker=true}){
                                    ZStack{
                                        TextFieldWithPickerAsInputView(data: bloodTypes, placeholder: "", selectionIndex: $bloodTypeSelected, isFirstResponder: $showBornDatePicker, date: $date, pickerType: .date).frame(width: 0, height: 0)
                                        Text(date)
                                    }
                                }
                            }else{
                                Text(user.userHealth?.BornYear ?? "未设定")
                            }
                        }
                        
                        HStack{
                            Text("身高（厘米）").font(.headline)
                            Spacer()
                            if edit{
                                CustomTextField(keyboardType: .decimalPad, text: $height, placeholder: "请输入身高（可选）", isSafeText: false, textAlignment: .right)
                            } else {
                                Text(user.userHealth?.Height ?? "未设定")
                            }
                        }
                        
                        HStack{
                            Text("体重（千克）").font(.headline)
                            Spacer()
                            if edit{
                                CustomTextField(keyboardType: .decimalPad, text: $weight, placeholder: "请输入体重（可选）", isSafeText: false, textAlignment: .right)
                            } else {
                                Text(user.userHealth?.Weight ?? "未设定")
                            }
                        }
                        
                        VStack(alignment: .leading){
                            Text("病史").font(.headline)
                            Spacer()
                            if edit{
                                CustomTextField(keyboardType: .default, text: $diseaseHistory, placeholder: "请输入病史（可选）", isSafeText: false, textAlignment: .left)
                            } else {
                                Text(user.userHealth?.DiseaseHistory ?? "未设定")
                            }
                        }
                        
                        VStack(alignment: .leading){
                            Text("过敏反应").font(.headline)
                            Spacer()
                            if edit{
                                CustomTextField(keyboardType: .default, text: $anaphylaxis, placeholder: "请输入过敏反应（可选）", isSafeText: false, textAlignment: .left)
                            } else {
                                Text(user.userHealth?.Anaphylaxis ?? "未设定")
                            }
                        }
                    }
                    
                    Section{
                        if edit{
                            Toggle(isOn: $isDoctor) {
                                Text("我是医护工作者")
                            }
                        } else {
                            HStack{
                                Text("我是医护工作者")
                                Spacer()
                                Text(isDoctorText)
                            }
                        }

                        if edit{
                            Toggle(isOn: $isTrained) {
                                Text("我接受过急救培训")
                            }
                        } else {
                            HStack{
                                Text("我接受过急救培训")
                                Spacer()
                                Text(isTrainedText)
                            }
                        }
                    }
                    
                    Section{
                        Button(action:{
                            self.showlogoutalert = true
                        }){
                            HStack{
                                Spacer()
                                Text("注销")
                                Spacer()
                            }.alert(isPresented: $showlogoutalert) {
                                Alert(title: Text("确定要注销吗？"), message: Text(""),primaryButton:
                                    .default(Text("取消"),action: {
                                        self.showlogoutalert = false
                                    }),secondaryButton:
                                    .destructive(Text("确定").bold(), action: {
                                        let domain = Bundle.main.bundleIdentifier!
                                        UserDefaults.standard.removePersistentDomain(forName: domain)
                                        self.showlogoutalert = false
                                        self.presentationMode.wrappedValue.dismiss()
                                        self.showSheet = false
                                        self.status = "Login"
                                })
                                )
                            }
                        }.foregroundColor(Color.blue)
                    }
                    
                    Section{
                        Button(action:{
                            self.showdeletealert = true
                        }){
                            HStack{
                                Spacer()
                                Text("删除")
                                Spacer()
                            }.alert(isPresented: $showdeletealert) {
                                Alert(title: Text("确定要删除帐号吗？"), message: Text(""),primaryButton:
                                    .default(Text("取消"),action: {
                                        self.showdeletealert = false
                                    }),secondaryButton:
                                    .destructive(Text("确定").bold(), action: {
                                        self.user.deleteUser(deleteUserCompletionHandler: { _,execSuccessfully  in
                                            if execSuccessfully{
                                                let domain = Bundle.main.bundleIdentifier!
                                                UserDefaults.standard.removePersistentDomain(forName: domain)
                                                self.showdeletealert = false

                                                self.showSheet = false
                                                self.presentationMode.wrappedValue.dismiss()
                                                self.status = "Login"
                                            }
                                        })
                                    })
                                )
                            }
                        }.foregroundColor(Color.red)
                    }} else {
                        Button(action:{
                            self.presentationMode.wrappedValue.dismiss()
                            self.status = "Login"

                        }){
                            VStack(alignment: .center){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20).fill(Color("ThemeColor")).frame(width:110,height: 40)
                                    Text("登录")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color.white)
                                }
                            }
                        }
                    }
                    }.onAppear(perform: {
                        self.loadtoUI()
                    })
                    
                .navigationBarTitle("帐户")
                .navigationBarItems(leading: Button(action:{
                    if self.edit{
                        self.editText = "编辑"
                        self.edit = false
                    } else {
                        self.editText = "取消"
                        self.edit = true
                        
                        if self.height == "未设定"{
                            self.height = ""
                            
                        }
                        if self.weight == "未设定"{
                            self.weight = ""
                        }
                    }
                }){
                    if !isSkip{
                        Text(editText)
                    }
                },trailing:
                    Button(action:{
                        if self.edit{
                            
                            self.user.userAccount?.User_name = self.username
                            self.user.userAccount?.User_email = self.email
                            self.user.userAccount?.User_phone = self.phone
                            
                            self.user.userHealth?.Name = self.name
                            self.user.userHealth?.BornYear = self.date
                            if self.sexs[self.sexSelected] == "（可选）"{
                                self.user.userHealth?.Sex = ""
                            } else {
                                self.user.userHealth?.Sex = self.sexs[self.sexSelected]
                            }
                            if self.bloodTypes[self.bloodTypeSelected] == "（可选）"{
                                self.user.userHealth?.BloodType = ""
                            } else {
                                self.user.userHealth?.BloodType = self.bloodTypes[self.bloodTypeSelected]
                            }
                            
                            self.user.userHealth?.Height = self.height
                            self.user.userHealth?.Weight = self.weight
                            self.user.userHealth?.DiseaseHistory = self.diseaseHistory
                            self.user.userHealth?.Anaphylaxis = self.anaphylaxis
                            
                            if self.isDoctor{
                                self.user.userSkill?.isDoctor = "1"
                            } else {
                                self.user.userSkill?.isDoctor = "0"
                            }
                            
                            if self.isTrained {
                                self.user.userSkill?.isTrained = "1"
                            } else {
                                self.user.userSkill?.isTrained = "0"
                            }
                            
                            self.user.changeAccount(changeAccountCompletionHandler: {CA_accountExist,CA_execSuccessfully in
                                self.user.changeHealth(changeHealthCompletionHandler: { CH_accountExist,CH_execSuccessfully in
                                    self.user.changeSkill(changeSkillCompletionHandler: {CS_accountExist,CS_execSuccessfully in
                                        if CA_accountExist && CA_execSuccessfully && CH_accountExist && CH_execSuccessfully && CS_accountExist && CS_execSuccessfully{
                                                self.editText = "编辑"
                                                self.loadtoUI()
                                                self.edit = false
                                        } else {
                                            self.isShowalert = true
                                        }
                                    })
                            })})
                            
                        } else {
                            self.presentationMode.wrappedValue.dismiss()
                            
                        }
                    }){
                        Text("完成")
                    }.alert(isPresented: $isShowalert){
                        Alert(title: Text("修改失败"), message: Text(""), dismissButton: .default(Text("好")))
                    }
                )
        }
    }
}

//struct UserInfoSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        UserInfoSheet()
//    }
//}
