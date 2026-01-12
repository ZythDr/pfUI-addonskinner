pfUI.addonskinner:RegisterSkin("Postal", function()
-- place main code below
local penv = pfUI:GetEnvironment()
local HookAddonOrVariable, StripTextures, SkinButton, SkinCheckbox, CreateBackdrop, CreateBackdropShadow =
penv.HookAddonOrVariable, penv.StripTextures, penv.SkinButton, penv.SkinCheckbox, penv.CreateBackdrop, penv.CreateBackdropShadow
local function SkinPostalAttachments()
  local function safeExec(fn) pcall(fn) end
  for i = 1, 200 do
    local btn = _G["PostalAttachment" .. i]
    if not btn then break end

    if not btn._pfSkinned then
      StripTextures(btn, true)
      for _, r in ipairs({btn:GetRegions()}) do if r and r.SetTexture then r:Hide() end end
      SkinButton(btn)
      safeExec(function() btn.backdrop:SetFrameLevel(btn:GetFrameLevel() - 1) end)

      -- skin the button and let pfUI crop its icon region
      local icon = btn:GetNormalTexture()
      SkinButton(btn, nil, nil, nil, icon)
      safeExec(function() btn.backdrop:SetFrameLevel(btn:GetFrameLevel() - 1) end)

      -- ensure Postal's calls to SetNormalTexture get cropped by pfUI
      local origSetNormal = btn.SetNormalTexture
      btn.SetNormalTexture = function(self, tex)
        if origSetNormal then origSetNormal(self, tex) end
        local iconRegion = self:GetNormalTexture()
        if iconRegion and iconRegion.SetTexCoord then
          safeExec(function() pfUI.api.HandleIcon(self, iconRegion) end)
          -- enforce a slightly larger crop to hide baked-in borders (attempted, safe)
          safeExec(function() iconRegion:SetTexCoord(.08, .92, .08, .92) end)
          safeExec(function() iconRegion:SetPoint("TOPLEFT", self, "TOPLEFT", 3, -3) end)
          safeExec(function() iconRegion:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -3, 3) end)
        end
      end

      -- if a texture already exists (Postal may have set it earlier), force the override to run now
      do
        local cur = btn:GetNormalTexture()
        if cur and cur.GetTexture then
          local t = cur:GetTexture()
          if t and btn.SetNormalTexture then
            btn:SetNormalTexture(t)
          end
        end
      end

      -- style the stack count FontString (bottom-right number)
      do
        local count = _G[btn:GetName() .. 'Count']
        if count and count.SetFont then
          count:SetFont(pfUI.font_default, 11, "THICKOUTLINE")
          count:SetTextColor(1,1,1)
        end
      end

      btn._pfSkinned = true
    end

    local tex
    if btn.bag and btn.slot then tex = select(1, GetContainerItemInfo(btn.bag, btn.slot)) end
    local nt = btn:GetNormalTexture()
    if not tex and nt and nt.GetTexture then tex = nt:GetTexture() end

    if tex and nt then
      -- apply the texture to the normal region and let pfUI's HandleIcon crop it
      safeExec(function() nt:SetTexture(tex) end)
      safeExec(function() pfUI.api.HandleIcon(btn, nt) end)
      safeExec(function() nt:Hide() end)
    elseif nt then
      safeExec(function() nt:Hide() end)
      safeExec(function() nt:SetTexture(nil) end)
    end
  end

  StripTextures(SendMailPackageButton, true)
  if SendMailPackageButton.backdrop then SendMailPackageButton.backdrop:Hide() end
end

HookAddonOrVariable("Postal", function()
  SkinButton(PostalInboxReturnSelected)
  SkinButton(PostalInboxOpenSelected)
  SkinButton(PostalInboxReturnAllButton)
  SkinButton(PostalInboxOpenAllButton)
  SkinButton(PostalMailButton)

  pcall(function()
    StripTextures(SendMailPackageButton, true)
    SkinButton(SendMailPackageButton, nil, nil, nil, SendMailPackageButton:GetNormalTexture(), true)
    if SendMailPackageButton.backdrop then SendMailPackageButton.backdrop:Hide() end
    for _, r in ipairs({SendMailPackageButton:GetRegions()}) do if r and r.SetTexture then r:Hide() end end
  end)

  for i = 1, 16 do
    local cb = _G["PostalBoxItem" .. i .. "CB"]
    if not cb then break end
    SkinCheckbox(cb)
  end

  SkinPostalAttachments()
end)

