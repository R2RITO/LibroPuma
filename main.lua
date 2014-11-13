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
	if event.phase == "ended" or event.phase == "cancelled" then
		composer.setVariable( "pagina" , 0 )
		composer.gotoScene( "P0", "fade" )
	end
end

local function moverAInicio( event )
	if event.phase == "ended" or event.phase == "cancelled" then
		composer.setVariable( "pagina" , 0 )
		composer.gotoScene( "P0", "fade" )
	end
end

local function moverAMarcador( event )
	if event.phase == "ended" or event.phase == "cancelled" then
	    pag = "P" .. composer.getVariable( "paginaMarcador" )
	    pag_sig = composer.getVariable( "paginaMarcador" )
	    composer.setVariable( "pagina" , pag_sig )
	    print( composer.getVariable("pagina") )
		composer.gotoScene( pag, "fade" )
	end
end

local function cargarMarcador()
	local ruta = system.pathForFile( "data.txt", system.DocumentsDirectory )
	local archivo = io.open( ruta, "r" )

	if archivo then

		local data = archivo:read( "*a" )
		local tabla = json.decode( data )
		io.close( archivo )

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