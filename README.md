# NJU_GPA_Calculator
A GPA calculator for Nanjing University students, running on iOS 9.0 or later.

## Prerequisites
#### Server
* `Python 3`
* `Django`
* `urllib.request`, `urllib.parse`
* `http.cookiejar`
  
#### iOS Client
* `Swift 3`
* `Pod`

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


