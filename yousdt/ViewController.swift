//
//  ViewController.swift
//  yousdt
//
//  Created by You.Xiang on 15/6/16.
//  Copyright (c) 2015年 You.Xiang. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,HttpProtocol,ChannelProtocol {
    
    @IBOutlet weak var logo: LogoController!
    @IBOutlet weak var tv: musicList!
    @IBOutlet weak var playTime: UILabel!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var progress: UIImageView!
    
    var ehttp = HttpController()
    var tableData:[JSON] = []
    var channelData:[JSON] = []
    
    //媒体播放器
    var audioPlayer:MPMoviePlayerController = MPMoviePlayerController()
    //定时器
    var concatTime:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置数据源和代理
        tv.dataSource = self
        tv.delegate = self
        ehttp.delegate = self
        //获取频道数据
        ehttp.onSearch("http://www.douban.com/j/app/radio/channels")
        //获取默认频道数据
        ehttp.onSearch("http://douban.fm/j/mine/playlist?type=n&channel=0&from=mainsite")
        tv.backgroundColor = UIColor.clearColor()
        //创建模糊效果
        var effect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effetcView = UIVisualEffectView(effect: effect)
        effetcView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        bg.addSubview(effetcView)
        logo.FlipForLogo()
    }
    
    func insertBlurView (view: UIView,  style: UIBlurEffectStyle) {
        view.backgroundColor = UIColor.clearColor()
        
        var blurEffect = UIBlurEffect(style: style)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.insertSubview(blurEffectView, atIndex: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didRecieveResults(results: AnyObject) {
        let json = JSON(results)

        if let channel = json["channels"].array {
            self.channelData = channel
        }else if let song =  json["song"].array {
            self.tableData = song
            self.tv.reloadData()
            onSelectRow(0)
        }
    }
    //初始化表格
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("yous") as! UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        //获取table数据
        let rowData:JSON = tableData[indexPath.row]
        //设置主标题
        cell.textLabel?.text = rowData["title"].string
        //设置自标题
        cell.detailTextLabel?.text = rowData["artist"].string
        cell.imageView?.image = UIImage(named: "detail")
        //设置缩略图
        var picture_url = rowData["picture"].string
        Alamofire.manager.request(Method.GET, picture_url!).response { (_, _, data, error) -> Void in
            var picture = UIImage(data: data! as! NSData)
            cell.imageView?.image = picture
        }
        self.logo.FlipForLogo()        
        return cell
    }
    //播放音乐
    func playerMusic(url:String){
        //停止播放所有音乐
        self.audioPlayer.stop()
        //设置音乐地址
        self.audioPlayer.contentURL = NSURL(string: url)
        //播放
        self.audioPlayer.play()
        
        //定时器设置
        concatTime?.invalidate()
        playTime.text = "00:00"
        //启动计时器
        concatTime = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "onUpdate", userInfo: nil, repeats: true)
    }
    
    //计时器更新方法
    func onUpdate(){
        let c = audioPlayer.currentPlaybackTime
        if c > 0.0{
            //歌曲总时间
            let total = audioPlayer.duration
            //进度条
            let prec:CGFloat = CGFloat(c/total)
            progress.frame.size.width = view.frame.size.width * prec
            
            let all:Int = Int(c)
            let sec = all % 60
            let min = Int(all/60)
            
            var time:String = ""
            
            if min < 10{
                time = "0\(min):"
            }else{
                time = "\(min):"
            }
            
            if sec < 10 {
                time += "0\(sec)"
            }else{
                time += "\(sec)"
            }
            //更新时间
            playTime.text = time
        }
    }
    //点击歌曲
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.onSelectRow(indexPath.row)
    }
    //选中行
    func onSelectRow(index:Int){
        self.logo.FlipForLogo()
        //构建一个索引的path
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        //设置选中的效果
        tv.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        //获取行数据
        var rowData:JSON = tableData[index]
        //获取图片
        var picture_url = rowData["picture"].stringValue
        onSetImage(picture_url)
        //播放音乐
        var music_url = rowData["url"].string!
        playerMusic(music_url)
    }
    //设置歌曲的封面以及背景
    func onSetImage(url:String){
        //通过网络获取图片
        Alamofire.manager.request(Method.GET, url).response { (_, _, data, error) -> Void in
            var picture = UIImage(data: data! as! NSData)
            self.logo.image = picture
            self.bg.image = picture
        }
    }
    //获取跳转目标
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var channelC:ChannelController = segue.destinationViewController as! ChannelController
        channelC.delegate = self
        channelC.channelData = self.channelData
    }
    //channel
    func onChangeChaneel(channel_id: String) {
        //频道地址更改
        var url:String = "http://douban.fm/j/mine/playlist?type=n&channel=\(channel_id)&from=mainsite"
        ehttp.onSearch(url)
        
    }
}










