---------------------------------------------------------------------------------
--
-- game.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local physics = require("physics")
local widget = require( "widget" )
local tools= require("tools")

physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local image, menuVisible, cajas, terminos, seleccion, count1, arreglo, gano, collisionCounter, collisionCounter, palabrasRestantes, numeroPalabras, posInicialX, posInicialY

-- Touch event listener for background image
local function onSceneTouch( self, event )
	if event.phase == "began" then
		
		composer.gotoScene( "scene2", "slideLeft", 800  )
		
		return true
	end
end

local function onSwipe(e)
    if(e.phase=="began") then
        x1=e.x
        y1=e.y
        print("X1 : "..x1.."  Y1 : "..y1)
    elseif(e.phase=="ended") then
        x2=e.x
        y2=e.y
        print("X2 : "..x2.."  Y2 : "..y2)
        restaX=x1-x2
        valorAbsoluto = math.abs(restaX)

        if(restaX>0 and valorAbsoluto>60) then
            print("RIGHT")
            composer.gotoScene( "scene2", "slideLeft", 400 )
        elseif(restaX<0 and valorAbsoluto>60) then
            print("LEFT")
            --composer.gotoScene( "scene1", "slideRight", 400 )
        else
        	print("TAP")
        	if(menuVisible) then
        		composer.hideOverlay( "slideDown", 400)
 
        		menuVisible = false
        	else
				composer.showOverlay( "floating_menu", {effect="slideUp",time=400,params={ hide="left"}} )

        		menuVisible = true
        	end	
        end

    end
end

