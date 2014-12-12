-----------------------------------------------------------------------------------------
--
-- page1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")



-- forward declarations and other locals
local pageText, pageTween, fadeTween1, fadeTween2, finger_left, handsTimer,
      finger_right, cientifico, animacionTexto, pageText2, globoDiccionario,
      textoDefinicion, fondo, diccionarioUsado, textoIndicador, boton


local continuarAnimacion, onPageSwipe

local textGroup = display.newGroup()

local swipeThresh = 100     -- amount of pixels finger must travel to initiate page swipe
local tweenTime = 900
local animStep = 1
local readyToContinue = false

-- Funciones para animaciones

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

-- Funcion para reposicionar texto
local function repositionAndFadeIn( texto, factorX, factorY )
    texto.x = display.contentWidth * factorX
    texto.y = display.contentHeight * factorY

    texto.alpha = 0
    texto.isVisible = true
            
    fadeTween1 = transition.to( texto, { time=tweenTime*0.5, alpha=1.0 } )
end

-- Funcion para desaparecer texto
local function desvanecerTexto( texto )
    fadeTween1 = transition.to( texto, { time=tweenTime*0.5, alpha=0 } )
    texto.isVisible = false
end

-- Funcion para crear un nuevo texto
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

-- Funcion para aparecer o desaparecer el diccionario
local function alternarDiccionario( self, event )

    if event.phase == "ended" or event.phase == "cancelled" then

        if self.globoActivo then

            fadeTween1 = transition.fadeOut( self.globo, { 
                                             onComplete=desvanecerTexto(self.definicion)
                                                         } 
                                            )
            self.globoActivo = false

            if not diccionarioUsado then
                Runtime:addEventListener("enterFrame", cientifico)
                cientifico:addEventListener("touch", continuarAnimacion)
                diccionarioUsado = true
                textoIndicador:removeSelf()
            end


        else
            self.globo.x, self.globo.y = display.contentWidth * self.factorX, display.contentHeight * self.factorY
            self.globo.isVisible = true
            fadeTween1 = transition.fadeIn( self.globo, {                                      
                                                onComplete=
                                                repositionAndFadeIn(self.definicion,self.factorX,self.factorY)
                                                    } 
                                      )
            self.globoActivo = true

            if not diccionarioUsado then
                textoIndicador = crearTexto{texto="Tócala de nuevo para desaparecer el globo cuando termines de leer", ancho=500}
                repositionAndFadeIn(textoIndicador, 0.7, 0.7)
            end
        end

    end

    return true
end

-- Funcion para terminar el tutorial
local function finalizarTutorial( event )

    if event.phase == "ended" or event.phase == "cancelled" then

        composer.setVariable( "tutorialCompletado", 1 )

        local ruta = system.pathForFile( "data.txt", system.DocumentsDirectory )

        local tabla
        local archivo = io.open( ruta, "r" )

        if archivo then
            local data = archivo:read( "*a" )
            tabla = json.decode( data )
            io.close( archivo )
        else
            tabla = {}
        end

        local archivo = io.open( ruta, "w" )

        if archivo then
            tabla.tutorialCompletado = 1
            contenido = json.encode( tabla )
            archivo:write(contenido)

            io.close( archivo )
        end
        composer.setVariable( "pagina", 1 )
        composer.gotoScene( "P1", fade )
    end

    return true

end

-- Fin de funciones para animaciones

