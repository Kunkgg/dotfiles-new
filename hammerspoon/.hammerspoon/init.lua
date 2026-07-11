-- 绑定 Command + Return 切换 WezTerm
hs.hotkey.bind({"cmd"}, "return", function()
    local appName = "WezTerm"
    local app = hs.application.get(appName)

    if app then
        if app:isFrontmost() then
            -- 如果 WezTerm 已经在最前面，则隐藏它
            app:hide()
        else
            -- 如果 WezTerm 在后台，则激活并推到最前面
            app:activate()
        end
    else
        -- 如果 WezTerm 没有运行，则启动它
        hs.application.launchOrFocus(appName)
    end
end)

