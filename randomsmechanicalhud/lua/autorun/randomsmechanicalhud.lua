/////////////////////////////
//Author:ThatRandomPerson45//
//		Version:0.1		   //
//		 Mech HUD		   //
/////////////////////////////
if !CLIENT then return end
hook.Add( "InitPostEntity", "HUDStart", function()
	surface.CreateFont("RandomsHUDFont", {
		font="Courier",
		size=20,
		weight=500,
		blursize=0,
		scanlines=0,
		antialias=true,
		underline=false,
		italic=false,
		strikeout=false,
		symbol=false,
		rotary=false,
		shadow=false,
		additive=false,
		outline=false,
	})
	surface.CreateFont("AmmoHUDFont", {
		font="Courier",
		size=14,
		weight=500,
		blursize=0,
		scanlines=0,
		antialias=true,
		underline=false,
		italic=false,
		strikeout=false,
		symbol=false,
		rotary=false,
		shadow=false,
		additive=false,
		outline=false,
	})
	surface.CreateFont("UserHUDFont", {
		font="Courier",
		size=18,
		weight=1000,
		blursize=0,
		scanlines=0,
		antialias=true,
		underline=false,
		italic=false,
		strikeout=false,
		symbol=false,
		rotary=false,
		shadow=false,
		additive=false,
		outline=false,
	})
	//Local Constants
	local client = LocalPlayer()
	local healthicon = Material("icon16/heart.png")
	local armoricon = Material("icon16/shield.png")
	local license = Material("icon16/accept.png")
	local nolicense = Material("icon16/cancel.png")
	//Hides Default HUD
	local hide = {
		["CHudHealth"]=true,
		["CHudBattery"]=true,
		["CHudAmmo"]=true,
		["CHudSecondaryAmmo"]=true,
		["DarkRP_Hungermod"]=true
	}
	local function HUDShouldDraw(name)
		if (hide[name]) then
			return false;
		end
	end
	hook.Add("HUDShouldDraw", "HUDHider", HUDShouldDraw)

	hook.Add("HUDPaint", "DrawMyHud", function()
		draw.RoundedBox(10, 2, ScrH()-160, 302+10, ScrH(), Color(174,198,207,125))
		//Playermodel Display
		draw.RoundedBox(10,6,ScrH()-95,100,ScrH(),Color(169,169,169,190))

		if (!IsValid(client)) then return; end

		local model=client:GetModel();

		if (!PlayerModel||!ispanel( PlayerModel)) then
			PlayerModel=vgui.Create("DModelPanel");
			PlayerModel:SetPos(20,ScrH()-40-100);
			PlayerModel:SetModel(model);
			PlayerModel.__Model=model;
			PlayerModel:SetSize(75,150)
			PlayerModel:SetCamPos(Vector(16,0,65));
			PlayerModel:SetLookAt(Vector(0,0,65));
			PlayerModel:SetAnimated(false);
			PlayerModel:SetAnimationEnabled(false);
			PlayerModel.bAnimated=false;
			PlayerModel:ParentToHUD();
		end

		if (client:GetModel() != PlayerModel.__Model) then
			PlayerModel:SetModel(model);
			PlayerModel.__Model = model;
		end
		//Health Display
		local health = client:Health()
		local maxhealth = client:GetMaxHealth()\
		//Health Logic
		local redhealth = (maxhealth-health)*(255/maxhealth)
		local greenhealth = health*(255/maxhealth)
		local bluehealth = 0
			draw.RoundedBox(10,108,ScrH()-95,200+4,30+4,Color(169,169,169,200))
			if health<=100 then
			draw.RoundedBox(10,110,ScrH()-93,health*2,30,Color(redhealth,greenhealth,bluehealth))
			else
			draw.RoundedBox(10,110,ScrH()-93,200,30,Color(redhealth,greenhealth,bluehealth))
			end
			draw.SimpleText(health.."%","RandomsHUDFont",112,ScrH()-87,Color(255,255,255),0,0)
			surface.SetMaterial(healthicon)
			surface.SetDrawColor(255,255,255)
			surface.DrawTexturedRect(290,ScrH()-85,14,14)
		//Armor Display
		local armor = client:Armor()
		//Armor Logic
		local maxarmor = 100
		local redarmor = (maxarmor-armor)*(255/maxarmor)
		local greenarmor = health*(255/maxarmor)
		local bluearmor = 0
			draw.RoundedBox(10,108,ScrH()-60,200+4,30+4,Color(169,169,169,200))
			draw.RoundedBox(10,110,ScrH()-58,armor*2,30,Color(redarmor,greenarmor,bluearmor))
			draw.SimpleText(armor.."%","RandomsHUDFont",112,ScrH()-52,Color(255,255,255),0,0)
			surface.SetMaterial(armoricon)
			surface.SetDrawColor(255,255,255)
			surface.DrawTexturedRect(290,ScrH()-50,14,14)

		draw.RoundedBox(12, 6, ScrH()-141, 300+4, 44, Color(169,169,169,200))
		//Name Display
		local name = client:Name()
		draw.SimpleText(name, "UserHUDFont", 8, ScrH()-138, Color(255,255,255), 0, 0)
		//Job Display
		draw.SimpleText(team.GetName(client:Team()), "UserHUDFont", 8, ScrH()-117, Color(255,255,255), 0, 0)
		//Money Display
		if client:getDarkRPVar("money")>0 then
		draw.SimpleText( DarkRP.formatMoney(client:getDarkRPVar("money")), "UserHUDFont", 300, ScrH()-117, Color(119,221,119), 2, 2)
		else
		draw.SimpleText( DarkRP.formatMoney(client:getDarkRPVar("money")), "UserHUDFont", 300, ScrH()-117, Color(255,0,0), 2, 2)
		end
		//Rank Display
		draw.SimpleText(string.upper(client:GetUserGroup()), "UserHUDFont", 300, ScrH()-138, Color(255,255,255), 2, 2)
		//License Display
		if client:getDarkRPVar("HasGunlicense") == true then
		draw.SimpleText("Has License", "UserHUDFont", 25, ScrH()-157, Color(255,255,255), 0, 0)
		surface.SetMaterial(license)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(8, ScrH()-155, 14, 14)
		else
		draw.SimpleText("No License", "UserHUDFont", 25, ScrH()-157, Color(255,255,255), 0, 0)
		surface.SetMaterial(nolicense)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(8, ScrH()-155, 14, 14)
		end
		//Weapon Display
		draw.RoundedBox(12,108,ScrH()-25,200+4,22,Color(169,169,169))

			if (client:GetActiveWeapon():GetPrintName()~=nil) then
				draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "AmmoHUDFont", 112, ScrH()-20, Color(255,255,255),0,0)
			end

			if (client:GetActiveWeapon():Clip1() != -1) then
				draw.SimpleText("Ammo: "..client:GetActiveWeapon():Clip1().."/"..client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType()),"AmmoHUDFont",300+2,ScrH()-20,Color(255,255,255),2,2)
			else
				draw.SimpleText("Ammo: "..client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType()), "AmmoHUDFont",300+2 , ScrH()-20, Color(255,255,255), 2, 2)
			end
		end)
end)