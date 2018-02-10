storage = require("storage")

local port = 80
print("Starting server version 1.0.0 at port ", port)

function statusController (request, next) 
    if(request.path == "/status") then
        if(request.method == "GET") then
            local enabled = storage.load()
            if(enabled) then
                return {status=200, body="{\"status\":\"enabled\"}"}
            else
                return {status=200, body="{\"status\":\"disabled\"}"}
            end
        elseif(request.method == "PUT") then
            local enabled = request.params.status == "enabled"
            storage.save(enabled)
            return {status=200}
        end
    else
        return next(request)
    end
end

function notFoundController (request)
    return {status=404}
end

function formatResponse(result)
    local response = ""
        .. "HTTP/1.1 " .. result.status
    if(result.body ~= nil) then
        response = response 
            .. "\r\nContent-Length: " .. string.len(result.body)
            .. "\r\nContent-Type: json/application"
            .. "\r\n"
            .. "\r\n" .. result.body
    end

    return response
end

function parseRequest(request)
    local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP")
    if(method == nil)then
        _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP")
    end
    local params = {}
    if (vars ~= nil)then
        for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
            params[k] = v
        end
    end

    return {
        path=path,
        method=method,
        params=params
    }
end

srv=net.createServer(net.TCP)
srv:listen(port,function(conn)
    conn:on("receive", function(client, rawRequest)
        local request = parseRequest(rawRequest)

        local result = statusController(
            request,
            notFoundController)

        response = formatResponse(result)
        print(response)
        
        client:send(response, function(sent)
            client:close()
            collectgarbage()
        end
        )
    end)
end)