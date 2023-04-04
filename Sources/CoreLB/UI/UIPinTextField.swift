//
//  UIPinTextField.swift
//  GraphicMotionApplication
//
//  Created by ICoon on 01.04.2022.
//  Copyright © 2022 ipinguin_linuxoid. All rights reserved.
//

import UIKit


public protocol UIPinTextFiedlDelegate: AnyObject{
    func onPinEntered(pin: String)
}

/**
    inherit example:
 
     open override func customizePin(textField: UITextField){
         textField.textColor = UIColor.red
         textField.borderStyle = .line
         
         textField.placeholder = "-"
         textField.text = "-"
         textField.font = UIFont.systemFont(ofSize: 20)
         textField.borderStyle = .roundedRect
 }

 */

@IBDesignable
class UIPinTextField: UIView, UITextFieldDelegate {
    
    
    
    @IBInspectable var count: UInt = 3
    
    @IBInspectable var spacing: UInt = 10
    
    @IBInspectable var textFieldSize: UInt = 50
    
    @IBInspectable var verticalInset: UInt = 5
    
    private var fields: [UITextField] = []
    
    private var code: String = ""
    
    weak var deleagate: UIPinTextFiedlDelegate? = nil
    
    
    
    
    public override func prepareForInterfaceBuilder(){
        super.prepareForInterfaceBuilder()
        self.invalidateIntrinsicContentSize()
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    public override var intrinsicContentSize: CGSize {
        let height: CGFloat = CGFloat(textFieldSize + (verticalInset * 2))
        return CGSize(width: self.bounds.width, height: height)
    }
    
    private func setup(){
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    public override func draw(_ rect: CGRect) {
        
        if(count < 1){
            fatalError("here should to be at least one pin")
        }
        
        if(!validateParams()){
            fatalError("wanted widht more than allowed")
        }
        
        
        let mainField = prepareMainTextField()
        addSubview(mainField)
        
        var x: Int = calculateStartX()
        for _ in 0...count - 1 {
            let field = createTextField(x: x, y: Int(verticalInset), size: Int(textFieldSize))
            fields.append(field)
            self.addSubview(field)
            x += Int(textFieldSize + spacing)
        }
        
    }
    
    private func validateParams() -> Bool{
        return self.bounds.width > CGFloat(getAllMeasuredWidth())
    }
    
    
    private func calculateStartX() -> Int{
        let half: CGFloat = (self.bounds.width - CGFloat(getAllMeasuredWidth()) ) / 2
        return Int(half)
    }
    
    private func getAllMeasuredWidth() -> UInt{
        return getCellsWidth() + getSpaceWidth()
    }
    
    private func getSpaceWidth() -> UInt {
        return  (count - 1) * spacing
    }
    
    private func getCellsWidth() -> UInt {
        return count * textFieldSize
    }
    
    
    open func customizePin(textField: UITextField){
        textField.placeholder = "X"
        textField.text = "X"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.line
       
    }
    
    private func prepareMainTextField() -> UITextField{
        let textField = UITextField(frame: self.frame)
            textField.keyboardType = UIKeyboardType.phonePad
            textField.tintColor = .clear
            textField.textColor = .clear
            textField.delegate = self
        return textField
    }
    
    private func createTextField(x: Int, y: Int, size: Int) -> UITextField{
        let frameTF = CGRect(x: x, y: y, width: size, height: size)
        let myTextField: UITextField = UITextField(frame: frameTF);
            myTextField.isUserInteractionEnabled = false
            myTextField.textAlignment = .center
        
        self.customizePin(textField: myTextField)
        
        return myTextField
        
    }
    
    
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if (string.count ) == 0 {
            if(code.count > 0){
                fields[code.count - 1].text?.removeAll()
                code.removeLast()
            }
        } else{
            if(code.count < count){
                fields[code.count].text = string
                code.append(string)
            }
        }
        
        
        if code.count == count {
            textField.text = textField.text! + string
            textField.resignFirstResponder()
            self.deleagate?.onPinEntered(pin: code)
        }

        return code.count <= count
        
    }
    
    
}
