local module = {}

function read(name)
    if file.open(name) then
        local value = file.read()
        file.close()
        return value
    end
    return ""
end

function write(name, value)
    if file.open(name, "w") then
      file.write(tostring(value))
      file.close()
    end
end

function module.load()
    return read("state") == "true"
end

function module.save(newState)
    write("state", newState)
end

return module