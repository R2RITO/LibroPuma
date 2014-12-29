module(..., package.seeall)

local physics = require("physics")
local widget = require( "widget" )

function seleccion(cotaInferior,cotaSuperior,totalNumeros)
    local seleccion = {}
    local correcto = 1
    local count1 = 1
    while count1<totalNumeros do
        correcto = 1
        while correcto > 0  do
            x= math.random(cotaInferior,cotaSuperior)

            local count2=0
            correcto = -1
            while(count2<count1) do

                if(x==seleccion[count2]) then
                    correcto = 1
                    count2=count1
                elseif(x~=seleccion[count2]) then
                    count2=count2+1
                end
            end
            if(correcto == -1) then
                seleccion[count1] = x
            end
        end
        count1 = count1+1
    end
    
    return seleccion
end


function eraseData(seleccion,terminos,numeroPalabras)
    count1 = 1
    local arreglo = {}
    while(count1<numeroPalabras+1) do

        print("EraseData : "..count1)
        arreglo[count1]={}

        local indice = seleccion[count1]
        print("Indice : "..indice)
        arreglo[count1].indice = terminos[indice].indice
        arreglo[count1].columna1 = terminos[indice].columna1
        print(" Arreglo columna1 : "..arreglo[count1].columna1)
        arreglo[count1].columna2 = terminos[indice].columna2
        arreglo[count1].ruta = terminos[indice].ruta

        count1=count1+1

    end

    local tabla = seleccion

    for i = 1, #tabla do --> array start to end
            for j = 2, #tabla do
                    if tabla[j] < tabla[j-1] then -->switch
                            temp = tabla[j-1]
                            tabla[j-1] = tabla[j]
                            tabla[j] = temp
                    end
            end
    end

    count1=1
    while(count1<#tabla+1) do 
        print("Selección Ordenado : "..tabla[count1])
        count1=count1+1
    end

    count1 = 1
    while(count1<numeroPalabras+1) do 


        local i = 0
        while(i<(#terminos-(tabla[count1]-(count1-1)))) do
            local indice = tabla[count1] -(count1-1)
            terminos[indice+i]= terminos[indice+(i+1)]
            i=i+1
        end
        terminos[#terminos] = nil
        count1=count1+1
    end


    return arreglo,terminos
end


function boxFactory(tipo,posX,posY,palabra,indice)
     local cajaX
     --[[
     cajaX = widget.newButton{
        
        --defaultFile="images/display.png",
        left = posX,
        top = posY,
        --shape="roundedRect",
        label = ""..palabra,
        cornerRadius = 0,
        width = 240, height = 50,
        fontSize = 18
 

    }
    cajaX.indice = indice
    --cajaX:setReferencePoint(display.CenterReferencePoint)
    cajaX.anchorX = 1
    cajaX.anchorY = 1
    ]]

    cajaX = display.newText( "", posX, posY, native.systemFont, 20 )
    cajaX:setFillColor( 1, 0, 0 )
    cajaX.indice = indice

    --caja tipo1 estática
    if(tipo==1) then


        physics.addBody(cajaX,"static",{radius =15})

    --caja tipo2 dinámica
    elseif(tipo==2) then

        cajaX.text = palabra
        local filtro = { categoryBits = 2, maskBits = 1 }
        cajaX.palabra = palabra
        physics.addBody(cajaX,{filter=filtro, radius =15})


    end

    print(" Caja contruida : "..palabra)
    
    return cajaX
end


