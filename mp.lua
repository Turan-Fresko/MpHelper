script_name("Fresko")
script_author("Turan")
script_version("1.0.0")

require 'lib.moonloader'

local dlstatus = require('moonloader').download_status
local ffi = require 'ffi'
local imgui = require 'mimgui'
local inicfg = require 'inicfg'
local new = imgui.new
local MainWindow = new.bool()
local sizeX, sizeY = getScreenResolution()

if not doesFileExist('moonloader/MP') then
    createDirectory('moonloader/MP')
end
local IniFilename = "../MP/Config.ini"
local ini = inicfg.load({
    settings = {
        forma = false,
        }
    }, IniFilename)
inicfg.save(ini,IniFilename)

local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local tabId = 1
local mpPlayer
local formaMp = new.bool(ini.settings.forma)
local inputMpWinner = new.char[256]()
local inputMpName = new.char[256]()
local inputMpGun = new.char[256]()
local inputMpSearch = new.char[256]()
local inputAddMPName = new.char[256]()
local inputAddMPCommand = new.char[256]()
local inputTsId = new.char[256]()
local SliderTs = new.int(6)

if not doesFileExist('moonloader/MP/MP.json') then
    jsonText = '[{ "name" :"Корабль", "command" :"/gc -2318.92 1544.64 19 12 0"},{ "name" :"Офис (17)", "command" :"/gotoint 17"},{ "name" :"Офис (30)", "command" :"/gotoint 30"},{ "name" :"Офис (76)", "command" :"/gotoint 76"},{ "name" :"Офис (114)", "command" :"/gotoint 114"},{ "name" :"Король оружия (11)", "command" :"/gotoint 11"},{ "name" :"Арена (41)", "command" :"/gotoint 41"},{ "name" :"Арена (42)", "command" :"/gotoint 42"},{ "name" :"Арена (66)", "command" :"/gotoint 66"},{ "name" :"Арена (85)", "command" :"/gotoint 85"},{ "name" :"Арена (112)", "command" :"/gotoint 112"},{ "name" :"Арена (121)", "command" :"/gotoint 121"},{ "name" :"CSGO (48)", "command" :"/gotoint 48"},{ "name" :"Завод (74)", "command" :"/gotoint 74"},{ "name" :"Завод", "command" :"/gc 2509.90 2770.33 12 12 0"},{ "name" :"Рулетка", "command" :"/gc 2821.89 2538.56 18 12 0"},{ "name" :"Матрица", "command" :"/gc 1811.03 -1221.43 64.97 12 0"},{ "name" :"Комбайн", "command" :"/gc -1084.87 -976.62 130.22 12 0"}]'
    local file = io.open(getGameDirectory() .. "\\moonloader\\MP\\MP.json", "a")
    file:write(jsonText)
    file:close()
end

local file = io.open(getGameDirectory() .. "\\moonloader\\MP\\MP.json", "r")
jsonMP = file:read("*a")
file:close()

local MpTp = decodeJson(jsonMP)

local tag = '[ MP Script ] {e6e6e6}'
local colour = 0x2de139

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampAddChatMessage(tag .. "Скрипт загружен!",colour)
    sampRegisterChatCommand('mpmenu', mpmenu)

    if not doesFileExist('moonloader/MP/EagleSans-Reg.ttf') then
        downloadUrlToFile('https://raw.githubusercontent.com/Turan-Fresko/MpHelper/main/MP/EagleSans-Reg.ttf', 'moonloader/MP/EagleSans-Reg.ttf', function (id, status, p1, p2)
            if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                sampAddChatMessage(tag..'Шрифт был успешно установлен!', colour)
            end
        end)
    end
    if not doesFileExist('moonloader/MP/Logo.png') then
        downloadUrlToFile('https://raw.githubusercontent.com/Turan-Fresko/MpHelper/main/MP/Logo.png', 'moonloader/MP/Logo.png', function (id, status, p1, p2)
            if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                sampAddChatMessage(tag..'Иконка была успешна установлена!', colour)
            end
        end)
    end

    while true do
        wait(0)
    end
end

