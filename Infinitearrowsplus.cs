using BepInEx;
using HarmonyLib;
using UnityEngine;

[BepInPlugin("infinitearrowsplus", "Infinite Arrows Plus", "1.0.0")]
public class InfiniteArrowsPlus : BaseUnityPlugin
{
    private void Awake()
    {
        Harmony.CreateAndPatchAll(typeof(ArrowPatch));
        Logger.LogInfo("Infinite Arrows Plus loaded.");
    }

    [HarmonyPatch(typeof(Inventory), nameof(Inventory.RemoveItem), new[] { typeof(ItemDrop.ItemData), typeof(int) })]
    public static class ArrowPatch
    {
        public static bool Prefix(ItemDrop.ItemData item, int amount)
        {
            if (item != null && item.m_shared.m_itemType == ItemDrop.ItemData.ItemType.Ammo)
            {
                // Prevent arrow removal
                return false;
            }

            return true; // Allow default behavior otherwise
        }
    }
}
