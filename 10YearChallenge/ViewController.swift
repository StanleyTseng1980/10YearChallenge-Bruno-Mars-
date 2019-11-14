//
//  ViewController.swift
//  10YearChallenge
//
//  Created by Stanley Tseng on 2019/11/13.
//  Copyright © 2019 StanleyAppWorld. All rights reserved.
//
//  大部分程式碼皆參考自永展學長
//  將照片陣列pics與音樂陣列內的名稱皆做相同設定，故可直接取用pics的陣列
//  預計增加功能-自動播放下一首歌（尚在尋找解決方案）
//  目前沒有Auto Layout，在iPhone11是正常的，其他款式就不確定了...

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var songName: UILabel!
    
    let dateFormatter = DateFormatter()
    var player = AVQueuePlayer()
    var looper: AVPlayerLooper? 
    var picDate:String = ""
    var timer:Timer?
    var picNum = 0
    var sliderValue = 0
    let pics = ["20091215Nothin On You","20100309Billionaire","20100720Just The Way You Are","20100928Grenade","20101004Runaway Baby","20110215The Lazy Song","20110822Marry You","20111107Count On Me","20121206Locked Out Of Heaven","20130115When I Was Your Man","20130617Treasure","20141110Uptown Funk","20170130That’s What I Like","2016100724K Magic","20180103Finesse"]
    
    // 設定音樂播放與重複播放
    func nowPlaySong() {
        
        let nowSong = pics[picNum]
        let sound = Bundle.main.path(forResource: nowSong, ofType: "mp3")
        let item = AVPlayerItem(url: URL(fileURLWithPath: sound!))
        looper = AVPlayerLooper(player: player, templateItem: item)
        // 若不需要自動重播，上面的兩行註解掉，改用下面這一行
        //        player = AVQueuePlayer(url:URL(fileURLWithPath: sound!))
        player.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.locale = Locale(identifier: "zh_TW")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        picView.image = UIImage(named: pics[picNum])
        let original = pics[picNum]
        songName.text = String(original.dropFirst(8))
        nowPlaySong()
        player.pause()
        
    }
    // 設定專輯照片自動輪播並設定移除日期的歌曲名稱
    func autoPicNum() {
        
        if picNum >= pics.count {
            picNum = 0
            choosePic(num: picNum)
            picView.image = UIImage(named: pics[picNum])
            
        }else{
            
            choosePic(num: picNum)
            picView.image = UIImage(named: pics[picNum])
        }
        let original = pics[picNum]
        songName.text = String(original.dropFirst(8))
        timeSlider.value = Float(picNum)
        picNum += 1
    }
    // 設定自動輪播時間
    func time() {
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true){(timer) in self.autoPicNum()}
    }
    
    // 用Slider控制專輯照片與音樂曲目播放並設定移除日期的歌曲名稱
    @IBAction func changeValueSlider(_ sender: UISlider) {
        sender.value.round()
        sliderValue = Int(sender.value)
        picView.image = UIImage(named: pics[sliderValue])
        choosePic(num: sliderValue)
        picNum = sliderValue
        let original = pics[picNum]
        songName.text = String(original.dropFirst(8))
    }
    
    // 自動播放照片
    @IBAction func autoPlaySwitch(_ sender: UISwitch) {
        if sender.isOn {
            
            sliderValue = Int(timeSlider.value)
            time()
            picNum = sliderValue
            timeSlider.value = Float(picNum)
            
        }else{
            timer?.invalidate()
        }
    }
    
    //用switch-case管理專輯時間點
    func choosePic(num:Int) {
        switch num {
        case 0:
            picDate = "2009/12/15"
        case 1:
            picDate = "2010/03/09"
        case 2:
            picDate = "2010/07/20"
        case 3:
            picDate = "2010/09/28"
        case 4:
            picDate = "2010/10/04"
        case 5:
            picDate = "2011/02/15"
        case 6:
            picDate = "2011/08/22"
        case 7:
            picDate = "2011/11/07"
        case 8:
            picDate = "2012/12/06"
        case 9:
            picDate = "2013/01/15"
        case 10:
            picDate = "2013/06/17"
        case 11:
            picDate = "2014/11/10"
        case 12:
            picDate = "2016/10/07"
        case 13:
            picDate = "2017/01/30"
        default:
            picDate = "2018/01/03"
        }
        let date = dateFormatter.date(from: picDate)
        datePicker.date = date!
    }
    
    // 切換播放目前sliderValue的歌曲
    @IBAction func changeNewSong(_ sender: Any) {
        nowPlaySong()
    }
    
    // 上一首
    @IBAction func back(_ sender: Any) {
        sliderValue = Int(timeSlider.value)
        picNum = sliderValue
        if picNum == 0 {
            picNum = pics.count-1
        } else if picNum > 0 && picNum <= pics.count-1 {
            picNum -= 1
        } else {
            picNum -= 1
        }
        nowPlaySong()
        player.play()
        sliderValue = picNum
        autoPicNum()
    }
    
    // 播放
    @IBAction func play(_ sender: Any) {
        
        if sliderValue == Int(timeSlider.value) && picNum == sliderValue {
            nowPlaySong()
            picNum = 0
        } else if picNum == sliderValue   {
            player.play()
        } else {
            player.play()
        }
    }
    
    // 暫停
    @IBAction func pause(_ sender: Any) {
        player.pause()
    }
    
    // 下一首
    @IBAction func forward(_ sender: Any) {
        sliderValue = Int(timeSlider.value)
        picNum = sliderValue
        if picNum == pics.count-1  {
            picNum = 0
        } else {
            picNum += 1
        }
        nowPlaySong()
        player.play()
        sliderValue = picNum
        autoPicNum()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
}
