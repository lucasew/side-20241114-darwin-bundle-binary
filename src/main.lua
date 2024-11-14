function main()
    for i = 1, #assets do
        local curret = assets[i]
        local converted_path = string.gsub(curret.path, "assets", OUT_DIR)
        dtw.write_file(converted_path, curret.content)
    end
    local executable_name = OUT_DIR .. "/main.o"
    os.execute("chmod +x " .. executable_name)
    os.execute(executable_name)
end
