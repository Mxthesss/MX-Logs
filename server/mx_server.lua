Config = {}

function SendWebHook(MXLink, title, color, message)
    local embedMsg = {}
    timestamp = os.date("%c")
    embedMsg = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] =  ""..message.."",
            ["footer"] ={
                ["text"] = "Made by Mxthess Development |"  ..timestamp.."  (Server Time).",
            },
        }
    }
    PerformHttpRequest(MXLink, function(err, text, headers)end, 'POST', json.encode({username = Config.MXName, avatar_url= Config.MXLogo ,embeds = embedMsg}), { ['Content-Type']= 'application/json' })
end


AddEventHandler('MX_logs:sendWebhook', function(MXData)
    if MXData.link == nil then
        MXLink = Config.MXlink
    else
        MXLink = MXData.link
    end
    title = MXData.title
    color = MXData.color
    message = MXData.message
    SendWebHook(MXLink, title, color, message)
end)

Citizen.CreateThread(function()
    if Config.loginLog then
        if Config.loginLogLink == '' then
            print('^7[^1INFO^7]: Please set a WebHook URL in the config.lua to log players joining and leaving.')
        else
        AddEventHandler('playerJoining', function()
            local id = source
            local ids = GetPlayerIdentifier(id, steam)
            local plyName = GetPlayerName(id)
            local MXData = {
                link = Config.loginLogLink,
                title = plyName.." JOINING",
                color = 655104,
                message = 
                '**[User]: **'..plyName..'\n'..
                '**[Identifier]: **'..ids..'\n'..
                '**[Asigned ID]: **'..id..'\n'
            }
            TriggerEvent('MX_logs:sendWebhook', MXData)
        end)

        AddEventHandler('playerDropped', function(reason)
            local id = source
            local ids = GetPlayerIdentifier(id, steam)
            local plyName = GetPlayerName(id)
            local reason = reason
            local MXData = {
                link = Config.loginLogLink,
                title = plyName.." LEFT",
                color = 16711689,
                message = 
                '**[User]: **'..plyName..'\n'..
                '**[Identifier]: **'..ids..'\n'..
                '**[Reason]: **'..reason..'\n'
            }
            TriggerEvent('MX_logs:sendWebhook', MXData)
        end)
        end
    end
end)


AddEventHandler('chatMessage', function(source, name, message)
    if Config.MXlink == '' then
          print('^7[^1INFO^7]: No default WebHook URL detected. Please configure the script correctly.')
      else 
          print('^7[^2INFO^7]: '..message..' player say.')
          local MXData = {
              link = Config.MXlink,
              title = "PLAYER SAY",
              color = 4521728,
              message = ' **'..name..'** |  '..message..'',
              footer
          }
          TriggerEvent('MX_logs:sendWebhook', MXData)
      end
end)


TriggerClientEvent('esx_rpchat:sentMe', function(source, name, message, args) -- Me log
  if Config.MXlink == '' then
        print('^7[^1INFO^7]: No default WebHook URL detected. Please configure the script correctly.')
    else 
        print('^7[^2INFO^7]: '..args..' player say.')
        local MXData = {
            link = Config.MXlink,
            title = "ME",
            color = 4521728,
            message = ' **'..name..'** | /me '..args..'',
            footer
        }
        TriggerEvent('MX_logs:sendWebhook', MXData)
    end
end) 


print('^5Made By Mxthess^7: ^1'..GetCurrentResourceName()..'^7 started ^2successfully^7...') 
