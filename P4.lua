-----------------------------------------------------------------------------------------
--
-- page1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")



-- forward declarations and other locals
local cientifico, pageText, animacionTexto, pageText2, pageTween, fadeTween1, 
      fadeTween2, markerObj, finger_left, handsTimer, globoDiccionario,
      textoCarnivoro, siluetaGato, siluetaPerro, siluetaPuma, fondo


local continuarAnimacion, onPageSwipe

local textGroup = display.newGroup()

local swipeThresh = 100     -- amount of pixels finger must travel to initiate page swipe
local tweenTime = 900
local animStep = 1
local readyToContinue = false

local function inflate(self,event)
    if (self.inflate) then
        self.rate = self.rate + 0.005
    else 
        self.rate = self.rate - 0.005
    end 

    if (self.rate >= 1 + self.inf ) then
        self.inflate = false
    elseif (self.rate <= 1 - self.inf) then
        self.inflate =  true
    end 

    self.xScale = self.rate 
    self.yScale = self.rate 

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
            if animStep > 5 then animStep = 1; end
            
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

            cientifico.isVisible = true
            fadeTween1 = transition.to( cientifico, { time=tweenTime, x=display.contentWidth*0.25 ,transition=easing.outExpo } )

            -- Crear texto nuevo
            pageText = crearTexto{texto="!Observa lo grande que es!. Es el mayor "}
            pageText.isVisible = false

            animacionTexto = crearTexto{texto="carnívoro"}
            animacionTexto.isVisible = false

            pageText2 = crearTexto{texto=" terrestre de Chile."}
            pageText2.isVisible = false

            repositionAndFadeIn(pageText, 0.40, 0.25)
            repositionAndFadeIn(animacionTexto, 0.85, 0.25)
            repositionAndFadeIn(pageText2, 0.80, 0.35)


            -- Parametros para posicionar la imagen del globo y la definicion de la palabra.
            -- De ser necesario, reposicionar el globo en cada palabra.
            animacionTexto.definicion, animacionTexto.globo = textoCarnivoro, globoDiccionario
            animacionTexto.factorX, animacionTexto.factorY = 0.85, 0.15
            animacionTexto.globoActivo = false
            animacionTexto.touch = alternarDiccionario
            animacionTexto:addEventListener( "touch", animacionTexto )

            cientifico:addEventListener( "touch", continuarAnimacion)
            cientifico.enterFrame = inflate
            Runtime:addEventListener("enterFrame", cientifico)

            completeTween()


        elseif animStep == 2 then

            -- Desaparecer texto anterior
            pageText.alpha = 0
            animacionTexto.alpha = 0
            pageText2.alpha = 0

            -- Preventivamente desaparecer los elementos del diccionario
            textoCarnivoro.isVisible = false
            globoDiccionario.alpha = 0

            -- Remover las animaciones anteriores
            Runtime:removeEventListener("enterFrame", cientifico)
            animacionTexto:removeEventListener( "touch", animacionTexto )
            cientifico:removeEventListener("touch", continuarAnimacion)

            -- Crear texto nuevo
            pageText = crearTexto{texto="Tiene una longitud de hasta "}
            pageText.isVisible = false

            animacionTexto = crearTexto{texto="1.90"}
            animacionTexto.isVisible = false

            pageText2 = crearTexto{texto=" metros. ¡Impresionante!"}
            pageText2.isVisible = false

            repositionAndFadeIn(pageText, 0.40, 0.25)
            repositionAndFadeIn(animacionTexto, 0.85, 0.25)
            repositionAndFadeIn(pageText2, 0.80, 0.35)

            -- Agregar "receptores" para la nueva animacion
            animacionTexto:addEventListener( "touch", continuarAnimacion )

            completeTween()
            

        elseif animStep == 3 then
            
            -- Eliminar funciones anteriores
            animacionTexto:removeEventListener( "touch", continuarAnimacion )

            transition.moveTo( siluetaPuma, {x=display.contentWidth*0.7} )
            transition.moveTo( siluetaPerro, {x=display.contentWidth*0.7} )
            transition.moveTo( siluetaGato, {x=display.contentWidth*0.7} )

            -- Agregar "receptores" para continuar
            cientifico:addEventListener( "touch", continuarAnimacion)
            cientifico.enterFrame = inflate
            Runtime:addEventListener("enterFrame", cientifico)

            completeTween()

        elseif animStep == 4 then
            -- Eliminar funciones anteriores
            Runtime:removeEventListener("enterFrame", cientifico)
            cientifico:removeEventListener( "touch", continuarAnimacion )
            siluetaPuma:removeSelf()
            siluetaPerro:removeSelf()
            siluetaGato:removeSelf()

            -- Desaparecer texto anterior
            pageText.alpha = 0
            animacionTexto.alpha = 0
            pageText2.alpha = 0

             -- Crear texto nuevo
            pageText = crearTexto{texto="Su cola mide más de 80cm y los más grandes alcanzan a pesar "}
            pageText.isVisible = false

            animacionTexto = crearTexto{texto="55kg."}
            animacionTexto.isVisible = false

            repositionAndFadeIn(pageText, 0.40, 0.25)
            repositionAndFadeIn(animacionTexto, 0.85, 0.25)

            -- Agregar "receptores" para la nueva animacion
            animacionTexto:addEventListener( "touch", continuarAnimacion )

            completeTween()

        elseif animStep == 5 then

            -- Eliminar funciones anteriores
            animacionTexto:removeEventListener( "touch", continuarAnimacion )

            -- Animar balanza
            transition.fadeIn( balanza )

            -- Agregar "receptores" para continuar
            fondo.touch = onPageSwipe
            --fondo:addEventListener( "touch", fondo )

            -- Animar ayuda para swipe
            finger_left.isVisible = true

            handsTimer = timer.performWithDelay( 1000, move, -1 )

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
    fondo = display.newImageRect( sceneGroup, "Pagina4/Sky.jpg", display.contentWidth, display.contentHeight )
    fondo.x, fondo.y = display.contentCenterX, display.contentCenterY

    cientifico = display.newImageRect( sceneGroup, "Pagina4/Scientist.png", display.contentWidth * 0.4, display.contentHeight*0.5)
    cientifico.x, cientifico.y = display.contentWidth*-0.25, display.contentHeight * 0.6
    cientifico.isVisible, cientifico.inf, cientifico.inflate, cientifico.rate = false, 0.05, true, 1

    -- Sección de diccionario

    globoDiccionario = display.newImageRect( sceneGroup, "Pagina4/globoDiccionario.png", display.contentWidth * 0.2, display.contentHeight * 0.2 )
    globoDiccionario.x, globoDiccionario.y = display.contentWidth * 0.85, display.contentHeight * 0.15
    globoDiccionario.alpha = 0

    textoCarnivoro = crearTexto{ texto="Que se alimenta de carne", ancho=500, tam=30 }
    textoCarnivoro.isVisible = false

    -- Sección de siluetas
    siluetaPuma = display.newImageRect( sceneGroup, "Pagina4/puma.png", display.contentWidth * 0.4, display.contentHeight * 0.4 )
    siluetaPuma.x, siluetaPuma.y = display.contentWidth * 1.3, display.contentHeight * 0.7

    siluetaPerro = display.newImageRect( sceneGroup, "Pagina4/perro.png", display.contentWidth * 0.35, display.contentHeight * 0.35 )
    siluetaPerro.x, siluetaPerro.y = display.contentWidth * 1.3, display.contentHeight * 0.75

    siluetaGato = display.newImageRect( sceneGroup, "Pagina4/gato.png", display.contentWidth * 0.2, display.contentHeight * 0.2 )
    siluetaGato.x, siluetaGato.y = display.contentWidth * 1.3, display.contentHeight * 0.8

    -- Sección de imágenes de la página.
    balanza = display.newImageRect( sceneGroup, "Pagina4/balanza.png", display.contentWidth * 0.3, display.contentHeight * 0.3 )
    balanza.x, balanza.y = display.contentWidth * 0.7, display.contentHeight * 0.8
    balanza.alpha = 0

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

        composer.setVariable( "paginaAnterior", "P4" )
        timer.cancel( handsTimer ); handsTimer = nil;
        
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