

-----------------------------------------------------------------------------------------
--
-- page1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")



-- forward declarations and other locals
local background2, pageText2, continueText2, pageTween, fadeTween1, fadeTween2, siluetaNegra2, siluetaGris2

local swipeThresh = 100     -- amount of pixels finger must travel to initiate page swipe
local tweenTime = 500
local animStep = 1
local readyToContinue = false

-- function to show next animation
local function showNext()
    if readyToContinue then
        continueText2.isVisible = false
        readyToContinue = false
        
        local function repositionAndFadeIn()
            pageText2.x = display.contentWidth * 0.5
            pageText2.y = display.contentHeight * 0.3
            pageText2.isVisible = true

                    
            fadeTween1 = transition.to( pageText2, { time=tweenTime*0.5, alpha=1.0 } )
        end
        
        local function completeTween()
            animStep = animStep + 1
            if animStep > 3 then animStep = 1; end
            
            readyToContinue = true
            continueText2.isVisible = true
        end

        local function desaparecer( self )
            self.isVisible = false
        end
        
        if animStep == 1 then
            pageText2.alpha = 0

            local textOption = 
                {           
                    --parent = textGroup,
                    text =  "Características: Es el mayor carnívoro terrestre de Chile. Tiene una longitud hasta de 1,90 metros. con una cola de más de 80 cm. y los ejemplares más grandes alcanzan 55 kilos. ",     
                    width = 500,     --required for multi-line and alignment
                    font = "Austie Bost Kitten Klub",   
                    fontSize = 40,
                    align = "center"  --new alignment parameter
            
                }

            pageText2= display.newText(textOption)
            pageText2.isVisible = false
            repositionAndFadeIn()

            siluetaNegra2.alpha = 1 --Not transparent
            siluetaNegra2.x = -siluetaNegra2.contentWidth
            siluetaNegra2.isVisible = true
            pageTween = transition.to( siluetaNegra2, { time=tweenTime, x=display.contentWidth*0.75, transition=easing.outExpo, onComplete=completeTween } )
            pageTween = transition.to( siluetaNegra2, { alpha=0, onComplete=desaparecer } )

        elseif animStep == 2 then
            pageText2.alpha = 0 --transparent
            
            local textOption = 
                {           
                    --parent = textGroup,
                    text = "Características: Es el mayor carnívoro terrestre de Chile. Tiene una longitud hasta de 1,90 metros. con una cola de más de 80 cm. y los ejemplares más grandes alcanzan 55 kilos. ",     
                    width = 500,     --required for multi-line and alignment
                    font = "Austie Bost Kitten Klub",   
                    fontSize = 40,
                    align = "center"  --new alignment parameter
                            
                }

            pageText2= display.newText(textOption)   
            repositionAndFadeIn()

            siluetaGris2.alpha = 1
            siluetaGris2.x = display.contentWidth + siluetaGris2.contentWidth
            siluetaGris2.isVisible = true
            pageTween = transition.to( siluetaGris2, { time=tweenTime, x=display.contentWidth*0.5, transition=easing.outExpo, onComplete=completeTween } )
            pageTween = transition.to( siluetaGris2, { alpha=0, onComplete=desaparecer } )
        
        elseif animStep == 3 then
            pageText2.alpha = 0
            local textOption = 
                {           
                    --parent = textGroup,
                    text = "Son cazadores por excelencia, cautos, silenciosos y solitarios. Se alimenta de diversas presas, desde roedores como ratones y tucos tucos, hasta huemules y guanacos pero no ataca al hombre.",     
                    width = 500,     --required for multi-line and alignment
                    font = "Austie Bost Kitten Klub",   
                    fontSize = 40,
                    align = "center"  --new alignment parameter
                    
                }

            pageText2= display.newText(textOption)
            repositionAndFadeIn()
            
            ramaObj2.isVisible = true
            ramaObj2.alpha = 0
            pageTween = transition.to( ramaObj2, { time=tweenTime*1.5, alpha=1, transition=easing.inOutExpo, onComplete=completeTween } )
            pageTween = transition.to( ramaObj2, { alpha=0, delay=2500, onComplete=desaparecer } )
        end
    end
end

