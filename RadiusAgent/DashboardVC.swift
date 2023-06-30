//
//  DashboardVC.swift
//  RadiusAgent
//
//  Created by NFC User on 28/06/23.
//

import UIKit

class DashboardVC: BaseVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var facilitiesTableView: UITableView!
    @IBOutlet weak var roomTableView: UITableView!
    @IBOutlet weak var otherFacilitiesTableView: UITableView!
    
    @IBOutlet weak var view1Label: UILabel!
    @IBOutlet weak var view2Label: UILabel!
    @IBOutlet weak var view3Label: UILabel!
    
    var pHideTuple: [Int]?
    var rHideTuple: [Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("entered the dashboard VC")

        facilitiesTableView.delegate = self
        facilitiesTableView.dataSource = self

        roomTableView.delegate = self
        roomTableView.dataSource = self
        
        otherFacilitiesTableView.delegate = self
        otherFacilitiesTableView.dataSource = self
  
    }
    
    //MARK: - View Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        SpinnerView.shared.startAnimating(in: self.view)
        navbarStyling()
        
        if isInternetAvailable() {
            
            ListAPICall { result in
                switch result {
                case .success(let data):
                    print("Received API response: \(data)")
                        DispatchQueue.main.async {
                            self.facilitiesTableView.reloadData()
                            self.roomTableView.reloadData()
                            self.otherFacilitiesTableView.reloadData()
                            self.labelName()
                            SpinnerView.shared.stopAnimating()
                                   }
                    
                case .failure(let error):
                    print("API request failed with error: \(error)")
                }
            }
            
        }
        
        else {
            
            showAlertWithOkButton(titlename: "No Internet Connection", messageContent: "Please connect to an active network and try again")
            
        }
        
    }
    
    func labelName() {
        view1Label.text = view1Name
        view2Label.text = view2Name
        view3Label.text = view3Name
    }

    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == facilitiesTableView {
            return propertyType.count
        }
        else if tableView == roomTableView {
            return roomType.count
        }
        else if tableView == otherFacilitiesTableView {
            return facilityType.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == facilitiesTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier:"pCell") as! PropertyTypeCell
            cell.pLabel.text = propertyType[indexPath.row]
            let image = propertyType[indexPath.row]
            cell.pImage.image = UIImage(named: "\(image)")
            
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 1.5)
            cell.layer.shadowOpacity = 0.3
            cell.layer.shadowRadius = 3
            cell.layer.masksToBounds = false
            cell.clipsToBounds = false
            
            return cell
        }
        else if tableView == roomTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier:"rCell") as! RoomTypeCell
            cell.roomTitle.text = roomType[indexPath.row]
            let image = roomType[indexPath.row]
            cell.roomImage.image = UIImage(named: "\(image)")
            
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 1.5)
            cell.layer.shadowOpacity = 0.3
            cell.layer.shadowRadius = 3
            cell.layer.masksToBounds = false
            cell.clipsToBounds = false
            
            return cell
        }
        else if tableView == otherFacilitiesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier:"fCell") as! FacilityTypeCell
            cell.facilityName.text = facilityType[indexPath.row]
            let image = facilityType[indexPath.row]
            cell.facilityImage.image = UIImage(named: "\(image)")
            
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 1.5)
            cell.layer.shadowOpacity = 0.3
            cell.layer.shadowRadius = 3
            cell.layer.masksToBounds = false
            cell.clipsToBounds = false
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView == facilitiesTableView{
            
            pHideTuple = [0,0]
            let selectedCellData = propertyId![indexPath.row]
            let selectedID = selectedCellData.0
            for i in 0..<checkListTuple.count{
                let intTuple = checkListTuple[i]
                let intArray = Array([intTuple.0, intTuple.1])
                roomTableView.reloadData()
                otherFacilitiesTableView.reloadData()
                if selectedID == intArray {
                    let intTuple = hideListTuple[i]
                    let intArray = Array([intTuple.0, intTuple.1])
                    pHideTuple = intArray
                    print("viv cell need to hide at ", pHideTuple!)
                    roomTableView.reloadData()
                    otherFacilitiesTableView.reloadData()
                }
            }
            
        }
        else if tableView == roomTableView{
            
            rHideTuple = [0,0]
            let selectedCellData = roomId![indexPath.row]
            let selectedID = selectedCellData.0
            for i in 0..<checkListTuple.count{
                let intTuple = checkListTuple[i]
                let intArray = Array([intTuple.0, intTuple.1])
                otherFacilitiesTableView.reloadData()
                if selectedID == intArray {
                    let intTuple = hideListTuple[i]
                    let intArray = Array([intTuple.0, intTuple.1])
                    rHideTuple = intArray
                    print("viv cell need to hide at ", rHideTuple!)
                    otherFacilitiesTableView.reloadData()
                }
            }

        }
        else if tableView == otherFacilitiesTableView{
            print("the selected facility is",facilityType[indexPath.row])
        }

    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if tableView == roomTableView && pHideTuple == [2,6] && indexPath.row == 0 {
            
            UIView.animate(withDuration: 0.1, animations: {
                tableView.cellForRow(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.9074706435, green: 0.6701427102, blue: 0.6037115455, alpha: 1)
            }) { (_) in
                UIView.animate(withDuration: 0.1, animations: {
                    tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.white // Change to the original color
                })
            }
            
            print("hided viv")
            return nil
        }
        
        if tableView == otherFacilitiesTableView && rHideTuple == [3,12] && indexPath.row == 2 {
            
            UIView.animate(withDuration: 0.1, animations: {
                tableView.cellForRow(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.9074706435, green: 0.6701427102, blue: 0.6037115455, alpha: 1)
            }) { (_) in
                UIView.animate(withDuration: 0.1, animations: {
                    tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.white // Change to the original color
                })
            }
            
            print("hided viv")
            return nil
        }
        
        if tableView == otherFacilitiesTableView && pHideTuple == [3,12] && indexPath.row == 2 {
            
            UIView.animate(withDuration: 0.1, animations: {
                tableView.cellForRow(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.9074706435, green: 0.6701427102, blue: 0.6037115455, alpha: 1)
            }) { (_) in
                UIView.animate(withDuration: 0.1, animations: {
                    tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.white // Change to the original color
                })
            }
            
            print("hided viv")
            return nil
        }
         
         return indexPath
     }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    
    //MARK: - Submit Button
    
    
    @IBAction func submitButton(_ sender: Any) {
        facilitiesTableView.reloadData()
        roomTableView.reloadData()
        otherFacilitiesTableView.reloadData()
        showAlertWithOkButton(titlename: "Thank You!", messageContent: "")
    }
    
}