-- function to show next animation
local function showNext()
    if readyToContinue then
        readyToContinue = false
        
        local function completeTween()
            animStep = animStep + 1
            if animStep > 6 then animStep = 1; end
            
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

            -- Aparecer cientifico
            cientifico.isVisible = true
            fadeTween1 = transition.to( cientifico, { time=tweenTime, x=display.contentWidth*0.25 ,transition=easing.outExpo } )
            cientifico:addEventListener( "touch", continuarAnimacion )

            -- Crear y mostrar texto
            pageText = crearTexto{texto="Hola, bienvenido a esta guía para leer el cuento. Tócame para continuar"}
            pageText.isVisible = false
            repositionAndFadeIn(pageText, 0.6, 0.3)

            completeTween()

        elseif animStep == 2 then

            -- Desaparecer texto anterior
            pageText.isVisible = false

            cientifico.enterFrame = inflate
            Runtime:addEventListener("enterFrame", cientifico)

            -- Crear y mostrar texto
            pageText = crearTexto{texto="Cuando un personaje (como yo) se anime así, tócalo para continuar."}
            pageText.isVisible = false
            repositionAndFadeIn(pageText, 0.6, 0.3)

            completeTween()

        elseif animStep == 3 then

            -- Desaparecer texto anterior
            pageText.isVisible = false

            -- Eliminar receptores anteriores
            Runtime:removeEventListener("enterFrame", cientifico)
            cientifico:removeEventListener( "touch", continuarAnimacion )

            -- Crear y mostrar texto
            pageText = crearTexto{texto="Si encuentras una palabra "}
            pageText.isVisible = false

            animacionTexto = crearTexto{texto="así", tam=50}
            animacionTexto:setFillColor( 1, 0.2, 0.2 )
            animacionTexto.isVisible = false

            pageText2 = crearTexto{texto=" tócala para conocer su significado."}
            pageText2.isVisible = false

            repositionAndFadeIn(pageText, 0.40, 0.25)
            repositionAndFadeIn(animacionTexto, 0.85, 0.25)
            repositionAndFadeIn(pageText2, 0.80, 0.35)


            -- Parametros para posicionar la imagen del globo y la definicion de la palabra.
            -- De ser necesario, reposicionar el globo en cada palabra.
            animacionTexto.definicion, animacionTexto.globo = textoDefinicion, globoDiccionario
            animacionTexto.factorX, animacionTexto.factorY = 0.85, 0.15
            animacionTexto.globoActivo = false
            animacionTexto.touch = alternarDiccionario
            animacionTexto:addEventListener( "touch", animacionTexto )

            -- Variable para detectar cuando se toque la palabra
            diccionarioUsado = false

            completeTween()

        elseif animStep == 4 then

            -- Desaparecer texto anterior
            pageText.isVisible = false
            animacionTexto.isVisible = false
            pageText2.isVisible = false

            -- Eliminar receptores anteriores
            Runtime:removeEventListener("enterFrame", cientifico)
            cientifico:removeEventListener( "touch", continuarAnimacion )

            -- Crear y mostrar texto
            pageText = crearTexto{texto="Cuando veas esta animación, desliza tu dedo de derecha a izquierda en la pantalla"}
            pageText.isVisible = false
            repositionAndFadeIn(pageText, 0.6, 0.3)

            finger_left.isVisible = true

            handsTimer = timer.performWithDelay( 1000, move, -1 )

            fondo.touch = onPageSwipe
            fondo:addEventListener( "touch", fondo )

            completeTween()

        elseif animStep == 5 then

            -- Desaparecer texto anterior
            pageText.isVisible = false

            -- Eliminar receptores anteriores
            fondo.touch = nil
            fondo:removeEventListener( "touch", fondo )

            -- Terminar animación
            finger_left.isVisible = false
            timer.cancel( handsTimer )

            -- Crear y mostrar texto
            pageText = crearTexto{texto="Para acceder al menú, toca la pantalla durante varios segundos."}
            pageText.isVisible = false

            pageText2 = crearTexto{texto="Si quieres salir, toca nuevamente por varios segundos. Para esta guía estará deshabilitado.", ancho=500}
            pageText2.isVisible = false

            repositionAndFadeIn(pageText, 0.5, 0.2)
            repositionAndFadeIn(pageText2, 0.7, 0.7)

            -- Agregar receptores
            cientifico:addEventListener( "touch", continuarAnimacion )
            Runtime:addEventListener( "enterFrame", cientifico )

            completeTween()

        elseif animStep == 6 then

             -- Desaparecer texto anterior
            pageText.isVisible = false
            pageText2.isVisible = false

            -- Eliminar receptores anteriores
            Runtime:removeEventListener("enterFrame", cientifico)
            cientifico:removeEventListener( "touch", continuarAnimacion )
            
            pageText = crearTexto{texto="En el menú podrás ir a la portada, al índice, a este tutorial, o a la página que hayas marcado."}
            pageText.isVisible = false

            pageText2 = crearTexto{texto="Tócame para finalizar la guía, y comenzar el cuento.", ancho=500}
            pageText2.isVisible = false

            repositionAndFadeIn(pageText, 0.5, 0.2)
            repositionAndFadeIn(pageText2, 0.7, 0.7)

            transition.dissolve( cientifico, boton )

            boton:addEventListener( "touch", finalizarTutorial )

        end

    end
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

                if distance < swipeThresh then
                    -- deslizar a la izquierda, pagina siguiente
                    showNext()
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

    fondo = display.newImageRect( sceneGroup, "Tutorial/Sky.jpg", display.contentWidth, display.contentHeight )
    fondo.x, fondo.y = display.contentCenterX, display.contentCenterY

    cientifico = display.newImageRect( sceneGroup, "Tutorial/Scientist.png", display.contentWidth * 0.4, display.contentHeight*0.5)
    cientifico.x, cientifico.y = display.contentWidth*-0.25, display.contentHeight * 0.6
    cientifico.isVisible, cientifico.inf, cientifico.inflate, cientifico.rate = false, 0.05, true, 1

    globoDiccionario = display.newImageRect( sceneGroup, "Tutorial/globoDiccionario.png", display.contentWidth * 0.2, display.contentHeight * 0.2 )
    globoDiccionario.x, globoDiccionario.y = display.contentWidth * 0.85, display.contentHeight * 0.15
    globoDiccionario.alpha = 0

    textoDefinicion = crearTexto{ texto="En este globo estará el significado de la palabra", ancho=500 }
    textoDefinicion.isVisible = false

    finger_left = display.newImageRect( sceneGroup, "swipeIzq.png", 150, 150 )
    finger_left.x, finger_left.y = display.contentWidth * 0.9, display.contentHeight * 0.6
    finger_left.isVisible = false

    boton = display.newImageRect( sceneGroup, "Tutorial/boton.png", display.contentWidth * 0.4, display.contentHeight * 0.5 )
    boton.x, boton.y = display.contentWidth * 0.25, display.contentHeight * 0.6
    boton.alpha = 0

    sceneGroup:insert( textGroup )
    
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

        composer.removeScene( composer.getVariable( "paginaAnterior" ) )

        animStep = 1
        readyToContinue = true

        showNext()
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
    
        -- remove touch event listener for background
    
        -- cancel page animations (if currently active)
        if pageTween then transition.cancel( pageTween ); pageTween = nil; end
        if fadeTween1 then transition.cancel( fadeTween1 ); fadeTween1 = nil; end
        if fadeTween2 then transition.cancel( fadeTween2 ); fadeTween2 = nil; end

        composer.setVariable( "paginaAnterior", "Tutorial" )
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