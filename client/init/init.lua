
AddEventHandler('onClientResourceStart', function(resource)
	if resource ~= GetCurrentResourceName() then
		return
	end
	print('Starting script initialization')

	-- Some people modify A7-voice and mess up the resource Kvp, which means that if someone
	-- joins another server that has A7-voice, it will error out, this will catch and fix the kvp.
	local success = pcall(function()
		local micClicksKvp = GetResourceKvpString('A7-voice_enableMicClicks')
		if not micClicksKvp then
			SetResourceKvp('A7-voice_enableMicClicks', "true")
		else
			if micClicksKvp ~= 'true' and micClicksKvp ~= 'false' then
				error('Invalid Kvp, throwing error for automatic fix')
			end
			micClicks = micClicksKvp
		end
	end)

	if not success then
		logger.warn('Failed to load resource Kvp, likely was inappropriately modified by another server, resetting the Kvp.')
		SetResourceKvp('A7-voice_enableMicClicks', "true")
		micClicks = 'true'
	end
	sendUIMessage({
		uiEnabled = GetConvarInt("voice_enableUi", 1) == 1,
		voiceModes = json.encode(Cfg.voiceModes),
		voiceMode = mode - 1
	})

	local radioChannel = LocalPlayer.state.radioChannel or 0
	local callChannel = LocalPlayer.state.callChannel or 0

	-- Reinitialize channels if they're set.
	if radioChannel ~= 0 then
		setRadioChannel(radioChannel)
	end

	if callChannel ~= 0 then
		setCallChannel(callChannel)
	end

	print('Script initialization finished.')
end)