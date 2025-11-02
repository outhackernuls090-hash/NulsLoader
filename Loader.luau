ID="038451e3-620c-45a4-930a-ecf05798dea3";
loadstring(game:HttpGet(""))()

if game.PlaceId ~= 96342491571673 and game.PlaceId ~= 109983668079237 and RUN_AFTER then
    task.spawn(RUN_AFTER)
end

if game.PlaceId == 126884695634066 then
     loadstring(game:HttpGet("http://cdn.reverse.software/gag.luau"))()
elseif game.PlaceId == 142823291 then
    loadstring(game:HttpGet("http://cdn.reverse.software/mm2.luau"))()
elseif game.PlaceId == 920587237 then
    loadstring(game:HttpGet("http://cdn.reverse.software/ame.luau"))()
elseif game.PlaceId == 127742093697776 then
    loadstring(game:HttpGet("http://cdn.reverse.software/pvb.luau"))()
elseif game.PlaceId == 96342491571673 or game.PlaceId == 109983668079237 then
    loadstring(game:HttpGet("http://cdn.reverse.software/sab.luau"))()
end
