FFCircularProgressView [![Build Status](https://travis-ci.org/elbryan/FFCircularProgressView.png?branch=master)](https://travis-ci.org/elbryan/FFCircularProgressView)
======================

FFCircularProgressView - An iOS 7-inspired blue circular progress view

![ss1](https://raw.github.com/elbryan/FFCircularProgressView/master/Media/ss1.png) ![ss2](https://raw.github.com/elbryan/FFCircularProgressView/master/Media/ss2.png) ![ss3](https://raw.github.com/elbryan/FFCircularProgressView/master/Media/ss3.png) ![ss4](https://raw.github.com/elbryan/FFCircularProgressView/master/Media/ss4.png)

This progress view is inspired by the new progress view in the App Store, iOS 7. Also the colors are taken from there.

## See it in action

 [![sample](https://raw.github.com/elbryan/FFCircularProgressView/master/Media/sample.gif)](https://raw.github.com/elbryan/FFCircularProgressView/master/Media/sample.mov)

## Requirements

FFCircularProgressView works on iOS version > 5 and is compatible with both ARC and non-ARC projects. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* Foundation.framework
* UIKit.framework
* CoreGraphics.framework
* QuartzCore.framework

You will need LLVM 3.0 or later in order to build FFCircularProgressView.

## Adding FFCircularProgressView to your project

There are plenty of ways to add this view to your project.
Make sure you add the aforementioned frameworks to your project as well.

### GIT submodule

You have the canonical `git submodule` option. Simply issue `git submodule add https://github.com/elbryan/FFCircularProgressView.git <path>` in your root folder of your repository.

### CocoaPods

1. Add a pod entry to your [Podfile](https://github.com/CocoaPods/CocoaPods/wiki/A-Podfile) dependencies file such as `pod 'FFCircularProgressView', '>= 0.1'`.
2. Install the pod(s) by running `pod install`.
3. Import the progress view with `#import "FFCircularProgressView.h" wherever you need in your project.

### Source files

Manually add the source files to your project. The files you need are 'FFCircularProgressView.h', 'FFCircularProgressView.m', 'UIColor+iOS7.h', 'UIColor+iOS7.m'.

## Usage

Just use it as it is a normal UIProgressView. Make sure you set the progress value in the main thread ;)

```objective-c
double delayInSeconds = 2.0;
dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0), ^{
        for (float i=0; i<1.1; i+=0.01F) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [circularProgressView setProgress:i];
            });
            usleep(10000);
        }            
    });
});
```

You can also control the progress view spin animation by using the following two methods to start and stop the spinning, respectively:

```objective-c
// Start spinning
[circularProgressView startSpinProgressBackgroundLayer];

// Stop spinning
[circularProgressView stopSpinProgressBackgroundLayer];
```

## Acknowledgments

The code to draw the tick has been adapted from [GSProgressView](https://github.com/goosoftware/GSProgressView/blob/master/GSProgressView.m).

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE). 

## Attributions

I do not demand to be mentioned in your apps nor to receive any kind of compensation if you use this code. Yet, I would like to have feedbacks if you use it and you like it.

Follow me on Twitter: [@elbryanlos](https://twitter.com/elbryanlos)

## Android

Are you an Android developer and you love this progress view? No problem! A couple of folks ported it to Android OS and you can get it [here](https://github.com/torryharris/TH-ProgressButton).

Thank you guys!
