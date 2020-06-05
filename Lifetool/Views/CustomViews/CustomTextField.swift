//
//  CustomTextField.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/4/11.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI
import UIKit

struct CustomTextField: UIViewRepresentable {
    
    let keyboardType:UIKeyboardType
    @Binding var text:String
    var placeholder:String
    var isSafeText:Bool
    var textAlignment:NSTextAlignment
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame:.zero)
        textField.keyboardType = keyboardType
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.returnKeyType = .done
        textField.textAlignment = self.textAlignment
        if isSafeText{
            textField.isSecureTextEntry = true
        }
        
        _ = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: textField)
            .compactMap {
                guard let field = $0.object as? UITextField else {
                    return nil
                }
                return field.text
            }
            .sink {
                self.text = $0
            }
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject,UITextFieldDelegate{
        var parent:CustomTextField
        
        init(_ textField:CustomTextField){
            self.parent = textField
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            UIApplication.shared.windows.forEach{$0.endEditing(true)}
            return true
        }
    }
}
