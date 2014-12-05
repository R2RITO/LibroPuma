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
      textoCarnivoro


local continuarAnimacion, onPageSwipe

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
            --parent = textGroup,
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

            fadeTween1 = transition.to( self.globo, {
                                                y=display.contentWidth * self.factorYReverso, 
                                                onComplete=
                                                desvanecerTexto(self.definicion)
                                                    } 
                                      )
            self.globoActivo = false

        else
            self.globo.isVisible = true
            fadeTween1 = transition.to( self.globo, {
                                                y=display.contentWidth * self.factorY, 
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
            if animStep > 4 then animStep = 1; end
            
            readyToContinue = true
        end

        local function desaparecer( self )
            self.isVisible = false
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

            pageText.alpha = 0
            animacionTexto.alpha = 0
            pageText2.alpha = 0

            cientifico.isVisible = true
            fadeTween1 = transition.to( cientifico, { time=tweenTime, x=display.contentWidth*0.25 ,transition=easing.outExpo } )

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
            animacionTexto.definicion, animacionTexto.globo = textoCarnivoro, globoDiccionario
            animacionTexto.factorX, animacionTexto.factorY = 0.85, 0.15
            animacionTexto.factorXReverso, animacionTexto.factorYReverso = 0.85, -0.2
            animacionTexto.touch = alternarDiccionario
            animacionTexto:addEventListener( "touch", animacionTexto )

            completeTween()


        elseif animStep == 2 then

            pageText.alpha = 0

            -- Eliminar funciones anteriores
            
            cientifico.isVisible = true  
            ninos.isVisible = false
            transition.to( cientifico, { time=tweenTime, x=display.contentWidth*0.25 ,transition=easing.outExpo } )

            local textOption = 
                {           
                    --parent = textGroup,
                    text = "¡Hola! Hoy podrás acompañarnos en esta aventura. Recorreremos el bosque y es muy posible que nos encontremos con un puma ",     
                    width = 500,     --required for multi-line and alignment
                    font = "Austie Bost Kitten Klub",   
                    fontSize = 40,
                    align = "center"  --new alignment parameter
            
                }

            pageText= display.newText(textOption)
            pageText.isVisible = false
            --repositionAndFadeIn(0.50,0.25)

           
            cientifico.enterFrame = inflate
            Runtime:addEventListener("enterFrame", cientifico)
            cientifico:addEventListener( "touch", continuarAnimacion )
            completeTween()
            

        elseif animStep == 3 then
            

            -- Eliminar funciones anteriores
            cientifico:removeEventListener( "touch", continuarAnimacion )
            Runtime:removeEventListener("enterFrame",cientifico)

            pageText.alpha = 0

            local textOption = 
                {           
                    --parent = textGroup,
                    text = "Por si no lo conoces, aquí te muestro una foto",     
                    width = 500,     --required for multi-line and alignment
                    font = "Austie Bost Kitten Klub",   
                    fontSize = 40,
                    align = "center"  --new alignment parameter
            
                }

            pageText= display.newText(textOption)
            pageText.isVisible = false
            --repositionAndFadeIn(0.50,0.25)


            pumaReal.isVisible = true
            pumaReal:toFront( )
            marcoJungla.isVisible = true
            marcoJungla:toFront( )
            botonVolver.isVisible = true
            botonVolver:toFront( )

            transition.to( pumaReal, { time=tweenTime, x=display.contentCenterX, transition=easing.outExpo } )
            transition.to( marcoJungla, { time=tweenTime, x=display.contentCenterX, transition=easing.outExpo } )
            transition.to( botonVolver, { time=tweenTime, x=display.contentWidth * 0.9, transition=easing.outExpo } )


            botonVolver.enterFrame = inflate
            Runtime:addEventListener("enterFrame", botonVolver)
            botonVolver:addEventListener( "touch", continuarAnimacion )
            completeTween()

        elseif animStep == 4 then

            pageText.alpha = 0

            transition.to( pumaReal, { time=tweenTime, x=-display.contentCenterX, transition=easing.outExpo } )
            transition.to( marcoJungla, { time=tweenTime, x=display.contentCenterX*4, transition=easing.outExpo } )
            transition.to( botonVolver, { time=tweenTime, x=display.contentWidth * -0.9, transition=easing.outExpo } )

            local textOption = 
                {           
                    --parent = textGroup,
                    text = "¡Continuemos nuestro viaje!",     
                    width = 500,     --required for multi-line and alignment
                    font = "Austie Bost Kitten Klub",   
                    fontSize = 40,
                    align = "center"  --new alignment parameter
            
                }

            pageText= display.newText(textOption)
            pageText.isVisible = false
            --repositionAndFadeIn(0.50,0.25)

            botonVolver:removeEventListener( "touch", continuarAnimacion )
            
            pasto.touch = onPageSwipe
            pasto:addEventListener( "touch", pasto )

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

    cientifico = display.newImageRect( sceneGroup, "Pagina4/Scientist.png", display.contentWidth * 0.4, display.contentHeight*0.5)
    cientifico.x, cientifico.y = display.contentWidth*-0.25, display.contentHeight * 0.6
    cientifico.isVisible, cientifico.inf, cientifico.inflate, cientifico.rate = false, 0.05, true, 1

    -- create pageText
    pageText = display.newText( sceneGroup, "", 0, 0, native.systemFontBold, 18 )
    pageText.isVisible = false

    animacionTexto = display.newText( sceneGroup, "", 0, 0, native.systemFontBold, 18 )
    animacionTexto.isVisible, animacionTexto.globoActivo = false, false

    pageText2 = display.newText( sceneGroup, "", 0, 0, native.systemFontBold, 18 )
    pageText2.isVisible = false

    globoDiccionario = display.newImageRect( sceneGroup, "Pagina4/globoDiccionario.png", display.contentWidth * 0.2, display.contentHeight * 0.2 )
    globoDiccionario.x, globoDiccionario.y = display.contentWidth * 0.85, display.contentHeight * -0.35
    globoDiccionario.isVisible = false

    textoCarnivoro = crearTexto{ texto="Carnívoro: que se alimenta de carne", ancho=500 }
    textoCarnivoro.isVisible = false



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