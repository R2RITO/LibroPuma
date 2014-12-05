-----------------------------------------------------------------------------------------
--
-- page1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")



-- forward declarations and other locals
local cientifico, pageText, pageTween, fadeTween1, fadeTween2, markerObj,
      fondoPreguntas, marcoJungla, puma, ave, caballo, sonidoAve,
      sonidoPuma, sonidoCaballo, juegoCompletado, globoExito, globoFallo

local continuarAnimacion, onPageSwipe

local swipeThresh = 100     -- amount of pixels finger must travel to initiate page swipe
local tweenTime = 900

local function desaparecerGlobo( globo )
    transition.to( globo, { alpha=0 })
    globo.isVisible = false
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
            fondoPreguntas.touch = onPageSwipe
            fondoPreguntas:addEventListener( "touch", fondoPreguntas )

            -- Iniciar animacion de swipe.

            -- Iniciar animacion de exito

            globoExito.x, globoExito.y = self.x - 50, self.y - 50
            globoExito.isVisible = true
            fadeTween1 = transition.to( globoExito, { y = globoExito.y - 250, onComplete=desaparecerGlobo } )

        end

    end

    return true

end

local function iniciarJuego()
        
    local function repositionAndFadeIn( factorX, factorY )
        pageText.x = display.contentWidth * factorX
        pageText.y = display.contentHeight * factorY

        pageText.isVisible = true
                
        fadeTween1 = transition.to( pageText, { time=tweenTime*0.5, alpha=1.0 } )
    end

    pageText.alpha = 0

    local textOption = 
        {           
            --parent = textGroup,
            text = "¡Toca al puma para conocer su hábitat!.",     
            width = 500,     --required for multi-line andT alignment
            font = "Austie Bost Kitten Klub",   
            fontSize = 60,
            align = "center"  --new alignment parameter
    
        }

    pageText= display.newText(textOption)
    pageText.isVisible = false

    cientifico.isVisible = true          
    repositionAndFadeIn(0.3,0.25)

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

-- touch event listener for background object
onPageSwipe = function( self, event )
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

    fondoPreguntas = display.newImageRect( sceneGroup, "Pagina2/fondoPregNegro.jpg", display.contentWidth, display.contentHeight )
    fondoPreguntas.x, fondoPreguntas.y = display.contentWidth * 0.5, display.contentHeight * 0.5

    marcoJungla = display.newImageRect( sceneGroup, "Pagina2/JungleFrame.png", display.contentWidth * 1.3, display.contentHeight * 1.3 )
    marcoJungla.x, marcoJungla.y = display.contentWidth * 0.5, display.contentHeight * 0.5

    cientifico = display.newImageRect( sceneGroup, "Pagina2/Scientist.png", display.contentWidth * 0.4, display.contentHeight*0.5)
    cientifico.x, cientifico.y = display.contentWidth*0.25, display.contentHeight * 0.6
    cientifico.isVisible = false

    puma = display.newImageRect( sceneGroup, "Pagina2/puma.png", display.contentWidth * 0.35, display.contentHeight * 0.35 )
    puma.x, puma.y = display.contentWidth * 0.65, display.contentHeight * 0.7
    puma.sonido = audio.loadSound( "Pagina2/puma.mp3" )
    puma.touch = seleccionCorrecta

    ave = display.newImageRect( sceneGroup, "Pagina2/ave.png", display.contentWidth * 0.15, display.contentHeight * 0.15 )
    ave.x, ave.y = display.contentWidth * 0.5, display.contentHeight * 0.55
    ave.sonido = audio.loadSound( "Pagina2/ave.mp3" )
    ave.touch = seleccionIncorrecta

    caballo = display.newImageRect( sceneGroup, "Pagina2/caballo.png", display.contentWidth * 0.3, display.contentHeight * 0.4 )
    caballo.x, caballo.y = display.contentWidth * 0.75, display.contentHeight * 0.35
    caballo.sonido = audio.loadSound( "Pagina2/caballo.mp3" )
    caballo.touch = seleccionIncorrecta

    globoExito = display.newImageRect( sceneGroup, "Pagina2/globoExito.png", display.contentWidth* 0.15, display.contentHeight * 0.15 )
    globoExito.isVisible = false

    globoFallo = display.newImageRect( sceneGroup, "Pagina2/globoFallo.png", display.contentWidth* 0.15, display.contentHeight * 0.15 )
    globoFallo.isVisible = false

    -- create pageText
    pageText = display.newText( sceneGroup, "", 0, 0, native.systemFontBold, 18 )
    pageText.x = display.contentWidth * 0.5
    pageText.y = display.contentHeight * 0.5
    pageText.isVisible = false

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
        pageText.isVisible = false
        markerObj.isVisible = false
        cientifico.isVisible = false
    
        -- remove touch event listener for background
        markerObj:removeEventListener( "touch", activarMarcador )
        composer.setVariable( "paginaAnterior", "P2" )
    
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