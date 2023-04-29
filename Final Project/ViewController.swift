//
//  ViewController.swift
//  Final Project
//
//  Created by d.igihozo on 4/28/23.
//

// Imported necessary modules
import UIKit
import MessageUI


// Declaring a view controller class that conforms to several protocols
class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MFMessageComposeViewControllerDelegate, UITextFieldDelegate {
    
    
    // Connecting outlets from storyboard to the view controller
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var amountTextField: UITextField!
    
    
    // Declaring arrays and variables for the currencies and their values
    var currencyCode: [String] = []
    var values: [Double] = []
    var activeCurrency = 0.0
    
    // Setting up the view when it is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the picker delegate and data source
        picker?.dataSource = self
        picker?.delegate = self
        
        // Fetching the currency data from a web API
        fetchJSon()
        
        // Adding a target for the amount text field to update the price when it is edited
        amountTextField?.addTarget(self, action: #selector(updateViews), for: .editingChanged)
        
        // Setting the phone number text field delegate
        phoneNumberTextField?.delegate = self
        
        // Creating a swipe gesture recognizer to handle user swipes
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeGesture.direction = .down
        
        // Adding the swipe gesture recognizer to the view
        view.addGestureRecognizer(swipeGesture)
    }
    
    // Handling user swipe gestures
    @objc func handleSwipeGesture() {
        
        // Taking user back to home of the app
        navigationController?.popToRootViewController(animated: true)
    }
    
    // Handling message compose view controller events
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            // a required function to be able to compse a message
        }
    // Handling the send SMS button
    @IBAction func sendSMS(_ sender: Any) {
        
        // Creating a message compose view controller and set its delegate
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Getting the phone number entered in the textField
        if let phoneNumber = phoneNumberTextField.text {
            composeVC.recipients = [phoneNumber]
        } else {
            // Handling error when the phone number is not entered
            print("Phone number not entered")
            return
        }
        
        // Setting the message body to the current price
        if let priceText = priceLabel.text {
            composeVC.body = "The current price is \(priceText)"
        } else {
            // Handling error when the price label is not set
            print("Price label not set")
            return
        }
        
        // Checking if the user's device can send text messages and present the compose view controller else print in the console that message
         if MFMessageComposeViewController.canSendText() {
             self.present(composeVC, animated: true, completion: nil)
         } else {
             print("can't send message")
         }
    }
    
    // Updating the price label when the amount text field is edited
    @objc func updateViews() {
        guard let amountText = amountTextField?.text, let theAmountText = Double(amountText) else { return }
        if !amountText.isEmpty {
            let total = theAmountText * activeCurrency
            priceLabel.text = String(format: "%.2f", total)
        }
    }
    
    // Setting up the picker view with one component
    func numberOfComponents(in picker: UIPickerView) -> Int {
        return 1
    }
    
    // Setting the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyCode.count
    }
    
    // Setting the title for each row in the picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyCode[row]
    }
    
    // Handling the selection of a row in the picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = values[row]
        updateViews()
    }
    
    //MARK: - Method to fetch JSON data from API
    func fetchJSon() {
        // Checking if the URL is valid
        guard let url = URL(string: "https://open.exchangerate-api.com/v6/latest") else {return}
        
        // Creating a URLSession data task to retrieve data from the API
        URLSession.shared.dataTask(with: url) { (data, response, error)in
            
            //handling any errors if there are any
            if error != nil{
                print(error!)
                return
            }
            
            //safety retrieved the data
            guard let safeData = data else{return}
            
            //decode the JSON  data using a Codable model
            
            do{
                let results = try JSONDecoder().decode(exchangeRates.self, from: safeData)
                
                // Appending the currency codes and rates to arrays for use in the picker view
                self.currencyCode.append(contentsOf: results.rates.keys)
                self.values.append(contentsOf: results.rates.values)
                
                // Reloading the picker view on the main thread
                DispatchQueue.main.async {
                    self.picker?.reloadAllComponents()
                }
            }
            catch{
                print(error)
            }
        }.resume() // Starting the data task again
    }
}
