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

local botonInicio, botonIndice, botonMarcador

--Font

--CustFont = display.newText( "PTSerif-Regular", 40, 20, "PT Serif", 24 )

if "Win" == system.getInfo( "platformName" ) then
    PTSERIF = "Austie Bost Kitten Klub"
elseif "Android" == system.getInfo( "platformName" ) then
    PTSERIF = "AustieBostKittenKlub"
else
    -- Mac and iOS
    PTSERIF = "Austie Bost Kitten Klub"
end

if "Win" == system.getInfo( "platformName" ) then
    PTSERIF1 = "Annie Use Your Telescope"
elseif "Android" == system.getInfo( "platformName" ) then
    PTSERIF1 = "AnnieUseYourTelescope"
else
    -- Mac and iOS
    PTSERIF1 = "Annie Use Your Telescope"
end



function moverAIndice( event )
	if event.phase == "ended" or event.phase == "cancelled" then
		composer.setVariable( "pagina" , 0 )
		composer.gotoScene( "Indice", "fade" )
	end
	return true
end

-- function moverAInicio( event )
-- 	if event.phase == "ended" or event.phase == "cancelled" then
-- 		composer.setVariable( "pagina" , 0 )
-- 		composer.gotoScene( "P0", "fade" )
-- 	end
-- 	return true
-- end

-- function moverAMarcador( event )
-- 	if event.phase == "ended" or event.phase == "cancelled" then
-- 	    pag = "P" .. composer.getVariable( "paginaMarcador" )
-- 	    pag_sig = composer.getVariable( "paginaMarcador" )
-- 	    composer.setVariable( "pagina" , pag_sig )
-- 	    print( composer.getVariable("pagina") )
-- 		composer.gotoScene( pag, "fade" )
-- 	end
-- 	return true
-- end

local function cargarData()
	local ruta = system.pathForFile( "data.txt", system.DocumentsDirectory )
	local archivo = io.open( ruta, "r" )

	if archivo then

		local data = archivo:read( "*a" )
		local tabla = json.decode( data )
		io.close( archivo )

		composer.setVariable( "paginaMarcador", tabla.paginaMarcador )

		if tabla.tutorialCompletado then
			composer.setVariable( "tutorialCompletado", tabla.tutorialCompletado)
		else
			composer.setVariable( "tutorialCompletado", 0 )
		end
	else
		composer.setVariable( "paginaMarcador", 0 )
		composer.setVariable( "tutorialCompletado", 0 )
	end

end

-- botonIndice = display.newImageRect( "Menu/bIndice.png", 160, 160 )
-- botonIndice.x = 205
-- botonIndice.y = display.contentHeight - 57
-- botonIndice.isVisible = false

-- botonInicio = display.newImageRect( "Menu/bInicio.png", 160, 160 )
-- botonInicio.x = 70
-- botonInicio.y = display.contentHeight - 57
-- botonInicio.isVisible = false

-- botonMarcador = display.newImageRect( "Menu/bMarcador.png", 160, 160 )
-- botonMarcador.x = 340
-- botonMarcador.y = display.contentHeight - 57
-- botonMarcador.isVisible = false

-- Cargar información guardada.
cargarData()

composer.setVariable( "paginaAnterior", nil )
composer.setVariable( "pagina", 0 )

local stage = display.getCurrentStage()
stage:insert( composer.stage )
-- stage:insert( botonInicio )
-- stage:insert( botonIndice )
-- stage:insert( botonMarcador )

-- botonIndice:addEventListener( "touch", moverAIndice)
-- botonInicio:addEventListener( "touch", moverAInicio)
-- botonMarcador:addEventListener( "touch", moverAMarcador)

-- load title screen
composer.gotoScene( "P0", "fade" )