//
//  ViewController.swift
//  Jumpy Horse
//
//  Created by Mary  on 12/4/22.
//

import UIKit
import SpriteKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var back2: UIImageView!
    @IBOutlet weak var horse: UIImageView!
    @IBOutlet var obstacle: UIImageView!
    @IBOutlet var treat: UIImageView!
    @IBOutlet var wall: UIImageView!
    var jumps:Int=5
    var backImage:String="mountain"
    var gallopSound:String="gallop"
    var score:Int=0
    var bgTimer: Timer?
    var obstacleTimer: Timer?
    var goodiesTimer:Timer?
    var changeBGTimer: Timer?
    var gallopTimer: Timer?
    var gameOver:Bool = false
    @IBOutlet weak var jumpsLabel: UILabel!
    
    override func viewDidLoad() {
       
        let height=view.frame.height-(view.frame.height/3.5)
        horse.center.y=height
        obstacle.center.y=height+10
        wall.center.y=height-5
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        back2.frame.origin.x=background.frame.width
        wall.frame.origin.x=background.frame.width
        obstacle.frame.origin.x=background.frame.width
        treat.frame.origin.x=background.frame.width
        
        if let soundURL = Bundle.main.url(forResource: "gallop", withExtension: "wav")
        {
            var soundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundId)
            AudioServicesPlaySystemSound(soundId)
        }
        
        bgTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(moveGrass), userInfo: nil, repeats: true)
        obstacleTimer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(generateObstacles), userInfo: nil, repeats: true)
        goodiesTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(generateGoodies), userInfo: nil, repeats: true)
        changeBGTimer = Timer.scheduledTimer(timeInterval: 13, target: self, selector: #selector(changeBackground), userInfo: nil, repeats: true)
        gallopTimer = Timer.scheduledTimer(timeInterval: 13, target: self, selector: #selector(gallop), userInfo: nil, repeats: true)
        let tap=UITapGestureRecognizer(target: self, action: #selector(tap))
        let doubleTap=UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        doubleTap.numberOfTapsRequired=2
        self.view.addGestureRecognizer(tap)
        self.view.addGestureRecognizer(doubleTap)
        var runningImages: [UIImage]=[]
        
        for i in 1...14{
            runningImages.append(UIImage(named: "run\(i).tiff")!)
        }
        horse.animationImages=runningImages
        horse.animationDuration=0.7
        horse.animationRepeatCount=0
        horse.startAnimating()
    }
    
    @objc func moveGrass(){
        if(background.frame.origin.x<(-background.frame.width)){
            background.frame.origin.x=back2.frame.origin.x
        }
        background.center.x-=3
        back2.frame.origin.x=background.frame.width+background.frame.origin.x
        
    }
    @objc func tap(){
        var jump:Int=50
        var bool:Bool=false
        horse.stopAnimating()
        //    horse.image=UIImage(named: "jump.jpeg")!
        Timer.scheduledTimer(withTimeInterval: 0.008, repeats: true) { timer in
            if(bool==false){
                self.horse.center.y-=2
                jump-=2
                if(jump<=0){
                    bool=true
                }
            }
            if(bool==true){
                self.horse.center.y+=2
                jump+=2
                if(jump>=50){
                    self.horse.startAnimating()
                    timer.invalidate()
                }
            }
            
        }
    }
    
    @objc func doubleTap(){
        if(jumps>0){
            jumps-=1;
            jumpsLabel.text=("Jumps: \(jumps)");
            jumpSound()
            var jump:Int=75
            var bool:Bool=false
            horse.stopAnimating()
            //  horse.image=UIImage(named: "jump.jpeg")!
            Timer.scheduledTimer(withTimeInterval: 0.008, repeats: true) { timer in
                if(bool==false){
                    self.horse.center.y-=2
                    jump-=2
                    if(jump<=0){
                        bool=true
                    }
                }
                if(bool==true){
                    self.horse.center.y+=2
                    jump+=2
                    if(jump>=75){
                        self.horse.startAnimating()
                        timer.invalidate()
                    }
                }
            }
        }
    }
    @objc func generateObstacles(){
        let speed:Float=Float.random(in:3...4)
        let random:Int=Int.random(in: 1...5)
        var bool:Bool=false
        if(random==1 || random==3){ //generate obstacle 1
            if(random==1){
                self.obstacle.image=UIImage(named: "fence1.png")!
            }
            else{
                cowboySound()
                self.obstacle.image=UIImage(named: "fence2.png")!
            }
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                if(bool==false){
                    self.obstacle.center.x=self.view.frame.width
                    bool=true
                }
                if(self.obstacle.center.x<=(self.horse.center.x+50) && self.obstacle.center.x>=(self.horse.center.x-50) && self.obstacle.center.y<=(self.horse.center.y+50) && self.obstacle.center.y>=(self.horse.center.y-50) &&
                   !self.gameOver){
                    self.gameOver=true
                    self.segue()
                    timer.invalidate()
                }
                if(bool==true){
                    self.obstacle.center.x-=CGFloat(speed)
                    if((self.obstacle.frame.origin.x+self.obstacle.frame.width)<=0){
                        self.score=self.score+1
                        timer.invalidate()
                        bool=false;
                    }
                }
            }
        }
        else if (random==2 || random == 4){ //generate obstacle 2
            if(random==2){
                lionSound()
                self.wall.image=UIImage(named: "wall.png")!
            }
            else{
                fireSound()
                self.wall.image=UIImage(named: "wall2.png")!
            }
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                if(bool==false){
                    self.wall.center.x=self.view.frame.width
                    bool=true
                }
                if(self.wall.center.x<=(self.horse.center.x+70) && self.wall.center.x>=(self.horse.center.x-70) && self.wall.center.y<=(self.horse.center.y+70) && self.wall.center.y>=(self.horse.center.y-70) &&
                   !self.gameOver){
                    self.gameOver=true
                    self.segue()
                    timer.invalidate()
                }
                if(bool==true){
                    self.wall.center.x-=CGFloat(speed)
                    if((self.wall.frame.origin.x+self.wall.frame.width)<=0){
                        self.score=self.score+2
                        timer.invalidate()
                        bool=false;
                    }
                }
            }
        }
    }
    @objc func generateGoodies(){
        let height:Int=Int.random(in:-50...50)
        treat.center.y+=CGFloat(height)
        if(treat.center.y>(self.view.frame.height-150)){
            treat.center.y=(self.view.frame.height-150)
        }
        else if(treat.center.y<=150){
            treat.center.y=150
        }
        let speed:Float=Float.random(in:3...3.5)
        var bool:Bool=false
        let rand:Int=Int.random(in: 1...3)
        treat.isHidden=false
        self.treat.image=UIImage(named: "treat\(rand).png")!
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if(bool==false){
                self.treat.center.x=self.view.frame.width
                bool=true
            }
            if(bool==true){
                self.treat.center.x-=CGFloat(speed)
                if(self.treat.center.x<=(self.horse.center.x+25) && self.treat.center.x>=(self.horse.center.x-25) && self.treat.center.y<=(self.horse.center.y+25) && self.treat.center.y>=(self.horse.center.y-25) &&
                    self.treat.isHidden==false){
                    self.jumps+=5;
                    self.jumpsLabel.text=("Jumps: \(self.jumps)");
                    self.score=self.score+1
                    self.treat.isHidden=true
                    if let soundURL = Bundle.main.url(forResource: "eat", withExtension: "mp3")
                    {
                        var soundId: SystemSoundID = 0
                        AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundId)
                        AudioServicesPlaySystemSound(soundId)
                    }
                }
                if((self.treat.frame.origin.x+self.treat.frame.width)<=0){
                    timer.invalidate()
                    bool=false;
                }
            }
        }
    }
    @objc func changeBackground(){
        if(backImage=="mountain"){
            gallopSound="desert"
            background.image=UIImage(named: "desert.jpg")!
            back2.image=UIImage(named: "desert.jpg")!
            backImage="desert"
        }
        else{
            gallopSound="gallop"
            background.image=UIImage(named: "mountain.jpg")!
            back2.image=UIImage(named: "mountain.jpg")!
            backImage="mountain"
        }
    }
    @objc func gallop()
    {
        if let soundURL = Bundle.main.url(forResource: gallopSound, withExtension: "wav")
        {
            var soundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundId)
            AudioServicesPlaySystemSound(soundId)
        }
    }
    func jumpSound(){
        if let soundURL = Bundle.main.url(forResource: "jump", withExtension: "mp3")
        {
            var soundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundId)
            AudioServicesPlaySystemSound(soundId)
        }
    }
    func neigh(){
        if let soundURL = Bundle.main.url(forResource: "neigh", withExtension: "mp3")
        {
            var soundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundId)
            AudioServicesPlaySystemSound(soundId)
        }
    }
    func fireSound(){
        if let soundURL = Bundle.main.url(forResource: "fire", withExtension: "mp3")
        {
            var soundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundId)
            AudioServicesPlaySystemSound(soundId)
        }
    }
    func cowboySound(){
        if let soundURL = Bundle.main.url(forResource: "cowboy", withExtension: "mp3")
        {
            var soundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundId)
            AudioServicesPlaySystemSound(soundId)
        }
    }
    func lionSound(){
        if let soundURL = Bundle.main.url(forResource: "lion", withExtension: "mp3")
        {
            var soundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundId)
            AudioServicesPlaySystemSound(soundId)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "GameOver",
              let destinationVC = segue.destination as?
                GOViewController{
                destinationVC.numberToDisplay = score
          }
      }
    func segue(){
        neigh()
        bgTimer?.invalidate()
        obstacleTimer?.invalidate()
        goodiesTimer?.invalidate()
        changeBGTimer?.invalidate()
        gallopTimer?.invalidate()
        performSegue(withIdentifier: "GameOver", sender: self)
    }
    }



