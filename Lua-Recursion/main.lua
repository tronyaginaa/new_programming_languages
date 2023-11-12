local function readGraph(path)
    local graph= {{}}
    local file = io.open(path, "r")
    if file == nil then
        print("The file cannot be opened")
        return nil, nil
    end
    local line = file:read("l")
    local numOfVertices = tonumber(line)
    for i = 1,numOfVertices do
        graph[i] = {}
        for j = 1,numOfVertices do
            graph[i][j] = 0
        end
    end
    local i = 1
    line = file:read("l")
    while line ~= nil do
        for num in line:gmatch("%S+") do
            graph[i][tonumber(num)] = 1
        end
        line = file:read("l")
        i = i + 1
    end
    return graph, numOfVertices
end

local function DFS(graph, num, numOfVertices, endPoint)
    if num == endPoint then
        table.insert(WAY, num)
        return true 
    end
    if CHEKED_VERTICES == true then
        return false
    end
    CHEKED_VERTICES[num] = true
    table.insert(WAY, num)
    for i = numOfVertices,1,-1  do
        if graph[num][i] ~= 0 and CHEKED_VERTICES[i] ~= true then
            table.insert(STACK, i)
        end
    end
    while #STACK ~= 0 do
        num = table.remove(STACK)
        if CHEKED_VERTICES[num] ~= true then
            local achived = DFS(graph, num, numOfVertices, endPoint)
            if achived then
                return true
            end
        end 
    end
    return false
end

STACK = {}
CHEKED_VERTICES = {}
WAY = {}

local function main(path)
    local graph, numOfVertices = readGraph(path)
    if graph == nil or numOfVertices == nil then
        return
    end
    for i = 1,numOfVertices do
        CHEKED_VERTICES[i] = false
    end
    local achived = DFS(graph, 1, numOfVertices, 3)
    if achived then
        for key, vertices in pairs(WAY) do
            print(vertices)
        end
    end
    WAY = {}
    CHEKED_VERTICES = {}
end

local path = io.read()
main(path)

