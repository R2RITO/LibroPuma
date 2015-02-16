-----------------------------------------------------------------------------------------
--
-- page1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")



-- forward declarations and other locals
local finger_left, handsTimer, fadeTween1, fadeTween2, markerObj,
      fondo, marcoJungla, puma, ave, caballo, sonidoAve,
      sonidoPuma, sonidoCaballo, juegoCompletado, globoExito, globoFallo

local onPageSwipe

local swipeThresh = 100     -- amount of pixels finger must travel to initiate page swipe
local tweenTime = 900

local function crearTexto( args )

    local textOption = 
        {           
            parent = textGroup,
            text = args.texto,     
            width = args.ancho or display.contentWidth*0.90,     --required for multi-line and alignment
            font = args.fuente or PTSERIF1,   
            fontSize = args.tam or 33,
            align = "center"  --new alignment parameter
        
        }

    return display.newText(textOption)
end

local function desaparecerGlobo( globo )
    transition.to( globo, { alpha=0 })
    globo.isVisible = false
end

local move = function()
    local function back()
        transition.to( finger_left, { alpha = 0 } )
        finger_left.x=display.contentWidth * 0.9
    end
    transition.to( finger_left, { alpha = 1 } )
    transition.to( finger_left, { x=display.contentWidth * 0.7, time=900, onComplete=back})
    
end

local function seleccionIncorrecta( self, event )

    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play( self.sonido )

        globoFallo.x, globoFallo.y = self.x - 50, self.y - 50
        globoFallo.alpha = 1
        globoFallo.isVisible = true
        fadeTween1 = transition.to( globoFallo, { y = globoFallo.y - 150, onComplete=desaparecerGlobo } )
    end

    return true

end

local function seleccionCorrecta( self, event )

    if event.phase == "ended" or event.phase == "cancelled" then
        audio.play( self.sonido )

        if not juegoCompletado then
            juegoCompletado = true

            -- Habilitar deslizamiento a página siguiente
            --fondo.touch = onPageSwipe
            --fondo:addEventListener( "touch", fondo )
              fondo.touch = onPageSwipe
              fondo:addEventListener( "touch", fondo )

            -- Iniciar animacion de swipe.
            finger_left.isVisible = true
            handsTimer = timer.performWithDelay( 1000, move, -1 )

            -- Iniciar animacion de exito

            globoExito.x, globoExito.y = self.x - 50, self.y - 50
            globoExito.isVisible = true
            fadeTween1 = transition.to( globoExito, { y = globoExito.y - 250, onComplete=desaparecerGlobo } )



        end

    end

    return true

end

local function repositionAndFadeIn( texto, factorX, factorY )
    texto.x = display.contentWidth * factorX
    texto.y = display.contentHeight * factorY

    texto.alpha = 0
    texto.isVisible = true
            
    fadeTween1 = transition.to( texto, { time=tweenTime*0.5, alpha=1.0 } )
end

local function iniciarJuego()            

    puma:addEventListener( "touch", puma )
    ave:addEventListener( "touch", ave )
    caballo:addEventListener( "touch", caballo )

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

    -- Called when the scene's view does not exist.
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
    
    -- -- create background image

    fondo = display.newImageRect( sceneGroup, "Pagina2/fondo.png", display.contentWidth, display.contentHeight)
    fondo.x, fondo.y = display.contentCenterX, display.contentCenterY
    fondo.isVisible = true

    puma = display.newImageRect( sceneGroup, "Pagina2/silueta_puma.png", display.contentWidth * 0.35, display.contentHeight * 0.35)
    puma.x, puma.y = display.contentWidth * 0.75, display.contentHeight * 0.7
    puma.sonido = audio.loadSound( "Pagina2/puma.mp3" )
    puma.touch = seleccionCorrecta

    ave = display.newImageRect( sceneGroup, "Pagina2/silueta_pajaro.png", display.contentWidth * 0.12, display.contentHeight * 0.15 )
    ave.x, ave.y = display.contentWidth * 0.75, display.contentHeight * 0.18
    ave.sonido = audio.loadSound( "Pagina2/ave.mp3" )
    ave.touch = seleccionIncorrecta

    caballo = display.newImageRect( sceneGroup, "Pagina2/silueta_caballo.png", display.contentWidth * 0.4, display.contentHeight * 0.48 )
    caballo.x, caballo.y = display.contentWidth * 0.25, display.contentHeight * 0.73
    caballo.sonido = audio.loadSound( "Pagina2/caballo.mp3" )
    caballo.touch = seleccionIncorrecta

    globoExito = display.newImageRect( sceneGroup, "Pagina2/globoExito.png", display.contentWidth* 0.07, display.contentHeight * 0.1 )
    globoExito.isVisible = false

    globoFallo = display.newImageRect( sceneGroup, "Pagina2/globoFallo.png", display.contentWidth* 0.07, display.contentHeight * 0.1 )
    globoFallo.isVisible = false

    finger_left = display.newImageRect( sceneGroup, "swipeIzq.png", 150, 150 )
    finger_left.x, finger_left.y = display.contentWidth * 0.9, display.contentHeight * 0.43
    finger_left.isVisible = false

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
    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc.

        markerObj.alpha = 0.2
        markerObj.isVisible = true
        verificarMarcador()

        Runtime:addEventListener( "touch", onPageTouch )

        composer.removeScene( composer.getVariable( "paginaAnterior" ) )

        juegoCompletado = false
        iniciarJuego()
    
        -- assign touch event to background to monitor page swiping
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
        markerObj.isVisible = false
    
        -- remove touch event listener for background
        markerObj:removeEventListener( "touch", activarMarcador )
        composer.setVariable( "paginaAnterior", "P2" )
    
        -- cancel page animations (if currently active)
        if pageTween then transition.cancel( pageTween ); pageTween = nil; end
        if fadeTween1 then transition.cancel( fadeTween1 ); fadeTween1 = nil; end
        if fadeTween2 then transition.cancel( fadeTween2 ); fadeTween2 = nil; end
        Runtime:removeEventListener( "touch", onPageTouch )

        if handsTimer then timer.cancel( handsTimer ); handsTimer = nil; end
        
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