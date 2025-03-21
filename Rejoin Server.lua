-- Получение локального игрока
local Plr = game:GetService("Players").LocalPlayer

-- Функция для повторного подключения к текущему серверу
function RejoinServer()
    -- Получаем текущий ID места (игры) и ID сервера
    local placeId = game.PlaceId
    local jobId = game.JobId

    -- Используем TeleportService для повторного подключения
    local TeleportService = game:GetService("TeleportService")
    local success, result = pcall(function()
        -- Переходим на тот же сервер
        TeleportService:TeleportToPlaceInstance(placeId, jobId, Plr)
    end)

    -- Обработка ошибок (без вывода сообщений)
    if not success then
        -- В случае ошибки просто завершаем выполнение
        return
    end
end

-- Запуск функции для повторного подключения
RejoinServer()