-- Funcion para verificar si esta página corresponde al marcador, y hacerlo visible.
local function verificarMarcador()
    local pagMarcador = composer.getVariable( "paginaMarcador" )
    local pag_act = composer.getVariable( "pagina" )

    print( "PagM" .. pagMarcador .. " Pag" .. pag_act)

    if pagMarcador == pag_act then
        print("Marcador activo, alpha 1")
        transition.to( markerObj2, { alpha=1 } )
    else
        --transition.to( markerObj2, { alpha=0.2 } )
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
            transition.to( markerObj2, { alpha=0.2 } )
            composer.setVariable( "paginaMarcador", 0 )
        else
            -- Hacer visible el marcador y guardar la pagina
            transition.to( markerObj2, { alpha=1 } )
            composer.setVariable( "paginaMarcador", pagActual )
        end

        guardarMarcador()
    end

    return true
end

-- touch event listener for background2 object
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
                if pag_sig == 3 then
                    return true
                end
                pag = "P" .. pag_sig
                composer.setVariable( "pagina", pag_sig)

                if distance > swipeThresh then
                    -- deslizar hacia la derecha, pagina anterior
                    composer.gotoScene( pag, "slideRight", 800 )
                    pageText2.isVisible=false
                else
                    -- deslizar a la izquierda, pagina siguiente
                    composer.gotoScene( pag, "slideLeft", 800 )
                    pageText2.isVisible=false
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
    
    -- create background2 image
    background2 = display.newImageRect( sceneGroup, "PumaArbol.jpg", display.contentWidth * 2.5, display.contentHeight - 120 )
    background2.anchorX = 0
    background2.anchorY = 0
    background2.x, background2.y = -750, 0
    background2.alpha = 0.5
    
    
    -- Creacion de iconos 
    siluetaNegra2 = display.newImageRect( sceneGroup, "PumaSF.png", 400, 300 )
    siluetaNegra2.x = display.contentWidth * 0.5
    siluetaNegra2.y = display.contentHeight * 0.5
    siluetaNegra2.isVisible = false
    
    siluetaGris2 = display.newImageRect( sceneGroup, "PumaSFG.png", 400, 300 )
    siluetaGris2.x = display.contentWidth * 0.10
    siluetaGris2.y = display.contentHeight * 0.55
    siluetaGris2.isVisible = false

    fallingObj2 = display.newImageRect( sceneGroup, "PumaCayendo.png", 400, 300 )
    fallingObj2.x = display.contentWidth * 0.44
    fallingObj2.y = display.contentHeight * 0.55
    fallingObj2.isVisible = false

    ramaObj2 = display.newImageRect( sceneGroup, "PumaRama.png", 600, 300 )
    ramaObj2.anchorX = 0
    ramaObj2.anchorY = 0
    ramaObj2.x , ramaObj2.y = display.contentWidth * 0.3, display.contentHeight * 0.60
    ramaObj2.isVisible = false
    
    -- create pageText2
    pageText2 = display.newText( sceneGroup, "", 0, 0, native.systemFontBold, 18 )
    pageText2.x = display.contentWidth * 0.5
    pageText2.y = display.contentHeight * 0.5
    pageText2.isVisible = false
    
    -- create text at bottom of screen
    continueText2 = display.newText( sceneGroup, "[ Toca la pantalla para continuar ]", 0, 0, native.systemFont, 18 )
    continueText2.x = display.contentWidth * 0.5
    continueText2.y = display.contentHeight - (display.contentHeight * 0.04 ) - 120
    continueText2.isVisible = false

    --create marker object
    markerObj2 = display.newImageRect( sceneGroup, "Marcador.png", 80, 119 )
    markerObj2.anchorX = 0
    markerObj2.anchorY = 0
    markerObj2.x, markerObj2.y = 0, 50
    markerObj2.isVisible = false
    markerObj2.alpha = 0.2
    
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

        markerObj2.alpha = 0.2
        print( "P2MarkerTrueInicio" )
        markerObj2.isVisible = true
        print( "P2MarkerTrueFin" )
        verificarMarcador()

        
        animStep = 1
        readyToContinue = true
        showNext()
    
        -- assign touch event to background2 to monitor page swiping
        background2.touch = onPageSwipe
        background2:addEventListener( "touch", background2 )
        markerObj2:addEventListener( "touch", activarMarcador )
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
        siluetaNegra2.isVisible = false
        siluetaGris2.isVisible = false
        ramaObj2.isVisible = false
        pageText2.isVisible = false
        print( "P2MarkerFalseInicio" )
        markerObj2.isVisible = false
        print( "P2MarkerFalseFin" )
    
        -- remove touch event listener for background2
        background2:removeEventListener( "touch", background2 )
        markerObj2:removeEventListener( "touch", activarMarcador )
    
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