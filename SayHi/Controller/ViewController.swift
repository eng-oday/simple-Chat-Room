//
//  ViewController.swift
//  SayHi
//
//  Created by Oday Dieg on 7/3/19.
//  Copyright © 2019 Oday Dieg. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    

    @IBOutlet weak var CollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.delegate = self
        CollectionView.dataSource = self
        
    
    }
    
    //For CollectionView
    //1
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    return 2
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.CollectionView.dequeueReusableCell(withReuseIdentifier: "FormCell", for: indexPath)as! FormCell
        if (indexPath.row == 0 ){//sign in
            cell.UsernameContainer.isHidden = true
            cell.ActionButton.setTitle("Login", for:.normal)
            cell.SlideButton.setTitle("Sign Up 👉", for: .normal)
            cell.SlideButton.addTarget(self, action: #selector(MoveToSignUpCell), for: .touchUpInside)
               cell.ActionButton.addTarget(self, action: #selector(PressedSignin), for: .touchUpInside)
            
        }else if (indexPath.row == 1) //sign up
        {
            cell.UsernameContainer.isHidden = false
            cell.ActionButton.setTitle("Sign Up", for:.normal)
            cell.SlideButton.setTitle("👈 Sign in", for: .normal)
             cell.SlideButton.addTarget(self, action: #selector(MoveToSignInCell), for: .touchUpInside)
            cell.ActionButton.addTarget(self, action: #selector(PressedSignUp), for: .touchUpInside)
        }
        
        
        return cell
    }
    
    //Sign In
    @objc func PressedSignin(_ sender: UIButton)
    {
    
        let indexPath = IndexPath(row: 0, section: 0)
        
        let cell = self.CollectionView.cellForItem(at:indexPath )as! FormCell
        
        guard let EmailAdress = cell.EmailTxtField.text , let Password = cell.PasswordTxtField.text
            else{
                return
        }
        
        if (EmailAdress.isEmpty == true || Password.isEmpty == true)
            
        {
            DisplayErrorToUser(ErrorTxt: "Please Enter Fields")
        }
        else{
        Auth.auth().signIn(withEmail: EmailAdress, password: Password) { (result, error) in
            if (error == nil)
            {
                self.dismiss(animated: true, completion: nil)
                print("hello")
            }
            else
            {
                self.DisplayErrorToUser(ErrorTxt: "Wrong user name or password")
            }
        }
        }
    
    }
    
    func DisplayErrorToUser(ErrorTxt: String)
    {
        let Alert = UIAlertController.init(title: "Error", message: ErrorTxt, preferredStyle: .alert)
        let DismissButton = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        Alert.addAction(DismissButton)
        self.present(Alert, animated: true, completion: nil)
    }
    
    
    //Sign Up
    @objc func PressedSignUp(_ sender: UIButton)
    {
        let indexPath = IndexPath(row: 1, section: 0)
        
        let cell = self.CollectionView.cellForItem(at:indexPath )as! FormCell
        
        guard let EmailAdress = cell.EmailTxtField.text , let Password = cell.PasswordTxtField.text
            else{
                return
        }
        
        Auth.auth().createUser(withEmail: EmailAdress, password: Password) { (Result, error) in
            
            if (error == nil)
            {
                guard let UserID = Result?.user.uid, let Username = cell.UserNameTxtField.text else {
                    return
                }
                 self.dismiss(animated: true, completion: nil)
                let reference = Database.database().reference()
                
               let User = reference.child("Users").child(UserID)
                
                let DataArray: [String: Any] = ["username": Username]
                
                User.setValue(DataArray)
                
            }
           
        }
        
    }
    
    
    @objc func MoveToSignUpCell (_ sender:UIButton)
    {
        let indexPath = IndexPath(row: 1, section: 0)
        
        self.CollectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
    @objc func MoveToSignInCell (_ sender:UIButton)
    {
        let indexPath = IndexPath(row: 0, section: 0)
        
        self.CollectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }


}

