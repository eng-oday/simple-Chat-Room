//
//  ChatCell.swift
//  SayHi
//
//  Created by Oday Dieg on 7/5/19.
//  Copyright © 2019 Oday Dieg. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    
    enum ChatBubbleStatus {
        case Recieve
        case Sender
    }
    
    
    @IBOutlet weak var UsernameLabel: UILabel!
    
    @IBOutlet weak var ChatTextView: UITextView!
    
    @IBOutlet weak var ChatStackView: UIStackView!
    
    
    @IBOutlet weak var ChatBubbleView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
         ChatBubbleView.layer.cornerRadius = 12
    }
    func SetMessage(Message: Message)
    {
        UsernameLabel.text = Message.SenderName
        ChatTextView.text = Message.MessageText
       
        
    }
    
    func setChatBubble (DirectOfMessage: ChatBubbleStatus)
    {
        if DirectOfMessage == .Recieve
        {
            ChatStackView.alignment = .leading
            ChatBubbleView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
        else if DirectOfMessage == .Sender
        {
            ChatStackView.alignment = .trailing
            ChatBubbleView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        
    }
    
    
}
