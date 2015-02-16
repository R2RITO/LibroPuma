-----------------------------------------------------------------------------------------
--
-- page1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")



-- forward declarations and other locals
local   cientifico, finger_left, fadeTween, markerObj, 
		cientifico, handsTimer, fondo



local continuarAnimacion, onPageSwipe

local textGroup = display.newGroup()

local swipeThresh = 100     -- amount of pixels finger must travel to initiate page swipe
local tweenTime = 4000  --ms
local animStep = 1
local readyToContinue = false


-- Funciones

local function crearTexto( args )

    local textOption = 
        {           
            parent = textGroup,
            text = args.texto,     
            width = args.ancho or 900,     --required for multi-line and alignment
            font = args.fuente or PTSERIF,   
            fontSize = args.tam or 40,
            align = "center"  --new alignment parameter
    
        }

    return display.newText(textOption)
end

-- Funcion para reposicionar texto
local function repositionAndFadeIn( texto, factorX, factorY )
    texto.x = display.contentWidth * factorX
    texto.y = display.contentHeight * factorY

    texto.alpha = 0
    texto.isVisible = true
            
    fadeTween1 = transition.to( texto, { time=tweenTime*0.5, alpha=1.0 } )
end

local function inflate(self,event)
    if (self.inflar) then
        self.cuaninflado = self.cuaninflado + 0.005
    else 
        self.cuaninflado = self.cuaninflado - 0.005
    end 

    if (self.cuaninflado >= 1 + self.maximoinflado ) then  
        self.inflar = false
    elseif (self.cuaninflado<= 1 - self.maximoinflado) then
        self.inflar =  true
    end 

    self.xScale = self.cuaninflado
    self.yScale = self.cuaninflado 

end 

-- function to show next animation
local function showNext()
	if readyToContinue then
		readyToContinue = false
		
		local function completeTween()
			animStep = animStep + 1
			if animStep > 2 then animStep = 1; end
			
			readyToContinue = true
		end

		local move = function()
			local function back()
				transition.to( finger_left, { alpha = 0 } )
				finger_left.x=display.contentWidth * 0.9
			end
			transition.to( finger_left, { alpha = 1 } )
			transition.to( finger_left, { x=display.contentWidth * 0.7, time=900, onComplete=back})
			
		end

		local function sonido( self, event )

			if event.phase == "ended" or event.phase == "cancelled" then
				audio.play( self.sonido )
			end

			return true	

		end
	
		if animStep == 1 then
			--animacion de inflado para cientifico
			cientifico.enterFrame = inflate
            Runtime:addEventListener("enterFrame", cientifico)

			--Se avanza en animStep
			completeTween()

			-- Habilitar sonido para el cientifico.
			cientifico:addEventListener( "touch", continuarAnimacion )
			
		elseif animStep == 2 then

			-- Simular la primera reproduccion del sonido del puma
			-- y permitir que al tocar al cientifico se reproduzca
			audio.play( cientifico.sonido )
			cientifico:removeEventListener( "touch", continuarAnimacion )
			cientifico.touch = sonido
			cientifico:addEventListener( "touch", cientifico )

			-- Detener la animacion de inflado
			cientifico.enterFrame = nil
			Runtime:removeEventListener( "enterFrame", cientifico )

			-- Animacion para deslizar a la siguiente pagina
			finger_left.isVisible = true
			handsTimer = timer.performWithDelay( 1000, move , -1 )
			fondo.touch = onPageSwipe
			fondo:addEventListener( "touch", fondo )

		end

	end
end

-- Funcion para verificar si esta página corresponde al marcador, y hacerlo visible.
local function verificarMarcador()
	local pagMarcador = composer.getVariable( "paginaMarcador" )
	local pag_act = composer.getVariable( "pagina" )

	if pagMarcador == pag_act then
		transition.to( markerObj, { alpha=1 } )
	else
		transition.to( markerObj, { alpha=0.2 } )
	end
	return true
end

-- Funcion para guardar en el archivo los datos del marcador
local function guardarMarcador()

    local ruta = system.pathForFile( "data.txt", system.DocumentsDirectory )
    local pag = composer.getVariable( "paginaMarcador" )
    local tabla

    local archivo = io.open( ruta, "r" )

    if archivo then
        local data = archivo:read( "*a" )
        tabla = json.decode( data )
        io.close( archivo )
    else
        tabla = {}
    end

    archivo = io.open( ruta, "w" )

    if archivo then
        tabla.paginaMarcador = pag
        contenido = json.encode( tabla )
        archivo:write(contenido)

		io.close( archivo )
	end
	return true

end

