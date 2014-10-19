--[[ 
********************************************************************************
	Project:		GTW RPG [2.0.4]
	Owner:			GTW Games 	
	Location:		Sweden
	Developers:		MrBrutus
	Copyrights:		See: "license.txt"
	
	Website:		http://code.albonius.com
	Version:		2.0.4
	Status:			Stable release
********************************************************************************
]]--

players = {}
colorUpdater = {}
function onResourceStart(resource)
  	for id, plr in ipairs(getElementsByType("player")) do
		if players[plr] then
			createBlipAttachedTo(plr, 0, 2, players[plr][1], players[plr][2], players[plr][3])
		elseif getPlayerTeam(plr) then
			local r,g,b = getTeamColor(getPlayerTeam(plr))
			createBlipAttachedTo(plr, 0, 2, r, g, b)
			players[plr] = { tonumber(r), tonumber(g), tonumber(b) }
		end
		colorUpdater[plr] = setTimer(updateBlipColor,200,0,plr)
	end
end

function onPlayerSpawn(spawnpoint)
	if(players[source]) then
		createBlipAttachedTo(source, 0, 2, players[source][1], players[source][2], players[source][3])
	elseif getPlayerTeam(source) then
		local r,g,b = getTeamColor(getPlayerTeam(source))
		createBlipAttachedTo(source, 0, 2, r, g, b)
		players[source] = { tonumber(r), tonumber(g), tonumber(b) }
	end
	if not isTimer(colorUpdater[source]) then
		colorUpdater[source] = setTimer(updateBlipColor,200,0,source)
	end
end

function onPlayerQuit()
	destroyBlipsAttachedTo(source)
	if isTimer(colorUpdater[source]) then
		killTimer(colorUpdater[source])
	end	
end

function onPlayerWasted(totalammo, killer, killerweapon)
	destroyBlipsAttachedTo(source)
end

function updateBlipColor(plr)
	local r,g,b = getTeamColor(getPlayerTeam(plr))
	if players[plr] and ( r ~= players[plr][1] or g ~= players[plr][2] or b ~= players[plr][3] ) then
		destroyBlipsAttachedTo(plr)
		r,g,b = getTeamColor(getPlayerTeam(plr))
		players[plr] = { tonumber(r), tonumber(g), tonumber(b) }
  		createBlipAttachedTo(plr, 0, 2, players[plr][1], players[plr][2], players[plr][3])
	end
	if not hasPlayerBlip(plr) then
		r,g,b = getTeamColor(getPlayerTeam(plr))
		players[plr] = { tonumber(r), tonumber(g), tonumber(b) }
  		createBlipAttachedTo(plr, 0, 2, players[plr][1], players[plr][2], players[plr][3])
	end
end

addEventHandler("onResourceStart", resourceRoot, onResourceStart)
addEventHandler("onPlayerSpawn", root, onPlayerSpawn)
addEventHandler("onPlayerQuit", root, onPlayerQuit)
addEventHandler("onPlayerWasted", root, onPlayerWasted)

function destroyBlipsAttachedTo(plr)
	local attached = getAttachedElements(plr)
	if(attached) then
		for k,element in ipairs(attached) do
			if element and getElementType(element) == "blip" then
				destroyElement(element)
			end
		end
	end
end

function hasPlayerBlip(plr)
	local attached = getAttachedElements(plr)
	if(attached) then
		for k,element in ipairs(attached) do
			if element and getElementType(element) == "blip" then
				return true
			end
		end
	end
	return false
end