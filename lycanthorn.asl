state("Lycanthorn2")
{
    bool isLoading: 0x1135C20;
    // GA_NEWGAME = 2;
    int gameaction: 0x112949C;
}

start
{
    return current.gameaction != old.gameaction && current.gameaction == 2;
}

isLoading
{
    return current.isLoading;
}