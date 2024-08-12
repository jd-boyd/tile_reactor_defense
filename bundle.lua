-- Variable to hold the concatenated content
local concatenatedContent = ""

-- Function to read and concatenate file contents with custom lines
local function readAndConcatenateFiles(fileList)
    for _, file in ipairs(fileList) do
        local f = io.open(file, "r")  -- Open the file for reading
        if f then  -- If the file exists and is open
            local moduleName = file:match("^(.+)%..+$")  -- Extract the file name without extension
            concatenatedContent = concatenatedContent .. "package.preload['" .. moduleName .. "'] = function ()\n"  -- Add custom line before content
            local content = f:read("*a")  -- Read the entire content of the file
            concatenatedContent = concatenatedContent .. content  -- Concatenate the content
            concatenatedContent = concatenatedContent .. "\nend\n"  -- Add custom line after content
            f:close()  -- Close the file
        else
            print("Failed to open " .. file)
        end
    end
end

-- Collect files from command line arguments
local files = {}
for i = 1, #arg do
    table.insert(files, arg[i])
end

-- Call the function with the list of files provided as command line arguments
readAndConcatenateFiles(files)

-- Print the concatenated contents
print(concatenatedContent)

