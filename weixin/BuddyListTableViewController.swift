//
//  BuddyListTableViewController.swift
//  weixin
//
//  Created by air on 15/4/18.
//  Copyright (c) 2015年 air. All rights reserved.
//

import UIKit

class BuddyListTableViewController: UITableViewController,ZtDL,XxDL{
    //未读消息数组，作为表格数据源
    var unreadList = [WXMessage]()
    
    //状态数据源
    var ztList = [Zhuangtai]()
    
    
    //已登录
    var logged = false
    
    //聊天的好友用户名
    var currentBuddyName = ""
    
    @IBOutlet weak var mystatus: UIBarButtonItem!
    
    @IBAction func log(sender: UIBarButtonItem) {
        //根据在线状况，调整状态图片和进行上下线操作
        if logged {
            logoff()
            //图片更改成离线
            sender.image = UIImage(named: "off")
        }else {
            login()
            sender.image = UIImage(named: "on")
        }
    }
    
    //获取总代理
    func zdl() ->AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    //自己离线
    func meOff() {
        logoff()
    }
    
    //上线状态处理
    func isOn(zt: Zhuangtai) {
        //逐条查找
        for (index,oldzt) in enumerate(ztList){
            //如果找到旧用户的状态
            if zt.name == oldzt.name {
                //就移除掉旧的用户状态
                ztList.removeAtIndex(index)
                //一旦找到，就不找了，退出循环
                break
            }
        }
        //添加新状态到状态数组
        ztList.append(zt)
        
        //通知表格更新
        self.tableView.reloadData()
    }
    
    //收到离线或未读消息
    func newMsg(aMsg: WXMessage) {
        //如果消息有正文，则加入到未读消息，通知表格刷新
        if aMsg.body != "" {
            //则加入到唯独消息组
            unreadList.append(aMsg)
            //通知表格刷新
            self.tableView.reloadData()
        }
    }
    
    
    //下线状态处理
    func isOff(zt: Zhuangtai) {
        //逐条查找
        for (index,oldzt) in enumerate(ztList){
            //如果找到旧用户的状态
            if zt.name == oldzt.name {
                //就更改旧的用户状态
                ztList[index].isOnline = false
                //一旦找到，就不找了，退出循环
                break
            }
        }
        
        //通知表格更新
        self.tableView.reloadData()
        
    }
    
    //登入
    func login() {
        //清空数据源
        unreadList.removeAll(keepCapacity: false)
        ztList.removeAll(keepCapacity: false)
        
        zdl().connect()
        logged = true
        mystatus.image = UIImage(named: "on")
        
        //导航标题
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        self.navigationItem.title = myID! + "的好友"
        
        //通知表格刷新
        self.tableView.reloadData()
    }
    
    //登出
    func logoff() {
        //清空数据源
        unreadList.removeAll(keepCapacity: false)
        ztList.removeAll(keepCapacity: false)
        
        zdl().disconnect()
        logged = false
        mystatus.image = UIImage(named: "off")
        
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //取用户名
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        
        //取自动登录
        let autologin = NSUserDefaults.standardUserDefaults().boolForKey("wxautologin")
        
        //配置用户名和自动登录
        if myID != nil && autologin {
            self.login()
            self.navigationItem.title = myID! + "的好友"
        } else {
            self.performSegueWithIdentifier("toLoginSegue", sender: self)
        }
        //接管状态代理
        zdl().ztdl = self
        
        //接管消息代理
        zdl().xxdl = self

    }
    
    override func viewDidDisappear(animated: Bool) {
        
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
        return ztList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("buddyListCell", forIndexPath: indexPath) as! UITableViewCell
        //好友状态
        let online = ztList[indexPath.row].isOnline
        //好友名称
        let name = ztList[indexPath.row].name
        
        //未读消息的条数
        var unreads = 0
        //查找相应好友的未读条数
        for msg in unreadList {
            if name == msg.from {
                unreads++
            }
            
        }
        
        //单元格文本
        cell.textLabel?.text = name + "(\(unreads))"
        
        //单元格图像
        if online {
            cell.imageView?.image = UIImage(named: "on")
        } else {
            cell.imageView?.image = UIImage(named: "off")
        }

        return cell
    }
    
    //选择单元格
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //保存好友用户名
        currentBuddyName = ztList[indexPath.row].name
        
        //跳转到聊天视图的场景
        self.performSegueWithIdentifier("toChatSegue", sender: self)
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


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //判断一下是否转到聊天界面
        if (segue.identifier == "toChatSegue") {
            //取得聊天视图控制器
            let dest = segue.destinationViewController as! ChatTableViewController
            //把当前选择的聊天用户名传递聊天视图
            dest.ToBuddyName = currentBuddyName
            
            //把未读消息传递给聊天视图
            for msg in unreadList {
                if msg.from == currentBuddyName {
                    //加入到聊天视图的消息组中
                    dest.msgList.append(msg)
                }
            }
             /*
            //把相应的未读消息从未读消息组中移除
            var count = 0
            for (index,msg) in enumerate(unreadList) {
                if msg.from == currentBuddyName {
                    //加入到聊天视图的消息组中
                    dest.msgList.append(msg)
                    //移除未读消息组
                    unreadList.removeAtIndex(index-count)
                    count++
                }
            }
            */
            //把相应的未读消息从未读消息组中移除 小波
            removeValuefromArray(currentBuddyName, &unreadList)
            
            //刷新表格
            self.tableView.reloadData()
        }
    }

    @IBAction func unwindToBlist(segue: UIStoryboardSegue) {
       //如果是登录界面的完成按钮,开始登录
        let source = segue.sourceViewController as! LoginViewController
        if source.requireLogin {
            //注销用户
            self.logoff()
            //登录新用户
            self.login()
        }else {
            
        }
    }


}
