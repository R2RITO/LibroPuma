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
        handsTimer


local continuarAnimacion, onPageSwipe

local swipeThresh = 100     -- amount of pixels finger must travel to initiate page swipe
local tweenTime = 900
local animStep = 1
local readyToContinue = false




local function animPuma()

   --Para animación Sprite de Puma
    seqData ={
        {name = "puma", start=1, count=4, time = 700, loopCount = 0}
    }

    data = {

            frames ={
            {name=puma1, x = 0, y = 398, width = 725, height = 398, sourceX=0, sourceY=0 },
            {name=puma2, x = 725, y = 0, width = 725, height = 398, sourceX=0, sourceY=0 },
            {name=puma3, x = 0, y = 398, width = 725, height = 398, sourceX=0, sourceY=0 },
            {name=puma4, x = 0, y = 0, width = 725, height = 398, sourceX=0, sourceY=0 },
        },
        sheetContentWidth = 1451,
        sheetContentHeight = 796,
        width=64, height=64,
    }

    sheet = graphics.newImageSheet("sprite1.png", data)
    sprite = display.newSprite(sheet, seqData)
    sprite.x = 244
    sprite.y = 400
    --sprite.x = display.contentHeight/2
    --sprite.y = display.contentWidth/2
    sprite.alpha=1

    sprite:setSequence("puma")
    sprite:play()

    --Como loopCount = 0 se reproduce infinitamente
    --Fin animación

    sprite.xScale = .5
    sprite.yScale = .5 
end

function scrollBackground(self, event)
    
--Para la montaña
    if(self.type==1) then
        if (self.x<-250) then
            self.x  = 1440
        else    
            self.x = self.x-self.speed
        end
    end
    -- Para el boque
    if(self.type==2) then
        if (self.x<-263) then
            self.x  = 1280
        else    
            self.x = self.x-self.speed
        end
    end

    if(self.type==3) then
        if (self.x<-495) then
            self.x  = 1260
        else    
            self.x = self.x-self.speed
        end
    end
end



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

-- function to show next animation
local function showNext()
    if readyToContinue then
        readyToContinue = false
        
        local function repositionAndFadeIn( factorX, factorY )
            pageText.x = display.contentWidth * factorX
            pageText.y = display.contentHeight * factorY

            pageText.isVisible = true
                    
            fadeTween1 = transition.to( pageText, { time=tweenTime*0.5, alpha=1.0 } )
        end
        
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

            
        elseif animStep == 2 then

           
            

        elseif animStep == 3 then
            

        elseif animStep == 4 then

          

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

    local sky = display.newImageRect( "Sky.jpg", 1021, 365 )
    sky.x = 511
    sky.y = 182


    local mountain1 = display.newImageRect( "BrownMontain1.png", 640, 480 )
    mountain1.type = 1
    mountain1.x = 1440
    mountain1.y = 150
    mountain1.speed = 2

    local mountain2 = display.newImageRect( "BrownMontain1.png", 640, 480 )
    mountain2.type = 1
    mountain2.x = 320
    mountain2.y = 150
    mountain2.speed = 2

    local mountain3 = display.newImageRect( "BrownMontain1.png", 640, 480 )
    mountain3.type = 1
    mountain3.x = 900
    mountain3.y = 150
    mountain3.speed = 2


    local grass = display.newImageRect( "Grass.png", 1024, 768 )
    grass.x = 512
    grass.y = 342
    grass.speed = 3
    grass.type = 3

    local grass1 = display.newImageRect( "Grass.png", 1024, 768 )
    grass1.x = 1500
    grass1.y = 342
    grass1.speed = 3
    grass1.type = 3

    local forest1 = display.newImageRect( "Forest.png", 500, 263 )
    forest1.type = 2
    forest1.x = 200
    forest1.y = 276
    forest1.speed = 3

    local forest4 = display.newImageRect( "Forest.png", 500, 263 )
    forest4.type = 2
    forest4.x = 1160
    forest4.y = 276
    forest4.speed = 3

    local forest3 = display.newImageRect( "Forest.png", 500, 263 )
    forest3.type = 2
    forest3.x = 878
    forest3.y = 276
    forest3.speed = 3

    local forest2 = display.newImageRect( "Forest.png", 500, 263 )
    forest2.type = 2
    forest2.x = 502
    forest2.y = 276
    forest2.speed = 3

    local forest5 = display.newImageRect( "Forest.png", 500, 263 )
    forest5.type = 2
    forest5.x = 1536
    forest5.y = 276
    forest5.speed = 3


    --create marker object
    markerObj = display.newImageRect( sceneGroup, "Marcador.png", 80, 120 )
    markerObj.x, markerObj.y = 40, 60
    markerObj.isVisible = false
    markerObj.alpha = 0.2

    --animBack()

    --Animación pasto
    grass.enterFrame = scrollBackground
    Runtime:addEventListener("enterFrame",grass)
    grass1.enterFrame = scrollBackground
    Runtime:addEventListener("enterFrame",grass1)

    --Animación bosque
    forest1.enterFrame = scrollBackground
    Runtime:addEventListener("enterFrame",forest1)
    forest2.enterFrame = scrollBackground
    Runtime:addEventListener("enterFrame",forest2)
    forest3.enterFrame = scrollBackground
    Runtime:addEventListener("enterFrame",forest3)
    forest4.enterFrame = scrollBackground
    Runtime:addEventListener("enterFrame",forest4)
    forest5.enterFrame = scrollBackground
    Runtime:addEventListener("enterFrame",forest5)

    --Animación Montaña

    mountain1.enterFrame = scrollBackground
    Runtime:addEventListener("enterFrame",mountain1)
    mountain2.enterFrame = scrollBackground
    Runtime:addEventListener("enterFrame",mountain2)
    mountain3.enterFrame = scrollBackground
    Runtime:addEventListener("enterFrame",mountain3)
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
        
        -- hide objects
        pageText.isVisible = false
        markerObj.isVisible = false
        hojas.isVisible = false
        bosque.isVisible = false
        cientifico.isVisible = false
        retratoPuma.isVisible = false
        ninos.isVisible = false
    
        -- remove touch event listener for background
        pasto:removeEventListener( "touch", background )
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
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene