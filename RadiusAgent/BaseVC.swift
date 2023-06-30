//
//  BaseVC.swift
//  RadiusAgent
//
//  Created by NFC User on 28/06/23.
//

import UIKit
import SystemConfiguration

class BaseVC: UIViewController {

    var facilities: [Any]?
    var totalF: Int?
    var exclusions: [Any]?
    var totalE: Int?
    var propertyType: [String] = []
    var roomType: [String] = []
    var facilityType: [String] = []
    var view1Name = ""
    var view2Name = ""
    var view3Name = ""
    
    var propertyId: [([Int], String)]?
    var roomId: [([Int], String)]?
    var facilityId: [([Int], String)]?
    var checkListTuple: [(Int,Int)] = []
    var hideListTuple: [(Int,Int)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Internet Availibility
        
        public func isInternetAvailable() -> Bool
        {
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)
            return (isReachable && !needsConnection)
        }
    
    //MARK: - Nav bar Styling
    
    func navbarStyling () {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = #colorLiteral(red: 0.3742285371, green: 0.426192522, blue: 0.3634500504, alpha: 1)
        
        let titleStyle = [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 18), NSAttributedString.Key.foregroundColor: UIColor.white]
        
        appearance.titleTextAttributes = titleStyle as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    //MARK: - Alert function with ok Button
    
    func showAlertWithOkButton (titlename: String, messageContent: String) {
        
        let alertController = UIAlertController(title: titlename, message: messageContent, preferredStyle: .alert)
        
        let titleFont = UIFont(name: "Poppins-Medium", size: 14)!
        let titleAttributes = [NSAttributedString.Key.font: titleFont]
        let attributedTitle = NSAttributedString(string: titlename, attributes: titleAttributes)
        alertController.setValue(attributedTitle, forKey: "attributedTitle")

        let okAction = UIAlertAction(title: "Done", style: .default) { (_) in
            
        }

        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    //MARK: - API Call
    
    func ListAPICall(completion: @escaping (Result<Data, Error>) -> Void) {

        guard let url = URL(string: "https://my-json-server.typicode.com/iranjith4/ad-assignment/db") else {
            print("Invalid URL")
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            if httpResponse.statusCode == 200 {

                if let data = data {

                     if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                        let jsonDict = jsonObject as? [String: [Any]] {

                         self.facilities = jsonDict["facilities"]
                         self.totalF = self.facilities?.count

                         self.exclusions = jsonDict["exclusions"]
                         self.totalE = self.exclusions?.count
                         
                         self.facilitiesBreakDown()
                         self.exclusionBreakDown()
                         
                         completion(.success(data))

                     }

                }
            } else {
                print("HTTP response status code: \(httpResponse.statusCode)")
                let error = NSError(domain: "No data received", code: 0, userInfo: nil)
                completion(.failure(error))
            }
        }

        task.resume()

    }
    
    //MARK: - Facilities

    func facilitiesBreakDown() {

        if let fCount = totalF {
            for i in 0..<fCount {

                if i == 0{
                    let facilities1 = facilities![i] as! [String : Any]
                    view1Name = facilities1["name"] as! String
                    if let options = facilities1["options"] as? [Any]{
                        let optionCount = options.count

                        for i in 0..<optionCount {
                            let optionItem = options[i] as! [String : Any]
                            let property = optionItem["name"] as! String
                            propertyType.append(property)
                            print("the proerty type \(i+1) is ", propertyType)
                        }
                        
                        propertyId = assignIDsToStrings(strings: propertyType, parentId: [1,1])
    
                    }
                }
                
                else if i == 1{
                    let facilities2 = facilities![i] as! [String : Any]
                    view2Name = facilities2["name"] as! String
                    if let options = facilities2["options"] as? [Any]{
                        let optionCount = options.count

                        for i in 0..<optionCount {
                            let optionItem = options[i] as! [String : Any]
                            let property = optionItem["name"] as! String
                            roomType.append(property)
                            print("the room type \(i+1) is ", roomType)
                        }
                        
                        roomId = assignIDsToStrings(strings: roomType, parentId: [2,6])
       
                    }
                }
                else if i == 2{
                    let facilities3 = facilities![i] as! [String : Any]
                    view3Name = facilities3["name"] as! String
                    if let options = facilities3["options"] as? [Any]{
                        let optionCount = options.count

                        for i in 0..<optionCount {
                            let optionItem = options[i] as! [String : Any]
                            let property = optionItem["name"] as! String
                            facilityType.append(property)
                            print("the room type \(i+1) is ", facilityType)
                        }
                        
                        facilityId = assignIDsToStrings(strings: facilityType, parentId: [3,10])
  
                    }
                }
            }
        }

    }
    
    //MARK: - Assigning Id's
    
    func assignIDsToStrings(strings: [String], parentId: [Int]) -> [([Int], String)] {
        var ids: [([Int], String)] = []
        var parentId: [Int] = parentId

        for string in strings {

            ids.append((parentId, string))

            parentId[1] += 1
        }

        return ids
    }
    
    //MARK: - Exclusion Breakdown
    
    func exclusionBreakDown() {
        
        if let eCount = totalE{
            
            for i in 0..<eCount {
                if let options = exclusions![i] as? [Any] {
                    let optionCount = options.count
                    for i in 0..<optionCount{
                        
                        if i == 0 {
                            let optionItem = options[i] as! [String : Any]
                            let id1 = optionItem["facility_id"] as! String
                            let id2 = optionItem["options_id"] as! String
                            let idsTuple: (String, String) = (id1, id2)
                            let intTuple = (Int(idsTuple.0) ?? 0, Int(idsTuple.1) ?? 0)
                            checkListTuple.append(intTuple)
                        }
                        
                        else if i == 1 {
                            let optionItem = options[i] as! [String : Any]
                            let id1 = optionItem["facility_id"] as! String
                            let id2 = optionItem["options_id"] as! String
                            let idsTuple: (String, String) = (id1, id2)
                            let intTuple = (Int(idsTuple.0) ?? 0, Int(idsTuple.1) ?? 0)
                            hideListTuple.append(intTuple)
                        }
                    }
                }
            }
            print("the tuple checklist are", checkListTuple)
            print("the tuple hidelist are", hideListTuple)
        }
        
    }

}
