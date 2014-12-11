-----------------------------------------------------------------------------------------
--
-- P0.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------

-- forward declaration
local background, pageText, patita, puma, logoPUC, logoCRA
local swipeThresh = 100 


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
                composer.gotoScene( "Indice", "slideLeft", 800 )
                pageText.isVisible=false
        	else
            
	            local distance = event.x - event.xStart
	            if math.abs(distance) > swipeThresh then

	                pag_sig = 1
	                pag = "P" .. pag_sig
	                composer.setVariable( "pagina", pag_sig)

	                if distance < swipeThresh then
	                    -- deslizar hacia la derecha, pagina anterior
	                    composer.gotoScene( pag, "slideLeft", 800 )
	                    pageText.isVisible=false
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

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	background = display.newImageRect( sceneGroup, "Portada/fondoJungla.jpg", display.contentWidth, display.contentHeight )
	background.x, background.y = display.contentWidth * 0.5, display.contentHeight * 0.5
	background.isVisible = false

	patita = display.newImageRect( sceneGroup, "Portada/PataPumita.png", display.contentWidth * 0.4, display.contentHeight * 0.6 )
	patita.x, patita.y = display.contentWidth * 0.75, display.contentHeight * 0.6
	patita.isVisible = false

	puma = display.newImageRect( sceneGroup, "Portada/Puma.png", display.contentWidth * 1.5, display.contentHeight * 1.5 )
	puma.x, puma.y = display.contentWidth * -0.2, display.contentHeight * 0.4
	puma.rotation = -10
	puma.isVisible = false

	logoPUC = display.newImageRect( sceneGroup, "Portada/LogoPUC.png", display.contentWidth * 0.15, display.contentHeight * 0.25 ) 
	logoPUC.x, logoPUC.y = display.contentWidth * 0.1, display.contentHeight * 0.9
	logoPUC.isVisible = false

	--logoCRA = display.newImageRect( sceneGroup, "Portada/LogoCRA.jpg", display.contentWidth * 0.15, display.contentHeight * 0.25 ) 
	--logoCRA.x, logoCRA.y = display.contentWidth * 0.4, display.contentHeight * 0.8
	--logoCRA.isVisible = false

	-- Texto del titulo
    pageText = display.newText( sceneGroup, "El Puma Chileno", 0, 0, "Austie Bost Kitten Klub", 80 )
	pageText.x = display.contentWidth * 0.7
	pageText.y = display.contentHeight * 0.1	
	pageText.isVisible = false

	-- Establecer el numero de pagina
	composer.setVariable( "pagina", 0 )
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

		background.isVisible = true
		patita.isVisible = true
		puma.isVisible = true
		logoPUC.isVisible = true
		--logoCRA.isVisible = true
		pageText.isVisible = true

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
		-- Called when the scene is now off screen
		background.isVisible = false
		patita.isVisible = false
		puma.isVisible = false
		logoPUC.isVisible = false
		--logoCRA.isVisible = false
		pageText.isVisible = false

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