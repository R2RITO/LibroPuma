-- Menú para moverse en el cuento.

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")

-- forward declarations and other locals
local pageTween, fadeTween1, fadeTween2

local botonInicio, botonIndice, botonMarcador, fondo

local onPageTouch

local swipeThresh = 100     -- amount of pixels finger must travel to initiate page swipe
local tweenTime = 900


local function moverAIndice( event )
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.setVariable( "pagina" , 0 )
        composer.setVariable( "paginaAnterior", "menu")
        composer.gotoScene( "Indice", "fade" )
    end
    return true
end

local function moverAInicio( event )
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.setVariable( "pagina" , 0 )
        composer.setVariable( "paginaAnterior", "menu")
        composer.gotoScene( "P0", "fade" )
    end
    return true
end

local function moverAMarcador( event )
    if event.phase == "ended" or event.phase == "cancelled" then
        pag = "P" .. composer.getVariable( "paginaMarcador" )
        pag_sig = composer.getVariable( "paginaMarcador" )
        composer.setVariable( "pagina" , pag_sig )
        composer.setVariable( "paginaAnterior", "menu")
        composer.gotoScene( pag, "fade" )
    end
    return true
end

-- touch event listener for background object
onPageTouch = function( self, event )
    local phase = event.phase
    local pag_act = composer.getVariable( "pagina" )

    if phase == "began" then
        display.getCurrentStage():setFocus( self )
        self.isFocus = true
        self.tiempo = event.time
    
    elseif self.isFocus then
        if phase == "ended" or phase == "cancelled" then
            
            local duracion = event.time - self.tiempo
            if duracion > 1000 then
                composer.hideOverlay("fade")
            end
            
            display.getCurrentStage():setFocus( nil )
            self.isFocus = nil
        end
    end
    return true
end

function scene:create( event )
    local sceneGroup = self.view

    -- Called when the scene's view does not exist.
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
    
    -- -- create background image

    fondo = display.newImageRect( sceneGroup, "Menu/fondo.jpg", display.contentWidth, display.contentHeight )
    fondo.x, fondo.y = display.contentCenterX, display.contentCenterY
    fondo.touch = onPageTouch

    botonIndice = display.newImageRect( sceneGroup, "Menu/bIndice.png", 160, 160 )
    botonIndice.x = 205
    botonIndice.y = display.contentHeight - 57

    botonInicio = display.newImageRect( sceneGroup, "Menu/bInicio.png", 160, 160 )
    botonInicio.x = 70
    botonInicio.y = display.contentHeight - 57

    botonMarcador = display.newImageRect( sceneGroup, "Menu/bMarcador.png", 160, 160 )
    botonMarcador.x = 340
    botonMarcador.y = display.contentHeight - 57

    fondo:addEventListener( "touch", fondo )
    botonIndice:addEventListener( "touch", moverAIndice )
    botonInicio:addEventListener( "touch", moverAInicio )
    botonMarcador:addEventListener( "touch", moverAMarcador )

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc.

    end 

end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.
    
        -- cancel page animations (if currently active)
        if pageTween then transition.cancel( pageTween ); pageTween = nil; end
        if fadeTween1 then transition.cancel( fadeTween1 ); fadeTween1 = nil; end
        if fadeTween2 then transition.cancel( fadeTween2 ); fadeTween2 = nil; end
        
    elseif phase == "did" then
        -- Called when the scene is now off screen
    end     

end

function scene:destroy( event )
    local sceneGroup = self.view
    
    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene