state("Lycanthorn2")
{
    bool isLoading: 0x1135C20;
    int gameaction: 0x112949C;
    // 0x112BA90 + 0x940
    int levelnum: 0x112C3D0;
}

startup
{
    // vars.Log = (Action<object>)((output) => print("[Lycanthorn II ASL] " + output));

    vars.OVERWORLD = 2;
    vars.ENDING = 12;
    var Maps = new Dictionary<string, int>() {
        {"Canyon", 3},
        {"Lighthouse", 4},
        {"Observatory", 5},
        {"Pyramid", 6},
        {"Volcano", 7},
        {"Swamp", 8},
        {"Fish", 9},
        {"Tundra", 10},
        {"Nosferatu's Castle", 11},
        {"Intro Castle", 13},
    };
    vars.TransitionSplits = new Dictionary<string, Tuple<int, int>>();

    var AddEntrySplit = (Action<String>) ((mapName) => {
        var splitName = "split_enter_" + mapName
            .Replace("'", "")
            .Replace(" ", "_")
            .ToLower();
        settings.Add(splitName, true, mapName, "split_enter");
        vars.TransitionSplits.Add(splitName, new Tuple<int, int>(vars.OVERWORLD, Maps[mapName]));
    });
    var AddExitSplit = (Action<String>) ((mapName) => {
        var splitName = "split_exit_" + mapName.ToLower();
        settings.Add(splitName, true, mapName, "split_exit");
        vars.TransitionSplits.Add(splitName, new Tuple<int, int>(Maps[mapName], vars.OVERWORLD));
    });

    settings.Add("split_exit", true, "Split on leave area");
    settings.Add("split_enter", true, "Split on enter area");
    foreach (var map in Maps.Keys)
    {
        if (map != "Intro Castle") {
            AddEntrySplit(map);
        }
        if (map != "Nosferatu's Castle") {
            AddExitSplit(map);
        }
    }
}

start
{
    return current.gameaction != old.gameaction && current.gameaction == 2;
}

split
{
    if (current.levelnum != old.levelnum) {
        // Final split - always enabled
        if (current.levelnum == 12) {
            return true;
        }

        // Other transition splits
        foreach(var entry in vars.TransitionSplits) {
            var mFrom = entry.Value.Item1;
            var mTo = entry.Value.Item2;
            if (old.levelnum == mFrom && current.levelnum == mTo) {
                return settings[entry.Key];
            }
        }
    }
}

isLoading
{
    return current.isLoading;
}