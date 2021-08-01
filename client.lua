--------------------------------------------------------------------------------------------
--██╗░░██╗░█████╗░████████╗░██████╗███╗░░██╗██╗░░░██╗░██╗░░█████╗░░█████╗░░█████╗░░█████╗░--
--██║░██╔╝██╔══██╗╚══██╔══╝██╔════╝████╗░██║██║██████████╗██╔══██╗██╔═══╝░██╔══██╗██╔══██╗--
--█████═╝░███████║░░░██║░░░╚█████╗░██╔██╗██║██║╚═██╔═██╔═╝██║░░██║██████╗░╚██████║██║░░██║--
--██╔═██╗░██╔══██║░░░██║░░░░╚═══██╗██║╚████║██║██████████╗██║░░██║██╔══██╗░╚═══██║██║░░██║--
--██║░╚██╗██║░░██║░░░██║░░░██████╔╝██║░╚███║██║╚██╔═██╔══╝╚█████╔╝╚█████╔╝░█████╔╝╚█████╔╝--
--╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═════╝░╚═╝░░╚══╝╚═╝░╚═╝░╚═╝░░░░╚════╝░░╚════╝░░╚════╝░░╚════╝░--
--------------------------------------------------------------------------------------------

local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
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
                        ESX.ShowNotification('Tällä kilvellä löytyy jo auto!')
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
