# PhotoGamut
Sample iOS Project

This is the basic framework for a sample iOS project.  The app will sort all of your photos by color.  
*Note: the actual sorting algorithm is missing from this code.  That's just for me to know :)*

Please be aware: this is just the very bare bones project framework for demo purposes only.  There are still many improvements needed for this to be a true app.


**Before** | **After**
:---------:|:---------:
![PhotoGamut_Before](https://user-images.githubusercontent.com/113631682/191107386-5e6c4aa8-ba83-449c-ad21-505519902873.png) | ![PhotoGamut_After](https://user-images.githubusercontent.com/113631682/191107397-93248d1b-fc18-4d6e-b710-412e59959ac6.png)
  
Not a *huge* difference, but the blues, reds, and yellows are grouped in the **After** image.  
  
## Motivation

The main reason for building this demo app was to refresh my skills working with Interface Builder/Scenes.  I primarily work with programatically defined interfaces in SwiftUI these days.  So this was a good weekend refresher project.
  
## Getting Started
  
If you would like to try it out, you'll need a few things first:  
* a clone of this repo
* [`xcodegen`](https://github.com/yonaskolb/XcodeGen) for building the project and info.plist files
* [Xcode](https://developer.apple.com/xcode/) for building the app  
  
Once you have everything you need, just:  
1. Open a terminal and `cd` into the repo directory  
`$ cd PhotoGamut`  
2. Generate the project and info.plist files  
`$ xcodegen`  
3. Open the project in Xcode  
`$ xed PhotoGamut.xcodeproj/`  
4. Then just build and run!
  
## Additional Resources
  
You may find the app more interesting if your simulator has lots of photos on it.  There are several ways to get photos into your simulator's photo library, but here's the method I found to be most useful.  
> **Note**  
> *Make sure you have Xcode command line tools enabled before attempting step 3. (see below for more information)*  
  

1. Put all the photos you want to add to your simulator into a folder.  
2. Launch the simulator you want to target (i.e. just run the app from Xcode).  
3. Run the following command:  
`$ xcrun simctl addmedia booted [YOUR_FOLDER_PATH]/*`. 
  
If all goes well, your simulator should now have a lot of photos to play with!  
  
> ### Xcode Command Line Tools  
>To enable Xcode Command Line Tools, open XCode and go to Xcode -> Preferences... -> Locations, then select the available command line tools from the Command Line Tools: dropdown menu.  
>  
>![Screen Shot 2022-09-21 at 11 48 04 AM](https://user-images.githubusercontent.com/113631682/191588202-a99b227b-ae85-4a1d-89b7-8e3e654a9f16.png)