function white_style()
    imgui.SwitchContext()
    imgui.GetStyle().WindowTitleAlign        = imgui.ImVec2(0.50,0.50)
    imgui.GetStyle().WindowRounding        = 7.0
    imgui.GetStyle().ChildRounding        = 7.0
    imgui.GetStyle().FrameRounding        = 3
    imgui.GetStyle().FramePadding        = imgui.ImVec2(5, 3)
    imgui.GetStyle().WindowPadding        = imgui.ImVec2(8, 8)
    imgui.GetStyle().ButtonTextAlign    = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().GrabMinSize        = 7
    imgui.GetStyle().GrabRounding        = 15

    imgui.GetStyle().Colors[imgui.Col.Text]                    = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextDisabled]            = imgui.ImVec4(1.00, 1.00, 1.00, 0.20)
    imgui.GetStyle().Colors[imgui.Col.WindowBg]                = imgui.ImVec4(0, 0, 0, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.40, 0.39, 0.39, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Border]                = imgui.ImVec4(1, 1, 1, 0.25)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab]            = imgui.ImVec4(0.90, 0.90, 0.90, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]        = imgui.ImVec4(0.70, 0.70, 0.70, 1.00)
    imgui.GetStyle().Colors[imgui.Col.BorderShadow]            = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.60, 0.60, 0.60, 0.90)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]        = imgui.ImVec4(0.90, 0.90, 0.90, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]    = imgui.ImVec4(0.80, 0.80, 0.80, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.70, 0.70, 0.70, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]        = imgui.ImVec4(0.20, 0.20, 0.20, 0.80)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]        = imgui.ImVec4(0.20, 0.20, 0.20, 0.60)
    imgui.GetStyle().Colors[imgui.Col.CheckMark]            = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Button]                = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]        = imgui.ImVec4(0.15, 0.15, 0.15, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive]            = imgui.ImVec4(0.10, 0.10, 0.10, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]        = imgui.ImVec4(0.80, 0.80, 0.80, 0.80)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]        = imgui.ImVec4(0.37, 0.34, 0.34, 1)
    imgui.GetStyle().Colors[imgui.Col.TitleBg]        = imgui.ImVec4(0.37, 0.34, 0.34, 1)
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip]        = imgui.ImVec4(0.63, 0.63, 0.63, 0.25)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]        = imgui.ImVec4(1, 1, 1, 0.67)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]        = imgui.ImVec4(0.37, 0.37, 0.37, 0.92)

    local but_orig = imgui.Button
    imgui.Button = function(...)
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 1, 1, 1.00))
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.20, 0.20, 0.20, 1.00))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.18, 0.18, 0.18, 1.00))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.70, 0.70, 0.70, 1.00))
        local result = but_orig(...)
        imgui.PopStyleColor(4)
        return result
    end
end

imgui.OnInitialize(function()
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    onest = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/MP/EagleSans-Reg.ttf', 18, _, glyph_ranges)
    LogoImg = imgui.CreateTextureFromFile(getWorkingDirectory() .. '\\MP\\Logo.png')
    imgui.GetIO().IniFilename = nil
    white_style()
end)