StripTextures(PostalSubjectEditBox, false, "BACKGROUND")
CreateBackdrop(PostalSubjectEditBox)
SkinCheckbox(SendMailSendMoneyButton)
SkinCheckbox(SendMailCODButton)



-- Use Friz Quadrata for mail text and set color directly
local MAIL_FONT = "Fonts\\FRIZQT__.TTF"
InvoiceTextFontNormal:SetTextColor(1, 1, 1)
InvoiceTextFontNormal:SetFont(MAIL_FONT, 12)
InvoiceTextFontSmall:SetFont(MAIL_FONT, 11)
SendMailTitleText:SetFont(MAIL_FONT, 14)

-- Reapply fonts when the Mail frame opens (ensures pfUI or others don't overwrite)
local mailHook = CreateFrame("Frame")
mailHook:RegisterEvent("MAIL_SHOW")
mailHook:SetScript("OnEvent", function()
  InvoiceTextFontNormal:SetTextColor(1, 1, 1)
  InvoiceTextFontNormal:SetFont(MAIL_FONT, 12)
  InvoiceTextFontSmall:SetFont(MAIL_FONT, 11)
  SendMailTitleText:SetFont(MAIL_FONT, 14)
  MailTextFontNormal:SetFont(MAIL_FONT, 15); MailTextFontNormal:SetTextColor(1, 1, 1)
  ItemTextFontNormal:SetFont(MAIL_FONT, 15); ItemTextFontNormal:SetTextColor(1, 1, 1)

  pcall(function() SendStationeryBackgroundLeft:Hide() end)
  pcall(function() SendStationeryBackgroundRight:Hide() end)
  pcall(function() OpenStationeryBackgroundLeft:Hide() end)
  pcall(function() OpenStationeryBackgroundRight:Hide() end)
  pcall(function() StationeryBackgroundLeft:Hide() end)
  pcall(function() StationeryBackgroundRight:Hide() end)
  pcall(function() PostalHorizontalBarLeft:Hide() end)
  pcall(function() PostalHorizontalBarRight:Hide() end)
  pcall(function() StripTextures(SendMailScrollFrame, true) end)
  pcall(function() StripTextures(SendMailScrollChildFrame, true) end)
  pcall(function()
    for _, r in ipairs({SendMailScrollChildFrame:GetRegions()}) do if r and r.SetTexture then r:Hide() end end
    for _, c in ipairs({SendMailScrollChildFrame:GetChildren()}) do for _, r in ipairs({c:GetRegions()}) do if r and r.SetTexture then r:Hide() end end end
  end)

  pcall(function() CreateBackdrop(SendMailScrollFrame) end)
  pcall(function() CreateBackdropShadow(SendMailScrollFrame) end)
  pcall(function() SkinScrollbar(SendMailScrollFrameScrollBar) end)
  pcall(function() if SendMailScrollFrame.backdrop and SendMailScrollFrame.backdrop.SetFrameLevel then SendMailScrollFrame.backdrop:SetFrameLevel(SendMailScrollFrame:GetFrameLevel() - 1) end end)

  pcall(function()
    for _, r in ipairs({SendMailScrollChildFrame:GetRegions()}) do pcall(function() if r.SetFont then r:SetFont(MAIL_FONT, 12); r:SetTextColor(1,1,1) end end) end
  end)
end)

hooksecurefunc("SendMailFrame_Update", function()
  PostalHorizontalBarLeft:Hide()
  PostalHorizontalBarRight:Hide()
  SkinPostalAttachments()
end)

if _G.Postal and _G.Postal.SendMailFrame_Update then
  hooksecurefunc(_G.Postal, "SendMailFrame_Update", function()
    pcall(SkinPostalAttachments)
  end)
end

-- remove from pending list when applied
pfUI.addonskinner:UnregisterSkin("Postal")
end)