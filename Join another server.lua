-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для перехода на другой сервер
function JoinAnotherServer()
    -- Получаем текущий ID места (игры)
    local placeId = game.PlaceId

    -- Используем TeleportService для поиска нового сервера
    local TeleportService = game:GetService("TeleportService")
    local success, result = pcall(function()
        -- Получаем список серверов
        local servers = TeleportService:GetServers(placeId)
        if #servers > 0 then
            -- Выбираем случайный сервер из списка
            local randomServer = servers[math.random(1, #servers)]
            -- Переходим на выбранный сервер
            TeleportService:TeleportToPlaceInstance(placeId, randomServer.id, Plr)
        else
            -- Если серверы не найдены, переходим на новый сервер
            TeleportService:Teleport(placeId, Plr)
        end
    end)

    -- Обработка ошибок (без вывода сообщений)
    if not success then
        -- В случае ошибки просто завершаем выполнение
        return
    end
end

-- Запуск функции для перехода на другой сервер
JoinAnotherServer()
