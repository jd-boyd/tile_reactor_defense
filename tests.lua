-- Helper function to execute a file and check its exit status
function executeTestFile(filename)
   print("Executing " .. filename)
    -- Construct the command to run the Lua script
    local command = "lua " .. filename
    -- Execute the command
    local exitCode = os.execute(command)
    
    -- Check if the execution was successful
    if exitCode ~= 0 then
        print(filename .. " failed with exit code: " .. exitCode)
        return false
    else
        print(filename .. " passed.")
        return true
    end
end

-- Main function to find and execute test files
function main()
    -- Command to list all files matching 'test_*.lua'
    local pattern = "test_*.lua"
    local command = "ls " .. pattern
    local allPassed = true

    -- Open the command for reading
    local files = io.popen(command, "r")
    
    -- Read each line from the command's output
    for filename in files:lines() do
        if not executeTestFile(filename) then
            allPassed = false
        end
    end

    files:close()
    
    -- Check the overall pass status
    if not allPassed then
        os.exit(1)  -- Exit with a non-zero status if any test fails
    end
end

-- Run the main function
main()
