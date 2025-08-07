-- #####################################################################################################################
-- #            FUNÇÃO PARA MAPEAR O TECLADO WINDOWS PARA O MAC TROCANDO O CMD PELO CTRL                               #
-- #####################################################################################################################

-- Lista de aplicativos a serem ignorados (use os nomes completos dos aplicativos como aparecem no Activity Monitor)
local ignoredApps = { "Windows App", "Terminal", "iTerm2", "Hyper", "Alacritty" }

-- Função para verificar se o aplicativo atual está na lista de ignorados
local function isIgnoredApp(appName)
    for _, ignoredApp in ipairs(ignoredApps) do
        if appName == ignoredApp then
            return true
        end
    end
    return false
end

-- Função para mapear Control para Command, exceto nos aplicativos ignorados
local function mapCtrlToCmdForAllKeys()
    return hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
        local flags = event:getFlags()
        local keyCode = event:getKeyCode()
        local activeApp = hs.application.frontmostApplication():name()

        -- Verifica se apenas Control está pressionado e se o aplicativo ativo não está na lista de ignorados
        if flags.ctrl and not (flags.cmd or flags.alt or flags.shift) and not isIgnoredApp(activeApp) then
            -- Suprime o evento original e simula Command + key
            hs.eventtap.keyStroke({ "cmd" }, hs.keycodes.map[keyCode], 0)
            return true -- Suprime o evento original
        end

        return false
    end)
end

-- Função para mapear Option + Tab para Command + Tab, exceto nos aplicativos ignorados
local function mapOptionToCmdTab()
    return hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
        local flags = event:getFlags()
        local keyCode = event:getKeyCode()
        local activeApp = hs.application.frontmostApplication():name()

        -- Verifica se Option é pressionado junto com Tab e se o aplicativo ativo não está na lista de ignorados
        if flags.alt and not (flags.ctrl or flags.cmd or flags.shift) and keyCode == hs.keycodes.map.tab and not isIgnoredApp(activeApp) then
            -- Suprime o evento original e simula Command + Tab
            hs.eventtap.keyStroke({ "cmd" }, "tab", 0)
            return true
        end

        return false
    end)
end

-- Ativa o remapeamento de Control para Command para todas as teclas
ctrlToCmd_event = mapCtrlToCmdForAllKeys()
optionTab_event = mapOptionToCmdTab()

-- Iniciar o listener para o remapeamento
ctrlToCmd_event:start()
optionTab_event:start()


-- ###########################################################################################
-- #    FUNÇÃO PARA TECLADO 60% TECLAR SHIT + ESC PARA INSERIR TIL (~)                       #
-- ###########################################################################################

-- Carrega o módulo hotkey
local hotkey = require "hs.hotkey"
local eventtap = require "hs.eventtap"

-- Função que simula o pressionamento do til
local function insertTilde()
    eventtap.keyStroke({"shift"}, "`") -- Simula a combinação Shift + "`" para ativar o til
end

-- Mapeia a combinação Fn + Shift + ESC para inserir o til
-- No Hammerspoon, a tecla Fn geralmente não é reconhecida diretamente,
-- então você só precisa mapear Shift + ESC.
hotkey.bind({"shift"}, "escape", insertTilde)
