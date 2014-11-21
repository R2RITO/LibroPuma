-----------------------------------------------------------------------------------------
--
-- page1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")



-- forward declarations and other locals
local cielo, pasto, cientifico, nube, hojas, bosque, pageText, continueText,
      pageTween, fadeTween1, fadeTween2, markerObj


local continuarAnimacion

local swipeThresh = 100     -- amount of pixels finger must travel to initiate page swipe
local tweenTime = 900
local animStep = 1
local readyToContinue = false

-- function to show next animation
local function showNext()
    if readyToContinue then
        continueText.isVisible = false
        readyToContinue = false
        
        local function repositionAndFadeIn()
            pageText.x = display.contentWidth * 0.5
            pageText.y = display.contentHeight * 0.3

            pageText.isVisible = true
                    
            fadeTween1 = transition.to( pageText, { time=tweenTime*0.5, alpha=1.0 } )
        end
        
        local function completeTween()
            animStep = animStep + 1
            if animStep > 3 then animStep = 1; end
            
            readyToContinue = true
            continueText.isVisible = true
        end

        local function desaparecer( self )
            self.isVisible = false
        end
        
        if animStep == 1 then

            pageText.alpha = 0

            local textOption = 
                {           
                    --parent = textGroup,
                    text = "¡Hola! Bienvenido a este cuento, tócame para comenzar.",     
                    width = 500,     --required for multi-line and alignment
                    font = "Austie Bost Kitten Klub",   
                    fontSize = 40,
                    align = "center"  --new alignment parameter
            
                }

            pageText= display.newText(textOption)
            pageText.isVisible = false

            pageTween = transition.to( cientifico, { time=tweenTime, transition=easing.outExpo, onComplete=completeTween } )
            cientifico.isVisible = true           
            repositionAndFadeIn()

        elseif animStep == 2 then
            pageText.alpha = 0 --transparent
            
            local textOption = 
                {           
                    --parent = textGroup,
                    text = "¡Te presento al puma chileno, tócalo para conocer su nombre científico!",     
                    width = 500,     --required for multi-line and alignment
                    font = "Austie Bost Kitten Klub",   
                    fontSize = 40,
                    align = "center"  --new alignment parameter
                            
                }

            pageText= display.newText(textOption) 
            repositionAndFadeIn()

            retratoPuma.isVisible = true
            hojas.isVisible = true
            bosque.isVisible = true

            transition.to( hojas, { time=tweenTime, x=display.contentWidth*0.2, transition=easing.outExpo} )
            transition.to( bosque, { time=tweenTime, x=display.contentWidth*0.25, transition=easing.outExpo} )
            transition.to( retratoPuma, { time=tweenTime, alpha=1, transition=easing.outExpo, onComplete=completeTween } )

            cientifico:removeEventListener( "touch", continuarAnimacion )
            --retratoPuma:addEventListener( "touch", continuarAnimacion )
        
        elseif animStep == 3 then
            pageText.alpha = 0
            local textOption = 
                {           
                    --parent = textGroup,
                    text = "Felis Concolor.",     
                    width = 500,     --required for multi-line and alignment
                    font = "Austie Bost Kitten Klub",   
                    fontSize = 40,
                    align = "center"  --new alignment parameter
                    
                }

            pageText= display.newText(textOption)
            repositionAndFadeIn()
            
            pageTween = transition.to( ramaObj, { time=tweenTime*1.5, alpha=0, transition=easing.inOutExpo, onComplete=completeTween } )

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

    local archivo = io.open( ruta, "w" )

    if archivo then
        local tabla = {}
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
    -- background = display.newImageRect( sceneGroup, "PumaArbol.jpg", display.contentWidth * 2.5, display.contentHeight - 120 )
    -- background.anchorX = 0
    -- background.anchorY = 0
    -- background.x, background.y = -750, 0
    -- background.alpha = 0.5

    cielo = display.newImageRect( sceneGroup, "Pagina1\\Sky.jpg", display.contentWidth, display.contentHeight * 0.6 )
    cielo.x, cielo.y = display.contentWidth*0.5, display.contentHeight * 0.3

    pasto = display.newImageRect( sceneGroup, "Pagina1\\Grass.png", display.contentWidth, display.contentHeight * 2)
    pasto.x, pasto.y = display.contentWidth*0.5, display.contentHeight * 0.35


    hojas = display.newImageRect( sceneGroup, "Pagina1\\Hojas2.png", display.contentWidth * 0.45, display.contentHeight * 0.65 )
    hojas.x, hojas.y = display.contentWidth * -2, display.contentHeight * 0.7
    hojas.isVisible = false

    bosque = display.newImageRect( sceneGroup, "Pagina1\\Forest.png", display.contentWidth * 0.6, display.contentHeight * 0.4 )
    bosque.x, bosque.y = display.contentWidth * -2, display.contentHeight * 0.3
    bosque.isVisible = false

    cientifico = display.newImageRect( sceneGroup, "Pagina1\\Scientist.png", display.contentWidth * 0.4, display.contentHeight*0.5)
    cientifico.x, cientifico.y = display.contentWidth*0.25, display.contentHeight * 0.5
    cientifico.isVisible = false

    nube = display.newImageRect( sceneGroup, "Pagina1\\Cloud.png", 256, 256 )
    nube.x, nube.y = display.contentWidth * 0.8, display.contentHeight * 0.2

    retratoPuma = display.newImageRect( sceneGroup, "Pagina1\\retratoPuma.png", display.contentWidth * 0.5, display.contentHeight * 0.7 )
    retratoPuma.x, retratoPuma.y = display.contentWidth * 0.85, display.contentHeight * 0.7
    retratoPuma.alpha = 0
    retratoPuma.isVisible = false


    -- create pageText
    pageText = display.newText( sceneGroup, "", 0, 0, native.systemFontBold, 18 )
    pageText.x = display.contentWidth * 0.5
    pageText.y = display.contentHeight * 0.5
    pageText.isVisible = false
    
    -- create text at bottom of screen
    continueText = display.newText( sceneGroup, "[ Toca la pantalla para continuar ]", 0, 0, native.systemFont, 18 )
    continueText.x = display.contentWidth * 0.5
    continueText.y = display.contentHeight - (display.contentHeight * 0.04 ) - 120
    continueText.isVisible = false

    --create marker object
    markerObj = display.newImageRect( sceneGroup, "Marcador.png", 80, 120 )
    markerObj.x, markerObj.y = 40, 60
    markerObj.isVisible = false
    markerObj.alpha = 0.2
    
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
        rugido = audio.loadSound( "cougar.wav" )
    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc.

        markerObj.alpha = 0.2
        markerObj.isVisible = true
        verificarMarcador()

        animStep = 1
        readyToContinue = true
        showNext()
    
        -- assign touch event to background to monitor page swiping
        --background.touch = onPageSwipe
        --background:addEventListener( "touch", background )
        cientifico:addEventListener( "touch", continuarAnimacion )
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
        
        -- hide objects
        pageText.isVisible = false
        markerObj.isVisible = false
        continueText.isVisible = false
    
        -- remove touch event listener for background
        --background:removeEventListener( "touch", background )
        markerObj:removeEventListener( "touch", activarMarcador )
    
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