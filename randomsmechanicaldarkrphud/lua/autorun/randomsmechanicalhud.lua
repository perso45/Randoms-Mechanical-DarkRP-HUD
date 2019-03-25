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

	local client = LocalPlayer()
	local healthicon = Material("icon16/heart.png")
	local armoricon = Material("icon16/shield.png")

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
		draw.RoundedBox(10, 2, ScrH()-150, 302+10, ScrH(), Color(174,198,207,125))

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

		local health = client:Health()
			draw.RoundedBox(10,108,ScrH()-95,200+4,30+4,Color(169,169,169,200))
			draw.RoundedBox(10,110,ScrH()-93,health*2,30,Color(255,105,97))
			draw.SimpleText(health.."%","RandomsHUDFont",112,ScrH()-87,Color(255,255,255),0,0)
			surface.SetMaterial(healthicon)
			surface.SetDrawColor(255,255,255,255)
			surface.DrawTexturedRect(290,ScrH()-85,14,14)

		local armor = client:Armor()
			draw.RoundedBox(10,108,ScrH()-60,200+4,30+4,Color(169,169,169,200))
			draw.RoundedBox(10,110,ScrH()-58,armor*2,30,Color(150,111,214))
			draw.SimpleText(armor.."%","RandomsHUDFont",112,ScrH()-52,Color(255,255,255),0,0)
			surface.SetMaterial(armoricon)
			surface.SetDrawColor(255,255,255,255)
			surface.DrawTexturedRect(290,ScrH()-50,14,14)

		draw.RoundedBox(12, 6, ScrH()-141, 300+4, 44, Color(169,169,169,200))

		local name = client:Name()
		draw.SimpleText(name, "UserHUDFont", 8, ScrH()-138, Color(255,255,255), 0, 0)

		draw.SimpleText(team.GetName(client:Team()), "UserHUDFont", 8, ScrH()-117, Color( 255, 255, 255, 255 ), 0, 0)

		draw.SimpleText( DarkRP.formatMoney(client:getDarkRPVar("money")), "UserHUDFont", 300, ScrH()-117, Color(119,221,119), 2, 2)

		draw.RoundedBox(12,108,ScrH()-25,200+4,22,Color(169,169,169))

			if (client:GetActiveWeapon():GetPrintName()!=nil) then
				draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "AmmoHUDFont", 112, ScrH()-20, Color(255,255,255,255),0,0)
			end

			if (client:GetActiveWeapon():Clip1() != -1) then
				draw.SimpleText("Ammo: "..client:GetActiveWeapon():Clip1().."/"..client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType()),"AmmoHUDFont",300+2,ScrH()-20,Color(255,255,255),2,2)
			else
				draw.SimpleText("Ammo: "..client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType()), "AmmoHUDFont",300+2 , ScrH()-20, Color( 255, 255, 255, 255 ), 2, 2)
			end
		end)
end)