-- Funcion que activa el marcador para la página actual.
local function activarMarcador( event )

	if event.phase == "ended" or event.phase == "cancelled" then

		local pagActual = composer.getVariable( "pagina" )
		local pagMarcador = composer.getVariable( "paginaMarcador" )

		if pagActual == pagMarcador then
			transition.to( markerObj, { alpha=0.2 } )
			composer.setVariable( "paginaMarcador", 0 )
		else
			-- Hacer visible el marcador y guardar la pagina
			transition.to( markerObj, { alpha=1 } )
			composer.setVariable( "paginaMarcador", pagActual )
		end

		guardarMarcador()
	end

	return true
end

-- Funcion que se activa cuando se toca al puma guia.
continuarAnimacion = function( event )

	if event.phase == "ended" or event.phase == "cancelled" then
		showNext()
	end

	return true

end


-- touch event listener for background object
onPageSwipe = function( self, event )
    local phase = event.phase
    local pag_act = composer.getVariable( "pagina" )

    if phase == "began" then
        display.getCurrentStage():setFocus( self )
        self.isFocus = true
        self.tiempo = event.time
    
    elseif self.isFocus then
        if phase == "ended" or phase == "cancelled" then
            
            local distance = event.x - event.xStart

            local duracion = event.time - self.tiempo

            if math.abs(distance) > swipeThresh then

                pag_sig = pag_act - distance/math.abs(distance)
                pag = "P" .. pag_sig
                composer.setVariable( "pagina", pag_sig)

                if distance > swipeThresh then
                    -- deslizar hacia la derecha, pagina anterior
                    composer.gotoScene( pag, "slideRight", 800 )
                else
                    -- deslizar a la izquierda, pagina siguiente
                    composer.gotoScene( pag, "slideLeft", 800 )
                end

            elseif duracion > 800 then
                composer.showOverlay( "menu", {effect="fade",time=900,isModal=true} )
            end
            
            display.getCurrentStage():setFocus( nil )
            self.isFocus = nil
        end
    end
    return true
end

onPageTouch = function( event )
    local phase = event.phase
    local pag_act = composer.getVariable( "pagina" )

    if phase == "began" then
        tiempoInicio = event.time
    
    elseif phase == "ended" or phase == "cancelled" then
        
        local duracion = event.time - tiempoInicio
        if duracion > 800 then
            composer.showOverlay( "menu", {effect="fade",time=900,isModal=true} )
        end
    end
    return true
end

function scene:create( event )
	local sceneGroup = self.view

	fondo = display.newImageRect( sceneGroup, "Pagina3/fondo.png", display.contentWidth, display.contentHeight)
    fondo.x, fondo.y = display.contentCenterX, display.contentCenterY
    fondo.isVisible = true

	cientifico = display.newImageRect( sceneGroup, "Pagina3/ninos_observando_puma.png", display.contentWidth * 0.48, display.contentHeight*0.56)
	cientifico.x, cientifico.y = display.contentWidth*0.28, display.contentHeight * 0.76
	cientifico.maximoinflado, cientifico.inflar, cientifico.cuaninflado = 0.05, true, 1
	cientifico.sonido = audio.loadSound( "Pagina2/puma.mp3" )

    finger_left = display.newImageRect( sceneGroup, "swipeIzq.png", 150, 150 )
    finger_left.x, finger_left.y = display.contentWidth * 0.9, display.contentHeight * 0.25
    finger_left.isVisible = false

    sceneGroup:insert(textGroup)
   
	--create marker object
	markerObj = display.newImageRect(sceneGroup, "Marcador.png", 80, 120 )
	markerObj.x, markerObj.y = 40, 60
	markerObj.alpha = 0.2


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

		markerObj.alpha = 0.2
		verificarMarcador()

		composer.removeScene( composer.getVariable( "paginaAnterior" ) )
		Runtime:addEventListener( "touch", onPageTouch )

		animStep = 1
		readyToContinue = true

		showNext()
		markerObj:addEventListener( "touch", activarMarcador )		
		
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
	
		-- remove touch event listener for background
		markerObj:removeEventListener( "touch", activarMarcador )
	
		-- cancel page animations (if currently active)
		if pageTween then transition.cancel( pageTween ); pageTween = nil; end
		if fadeTween1 then transition.cancel( fadeTween1 ); fadeTween1 = nil; end
		if fadeTween2 then transition.cancel( fadeTween2 ); fadeTween2 = nil; end

		Runtime:removeEventListener( "touch", onPageTouch )

		composer.setVariable( "paginaAnterior", "P3" )
		if handsTimer then timer.cancel( handsTimer ); handsTimer = nil; end
		
	elseif phase == "did" then

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