local MainFrame = imgui.OnFrame(function() return MainWindow[0] end, function(player)
    -- imgui.ShowStyleEditor()
    imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(800,500), imgui.Cond.FirstUseEver)
    imgui.PushFont(onest)
    imgui.Begin(u8"Главное меню", MainWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    imgui.SetCursorPos(imgui.ImVec2(60, 50))
    imgui.Image(LogoImg, imgui.ImVec2(100, 100))
    imgui.SetCursorPos(imgui.ImVec2(8, 170))
    if imgui.Button(u8'Основное', imgui.ImVec2(185,47)) then tabId = 1 end
    if imgui.Button(u8'Добавить', imgui.ImVec2(185,47)) then tabId = 2 end
    if imgui.Button(u8'Транспорт', imgui.ImVec2(185,47)) then tabId = 3 end
    if imgui.Button(u8'Сохранить', imgui.ImVec2(185,47)) then
        ini.settings.forma = formaMp[0]
        inicfg.save(ini,IniFilename)
        encodedTable = encodeJson(MpTp)
        local file = io.open(getGameDirectory() .. "\\moonloader\\MP\\MP.json", "w")
        file:write(encodedTable)
        file:flush()
        file:close()
        sampAddChatMessage(tag .. "Все успешно сохраненно!", colour)
    end
    imgui.SetCursorPos(imgui.ImVec2(8, 425))
    if imgui.Button(u8'Перезагрузить', imgui.ImVec2(185, 30)) then
        sampAddChatMessage(tag .. 'Скрипт перезагружается...',colour)
        sampAddChatMessage(' ',-1)
        thisScript():reload()
    end
    if imgui.Button(u8'Выключить', imgui.ImVec2(185, 30)) then
        sampAddChatMessage(tag .. 'Скрипт выключается...',colour)
        sampAddChatMessage(' ',-1)
        thisScript():unload()
    end
    imgui.SetCursorPos(imgui.ImVec2(200, 30))
    imgui.VerticalSeparator()
    imgui.SetCursorPos(imgui.ImVec2(210, 30))
    local buttonsMp = {
        { name = "Выдать оружие (100)", command = "/gunall 100 ".. ffi.string(inputMpGun) .. " 500"},
        { name = "Выдать оружие (1)", command = "/gunall 1 ".. ffi.string(inputMpGun) .. " 500"},
        { name = "Отобрать Оружие (100)", command = "/weapall 100"},
        { name = "Выдать армор (100)", command = "/armourall 100"},
        { name = "Выдать армор (1)", command = "/armourall 1"},
        { name = "Отобрать армор (100)", command = "/unarmourall 100"},
        { name = "Выдать хп (100)", command = "/hpall 100"},
        { name = "Выдать голод (100)", command = "/eatall 100"},
        { name = "Выдать azakon (100)", command = "/azakon 100"},
        { name = "Выдать azakon (1)", command = "/azakon 1"},
        { name = "Выдать freezeall (100)", command = "/freezeall 100"},
        { name = "Выдать unfreezeall (100)", command = "/unfreezeall 100"},
        { name = "/smp (Правила)", command = "/smp НЕ ИСПОЛЬЗУЕМ АРМОР, АНИМАЦИИ, МАСКИ - СРАЗУ СПАВН."},
    }
    if tabId == 1 then
        if imgui.BeginChild('MP', imgui.ImVec2(580, 465), false) then
            imgui.CenterText("Мероприятия")
            imgui.Text(u8"Название Мероприятия: ")
            imgui.SameLine()
            imgui.SetCursorPos(imgui.ImVec2(200, 25))
            imgui.InputTextWithHint('##MpName', u8'Король Дигла', inputMpName, 256)
            imgui.Text(u8"ID Оружия: ")
            imgui.SameLine()
            imgui.SetCursorPos(imgui.ImVec2(200, 55))
            imgui.InputTextWithHint('##GunID', u8'24', inputMpGun, 256)
            imgui.Text(u8"Победитель МП (ID/Nick): ")
            imgui.SameLine()
            imgui.SetCursorPos(imgui.ImVec2(200, 85))
            imgui.InputTextWithHint('##WinnerMP', u8'Turan_Fresko | 314', inputMpWinner, 256)
            imgui.Text(u8"Быстрое ТП: ")
            if imgui.BeginChild('Menu', imgui.ImVec2(580, 150), true) then
                imgui.Text(u8"Поиск:")
                imgui.SameLine()
                imgui.InputTextWithHint('##searchMP', u8'Корабль', inputMpSearch, 256)
                imgui.SameLine()
                if imgui.Button(u8'Очистить') then
                    imgui.StrCopy(inputMpSearch,'')
                end
                imgui.Text(u8"Название: ")
                lua_thread.create(function()
                    for k,v in pairs(MpTp) do
                        if u8(v.name):find(ffi.string(inputMpSearch)) then
                            if imgui.TextButton(k .. ". " .. u8(v.name)) then
                                sampSendChat(v.command)
                            end
                            imgui.SameLine()
                            if imgui.TextButton("[X]",k) then
                                rmTable(v.name)
                                sampAddChatMessage(tag .. "Вы успешно удалили телепорт! Не забудьте сохранить!", colour)
                            end
                        end
                    end
                end)
                imgui.EndChild()
            end
            lua_thread.create(function()
                for k,v in pairs(buttonsMp) do
                    if imgui.Button(u8(v.name),imgui.ImVec2(185,30)) then
                        sampSendChat(v.command)
                    end
                    if k % 3 ~= 0 then
                        imgui.SameLine()
                    end
                end
            end)
            if imgui.Button(u8"/ao",imgui.ImVec2(185,30)) then
                if ffi.string(inputMpName) == "" or ffi.string(inputMpWinner) == "" then
                    sampAddChatMessage(tag .. "Ошибка! Вы не указали мероприятие или игрока!",colour)
                else
                    if get_player(ffi.string(inputMpWinner)) then
                        sampSendChat(string.format("/ao Победитель мероприятия \"%s\" становиться %s[%s]. Поздравляем!",u8:decode(ffi.string(inputMpName)),mpPlayer[1],mpPlayer[2]))
                    else sampAddChatMessage(tag .. "Ошибка! Не верный игрок!",colour)
                    end
                end
            end
            imgui.SameLine()
            imgui.Checkbox(u8'Отправять формой', formaMp)
        end
    elseif tabId  == 2 then
        if imgui.BeginChild('MP', imgui.ImVec2(580, 460), false) then
            imgui.CenterText("Добавление локаций")
            imgui.Text(u8"Название кнопки: ")
            imgui.SameLine()
            imgui.SetCursorPos(imgui.ImVec2(200, 25))
            imgui.InputTextWithHint('##MpNameAdd', u8'Арена', inputAddMPName, 256)
            imgui.Text(u8"Команда для тп: ")
            imgui.SameLine()
            imgui.SetCursorPos(imgui.ImVec2(200, 55))
            imgui.InputTextWithHint('##MpCommand', u8'/gc 1811.03 -1221.43 64.97 12 0', inputAddMPCommand, 256)
            imgui.SetCursorPos(imgui.ImVec2(200, 100))
            if imgui.Button(u8"Добавить ТП", imgui.ImVec2(150,50)) then
                if ffi.string(inputAddMPName) == "" or ffi.string(inputAddMPCommand) == "" then
                    sampAddChatMessage(tag .. "Вы не ввели название или команду!", colour)
                else
                    if checkNameExists(u8:decode(ffi.string(inputAddMPName))) then
                        sampAddChatMessage(tag .. "Такое название кнопки уже есть!!", colour)
                    else
                        table.insert(MpTp,{name = u8:decode(ffi.string(inputAddMPName)), command = u8:decode(ffi.string(inputAddMPCommand))})
                        encodedTable = encodeJson(MpTp)
                        local file = io.open(getGameDirectory() .. "\\moonloader\\MP\\MP.json", "w")
                        file:write(encodedTable)
                        file:flush()
                        file:close()
                        sampAddChatMessage(tag .. "Успешно!", colour)
                    end
                end
            end
            imgui.EndChild()
        end
    elseif tabId == 3 then
        if imgui.BeginChild('Transport', imgui.ImVec2(580, 460), false) then
            imgui.Text(u8"Игроки в стриме: ")
            if imgui.BeginChild('playersChield', imgui.ImVec2(580, 350), true) then
                for k, v in ipairs(getAllChars()) do
                    local res, id = sampGetPlayerIdByCharHandle(v)
                    local _, handle = sampGetCharHandleBySampPlayerId(id)
                    if res and _ then
                        local px, py, pz = getCharCoordinates(handle)
                        local mx, my, mz = getCharCoordinates(PLAYER_PED)
                        local distance = getDistanceBetweenCoords3d(px,py,pz,mx,my,mz)
                        imgui.Text(string.format(u8"Игрок: %s[%s] | Расстояние: %s метров.",sampGetPlayerNickname(id),id,math.floor(distance+ 0.5)))
                    end
                end
                imgui.EndChild()
            end
            imgui.SliderInt(u8'Кд выдачи', SliderTs, 0, 10)
            imgui.InputTextWithHint(u8'id транспорта', u8'444 (Монстер)', inputTsId, 256)
            if imgui.Button(u8"Выдать всем") then
                lua_thread.create(function()
                    for k, v in ipairs(getAllChars()) do
                        local res, id = sampGetPlayerIdByCharHandle(v)
                        if res then
                            sampSendChat(string.format("/plveh %s %s", id, u8:decode(ffi.string(inputTsId))))
                            wait(SliderTs[0]*1000)
                        end
                    end
                end)
            end
            imgui.EndChild()
        end
    end
    imgui.PopFont()
    imgui.End()
end)

