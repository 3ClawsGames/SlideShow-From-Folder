--[[-------------3 CLAWS GAMES INC------------------------------------------------------
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
--]]--------------------------------------------------------------------------------------

local lfs = require "lfs"
local _M 				= {}						-- The class object that we return in the end.

local centerX 			= display.contentCenterX
local centerY 			= display.contentCenterY

--Forward declaration of variables
local splashFunction 	= {}
local splashCounter 	= 1 						-- keep track of the different images in the intro.
local pathForImages 	= "ImageShow/"				-- The path to the intro images... you can change it to what you prefer.
local filenames 		= {}
local splashImage
local baseDir
local baseDirDevice
local transTime 		= 500						-- Transitiontime between images.
local environment = system.getInfo( "environment" )

_M.group 				= display.newGroup()
_G.doneSplash 			= false 					-- We use this var so you don´t have to see the intro more than one time.

--FUNCTIONS--
-- path is relative to the baseDirectory
function _M.getFiles()   
if environment == "simulator" then  
	baseDir = system.pathForFile('main.lua'):gsub("main.lua", "")
    for file in lfs.dir(baseDir .. pathForImages) do
        if (file ~= '.' and file ~= '..' and file ~= ".DS_Store" ) then
            table.insert(filenames, file)
        end
    end
else
	baseDir = system.pathForFile( nil, system.ResourceDirectory ) 
	for file in lfs.dir(baseDir .. "/" .. pathForImages) do
        if (file ~= '.' and file ~= '..' and file ~= ".DS_Store" ) then
            table.insert(filenames, file)
        end
    end
    if (#filenames == 0) then return false end
end
    return filenames
end	

function _M.printSplashImageFolderContent()			-- Mainly for debug purposes, it will print out the filenames in the folder.
	for k,v in ipairs(filenames) do
    	print(k,v)
    end
end

function _M.playGame()								-- Will be triggered when all the images in the folder is shown.
	print("End of introFunction") 					-- Here you can put whatever you like to resume your game
	system.vibrate()								-- Makes the device vibrate ....just for the hell of it ;D
	system.openURL( "http://www.3claws.org" )
end

function _M.splashFunction(self, event)
	if event.phase == "began" then
		if _G.doneSplash == false then
			if splashCounter < #filenames then
				_M.disableImageTouch()				-- Disable touch so the user can´t click the image before the transition is done
				splashImage = display.newImageRect( pathForImages .. filenames[splashCounter], 480, 320 )
				splashImage.x, splashImage.y = display.contentCenterX, display.contentCenterY
				splashImage.alpha = 1
				_M.group:insert(splashImage)
				transition.to( splashImage, {time=transTime, alpha=0, onComplete= function() 
				display.remove( splashImage )	
				splashImage = display.newImageRect( pathForImages .. filenames[splashCounter], 480, 320 )
				splashImage.x, splashImage.y = display.contentCenterX, display.contentCenterY
				splashImage.alpha = 0
				_M.group:insert(splashImage)						
				transition.to( splashImage, {time=transTime, alpha=1, onComplete = function()
					_M.enableImageTouch()			-- Enables touch on image again
					end})		
				return true end} )

			elseif splashCounter == #filenames then -- Clean up because the show is over.
				_G.doneSplash = true 				-- This enshures you that the player dont need to whatch the images if he/she i.e. restart the game.
				_M.playGame()						-- Triggers the function that i.e. brings you back to the game.

				if nil ~= splashImage.touch then 	-- If there is a touch handler attached to the imageobject then remove it
					_M.disableImageTouch() 
				end

				if nil ~= splashImage then 			-- Remove the splashImage if it is present
					splashImage = nil
				end
			end			
			splashCounter = splashCounter + 1
			return true
		end
	end
end

function _M.enableImageTouch()
	splashImage:addEventListener("touch", splashImage)
	splashImage.touch = _M.splashFunction
	return true
end

function _M.disableImageTouch()
	splashImage:removeEventListener("touch", splashImage)
	splashImage.touch = nil
	return true
end

function _M:new()			
	splashImage = display.newImageRect( pathForImages .. filenames[splashCounter], 480, 320 )
	splashImage.x, splashImage.y = display.contentCenterX, display.contentCenterY
	splashImage.alpha = 1
	_M.group:insert(splashImage)
	splashImage.touch = _M.splashFunction
	splashImage:addEventListener("touch", splashImage)
	return splashImage
end

	_M.getFiles() 
	_M:new()
	_M.printSplashImageFolderContent()				-- For debug purpose ( prints the foldercontent to the terminalwindow )

return _M 											-- Returns the module to the codepart that requires it

