//
//  ViewController.swift
//  Assignment 4
//
//  Created by Victor Yang on 2020-04-29.
//  Copyright © 2020 COMP2601. All rights reserved.
//

import UIKit
//import SocketIO
import Starscream
import SafariServices

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var address = ""
    var socket:WebSocket!
    //let pinner = FoundationSecurity(allowSelfSigned: true) //don't validate SSL certificates
    var arrayOfText = [String]() //stores strings that represent messages; initialization of array appears correct; HOWEVER, does this need to be a tableview array (if it isn't already that is)???
    
    // MARK: -IBOutlets
    @IBOutlet var userInput: UITextField!
    @IBOutlet var connectButton: UIButton!
    @IBOutlet var disconnectButton: UIButton!
    @IBOutlet var sendMessageButton: UIButton!
    @IBOutlet var displayText: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //displayText.keyboardDismissMode = .onDrag
        userInput.delegate = self
        //displayText.tableFooterView = UIView(frame: CGRect.zero)
        displayText.dataSource = self //do I need this??
        displayText.delegate = self
    }
    
    @IBAction func establishConnection(_ sender: UIButton){
        print("establishConnection() function called")
        //take the address user enters in text field and try to connect it with the socket
        address += userInput.text! //this line of code works properly
        print(address)
        socket = WebSocket(request: URLRequest(url: URL(string: address)!)) //creates a WebSocket connection; it is problematic if 'http://134.117.26.92:3000' or 'http://134.117.26.92:3001' is entered because these are live servers and those have probably been taken down. Instead, USE 'http://localhost:3000'
        
        //create a custom queue
        socket.callbackQueue = DispatchQueue(label: "com.vluxe.starscream.myapp")
        
        socket.delegate = self //not sure if I need this
        socket.connect() //connects the socket to the server
        userInput.text = ""
        
        //indicate that a connection has been made to the server
        let connectionAlert = UIAlertController(title: "Alert", message: "Connected to Server", preferredStyle: .alert)
        connectionAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
        }))
        self.present(connectionAlert, animated: true, completion: nil)
    }
    
    @IBAction func sendMessage(_ sender: UIButton){ //does this method need to be run on main thread???
        print("sendMessage() function called")
        let message = userInput.text! //get the message entered by user in text field
        socket.write(string: message) //sends the message
        print("Message has been sent")
        //display the message sent
        arrayOfText.append(message)
        
        /*for text in arrayOfText{ //debugging
            print(text)
        }*/
        
        let indexPath = IndexPath(row: arrayOfText.count-1, section: 0)
        
        //add the received message to 'displayText'
        displayText.beginUpdates() //begins a series of method calls that insert, delete, or select rows and sections of the table view
        print("Beginning updates")
        displayText.insertRows(at: [indexPath], with: .automatic) //is there an alternative function that can be used instead? Such as '.setText()'???
        print("Inserted rows")
        displayText.endUpdates() //concludes a series of method calls that insert, delete, select, or reload rows and sections of the table view
        print("Ended updates")
        
        //The bottom 4 lines is an alternate way of adding text to the textview
        
        /*self.arrayOfText.append(message)
        
        self.displayText.beginUpdates()
        self.displayText.insertRows(at: [IndexPath.init(row: self.arrayOfText.count-1, section: 0)], with: .automatic)
        self.displayText.endUpdates()*/
        
        //Method 3: using reloadData() and resignFirstResponder(); this method does not cause an assertion failure error like the previous 2 methods, but this method also does not add the text to the textview either
        
        /*DispatchQueue.main.async{
            self.displayText.reloadData()
        }*/
                
        userInput.text = "" //or should this be set to 'nil'?
        print("Userinput's text has been set to clear")
        view.endEditing(true) //do I really need to have this?
    }
    
    //Should the following 4 methods be here???
    public func websocketDidConnect(_ socket: Starscream.WebSocket){
        print("websocketDidConnect function called") //debugging
    }
    
    public func websocketDidDisconnect(_ socket: Starscream.WebSocket, error: NSError?){
        print("websocketDidDisconnect function called") //debugging
    }
    
    public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String){
        print("Receiving message from other clients...") //debugging
        
        // 1. First convert the String to NSData. Next pass the NSData to the JSONSerialization object to parse the payload and (hopefully) return a valid object. Finally check that several important keys are set within the object. If the data is not valid, the method will exit early using the guard statement.
        guard let data = text.data(using: .utf16),
            let jsonData = try? JSONSerialization.jsonObject(with: data),
            let jsonDict = jsonData as? [String: Any],
            let messageType = jsonDict["type"] as? String else {
            return
        }
        
        // 2. The messages are filtered by messageType and then sent through to the existing messageReceived(messageText:, senderName:) method
        if messageType == "message",
            let messageData = jsonDict["data"] as? [String: Any],
            let messageText = messageData["text"] as? String{
                
            messageReceived(messageText) //this function isn't being called for some reason
        }
    }
    
    public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data){
        print("websocketDidReceiveData function called") //debugging
    }
    
    /*func messageReceived(_ message: String){ //if user receives a message from client elsewhere; does this method need to be run on main thread???
        arrayOfText.append(message)
        
        for text in arrayOfText{ //debugging
            print(text)
        }
        
        let indexPath = IndexPath(row: arrayOfText.count-1, section: 0)
        
        //add the received message to 'displayText'
        displayText.beginUpdates()
        displayText.insertRows(at: [indexPath], with: .automatic)
        displayText.endUpdates()
        
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int { //do I need this delegate method???
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //called every time tableView needs a cell
        //does this method need to be fixed???
        
        print("TableView needs a cell")
        
        let title = arrayOfText[indexPath.row]
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) //is this correct???
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Cell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! //is this correct???
        //cell.textLabel!.text = title //is this correct???
        //cell.textLabel?.text = title //is this correct???
        cell.title.text = title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @IBAction func closeConnection(_ sender: UIButton){
        socket.disconnect() //disconnects the socket from the server
        socket.delegate = nil //not sure if I need this
        address = ""
    }

    deinit { //this forces the WebSocket connection to disconnect when the view controller is deallocated
        socket.disconnect() //disconnects the socket from the server
        socket.delegate = nil
        address = ""
    }
    
    //UITextFieldDelegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userInput.resignFirstResponder() //hides the keyboard when user enters text in userInput
        return true
    }
    
}

//So was the following big block of code below giving me issues???
/*extension ViewController: UITableViewDelegate, UITableViewDataSource{ //this extension is needed in order to add text to the tableview
    func numberOfSections(in tableView: UITableView) -> Int { //do I need this delegate method???
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //called every time tableView needs a cell
        //does this method need to be fixed???
        
        print("TableView needs a cell")
        
        let title = arrayOfText[indexPath.row]
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) //is this correct???
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Cell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! //is this correct???
        //cell.textLabel!.text = title //is this correct???
        //cell.textLabel?.text = title //is this correct???
        cell.title.text = title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}*/