-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view

	menuVisible=false

	numeroPalabras = 6
    palabrasRestantes = 0

    cajas = display.newGroup()

	image = display.newImage( "Juego/game.png" )
	image.x = display.contentCenterX
	image.y = display.contentCenterY
	image.width = display.contentWidth
	image.height = display.contentHeight
	
	sceneGroup:insert( image )
	
	--image:addEventListener( "touch", onSwipe )

	terminos = {}

    terminos[1] = {}
    terminos[1].indice = 1
    terminos[1].columna1 = "Puma"
    terminos[1].columna2 = "Puma"
    terminos[1].ruta = "Juego/puma.png"
    terminos[2] = {}
    terminos[2].indice = 2
    terminos[2].columna1 = "Ratón"
    terminos[2].columna2 = "Ratón"
    terminos[2].ruta = "Juego/raton.png"
    terminos[3] = {}
    terminos[3].indice = 3
    terminos[3].columna1 = "Guanaco"
    terminos[3].columna2 = "Guanaco"
    terminos[3].ruta = "Juego/guanaco.png"
    terminos[4] = {}
    terminos[4].indice = 4
    terminos[4].columna1 = "Gato"
    terminos[4].columna2 = "Gato"
    terminos[4].ruta = "Juego/gato.png"
    terminos[5] = {}
    terminos[5].indice = 5
    terminos[5].columna1 = "Perro"
    terminos[5].columna2 = "Perro"
    terminos[5].ruta = "Juego/perro.png"
    terminos[6] = {}
    terminos[6].indice = 6
    terminos[6].columna1 = "Cordillera"
    terminos[6].columna2 = "Cordillera"
    terminos[6].ruta = "Juego/cordillera.png"

    palabrasRestantes= #terminos

    seleccion = tools.seleccion(1,#terminos,numeroPalabras+1)
	
	seleccion,terminos = tools.eraseData(seleccion,terminos,numeroPalabras)

	count1=1
    while(count1<(#terminos+1)) do

        print("columna1 terminos "..terminos[count1].columna1)
        count1=count1+1
    end
    --Arreglo con orden al azar
    arreglo = tools.seleccion(1,numeroPalabras,numeroPalabras+1)

    --Función para mover objetos al tocarlos
    local function onTouch( event )
        local t = event.target
        local phase = event.phase
        

        if "began" == phase then
            local parent = t.parent
            parent:insert( t )
            display.getCurrentStage():setFocus( t )

            t.isFocus = true

            t.x0 = event.x - t.x
            t.y0 = event.y - t.y

            posInicialX = t.x;
            posInicialY = t.y;

        elseif t.isFocus then
            if "moved" == phase then

                t.x = event.x - t.x0
                t.y = event.y - t.y0

                t.rotation=0
            elseif "ended" == phase or "cancelled" == phase then

                t.x = posInicialX;
                t.y = posInicialY;

                t.rotation=0

                display.getCurrentStage():setFocus( nil )
                t.isFocus = false


            end
        end

        return true
    end	

    gano = display.newText("Completó el juego", display.contentWidth*0.5, display.contentHeight*0.8, 400, 30, native.systemFont, 24)
    gano:setTextColor(73,0,0)
    gano.alpha=0
    sceneGroup:insert(gano)

    --Función para manejar la colisión con el objeto caja1
    collisionCounter = 0
    indiceCorrecto = 444
    local function onCollision(e)
        
        
        --esto ocurre cuando la colision inicia
        if(e.phase=="began") then
            if((e.other.indice == e.target.indice) and (e.other.indice ~= nil) ) then
                
                if(e.other.indice ~= indiceCorrecto) then
                    collisionCounter=collisionCounter+1
                end
                indiceCorrecto = e.other.indice
                
                --el objeto correcto se hace invisible para detener el movimiento
                e.other.alpha= 0
                e.phase="ended"
                --e.other.x=display.contentWidth+100
                
                print("Colision"..e.other.indice.."  "..e.target.indice)
                --se crea una caja al lado de la caja1 emulando la caja2 que desapareció
                --[[
                local cajaX = widget.newButton{
                    
                    --defaultFile= "images/display.png",
                    left = e.target.x+e.target.width,
                    top = e.target.y,
                    label = ""..e.other.palabra,
                    cornerRadius = 0,
                    width = 240, height = 50,
                    fontSize = 18,
                    labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0 } }
                }
                --cajaX:setReferencePoint(display.CenterReferencePoint)
                cajaX.x = e.target.x+e.target.width
                cajaX.y = e.target.y
                cajaX.anchorX = 0.5
                cajaX.anchorY = 0.5
                ]]

                cajaX = display.newText( ""..e.other.palabra, e.target.x+e.target.width, e.target.y, native.systemFont, 20 )
                cajaX:setFillColor( 1, 0, 0 )

                cajas:insert(cajaX)
                sceneGroup:insert(cajas)
            
            end

            --esto ocurre cuando la colision finaliza
        elseif(e.phase=="ended") then
            print("Colision terminada")
            print("Collision Counter : "..collisionCounter)
            
            if(palabrasRestantes==collisionCounter) then 
                print("Gano : "..palabrasRestantes)
                gano.alpha=1
            end
            if(collisionCounter>5) then 
                reloadButton.alpha=1
                collisionCounter=0
            end
            print("Gano : "..palabrasRestantes)
            
        end

    end

    -- Se crean las cajas en pantalla
    local function cargarNuevasCajas(arreglo,seleccion) 
        local i = 1
        local j = 1
        cajas = display.newGroup()
        while(i<#seleccion+1) do
            

            local posY = display.contentWidth*1/6
            if(i>3) then 
                posY=posY+200
                print(">3")
            end
            
            local cajaA = tools.boxFactory(1, display.contentHeight*((j))/2.3, posY,""..seleccion[i].columna2,seleccion[i].indice)
            cajaA:addEventListener("collision", onCollision)
            cajas:insert(cajaA)
            local imagen = display.newImageRect( seleccion[i].ruta, 200, 200)
            imagen.x,imagen.y = cajaA.x, cajaA.y
            --imagen.alpha=0
            cajas:insert(imagen)

            local cajaB = tools.boxFactory(2, display.contentWidth*(arreglo[i])/7,display.contentHeight*5/6,""..seleccion[i].columna1,seleccion[i].indice)
            cajaB:addEventListener("touch", onTouch)
            print("CAJA"..seleccion[i].columna2,seleccion[i].indice.." x : "..cajaB.x)
            cajas:insert(cajaB)

            if(j==3) then j=0 end    
            i=i+1
            j=j+1
        end
    end

    cargarNuevasCajas(arreglo,seleccion)
    sceneGroup:insert(cajas)

    local function reload() 
        
        local currScene = composer.getSceneName( "current" )
        composer.removeScene( currScene )
        composer.gotoScene( currScene , "fade", 500)
        -- print("Reload")
        
        -- palabrasRestantes= #terminos
        -- --palabras.text = "Contador: Quedan "..palabrasRestantes.." palabras"
        
        -- print("Numero de objetos antes : "..cajas.numChildren)

        -- for i=cajas.numChildren,1,-1 do
        --       local child = cajas[i]
        --       child:removeSelf()
        --       child = nil
        -- end
        -- print("Numero de objetos despues : "..cajas.numChildren)
        -- display.remove( cajas )
        
        -- --cajas:removeSelf() 

        -- numeroPalabras=6
        -- palabrasRestantes=6
        -- collisionCounter=0

        -- --l1, terminos = tools.eraseData(tools.seleccion(1,#terminos,numeroPalabras+1),terminos,numeroPalabras)
        -- cargarNuevasCajas(tools.seleccion(1,numeroPalabras,numeroPalabras+1),seleccion)
        -- sceneGroup:insert(cajas)
        
        -- gano.alpha=0
        -- reloadButton.alpha=0
        
    end
    
    
    --Botón de reload
    
    reloadButton = widget.newButton{
        
        defaultFile= "Juego/reload.png",
        left = display.contentWidth*18/20,
        top = display.contentHeight*13/14,
        cornerRadius = 0,
        onRelease = reload
    }
    --reloadButton:setReferencePoint(display.CenterReferencePoint)
    reloadButton.x= display.contentWidth*18.5/20
    reloadButton.y= display.contentHeight*13/14
    reloadButton.width= 50
    reloadButton.height= 50
    reloadButton.alpha=0
    gano.alpha=0
    sceneGroup:insert(reloadButton)

end

function scene:show( event )
	
	local phase = event.phase
	
	if "did" == phase then
	
		print( "1: show event, phase did" )
	
		-- remove previous scene's view
		--composer.removeScene( "scene2" )

	
	end
	
end

function scene:hide( event )
	
	local phase = event.phase
	
	if "will" == phase then
	
		print( "1: hide event, phase will" )
	
		-- remove touch listener for image
		--image:removeEventListener( "touch", image )
	
		-- cancel timer
	
	
	end
	
end

function scene:destroy( event )
	print( "((destroying scene 1's view))" )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene