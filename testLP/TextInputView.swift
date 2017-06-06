//
//  TextInputView.swift
//  testLP
//
//  Created by Darius on 09/04/2017.
//  Copyright © 2017 Darius Prismontas. All rights reserved.
//

import UIKit


class TextInputView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    
    var messageInputField = GrowingTextView() // DynamicTextView? //UITextView() //GrowingTextView()
    let sendButton = SubmitButton()
    
    var heightConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //messageInputField = DynamicTextView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50), offset: 20)
        
        self.backgroundColor = .white //UIColor(white: 0.9, alpha: 1)
        
        self.addSubview(messageInputField)
        
        let line = UIView()
        line.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.addSubview(line)
        
        self.addSubview(sendButton)
        
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: line)
        
        self.addConstraintsWithFormat(format: "H:|-10-[v0]-10-[v1(70)]-10-|", views: messageInputField, sendButton)
        self.addConstraintsWithFormat(format: "V:|[v0(0.4)]-10-[v1]-10-|", views: line, messageInputField)
        self.addConstraintsWithFormat(format: "V:[v0(30)]-12-|", views: sendButton)
        
        // messageInputField?.minHeight = 20
        // messageInputField?.maxHeight = 50
        
        
        //messageInputField.backgroundColor = .white
        messageInputField.isEditable = true
        //messageInputField.isScrollEnabled = false
        //messageInputField.layer.cornerRadius = 10
        messageInputField.font = UIFont(name: "AvenirNext-Medium", size: 15)
        messageInputField.textColor = .darkGray
        messageInputField.maxHeight = 70.0
        messageInputField.trimWhiteSpaceWhenEndEditing = true
        messageInputField.placeHolder = "Say something..."
        
        //messageInputField.scrollsToTop = false
        
        //sdfdsfmessageInputField.addObserver(self, forKeyPath: "contentSize", options:[ NSKeyValueObservingOptions.old , NSKeyValueObservingOptions.new], context: nil)
        
        
        //self.addConstraintsWithFormat(format: "H:|-10-[v0]-10-[v1(70)]-10-|", views: messageInputField, sendButton)
        //self.addConstraintsWithFormat(format: "V:|-10-[v0(30)]", views: sendButton)
        //self.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: messageInputField)
        
        // self.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        //        self.addConstraintsWithFormat(format: "V:[v0(<=150@900,==50@700)]", views: self)
        
        //NSLayoutConstraint(item: self, attribute: .height, relatedBy: .lessThanOrEqual, toItem: self.superview, attribute: .height, multiplier: 1, constant: 150).isActive = true
        //
        //        NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: self.superview, attribute: .height, multiplier: 1, constant: 50).isActive = true
        
        //        heightConstraint = NSLayoutConstraint(item: messageInputField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        //        self.addConstraint(heightConstraint!)
        
        //self.messageInputField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class SubmitButton : UIButton {
    
    override var isEnabled: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitle("Send", for: .normal)
        //backgroundColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
        backgroundColor = UIColor.white
        
        titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 15)
        layer.cornerRadius = 15
        
        isEnabled = false
        
        
        setTitleColor(UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1), for: .normal)
        setTitleColor(UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 0.5), for: .disabled)
        
        
        //setTitleColor(UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1), for: .normal)
        //setTitleColor(UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 0.5), for: .disabled)
        
        
    }
    
    func updateBackgroundColor() {
        if isEnabled == true {
            //backgroundColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
            
        } else {
            //backgroundColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





/*

class SubmitButton : UIButton {
    
    override var isEnabled: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitle("Send", for: .normal)
        backgroundColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
        
        titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 12)
        layer.cornerRadius = 15
        
        isEnabled = false
        
    }
    
    func updateBackgroundColor() {
        if isEnabled == true {
            backgroundColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
        } else {
            backgroundColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class TestAccesoryView : UIView {
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if ((newSuperview) != nil) {
            
            print("1")
            let keyboardWindow = UIApplication.shared.windows.filter { (element) -> Bool in
                element.isKind(of: NSClassFromString("UIRemoteKeyboardWindow")!)
                }.first
            
            if let keyboardWindow = keyboardWindow {
                print("2")

                for subview in keyboardWindow.subviews {
                    for hostView in subview.subviews {
                        if hostView.isKind(of: NSClassFromString("UIInputSetHostView")!) {
                            //keyboardWindow = hostView
                            print("KEYBOARD FRAME ! ")
                            frame = hostView.frame
                            break
                        }
                    }
                }
            }
        }
        
        frame = CGRect(x: 100, y: 0, width: 414, height: 50)

        
    }
}

 */
