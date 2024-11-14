local assets = {}

local assets_files = dtw.list_files_recursively("assets", true)
for i = 1, #assets_files do
    local current       = assets_files[i]
    local data          = {
        path = current,
        content = dtw.load_file(current)
    }
    assets[#assets + 1] = data
end


darwin.add_c_file("LuaDoTheWorld/src/one.c", true, function(import, path)
    -- to make the luacembe not be imported twice
    if import == "../dependencies/dependency.LuaCEmbed.h" then
        return false
    end
    return true
end)


darwin.embed_global("assets", assets)
darwin.load_lualib_from_c("load_luaDoTheWorld", "dtw")

local concat_path = true
local src_files = dtw.list_files_recursively("src", concat_path)
for i = 1, #src_files do
    local current = src_files[i]
    darwin.add_lua_code("-- file: " .. current .. "\n")
    darwin.add_lua_file(current)
end
darwin.add_lua_code("main()") -- these its required to start main
darwin.generate_c_executable_output({ output_name = "bundle.c" })
os.execute("gcc bundle.c -o bundle.o")
