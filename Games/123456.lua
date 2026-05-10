getgenv().Notify("外部スクリプト読み込み成功")

print("外部スクリプト読み込み成功")

local module = {}

function module.init()
    print("初期化完了")
end

module.init()
