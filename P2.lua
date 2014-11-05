-----------------------------------------------------------------------------------------
--
-- page1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()



-- forward declarations and other locals
local background, pageText, pageText2, continueText, pageTween, fadeTween1, fadeTween2, sunObj, moonObj, coronaIcon

local swipeThresh = 100		-- amount of pixels finger must travel to initiate page swipe
local tweenTime = 500
local animStep = 1
local readyToContinue = false

-- function to show next animation
local function showNext()
	if readyToContinue then
		continueText.isVisible = false
		readyToContinue = false
		
		local function repositionAndFadeIn()
			pageText.x = display.contentWidth * 0.5
			pageText.y = display.contentHeight * 0.20
			pageText.isVisible = true

					
			fadeTween1 = transition.to( pageText, { time=tweenTime*0.5, alpha=1.0 } )
			fadeTween1 = transition.to( pageText2, { time=tweenTime*0.5, alpha=1.0 } )
		end
		
		local function completeTween()
			animStep = animStep + 1
			if animStep > 4 then animStep = 1; end
			
			readyToContinue = true
			continueText.isVisible = true
		end
		
		if animStep == 1 then
			pageText.alpha = 0
			local textOption = 
				{			
							--parent = textGroup,
						    text = "Nombre científico: Felis concolor.Hábitat: Habita a lo largo de todo el país en zonas boscosas y cordilleranas.",     
						    width = 500,     --required for multi-line and alignment
						    font = "Calibri Light",   
						    fontSize = 22,
						    align = "center"  --new alignment parameter
					
				}
			pageText= display.newText(textOption)
			--pageText = display.newText("Nombre científico: Felis concolor.\nHábitat: Habita a lo largo de todo el país en zonas boscosas y cordilleranas.",25,25,"Calibri Light",18)
			--pageText= display.newText( "Hello Corona User! \n Hope you're having a great day.", 25, 25, "Helvetica", 18 )
			repositionAndFadeIn()
			
			-- hide corona icon
			coronaIcon.isVisible = false

			ramaObj.isVisible=false
			sunObj.alpha = 1 --Not transparent
			sunObj.x = -sunObj.contentWidth
			sunObj.isVisible = true
			pageTween = transition.to( sunObj, { time=tweenTime, x=display.contentWidth*0.5, transition=easing.outExpo, onComplete=completeTween } )
			
		elseif animStep == 2 then
			pageText.alpha = 0 --transparent
			
			local textOption = 
				{			
							--parent = textGroup,
						    text = "Características: Es el mayor carnívoro terrestre de Chile. Tiene una longitud hasta de 1,90 metros. con una cola de más de 80 cm. y los ejemplares más grandes alcanzan 55 kilos. ",     
						    width = 500,     --required for multi-line and alignment
						    font = "Calibri Light",   
						    fontSize = 22,
						    align = "center"  --new alignment parameter
						    
				}
			pageText= display.newText(textOption)


			--pageText.text = "Easy API accessed via Lua scripting."
			--pageText = display.newText("Características: Es el mayor carnívoro terrestre de Chile. \nTiene una longitud hasta de 1,90 metros. con una cola de más de 80 cm. y los ejemplares más grandes alcanzan 55 kilos. \nSon cazadores por excelencia, cautos, silenciosos y solitarios. \nSe alimenta de diversas presas, desde roedores como ratones y tucos tucos, hasta huemules y guanacos pero no ataca al hombre.",20,100,"Calibri Light",18, "center")
			
			repositionAndFadeIn()

			ramaObj.isVisible = false
			moonObj.alpha = 1
			--moonObj.x = display.contentWidth + moonObj.contentWidth
			moonObj.isVisible = true
			pageTween = transition.to( moonObj, { time=tweenTime, x=display.contentWidth*0.5, transition=easing.outExpo, onComplete=completeTween } )
		
		elseif animStep == 3 then
			pageText.alpha = 0
		    local textOption = 
				{			
							--parent = textGroup,
						    text = "Son cazadores por excelencia, cautos, silenciosos y solitarios. Se alimenta de diversas presas, desde roedores como ratones y tucos tucos, hasta huemules y guanacos pero no ataca al hombre.",     
						    width = 500,     --required for multi-line and alignment
						    font = "Calibri Light",   
						    fontSize = 22,
						    align = "center"  --new alignment parameter
						    
				}
			pageText= display.newText(textOption)
			repositionAndFadeIn()
			
			-- hide sun and moon
			fadeTween1 = transition.to( sunObj, { time=tweenTime*0.5, alpha=0 } )  -- alpha=0 Make them not visible  
			fadeTween2 = transition.to( moonObj, { time=tweenTime*0.5, alpha=0 } ) -- alpha=0 Make them not visible
			

			ramaObj.isVisible = true
			ramaObj.alpha = 0
			pageTween = transition.to( ramaObj, { time=tweenTime*1.5, alpha=1, transition=easing.inOutExpo, onComplete=completeTween } )

		elseif animStep == 4 then
			pageText.alpha = 0
			pageText.text = "Reproducción: Las hembras pueden entrar en celo varias veces en el año, y a partir del segundo o tercer año de vida se aparean con el macho, a los 90 o 96 días da a luz a dos o tres cachorros"
			repositionAndFadeIn()
			
			-- hide sun and moon
			fadeTween1 = transition.to( sunObj, { time=tweenTime*0.5, alpha=0 } )
			fadeTween2 = transition.to( moonObj, { time=tweenTime*0.5, alpha=0 } )
			
			coronaIcon.isVisible = false
			coronaIcon.alpha = 0
			coronaIcon.x = display.contentWidth * 0.5
			pageTween = transition.to( coronaIcon, { time=tweenTime*1.5, alpha=1, transition=easing.inOutExpo, onComplete=completeTween } )
		

		elseif animStep == 5 then
			pageText.alpha = 0
			pageText.text = "Protección: Existe un decreto especial que prohíbe cazar pumas, debido a que son animales benéficos para la naturaleza del país. "
			repositionAndFadeIn()
			
			-- hide sun and moon
			fadeTween1 = transition.to( sunObj, { time=tweenTime*0.5, alpha=0 } )
			fadeTween2 = transition.to( moonObj, { time=tweenTime*0.5, alpha=0 } )
			
			coronaIcon.isVisible = false
			coronaIcon.alpha = 0
			coronaIcon.x = display.contentWidth * 0.5
			pageTween = transition.to( coronaIcon, { time=tweenTime*1.5, alpha=1, transition=easing.inOutExpo, onComplete=completeTween } )
		end
	end
