//
//  ChannelController.swift
//  yousdt
//
//  Created by You.Xiang on 15/6/17.
//  Copyright (c) 2015年 You.Xiang. All rights reserved.
//

import UIKit

protocol ChannelProtocol{
    func onChangeChaneel(channel_id:String)
}

class ChannelController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var channel: UITableView!
    
    //接收频道数据
    var channelData:[JSON] = []
    var delegate:ChannelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0.8
    }

    //初始化表格
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channelData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = channel.dequeueReusableCellWithIdentifier("channel") as! UITableViewCell
        
        //获取行数据
        var rowData = self.channelData[indexPath.row] as JSON
        //设置主标题
        cell.textLabel?.text = rowData["name"].string
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let rowData:JSON = self.channelData[indexPath.row] as JSON
        let channel_id:String = rowData["channel_id"].stringValue
        delegate?.onChangeChaneel(channel_id)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
