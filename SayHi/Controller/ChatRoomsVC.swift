//
//  ChatRoomsVC.swift
//  SayHi
//
//  Created by Oday Dieg on 7/4/19.
//  Copyright © 2019 Oday Dieg. All rights reserved.
//

import UIKit
import Firebase
class ChatRoomsVC: UIViewController,UIPopoverPresentationControllerDelegate,UITableViewDelegate, UITableViewDataSource {
    
  
    @IBOutlet weak var RoomsTableView: UITableView!
    
    var Room = [Rooms]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RoomsTableView.delegate = self
        RoomsTableView.dataSource = self
        observerRoom()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (Auth.auth().currentUser == nil)
        {
            PresentFormScreen()
        }
    }
    
    
    
    func observerRoom()
    {
        let DatabaseRef = Database.database().reference()
        DatabaseRef.child("Rooms").observe(.childAdded) { (snapshot) in
           if let DataArray = snapshot.value as? [String:Any]
           {
          if   let RoomName = DataArray["RoomName"]as? String
          {
            let room = Rooms.init(RoomId: snapshot.key, RoomName: RoomName)
            self.Room.append(room)
            self.RoomsTableView.reloadData()
            }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Room.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = Room[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell")!
        cell.textLabel?.text = room.RoomName
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let SelectedRoom = Room[indexPath.row]
        
        let ChatRoom = self.storyboard?.instantiateViewController(withIdentifier: "ChatPageVC")as!ChatPageVC
        
        ChatRoom.room = SelectedRoom
        
        self.navigationController?.pushViewController(ChatRoom, animated: true)
    }
    
    

    @IBAction func LogoutPressed(_ sender: Any) {
        
       try! Auth.auth().signOut() // اجباري يعمل sign out لما يدوس علي زرار
        PresentFormScreen()
    }
    
    
    func PresentFormScreen ()
    {
        let ViewForm = self.storyboard?.instantiateViewController(withIdentifier: "LoginForm")as!ViewController
        self.present(ViewForm, animated: true, completion: nil)
        
    }
    
    
    @IBAction func PressedAddBtn(_ sender: Any) {
        let CretaeroomVc = storyboard?.instantiateViewController(withIdentifier: "CreateRoomVC") as! CreateRoomVC
        
        CretaeroomVc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 150)
        
        let navControler = UINavigationController(rootViewController: CretaeroomVc)
        
        navControler.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let popOver = navControler.popoverPresentationController
        
        popOver?.delegate = self
        popOver?.barButtonItem = sender as? UIBarButtonItem
        
        self.present(navControler, animated: true, completion: nil)
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    

}
