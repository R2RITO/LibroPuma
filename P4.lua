-----------------------------------------------------------------------------------------
--
-- page1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")



-- forward declarations and other locals
local pageText, animacionTexto, pageTween, fadeTween1, 
      markerObj, finger_left, handsTimer, globoDiccionario,
      textoCarnivoro, fondo1, fondo2, escalaPuma, barraBalanza, pumaBalanza,
      baseBalanza, personasBalanza


local continuarAnimacion, onPageSwipe

local textGroup = display.newGroup()

local swipeThresh = 100     -- amount of pixels finger must travel to initiate page swipe
local tweenTime = 900
local animStep = 1
local readyToContinue = false

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

local function repositionAndFadeIn( texto, factorX, factorY )
    texto.x = display.contentWidth * factorX
    texto.y = display.contentHeight * factorY

    texto.alpha = 0
    texto.isVisible = true
            
    fadeTween1 = transition.to( texto, { time=tweenTime*0.5, alpha=1.0 } )
end

local function desvanecerTexto( texto )
    fadeTween1 = transition.to( texto, { time=tweenTime*0.5, alpha=0 } )
    texto.isVisible = false
end

local function crearTexto( args )

    local textOption = 
        {           
            parent = textGroup,
            text = args.texto,     
            width = args.ancho or 900,     --required for multi-line and alignment
            font = args.fuente or "Austie Bost Kitten Klub",   
            fontSize = args.tam or 40,
            align = "center"  --new alignment parameter
    
        }

    return display.newText(textOption)
end

local function alternarDiccionario( self, event )

    if event.phase == "ended" or event.phase == "cancelled" then

        if self.globoActivo then

            fadeTween1 = transition.fadeOut( self.globo, { 
                                             onComplete=desvanecerTexto(self.definicion)
                                                         } 
                                            )
            self.globoActivo = false

        else
            self.globo.x, self.globo.y = display.contentWidth * self.factorX, display.contentHeight * self.factorY
            self.globo.isVisible = true
            fadeTween1 = transition.fadeIn( self.globo, {                                      
                                                onComplete=
                                                repositionAndFadeIn(self.definicion,self.factorX,self.factorY)
                                                    } 
                                      )
            self.globoActivo = true
        end

    end

    return true
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
        
        if animStep == 1 then

            -- Animacion de inflado
            ovalo.enterFrame = inflate
            Runtime:addEventListener( "enterFrame", ovalo )

            -- Tocar para continuar
            ovalo:addEventListener( "touch", continuarAnimacion )

            -- Parametros para posicionar la imagen del globo y la definicion de la palabra.
            -- De ser necesario, reposicionar el globo en cada palabra.
            -- animacionTexto.definicion, animacionTexto.globo = textoCarnivoro, globoDiccionario
            -- animacionTexto.factorX, animacionTexto.factorY = 0.85, 0.15
            -- animacionTexto.globoActivo = false
            -- animacionTexto.touch = alternarDiccionario
            -- animacionTexto:addEventListener( "touch", animacionTexto )

            completeTween()


        elseif animStep == 2 then

            -- Preventivamente desaparecer los elementos del diccionario
            textoCarnivoro.isVisible = false
            globoDiccionario.alpha = 0

            -- Remover las animaciones anteriores
            ovalo.isVisible = false
            Runtime:removeEventListener("enterFrame", ovalo)
            ovalo:removeEventListener("touch", continuarAnimacion)

            fadeTween1 = transition.fadeOut( escalaPuma, { time = 300} )
            fadeTween1 = transition.fadeIn( baseBalanza, { delay = 300} )
            fadeTween1 = transition.fadeIn( barraBalanza, { delay = 300} )
            fadeTween1 = transition.fadeIn( pumaBalanza, { delay = 300} )
            fadeTween1 = transition.fadeIn( personasBalanza, { delay = 300} )

            completeTween()

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

    -- Called when the scene's view does not exist.
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
    
    -- -- create background image
    fondo1 = display.newImageRect( sceneGroup, "Pagina4/fondo1.png", display.contentWidth, display.contentHeight )
    fondo1.x, fondo1.y = display.contentCenterX, display.contentCenterY

    fondo2 = display.newImageRect( sceneGroup, "Pagina4/fondo2.png", display.contentWidth, display.contentHeight )
    fondo2.x, fondo2.y = display.contentCenterX, display.contentCenterY
    fondo2.isVisible = false

    -- Sección de diccionario
    globoDiccionario = display.newImageRect( sceneGroup, "Pagina4/globoDiccionario.png", display.contentWidth * 0.2, display.contentHeight * 0.2 )
    globoDiccionario.x, globoDiccionario.y = display.contentWidth * 0.85, display.contentHeight * 0.15
    globoDiccionario.alpha = 0

    textoCarnivoro = crearTexto{ texto="Que se alimenta de carne", ancho=500, tam=30 }
    textoCarnivoro.isVisible = false

    -- Imagen del puma con la regla
    escalaPuma = display.newImageRect( sceneGroup, "Pagina4/puma_regla.png", display.contentWidth * 0.9, display.contentHeight * 0.6 )
    escalaPuma.x, escalaPuma.y = display.contentWidth * 0.5, display.contentHeight * 0.7

    -- Sección de imágenes de la balanza.

    pumaBalanza = display.newImageRect( sceneGroup, "Pagina4/balanza_puma.png", display.contentWidth * 0.15, display.contentHeight * 0.38 )
    pumaBalanza.x, pumaBalanza.y = display.contentWidth * 0.26, display.contentHeight * 0.72
    pumaBalanza.alpha = 0

    personasBalanza = display.newImageRect( sceneGroup, "Pagina4/balanza_personas.png", display.contentWidth * 0.15, display.contentHeight * 0.38 )
    personasBalanza.x, personasBalanza.y = display.contentWidth * 0.64, display.contentHeight * 0.68
    personasBalanza.alpha = 0

    barraBalanza = display.newImageRect( sceneGroup, "Pagina4/balanza_barra.png", display.contentWidth * 0.4, display.contentHeight * 0.1 )
    barraBalanza.x, barraBalanza.y = display.contentWidth * 0.45, display.contentHeight * 0.5
    barraBalanza.alpha = 0

    baseBalanza = display.newImageRect( sceneGroup, "Pagina4/balanza_base.png", display.contentWidth * 0.55, display.contentHeight * 0.6 )
    baseBalanza.x, baseBalanza.y = display.contentWidth * 0.45, display.contentHeight * 0.7
    baseBalanza.alpha = 0

    ovalo = display.newImageRect( sceneGroup, "Pagina4/ovalo.png", display.contentWidth * 0.09, display.contentHeight * 0.07 )
    ovalo.x, ovalo.y = display.contentWidth * 0.81, display.contentHeight * 0.24
    ovalo.maximoinflado, ovalo.inflar, ovalo.cuaninflado = 0.05, true, 1

    finger_left = display.newImageRect( sceneGroup, "swipeIzq.png", 150, 150 )
    finger_left.x, finger_left.y = display.contentWidth * 0.9, display.contentHeight * 0.5
    finger_left.isVisible = false

    sceneGroup:insert(textGroup)

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

        composer.setVariable( "paginaAnterior", "P4" )
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