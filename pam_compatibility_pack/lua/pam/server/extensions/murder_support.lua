PAM_EXTENSION.name = "murder_support"
PAM_EXTENSION.enabled = true

function PAM_EXTENSION:Initialize()
	if engine.ActiveGamemode() ~= "murder" then return false end
end

function PAM_EXTENSION:OnInitialize()
	-- mechanicalmind/murder
	-- Reconstructing MiRe's MapVote api, because murder supports only their addon natively
	MapVote = MapVote or {}
	MapVote.Start = function()
		PAM.Start()
	end
	MapVote.Cancel = function()
		PAM.Cancel()
	end
	
	local maxRounds = PAM.extension_handler.RunReturningEvent("GetRoundLimit")
	if maxRounds then
		GAMEMODE.RoundLimit:SetInt(maxRounds)
	end

	-- Notify PAM that the round has ended
	hook.Add("OnEndRound", "PAM_RoundEnded", function()
		PAM.EndRound()
	end)
end

function PAM_EXTENSION:HasRoundLimitExtensionSupport()
	return true
end

function PAM_EXTENSION:RoundLimitExtensionSupport(newRound, percentage)
	SetGlobalInt("RoundNumber", newRound)
	GAMEMODE:SetRound(2)
end