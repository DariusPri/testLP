//
//  MessagesViewController.swift
//  UICVVariableHeightiOS8
//
//  Created by Darius on 25/05/2017.
//  Copyright © 2017 AlexisGallagher. All rights reserved.
//
//
//  MessagesViewController.swift
//  KSMD
//
//  Created by Darius on 30/03/2017.
//  Copyright © 2017 Digital Brand House. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {
    
    
    let containerView = UIView()
    
    var bottomLayoutConstraint : NSLayoutConstraint?
    var messagesTableVC = ConvoViewController(collectionViewLayout: ChatCollectionViewFlowLayout3())
    
    let loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    let inputFieldView = TextInputView()
    
    let userIconImageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userIconImageView.layer.borderColor = UIColor.white.cgColor
        userIconImageView.layer.masksToBounds = true
        userIconImageView.layer.cornerRadius = 20
        userIconImageView.layer.borderWidth = 2
        userIconImageView.contentMode = .scaleAspectFill
        
        
        addMessagesTable()
        
        automaticallyAdjustsScrollViewInsets = false
        
        
    }
    
    
    
    
    // MARK: - Setup and Nav Stuff
    
    
    func addMessagesTable() {
        
        inputFieldView.sendButton.addTarget(self, action: #selector(sendMessageButtonAction), for: .touchUpInside)
        inputFieldView.messageInputField.delegate = self
        
        
        containerView.addSubview(inputFieldView)
        containerView.addSubview(messagesTableVC.view)
        addChildViewController(messagesTableVC)
        messagesTableVC.didMove(toParentViewController: self)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: messagesTableVC.view)
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: inputFieldView)
        //containerView.addConstraintsWithFormat(format: "V:|[v0]|", views: messagesTableVC.view)
        containerView.addConstraintsWithFormat(format: "V:|[v0]", views: messagesTableVC.view)
        
        containerView.addConstraintsWithFormat(format: "V:[v0][v1]", views: messagesTableVC.view, inputFieldView)
        
        containerView.addConstraintsWithFormat(format: "V:[v0]|", views: inputFieldView)
        
        view.addSubview(containerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        view.addConstraintsWithFormat(format: "V:|[v0]", views: containerView)
        
        bottomLayoutConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomLayoutConstraint!)
        
        
    }
    
 
    
    func addSpinner() {
        containerView.addSubview(loadingSpinner)
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loadingSpinner, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loadingSpinner, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        loadingSpinner.startAnimating()
        
        containerView.backgroundColor = .clear
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.resignFirstResponder()
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
    }
    
    
    // MARK: - Private
    
    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        
        
        
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
        let animationCurve = UIViewAnimationOptions.init(rawValue: UInt(rawAnimationCurve))
        
        bottomLayoutConstraint?.constant = (-1)*(view.bounds.maxY - convertedKeyboardEndFrame.minY)
        
        print(bottomLayoutConstraint?.constant)
        if (bottomLayoutConstraint!.constant < CGFloat(0)) { messagesTableVC.scrollTableDown(animated: true) }
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.beginFromCurrentState, animationCurve], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func sendMessageButtonAction(sender : UIButton) {
        
        sender.isEnabled = false
        inputFieldView.messageInputField.text = ""
    }
    
}




extension MessagesViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if (textView.text.characters.count > 0) {
            inputFieldView.sendButton.isEnabled = true
        } else {
            inputFieldView.sendButton.isEnabled = false
        }
        
    }
    
}

extension MessagesViewController : GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        
        messagesTableVC.scrollTableDown(animated: true) // was true
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}














protocol GrowingTextViewDelegate: UITextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat)
}

class GrowingTextView: UITextView {
    
    // Maximum length of text. 0 means no limit.
    @IBInspectable open var maxLength: Int = 0
    
    // Trim white space and newline characters when end editing. Default is true
    @IBInspectable open var trimWhiteSpaceWhenEndEditing: Bool = true
    
    // Maximm height of the textview
    @IBInspectable open var maxHeight: CGFloat = CGFloat(0)
    
    // Placeholder properties
    // Need to set both placeHolder and placeHolderColor in order to show placeHolder in the textview
    @IBInspectable open var placeHolder: NSString? {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable open var placeHolderColor: UIColor = UIColor(white: 0.8, alpha: 1.0) {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable open var placeHolderLeftMargin: CGFloat = 5 {
        didSet { setNeedsDisplay() }
    }
    
    override open var text: String! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    fileprivate weak var heightConstraint: NSLayoutConstraint?
    
    // Initialize
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 30)
    }
    
    func associateConstraints() {
        // iterate through all text view's constraints and identify
        // height,from: https://github.com/legranddamien/MBAutoGrowingTextView
        for constraint in self.constraints {
            if (constraint.firstAttribute == .height) {
                if (constraint.relation == .equal) {
                    self.heightConstraint = constraint;
                }
            }
        }
    }
    
    // Listen to UITextView notification to handle trimming, placeholder and maximum length
    fileprivate func commonInit() {
        self.contentMode = .redraw
        associateConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
    }
    
    // Remove notification observer when deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Calculate height of textview
    override open func layoutSubviews() {
        super.layoutSubviews()
        let size = sizeThatFits(CGSize(width:bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        var height = size.height
        if maxHeight > 0 {
            height = min(size.height, maxHeight)
        }
        
        if (heightConstraint == nil) {
            heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
            addConstraint(heightConstraint!)
        }
        
        if height != heightConstraint?.constant {
            self.heightConstraint!.constant = height;
            scrollRangeToVisible(NSMakeRange(0, 0))
            if let delegate = delegate as? GrowingTextViewDelegate {
                delegate.textViewDidChangeHeight(self, height: height)
            }
        }
    }
    
    // Show placeholder
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if text.isEmpty {
            guard let placeHolder = placeHolder else { return }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment
            
            let rect = CGRect(x: textContainerInset.left + placeHolderLeftMargin,
                              y: textContainerInset.top,
                              width:   frame.size.width - textContainerInset.left - textContainerInset.right,
                              height: frame.size.height)
            
            var attributes: [String: Any] = [
                NSForegroundColorAttributeName: placeHolderColor,
                NSParagraphStyleAttributeName: paragraphStyle
            ]
            if let font = font {
                attributes[NSFontAttributeName] = font
            }
            
            placeHolder.draw(in: rect, withAttributes: attributes)
        }
    }
    
    // Trim white space and new line characters when end editing.
    func textDidEndEditing(notification: Notification) {
        if let notificationObject = notification.object as? GrowingTextView {
            if notificationObject === self {
                if trimWhiteSpaceWhenEndEditing {
                    text = text?.trimmingCharacters(in: .whitespacesAndNewlines)
                    setNeedsDisplay()
                }
            }
        }
    }
    
    // Limit the length of text
    func textDidChange(notification: Notification) {
        if let notificationObject = notification.object as? GrowingTextView {
            if notificationObject === self {
                if maxLength > 0 && text.characters.count > maxLength {
                    
                    let endIndex = text.index(text.startIndex, offsetBy: maxLength)
                    text = text.substring(to: endIndex)
                    undoManager?.removeAllActions()
                }
                setNeedsDisplay()
            }
        }
    }
}

