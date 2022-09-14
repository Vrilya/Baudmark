local KeyHeld;

function BaudMark_OnLoad(self)
	self:RegisterEvent("PLAYER_TARGET_CHANGED");

	BINDING_HEADER_BaudMark = "Baud Mark";
	BINDING_NAME_BaudMark = "Mark Targets(Hold)";

	local Button, Angle;
	for Index = 0, 8 do
		Button = CreateFrame("Button", "BaudMarkIconButton"..Index, self);
		Button:SetWidth(30);
		Button:SetHeight(30);
		Button:SetID(Index);
		Button.Texture = Button:CreateTexture(Button:GetName().."NormalTexture", "ARTWORK");
		Button.Texture:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
		Button.Texture:SetAllPoints();
		SetRaidTargetIconTexture(Button.Texture, Index);
		Button:RegisterForClicks("LeftButtonUp","RightButtonUp");
		Button:SetScript("OnClick", BaudMarkButton_OnClick);
		Button:SetScript("OnEnter", BaudMarkButton_OnEnter);
		Button:SetScript("OnLeave", BaudMarkButton_OnLeave);
		if(Index==0)then
		  Button:SetPoint("CENTER");
		else
		  Angle = 360 / 8 * Index;
		  Button:SetPoint("CENTER", sin(Angle) * 50, cos(Angle) * 50);
		end
	end

	DEFAULT_CHAT_FRAME:AddMessage("Baud Mark: AddOn Loaded.  Version "..GetAddOnMetadata("BaudMark","Version")..".");
end


function BaudMarkCanMark()
	if IsInRaid()
	and not (UnitIsGroupLeader("player"))
	and not (UnitIsGroupAssistant("player")) 
	then 
		UIErrorsFrame:AddMessage("You don't have permission to mark targets.", 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
		return false; 
	else
		return true; 
	end
end


function BaudMark_HotkeyPressed(keystate)
	KeyHeld = (keystate=="down")
	if KeyHeld
	and BaudMarkCanMark(true)
	then
		BaudMarkShowIcons();
	else
		BaudMarkFrame:Hide();
	end
end


function BaudMark_OnEvent(self, event)
	if(event=="PLAYER_TARGET_CHANGED")then
		if KeyHeld then
			BaudMarkShowIcons();
		end
	end
end


function BaudMarkShowIcons()
	if not UnitExists("target")or UnitIsDead("target")then
		return;
	end
	local X, Y = GetCursorPosition();
	local Scale = UIParent:GetEffectiveScale();
	BaudMarkFrame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", X / Scale, Y / Scale);
	BaudMarkFrame:Show();
end


function BaudMarkButton_OnEnter(self)
	self.Texture:ClearAllPoints();
	self.Texture:SetPoint("TOPLEFT", -5, 5);
	self.Texture:SetPoint("BOTTOMRIGHT", 5, -5);
end


function BaudMarkButton_OnLeave(self)
	self.Texture:SetAllPoints();
end


function BaudMarkButton_OnClick(self)
	PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
	SetRaidTargetIcon("target", (arg1~="RightButton")and self:GetID()or 0);
	BaudMarkFrame:Hide();
end