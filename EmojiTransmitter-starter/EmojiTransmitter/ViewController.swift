/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
//import Starscream //added

final class ViewController: UIViewController {

  // MARK: - Properties
  var username = ""
  //var socket = WebSocket(url: URL(string: "ws://localhost:1337/")!, protocols: ["chat"])

  // MARK: - IBOutlets
  @IBOutlet var emojiLabel: UILabel!
  @IBOutlet var usernameLabel: UILabel!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    /*socket.delegate = self
    socket.connect()*/
    navigationItem.hidesBackButton = true
  }
  
  /*deinit {
    socket.disconnect(forceTimeout: 0) //this forces the WebSocket connection to disconnect when the view controller is deallocated
    socket.delegate = nil
  }*/
}

// MARK: - IBActions
extension ViewController {

  @IBAction func selectedEmojiUnwind(unwindSegue: UIStoryboardSegue) {
    guard let viewController = unwindSegue.source as? CollectionViewController,
      let emoji = viewController.selectedEmoji() else{
        return
    }

    sendMessage(emoji)
  }
}

// MARK: - FilePrivate
fileprivate extension ViewController {

  func sendMessage(_ message: String) {
    print("NOOP - sendMessage: \(message)")
    //socket.write(string: message) //sends any messages (or emojis, in this application’s case) to the Node.js server
  }

  func messageReceived(_ message: String, senderName: String) {
    emojiLabel.text = message
    usernameLabel.text = senderName
  }
}

/*// MARK: - WebSocketDelegate
 //these four delegate methods are required to be implemented for your code to compile
extension ViewController : WebSocketDelegate {
  public func websocketDidConnect(_ socket: Starscream.WebSocket) {
    socket.write(string: username) //sends the username entered from the first screen as soon as the socket connects
  }
  
  public func websocketDidDisconnect(_ socket: Starscream.WebSocket, error: NSError?) {
    performSegue(withIdentifier: "websocketDisconnected", sender: self) //pops the user back to the username screen if the socket disconnects for whatever reason
  }
  
  public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {
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
      let messageAuthor = messageData["author"] as? String,
      let messageText = messageData["text"] as? String {

      messageReceived(messageText, senderName: messageAuthor)
    }
  }
  
  public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {

  }
}*/
