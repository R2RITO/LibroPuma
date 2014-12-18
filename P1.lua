-----------------------------------------------------------------------------------------
--
-- page1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")



-- forward declarations and other locals
local cielo, pasto, cientifico, nube, hojas, bosque, pageText,
        pageTween, fadeTween1, fadeTween2, markerObj, retratoPuma,
        ninos, pumaReal, marcoJungla, botonVolver, finger_left,
        handsTimer,arbol, tiempoInicio, square


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

local function start(value1,value2,value3)
--La indentación del código es una buena práctica para facilitar la lectura de éste. CARLOS
rate=value1
max=value2
drate=value3
end

start(1,0.05,0.005)

local function crearTexto( args )

    local textOption = 
        {           
            parent = textGroup,
            text = args.texto,     
            width = args.ancho or display.contentWidth*0.90,     --required for multi-line and alignment
            font = args.fuente or PTSERIF1,   
            fontSize = args.tam or 32,
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

            pageText = crearTexto{texto="Érase una vez, un grupo de niños que fueron de expedición a la Cordillera de los Andes."}
            pageText.isVisible = false
            pageText:setFillColor( 0, 0, 0 ) -- color negro
            repositionAndFadeIn( pageText,0.55,0.10 )

            transition.to( arbol, { time=tweenTime*1.5, alpha=1.0 } )
            transition.to( ninos, { time=tweenTime*0.5, alpha=1.0, delay=1000 } )

            ninos.isVisible = true  
           
            ninos.enterFrame = inflate
            Runtime:addEventListener("enterFrame", ninos)

            ninos:addEventListener( "touch", continuarAnimacion )
            completeTween()


        elseif animStep == 2 then

            pageText:removeSelf()

            -- Eliminar funciones anteriores
            ninos:removeEventListener( "touch", continuarAnimacion )
            Runtime:removeEventListener("enterFrame",ninos)
            
            cientifico.isVisible = true  
            ninos.isVisible = false
            transition.to( cientifico, { time=tweenTime, x=display.contentWidth*0.25 ,transition=easing.outExpo } )

            pageText = crearTexto{texto="¡Hola! Hoy podrás acompañarnos en esta aventura. Recorreremos el bosque y es muy posible que nos encontremos con un puma ", tam=30}
            pageText:setFillColor( 0, 0, 0 ) -- color negro
            pageText.isVisible = false
            repositionAndFadeIn(pageText,0.55,0.10)

           
            cientifico.enterFrame = inflate
            Runtime:addEventListener("enterFrame", cientifico)
            cientifico:addEventListener( "touch", continuarAnimacion )
            completeTween()
            

        elseif animStep == 3 then
             pageText:removeSelf()

             -- Eliminar funciones anteriores
            cientifico:removeEventListener( "touch", continuarAnimacion )
            Runtime:removeEventListener("enterFrame",cientifico)

            cientifico2.isVisible = true  
            cientifico.isVisible = false
            transition.to( cientifico2, { time=tweenTime, x=display.contentWidth*0.25 ,transition=easing.outExpo } )

            pageText.alpha = 0

            pageText = crearTexto{texto="Por si no lo conoces, aquí te muestro una foto"}
            pageText:setFillColor( 0, 0, 0 ) -- color negro
            pageText.isVisible = false
            repositionAndFadeIn(pageText,0.50,0.10)


            retratoPuma.isVisible = true
            retratoPuma:toFront( )
            transition.to( retratoPuma, { time=tweenTime, x=display.contentWidth*0.345 ,transition=easing.outExpo } )



            retratoPuma.enterFrame = inflate
            Runtime:addEventListener("enterFrame", retratoPuma)
            retratoPuma:addEventListener( "touch", continuarAnimacion )
            completeTween()

        elseif animStep == 4 then
            pageText:removeSelf()
        -- Eliminar funciones anteriores
            retratoPuma:removeEventListener( "touch", continuarAnimacion )
            Runtime:removeEventListener("enterFrame",retratoPuma)


            square.isVisible=true
            botonVolver.isVisible=true

            transition.to( retratoPuma, { time=tweenTime*3, width= display.contentWidth*0.4,height= display.contentHeight*0.7, x=display.contentCenterX, rotation=0,transition=easing.outExpo } )
            transition.to( square, { time=tweenTime*3, x=display.contentCenterX,  width= display.contentWidth,height= display.contentHeight, rotation=0,transition=easing.outExpo } )
            transition.to( botonVolver, { time=tweenTime, delay=1000,x=display.contentWidth*0.9,alpha=1, transition=easing.outExpo } )


            botonVolver.enterFrame = inflate
            Runtime:addEventListener("enterFrame", botonVolver)
            botonVolver:addEventListener( "touch", continuarAnimacion )
            completeTween()

        elseif animStep == 5 then
           
        -- Eliminar funciones anteriores
            botonVolver:removeEventListener( "touch", continuarAnimacion )
            Runtime:removeEventListener("enterFrame", botonVolver)

            square.isVisible=false
            botonVolver.isVisible=false
            retratoPuma.isVisible=false

            pageText.alpha = 0

            cientifico.isVisible = true  
            cientifico2.isVisible = false
            transition.to( cientifico, { time=tweenTime*1.5, x=display.contentWidth*0.4 ,transition=easing.outExpo } )


            pageText = crearTexto{texto="¡Continuemos nuestro viaje!"}
            pageText:setFillColor( 0, 0, 0 ) -- color negro
            pageText.isVisible = false
            repositionAndFadeIn(pageText,0.50,0.10)

            botonVolver:removeEventListener( "touch", continuarAnimacion )
              
            background2.touch = onPageSwipe
            background2:addEventListener( "touch", pasto )

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
                    pageText.isVisible=false
                else
                    -- deslizar a la izquierda, pagina siguiente
                    composer.gotoScene( pag, "slideLeft", 800 )
                    pageText.isVisible=false
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

    --Tal vez sería  recomendable cargar esta imagen como variable local. CARLOS 
    background = display.newImageRect( sceneGroup, "Pagina1/capa_2.png", display.contentWidth+display.contentWidth/10, display.contentHeight*0.84)
    background.anchorX,background.anchorY=0,0 --el punto de referencia (0,0) de la imagen es el de la izquierda y arriba
    background.x, background.y = -display.contentWidth*0.02, display.contentHeight*0.14
    background.isVisible = true
    
    --Tal vez sería  recomendable cargar esta imagen como variable local. CARLOS 
    background2 = display.newImageRect( sceneGroup, "Pagina1/capa_2_1.png", display.contentWidth+display.contentWidth/10, display.contentHeight*0.84)
    background2.anchorX,background2.anchorY=0,1 --el punto de referencia (0,0) de la imagen es el de la izquierda y abajo
    background2.x, background2.y = -display.contentWidth*0.1,display.contentHeight
    background2.isVisible = true
    
    nube = display.newImageRect( sceneGroup, "Pagina1/nubes.png", display.contentWidth*0.8, display.contentHeight*0.1 )
    nube.x, nube.y = display.contentWidth * 0.8, display.contentHeight * 0.2

    --Tal vez sería  recomendable cargar esta imagen como variable local. CARLOS 
    backWhite = display.newImageRect( sceneGroup, "Portada/BackgroundWhite.jpg", display.contentWidth, display.contentHeight*0.2)
    backWhite.anchorX,backWhite.anchorY=0,0 --el punto de referencia (0,0) de la imagen es el de la izquierda y arriba
    backWhite.x, backWhite.y = 0, 0
    backWhite.isVisible = true
  
    
    arbol = display.newImageRect( sceneGroup, "Pagina1/arbol_2.png", display.contentWidth*0.4, display.contentHeight*0.7)
    arbol.anchorX,arbol.anchorY=0,1 --el punto de referencia (0,0) de la imagen es el de la izquierda y abajo
    arbol.x, arbol.y = display.contentWidth*0.6,display.contentHeight*0.9
    arbol.isVisible = true
    arbol.alpha=0

    hojas = display.newImageRect( sceneGroup, "Pagina1/Hojas2.png", display.contentWidth * 0.45, display.contentHeight * 0.65 )
    hojas.x, hojas.y = display.contentWidth * -2, display.contentHeight * 0.7
    hojas.isVisible = false

    bosque = display.newImageRect( sceneGroup, "Pagina1/Forest.png", display.contentWidth * 0.6, display.contentHeight * 0.4 )
    bosque.x, bosque.y = display.contentWidth * -2, display.contentHeight * 0.3
    bosque.isVisible = false

    cientifico = display.newImageRect( sceneGroup, "Pagina1/explorador.png",   display.contentWidth * 0.15, display.contentHeight*0.6)
    cientifico.x, cientifico.y = display.contentWidth * 0.3, display.contentHeight * 0.6
    cientifico.isVisible, cientifico.maximoinflado, cientifico.inflar, cientifico.cuaninflado = false, 0.05, true, 1

    cientifico2 = display.newImageRect( sceneGroup, "Pagina1/explorador_2.png",   display.contentWidth * 0.25, display.contentHeight*0.6)
    cientifico2.x, cientifico2.y = display.contentWidth * 0.3, display.contentHeight * 0.6
    cientifico2.isVisible, cientifico2.maximoinflado, cientifico.inflar, cientifico.cuaninflado = false, 0.05, true, 1


    retratoPuma = display.newImageRect( sceneGroup, "Pagina1/puma_sentado_1.png", display.contentWidth * 0.03, display.contentHeight * 0.07 )
    retratoPuma.x, retratoPuma.y = display.contentWidth * 0.4, display.contentHeight * 0.55
    retratoPuma.rotation= -10
    retratoPuma.isVisible = false
    retratoPuma.isVisible, retratoPuma.maximoinflado, retratoPuma.inflar, retratoPuma.cuaninflado = false, 0.05, true, 1

    -- pumaReal = display.newImageRect( sceneGroup, "Pagina1/puma_sentado_1.png", display.contentWidth, display.contentHeight )
    -- pumaReal.x, pumaReal.y = -display.contentCenterX, display.contentCenterY
    -- pumaReal.isVisible = false

    marcoJungla = display.newImageRect( sceneGroup, "Pagina1/JungleFrame.png", display.contentWidth * 1.3, display.contentHeight * 1.3 )
    marcoJungla.x, marcoJungla.y = display.contentCenterX * 4, display.contentCenterY
    marcoJungla.isVisible = false

    square = display.newRect(sceneGroup, display.contentWidth * 0.345, display.contentHeight * 0.55, display.contentWidth*0.05, display.contentHeight *0.07)
    square:setFillColor(1,1,1)
    square.isVisible,square.rotation=false,-10


    botonVolver = display.newImageRect( sceneGroup, "Pagina1/botonVolver.png", display.contentWidth * 0.15, display.contentHeight * 0.2 )
    botonVolver.x, botonVolver.y = display.contentWidth * 0.8, display.contentHeight * 0.85
    botonVolver.isVisible, botonVolver.alpha = true, 0
    botonVolver.isVisible, botonVolver.maximoinflado, botonVolver.inflar, botonVolver.cuaninflado = false, 0.05, true, 1

    ninos = display.newImageRect( sceneGroup, "Pagina1/ninios.png", display.contentWidth * 0.4, display.contentHeight * 0.4 )
    ninos.x, ninos.y = display.contentWidth * 0.3, display.contentHeight * 0.7
    ninos.isVisible, ninos.maximoinflado, ninos.inflar, ninos.cuaninflado = false, 0.05, true, 1
    ninos.alpha=0

    finger_left = display.newImageRect( sceneGroup, "swipeIzq.png", 150, 150 )
    finger_left.x, finger_left.y = display.contentWidth * 0.9, display.contentHeight * 0.5
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

        sceneGroup:insert(textGroup)

        composer.removeScene( composer.getVariable( "paginaAnterior" ) )

        animStep = 1
        readyToContinue = true
        Runtime:addEventListener( "touch", onPageTouch )

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
        
        -- hide objects
        -- pageText.isVisible = false
        -- markerObj.isVisible = false
        -- hojas.isVisible = false
        -- bosque.isVisible = false
        -- cientifico.isVisible = false
        -- retratoPuma.isVisible = false
        -- ninos.isVisible = false
    
        -- remove touch event listener for background
        --pasto:removeEventListener( "touch", background )
        markerObj:removeEventListener( "touch", activarMarcador )
    
        -- cancel page animations (if currently active)
        if pageTween then transition.cancel( pageTween ); pageTween = nil; end
        if fadeTween1 then transition.cancel( fadeTween1 ); fadeTween1 = nil; end
        if fadeTween2 then transition.cancel( fadeTween2 ); fadeTween2 = nil; end

        composer.setVariable( "paginaAnterior", "P1" )
        timer.cancel( handsTimer ); handsTimer = nil;
        
    elseif phase == "did" then

        hojas.x, hojas.y = display.contentWidth * -2, display.contentHeight * 0.7
        bosque.x, bosque.y = display.contentWidth * -2, display.contentHeight * 0.3
        retratoPuma.alpha = 0

        -- Called when the scene is now off screen
    end     

end

function scene:destroy( event )
    local sceneGroup = self.view
    
    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc.

    --!!!! Es recomendable usar el object:removeself() y object=nil para liberar memoria en el dispositivo. CARLOS
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene