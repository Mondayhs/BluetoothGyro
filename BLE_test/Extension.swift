//
//  Extension.swift
//  BLE_test
//
//  Created by zhou Chou on 2023/6/19.
//

import UIKit


// MARK: - UI defined
extension UIColor {
    static var customLabelColor: UIColor { return UIColor(named: "InvertedBWColor")! }
}

extension UIButton {

    func configureWith(title: String, selector: Selector, target: Any) {

        let labelFont = UIFont(name: "HelveticaNeue", size: 12)

        self.setTitle(title, for: .normal)
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = labelFont
        self.setTitleColor(UIColor.black, for: .normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 6
        self.addTarget(target, action: selector, for: .touchUpInside)
    }
    
    func Buildbarbutton(selector: Selector, target: Any) {
        
//        let button = UIButton()
        self.imageView?.contentMode = .scaleToFill
//        self.imageView?.layer.cornerRadius = 14
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(UIImage(named: "Acromax"), for: .normal)
        self.widthAnchor.constraint(equalToConstant: 55).isActive = true
        self.heightAnchor.constraint(equalToConstant: 28).isActive = true
        self.addTarget(target, action: selector, for: .touchUpInside)
//        self.navigationItem.leftBarButtonItem = button
        
    }
}


extension UILabel {

    private func configure(textAlignment: NSTextAlignment) {

        self.textAlignment = textAlignment
        self.textColor = UIColor.black
        self.numberOfLines = 0
    }

    func titleWith(title: String) {

        self.configure(textAlignment: .center)
        self.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        self.text = title
    }

    func rightAlignWith(title: String) {

        self.configure(textAlignment: .right)
        self.font = UIFont(name: "HelveticaNeue", size: 12)
        self.text = title
    }
    func leftAlignWith(title: String) {

        self.configure(textAlignment: .left)
        self.font = UIFont(name: "HelveticaNeue", size: 12)
        self.text = title
    }
    
    func teachlabel(title: String, color: UIColor) {

//        self.configure(textAlignment: .right)
        self.font = UIFont(name: "HelveticaNeue", size: 14)
        self.text = title
        self.textColor = color
        self.numberOfLines = 0
        self.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
    }
    
}


extension UITextField {

    func configure() {

        self.font = UIFont(name: "HelveticaNeue", size: 12)
        self.textColor = UIColor.black
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 6
    }

    func configureWith(toolbar: UIToolbar, keyboardtype: UIKeyboardType) {

        self.configure()
        self.inputAccessoryView = toolbar
        self.keyboardType = keyboardtype
    }

    func configureWith(toolbar: UIToolbar, inputView: UIView) {
        
        self.configure()
        self.inputAccessoryView = toolbar
        self.inputView = inputView
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
        )
    }

}




extension Date {
    
    func isFirstOfMonth() -> Bool {
        let components = Calendar.current.dateComponents([.day], from: self)
        return components.day == 1
    }
    
    func monthName() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            dateFormatter.locale = Locale(identifier: "en_US")
            return dateFormatter.string(from: self)
    }
    
}
