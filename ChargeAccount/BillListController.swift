//
//  BillListController.swift
//  ChargeAccount
//
//  Created by Lei on 2022/5/9.
//  Implemented by Hongguang on 2022/5/14

import UIKit
import ToastViewSwift

class BillListController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var billListTableView: UITableView!
        
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var filterHeaderView: UIView!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    let dataStorageManager: DataStorageManager = DataStorageManager()
    
    var billModels: [BillModel] = []
    var filteredBillsGroup: [String: [BillModel]] = [:]

    var indexTitles = ["Clothing", "Entertainment", "Food", "Travel", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitData()
        
        setupViews()
    }
    
    func setupViews() {
        
        filterHeaderView.layer.shadowColor = UIColor.gray.cgColor
        filterHeaderView.layer.shadowOpacity = 1
        filterHeaderView.layer.shadowOffset = CGSize(width: 0, height: 0)
        filterHeaderView.layer.shadowRadius = 1.5
        filterHeaderView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: filterHeaderView.bounds.maxY - filterHeaderView.layer.shadowRadius, width: filterHeaderView.bounds.width, height: filterHeaderView.layer.shadowRadius)).cgPath

        startDatePicker.sizeToFit()
        startDatePicker.maximumDate = Date()
        startDatePicker.sizeToFit()
        endDatePicker.maximumDate = Date()

        billListTableView.dataSource = self
        billListTableView.delegate = self
    }
    
    func setupInitData() {
        do {
            billModels = try dataStorageManager.readBillModels()
            filteredBillsGroup = Dictionary(grouping: billModels, by: { $0.type })
        } catch {
            print("read data error: \(error)")
        }
    }
    
    
    @IBAction func onClickedBackHome(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickedEditButton(_ sender: Any) {
        
        billListTableView.setEditing(!billListTableView.isEditing, animated: true)

        editButton.setTitle(billListTableView.isEditing ? "Done" : "Edit", for: .normal)
    }
    
    @IBAction func onClickedFilterButton(_ sender: Any) {
        
        guard startDatePicker.date.compare(endDatePicker.date) != .orderedDescending else {
            startDatePicker.shakeIt()
            endDatePicker.shakeIt()
            return
        }
        
        let filteredBills = billModels.filter({ $0.date().distance(from: startDatePicker.date, only: .day) >= 0 && $0.date().distance(from: endDatePicker.date, only: .day) <= 0 })
        filteredBillsGroup = Dictionary(grouping: filteredBills, by: { $0.type })

        billListTableView.reloadData()
    }
    
    //MARK: Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredBillsGroup.keys.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return filteredBillsGroup.keys.sorted()
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredBillsGroup.keys.sorted()[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = filteredBillsGroup.keys.sorted()[section]
        return filteredBillsGroup[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NameBillsCell", for: indexPath) as? NameBillsCell else {
            return UITableViewCell()
        }
        
        let key = filteredBillsGroup.keys.sorted()[indexPath.section]
        let bills = filteredBillsGroup[key]!
        if bills.count > indexPath.row {
            cell.billModel = bills[indexPath.row]
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "EditBillViewControllerSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let key = filteredBillsGroup.keys.sorted()[indexPath.section]
            var bills = filteredBillsGroup[key]!
            if bills.count > indexPath.row {
                
                let bill = bills[indexPath.row]
                
                do {
                    try dataStorageManager.deleteBill(bill)
                    bills.remove(at: indexPath.row)
                    filteredBillsGroup[key] = bills
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } catch {
                    Toast.default(image: UIImage(systemName: "info.circle")!, title: error.localizedDescription).show()
                }
            }
        }
    }
    
    
    @IBAction func homeButtonTapped(_ sender: Any) {
         self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "EditBillViewControllerSegue":
            if let viewController = segue.destination as? ChargeAccountController, let selectedIndexPath = sender as? IndexPath {
                let key = filteredBillsGroup.keys.sorted()[selectedIndexPath.section]
                var bills = filteredBillsGroup[key]!
                let editBill = bills[selectedIndexPath.row]
                viewController.editBill = editBill
                viewController.editBillFinishHandler = { [weak self] editedBill in
                    bills[selectedIndexPath.row] = editedBill
                    self?.filteredBillsGroup[key] = bills
                    self?.billListTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
                }
            }
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


extension Date {
    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }
}
