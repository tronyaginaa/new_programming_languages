local function readGraph(path)
    local graph= {{}}
    local file = io.open(path, "r")
    if file == nil then
        io.write("the file cannot be opened")
        return nil
    end
    local line = file:read("l")
    local i = 1
    while line ~= nil do
        graph[i] = {}
        for vertex in line:gmatch("%S+") do
            table.insert(graph[i], tonumber(vertex))
        end
        line = file:read("l")
        i = i + 1
    end
    return graph
end

local function DFS(graph, vertex, endVertex)
    if vertex == endVertex then
        table.insert(WAY, vertex)
        return true 
    end
    if CHEKED_VERTICES == true then
        return false
    end
    CHEKED_VERTICES[vertex] = true
    table.insert(WAY, vertex)
    for _, nextVertex in pairs(graph[vertex]) do
        if CHEKED_VERTICES[nextVertex] == false then
            local achived = DFS(graph, nextVertex, endVertex)
            if achived then
                return true
            end
        end
    end
    return false
end

local function length(t)
    local len = 0
    for _,_ in pairs(t) do
        len = len + 1
    end
    return len
end

local function graphProcessing(path)
    local graph = readGraph(path)
    if graph == nil then
        return
    end
    io.write("Enter the starting vertex:")
    local startVertex = io.read("n")
    io.write("Enter the starting vertex:")
    local endVertex = io.read("n")
    if endVertex > length(graph) or startVertex > length(graph) or endVertex < -1 or startVertex < -1 then
        io.write("incorect vertex index")
        return
    end
    for i = 1,length(graph) do
        CHEKED_VERTICES[i] = false
    end
    local achived = DFS(graph, startVertex, endVertex)
    if achived then
        io.write("Path between vertices: ")
        for key, vertices in pairs(WAY) do
            io.write(vertices, " ")
        end
    else
        io.write("impossible to find a path between vertices")
    end
    WAY = {}
    CHEKED_VERTICES = {}
end


io.write("Enter the file path:")
local path = io.read()
CHEKED_VERTICES = {}
WAY = {}
graphProcessing(path)

