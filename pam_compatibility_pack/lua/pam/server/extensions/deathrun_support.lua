PAM_EXTENSION.name = "deathrun_support"
PAM_EXTENSION.enabled = true

function PAM_EXTENSION:Initialize()
	if engine.ActiveGamemode() ~= "deathrun" then return false end
end

local round_limit
function PAM_EXTENSION:OnInitialize()
	local maxRounds = PAM.extension_handler.RunReturningEvent("GetRoundLimit")

	-- Arizard/deathrun
	if DR and MV and MV.BeginMapVote then
		round_limit = GetConVar("deathrun_round_limit")
		
		if maxRounds then
			round_limit:SetInt(maxRounds)
		end

		-- remove original functionality by cutting off the api
		concommand.Remove("mapvote_begin_mapvote")
		concommand.Remove("mapvote_list_maps")
		concommand.Remove("mapvote_nominate_map")
		concommand.Remove("mapvote_rtv")
		concommand.Remove("mapvote_update_mapvote")
		concommand.Remove("mapvote_vote")
		hook.Remove("PlayerSay", "CheckRTVChat")

		cvars.AddChangeCallback("mapvote_rtv_ratio", function()
			print("[PAM] This convar is no longer used")
		end)

		-- start PAM instead of MV
		MV.BeginMapVote = PAM.Start


		-- Notify PAM that the round has ended
		hook.Add("OnRoundSet", "PAM_RoundEnded", function(round_id)
			if round_id == ROUND_OVER then
				PAM.EndRound()
			end
		end)
		return
	end

	-- Mr-Gash/GMod-Deathrun
	if RTV and RTV.Start and ROUND_ENDING then
		if maxRounds then
			SetGlobalInt("dr_rounds_left", maxRounds)
		end

		-- remove original functionality by cutting off the api
		hook.Remove("PlayerSay", "RTV Chat Commands")
		concommand.Remove("rtv_vote")
		concommand.Remove("rtv_start")
		RTV.Start = PAM.Start


		-- Notify PAM that the round has ended
		hook.Add("OnRoundSet", "PAM_RoundEnded", function(round, ...)
			if round == ROUND_ENDING then
				PAM.EndRound()
			end
		end)
		return
	end
end


function PAM_EXTENSION:HasRoundLimitExtensionSupport()
	return true
end

function PAM_EXTENSION:RoundLimitExtensionSupport(newRound, percentage)
	if DR and MV then
		-- We cannot modify the local counter of rounds so instead we're going to change the convar to account for the remaining rounds
		round_limit:SetInt(round_limit:GetInt() * (1 + percentage))
		
		-- If next round wasn't scheduled, we start it
		if (ROUND:GetCurrent() == ROUND_OVER and ROUND:GetTimer() <= 0) then
			ROUND:RoundSwitch(ROUND_PREP)
		end
	end
	
	if RTV and RTV.Start and ROUND_ENDING then
		SetGlobalInt("dr_rounds_left", rounds)
	end
end