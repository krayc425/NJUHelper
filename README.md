# NJU_GPA_Calculator
A GPA calculator for Nanjing University students, running on iOS 9.0 or later.

![image](https://github.com/songkuixi/NJU_GPA_Calculator/blob/master/IMG_0578.JPG)

## Prerequisites
#### Server
* `Python 3`
* `Django`
* `urllib.request`, `urllib.parse`
* `http.cookiejar`
  
#### iOS Client
* `Swift 3`
* `CocoaPods`, see: [CocoaPods](https://cocoapods.org)

## Instruction
#### Start the server 
__Only if you want to run the server on your own computer.__

```
cd GPA_Cal_Server
python3 manage.py runserver
```

#### Build the app
```
cd GPA\ Cal
pod install
```
Then open `GPA Cal.xcworkspace`, and press `Cmd + R` to run.