function imgui.VerticalSeparator()
    local p = imgui.GetCursorScreenPos()
    imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x, p.y + imgui.GetContentRegionMax().y), 0x817e7e81)
end

function imgui.CenterText(text)
    imgui.SetCursorPosX(imgui.GetWindowWidth()/2-imgui.CalcTextSize(u8(text)).x/2)
    imgui.Text(u8(text))
end

function imgui.TextButton(name,index,colors)
    index = tostring(index) or ""
    colors = colors or {imgui.Col.ScrollbarBg,imgui.Col.Text}
    local size = imgui.CalcTextSize(name)
    local p = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    local resultBtn = imgui.InvisibleButton('##'..name..index, size)
    imgui.SetCursorPos(p2)
    if imgui.IsItemHovered() then
        imgui.TextColored(imgui.GetStyle().Colors[colors[1]], name)
        imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), 0xFFFFFFFF)
    else
        imgui.TextColored(imgui.GetStyle().Colors[colors[2]], name)
    end
    return resultBtn
end

function rmTable(text)
    for i, entry in ipairs(MpTp) do
        if entry.name == text then
            table.remove(MpTp, i)
            break
        end
    end
end

function checkNameExists(name)
    for _, entry in ipairs(MpTp) do
        if entry.name == name then
            return true
        end
    end
    return false
end

function get_player(nickname)
    for id = 0, 999 do
        if sampIsPlayerConnected(id) then
            local player_id = tonumber(nickname)
            if player_id then
                if id == player_id then
                    mpPlayer = {sampGetPlayerNickname(player_id), player_id}
                    return true
                end
            else
                local nick = sampGetPlayerNickname(id)
                if nick == nickname then
                    mpPlayer = {nick, id}
                    return true
                end
            end
        end
    end
    return false
end

function mpmenu()
    MainWindow[0] = not MainWindow[0]
end