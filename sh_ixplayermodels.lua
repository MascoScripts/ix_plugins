PLUGIN.name = "IX Player Models Fix"
PLUGIN.author = "Masco"
PLUGIN.description = "Fixes models in IX to make Player Models."

local IXPlayerModels = {
    "path/to/your.mdl",
    "path/to/your.mdl"
}

for _, model in ipairs(IXPlayerModels) do
    print("Setting " .. model .. " to a playermodel.")
    ix.anim.SetModelClass(model, "player")
end