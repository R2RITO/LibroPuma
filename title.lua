-----------------------------------------------------------------------------------------
--
-- P0.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------

-- forward declaration
local background

-- Touch listener function for background object
local function onBackgroundTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		-- go to page1.lua scene
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
	background = display.newImageRect( sceneGroup, "PumaSaltando.jpg", 1000, 600) --opcion: display.contentHeight display.contentWeight
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = -80, 0  --Aquí se setea la ubicación de la imagen

	background2 = display.newImageRect( sceneGroup, "PumaArbol.jpg", display.contentWidth * 2.5, display.contentHeight )
	background2.anchorX = 0
	background2.anchorY = 0
	background2.x, background.y = 0, 0
	background2.alpha = 0.5
	
	-- Add more text
	local pageText = display.newText( "[ Toca la pantalla para continuar ]", 0, 0, native.systemFont, 18 )
	pageText.x = display.contentWidth * 0.5
	pageText.y = display.contentHeight * 0.7

	-- Add more text
	local pageText2 = display.newText( "El Puma Chileno", 0, 0, native.systemFont, 40 )
	pageText2.x = display.contentWidth * 0.5
	pageText2.y = display.contentHeight * 0.65	
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( pageText )
	sceneGroup:insert( pageText2 )
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

--local function init()
        -- start and resume from previous state, if any
--        resumeStart()   
         
--        Runtime:addEventListener( "system", onSystemEvent )     
--end
 
--start the program
--init()
