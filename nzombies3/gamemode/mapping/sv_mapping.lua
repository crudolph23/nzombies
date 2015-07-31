//

function nz.Mapping.Functions.ZedSpawn(pos, link)

	local ent = ents.Create("zed_spawns") 
	pos.z = pos.z - ent:OBBMaxs().z
	ent:SetPos( pos )
	ent:Spawn()
	ent.link = link
	//For the link displayer
	if link != nil then
		ent:SetLink(link)	
	end
end

function nz.Mapping.Functions.PlayerSpawn(pos)

	local ent = ents.Create("player_spawns") 
	pos.z = pos.z - ent:OBBMaxs().z
	ent:SetPos( pos )
	ent:Spawn()
	
end

function nz.Mapping.Functions.EasterEgg(pos,ang,model)
	local egg = ents.Create( "easter_egg" )
	egg:SetModel( model )
	egg:SetPos( pos )
	egg:SetAngles( ang )
	egg:Spawn()

	local phys = egg:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
end

function nz.Mapping.Functions.WallBuy(pos, gun, price, angle)

	if weapons.Get(gun) != nil then
	
		local ent = ents.Create("wall_buys") 
		ent:SetAngles(angle)
		pos.z = pos.z - ent:OBBMaxs().z
		ent:SetWeapon(gun, price)
		ent:SetPos( pos )
		ent:Spawn()
		ent:PhysicsInit( SOLID_VPHYSICS )
		
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end
		
	else
		print("SKIPPED: " .. gun .. ". Are you sure you have it installed?")
	end
	
end

function nz.Mapping.Functions.RBoxHandler(pos, guns, angle, keep)

	if not guns then
		print("No guns were supplied for the RBoxHandler ... did you use a save where it isn't defined?")
	return end
	PrintTable(guns)

	if keep then
		local ent = ents.FindByClass("random_box_handler")[1]
		ent:ClearWeapons()
	else
		if !IsValid( ent ) then ent = ents.Create("random_box_handler") end
		ent:SetAngles(angle)
		ent:SetPos( pos )
		ent:Spawn()
		ent:PhysicsInit( SOLID_VPHYSICS )
		ent:SetColor( Color(0, 255, 255) )
		
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end
		//Just to be sure
		ent:ClearWeapons()
	end
		
	for k,v in pairs(guns) do
		if weapons.Get(v) != nil then
			ent:AddWeapon(v)
		else
			print("SKIPPED: " .. v .. ". Are you sure you have it installed?")
		end
	end
	
end

function nz.Mapping.Functions.PlayerHandler(pos, angle, startwep, startpoints, numweps, eeurl, keep)

	local ent
	
	if keep then
		ent = ents.FindByClass("player_handler")[1]
	else
		for k,v in pairs(ents.FindByClass("player_handler")) do
			//WE CAN ONLY HAVE 1!
			v:Remove()
		end
		ent = ents.Create("player_handler")
		ent:SetAngles(angle)
		ent:SetPos( pos )
		ent:Spawn()
		ent:PhysicsInit( SOLID_VPHYSICS )
		ent:SetColor( Color(0, 255, 255) )
		
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end
	end
		
	ent:SetData(startpoints, startwep, numweps, eeurl)
	
end

function nz.Mapping.Functions.PropBuy(pos,ang,model,flags)
	local prop = ents.Create( "prop_buys" )
	prop:SetModel( model )
	prop:SetPos( pos )
	prop:SetAngles( ang )
	prop:Spawn()
	prop:PhysicsInit( SOLID_VPHYSICS )
	
	//REMINDER APPY FLAGS
	if flags != nil then
		nz.Doors.Functions.CreateLink( prop, flags )
	end
	
	local phys = prop:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
end

function nz.Mapping.Functions.Electric(pos,ang,model)
	//THERE CAN ONLY BE ONE TRUE HERO
	local prevs = ents.FindByClass("button_elec")
	if prevs[1] != nil then
		prevs[1]:Remove()
	end
	
	local ent = ents.Create( "button_elec" )
	ent:SetPos( pos )
	ent:SetAngles( ang )
	ent:Spawn()
	ent:PhysicsInit( SOLID_VPHYSICS )
		
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
end

function nz.Mapping.Functions.BlockSpawn(pos,ang,model)
	local block = ents.Create( "wall_block" )
	block:SetModel( model )
	block:SetPos( pos )
	block:SetAngles( ang )
	block:Spawn()
	block:PhysicsInit( SOLID_VPHYSICS )
	
	local phys = block:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
end

function nz.Mapping.Functions.BoxSpawn(pos,ang)
	local box = ents.Create( "random_box_spawns" )
	box:SetPos( pos )
	box:SetAngles( ang )
	box:Spawn()
	box:PhysicsInit( SOLID_VPHYSICS )
end

function nz.Mapping.Functions.PerkMachine(pos, ang, id)
	local perkData = nz.Perks.Functions.Get(id)
	
	local perk = ents.Create("perk_machine")
	perk:SetPerkID(id)
	perk:TurnOff()
	perk:SetPos(pos)
	perk:SetAngles(ang)
	perk:Spawn()
	perk:Activate()
	perk:PhysicsInit( SOLID_VPHYSICS )
	
	local phys = perk:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
end

function nz.Mapping.Functions.BreakEntry(pos,ang)
	local entry = ents.Create( "breakable_entry" )
	entry:SetPos( pos )
	entry:SetAngles( ang )
	entry:Spawn()
	entry:PhysicsInit( SOLID_VPHYSICS )
	
	local phys = entry:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
end



//Physgun Hooks
function nz.Mapping.Functions.OnPhysgunPickup( ply, ent )
	local class = ent:GetClass()
	if ( class == "prop_buys" or class == "wall_block" or class == "breakable_entry" ) then 
		//Ghost the entity so we can put them in walls.
		local phys = ent:GetPhysicsObject()
		phys:EnableCollisions(false)
	end
	
end

function nz.Mapping.Functions.OnPhysgunDrop( ply, ent )
	local class = ent:GetClass()
	if ( class == "prop_buys" or class == "wall_block" or class == "breakable_entry" ) then 
		//Unghost the entity so we can put them in walls.
		local phys = ent:GetPhysicsObject()
		phys:EnableCollisions(true)
	end
	
end

hook.Add( "PhysgunPickup", "nz.OnPhysPick", nz.Mapping.Functions.OnPhysgunPickup )
hook.Add( "PhysgunDrop", "nz.OnDrop", nz.Mapping.Functions.OnPhysgunDrop )