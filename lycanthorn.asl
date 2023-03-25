state("Lycanthorn2")
{
    bool isLoading: 0x1135C20;
    int gameaction: 0x112949C;
    string5 nextlevel: 0x881528, 0x0;
}

startup
{
    vars.Log = (Action<object>)((output) => print("[Lycanthorn II ASL] " + output));

    var Maps = new Dictionary<string, string>() {
        {"Overworld", "MAP02"},
        {"Canyon", "MAP03"},
        {"Lighthouse", "MAP04"},
        {"Observatory", "MAP05"},
        {"Pyramid", "MAP06"},
        {"Volcano", "MAP07"},
        {"Swamp", "MAP08"},
        {"Fish", "MAP09"},
        {"Tundra", "MAP10"},
        {"Nosferatu's Castle", "MAP11"},
        {"Intro Castle", "MAP13"},
    };

    vars.TransitionSplits = new Dictionary<string, Tuple<string, string>>();
    var AddEntrySplit = (Action<String>) ((mapName) => {
        var splitName = "split_enter_" + mapName
            .Replace("'", "")
            .Replace(" ", "_")
            .ToLower();
        settings.Add(splitName, true, mapName, "split_enter");
        vars.TransitionSplits.Add(splitName, new Tuple<String, String>(Maps["Overworld"], Maps[mapName]));
    });
    var AddExitSplit = (Action<String>) ((mapName) => {
        var splitName = "split_exit_" + mapName.ToLower();
        settings.Add(splitName, true, mapName, "split_exit");
        vars.TransitionSplits.Add(splitName, new Tuple<String, String>(Maps[mapName], Maps["Overworld"]));
    });

    // Settings
    settings.Add("split_exit", true, "Split on leave area");
    settings.Add("split_enter", true, "Split on enter area");
    foreach (var map in Maps.Keys)
    {
        if (map == "Overworld") {
            continue;
        }
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
    if (current.nextlevel != old.nextlevel) {
        foreach(var entry in vars.TransitionSplits) {
            var mFrom = entry.Value.Item1;
            var mTo = entry.Value.Item2;
            if (old.nextlevel == mFrom && current.nextlevel == mTo) {
                return settings[entry.Key];
            }
        }
    }
}

isLoading
{
    return current.isLoading;
}