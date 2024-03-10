local Utils = require("utils")

Utils.Init("seekerted", "LessRandomEnemies", "1.0.0")

local SpawnFailRate = 0.85

local function BP_EnemyCoreLogic_C__OnSpawned(Param_BP_EnemyCoreLogic_C, Param_bIsBeginPlay)
	local BP_EnemyCoreLogic_C = Param_BP_EnemyCoreLogic_C:get()

	-- Checks if the enemy was created by a raid spawner. If so, there's a {SpawnFailRate} chance it will be destroyed.
	if BP_EnemyCoreLogic_C.OwnerSpawner:IsA("/Script/MadeInAbyss.MIASpawnRaidEnemy") then
		if math.random() < SpawnFailRate then
			BP_EnemyCoreLogic_C:K2_DestroyActor()
			Utils.Log("Nerfed enemy raid (%.1f%%)", SpawnFailRate * 100)
		end
	end
end

-- Called every time the Game State is initialized, but only push through if in the Abyss, as that's the only time
-- the function is available (or just to be sure)
RegisterInitGameStatePostHook(function(Param_AGameStateBase)
	if Param_AGameStateBase:get():GetClass():GetFName():ToString() ~= "BP_AbyssGameMode_C" then return end

    Utils.RegisterHookOnce("/Game/MadeInAbyss/Core/Characters/Enemy/BP_EnemyCoreLogic.BP_EnemyCoreLogic_C:OnSpawned",
			BP_EnemyCoreLogic_C__OnSpawned)
end)