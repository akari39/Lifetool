//
//  PickerTextfield.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/4/13.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

enum PickerType{
    case defaultpicker
    case date
}

struct TextFieldWithPickerAsInputView : UIViewRepresentable {

    var data : [String]
    var placeholder : String

    @Binding var selectionIndex:Int
    @Binding var isFirstResponder:Bool
    @Binding var date:String

    private let textField = UITextField()
    private let picker = UIPickerView()
    private let datepicker = UIDatePicker()
    private let toolbar = UIToolbar()
    
    var pickerType:PickerType
    
    func makeCoordinator() -> TextFieldWithPickerAsInputView.Coordinator {
          Coordinator(self)
     }
    
    func action(sender:UIButton!){
        textField.resignFirstResponder()
    }

    func makeUIView(context: UIViewRepresentableContext<TextFieldWithPickerAsInputView>) -> UITextField {
        switch(pickerType){
            case .defaultpicker:
                picker.delegate = context.coordinator
                picker.dataSource = context.coordinator
                picker.backgroundColor = .systemBackground
                textField.inputView = picker
            case .date:
                datepicker.backgroundColor = .systemBackground
                datepicker.locale = Locale(identifier: "zh_CN")
                datepicker.datePickerMode = .date
                datepicker.maximumDate = Date()
                datepicker.addTarget(context.coordinator, action: #selector(context.coordinator.dateChange(datePicker:)), for: .valueChanged)
                textField.inputView = datepicker
        }
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "完成", style: UIBarButtonItem.Style.done, target: context.coordinator, action: #selector(context.coordinator.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItem.Style.plain, target: context.coordinator, action: #selector(context.coordinator.cancelPicker))
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: true)
        textField.inputAccessoryView = toolbar
        textField.placeholder = placeholder
        textField.delegate = context.coordinator
        textField.isHidden = true
        return textField
    }
    
     func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TextFieldWithPickerAsInputView>) {
        if isFirstResponder{
            uiView.becomeFirstResponder()
        }
     }

     class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate , UITextFieldDelegate {

        private let parent : TextFieldWithPickerAsInputView
        private var selectedIndex = 0
        
        init(_ textfield : TextFieldWithPickerAsInputView) {
           self.parent = textfield
        }

        @objc func dateChange(datePicker:UIDatePicker){
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = formatter.string(from:datePicker.date)
            parent.date = date
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return self.parent.data.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return self.parent.data[row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.$selectionIndex.wrappedValue = row
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            self.parent.textField.resignFirstResponder()
            self.parent.isFirstResponder = false
        }
        
        @objc func cancelPicker(){
            switch(parent.pickerType){
            case .defaultpicker:
                self.parent.$selectionIndex.wrappedValue = 0
            case .date:
                parent.date = ""
            }
            parent.textField.endEditing(true)
        }
        
        @objc func donePicker(){
            parent.textField.endEditing(true)
        }
    }
}
