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

-- Touch listener function for background object
local function onBackgroundTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		-- go to page1.lua scene
		composer.setVariable( "pagina", 1)
		composer.gotoScene( "P1", "slideLeft", 800 )
		
		return true	-- indicates successful touch
	end
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

	logoPUC = display.newImageRect( sceneGroup, "Portada/logoPUC.png", display.contentWidth * 0.15, display.contentHeight * 0.25 ) 
	logoPUC.x, logoPUC.y = display.contentWidth * 0.1, display.contentHeight * 0.9
	logoPUC.isVisible = false

	--logoCRA = display.newImageRect( sceneGroup, "Portada/logoCRA.jpg", display.contentWidth * 0.15, display.contentHeight * 0.25 ) 
	--logoCRA.x, logoCRA.y = display.contentWidth * 0.4, display.contentHeight * 0.8
	--logoCRA.isVisible = false

	-- Texto del titulo
    pageText = display.newText( sceneGroup, "El Puma Chileno", 0, 0, "Austie Bost Kitten Klub", 80 )
	pageText.x = display.contentWidth * 0.7
	pageText.y = display.contentHeight * 0.1	
	pageText.isVisible = false

	-- Establecer el numero de pagina
	composer.setVariable( "pagina", 0)
	
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
		
		background.touch = onBackgroundTouch
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
		
	elseif phase == "did" then
		-- Called when the scene is now off screen
		--background.isVisible = false
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