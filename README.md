##一个简单的iOS倒计时控件
![Demo Image](https://raw.githubusercontent.com/RockefellerZQ/CountDownView/master/Image/Demo.png)

####初始化
将ZQCountDownView添加到你的项目工程，然后可以通过代码或者xib的形式进行初始化

````
_recoderTimeIntervalDidInBackground = YES
````

_recoderTimeIntervalDidInBackground等于YES的时候，应用程序进入后台会记录当前剩余的倒计时和进入后台的时间，当应用程序再次进入前台时倒计时会减掉中间的时间差。（程序进入后台一段时间后，定时器会暂停计时）

####pod 安装
pod 'ZQCountDownView', '~> 0.0.1'
