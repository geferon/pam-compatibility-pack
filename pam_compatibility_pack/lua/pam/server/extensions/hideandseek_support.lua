PAM_EXTENSION.name = "hideandseek_support"
PAM_EXTENSION.enabled = true

function PAM_EXTENSION:CanEnable()
	if engine.ActiveGamemode() ~= "hideandseek" then return false end
end

function PAM_EXTENSION:OnInitialize()
	-- Fafy2801/light-hns
	local maxRounds = PAM.extension_handler.RunReturningEvent("GetRoundLimit")
	if maxRounds then
		GAMEMODE.CVars.MaxRounds:SetInt(maxRounds)
	end

	hook.Add("HASVotemapStart", "PAM_Autostart_HAS", function()
		PAM.Start()
		return true
	end)


	-- Notify PAM that the round has ended
	hook.Add("HASRoundEnded", "PAM_RoundEnded", function()
		PAM.EndRound()
	end)
end

function PAM_EXTENSION:HasRoundLimitExtensionSupport()
	return true
end

function PAM_EXTENSION:RoundLimitExtensionSupport(newRound, percentage)
	SetGlobalInt("RoundNumber", newRound)
	GAMEMODE.RoundCount = newRound
	GAMEMODE:RoundTimer(2)
end