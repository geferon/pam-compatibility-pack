PAM_EXTENSION.name = "guesswho_support"
PAM_EXTENSION.enabled = true

function PAM_EXTENSION:CanEnable()
	if engine.ActiveGamemode() ~= "guesswho" then return false end
end

function PAM_EXTENSION:OnInitialize()
	-- lolleko/guesswho
	local maxRounds = PAM.extension_handler.RunReturningEvent("GetRoundLimit")
	if maxRounds then
		GetConVar("gw_maxrounds"):SetInt(maxRounds)
		GAMEMODE.GWRound.MaxRounds = maxRounds
	end

	-- Reconstructing MiRe's MapVote api, because guesswho supports only their addon natively
	MapVote = MapVote or {}
	MapVote.Start = function()
		PAM.Start()
	end
	MapVote.Cancel = function()
		PAM.Cancel()
	end


	-- Notify PAM that the round has ended
	hook.Add("GWOnRoundEnd", "PAM_RoundEnded", function()
		PAM.EndRound()
	end)
end

function PAM_EXTENSION:HasRoundLimitExtensionSupport()
	return true
end

function PAM_EXTENSION:RoundLimitExtensionSupport(newRound, percentage)
	SetGlobalInt("RoundNumber", newRound)
end