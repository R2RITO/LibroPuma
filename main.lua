-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

local json = require("json")

local botonInicio, botonIndice

local function moverAIndice( event )
	composer.gotoScene( "P0", "fade" )
end

local function moverAInicio( event )
	composer.gotoScene( "P0", "fade" )
end

local function moverAMarcador( event )
    pag = "P" .. composer.getVariable( "paginaMarcador" )
	composer.gotoScene( pag, "fade" )
end

local function cargarMarcador()
	local ruta = system.pathForFile( "data.txt", system.DocumentsDirectory )
	local archivo = io.open( ruta, "r" )

	if archivo then

		local data = archivo:read( "*a" )
		local tabla = json.decode( data )
		io.close( archivo )

		print(tabla.paginaMarcador)
		composer.setVariable( "paginaMarcador", tabla.paginaMarcador )
	else
		composer.setVariable( "paginaMarcador", 0 )
	end

end

botonIndice = display.newImageRect( "Menu\\bIndice.png", 120, 120 )
botonIndice.x = 60
botonIndice.y = display.contentHeight - 60

botonInicio = display.newImageRect( "Menu\\bInicio.png", 120, 120 )
botonInicio.x = 205
botonInicio.y = display.contentHeight - 60

botonMarcador = display.newImageRect( "Menu\\bMarcador.png", 120, 120 )
botonMarcador.x = 340
botonMarcador.y = display.contentHeight - 60

-- Cargar la página del marcador.
cargarMarcador()


local stage = display.getCurrentStage()
stage:insert( composer.stage )
stage:insert( botonInicio )
stage:insert( botonIndice )
stage:insert( botonMarcador )

botonIndice:addEventListener( "touch", moverAIndice)
botonInicio:addEventListener( "touch", moverAInicio)
botonMarcador:addEventListener( "touch", moverAMarcador)

-- load title screen
composer.gotoScene( "P0", "fade" )