PAM_EXTENSION.name = "zombiesurvival_support"
PAM_EXTENSION.enabled = true

function PAM_EXTENSION:Initialize()
	if engine.ActiveGamemode() ~= "zombiesurvival" then return false end
end

function PAM_EXTENSION:OnInitialize()
	-- jetboom/zombiesurvival
	hook.Add("LoadNextMap", "PAM_Autostart_ZombieSurvival", function()
		PAM.Start()
		return true
	end)


	hook.Add("PostEndRound", "PAM_RoundEnded", function()
		PAM.EndRound()
	end)
end
