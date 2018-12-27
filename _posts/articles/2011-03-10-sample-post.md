---
layout: post
share: true
title: Add useful touchpad gestures to ubuntu
modified: 2018-12-27T14:17:25-04:00
excerpt: "Macbook like touch gestures in ruby"
categories: articles
tags: [ubuntu, mac, gestures, gestures-recognition, keyboard, keyboard-shortcuts, touch]
image:
  feature: 
comments: true

---

If you ever used a MacBook then you know how pleasant and useful can be the trackpad gestures to change desktops. 
Unfortunately these gestures are not available by default on the major Linux distributions.

But thanks to Kohei Yamada who developed the application “Fusuma” in “Ruby” to recognise multi-touch input on the 
trackpad on Linux, shortcuts can be easily configured to different gestures.

###### Prerequisites
You must ensure first that your system touchpad supports the multi-touch.

###### Steps to install Fusuma in ubuntu

```ruby
 sudo gpasswd -a $USER input
```

You must logout and login again for the changes to take effect.

```ruby
 sudo apt-get install libinput-tools
 sudo apt-get install xdotool
```

Now, install the application Fusuma

```ruby
gem install fusuma
```

###### Configuring the Gestures

In your home directory, go to the folder ~/.config and create the folder fusuma inside of it. Now you must create a file 
config.yml, in which you will declare the shortcuts and gestures you want.

Add shortcuts to config.yml in ~/.config/fusuma

```ruby
swipe:
  3: 
    left: 
      command: 'xdotool key alt+Right'
    right: 
      command: 'xdotool key alt+Left'
    up: 
      command: 'xdotool key super'
    down: 
      command: 'xdotool key super'
  4:
    left: 
      command: 'xdotool key ctrl+alt+Down'
    right: 
      command: 'xdotool key ctrl+alt+Up'
    up: 
      command: 'xdotool key ctrl+alt+Down'
    down: 
      command: 'xdotool key ctrl+alt+Up'
pinch:
  in:
    command: 'xdotool key ctrl+plus'
  out:
     command: 'xdotool key ctrl+minus'

threshold:
  swipe: 0.4
  pinch: 0.4

interval:
  swipe: 0.8
  pinch: 0.1
```

###### Start the Gestures

```ruby
 fusuma
```

###### Launch Fusuma on Startup

In the Unity Menu, search for Startup Applications

* **Name**: Fusuma Gestures Application
* **Command**: fusuma
* **Comment**: Application to add gestures to your system.


__Now you can restart your computer and Fusuma will run as soon as you login. And start enjoying the Luxurious Life.__
