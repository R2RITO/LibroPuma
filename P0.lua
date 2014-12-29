-----------------------------------------------------------------------------------------
--
-- P0.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------

-- forward declaration
local background,  patita, puma, logoPUC, logoCRA, tituloText, tituloText1,indiceText
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

	                pag_sig = 2
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

	-- display a background image

print("create")

	-- backWhite = display.newImageRect( sceneGroup, "Portada/BackgroundWhite.jpg", display.contentWidth, display.contentHeight)
	-- backWhite.anchorX,backWhite.anchorY=0,0 --el punto de referencia (0,0) de la imagen es el de la izquierda y arriba
	-- backWhite.x, backWhite.y = 0, 0
	-- backWhite.isVisible = true

	background = display.newImageRect( sceneGroup, "Portada/capa_1_1.png", display.contentWidth, display.contentHeight*0.84)
	background.anchorX,background.anchorY=0,0 --el punto de referencia (0,0) de la imagen es el de la izquierda y arriba
	background.x, background.y = 0, display.contentHeight*0.14
	background.isVisible = true
	
	--Tal vez sería  recomendable cargar esta imagen como variable local. CARLOS 
	background2 = display.newImageRect( sceneGroup, "Portada/capa_1_3.png", display.contentWidth+display.contentWidth/10, display.contentHeight/3)
	background2.anchorX,background2.anchorY=0,1 --el punto de referencia (0,0) de la imagen es el de la izquierda y abajo
	background2.x, background2.y = -display.contentWidth/11,display.contentHeight
	background2.isVisible = true

	--Tal vez sería  recomendable cargar esta imagen como variable local. CARLOS 
	backWhite = display.newImageRect( sceneGroup, "Portada/BackgroundWhite.jpg", display.contentWidth, display.contentHeight*0.2)
    backWhite.anchorX,backWhite.anchorY=0,0 --el punto de referencia (0,0) de la imagen es el de la izquierda y arriba
    backWhite.x, backWhite.y = 0, 0
    backWhite.isVisible = true

	patita = display.newImageRect( sceneGroup, "Portada/PataPumita.png", display.contentWidth * 0.4, display.contentHeight * 0.6 )
	patita.x, patita.y = display.contentWidth * 0.75, display.contentHeight * 0.6
	patita.isVisible = false

	--Tal vez sería  recomendable cargar esta imagen como variable local. CARLOS 
	botonIndice = display.newImageRect( sceneGroup, "Portada/boton_huella_2.png", display.contentWidth*0.30, display.contentHeight*0.12)
	botonIndice.anchorX,botonIndice.anchorY=0.5,0.5 --el punto de referencia (0,0) de la imagen es el de la izquierda y abajo
	botonIndice.x, botonIndice.y = display.contentWidth/2,display.contentHeight*0.55
	botonIndice.isVisible = true
	botonIndice.alpha=0

	indiceText = display.newText( sceneGroup, "Ir al índice", 0, 0, PTSERIF, 30 )
	indiceText.x = display.contentWidth*0.55
	indiceText.y = display.contentHeight * 0.55
	indiceText.isVisible = true
	indiceText.alpha=0

	local options = 
	{
	    --parent = textGroup,
	    text = "Sorpresas en la expedición:",     
	    x = display.contentWidth*0.55,
	    y = display.contentHeight* 0.08,
	    width = display.contentWidth*0.6,
	    height =display.contentHeight*0.2,
	    font = PTSERIF1,   
	    fontSize = 45,
	    align = "center"  --new alignment parameter
	}

	tituloText = display.newText( options )

	tituloText:setFillColor( 0, 0, 0 ) -- color negro
	tituloText.isVisible=true

	local options = 
	{
	    --parent = textGroup,
	    text = "El puma chileno",     
	    x = display.contentWidth*0.55,
	    y = display.contentHeight* 0.17,
	    width = display.contentWidth*0.40,
	    height =display.contentHeight*0.2,
	    font = PTSERIF1,   
	    fontSize = 45,
	    align = "center"  --new alignment parameter
	}

	tituloText1 = display.newText( options )
	tituloText1:setFillColor( 0, 0, 0 ) -- color negro
	tituloText1.isVisible=true



 	--display.newText( [parentGroup,] text, x, y, [], font, fontSize )
	subtituloText = display.newText( sceneGroup, "Un cuento de Pontificia Universidad Católica y Programa de Bibliotecas Escolares CRA", display.contentWidth*0.69, display.contentHeight * 0.33
	,display.contentWidth*0.6,display.contentHeight*0.25, PTSERIF1 , 29)
	subtituloText.alpha=0
	subtituloText:setFillColor( 0, 0, 0 ) -- color negro
	

	puma = display.newImageRect( sceneGroup, "Portada/Puma.png", display.contentWidth *0.35, display.contentHeight * 0.3 )
	puma.x, puma.y = display.contentWidth *0.7, display.contentHeight * 0.75
	puma.alpha=0

	logoPUC = display.newImageRect( sceneGroup, "Portada/LogoPUC.png", display.contentWidth * 0.15, display.contentHeight * 0.25 ) 
	logoPUC.anchorX,logoPUC.anchorY=0.5,0.5 --el punto de referencia (0,0) de la imagen es el default (al medio)
	logoPUC.x, logoPUC.y = display.contentWidth*0.1, display.contentHeight*0.3
	logoPUC.isVisible = true

	logoCRA = display.newImageRect( sceneGroup, "Portada/logo-cra20.png", display.contentWidth * 0.15, display.contentHeight * 0.25 ) 
	logoCRA.anchorX,logoCRA.anchorY=0.5,0.5 --el punto de referencia (0,0) de la imagen es el default (al medio)
	logoCRA.x, logoCRA.y = display.contentWidth*0.25, display.contentHeight*0.3
	logoCRA.isVisible = true

	
	
	-- Establecer el numero de pagina
	composer.setVariable( "pagina", 0 )
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

		-- background.isVisible = true
		-- patita.isVisible = true
		-- puma.isVisible = true
		-- logoPUC.isVisible = true
		-- --logoCRA.isVisible = true
		-- pageText.isVisible = true

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
		
		print("did")
		
		transition.to( subtituloText, { time=tweenTime*2, alpha=1.0,delay=1000 } )
		transition.to( puma, { time=tweenTime*2, alpha=1.0, delay=3000 } )
		transition.to( botonIndice, { time=tweenTime*0.3, alpha=1.0, delay=5000 } )
		transition.to( indiceText, { time=tweenTime*0.3, alpha=1.0, delay=5000 } )
		
		function goGame(  )
			composer.gotoScene("game","slideLeft", 800)
		end

		background.touch = onPageSwipe
		background:addEventListener( "touch", background )
		logoPUC:addEventListener( "touch", goGame )

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
		
		tituloText.isVisible=false
        tituloText1.isVisible=false
        subtituloText.isVisible=false
        indiceText.isVisible=false
       		

		
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