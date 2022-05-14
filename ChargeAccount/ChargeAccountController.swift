//
//  ChargeAccountController.swift
//  ChargeAccount
//
//  Created by Lei on 2022/5/9.
//

import UIKit
import ToastViewSwift

class ChargeAccountController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
        
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let dataStorageManager: DataStorageManager = DataStorageManager()
    var billModels: [BillModel] = []

    var editBill: BillModel?
    var editBillFinishHandler: ((BillModel)->Void)?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let bill = editBill {
            moneyTextField.text = bill.money
            typeTextField.text = bill.type
            datePicker.date = bill.date()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitData()
        let rightView = UIView.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        // Right view
               let rightButton = UIButton()
        rightButton.setImage(UIImage.init(systemName: "chevron.down"), for: .normal)
               rightButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        rightButton.addTarget(self, action: #selector(chooseTypeAction), for: .touchUpInside)
        rightView.addSubview(rightButton)
        typeTextField.rightViewMode = .always
        typeTextField.rightView = rightView
        typeTextField.delegate = self
        moneyTextField.delegate = self
        moneyTextField.keyboardType = .decimalPad

    }

    func setupInitData() {
        do {
            billModels = try dataStorageManager.readBillModels()
            titleLabel.text = "Bill number：\(billModels.count)"
        } catch {
            titleLabel.text = "Bill number：0"
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
       self.navigationController?.popToRootViewController(animated: true)
    }
        
    @IBAction func startButtonAction(_ sender: UIButton) {
        
        guard let money = moneyTextField.text, !money.isEmpty else {
            Toast.default(image: UIImage(systemName: "info.circle")!, title: "Please enter the amount").show()
            return
        }
        
        guard let type = typeTextField.text, !type.isEmpty else {
            Toast.default(image: UIImage(systemName: "info.circle")!, title: "Please select the type").show()
            return
        }
        
        let date = datePicker.date
        // Create a date formatter
        let dformatter = DateFormatter()
        // Sets the format string for the date formatter
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // Use date formatter to format the date and time
        let datestr = dformatter.string(from: date)
           
        //Add bill
        guard var editBill = editBill else {
            let billModel = BillModel(money: money, type: typeTextField.text!, dateTime: datestr)
            addBill(billModel)
            return
        }
        
        //edit bill
        editBill.money = money
        editBill.type = type
        editBill.dateTime = datestr
        modifyBill(editBill)
    }
    
    private func modifyBill(_ bill: BillModel) {
        
        do {
            try dataStorageManager.updateBill(bill)
        
            Toast.default(image: UIImage(systemName: "checkmark.circle")!, title: "Modify bill success").show()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.navigationController?.popViewController(animated: true)
                self.editBillFinishHandler?(bill)
            }
            
        } catch {
            print("Error while modify bill")
        }
    }
    
    private func addBill(_ bill: BillModel) {
        
        billModels.append(bill)
        
        do {
            try dataStorageManager.storeBills(bills: billModels)
            
            setupInitData()

            Toast.default(image: UIImage(systemName: "checkmark.circle")!, title: "Save bill success").show()

        } catch {
            print("Error while storing bill")
        }
    }
    
    // Choose the type of bill
   @objc func chooseTypeAction() {
       let alertVC = UIAlertController(title: "Bill type", message: "Please select the billing type", preferredStyle: UIAlertController.Style.actionSheet)
       let clothing = UIAlertAction(title: "Clothing", style: .default) { (_) -> Void in
           self.typeTextField.text = "Clothing"
       }
       let entertainment = UIAlertAction(title: "Entertainment", style: .default) { (_) -> Void in
           self.typeTextField.text = "Entertainment"
       }
       let food = UIAlertAction(title: "Food", style: .default) { (_) -> Void in
           self.typeTextField.text = "Food"
       }
       let travel = UIAlertAction(title: "Travel", style: .default) { (_) -> Void in
           self.typeTextField.text = "Travel"
       }
       let other = UIAlertAction(title: "Other", style: .default) { (_) -> Void in
           self.typeTextField.text = "Other"
       }
       
       let acCancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
       alertVC.addAction(clothing)
       alertVC.addAction(entertainment)
       alertVC.addAction(food)
       alertVC.addAction(travel)
       alertVC.addAction(other)
       alertVC.addAction(acCancel)
       present(alertVC, animated: true, completion: nil)
   }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        moneyTextField.resignFirstResponder()
        typeTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moneyTextField.resignFirstResponder()
        typeTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
       return textField == moneyTextField
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
