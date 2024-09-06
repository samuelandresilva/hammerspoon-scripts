-- Nome do aplicativo a ser ignorado (use o nome completo do aplicativo como aparece no Activity Monitor)
local ignoredApp = "Microsoft Remote Desktop"

-- Função para mapear Control + key para Command + key, exceto no aplicativo ignorado
local function mapCtrlToCmd(key)
    return hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
        local flags = event:getFlags()
        local keyCode = event:getKeyCode()
        local activeApp = hs.application.frontmostApplication():name()

        -- Verifica se apenas Control é pressionado junto com a tecla especificada e se o aplicativo ativo não é o ignorado
        if flags.ctrl and not (flags.cmd or flags.alt or flags.shift) and keyCode == hs.keycodes.map[key] and activeApp ~= ignoredApp then
            -- Suprime o evento original e simula Command + key
            hs.eventtap.keyStroke({"cmd"}, key, 0)
            return true
        end
    end)
end

-- Função para mapear Option + Tab para Command + Tab e se o aplicativo ativo não é o ignorado
local function mapOptionToCmdTab()
    return hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
        local flags = event:getFlags()
        local keyCode = event:getKeyCode()
        local activeApp = hs.application.frontmostApplication():name()

        -- Verifica se Option é pressionado junto com Tab
        if flags.alt and not (flags.ctrl or flags.cmd or flags.shift) and keyCode == hs.keycodes.map.tab and activeApp ~= ignoredApp then
            -- Suprime o evento original e simula Command + Tab
            hs.eventtap.keyStroke({"cmd"}, "tab", 0)
            return true
        end
    end)
end

-- Atalhos para diferentes teclas
ctrlC_event = mapCtrlToCmd("c")
ctrlV_event = mapCtrlToCmd("v")
ctrlS_event = mapCtrlToCmd("s")
ctrlA_event = mapCtrlToCmd("a")
ctrlX_event = mapCtrlToCmd("x")
ctrlZ_event = mapCtrlToCmd("z")
ctrlZ_event = mapCtrlToCmd("q")
ctrlZ_event = mapCtrlToCmd("f")
optionTab_event = mapOptionToCmdTab()

-- Ativa todos os eventos
ctrlC_event:start()
ctrlV_event:start()
ctrlS_event:start()
ctrlA_event:start()
ctrlX_event:start()
ctrlZ_event:start()
optionTab_event:start()