// MARK: - IBActions //maybe I don't need this??

// MARK: - FilePrivate
/*fileprivate*/ extension ViewController{
    //should I have a sendMessage function here too?
    
    fileprivate func messageReceived(_ message: String){ //if user receives a message from client elsewhere; does this method need to be run on main thread???
        arrayOfText.append(message)
        
        for text in arrayOfText{ //debugging
            print(text)
        }
        
        let indexPath = IndexPath(row: arrayOfText.count-1, section: 0)
        
        //add the received message to 'displayText'
        displayText.beginUpdates()
        displayText.insertRows(at: [indexPath], with: .automatic)
        displayText.endUpdates()
        
    }
}

// MARK: - WebSocketDelegate
//these 4 delegate methods are required to be implemented for your code to compile
extension ViewController : WebSocketDelegate {
        
    /*public func websocketDidConnect(_ socket: Starscream.WebSocket){
        print("websocketDidConnect function called") //debugging
    }
    
    public func websocketDidDisconnect(_ socket: Starscream.WebSocket, error: NSError?){
        print("websocketDidDisconnect function called") //debugging
    }
    
    public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String){
        print("Receiving message from other clients...") //debugging
        
        // 1. First convert the String to NSData. Next pass the NSData to the JSONSerialization object to parse the payload and (hopefully) return a valid object. Finally check that several important keys are set within the object. If the data is not valid, the method will exit early using the guard statement.
        guard let data = text.data(using: .utf16),
            let jsonData = try? JSONSerialization.jsonObject(with: data),
            let jsonDict = jsonData as? [String: Any],
            let messageType = jsonDict["type"] as? String else {
            return
        }
        
        // 2. The messages are filtered by messageType and then sent through to the existing messageReceived(messageText:, senderName:) method
        if messageType == "message",
            let messageData = jsonDict["data"] as? [String: Any],
            let messageText = messageData["text"] as? String{
                
            messageReceived(messageText) //this function isn't being called for some reason
        }
    }
    
    public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data){
        print("websocketDidReceiveData function called") //debugging
    }*/
    
    public func didReceive(event: WebSocketEvent, client: WebSocket) { //didReceive receives all the WebSocket events in a single easy to handle enum
        socket.onEvent = { event in
            switch event {
            case .connected(let headers):
                print("websocket is connected: \(headers)") //this works fine
            case .disconnected(let reason, let code):
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                print("Received text: \(string)") //this works fine
                //self.messageReceived(string) //Will this work??? Apparently not ¯\_(ツ)_/¯
            case .binary(let data):
                print("Received data: \(data.count)") //or just 'data'?
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                print("cancelled")
            case .error(let error):
                //handleError(error)
                print("error \(String(describing: error))")
            }
        }
        /*switch event {
        case .connected(let headers):
            print("websocket is connected: \(headers)") //this works fine
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)") //this works fine
            //messageReceived(string) //Will this work??? Apparently not ¯\_(ツ)_/¯
        case .binary(let data):
            print("Received data: \(data.count)") //or just 'data'?
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            print("cancelled")
        case .error(let error):
            //handleError(error)
            print("error \(String(describing: error))")
        }*/
        
        /*socket.onEvent = { event in
            switch event {
            case .connected( _): break
                //print("websocket is connected: \(headers)") //this works fine
            case .disconnected( _, _): break
                //print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                self.messageReceived(string) //will this work???
            case .binary( _): break
                //print("Received data: \(data.count)") //or just 'data'?
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled: break
                //print("cancelled")
            case .error( _): break
                //handleError(error)
                //print("error \(String(describing: error))")
            /*default:
                <#code#>*/
            }
        }*/
    }
    
}