end

-- touch event listener for background object
local function onPageSwipe( self, event )
    local phase = event.phase
    local pag_act = composer.getVariable( "pagina" )

    if phase == "began" then
        display.getCurrentStage():setFocus( self )
        self.isFocus = true
    
    elseif self.isFocus then
        if phase == "ended" or phase == "cancelled" then
            
            local distance = event.x - event.xStart
            if math.abs(distance) > swipeThresh then

                pag_sig = pag_act - distance/math.abs(distance)
                pag = "P" .. pag_sig
                composer.setVariable( "pagina", pag_sig)

                if distance > swipeThresh then
                    -- deslizar hacia la derecha, pagina anterior
                    composer.gotoScene( pag, "slideRight", 800 )
                    pageText.isVisible=false
                else
                    -- deslizar a la izquierda, pagina siguiente
                    composer.gotoScene( pag, "slideLeft", 800 )
                    pageText.isVisible=false
                end

            else
                -- Touch and release; initiate next animation
                showNext()
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
	
	-- create background image
	background = display.newImageRect( sceneGroup, "PumaArbol.jpg", display.contentWidth * 2.5, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = -1152, 0
	background.alpha = 0.5


	
	-- create overlay
	local overlay = display.newImageRect( sceneGroup, "pagebg1.png", display.contentWidth, display.contentHeight )
	overlay.anchorX = 0
	overlay.anchorY = 0
	overlay.x, overlay.y = 0, 0

	--create marker object
	markerObj = display.newImageRect( sceneGroup, "Marcador.png", 80, 119 )
	markerObj.anchorX = 0
	markerObj.anchorY = 0
	markerObj.x, markerObj.y = 0, 50
	markerObj.isVisible = true
	
	
	-- create sun, moon, and corona icon
	sunObj = display.newImageRect( sceneGroup, "PumaSF.png", 400, 300 )
	sunObj.x = display.contentWidth * 0.5
	sunObj.y = display.contentHeight * 0.5
	sunObj.isVisible = false
	
	moonObj = display.newImageRect( sceneGroup, "PumaSFG.png", 400, 300 )
	moonObj.x = display.contentWidth * 0.10
	moonObj.y = display.contentHeight * 0.55
	moonObj.isVisible = false

	fallingObj = display.newImageRect( sceneGroup, "PumaCayendo.png", 400, 300 )
	fallingObj.x = display.contentWidth * 0.44
	fallingObj.y = display.contentHeight * 0.55
	fallingObj.isVisible = false

	ramaObj = display.newImageRect( sceneGroup, "PumaRama.png", 600, 300 )
	ramaObj.anchorX = 0
	ramaObj.anchorY = 0
	ramaObj.x , ramaObj.y = display.contentWidth * 0.3, display.contentHeight * 0.60
	ramaObj.isVisible = false

	
	coronaIcon = display.newImageRect( sceneGroup, "coronaicon-big.png", 450, 444 )
	coronaIcon.x = display.contentWidth * 0.5
	coronaIcon.y = display.contentHeight * 0.5
	coronaIcon.alpha = 0
	
	-- create pageText
	pageText = display.newText( sceneGroup, "", 0, 0, native.systemFontBold, 18 )
	pageText.x = display.contentWidth * 0.5
	pageText.y = display.contentHeight * 0.5
	pageText.isVisible = false

		-- create pageText
	pageText2 = display.newText( sceneGroup, "", 0, 0, native.systemFontBold, 18 )
	pageText2.x = display.contentWidth * 0.5
	pageText2.y = display.contentHeight * 0.5
	pageText2.isVisible = false
	
	-- create text at bottom of screen
	continueText = display.newText( sceneGroup, "[ Toca la pantalla para continuar ]", 0, 0, native.systemFont, 18 )
	continueText.x = display.contentWidth * 0.5
	continueText.y = display.contentHeight - (display.contentHeight * 0.04 )
	continueText.isVisible = false
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
		
		animStep = 1
		readyToContinue = true
		showNext()
	
		-- assign touch event to background to monitor page swiping
		background.touch = onPageSwipe
		background:addEventListener( "touch", background )
	end	

end

function scene:exit( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		
		-- hide objects
		sunObj.isVisible = false
		moonObj.isVisible = false
		coronaIcon.isVisible = false
		pageText.isVisible = false
	
		-- remove touch event listener for background
		background:removeEventListener( "touch", background )
	
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