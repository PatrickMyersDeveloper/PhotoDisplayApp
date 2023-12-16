/* Patrick Myers, Photo Button App
 The purpose of this app is to take a file path from the user.
 From there, the app looks for all files in that location that
 end in ".jpg" We then generate a button for each image and
 display the image on screen that corresponds with each button.*/
import UIKit

class ViewController: UIViewController {

    var input:UITextField?
    var instructions:UILabel?
    var buttons:[UIButton?] = []
    var sv:UIScrollView?
    var filepath:String?
    var submit:UIButton?
    var display:UIImageView?
    var disImgTitle:String? = ""
    var imgButton:UIButton?
    var filenames:[String?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filepath = "" // will crash without a real filepath as a default
        
        // Create a scroll view to accomadate a large amount of buttons
        sv = UIScrollView()
        sv!.frame = CGRect (x:0,y:0,width:view.frame.size.width,height:view.frame.size.height)
        sv!.contentSize = CGSize (width:view.frame.size.width,height:4000)
        sv!.backgroundColor = UIColor.white
        
        // Prompt for file path to be entered
        instructions = UILabel(frame: CGRect(x: 50, y: 50, width: 200, height: 20))
        instructions!.center = CGPoint(x: 200, y: 50)
        instructions!.textAlignment = .center
        instructions!.text = "Enter a file path: "
        instructions!.textColor = UIColor.black
        sv!.addSubview(instructions!)
        
        // Take in text from the user
        input = UITextField()
        input!.frame = CGRect (x:50, y:70, width:300, height: 50)
        input!.backgroundColor = UIColor.systemMint
        input!.textAlignment = .center
        input!.text = "Your Text Here"
        input!.clearsOnBeginEditing = true
        sv!.addSubview(input!)
        
        // Allow the user to submit the filepath
        submit = UIButton()
        submit!.frame = CGRect (x:50, y:150, width:300, height: 50)
        submit!.backgroundColor = UIColor.black
        submit!.setTitleColor (UIColor.white,for:UIControl.State.normal)
        submit!.setTitle ("Submit",for:UIControl.State.normal)
        sv!.addSubview(submit!)
        submit!.addTarget(self,action:#selector(clicked),for:UIControl.Event.touchUpInside)

        // add scrollview to the view
        view!.addSubview (sv!)
        
    }
    // This function runs when the button is clicked, it takes in the filepath and stores it in a var
    @IBAction func clicked () {
        filepath = input!.text
        
        // Get all the files from the path specified by the user, store in string array
        let enumerator = FileManager.default.enumerator(atPath:filepath!)
        var files = enumerator?.allObjects as! [String] //as! is a casting
        files.sort(){
        let s = $0.filter {$0.isLetter || $0.isNumber}
        let t = $1.filter {$0.isLetter || $0.isNumber}
        return s.lowercased() <= t.lowercased()
        }
        
        // If the file ends in ".jpg", store it in string array: filenames
        for i in files.indices {
            if files[i].hasSuffix(".jpg") {
                filenames.append(files[i])
            }
        }
        
        
        // Create a button for every file in the array of valid image filenames, store them in button array
        for i in filenames.indices {
            imgButton = UIButton()
            imgButton!.backgroundColor = UIColor.black
            imgButton!.setTitleColor (UIColor.white,for:UIControl.State.normal)
            imgButton!.setTitle (filenames[i],for:UIControl.State.normal)
            imgButton!.frame = CGRect (x:50,y:700+60*i,width:300,height:50)
            buttons.append(imgButton!)
            sv!.addSubview(imgButton!)
        }
        
        // Assign a tag to each button so that when it is clicked, it can be reference in the IBAction function
        for i in buttons.indices {
            buttons[i]!.tag = i
            buttons[i]!.addTarget(self,action:#selector(buttArrClicked),for:UIControl.Event.touchUpInside)
        }
        
        
    }
    
    // The imageView filepath will be changed depending on which button is clicked, via the tag
    @IBAction func buttArrClicked (sender:UIButton) {
        
        let x = sender.tag
        disImgTitle = filenames[x]
        
   
        // Create a display for the photo with the image specified by the button
        display = UIImageView()
        var imagePath = filepath! + "/" + disImgTitle!
        let image = UIImage(contentsOfFile: imagePath)
        display?.image = image
        display!.frame = CGRect (x:50, y:350, width:300, height: 300)
        sv!.addSubview(display!)
        

    }
    
}
