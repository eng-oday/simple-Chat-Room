//
//  CreateRoomVC.swift
//  SayHi
//
//  Created by Oday Dieg on 7/4/19.
//  Copyright © 2019 Oday Dieg. All rights reserved.
//

import UIKit
import Firebase
class CreateRoomVC: UIViewController {

    @IBOutlet weak var ChatRoomTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func PressedCreateRoom(_ sender: Any) {
        
        guard let RoomName = ChatRoomTextField.text, ChatRoomTextField.text?.isEmpty == false else
        {
            return
        }
        let DataBaseRef = Database.database().reference()
        let Rooms = DataBaseRef.child("Rooms").childByAutoId()
        
        let DataArray:[String: Any] = ["RoomName":RoomName]
        Rooms.setValue(DataArray) { (error, Ref) in
            if(error == nil)
            {
               self.ChatRoomTextField.text = ""
            }
        }
        
    }
    
    

  

}
