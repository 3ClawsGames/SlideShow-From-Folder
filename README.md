This is a module I initially made because I often end up 
making an intro with images, explaining how to play. 
When the session of images is done, you will not see it again when 
you restart the game because the global variable _G.doneSplash 
is set to true when the imagesession is done. 
THE COOL THING about this code is that you can put whatever 
you like, (as long as it is a jpg file) into the folder and how 
many files you like to, you dont have to alter any code at all to make it work
(it dont need to be serialnumbered 01, 02 neither (if the order is of no concern.))
You can change the folder name as long as you cange the pathForImages variable accordingly.
I deliberately made all the functions in the class public so you can
access them from anywhere in your code.
Thanks to Sergey Lerg for supporting on parts of the code
The code is free to use for anyone, and I hope it will come in handy
All I ask is that you cred 3 CLAWS GAMES in your code if you use this module.

To use this module you just put the following line in your main.lua file:
require("IntroClass") 
