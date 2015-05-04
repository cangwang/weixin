//
//  ChatTableViewController.swift
//  weixin
//
//  Created by air on 15/4/19.
//  Copyright (c) 2015年 air. All rights reserved.
//

import UIKit

class ChatTableViewController: UITableViewController,XxDL {
    @IBOutlet weak var msgTF: UITextField!

    @IBAction func composing(sender: UITextField) {
        //构建XML元素message
        var xmlmessage : DDXMLElement = DDXMLElement.elementWithName("message") as! DDXMLElement
        
        //增加属性
        xmlmessage.addAttributeWithName("to", stringValue: ToBuddyName)
        xmlmessage.addAttributeWithName("from", stringValue: NSUserDefaults.standardUserDefaults().stringForKey("weixinID"))
        
        //构建正在输入
        var composing = DDXMLElement.elementWithName("composing") as! DDXMLElement
        composing.addAttributeWithName("xmlns", stringValue: "http://jabber.org/protocol/chatstates")
        
        //消息的子节点加入正文
        xmlmessage.addChild(composing)
        
        //通过通道发送XML文本
        zdl().xs!.sendElement(xmlmessage)
             
    }
    @IBAction func send(sender: UIBarButtonItem) {
        //获取聊天文本
        let msgStr = msgTF.text
        
        if !msgStr.isEmpty {
            //构建XML元素message
            var xmlmessage : DDXMLElement = DDXMLElement.elementWithName("message") as! DDXMLElement
            
            //增加属性
            xmlmessage.addAttributeWithName("type", stringValue: "chat")
            xmlmessage.addAttributeWithName("to", stringValue: ToBuddyName)
            xmlmessage.addAttributeWithName("from", stringValue: NSUserDefaults.standardUserDefaults().stringForKey("weixinID"))
            
            //构建正文
            var body = DDXMLElement.elementWithName("body") as! DDXMLElement
            body.setStringValue(msgStr)
            
            //消息的子节点加入正文
            xmlmessage.addChild(body)
            
            //通过通道发送XML文本
            zdl().xs!.sendElement(xmlmessage)
            
            //清空聊天框
            msgTF.text = ""
            
            //保存自己的消息
            var msg = WXMessage()
            msg.isMe = true
            msg.body = msgStr
            
            //加入到聊天记录
            msgList.append(msg)
            
            self.tableView.reloadData()
        }
    }
    
    //选择聊天的好友用户名
    var ToBuddyName = ""
    
    //聊天消息数组，作为表格数据源
    var msgList = [WXMessage]()
    
    
    //获取总代理
    func zdl() ->AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    //聊天记录
    func newMsg(aMsg: WXMessage) {
        //对方正在输入
        if aMsg.isComposing && aMsg.from == ToBuddyName {
            self.navigationItem.title = "对方正在输入..."
            
        //如果消息有正文，则加入到未读消息，通知表格刷新
        }else if aMsg.body != "" {
            //则加入到唯独消息组
            self.navigationItem.title = ToBuddyName
            msgList.append(aMsg)
            //通知表格刷新
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zdl().xxdl = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return msgList.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as! UITableViewCell

        //取对应的消息
        let msg = msgList[indexPath.row]
        
        //对单元格文本的格式做个调整
        if msg.isMe {
            //居右，灰色
            cell.textLabel?.textAlignment = .Right
            cell.textLabel?.textColor = UIColor.grayColor()
            
        }else {
            //默认是居左
            //cell.textLabel?.textAlignment = .Left
            cell.textLabel?.textColor = UIColor.orangeColor()
    
        }
        
        //单元格文本
        cell.textLabel?.text = msg.body
        
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
