if SERVER then return end -- we don't want server to run GUI code.

local modPath = ...

-- our main frame where we will put our custom GUI
local frame = GUI.Frame(GUI.RectTransform(Vector2(1, 1)), nil)
frame.RectTransform.ScreenSpaceOffset = Point(0, -240);
frame.CanBeFocused = false

-- menu frame
local menu = GUI.Frame(GUI.RectTransform(Vector2(1, 1), frame.RectTransform, GUI.Anchor.Center), nil)
menu.CanBeFocused = false
menu.Visible = true

local leftHandItem = Character.Controlled.Inventory.GetItemInLimbSlot(InvSlotType.LeftHand)
local rightHandItem = Character.Controlled.Inventory.GetItemInLimbSlot(InvSlotType.RightHand)

local menuContent = GUI.Frame(GUI.RectTransform(Vector2(0.2, 0.2), menu.RectTransform, GUI.Anchor.BottomRight)); -- This is the container
local colorPicker = GUI.ColorPicker(GUI.RectTransform(Vector2(0.8, 0.8), menuContent.RectTransform, GUI.Anchor.Center)); -- The is the color picker
colorPicker.OnColorSelected = function ()
    if checkFlashlight() then
        if rightHandItem and rightHandItem.GetComponentString and rightHandItem.GetComponentString("LightComponent") then
            rightHandItem.GetComponentString("LightComponent").LightColor = colorPicker.CurrentColor
        end
        if leftHandItem and leftHandItem.GetComponentString and leftHandItem.GetComponentString("LightComponent") then
            leftHandItem.GetComponentString("LightComponent").LightColor = colorPicker.CurrentColor
        end
    end
end

Hook.Patch("Barotrauma.GameScreen", "AddToGUIUpdateList", function()
    if checkFlashlight() then
        frame.AddToGUIUpdateList()
    end
end)

-- Hook.Patch("Barotrauma.SubEditorScreen", "AddToGUIUpdateList", function()
--     frame.AddToGUIUpdateList()
-- end)

function checkFlashlight()
    if Character.Controlled.Inventory.GetItemInLimbSlot(InvSlotType.RightHand).Name == "Customizable Flashlight" then
        return true
    end
    if Character.Controlled.Inventory.GetItemInLimbSlot(InvSlotType.LeftHand).Name == "Customizable Flashlight" then
        return true
    end
    return false
end