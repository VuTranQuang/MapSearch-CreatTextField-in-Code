//
//  ViewController.swift
//  WorldTrotter
//
//  Created by VuTQ10 on 2/25/20.
//  Copyright © 2020 VuTQ10. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var viewBackground: UIView!
    @IBOutlet weak var textField: UITextField!
    static let share = ViewController()
    var maxLengths = [UITextField: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 6 || hour <= 18 {
            viewBackground.backgroundColor = UIColor.lightText
        } else {
            viewBackground.backgroundColor = UIColor.darkGray
        }
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

