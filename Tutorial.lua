-----------------------------------------------------------------------------------------
--
-- page1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")



-- forward declarations and other locals
local fadeTween1, finger_left, handsTimer,
      cientifico, animacionTexto, globoDiccionario,
      textoDefinicion, fondo1, fondo2, diccionarioUsado, textoIndicador, boton


local continuarAnimacion, onPageSwipe

local textGroup = display.newGroup()

local swipeThresh = 100     -- amount of pixels finger must travel to initiate page swipe
local tweenTime = 900
local animStep = 1
local readyToContinue = false

-- Funciones para animaciones

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

            fadeTween1 = transition.fadeOut( self.definicion, { time=500 } )
            self.globoActivo = false

            if not diccionarioUsado then
                Runtime:addEventListener("enterFrame", cientifico)
                cientifico:addEventListener("touch", continuarAnimacion)
                diccionarioUsado = true
            end

        else
            self.definicion.isVisible = true
            fadeTween1 = transition.fadeIn( self.definicion, { time=500 } )
            self.globoActivo = true

            if not diccionarioUsado then
                globo4.isVisible = true
                fadeTween2 = transition.fadeIn( globo4, { time=500 } )
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

            completeTween()

        elseif animStep == 2 then

            cientifico.enterFrame = inflate
            Runtime:addEventListener("enterFrame", cientifico)

            -- Crear y mostrar texto
            fadeTween1 = transition.dissolve( globo1, globo2, 500, 0 )

            completeTween()

        elseif animStep == 3 then

            -- Eliminar receptores anteriores
            Runtime:removeEventListener("enterFrame", cientifico)
            cientifico:removeEventListener( "touch", continuarAnimacion )

            -- Crear y mostrar texto
            fadeTween1 = transition.dissolve( globo2, globo3, 500, 0 )

            -- Parametros para posicionar la imagen del globo y la definicion de la palabra.
            -- De ser necesario, reposicionar el globo en cada palabra.
            -- RECORDAR QUE NO ES GLOBO 3 EL QUE LLEVA ESTO SINO LA PALABRA
            globo3.definicion = globoSignificado
            globo3.globoActivo = false
            globo3.touch = alternarDiccionario
            globo3:addEventListener( "touch", globo3 )

            -- Variable para detectar cuando se toque la palabra
            diccionarioUsado = false

            completeTween()

        elseif animStep == 4 then

            -- Eliminar receptores anteriores
            Runtime:removeEventListener("enterFrame", cientifico)
            cientifico:removeEventListener( "touch", continuarAnimacion )

            -- Mostrar el nuevo globo
            fadeTween1 = transition.fadeOut( globo4, {time=200} )
            fadeTween1 = transition.dissolve( globo3, globo5, 500, 0 )

            -- Mostrar animación de la mano
            finger_left.isVisible = true

            handsTimer = timer.performWithDelay( 1000, move, -1 )

            fondo1.touch = onPageSwipe
            fondo1:addEventListener( "touch", fondo1 )

            completeTween()

        elseif animStep == 5 then

            -- Eliminar receptores anteriores
            fondo1.touch = nil
            fondo1:removeEventListener( "touch", fondo1 )

            -- Terminar animación
            finger_left.isVisible = false
            timer.cancel( handsTimer )

            -- Mostrar el nuevo globo
            fadeTween1 = transition.dissolve( globo5, globo6, 500, 0 )
            fadeTween2 = transition.fadeIn( manoMenu, {time=300} )

            -- Agregar receptores
            cientifico:addEventListener( "touch", continuarAnimacion )
            Runtime:addEventListener( "enterFrame", cientifico )

            completeTween()

        elseif animStep == 6 then

            -- Eliminar receptores anteriores
            Runtime:removeEventListener("enterFrame", cientifico)
            cientifico:removeEventListener( "touch", continuarAnimacion )
            
            -- Mostrar los nuevos globos
            fadeTween2 = transition.fadeOut( manoMenu, {time=300} )
            fadeTween1 = transition.dissolve( fondo1, fondo2, 500, 0 )
            fadeTween2 = transition.dissolve( globo6, globo7, 500, 0 )            
            fadeTween1 = transition.dissolve( cientifico, boton )


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

    fondo1 = display.newImageRect( sceneGroup, "Tutorial/fondo1.png", display.contentWidth, display.contentHeight )
    fondo1.x, fondo1.y = display.contentCenterX, display.contentCenterY

    fondo2 = display.newImageRect( sceneGroup, "Tutorial/fondo2.png", display.contentWidth, display.contentHeight )
    fondo2.x, fondo2.y = display.contentCenterX, display.contentCenterY
    fondo2.isVisible = false

    cientifico = display.newImageRect( sceneGroup, "Tutorial/cientifico.png", display.contentWidth * 0.15, display.contentHeight*0.6)
    cientifico.x, cientifico.y = display.contentWidth*-0.25, display.contentHeight * 0.6
    cientifico.isVisible, cientifico.maximoinflado, cientifico.inflar, cientifico.cuaninflado = false, 0.05, true, 1

    globoDiccionario = display.newImageRect( sceneGroup, "Tutorial/globoDiccionario.png", display.contentWidth * 0.2, display.contentHeight * 0.2 )
    globoDiccionario.x, globoDiccionario.y = display.contentWidth * 0.85, display.contentHeight * 0.15
    globoDiccionario.alpha = 0

    textoDefinicion = crearTexto{ texto="En este globo estará el significado de la palabra", ancho=500 }
    textoDefinicion.isVisible = false

    -- Seccion de globos de texto
    globo1 = display.newImageRect( sceneGroup, "Tutorial/globo_1.png", display.contentWidth * 0.5, display.contentHeight*0.3)
    globo1.x, globo1.y = display.contentWidth*0.55, display.contentHeight * 0.3

    globo2 = display.newImageRect( sceneGroup, "Tutorial/globo_2.png", display.contentWidth * 0.5, display.contentHeight*0.3)
    globo2.x, globo2.y = display.contentWidth*0.55, display.contentHeight * 0.3
    globo2.isVisible = false

    globo3 = display.newImageRect( sceneGroup, "Tutorial/globo_3.png", display.contentWidth * 0.5, display.contentHeight*0.3)
    globo3.x, globo3.y = display.contentWidth*0.55, display.contentHeight * 0.23
    globo3.isVisible = false

    globo4 = display.newImageRect( sceneGroup, "Tutorial/globo_4.png", display.contentWidth * 0.5, display.contentHeight*0.3)
    globo4.x, globo4.y = display.contentWidth*0.55, display.contentHeight * 0.7
    globo4.isVisible = false

    globo5 = display.newImageRect( sceneGroup, "Tutorial/globo_5.png", display.contentWidth * 0.5, display.contentHeight*0.3)
    globo5.x, globo5.y = display.contentWidth*0.55, display.contentHeight * 0.3
    globo5.isVisible = false

    globo6 = display.newImageRect( sceneGroup, "Tutorial/globo_6.png", display.contentWidth * 0.5, display.contentHeight*0.3)
    globo6.x, globo6.y = display.contentWidth*0.55, display.contentHeight * 0.3
    globo6.isVisible = false

    globo7 = display.newImageRect( sceneGroup, "Tutorial/globo_7.png", display.contentWidth * 0.5, display.contentHeight*0.3)
    globo7.x, globo7.y = display.contentWidth*0.3, display.contentHeight * 0.55
    globo7.isVisible = false

    globoSignificado = display.newImageRect( sceneGroup, "Tutorial/globo_significado.png", display.contentWidth * 0.4, display.contentHeight*0.2)
    globoSignificado.x, globoSignificado.y = display.contentWidth*0.8, display.contentHeight * 0.45
    globoSignificado.isVisible = false

    -- Mano para indicar
    manoMenu = display.newImageRect( sceneGroup, "Tutorial/manoMenu.png", display.contentWidth * 0.08, display.contentHeight*0.2)
    manoMenu.x, manoMenu.y = display.contentWidth*0.55, display.contentHeight * 0.6
    manoMenu.alpha = 0


    finger_left = display.newImageRect( sceneGroup, "swipeIzq.png", 150, 150 )
    finger_left.x, finger_left.y = display.contentWidth * 0.9, display.contentHeight * 0.6
    finger_left.isVisible = false

    boton = display.newImageRect( sceneGroup, "Tutorial/boton.png", display.contentWidth * 0.13, display.contentHeight * 0.2 )
    boton.x, boton.y = display.contentWidth * 0.6, display.contentHeight * 0.65
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