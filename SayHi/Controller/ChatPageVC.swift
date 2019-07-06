//
//  ChatPageVC.swift
//  SayHi
//
//  Created by Oday Dieg on 7/4/19.
//  Copyright © 2019 Oday Dieg. All rights reserved.
//

import UIKit
import Firebase

class ChatPageVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    
    

    
    
    @IBOutlet weak var ChatTableView: UITableView!
    
    @IBOutlet weak var ChatTextField: UITextField!
    
    var room:Rooms?
    var ChatMessage = [Message]()
    
    var CurrentUserId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ChatTableView.delegate = self
        ChatTableView.dataSource = self
        ChatTableView.separatorStyle = .none
        ChatTableView.allowsSelection = false
        self.navigationItem.title = room?.RoomName
        
        guard let curerntuser = Auth.auth().currentUser?.uid else
        {
            return
        }
        CurrentUserId = curerntuser
        
        observeMessages()
    }
    
    
    func GetUserNameWithId(ID: String ,  Completion: @escaping (_ Username: String?) -> () )
        
    {
        let DataBaseRef = Database.database().reference()
        let user = DataBaseRef.child("Users").child(ID)
        user.child("username").observeSingleEvent(of: .value) { (snapshot) in
            if let username = snapshot.value as? String{
                Completion(username)
            }else
            {
                Completion(nil)
            }
        
    }
    }
    
    
    
    
    func SendMessage (Text: String , Completion: @escaping (_ IsSuccess: Bool ) -> () ){
        
        guard let UserID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let DataBaseRef = Database.database().reference()
        
        GetUserNameWithId(ID: UserID) { (Username) in
            if let username = Username
            {
                if let RoomId = self.room?.RoomId, let UserID = Auth.auth().currentUser?.uid
                {
                    let DataArray:[String:Any] = ["Text": Text , "SenderName": username, "UserId": UserID]
                    
                    let room = DataBaseRef.child("Rooms").child(RoomId)
                    
                    room.child("Messages").childByAutoId().setValue(DataArray, withCompletionBlock: { (error, ref) in
                        if (error == nil)
                        {
                            Completion(true)
                            
                            
                            self.ChatTextField.text = ""
                        }
                        else{
                            Completion(false)
                        }
                    }
                    )
                    
                }
            }
        }
       
            
        
        
    }
    

    @IBAction func SendMessageBtn(_ sender: Any) {
        
        guard let ChatText = self.ChatTextField.text, ChatTextField.text?.isEmpty == false  else {
            return
        }
        SendMessage(Text: ChatText) { (IsSuccess) in
            
            if(IsSuccess)
            {
                print("Message Sent")
            }
            
        }

        
    }
    func observeMessages()
    {
        guard let roomid = self.room?.RoomId else {
            return
        }
        
        let DatabaseRef =  Database.database().reference()
        DatabaseRef.child("Rooms").child(roomid).child("Messages").observe(.childAdded) { (snapshot) in
            
            if let DataArray = snapshot.value as? [String: Any]
            {
                guard let Sendername = DataArray["SenderName"] as? String , let MessageText = DataArray["Text"] as? String, let userid = DataArray["UserId"]as? String else{
                    return
                
            }
                let message = Message.init(MessageText: MessageText, SenderName: Sendername, MessageKey: snapshot.key, userId: userid)
                self.ChatMessage.append(message)
                self.ChatTableView.reloadData()
            }
            
        }
        
}
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ChatMessage.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Message = self.ChatMessage[indexPath.row]
        
        let cell = ChatTableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
                cell.SetMessage(Message: Message)
        
        if (Message.userId == self.CurrentUserId)
        {
            cell.setChatBubble(DirectOfMessage: .Sender)
            
        }else
        {
            cell.setChatBubble(DirectOfMessage: .Recieve)
        }
      
        
        
        return cell
    }
    

}
