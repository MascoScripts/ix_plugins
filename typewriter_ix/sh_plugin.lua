PLUGIN.name = "Typewriters"
PLUGIN.author = "Masco"
PLUGIN.desc = "Typewriters with Google Docs implementation"

-------------------
-- Helix Include --
-------------------

ix.util.Include("sv_plugin.lua")

--------------------------
-- Helix Configurations --
--------------------------

ix.config.Add("MaxQuantityAmount", 10, "Maximum amount of documents that can be made at once.", nil, {
	data = {min = 0, max = 10},
	category = "Typewriters"
})