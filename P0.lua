-----------------------------------------------------------------------------------------
--
-- P0.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------

-- forward declaration
local background, botonIndice, botonComenzar
local swipeThresh = 100 
local tweenTime = 900

onPageSwipe = function( self, event )
    local phase = event.phase
    composer.setVariable( "pagina", 0)
    local pag_act = composer.getVariable( "pagina" )


    if phase == "began" then
        display.getCurrentStage():setFocus( self )
        self.isFocus = true
    
    elseif self.isFocus then
        if phase == "ended" or phase == "cancelled" then

        	if composer.getVariable( "tutorialCompletado" ) == 0 then
                composer.gotoScene( "Tutorial", "slideLeft", 800 )
        	else
            
	            local distance = event.x - event.xStart
	            if math.abs(distance) > swipeThresh then

	                pag_sig = 1
	                pag = "P" .. pag_sig
	                composer.setVariable( "pagina", pag_sig)

	                if distance < swipeThresh then
	                    -- deslizar hacia la derecha, pagina siguiente
	                    composer.gotoScene( pag, "slideLeft", 800 )

	                end 

	            end
	            
	            display.getCurrentStage():setFocus( nil )
	            self.isFocus = nil
	        end
        end

    end
    return true
end


function scene:create( event )
	local sceneGroup = self.view

	-- Para coordenadas x e y, el cero es a la izquierda y arriba respectivamente.

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	background = display.newImageRect( sceneGroup, "Portada/fondo.png", display.contentWidth, display.contentHeight)
	background.x, background.y = display.contentCenterX, display.contentCenterY
	background.isVisible = true
 
	botonIndice = display.newImageRect( sceneGroup, "Portada/indice.png", display.contentWidth*0.20, display.contentHeight*0.12)
	botonIndice.x, botonIndice.y = display.contentWidth * 0.85,display.contentHeight*0.55
	botonIndice.isVisible = true
	botonIndice.alpha=1

	botonComenzar = display.newImageRect( sceneGroup, "Portada/comenzar.png", display.contentWidth*0.20, display.contentHeight*0.12)
	botonComenzar.x, botonComenzar.y = display.contentWidth * 0.9,display.contentHeight*0.70
	botonComenzar.isVisible = true
	botonComenzar.alpha=1


		
	-- Establecer el numero de pagina
	composer.setVariable( "pagina", 0 )
	
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
		local pag = composer.getVariable( "paginaAnterior" )
		if pag then
			composer.removeScene( pag )
		end
		pag = nil
		
		background.touch = onPageSwipe
		background:addEventListener( "touch", background )
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)

		-- remove event listener from background
			
		background:removeEventListener( "touch", background )
		composer.setVariable( "paginaAnterior", "P0" )
       		

		
	elseif phase == "did" then

		
		   -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc.

      --pageText.isVisible=false
                

	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.


	--!!!! Es recomendable usar el object:removeself() y object=nil para liberar memoria en el dispositivo. CARLOS
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene