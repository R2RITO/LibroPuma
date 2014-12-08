-----------------------------------------------------------------------------------------
--
-- page1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")



-- forward declarations and other locals
local pageTween, fadeTween1, fadeTween
local textoP1, textoP2, textoP3, textoP4, textoP5, textoP6, textoP7, textoP8,
      fondoP1, fondoP2, fondoP3, fondoP4, fondoP5, fondoP6, fondoP7, fondoP8,
      fondo, titulo

local textGroup = display.newGroup()

local onPageSwipe

local swipeThresh = 100     -- amount of pixels finger must travel to initiate page swipe
local tweenTime = 900

local function crearTexto( args )

    local textOption = 
        {           
            parent = textGroup,
            text = args.texto,     
            width = args.ancho or 500,     --required for multi-line and alignment
            font = args.fuente or "Austie Bost Kitten Klub",   
            fontSize = args.tam or 40,
            align = "center"  --new alignment parameter
    
        }

    return display.newText(textOption)
end


local function repositionAndFadeIn( texto, factorX, factorY )
    texto.x = display.contentWidth * factorX
    texto.y = display.contentHeight * factorY

    texto.isVisible = true
            
    fadeTween1 = transition.to( texto, { time=tweenTime*0.5, alpha=1.0 } )
end

-- Funcion para ir a la pagina seleccionada
local function cambiarPagina( self , event )

    local phase = event.phase
    if phase == "ended" or phase == "cancelled" then
        pag = "P" .. self.pag
        composer.setVariable( "pagina", self.pag )
        composer.gotoScene( pag, "slideLeft", 800 )

    end

    return true
end

-- Funcion para aumentar o disminuir el tamaño de las imagenes de muestra
local function zoomVistaPrevia( self, event )

    local phase = event.phase
    if phase == "ended" or phase == "cancelled" then
        if self.activo then
            transition.scaleTo( self, { xScale = 0.12, yScale = 0.12 } )
            self.activo = false
        else
            self:toFront()
            transition.scaleTo( self, { xScale = 1, yScale = 1 } )
            self.activo = true
        end

    end

    return true

end

-- Funcion para crear el texto y la imagen de muestra de una pagina
local function crearElementoIndice( textoPag, ruta, factorY, pag, sceneGroup)

    local textoFinal = crearTexto{texto=textoPag}
    repositionAndFadeIn(textoFinal, 0.4, factorY)

    local fondoFinal = display.newImageRect( sceneGroup, ruta, display.contentWidth * 0.7, display.contentHeight * 0.7 )
    fondoFinal.x, fondoFinal.y = (display.contentWidth * 0.1) - 40, (display.contentHeight * factorY) - (64 * (0.5 - factorY))
    fondoFinal.xScale, fondoFinal.yScale = 0.12, 0.12
    fondoFinal.anchorX, fondoFinal.anchorY = 0, factorY
    fondoFinal.activo, fondoFinal.factorY = false, factorY

    textoFinal.pag = pag
    textoFinal.touch = cambiarPagina
    textoFinal:addEventListener( "touch", textoFinal )

    fondoFinal.touch = zoomVistaPrevia
    fondoFinal:addEventListener( "touch", fondoFinal )

    return textoFinal, fondoFinal

end

function scene:create( event )
    local sceneGroup = self.view

    -- Called when the scene's view does not exist.
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
    
    -- Fondo

    fondo = display.newImageRect( sceneGroup, "Indice/fondo.jpg", display.contentWidth, display.contentHeight )
    fondo.x, fondo.y = display.contentCenterX, display.contentCenterY 

    titulo = crearTexto{texto="Índice", tam=50}
    repositionAndFadeIn(titulo, 0.5, 0.1)

    -- Texto e imagen de cada página
    sceneGroup:insert(textGroup)

    textoP1, fondoP1 = crearElementoIndice("Introducción","Indice/pag1.png", 0.2, 1, sceneGroup)
    textoP2, fondoP2 = crearElementoIndice("Juego de reconocimiento", "Indice/pag1.png", 0.3, 2, sceneGroup)
    textoP3, fondoP3 = crearElementoIndice("Nombre científico", "Indice/pag1.png", 0.4, 3, sceneGroup)
    textoP4, fondoP4 = crearElementoIndice("Tamaño y peso","Indice/pag1.png", 0.5, 4, sceneGroup)
    textoP5, fondoP5 = crearElementoIndice("Dieta", "Indice/pag1.png", 0.6, 5, sceneGroup)
    textoP6, fondoP6 = crearElementoIndice("Juego acerca de la dieta", "Indice/pag1.png", 0.7, 6, sceneGroup)
    textoP7, fondoP7 = crearElementoIndice("Reproducción","Indice/pag1.png", 0.8, 7, sceneGroup)
    textoP8, fondoP8 = crearElementoIndice("Protección", "Indice/pag1.png", 0.9, 8, sceneGroup)

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
        composer.setVariable( "paginaAnterior", "Indice" )
    
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