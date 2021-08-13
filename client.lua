--------------------------------------------------------------------------------------------
--██╗░░██╗░█████╗░████████╗░██████╗███╗░░██╗██╗░░░██╗░██╗░░█████╗░░█████╗░░█████╗░░█████╗░--
--██║░██╔╝██╔══██╗╚══██╔══╝██╔════╝████╗░██║██║██████████╗██╔══██╗██╔═══╝░██╔══██╗██╔══██╗--
--█████═╝░███████║░░░██║░░░╚█████╗░██╔██╗██║██║╚═██╔═██╔═╝██║░░██║██████╗░╚██████║██║░░██║--
--██╔═██╗░██╔══██║░░░██║░░░░╚═══██╗██║╚████║██║██████████╗██║░░██║██╔══██╗░╚═══██║██║░░██║--
--██║░╚██╗██║░░██║░░░██║░░░██████╔╝██║░╚███║██║╚██╔═██╔══╝╚█████╔╝╚█████╔╝░█████╔╝╚█████╔╝--
--╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═════╝░╚═╝░░╚══╝╚═╝░╚═╝░╚═╝░░░░╚════╝░░╚════╝░░╚════╝░░╚════╝░--
--------------------------------------------------------------------------------------------

local ESX	  = nil
local plate = nil
local inMenu =false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


function KilvenVaihtoMenuXD()
  inMenu = true
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pawn_menu',
      {
          title    = 'Mitä haluat?',
          elements = {
              {label = 'Vaihda kilpi ($100k)', value = 'change'},
          }
      },
      function(data, menu)
          ESX.UI.Menu.Open(
              'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
              {
                title = "Kirjoita kilpi"
              },
              function(data2, menu2)
     
                local plate = data2.value
                menu2.close()
                menu.close()
                if plate ~= nil then
                  local vehicle, distance = ESX.Game.GetClosestVehicle(coords)
            
                  if distance ~= -1 and distance <= 3.0 then
                    local oldplate = GetVehicleNumberPlateText(vehicle)
            
                    ESX.TriggerServerCallback('esx_kilvenvaihtopiste:update', function( cb )
                      if cb == 'found' then
                        ESX.UI.Menu.CloseAll()
                        ESX.ShowNotification("Ajoneuvosi kilpi on nyt: ~b~"..plate)
                        SetVehicleNumberPlateText(vehicle, plate)
                        plate = nil
                      elseif cb == 'error' then
                        ESX.ShowNotification('Jokin meni vikaa!')
		      else
			ESX.ShowNotification("Tällä kilvellä löytyy jo ajoneuvo!")
                      end
                    end, oldplate, plate)
                    menu.close()
                    inMenu = false
                  end
                end
              end,
              function(data2, menu2)
              menu2.close()
            end
          )
      end,
      function(data, menu)
          menu.close()
          inMenu = false
      end
  )
end

local markerissa = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local paikka = vector3(376.30, -1612.33, 28.96)
    if Vdist(pos.x, pos.y, pos.z, paikka) < 5 then
      if Vdist(pos.x, pos.y, pos.z, paikka) < 2 then
        TriggerEvent("markeri:yes")
      end

      if Vdist(pos.x, pos.y, pos.z, paikka) > 2 then
        TriggerEvent("markeri:no")
      end
    else
      Citizen.Wait(1000)
    end
  end
end)

RegisterNetEvent("markeri:yes")
AddEventHandler("markeri:yes", function()
  markerissa = true
end)

RegisterNetEvent("markeri:no")
AddEventHandler("markeri:no", function()
  markerissa = false
end)

Citizen.CreateThread(function()
  while true do
    Wait(0)
    local coords = GetEntityCoords(PlayerPedId())
    local dist = #(coords-vector3(376.30, -1612.33, 28.96))
    if dist < 10 then
      if dist < 5 then
        DrawMarker(20, 376.30, -1612.33, 28.96, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 100, false, true, 2, false, false, false, false)
      end
    end
  end
end)


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if markerissa then
      if not inMenu then
        ESX.ShowHelpNotification("Paina ~INPUT_CONTEXT~ vaihtaaksesi kilpi")
        if IsControlJustPressed(0, 38) then
          KilvenVaihtoMenuXD()
        end
      end
    else
      Citizen.Wait(1000)
    end
  end
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(376.30, -1612.33, 28.96)
	SetBlipSprite(blip, 525)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 0)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Kilpikauppa")
	EndTextCommandSetBlipName(blip)
end)
