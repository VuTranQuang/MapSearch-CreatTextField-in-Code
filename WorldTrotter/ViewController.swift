//
//  ViewController.swift
//  WorldTrotter
//
//  Created by VuTQ10 on 2/25/20.
//  Copyright © 2020 VuTQ10. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var textField: UITextField!
    
    static let share = ViewController()
    var maxLengths = [UITextField: Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
    }
    // MARK: TextField take only Integer
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let s = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        guard !s.isEmpty else {
            return true
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        return numberFormatter.number(from: s)?.intValue != nil
    }
}

// MARK: Customs textField Maxlength
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = ViewController.share.maxLengths[self] else {
                return 150
            }
            return l
        }
        set {
            ViewController.share.maxLengths[self] = newValue
            addTarget(self, action: #selector(fix(textField:)), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}
