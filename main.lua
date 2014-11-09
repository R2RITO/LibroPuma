-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

local botonInicio, botonIndice

local function moverAIndice( self, event )
	composer.gotoScene( "P0", "fade" )
end

local function moverAInicio( self, event )
	composer.gotoScene( "P0", "fade" )
end

botonIndice = display.newImageRect( "Menu\\bIndice.png", 120, 120 )
botonIndice.x = 60
botonIndice.y = display.contentHeight - 60

botonInicio = display.newImageRect( "Menu\\bInicio.png", 120, 120 )
botonInicio.x = 205
botonInicio.y = display.contentHeight - 60

local stage = display.getCurrentStage()
stage:insert( composer.stage )
stage:insert( botonInicio )
stage:insert( botonIndice )

botonIndice:addEventListener( "touch", moverAIndice)
botonInicio:addEventListener( "touch", moverAInicio)


-- load title screen
composer.gotoScene( "P0", "fade" )